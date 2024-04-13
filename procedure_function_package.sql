CREATE OR REPLACE PROCEDURE create_program (
    p_college_name    IN VARCHAR2,
    p_degree_type     IN VARCHAR2,
    p_program_name    IN VARCHAR2,
    p_term_name       IN VARCHAR2,
    p_comments        IN VARCHAR2
)
IS
    v_college_id          NUMBER;
    v_degree_type_id      NUMBER;
    v_program_catalog_id  NUMBER;
    v_term_id             NUMBER;
    v_program_id          NUMBER;
    v_count               NUMBER;
BEGIN
    -- Get college_id based on college_name
    SELECT id INTO v_college_id FROM college WHERE name = p_college_name;

    -- Check if college exists
    IF v_college_id IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('College doesn''t exist.');
        RETURN;
    END IF;

    -- Get degree_type_id based on degree_type
    SELECT id INTO v_degree_type_id FROM degree_type WHERE NAME = p_degree_type;

    -- Check if degree type exists
    IF v_degree_type_id IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('Degree type doesn''t exist.');
        RETURN;
    END IF;

    -- Get program_catalog_id based on program_name, college_id, and degree_type_id
    SELECT id INTO v_program_catalog_id 
    FROM program_catalog 
    WHERE NAME = p_program_name 
    AND COLLEGE_ID = v_college_id 
    AND DEGREE_TYPE_ID = v_degree_type_id;

    -- Check if program catalog exists
    IF v_program_catalog_id IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('Program catalog doesn''t exist.');
        RETURN;
    END IF;

    -- Get term_id based on term_name
    SELECT id INTO v_term_id FROM term WHERE name = p_term_name;

    -- Check if term exists
    IF v_term_id IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('Term doesn''t exist.');
        RETURN;
    END IF;

    -- Check if a program with the same program_catalog_id and term_id already exists
    SELECT COUNT(*) INTO v_count
    FROM program
    WHERE PROGRAM_CATALOG_ID = v_program_catalog_id
    AND TERM_ID = v_term_id;

    IF v_count > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Program already exists for the given Program Catalog and Term.');
        RETURN;
    END IF;

    -- Check the length of the comments
    IF LENGTH(p_comments) > 99 THEN
        DBMS_OUTPUT.PUT_LINE('Comments length is greater than 100.');
        RETURN;
    END IF;

    -- Get the next available ID
    SELECT COALESCE(MAX(ID), 0) + 1 INTO v_program_id FROM program;

    -- Insert into PROGRAM table
    INSERT INTO program (ID, PROGRAM_CATALOG_ID, TERM_ID, PROGRAM_STATUS_ID, COMMENTS, CREATED_BY, CREATED_ON, UPDATED_BY, UPDATED_ON) 
    VALUES (v_program_id, v_program_catalog_id, v_term_id, 1, p_comments, 'UMS', SYSDATE, NULL, NULL);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: College or Degree type or Program catalog or Term not found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
END;
/


create or replace PROCEDURE PUBLISH_NEW_COURSE (
    p_college_name    IN VARCHAR2,
    p_degree_type     IN VARCHAR2,
    p_program_name    IN VARCHAR2,
    p_course_code     IN VARCHAR2,
    p_course_name     IN VARCHAR2,
    p_description     IN VARCHAR2,
    p_comments        IN VARCHAR2,
    p_credits         IN NUMBER
)
IS
    v_college_id          NUMBER;
    v_degree_type_id      NUMBER;
    v_program_catalog_id  NUMBER;
    v_course_id           NUMBER;
    v_count               NUMBER;
