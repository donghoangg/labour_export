--DATABASE------------------------------------------------

CREATE DATABASE labour_export;

USE labour_export;

go
CREATE SCHEMA domestic;
go
CREATE SCHEMA student;
go
CREATE SCHEMA abroad;
go

--DROP------------------------------------------------------

DROP DATABASE labour_export;

DROP TABLE domestic.office;
DROP TABLE domestic.dep_off;
DROP TABLE domestic.department;
DROP TABLE domestic.staff;

DROP TABLE student.information;
DROP TABLE student.class;
DROP TABLE student.dependence;

DROP TABLE abroad.association;
DROP TABLE abroad.branch;
DROP TABLE abroad.job;
DROP TABLE abroad.company;
DROP TABLE abroad.recruitment;
DROP TABLE abroad.worker_information;
DROP TABLE abroad.worker_problem;
DROP TABLE abroad.worker_dependence;
DROP TABLE abroad.cooperate;

------------------------------------------------------------
GO
sp_help 'domestic.office';
go
sp_help 'domestic.dep_off';
go
sp_help 'domestic.department';
go
sp_help 'domestic.staff';
go
sp_help 'student.information';
go
sp_help 'student.class';
go
sp_help 'student.student_dependence';
go
sp_help 'abroad.association';
go
sp_help 'abroad.branch';
go
sp_help 'abroad.job';
go
sp_help 'abroad.company';
go
sp_help 'abroad.recruiment';
go
sp_help 'abroad.worker_information';
go
sp_help 'abroad.worker_problem';
go
sp_help 'abroad.worker_dependence';
go

----------------------------------------------------------
CREATE TABLE domestic.office (
    office_id           VARCHAR(2)          PRIMARY KEY,
    office_address      NVARCHAR(200)       NOT NULL UNIQUE,
    office_contact      VARCHAR(15)         NOT NULL UNIQUE,
    office_email        VARCHAR(70)         NOT NULL UNIQUE
);

CREATE TABLE domestic.department (
    department_id       VARCHAR(2)          PRIMARY KEY,
    department_name     NVARCHAR(70)       NOT NULL UNIQUE
);

CREATE TABLE domestic.dep_off (
    
    department_id       VARCHAR(2)          NOT NULL,
    office_id           VARCHAR(2)          NOT NULL

    PRIMARY KEY (department_id, office_id)

);

CREATE TABLE domestic.staff (
    staff_id            VARCHAR(15)         PRIMARY KEY, 
    staff_name          NVARCHAR(70)        NOT NULL,
    staff_idenNum       VARCHAR(30)         UNIQUE NOT NULL,
    staff_sex           NVARCHAR(3)         NOT NULL CHECK (UPPER(staff_sex) IN ('NAM', 'NỮ')),
    staff_dob           DATE                NOT NULL,
    staff_phone         VARCHAR(15)         UNIQUE NOT NULL,
    staff_email         VARCHAR(70)         NOT NULL,
    staff_address       NVARCHAR(200)       NOT NULL,
    staff_position      NVARCHAR(70)        NOT NULL,
    staff_salary        VARCHAR(30)         NOT NULL,

    office_id           VARCHAR(2)          NOT NULL,
    department_id       VARCHAR(2)          NOT NULL,
    manager_id          VARCHAR(15)
);

CREATE TABLE student.information (
    student_id          VARCHAR(15)         PRIMARY KEY,
    student_idenNum     VARCHAR(30)         NOT NULL UNIQUE,
    student_name        NVARCHAR(70)        NOT NULL, 
    student_sex         NVARCHAR(3)         NOT NULL CHECK (UPPER(student_sex) IN ('NAM', 'NỮ')),
    student_dob         VARCHAR(15)               NOT NULL,
    student_phone       VARCHAR(15)         UNIQUE NOT NULL,       
    student_email       VARCHAR(70)         UNIQUE NOT NULL, 
    student_address     NVARCHAR(200)       NOT NULL,
    est_departure_date  VARCHAR(15)                NOT NULL,
    student_age         INT                 NOT NULL,
    office_id           VARCHAR(2)          NOT NULL,
    job_id              VARCHAR(6)          NOT NULL,
    recruitment_id      INT                 NOT NULL,
    class_id            INT                 NOT NULL
);  


