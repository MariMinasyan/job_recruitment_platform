# Job Recruitment Database

A MySQL database for a job recruitment platform. It models companies, recruiters, jobs, applicants, skills, applications and interviews.

## Contents

| File | Purpose |
|------|---------|
| `create.sql` | Creates the database and tables |
| `insert.sql` | Sample data |
| `indices_funcions_views.sql` | Indexes, functions and views |
| `triggers.sql` | Triggers enforcing business rules |
| `queries.sql` | Example queries |
| `JobRecruitment_ERD.pdf` | Entity-relationship diagram |
| `ReverseEng.pdf` | Relational Schema |

## Setup

Requires MySQL 8.0.16 or later. Run the scripts in this order:

```bash
mysql -u <user> -p < create.sql
mysql -u <user> -p < insert.sql
mysql -u <user> -p < objects.sql
mysql -u <user> -p < triggers.sql
mysql -u <user> -p < queries.sql
```

Run `triggers.sql` after `insert.sql`: the sample data includes applications to a closed job, which a trigger would reject.

## Schema

Company, Recruiter, Job, Applicant, Applicant_Phone, Skill, Applicant_Skill, Job_Skill, Application, Interview. The tables are in BCNF (Applicant_phone in 4NF). See the ERD for relationships.

## Author

Mari Minasyan – Database Systems, AUA, 2026