BEGIN
    -- Get college_id based on college_name
    SELECT id INTO v_college_id FROM college WHERE name = p_college_name;

    -- Check if college exists
    IF v_college_id IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('The mentioned college doesn''t exist.');
        RAISE_APPLICATION_ERROR(-20001, 'The mentioned college doesnt exist.');
    END IF;

    -- Get degree_type_id based on degree_type
    SELECT id INTO v_degree_type_id FROM degree_type WHERE NAME = p_degree_type;

    -- Check if degree type exists
    IF v_degree_type_id IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('The mentioned degree type doesn''t exist.');
        RAISE_APPLICATION_ERROR(-20002, 'The mentioned degree type doesnt exist.');
    END IF;

    -- Get program_catalog_id based on program_name, college_id, and degree_type_id
    SELECT id INTO v_program_catalog_id 
    FROM program_catalog 
    WHERE NAME = p_program_name 
    AND COLLEGE_ID = v_college_id 
    AND DEGREE_TYPE_ID = v_degree_type_id;

    -- Check if program catalog exists
    IF v_program_catalog_id IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('The mentioned program catalog doesn''t exist.');
        RAISE_APPLICATION_ERROR(-20003, 'The mentioned program catalog doesnt exist.');
    END IF;

    -- Check uniqueness of COURSE_CODE
    SELECT COUNT(*) INTO v_count FROM COURSE_CATALOG WHERE COURSE_CODE = p_course_code;

    IF v_count > 0 THEN
        DBMS_OUTPUT.PUT_LINE('COURSE_CODE should be unique.');
        RAISE_APPLICATION_ERROR(-20004, 'COURSE_CODE should be unique.');
    END IF;

    -- Check COURSE_NAME length and characters
    IF LENGTH(p_course_name) > 50 OR NOT REGEXP_LIKE(p_course_name, '^[a-zA-Z ]+$') THEN
        DBMS_OUTPUT.PUT_LINE('COURSE_NAME should be less than 50 characters and contain only alphabets.');
        RAISE_APPLICATION_ERROR(-20005, 'COURSE_NAME should be less than 50 characters and contain only alphabets.');
    END IF;

    -- Check DESCRIPTION length and characters
    IF LENGTH(p_description) > 170 OR NOT REGEXP_LIKE(p_description, '^[a-zA-Z ]+$') THEN
        DBMS_OUTPUT.PUT_LINE('DESCRIPTION should be less than 170 characters and contain only alphabets.');
        RAISE_APPLICATION_ERROR(-20006, 'DESCRIPTION should be less than 170 characters and contain only alphabets.');
    END IF;

    -- Check COMMENTS length and characters
    IF LENGTH(p_comments) > 100 OR NOT REGEXP_LIKE(p_comments, '^[a-zA-Z ]+$') THEN
        DBMS_OUTPUT.PUT_LINE('COMMENTS should be less than 100 characters and contain only alphabets.');
        RAISE_APPLICATION_ERROR(-20007, 'COMMENTS should be less than 100 characters and contain only alphabets.');
    END IF;

    -- Check if CREDITS is a number
    IF NOT REGEXP_LIKE(TO_CHAR(p_credits), '^[0-9]+$') THEN
        DBMS_OUTPUT.PUT_LINE('CREDITS should be a number.');
        RAISE_APPLICATION_ERROR(-20008, 'CREDITS should be a number.');
    END IF;

    -- Get the next available ID
    SELECT MAX(ID) + 1 INTO v_course_id FROM COURSE_CATALOG;

    -- Insert into COURSE_CATALOG table
    INSERT INTO COURSE_CATALOG (ID, COURSE_CODE, COURSE_NAME, DESCRIPTION, CREDITS, PROGRAM_CATALOG_ID, COMMENTS, IS_ENABLED, CREATED_BY, CREATED_ON) 
    VALUES (v_course_id, p_course_code, p_course_name, p_description, p_credits, v_program_catalog_id, p_comments, 'Y', 'UMS', SYSDATE);

    COMMIT; -- Commit the transaction

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error occurred: Please enter a valid course details');
        --RAISE_APPLICATION_ERROR(-20009, 'Error occurred: Please enter a valid course details');
END PUBLISH_NEW_COURSE;
/


CREATE OR REPLACE PROCEDURE CREATE_NEW_ADMINISTRATOR (
    p_first_name            IN VARCHAR2,
    p_last_name             IN VARCHAR2,
    p_email                 IN VARCHAR2,
    p_phone_number          IN VARCHAR2,
    p_passport_number       IN VARCHAR2, 
    p_employment_type_name  IN VARCHAR2,
    p_employment_status_name IN VARCHAR2,
    p_comments              IN VARCHAR2
)
IS
    v_employment_type_id        NUMBER;
    v_employment_status_id      NUMBER;
    v_existing_status_id        NUMBER;
    v_administrator_id          NUMBER;
