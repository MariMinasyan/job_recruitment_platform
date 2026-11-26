-- =====================================================================
-- Job Recruitment Database - queries.sql (DML)
-- =====================================================================
USE job_recruitment;

-- Q1. Open jobs with recruiter and company info
SELECT j.job_id, j.title, j.employment_type, j.salary_min, j.salary_max,
       CONCAT(r.first_name, ' ', r.last_name) AS recruiter,
       c.company_name, c.city
FROM Job j
JOIN Recruiter r ON r.recruiter_id = j.recruiter_id
JOIN Company   c ON c.company_id   = r.company_id
WHERE j.status = 'Open'
ORDER BY c.company_name, j.title;

-- Q2. Jobs with 3 or more applications
SELECT j.job_id, j.title, COUNT(a.application_id) AS total_applications
FROM Job j
JOIN Application a ON a.job_id = j.job_id
GROUP BY j.job_id, j.title
HAVING COUNT(a.application_id) >= 3
ORDER BY total_applications DESC;

-- Q3. LEFT JOIN: jobs that received no applications
SELECT j.job_id, j.title, j.status
FROM Job j
LEFT JOIN Application a ON a.job_id = j.job_id
WHERE a.application_id IS NULL;

-- Q4. Every company with its number of recruiters (incl. none)
SELECT c.company_name, COUNT(r.recruiter_id) AS recruiter_count
FROM Recruiter r
RIGHT JOIN Company c ON c.company_id = r.company_id
GROUP BY c.company_id, c.company_name
ORDER BY recruiter_count DESC, c.company_name;

-- Q5. Applicants who passed at least one interview
SELECT a.applicant_id, a.first_name, a.last_name
FROM Applicant a
WHERE EXISTS (
    SELECT 1
    FROM Application ap
    JOIN Interview i ON i.application_id = ap.application_id
    WHERE ap.applicant_id = a.applicant_id
      AND i.result = 'Passed'
);

-- Q6. Applicants who never applied to any job
SELECT a.applicant_id, a.first_name, a.last_name, a.email
FROM Applicant a
WHERE NOT EXISTS (
    SELECT 1 FROM Application ap WHERE a.applicant_id = ap.applicant_id
);

-- Q7. Applicants who applied for Contract or Internship jobs
SELECT a.first_name, a.last_name, a.degree, a.field
FROM Applicant a
WHERE a.applicant_id IN (
    SELECT ap.applicant_id
    FROM Application ap
    WHERE ap.job_id IN (SELECT job_id FROM Job
                       WHERE employment_type IN ('Contract', 'Internship'))
);
Select *
from job_skill
where job_id =2;

-- Q8. Relational division with NOT EXISTS: applicants who satisfy ALL
--     required skills (at the required level) of job 2 (Data Analyst).
--     ENUM + 0 converts the level to its ordinal index.
SELECT ap.applicant_id, ap.first_name, ap.last_name
FROM Applicant ap
WHERE NOT EXISTS (
    SELECT 1
    FROM Job_Skill js
    WHERE js.job_id = 2
      AND NOT EXISTS (
          SELECT 1
          FROM Applicant_Skill s
          WHERE s.applicant_id = ap.applicant_id
            AND s.skill_id     = js.skill_id
            AND s.skill_level + 0 >= js.required_level + 0
      )
);

-- Q9. Average salary range by industry and type
SELECT c.industry, j.employment_type,
       COUNT(*)                                   AS jobs,
       ROUND(AVG(j.salary_min), 2)                AS avg_min,
       ROUND(AVG(j.salary_max), 2)                AS avg_max
FROM Job j
JOIN Recruiter r ON r.recruiter_id = j.recruiter_id
JOIN Company   c ON c.company_id   = r.company_id
GROUP BY c.industry, j.employment_type
ORDER BY avg_max DESC;

-- Q10. FULL OUTER JOIN emulation (LEFT UNION RIGHT): skills vs. applicants,
--      showing skills nobody has and applicants with no skills.
SELECT s.skill_name, ap.first_name, ap.last_name
FROM Skill s
LEFT JOIN Applicant_Skill x ON x.skill_id = s.skill_id
LEFT JOIN Applicant ap      ON ap.applicant_id = x.applicant_id
WHERE ap.applicant_id IS NULL
UNION
SELECT s.skill_name, ap.first_name, ap.last_name
FROM Applicant ap
LEFT JOIN Applicant_Skill x ON x.applicant_id = ap.applicant_id
LEFT JOIN Skill s           ON s.skill_id = x.skill_id
WHERE s.skill_id IS NULL;

-- Q11. Subquery in HAVING + function: applicants with above-average
--      experience, with their best-fit open job (skill match %)
SELECT ap.applicant_id, fn_full_name(ap.applicant_id) AS applicant,
       ap.experience_years,
       (SELECT j.title 
       FROM Job j
        WHERE j.status = 'Open'
        ORDER BY skill_match_pct(ap.applicant_id, j.job_id) DESC, j.job_id
        LIMIT 1) AS best_fit_job
FROM Applicant ap
WHERE ap.experience_years > (SELECT AVG(experience_years) FROM Applicant)
ORDER BY ap.experience_years DESC;

-- Q12. Self-join: pairs of recruiters working for the same company
SELECT c.company_name,
       CONCAT(r1.first_name, ' ', r1.last_name) AS recruiter_1,
       CONCAT(r2.first_name, ' ', r2.last_name) AS recruiter_2
FROM Recruiter r1
JOIN Recruiter r2 ON r1.company_id = r2.company_id
                 AND r1.recruiter_id < r2.recruiter_id
JOIN Company c ON c.company_id = r1.company_id;

-- Q13. Pending interviews with all context (multi-table JOIN)
SELECT i.interview_date, i.interview_type,
       CONCAT(ap.first_name, ' ', ap.last_name) AS applicant,
       j.title AS job,
       CONCAT(r.first_name, ' ', r.last_name)  AS interviewer
FROM Interview i
JOIN Application a ON a.application_id = i.application_id
JOIN Applicant  ap ON ap.applicant_id  = a.applicant_id
JOIN Job        j  ON j.job_id         = a.job_id
JOIN Recruiter  r  ON r.recruiter_id   = i.recruiter_id
WHERE i.result = 'Pending'
ORDER BY i.interview_date;
