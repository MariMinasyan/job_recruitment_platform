-- =====================================================================
-- Job Recruitment Database - objects.sql
-- =====================================================================
USE job_recruitment;

-- ---------------------------------------------------------------------
-- INDEXES
-- (PKs, UNIQUE keys and FK columns are already indexed by InnoDB.)
-- ---------------------------------------------------------------------
-- Job board listing: filter by status, newest first
CREATE INDEX idx_job_status_date        ON Job (status, date_posted);
-- Search applicants by name
CREATE INDEX idx_applicant_name         ON Applicant (last_name, first_name);
-- Applications by status over time
CREATE INDEX idx_application_status_date ON Application (status, application_date);
-- Interview scheduling / calendars
CREATE INDEX idx_interview_date         ON Interview (interview_date, result);

-- Check usage, e.g.
SELECT * 
FROM Job 
WHERE status = 'Open' 
ORDER BY date_posted DESC

-- ---------------------------------------------------------------------
-- FUNCTIONS
-- ---------------------------------------------------------------------

-- F1. Full name of an applicant
DROP FUNCTION IF EXISTS fn_full_name
DELIMITER //
CREATE FUNCTION fn_full_name(p_applicant_id INT)
RETURNS VARCHAR(101)
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE v_name VARCHAR(101);
    SELECT CONCAT(first_name, ' ', last_name) INTO v_name
    FROM Applicant 
    WHERE applicant_id = p_applicant_id;
    RETURN v_name;
END;

//             
DELIMITER ;

-- F2. Number of applications received by a job
DROP FUNCTION IF EXISTS application_count 
DELIMITER //
CREATE FUNCTION application_count(p_job_id INT)
RETURNS INT
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE v_cnt INT;
    SELECT COUNT(*) INTO v_cnt 
    FROM Application 
    WHERE job_id = p_job_id;
    RETURN v_cnt;
END;

//             
DELIMITER ;

-- F3. Percentage of a job's required skills that an applicant meets
DROP FUNCTION IF EXISTS skill_match_pct
DELIMITER //
CREATE FUNCTION skill_match_pct(p_applicant_id INT, p_job_id INT)
RETURNS DECIMAL(5,2)
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE v_total   INT;
    DECLARE v_matched INT;

    SELECT COUNT(*) INTO v_total 
    FROM Job_Skill 
    WHERE job_id = p_job_id;
    IF v_total = 0 THEN
        RETURN 100.00;
    END IF;

    SELECT COUNT(*) INTO v_matched
    FROM Job_Skill js
    JOIN Applicant_Skill s
      ON s.skill_id = js.skill_id
     AND s.applicant_id = p_applicant_id
     AND s.skill_level + 0 >= js.required_level + 0
    WHERE js.job_id = p_job_id;

    RETURN ROUND(100 * v_matched / v_total, 2);
END;

//             
DELIMITER ;

-- F4. Seniority band from years of experience
DROP FUNCTION IF EXISTS experience_band
DELIMITER //
CREATE FUNCTION experience_band(p_years INT)
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    RETURN CASE
        WHEN p_years < 2  THEN 'Junior'
        WHEN p_years < 5  THEN 'Mid'
        WHEN p_years < 8  THEN 'Senior'
        ELSE 'Expert'
    END;
END;

//
DELIMITER ;

-- Examples:
SELECT fn_full_name(1), application_count(10), skill_match_pct(3, 2), experience_band(5);

-- ---------------------------------------------------------------------
-- VIEWS
-- ---------------------------------------------------------------------
-- V1. Open jobs with company and recruiter details
CREATE OR REPLACE VIEW vw_open_jobs AS
SELECT j.job_id, j.title, j.employment_type, j.salary_min, j.salary_max,
       j.date_posted, c.company_name, c.industry, c.city,
       CONCAT(r.first_name, ' ', r.last_name) AS recruiter
FROM Job j
JOIN Recruiter r ON r.recruiter_id = j.recruiter_id
JOIN Company   c ON c.company_id   = r.company_id
WHERE j.status = 'Open';

-- V2. Number of jobs per company
CREATE OR REPLACE VIEW vw_company_jobs AS
SELECT c.company_id, c.company_name, COUNT(j.job_id) AS total_jobs
FROM Company c
LEFT JOIN Recruiter r ON r.company_id   = c.company_id
LEFT JOIN Job j       ON j.recruiter_id = r.recruiter_id
GROUP BY c.company_id, c.company_name;

-- V3. Per-job statistics (includes jobs with no applications)
CREATE OR REPLACE VIEW vw_job_statistics AS
SELECT j.job_id, j.title, j.status AS job_status,
       COUNT(a.application_id)                         AS applications,
       COALESCE(SUM(a.status = 'Accepted'), 0)         AS accepted,
       COALESCE(SUM(a.status = 'Rejected'), 0)         AS rejected,
       ROUND(AVG(ap.experience_years), 1)              AS avg_applicant_experience
FROM Job j
LEFT JOIN Application a ON a.job_id = j.job_id
LEFT JOIN Applicant ap  ON ap.applicant_id = a.applicant_id
GROUP BY j.job_id, j.title, j.status;

-- Examples:
SELECT * 
FROM vw_open_jobs;