BEGIN
    -- Check FIRST_NAME
    IF NOT REGEXP_LIKE(p_first_name, '^[a-zA-Z]+$') OR LENGTH(p_first_name) > 25 THEN
        DBMS_OUTPUT.PUT_LINE('Error: FIRST_NAME should contain alphabets only and length should be less than 25 characters.');
        RETURN;
    END IF;

    -- Check LAST_NAME
    IF NOT REGEXP_LIKE(p_last_name, '^[a-zA-Z]+$') OR LENGTH(p_last_name) > 25 THEN
        DBMS_OUTPUT.PUT_LINE('Error: LAST_NAME should contain alphabets only and length should be less than 25 characters.');
        RETURN;
    END IF;

    -- Check EMAIL format and length
    IF NOT REGEXP_LIKE(p_email, '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$') OR LENGTH(p_email) > 50 THEN
        DBMS_OUTPUT.PUT_LINE('Error: Invalid EMAIL format or length.');
        RETURN;
    END IF;

    -- Check PHONE_NUMBER format
    IF NOT REGEXP_LIKE(p_phone_number, '^(\+1)[0-9]{10}$') THEN
        DBMS_OUTPUT.PUT_LINE('Error: Invalid PHONE_NUMBER format.');
        RETURN;
    END IF;

    -- Check PASSPORT_NUMBER format and length
    IF NOT REGEXP_LIKE(p_passport_number, '^[A-Z]{2}[0-9]{7}$') OR LENGTH(p_passport_number) != 9 THEN
        DBMS_OUTPUT.PUT_LINE('Error: Invalid PASSPORT_NUMBER format or length.');
        RETURN;
    END IF;

    -- Get employment_type_id based on employment_type_name
    SELECT id INTO v_employment_type_id FROM employment_type WHERE name = p_employment_type_name;

    -- Check if employment type exists
    IF v_employment_type_id IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('Error: The mentioned employment type doesn''t exist.');
        RETURN;
    END IF;

    -- Get employment_status_id based on employment_status_name
    SELECT id INTO v_employment_status_id FROM employment_status WHERE name = p_employment_status_name;

    -- Check if employment status exists
    IF v_employment_status_id IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('Error: The mentioned employment status doesn''t exist.');
        RETURN;
    END IF;

    -- Check COMMENTS length and characters
    IF LENGTH(p_comments) > 200 OR NOT REGEXP_LIKE(p_comments, '^[a-zA-Z ]+$') THEN
        DBMS_OUTPUT.PUT_LINE('Error: COMMENTS should be less than 200 characters and contain alphabets only.');
        RETURN;
    END IF;

    -- Check existing status for the given passport number
    SELECT EMPLOYMENT_STATUS_ID INTO v_existing_status_id
    FROM ADMINISTRATOR
    WHERE PASSPORT_NUMBER = p_passport_number
    AND ROWNUM = 1
    ORDER BY CREATED_ON DESC;

    IF v_existing_status_id IS NOT NULL AND v_existing_status_id != 3 THEN
        DBMS_OUTPUT.PUT_LINE('Error: The person with the given PASSPORT_NUMBER has existing records with an employment_status_id other than former');
        RETURN;
    END IF;

    -- Get the next available ID
    SELECT MAX(ID) + 1 INTO v_administrator_id FROM ADMINISTRATOR;

    -- Insert into ADMINISTRATOR table
    INSERT INTO ADMINISTRATOR (
        ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, PASSPORT_NUMBER,
        EMPLOYMENT_TYPE_ID, EMPLOYMENT_STATUS_ID, COMMENTS,
        CREATED_BY, CREATED_ON, EMPLOYMENT_DESIGNATION_ID
    )
    VALUES (
        v_administrator_id, p_first_name, p_last_name, p_email, p_phone_number, p_passport_number,
        v_employment_type_id, v_employment_status_id, p_comments,
        'UMS', SYSDATE, 6
    );

    COMMIT; -- Commit the transaction

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: Please enter the valid data to create a new administrator');
END CREATE_NEW_ADMINISTRATOR;
/



CREATE OR REPLACE FUNCTION enroll_in_course(
    p_course_crn IN course.crn%TYPE,
    p_university_student_number IN student.university_student_number%TYPE
) RETURN VARCHAR2
AS
    v_student_id student.id%TYPE;
    v_course_id course.id%TYPE;
    v_enrollment_count NUMBER;
    v_seating_capacity course.seating_capacity%TYPE;
BEGIN
    -- Check if the student exists and get the student ID
    SELECT id INTO v_student_id
    FROM student
    WHERE university_student_number = p_university_student_number;

    -- Check if the course exists and get the course ID
    SELECT id INTO v_course_id
    FROM course
    WHERE crn = p_course_crn;

    -- Check for current number of enrollments in the course
    SELECT COUNT(*)
    INTO v_enrollment_count
    FROM student_course
    WHERE course_id = v_course_id;

    -- Check the seating capacity of the course
    SELECT seating_capacity INTO v_seating_capacity
    FROM course
    WHERE id = v_course_id;

    -- Compare current enrollments with seating capacity
    IF v_enrollment_count < v_seating_capacity THEN
        -- Check if the student is already enrolled
        SELECT COUNT(*)
        INTO v_enrollment_count
        FROM student_course
        WHERE student_id = v_student_id
        AND course_id = v_course_id;
        
        IF v_enrollment_count > 0 THEN
            RETURN 'Student is already enrolled in this course.';
        ELSE
            -- Enroll the student in the course
            INSERT INTO student_course (student_id, course_id)
            VALUES (v_student_id, v_course_id);
            RETURN 'Student successfully enrolled in the course.';
        END IF;
    ELSE
        RETURN 'Course is at full capacity.';
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Student or course not found.';
    WHEN OTHERS THEN
        RETURN 'Error enrolling student: ' || SQLERRM;