CREATE TABLE student.class (
    class_id            INT                 PRIMARY KEY,
    class_startTime     DATE                NOT NULL,
    class_endTime       DATE                NOT NULL,
    room_address        VARCHAR(15)         NOT NULL,
    class_level         INT                 NOT NULL,

    teacher_id          VARCHAR(15)         NOT NULL,
    office_id           VARCHAR(2)          NOT NULL
);

CREATE TABLE student.dependence (
    student_id          VARCHAR(15)         NOT NULL,
    dependence_name     NVARCHAR(70)        NOT NULL,
    relationship        NVARCHAR(15)        NOT NULL,
    dependence_sex      NVARCHAR(3)         NOT NULL CHECK (UPPER(dependence_sex) IN ('NAM', 'NỮ')),
    dependence_phone    VARCHAR(15)         NOT NULL,        
    dependence_address  NVARCHAR(200)
);

CREATE TABLE abroad.cooperate(
    cooperate_id        INT IDENTITY(1,1)   NOT NULL, 
    asso_id             VARCHAR(6) NOT NULL,
    office_id           VARCHAR(2) NOT NULL
);


CREATE TABLE abroad.association
(
    asso_id             VARCHAR(6)          PRIMARY KEY,
    asso_name           NVARCHAR(100)       UNIQUE NOT NULL,
    asso_manager        NVARCHAR(70)        NOT NULL,
    asso_contact        VARCHAR(15)         UNIQUE NOT NULL,
    asso_email          VARCHAR(70)         UNIQUE DEFAULT 0,
    asso_address        VARCHAR(200)        UNIQUE NOT NULL
);

CREATE TABLE abroad.branch (
    branch_id           INT                 IDENTITY(1,1)   PRIMARY KEY,
    branch_name         NVARCHAR(70)        UNIQUE NOT NULL 
);

CREATE TABLE abroad.job
(
    job_id              VARCHAR(6)          PRIMARY KEY,
    job_name            NVARCHAR(70)        UNIQUE NOT NULL,
    est_salary          VARCHAR(30)                 NOT NULL,
    age_limit           VARCHAR(15)                 DEFAULT 0,
    branch_id           INT                 NOT NULL
);

CREATE TABLE abroad.company
(
    company_id          VARCHAR(6)          PRIMARY KEY,
    company_name        NVARCHAR(100)       UNIQUE NOT NULL,
    company_address     NVARCHAR(200)       UNIQUE NOT NULL,
    company_contact     VARCHAR(15)         UNIQUE NOT NULL,
    company_email       VARCHAR(70)         UNIQUE DEFAULT 0,
    asso_id             VARCHAR(6)          NOT NULL,
    job_id              VARCHAR(6)          NOT NULL
);

CREATE TABLE abroad.recruitment
(
    recruitment_id       INT                 IDENTITY(1,1)   PRIMARY KEY,
    quantity            INT                 NOT NULL,	
    company_id          VARCHAR(6)          NOT NULL,
    recruitment_beginTime    DATE            NOT NULL,
    recruitment_endTime      DATE            NOT NULL,
    job_id              VARCHAR(6)          NOT NULL
);

CREATE TABLE abroad.worker_information
(
    worker_id           INT                 IDENTITY(1,1) PRIMARY KEY,
    worker_name	        VARCHAR(70)         NOT NULL,
    worker_age          INT                 NOT NULL,
    worker_sex          NVARCHAR(3)         NOT NULL CHECK (UPPER(worker_sex) IN ('NAM', 'NỮ')),
    worker_dob          VARCHAR(15)                NOT NULL,
    worker_phone        VARCHAR(15)         UNIQUE NOT NULL,
    worker_address      NVARCHAR(200)       NOT NULL,
    departure_date      VARCHAR(15)         NOT NULL,
    company_id          VARCHAR(6)          NOT NULL,
    asso_id             VARCHAR(6)          NOT NULL,
    worker_idenNum      VARCHAR(30)         NOT NULL UNIQUE,
    job_id              VARCHAR(6)          NOT NULL,
    worker_email        VARCHAR(70)         UNIQUE DEFAULT 0
);

