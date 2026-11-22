-- =====================================================================
-- Job Recruitment Database - insert.sql
-- =====================================================================
USE job_recruitment;

-- 1. Company
INSERT INTO Company (company_name, industry, website, region, city, street_name, street_number, apartment_number) VALUES
('TechNova Armenia',      'Software',   'https://www.technova.am',   'Yerevan',      'Yerevan', 'Tigran Mets Ave', '12',  '5'),
('Ararat Finance Group',  'Finance',    'https://www.araratfin.am',  'Yerevan',      'Yerevan', 'Amiryan St',      '4',   NULL),
('Sevan Health Systems',  'Healthcare', 'https://www.sevanhealth.am','Gegharkunik', 'Sevan',   'Nairyan St',      '21',  '2'),
('Gyumri Logistics',      'Logistics',  'https://www.gyumrilog.am',  'Shirak',       'Gyumri',  'Ghukasyan St',    '7',   NULL),
('Dilijan Learning Labs', 'Education',  'https://www.dilijanlabs.am','Tavush',       'Dilijan', 'Shahumyan St',    '33',  '1'),
('Kapan Mining Analytics','Mining',     'https://www.kapanmining.am','Syunik',       'Kapan',   'Azatamartikner St','9',  NULL);

-- 2. Recruiter
INSERT INTO Recruiter (first_name, last_name, email, company_id) VALUES
('Anna',   'Simonyan',   'anna.simonyan@technova.am',     1),
('Levon',  'Danielyan',  'levon.danielyan@technova.am',   1),
('Mane',   'Karapetyan', 'mane.karapetyan@araratfin.am',  2),
('Suren',  'Aslanyan',   'suren.aslanyan@araratfin.am',   2),
('Tatev',  'Hovhannisyan','tatev.h@sevanhealth.am',       3),
('Artur',  'Poghosyan',  'artur.poghosyan@gyumrilog.am',  4),
('Gayane', 'Mnatsakanyan','gayane.m@gyumrilog.am',        4),
('Hayk',   'Zakaryan',   'hayk.zakaryan@dilijanlabs.am',  5);

-- 3. Job
INSERT INTO Job (title, description, salary_min, salary_max, employment_type, date_posted, status, recruiter_id) VALUES
('Backend Developer',             'Build and maintain REST services in Java.',            900.00, 1800.00, 'Full-time', '2026-08-25', 'Open',   1),
('Data Analyst',                  'Analyze product data and build dashboards.',           700.00, 1300.00, 'Full-time', '2026-08-28', 'Open',   1),
('Frontend Developer',            'Develop responsive web interfaces.',                   800.00, 1500.00, 'Full-time', '2026-09-01', 'Open',   2),
('Software Engineering Intern',   'Summer-to-fall internship for students.',              150.00,  300.00, 'Internship','2026-09-03', 'Open',   2),
('Credit Risk Analyst',           'Model and monitor credit risk portfolios.',           1000.00, 1700.00, 'Full-time', '2026-09-05', 'Open',   3),
('Database Administrator',        'Administer and tune MySQL/PostgreSQL clusters.',      1100.00, 2000.00, 'Full-time', '2026-09-06', 'Open',   4),
('Health Data Engineer',          'Build data pipelines for clinical data.',             1000.00, 1900.00, 'Full-time', '2026-09-08', 'Open',   5),
('Logistics Coordinator',         'Coordinate regional freight operations.',              500.00,  900.00, 'Full-time', '2026-08-01', 'Closed', 6),
('Part-time SQL Tutor',           'Teach introductory SQL to undergraduates.',            300.00,  500.00, 'Part-time', '2026-09-15', 'Open',   8),
('Machine Learning Engineer',     'Design and deploy ML models (6-month contract).',     1500.00, 2800.00, 'Contract',  '2026-09-18', 'Open',   1),
('QA Engineer',                   'Manual and automated testing.',                        700.00, 1200.00, 'Full-time', '2026-10-02', 'Draft',  7),
('Business Intelligence Developer','Develop BI models and reports.',                      900.00, 1600.00, 'Full-time', '2026-10-05', 'Open',   3);