END;
/


CREATE OR REPLACE FUNCTION Assign_Teaching_Assistant(
    p_professor_email VARCHAR2,
    p_course_id NUMBER,  -- Using course ID directly as per your schema
    p_ta_email VARCHAR2,
    p_start_date DATE,
    p_end_date DATE,
    p_employment_type_id NUMBER,
    p_employment_designation_id NUMBER,
    p_employment_status_id NUMBER,
    p_comments VARCHAR2
) RETURN VARCHAR2
IS
    v_professor_id NUMBER;
    v_ta_id NUMBER;
    v_course_count NUMBER;
BEGIN
    -- Retrieve the professor ID using the email
    SELECT id INTO v_professor_id
    FROM professor
    WHERE email = p_professor_email;

    -- Retrieve the TA ID using the TA email
    SELECT id INTO v_ta_id
    FROM student  -- Assuming TAs are recorded in the student table
    WHERE email = p_ta_email;

    -- Check if the course is taught by the professor
    SELECT COUNT(*)
    INTO v_course_count
    FROM course
    WHERE id = p_course_id AND professor_id = v_professor_id;

    -- If no course matches, return an error message
    IF v_course_count = 0 THEN
        RETURN 'Error: No such course taught by this professor.';
    END IF;

    -- Insert the teaching assistant assignment
    INSERT INTO course_teaching_assistant (
        course_id,
        student_id,
        start_date,
        end_date,
        employment_type_id,
        employment_designation_id,
        employment_status_id,
        comments,
        created_by,
        created_on,
        updated_by,
        updated_on
    ) VALUES (
        p_course_id,
        v_ta_id,
        p_start_date,
        p_end_date,
        p_employment_type_id,
        p_employment_designation_id,
        p_employment_status_id,
        p_comments,
        p_professor_email, -- Using the professor's email as the creator
        SYSDATE,
        p_professor_email, -- Using the professor's email as the updater
        SYSDATE
    );

    -- Return success message
    RETURN 'Teaching assistant assigned successfully.';
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Error: Invalid professor email or TA email.';
    WHEN OTHERS THEN
        -- In case of any exception, return the error
        RETURN 'Error: ' || SQLERRM;
END;
/


CREATE OR REPLACE FUNCTION Enter_Assignment_Marks(
    p_ta_id NUMBER,
    p_course_id NUMBER,
    p_course_assessment_id NUMBER,
    p_student_course_id NUMBER,
    p_marks NUMBER,
    p_comments VARCHAR2
) RETURN VARCHAR2
IS
    v_ta_course_count NUMBER;
BEGIN
    -- Check if the TA is assigned to the course
    SELECT COUNT(*)
    INTO v_ta_course_count
    FROM course_teaching_assistant
    WHERE STUDENT_ID = p_ta_id AND COURSE_ID = p_course_id;

    IF v_ta_course_count = 0 THEN
        RETURN 'Error: TA is not assigned to this course.';
    END IF;
    
    -- Check if the marks are within a valid range (assumed 0 to 100)
    IF p_marks < 0 OR p_marks > 100 THEN
        RETURN 'Error: Marks must be between 0 and 100.';
    END IF;

    -- Enter the marks
    INSERT INTO student_course_mark (
        STUDENT_COURSE_ID,
        COURSE_ASSESSMENT_ID,
        OBTAINED_MARKS,
        COMMENTS,
        CREATED_BY,
        CREATED_ON,
        UPDATED_BY,
        UPDATED_ON
    ) VALUES (
        p_student_course_id,
        p_course_assessment_id,
        p_marks,
        p_comments,
        TO_CHAR(p_ta_id), -- Assuming the TA's ID is being used to track who created/updated the record
        SYSDATE,
        TO_CHAR(p_ta_id),
        SYSDATE
    );

    RETURN 'Marks entered successfully.';
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Error: Invalid TA ID, course ID, or assessment ID.';
    WHEN OTHERS THEN
        RETURN 'Error: ' || SQLERRM;
END;
/


CREATE OR REPLACE FUNCTION ums.create_course (
    p_professor_uni_num  VARCHAR2,
    p_course_catalog_id  NUMBER,
    p_term_id            NUMBER,
    p_crn                NUMBER,
    p_seating_capacity   NUMBER DEFAULT 100
) RETURN NUMBER AS
    v_college_id NUMBER;
    v_professor_id NUMBER;
    v_course_id NUMBER;
    v_count NUMBER;
