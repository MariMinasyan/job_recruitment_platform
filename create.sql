-- =====================================================================
-- Job Recruitment Database - create.sql
-- =====================================================================

DROP DATABASE IF EXISTS job_recruitment;
CREATE DATABASE job_recruitment;
USE job_recruitment;

-- ---------------------------------------------------------------------
-- 1. Company
-- ---------------------------------------------------------------------
CREATE TABLE Company (
    company_id       INT AUTO_INCREMENT,
    company_name     VARCHAR(100) NOT NULL,
    industry         VARCHAR(60),
    website          VARCHAR(150),
    region           VARCHAR(60),
    city             VARCHAR(60),
    street_name      VARCHAR(100),
    street_number    VARCHAR(10),
    apartment_number VARCHAR(10),
    CONSTRAINT pk_company PRIMARY KEY (company_id),
    CONSTRAINT uq_company_name UNIQUE (company_name)
);

-- ---------------------------------------------------------------------
-- 2. Recruiter
-- ---------------------------------------------------------------------
CREATE TABLE Recruiter (
    recruiter_id INT AUTO_INCREMENT,
    first_name   VARCHAR(50)  NOT NULL,
    last_name    VARCHAR(50)  NOT NULL,
    email        VARCHAR(100) NOT NULL,
    company_id   INT          NOT NULL,
    CONSTRAINT pk_recruiter PRIMARY KEY (recruiter_id),
    CONSTRAINT uq_recruiter_email UNIQUE (email),
    CONSTRAINT fk_recruiter_company FOREIGN KEY (company_id)
        REFERENCES Company (company_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- ---------------------------------------------------------------------
-- 3. Job
-- ---------------------------------------------------------------------
CREATE TABLE Job (
    job_id          INT AUTO_INCREMENT,
    title           VARCHAR(100) NOT NULL,
    description     TEXT,
    salary_min      DECIMAL(10,2),
    salary_max      DECIMAL(10,2),
    employment_type ENUM('Full-time','Part-time','Contract','Internship')
                    NOT NULL DEFAULT 'Full-time',
    date_posted     DATE NOT NULL,
    status          ENUM('Draft','Open','Closed') NOT NULL DEFAULT 'Open',
    recruiter_id    INT NOT NULL,
    CONSTRAINT pk_job PRIMARY KEY (job_id),
    CONSTRAINT fk_job_recruiter FOREIGN KEY (recruiter_id)
        REFERENCES Recruiter (recruiter_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT chk_job_salary CHECK (
        salary_min >= 0
        AND salary_max >= 0
        AND salary_max >= salary_min
    )
);

-- ---------------------------------------------------------------------
-- 4. Applicant
-- ---------------------------------------------------------------------
CREATE TABLE Applicant (
    applicant_id     INT AUTO_INCREMENT,
    first_name       VARCHAR(50)  NOT NULL,
    last_name        VARCHAR(50)  NOT NULL,
    email            VARCHAR(100) NOT NULL,
    degree           VARCHAR(60),
    field            VARCHAR(80),
    experience_years TINYINT UNSIGNED NOT NULL DEFAULT 0,
    CONSTRAINT pk_applicant PRIMARY KEY (applicant_id),
    CONSTRAINT uq_applicant_email UNIQUE (email),
    CONSTRAINT chk_applicant_exp CHECK (experience_years <= 60)
);

-- ---------------------------------------------------------------------
-- 5. Applicant_Phone
-- ---------------------------------------------------------------------
CREATE TABLE Applicant_Phone (
    applicant_id INT         NOT NULL,
    phone        VARCHAR(20) NOT NULL,
    CONSTRAINT pk_applicant_phone PRIMARY KEY (applicant_id, phone),
    CONSTRAINT fk_phone_applicant FOREIGN KEY (applicant_id)
        REFERENCES Applicant (applicant_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- ---------------------------------------------------------------------
-- 6. Skill
-- ---------------------------------------------------------------------
CREATE TABLE Skill (
    skill_id   INT AUTO_INCREMENT,
    skill_name VARCHAR(60) NOT NULL,
    CONSTRAINT pk_skill PRIMARY KEY (skill_id),
    CONSTRAINT uq_skill_name UNIQUE (skill_name)
);

-- ---------------------------------------------------------------------
-- 7. Applicant_Skill
-- ---------------------------------------------------------------------
CREATE TABLE Applicant_Skill (
    applicant_id INT NOT NULL,
    skill_id     INT NOT NULL,
    skill_level  ENUM('Beginner','Intermediate','Advanced','Expert')
                 NOT NULL DEFAULT 'Beginner',
    CONSTRAINT pk_applicant_skill PRIMARY KEY (applicant_id, skill_id),
    CONSTRAINT fk_as_applicant FOREIGN KEY (applicant_id)
        REFERENCES Applicant (applicant_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_as_skill FOREIGN KEY (skill_id)
        REFERENCES Skill (skill_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- ---------------------------------------------------------------------
-- 8. Job_Skill
-- ---------------------------------------------------------------------
CREATE TABLE Job_Skill (
    job_id         INT NOT NULL,
    skill_id       INT NOT NULL,
    required_level ENUM('Beginner','Intermediate','Advanced','Expert')
                   NOT NULL DEFAULT 'Beginner',
    CONSTRAINT pk_job_skill PRIMARY KEY (job_id, skill_id),
    CONSTRAINT fk_js_job FOREIGN KEY (job_id)
        REFERENCES Job (job_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_js_skill FOREIGN KEY (skill_id)
        REFERENCES Skill (skill_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- ---------------------------------------------------------------------
-- 9. Application
-- ---------------------------------------------------------------------
CREATE TABLE Application (
    application_id   INT AUTO_INCREMENT,
    application_date DATE NOT NULL,
    status           ENUM('Submitted','Under Review','Shortlisted',
                          'Rejected','Accepted')
                     NOT NULL DEFAULT 'Submitted',
    cover_letter     TEXT,
    applicant_id     INT NOT NULL,
    job_id           INT NOT NULL,
    CONSTRAINT pk_application PRIMARY KEY (application_id),
    CONSTRAINT uq_application_applicant_job UNIQUE (applicant_id, job_id),
    CONSTRAINT fk_app_applicant FOREIGN KEY (applicant_id)
        REFERENCES Applicant (applicant_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_app_job FOREIGN KEY (job_id)
        REFERENCES Job (job_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- ---------------------------------------------------------------------
-- 10. Interview
-- ---------------------------------------------------------------------
CREATE TABLE Interview (
    interview_id   INT AUTO_INCREMENT,
    interview_date DATETIME NOT NULL,
    interview_type ENUM('Phone','Video','On-site','Technical')
                   NOT NULL DEFAULT 'Video',
    result         ENUM('Pending','Passed','Failed')
                   NOT NULL DEFAULT 'Pending',
    application_id INT NOT NULL,
    recruiter_id   INT NOT NULL,
    CONSTRAINT pk_interview PRIMARY KEY (interview_id),
    CONSTRAINT fk_int_application FOREIGN KEY (application_id)
        REFERENCES Application (application_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_int_recruiter FOREIGN KEY (recruiter_id)
        REFERENCES Recruiter (recruiter_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);
