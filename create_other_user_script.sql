-- Drop the professor user if it exists
DECLARE
    user_exists NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO user_exists
    FROM dba_users
    WHERE username = 'PROFESSOR';

    IF user_exists = 1 THEN
        EXECUTE IMMEDIATE 'DROP USER professor CASCADE';
    END IF;
END;
/

-- Create the professor user
CREATE USER professor IDENTIFIED BY SpringDMDD2024#;

-- Grant the CONNECT privilege to the professor user
GRANT CONNECT TO professor;
GRANT RESOURCE TO professor;

-- Grant SELECT privileges on specific tables to the professor user
GRANT SELECT ON ums.term TO professor;
GRANT SELECT ON ums.course_catalog TO professor;
GRANT SELECT ON ums.program_catalog TO professor;
GRANT SELECT ON ums.building TO professor;
GRANT SELECT ON ums.floor TO professor;
GRANT SELECT ON ums.location TO professor;
GRANT SELECT ON ums.student_course_status TO professor;
GRANT SELECT ON ums.degree_type TO professor;
GRANT SELECT ON ums.employment_type TO professor;

GRANT SELECT, UPDATE, INSERT ON ums.course_schedule TO professor;
GRANT SELECT, UPDATE, INSERT ON ums.student_course TO professor;
GRANT SELECT, UPDATE, INSERT ON ums.course TO professor;
GRANT SELECT, UPDATE, INSERT ON ums.course_assessment TO professor;
GRANT SELECT, UPDATE, INSERT ON ums.student_course_mark TO professor;
GRANT SELECT, UPDATE, INSERT ON ums.course TO professor;
GRANT SELECT, UPDATE, INSERT ON ums.course_teaching_assistant TO professor;

GRANT SELECT ON ums.professor_teaching_schedule_view TO professor;
GRANT SELECT ON ums.student_transcript_view TO professor;
GRANT SELECT ON ums.course_statistics_view TO professor;
GRANT SELECT ON ums.course_enrollment_view TO student;

commit;


DECLARE
    user_exists NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO user_exists
    FROM dba_users
    WHERE username = 'STUDENT';

    IF user_exists = 1 THEN
        EXECUTE IMMEDIATE 'DROP USER student CASCADE';
    END IF;
END;
/

-- Create the professor user
CREATE USER student IDENTIFIED BY Database2024#;

-- Grant the CONNECT privilege to the professor user
GRANT CONNECT TO student;
GRANT RESOURCE TO student;

-- Grant SELECT privileges on specific tables to the professor user
GRANT SELECT ON ums.term TO student;
GRANT SELECT ON ums.course_catalog TO student;
GRANT SELECT ON ums.program_catalog TO student;
GRANT SELECT ON ums.course TO student;
GRANT SELECT ON ums.course_assessment TO student;

GRANT SELECT, UPDATE, INSERT ON ums.student_course TO student;

GRANT SELECT ON ums.student_information_view TO student;
GRANT SELECT ON ums.course_enrollment_view TO student;
GRANT SELECT ON ums.student_transcript_view TO student;

commit;


DECLARE
    user_exists NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO user_exists
    FROM dba_users
    WHERE username = 'TEACHINGASSISTANT';

    IF user_exists = 1 THEN
        EXECUTE IMMEDIATE 'DROP USER teachingassistant CASCADE';
    END IF;
END;
/

-- Create the professor user
CREATE USER teachingassistant IDENTIFIED BY Course2024ta#;

-- Grant the CONNECT privilege to the professor user
GRANT CONNECT TO teachingassistant;
GRANT RESOURCE TO teachingassistant;

-- Grant SELECT privileges on specific tables to the professor user
GRANT SELECT ON ums.course TO teachingassistant;
GRANT SELECT ON ums.student_course TO teachingassistant;
GRANT SELECT ON ums.course_assessment TO teachingassistant;

GRANT SELECT, UPDATE, INSERT ON ums.student_course_mark TO teachingassistant;

GRANT SELECT ON ums.grade_overview TO teachingassistant;

commit;