BEGIN
    -- Get professor ID and college from university professor number
    SELECT id, college_id INTO v_professor_id, v_college_id
    FROM ums.professor
    WHERE university_professor_number = p_professor_uni_num;

    -- Check if professor exists
    IF v_professor_id IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'The mentioned professor doesnt exist.');
    END IF;

    -- Check if course_catalog exists
    SELECT COUNT(*) INTO v_count FROM ums.course_catalog WHERE ID = p_course_catalog_id;
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'The mentioned course catalog doesnt exist.');
    END IF;

    -- Check if term exists
    SELECT COUNT(*) INTO v_count FROM ums.term WHERE ID = p_term_id;
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'The mentioned term doesnt exist.');
    END IF;

    -- Check if crn is unique
    SELECT COUNT(*) INTO v_count FROM ums.course WHERE CRN = p_crn;
    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20004, 'CRN should be unique.');
    END IF;

    -- Insert into COURSE table
    INSERT INTO ums.course (ID, COURSE_CATALOG_ID, PROFESSOR_ID, TERM_ID, CRN, SEATING_CAPACITY, CREATED_BY, CREATED_ON)
    VALUES ((SELECT MAX(ID) + 1 FROM ums.course), p_course_catalog_id, v_professor_id, p_term_id, p_crn, p_seating_capacity, 'UMS', SYSDATE);
    
    RETURN v_course_id;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20005, 'Error occurred: ' || SQLERRM);
END;
/



CREATE OR REPLACE FUNCTION ums.create_course_schedule (
    p_course_id          NUMBER,
    p_day_of_week        VARCHAR2,
    p_start_time         VARCHAR2,
    p_end_time           VARCHAR2,
    p_location           VARCHAR2
) RETURN NUMBER AS
    v_schedule_id NUMBER;
BEGIN
    -- Insert the schedule
    INSERT INTO ums.course_schedule (course_id, day, start_time, end_time, location_id, created_by, created_on)
    VALUES (p_course_id, p_day_of_week, p_start_time, p_end_time, p_location, 'System', SYSDATE);
    
    -- Return the course ID for confirmation
    RETURN p_course_id;
EXCEPTION
    WHEN OTHERS THEN
        -- Generic exception handling
        RAISE_APPLICATION_ERROR(-20002, SQLERRM);
END;
/


CREATE OR REPLACE FUNCTION ums.create_assessment (
    p_university_professor_number VARCHAR2,
    p_course_id                   NUMBER,
    p_name                        VARCHAR2,
    p_weightage                   NUMBER,
    p_total_marks                 NUMBER,
    p_comments                    VARCHAR2,
    p_assessment_id               NUMBER -- Add this parameter to provide the ID manually
) RETURN NUMBER AS
    v_professor_id NUMBER;
    v_term_end_date DATE;
    v_today DATE := SYSDATE;
BEGIN
    -- Check if weightage is between 0 and 1
    IF p_weightage <= 0 OR p_weightage > 1 THEN
        RAISE_APPLICATION_ERROR(-20004, 'Weightage must be a decimal between 0 and 1.');
    END IF;


    -- Get professor's ID and associated term end date of the course
    SELECT p.id, t.end_date
    INTO v_professor_id, v_term_end_date
    FROM ums.professor p
    JOIN ums.course c ON p.id = c.professor_id
    JOIN ums.term t ON c.term_id = t.id
    WHERE p.university_professor_number = p_university_professor_number
    AND c.id = p_course_id;

    -- Check if the term end date is in the past
    IF v_term_end_date < v_today THEN
        RAISE_APPLICATION_ERROR(-20003, 'Cannot set assessment for past terms.');
    END IF;

    -- Insert the assessment
    INSERT INTO ums.course_assessment (id, course_id, name, weightage, total_marks, comments, created_by, created_on)
    VALUES (p_assessment_id, p_course_id, p_name, p_weightage, p_total_marks, p_comments, 'System', SYSDATE);

    -- Return the ID of the new assessment for confirmation
    RETURN p_assessment_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'Invalid professor number or course ID.');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, SQLERRM);
END;
/



CREATE OR REPLACE FUNCTION ums.release_grades (
    p_course_id        NUMBER,
    p_assessment_id    NUMBER,
    p_grade_name       VARCHAR2,
    p_comments         VARCHAR2,
    p_is_enabled       VARCHAR2,
    p_created_by       VARCHAR2,
    p_created_on       DATE
) RETURN NUMBER AS
    v_grade_id NUMBER;
BEGIN
    -- Insert the released grade
    INSERT INTO ums.grade (id, name, comments, is_enabled, created_by, created_on)
    VALUES (NULL, p_grade_name, p_comments, p_is_enabled, p_created_by, p_created_on)
    RETURNING id INTO v_grade_id;

    -- Insert the released grade into student_course table
    INSERT INTO ums.student_course (id, course_id, grade_id, created_by, created_on)
    SELECT sc.id, p_course_id, v_grade_id, p_created_by, p_created_on
    FROM ums.student_course sc
    WHERE sc.course_id = p_course_id
    AND sc.grade_id IS NULL; -- Assuming you want to update only records with NULL grade_id
    
    -- Return 1 if successful
    RETURN 1;