CREATE TABLE abroad.worker_problem
(
    problem_id          INT IDENTITY(1,1)   PRIMARY KEY,
    problem_description NVARCHAR(100)        NOT NULL,
    worker_id           INT                 UNIQUE NOT NULL
);

CREATE TABLE abroad.worker_dependence
(
    worker_id                INT                 NOT NULL,
    dependence_name          NVARCHAR(70)        NOT NULL,
    dependence_dob           VARCHAR(15),            
    relationship             NVARCHAR(15)        NOT NULL,
    dependence_sex           NVARCHAR(3)         NOT NULL CHECK (UPPER(dependence_sex) IN ('NAM', 'NỮ')),
    dependence_phone         VARCHAR(15)         UNIQUE NOT NULL,
    dependence_address       NVARCHAR(200)       NOT NULL
);

--------------------------------------------------------------------------------

ALTER TABLE domestic.dep_off
ADD     FOREIGN KEY (office_id)     REFERENCES domestic.office(office_id) ,
        FOREIGN KEY (department_id) REFERENCES domestic.department(department_id);

ALTER TABLE domestic.staff
ADD   
    FOREIGN KEY (office_id)     REFERENCES domestic.office(office_id),
    FOREIGN KEY (department_id) REFERENCES domestic.department(department_id),
    FOREIGN KEY (manager_id)    REFERENCES domestic.staff(staff_id);

ALTER TABLE student.information
ADD   
    FOREIGN KEY (office_id)     REFERENCES domestic.office(office_id) ,
    FOREIGN KEY (job_id)        REFERENCES abroad.job(job_id) ,
    FOREIGN KEY (class_id)      REFERENCES student.class(class_id) ,
    FOREIGN KEY (recruitment_id)   REFERENCES abroad.recruitment(recruitment_id);

ALTER TABLE student.class
ADD 
    FOREIGN KEY (teacher_id)    REFERENCES domestic.staff(staff_id) ,
    FOREIGN KEY (office_id)     REFERENCES domestic.office(office_id) ;

ALTER TABLE student.dependence
ADD 
    PRIMARY KEY (student_id, dependence_name),
    FOREIGN KEY (student_id)    REFERENCES student.information(student_id) 

ALTER TABLE abroad.cooperate
ADD 
    PRIMARY KEY (asso_id,office_id),
    FOREIGN KEY (asso_id)       REFERENCES abroad.association (asso_id) ,
    FOREIGN KEY (office_id)     REFERENCES domestic.office(office_id)

ALTER TABLE abroad.job
ADD 
    FOREIGN KEY (branch_id) REFERENCES abroad.branch (branch_id) ON DELETE CASCADE

ALTER TABLE abroad.company
ADD 
    FOREIGN KEY (asso_id) REFERENCES abroad.association (asso_id) ON DELETE CASCADE, 
    FOREIGN KEY (job_id) REFERENCES abroad.job (job_id) ON DELETE CASCADE

ALTER TABLE abroad.recruitment
ADD 
    FOREIGN KEY (company_id) REFERENCES abroad.company (company_id) ,
    FOREIGN KEY (job_id) REFERENCES abroad.job (job_id) 

ALTER TABLE abroad.worker_information
ADD 
    FOREIGN KEY (company_id) REFERENCES abroad.company (company_id),
    FOREIGN KEY (asso_id)   REFERENCES abroad.association (asso_id),
    FOREIGN KEY (job_id) REFERENCES abroad.job (job_id) 

ALTER TABLE abroad.worker_problem
ADD 
    FOREIGN KEY (worker_id) REFERENCES abroad.worker_information (worker_id)

ALTER TABLE abroad.worker_dependence
ADD 
    PRIMARY KEY(dependence_name, worker_id),
    FOREIGN KEY (worker_id) REFERENCES abroad.worker_information (worker_id) ON DELETE CASCADE
