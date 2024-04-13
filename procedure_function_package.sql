REATE OR REPLACE PROCEDURE create_program (
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