EXCEPTION
    WHEN OTHERS THEN
        -- Return 0 if an error occurs
        RETURN 0;
END;
/

CREATE OR REPLACE PROCEDURE deregister_from_course (
    p_course_crn                IN course.crn%TYPE,
    p_university_student_number IN student.university_student_number%TYPE
) AS

    v_student_id  student.id%TYPE;
    v_course_id   course.id%TYPE;
    v_start_date  term.start_date%TYPE;
    v_is_enrolled INT;
BEGIN
    -- Check if the student exists
    BEGIN
        SELECT
            id
        INTO v_student_id
        FROM
            student
        WHERE
            university_student_number = p_university_student_number;

    EXCEPTION
        WHEN no_data_found THEN
            dbms_output.put_line('Student with University Student Number '
                                 || p_university_student_number
                                 || ' does not exist');
            RETURN;
    END;

    -- Check if the course exists
    BEGIN
        SELECT
            id
        INTO v_course_id
        FROM
            course
        WHERE
            crn = p_course_crn;

    EXCEPTION
        WHEN no_data_found THEN
            dbms_output.put_line('Invalid Course CRN');
            RETURN;
    END;

    -- Check if the student is enrolled in the course
    BEGIN
        SELECT
            start_date
        INTO v_start_date
        FROM
                 term
            JOIN course ON course.term_id = term.id
        WHERE
            course.id = v_course_id;

        SELECT
            COUNT(*)
        INTO v_is_enrolled
        FROM
            student_course
        WHERE
                student_id = v_student_id
            AND course_id = v_course_id;

        IF v_start_date > sysdate THEN
            IF v_is_enrolled > 0 THEN
                -- Remove the student from the course
                DELETE FROM student_course
                WHERE
                        course_id = v_course_id
                    AND student_id = v_student_id;

                dbms_output.put_line(v_is_enrolled);
                dbms_output.put_line('Student successfully deregistered from the course.');
            ELSE
                dbms_output.put_line(v_is_enrolled);
                dbms_output.put_line('Student is not enrolled in the specified course.');
            END IF;
        ELSE
            dbms_output.put_line('Course has already started. Deregistration not allowed.');
        END IF;

    END;

END;
/

set serveroutput on;

CREATE OR REPLACE PROCEDURE insert_student (
    p_first_name      VARCHAR2,
    p_last_name       VARCHAR2,
    p_date_of_birth   DATE,
    p_passport_number VARCHAR2,
    p_program_id      INT,
    p_email           VARCHAR2,
    p_student_status  VARCHAR2,
    p_phone_number    INT
) AS
    v_student_id     INT;
    v_term_id        INT;
    v_student_status INT;
BEGIN
    
    -- Check if the program ID exists
    SELECT
        term_id
    INTO v_term_id
    FROM
        program
    WHERE
            id = p_program_id
        AND program_status_id < 3; -- Assuming program_status_id = 2 indicates an active program and program_status_id = 1 means published program.
    dbms_output.put_line('v_term_id: ' || v_term_id);

    -- Check if the student status exists
    SELECT
        id
    INTO v_student_status
    FROM
        student_status
    WHERE
        status_name = p_student_status;

    dbms_output.put_line('v_student_status: ' || v_student_status);

    -- Validate first name and last name (should not contain numbers)
    IF regexp_like(p_first_name, '[[:digit:]]') OR regexp_like(p_last_name, '[[:digit:]]') THEN
        dbms_output.put_line('Error: First name and last name should not contain numbers.');
        RETURN;
    END IF;

    -- Validate email format
    IF instr(p_email, '@') = 0 THEN
        dbms_output.put_line('Error: Email address should contain an "@" symbol.');
        RETURN;
    END IF;

    -- Insert the student record
    INSERT INTO student (
        id,
        first_name,
        last_name,
        dob,
        passport_number,
        program_id,
        term_id,
        email,
        student_status_id,
        phone_number
    ) VALUES (
        (select max(ID)+1 from ums.student),
        p_first_name,
        p_last_name,
        p_date_of_birth,
        p_passport_number,
        p_program_id,
        v_term_id,
        p_email,
        v_student_status,
        p_phone_number
    );

    -- Print success message
    dbms_output.put_line('Student inserted successfully with ID: ' || v_student_id);
EXCEPTION
    WHEN no_data_found THEN
        IF v_term_id IS NULL THEN
            dbms_output.put_line('Error: Program ID does not exist.');
        ELSIF v_student_status IS NULL THEN
            dbms_output.put_line('Error: Student status does not exist.');
        END IF;
    WHEN OTHERS THEN
        -- Print the error message
        dbms_output.put_line('Error: ' || sqlerrm);
