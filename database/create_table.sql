CREATE TABLE Department (
    dept_name       CHAR(255)  NOT NULL UNIQUE,
    dept_position   CHAR(255)  NOT NULL,
    PRIMARY KEY(dept_name)
); 

CREATE TABLE Student (
    student_id      CHAR(255) NOT NULL UNIQUE,
    student_name    CHAR(255) NOT NULL,
    grade           INT NOT NULL,
CREATE TABLE Department (
    dept_name       CHAR(255)  NOT NULL UNIQUE,
    dept_position   CHAR(255)  NOT NULL,
    PRIMARY KEY(dept_name)
); 

CREATE TABLE Student (
    student_id      CHAR(255) NOT NULL UNIQUE,
    student_name    CHAR(255) NOT NULL,
    grade           INT NOT NULL,
    class           CHAR(255) NOT NULL,
    department      CHAR(255) NOT NULL,
    selected_credit INT NOT NULL,
    PRIMARY KEY(student_id),
    FOREIGN KEY(department) REFERENCES Department(dept_name)
);

CREATE TABLE Course (
    course_id      INT  NOT NULL UNIQUE,
    course_name    CHAR(255) NOT NULL,
    offer_dept     CHAR(255) NOT NULL,
    grade          INT NOT NULL,
    credit         INT NOT NULL,
    type           CHAR(255) NOT NULL,
    PRIMARY KEY(course_id), 
    FOREIGN KEY(offer_dept) REFERENCES Department(dept_name)
);

CREATE TABLE Instructor (
    instructor_id   INT  NOT NULL UNIQUE,
    instructor_name CHAR(255) NOT NULL,
    department      CHAR(255) NOT NULL,
    PRIMARY KEY(instructor_id),
    FOREIGN KEY(department) REFERENCES Department(dept_name)
);

CREATE TABLE Section (
    section_code    INT  NOT NULL UNIQUE,
    section_name    CHAR(255) NOT NULL,
    offer_class     CHAR(255) NOT NULL,
    max_enrollment  INT NOT NULL,
    cur_enrollment  INT NOT NULL,
--     course_id       INT NOT NULL,
    instructor_id   INT NOT NULL,
    PRIMARY KEY(section_code),
--     FOREIGN KEY(course_id)     REFERENCES Course(course_id),
    FOREIGN KEY(instructor_id) REFERENCES Instructor(instructor_id)
); 

CREATE TABLE SelectDetail (
    student_id      CHAR(255) NOT NULL,
    section_code    INT  NOT NULL,
    PRIMARY KEY(student_id, section_code),
    FOREIGN KEY(student_id) REFERENCES Student(student_id),
    FOREIGN KEY(section_code) REFERENCES Section(section_code)
);

CREATE TABLE LectureDetail (
    instructor_id   INT  NOT NULL,
    section_code    INT  NOT NULL,
    PRIMARY KEY(instructor_id, section_code),
    FOREIGN KEY(instructor_id) REFERENCES Instructor(instructor_id),
    FOREIGN KEY(section_code) REFERENCES Section(section_code)
);

CREATE TABLE TimeSlot (
    section_code    INT  NOT NULL,
    week_time		INT  NOT NULL,
    starting_time   INT  NOT NULL,
    ending_time     INT NOT NULL,
    PRIMARY KEY(section_code, week_time, starting_time, ending_time),
    FOREIGN KEY(section_code) REFERENCES Section(section_code)
);
