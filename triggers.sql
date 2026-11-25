-- =====================================================================
-- Job Recruitment Database - triggers.sql 
-- =====================================================================
USE job_recruitment;

DELIMITER $$

-- T1. Applications are accepted only for Open jobs
DROP TRIGGER IF EXISTS trg_application_before_insert $$
CREATE TRIGGER trg_application_before_insert
BEFORE INSERT ON Application
FOR EACH ROW
BEGIN
    DECLARE v_status VARCHAR(10);
    SELECT status INTO v_status 
    FROM Job 
    WHERE job_id = NEW.job_id;
    IF v_status <> 'Open' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Applications are accepted only for open jobs';
    END IF;
END $$

-- T2. The interviewer must work for the company that owns the job
DROP TRIGGER IF EXISTS trg_interview_before_insert $$
CREATE TRIGGER trg_interview_before_insert
BEFORE INSERT ON Interview
FOR EACH ROW
BEGIN
    DECLARE v_interviewer_company INT;
    DECLARE v_job_company INT;

    SELECT company_id INTO v_interviewer_company
    FROM Recruiter WHERE recruiter_id = NEW.recruiter_id;

    SELECT r.company_id INTO v_job_company
    FROM Application a
    JOIN Job j       ON j.job_id = a.job_id
    JOIN Recruiter r ON r.recruiter_id = j.recruiter_id
    WHERE a.application_id = NEW.application_id;

    IF v_interviewer_company <> v_job_company THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Interviewer must belong to the hiring company';
    END IF;
END $$

-- T3. First interview moves a Submitted application to Under Review
DROP TRIGGER IF EXISTS trg_interview_after_insert $$
CREATE TRIGGER trg_interview_after_insert
AFTER INSERT ON Interview
FOR EACH ROW
BEGIN
    UPDATE Application
    SET status = 'Under Review'
    WHERE application_id = NEW.application_id
      AND status = 'Submitted';
END $$

-- T4. A failed interview rejects the application (unless already accepted)
DROP TRIGGER IF EXISTS trg_interview_after_update $$
CREATE TRIGGER trg_interview_after_update
AFTER UPDATE ON Interview
FOR EACH ROW
BEGIN
    IF NEW.result = 'Failed' AND OLD.result <> 'Failed' THEN
        UPDATE Application
        SET status = 'Rejected'
        WHERE application_id = NEW.application_id
          AND status <> 'Accepted';
    END IF;
END $$