END;
/

--CREATE SEQUENCE professor_id_seq START WITH 1000 INCREMENT BY 1 NOCACHE NOCYCLE;

CREATE OR REPLACE PROCEDURE insert_professor (
    p_university_professor_number VARCHAR2,
    p_first_name                  VARCHAR2,
    p_last_name                   VARCHAR2,
    p_email                       VARCHAR2,
    p_phone_number                VARCHAR2,
    p_dob                         DATE,
    p_college_name                VARCHAR2,
    p_employment_type             VARCHAR2,
    p_employment_designation      VARCHAR2,
    p_employment_status           VARCHAR2
) AS
    v_professor_id              INT;
    v_college_id                INT;
    v_employment_type_id        INT;
    v_employment_designation_id INT;
    v_employment_status_id      INT;
BEGIN
    -- Generate a new professor ID using the sequence
    --SELECT
    --    professor_id_seq.NEXTVAL
    --INTO v_professor_id
    --FROM
    --    dual;

    -- Validate first name and last name (should not contain numbers)
    IF regexp_like(p_first_name, '[[:digit:]]') THEN
        raise_application_error(-20001, 'First name should not contain numbers.');
    END IF;

    IF regexp_like(p_last_name, '[[:digit:]]') THEN
        raise_application_error(-20002, 'Last name should not contain numbers.');
    END IF;

    -- Validate email format
    IF instr(p_email, '@') = 0 THEN
        raise_application_error(-20003, 'Email address should contain an "@" symbol.');
    END IF;

    -- Retrieve the college ID for the given college name
    BEGIN
        SELECT
            id
        INTO v_college_id
        FROM
            college
        WHERE
            name = p_college_name;

    EXCEPTION
        WHEN no_data_found THEN
            raise_application_error(-20004, 'College name not found: ' || p_college_name);
    END;

    -- Retrieve the employment type ID for the given employment type
    BEGIN
        SELECT
            id
        INTO v_employment_type_id
        FROM
            employment_type
        WHERE
            name = p_employment_type;

    EXCEPTION
        WHEN no_data_found THEN
            raise_application_error(-20005, 'Employment type not found: ' || p_employment_type);
    END;

    -- Retrieve the employment designation ID for the given employment designation
    BEGIN
        SELECT
            id
        INTO v_employment_designation_id
        FROM
            employment_designation
        WHERE
            name = p_employment_designation;

    EXCEPTION
        WHEN no_data_found THEN
            raise_application_error(-20006, 'Employment designation not found: ' || p_employment_designation);
    END;

    -- Retrieve the employment status ID for the given employment status
    BEGIN
        SELECT
            id
        INTO v_employment_status_id
        FROM
            employment_status
        WHERE
            name = p_employment_status;

    EXCEPTION
        WHEN no_data_found THEN
            raise_application_error(-20007, 'Employment status not found: ' || p_employment_status);
    END;

    -- Insert the professor record
    INSERT INTO professor (
        id,
        university_professor_number,
        first_name,
        last_name,
        email,
        phone_number,
        dob,
        college_id,
        employment_type_id,
        employment_designation_id,
        employment_status_id
    ) VALUES (
        (select max(ID)+1 from professor),
        p_university_professor_number,
        p_first_name,
        p_last_name,
        p_email,
        p_phone_number,
        p_dob,
        v_college_id,
        v_employment_type_id,
        v_employment_designation_id,
        v_employment_status_id
    );

    -- Print success message
    dbms_output.put_line('Professor inserted successfully with ID: ' || v_professor_id);
EXCEPTION
    WHEN OTHERS THEN
        -- Print the error message
        dbms_output.put_line('Error: ' || sqlerrm);
END;
/




CREATE OR REPLACE FUNCTION enroll_in_course(
    p_course_crn IN course.crn%TYPE,
    p_university_student_number IN student.university_student_number%TYPE
) RETURN VARCHAR2
AS
    v_student_id student.id%TYPE;
    v_course_id course.id%TYPE;
    v_enrollment_count NUMBER;
    v_seating_capacity course.seating_capacity%TYPE;