-- 4. Applicant
INSERT INTO Applicant (first_name, last_name, email, degree, field, experience_years) VALUES
('Ani',    'Hakobyan',    'ani.hakobyan@mail.am',    'MSc',         'Computer Science',       5),
('Davit',  'Sargsyan',    'davit.sargsyan@mail.am',  'BSc',         'Software Engineering',   2),
('Mariam', 'Petrosyan',   'mariam.petrosyan@mail.am','MSc',         'Data Science',           4),
('Narek',  'Grigoryan',   'narek.grigoryan@mail.am', 'BSc',         'Statistics',             1),
('Lilit',  'Avetisyan',   'lilit.avetisyan@mail.am', 'BSc',         'Computer Science',       3),
('Tigran', 'Mkrtchyan',   'tigran.mkrtchyan@mail.am','BSc',         'Information Systems',    0),
('Sona',   'Khachatryan', 'sona.khachatryan@mail.am','BSc',         'Computer Science',       0),
('Armen',  'Vardanyan',   'armen.vardanyan@mail.am', 'BA',          'Economics',              1),
('Eliza',  'Melkonyan',   'eliza.melkonyan@mail.am', 'MSc',         'Finance',                6),
('Gor',    'Harutyunyan', 'gor.harutyunyan@mail.am', 'BSc',         'Applied Mathematics',    2),
('Hasmik', 'Gevorgyan',   'hasmik.gevorgyan@mail.am','PhD',         'Computer Science',       9),
('Vahe',   'Manukyan',    'vahe.manukyan@mail.am',   'MSc',         'Biomedical Engineering', 3),
('Karen',  'Ghazaryan',   'karen.ghazaryan@mail.am', 'BA',          'Logistics',              7),
('Nare',   'Stepanyan',   'nare.stepanyan@mail.am',  'BSc',         'Business Administration',4),
('Arsen',  'Baghdasaryan','arsen.b@mail.am',         'High School', NULL,                     0);

-- 5. Applicant_Phone (multivalued attribute)
INSERT INTO Applicant_Phone (applicant_id, phone) VALUES
(1,'+37491100001'),(1,'+37499100001'),
(2,'+37491100002'),
(3,'+37493100003'),(3,'+37477100003'),
(4,'+37494100004'),
(5,'+37495100005'),
(6,'+37496100006'),
(7,'+37498100007'),
(8,'+37455100008'),
(9,'+37441100009'),(9,'+37491100099'),
(10,'+37443100010'),
(11,'+37444100011'),
(12,'+37446100012'),
(13,'+37447100013'),
(14,'+37433100014'),
(15,'+37477100015');

-- 6. Skill (skill 12 'Rust' is held by nobody)
INSERT INTO Skill (skill_name) VALUES
('SQL'),('Python'),('R'),('JavaScript'),('Java'),('Machine Learning'),
('Statistics'),('Data Visualization'),('Project Management'),('Communication'),
('Docker'),('Rust');

-- 7. Applicant_Skill
INSERT INTO Applicant_Skill (applicant_id, skill_id, skill_level) VALUES
(1,1,'Expert'),(1,2,'Advanced'),(1,5,'Advanced'),(1,11,'Intermediate'),
(2,5,'Advanced'),(2,1,'Intermediate'),(2,11,'Beginner'),
(3,2,'Expert'),(3,3,'Advanced'),(3,6,'Advanced'),(3,7,'Advanced'),(3,1,'Advanced'),(3,8,'Advanced'),
(4,3,'Intermediate'),(4,7,'Advanced'),(4,1,'Intermediate'),(4,8,'Intermediate'),
(5,4,'Advanced'),(5,2,'Intermediate'),(5,10,'Advanced'),
(6,4,'Beginner'),(6,1,'Beginner'),
(7,2,'Intermediate'),(7,5,'Intermediate'),
(8,1,'Beginner'),(8,8,'Intermediate'),(8,10,'Advanced'),
(9,7,'Advanced'),(9,1,'Advanced'),(9,2,'Intermediate'),(9,10,'Expert'),
(10,2,'Intermediate'),(10,3,'Intermediate'),(10,7,'Intermediate'),
(11,1,'Expert'),(11,2,'Expert'),(11,6,'Expert'),(11,11,'Advanced'),(11,5,'Advanced'),
(12,2,'Advanced'),(12,7,'Intermediate'),(12,6,'Intermediate'),
(13,9,'Advanced'),(13,10,'Advanced'),
(14,9,'Intermediate'),(14,10,'Expert'),(14,8,'Beginner'),
(15,10,'Beginner');

-- 8. Job_Skill
INSERT INTO Job_Skill (job_id, skill_id, required_level) VALUES
(1,1,'Advanced'),(1,5,'Advanced'),(1,11,'Intermediate'),
(2,1,'Advanced'),(2,2,'Intermediate'),(2,8,'Advanced'),(2,7,'Intermediate'),
(3,4,'Advanced'),(3,10,'Intermediate'),
(4,5,'Beginner'),(4,1,'Beginner'),
(5,7,'Advanced'),(5,1,'Advanced'),(5,2,'Intermediate'),
(6,1,'Expert'),(6,11,'Intermediate'),
(7,2,'Advanced'),(7,1,'Advanced'),(7,6,'Intermediate'),
(8,9,'Advanced'),(8,10,'Advanced'),
(9,1,'Intermediate'),(9,10,'Advanced'),
(10,2,'Expert'),(10,6,'Advanced'),(10,7,'Advanced'),
(11,5,'Intermediate'),
(12,1,'Advanced'),(12,8,'Advanced');

-- 9. Application (job 8 is Closed: historical applications; jobs 11, 12 have none)
INSERT INTO Application (application_date, status, cover_letter, applicant_id, job_id) VALUES
('2026-09-02','Accepted',    'Five years of backend experience with Java and SQL.',        1, 1),
('2026-09-03','Rejected',    'Eager to grow as a backend engineer.',                       2, 1),
('2026-09-05','Shortlisted', 'Data science graduate passionate about analytics.',          3, 2),
('2026-09-06','Under Review','Statistics background with solid R and SQL.',                4, 2),
('2026-09-08','Accepted',    'Frontend developer with three years of JavaScript.',         5, 3),
('2026-09-09','Rejected',    'Fresh graduate looking for a first role.',                   6, 3),
('2026-09-10','Shortlisted', 'Looking for an internship to apply my CS studies.',          7, 4),
('2026-09-11','Submitted',   NULL,                                                         8, 4),
('2026-09-12','Shortlisted', 'Six years in finance with strong statistics.',               9, 5),
('2026-09-13','Rejected',    'Applied mathematics graduate interested in risk.',          10, 5),
('2026-09-14','Under Review','Interested in moving into database administration.',         1, 6),
('2026-09-15','Accepted',    'PhD with deep expertise in database internals.',            11, 6),
('2026-09-16','Shortlisted', 'Want to apply data science to healthcare.',                  3, 7),
('2026-09-17','Under Review','Biomedical engineer with Python skills.',                   12, 7),
('2026-08-20','Rejected',    'Seven years in logistics operations.',                      13, 8),
('2026-08-22','Accepted',    'Business graduate with project management experience.',     14, 8),
('2026-09-20','Accepted',    'Enjoy teaching SQL to beginners.',                           4, 9),
('2026-09-21','Submitted',   NULL,                                                         8, 9),
('2026-09-22','Shortlisted', 'Ready for a challenging ML contract.',                       2,10),
('2026-09-23','Accepted',    'Expert in Python and machine learning.',                     3,10),
('2026-09-24','Rejected',    'Finance professional exploring ML.',                         9,10),
('2026-09-25','Under Review','Second application to TechNova.',                            5, 1),
('2026-09-26','Submitted',   'Interested in analytics.',                                  11, 2),
('2026-09-27','Under Review','Biomedical background applying to finance.',                12, 5),
('2026-09-28','Rejected',    'Looking for an internship.',                                 6, 4),
('2026-10-01','Submitted',   'Senior engineer interested in ML.',                          1,10);

-- 10. Interview
INSERT INTO Interview (interview_date, interview_type, result, application_id, recruiter_id) VALUES
('2026-09-10 10:00:00','Phone',    'Passed', 1, 1),
('2026-09-15 14:00:00','Technical','Passed', 1, 2),
('2026-09-11 11:00:00','Phone',    'Failed', 2, 1),
('2026-09-18 15:00:00','Video',    'Passed', 3, 1),
('2026-09-20 10:30:00','Technical','Passed', 5, 2),
('2026-09-19 12:00:00','Video',    'Failed', 6, 2),
('2026-11-25 16:00:00','Video',    'Pending',7, 2),
('2026-10-05 09:30:00','On-site',  'Passed', 9, 3),
('2026-11-27 11:00:00','Video',    'Pending',9, 4),
('2026-09-25 13:00:00','Phone',    'Failed',10, 3),
('2026-09-30 10:00:00','Technical','Passed',12, 4),
('2026-10-08 14:00:00','On-site',  'Passed',12, 4),
('2026-10-02 12:00:00','Video',    'Passed',13, 5),
('2026-08-28 10:00:00','Phone',    'Passed',16, 7),
('2026-09-02 11:00:00','On-site',  'Passed',16, 6),
('2026-10-01 17:00:00','Video',    'Passed',17, 8),
('2026-10-03 10:00:00','Technical','Passed',20, 1),
('2026-10-09 15:00:00','Video',    'Passed',20, 2),
('2026-10-04 12:00:00','Phone',    'Failed',21, 1),
('2026-11-24 10:00:00','Technical','Pending',19, 2);