BEGIN
    -- Check if the student exists and get the student ID
    SELECT id INTO v_student_id
    FROM student
    WHERE university_student_number = p_university_student_number;

    -- Check if the course exists and get the course ID
    SELECT id INTO v_course_id
    FROM course
    WHERE crn = p_course_crn;

    -- Check for current number of enrollments in the course
    SELECT COUNT(*)
    INTO v_enrollment_count
    FROM student_course
    WHERE course_id = v_course_id;

    -- Check the seating capacity of the course
    SELECT seating_capacity INTO v_seating_capacity
    FROM course
    WHERE id = v_course_id;

    -- Compare current enrollments with seating capacity
    IF v_enrollment_count < v_seating_capacity THEN
        -- Check if the student is already enrolled
        SELECT COUNT(*)
        INTO v_enrollment_count
        FROM student_course
        WHERE student_id = v_student_id
        AND course_id = v_course_id;
        
        IF v_enrollment_count > 0 THEN
            RETURN 'Student is already enrolled in this course.';
        ELSE
            -- Enroll the student in the course
            INSERT INTO student_course (student_id, course_id)
            VALUES (v_student_id, v_course_id);
            RETURN 'Student successfully enrolled in the course.';
        END IF;
    ELSE
        RETURN 'Course is at full capacity.';
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Student or course not found.';
    WHEN OTHERS THEN
        RETURN 'Error enrolling student: ' || SQLERRM;
END;
/









CREATE OR REPLACE FUNCTION Assign_Teaching_Assistant(
    p_professor_email VARCHAR2,
    p_course_id NUMBER,  -- Using course ID directly as per your schema
    p_ta_email VARCHAR2,
    p_start_date DATE,
    p_end_date DATE,
    p_employment_type_id NUMBER,
    p_employment_designation_id NUMBER,
    p_employment_status_id NUMBER,
    p_comments VARCHAR2
) RETURN VARCHAR2
IS
    v_professor_id NUMBER;
    v_ta_id NUMBER;
    v_course_count NUMBER;
BEGIN
    -- Retrieve the professor ID using the email
    SELECT id INTO v_professor_id
    FROM professor
    WHERE email = p_professor_email;

    -- Retrieve the TA ID using the TA email
    SELECT id INTO v_ta_id
    FROM student  -- Assuming TAs are recorded in the student table
    WHERE email = p_ta_email;

    -- Check if the course is taught by the professor
    SELECT COUNT(*)
    INTO v_course_count
    FROM course
    WHERE id = p_course_id AND professor_id = v_professor_id;

    -- If no course matches, return an error message
    IF v_course_count = 0 THEN
        RETURN 'Error: No such course taught by this professor.';
    END IF;

    -- Insert the teaching assistant assignment
    INSERT INTO course_teaching_assistant (
        course_id,
        student_id,
        start_date,
        end_date,
        employment_type_id,
        employment_designation_id,
        employment_status_id,
        comments,
        created_by,
        created_on,
        updated_by,
        updated_on
    ) VALUES (
        p_course_id,
        v_ta_id,
        p_start_date,
        p_end_date,
        p_employment_type_id,
        p_employment_designation_id,
        p_employment_status_id,
        p_comments,
        p_professor_email, -- Using the professor's email as the creator
        SYSDATE,
        p_professor_email, -- Using the professor's email as the updater
        SYSDATE
    );

    -- Return success message
    RETURN 'Teaching assistant assigned successfully.';
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Error: Invalid professor email or TA email.';
    WHEN OTHERS THEN
        -- In case of any exception, return the error
        RETURN 'Error: ' || SQLERRM;
END;
/











CREATE OR REPLACE FUNCTION Enter_Assignment_Marks(
    p_ta_id NUMBER,
    p_course_id NUMBER,
    p_course_assessment_id NUMBER,
    p_student_course_id NUMBER,
    p_marks NUMBER,
    p_comments VARCHAR2
) RETURN VARCHAR2
IS
    v_ta_course_count NUMBER;
BEGIN
    -- Check if the TA is assigned to the course
    SELECT COUNT(*)
    INTO v_ta_course_count
    FROM course_teaching_assistant
    WHERE STUDENT_ID = p_ta_id AND COURSE_ID = p_course_id;

    IF v_ta_course_count = 0 THEN
        RETURN 'Error: TA is not assigned to this course.';
    END IF;
    
    -- Check if the marks are within a valid range (assumed 0 to 100)
    IF p_marks < 0 OR p_marks > 100 THEN
        RETURN 'Error: Marks must be between 0 and 100.';
    END IF;

    -- Enter the marks
    INSERT INTO student_course_mark (
        STUDENT_COURSE_ID,
        COURSE_ASSESSMENT_ID,
        OBTAINED_MARKS,
        COMMENTS,
        CREATED_BY,
        CREATED_ON,
        UPDATED_BY,
        UPDATED_ON
    ) VALUES (
        p_student_course_id,
        p_course_assessment_id,
        p_marks,
        p_comments,
        TO_CHAR(p_ta_id), -- Assuming the TA's ID is being used to track who created/updated the record
        SYSDATE,
        TO_CHAR(p_ta_id),
        SYSDATE
    );

    RETURN 'Marks entered successfully.';
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Error: Invalid TA ID, course ID, or assessment ID.';
    WHEN OTHERS THEN
        RETURN 'Error: ' || SQLERRM;
END;
/


