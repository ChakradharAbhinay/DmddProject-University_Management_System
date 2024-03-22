--DDL script 
DECLARE
  v_sql CLOB;
  ----to create Table administrator
BEGIN
  ------------------administrator 
  v_sql := '
    CREATE TABLE ums.administrator (
        id                              NUMBER NOT NULL,
        university_administrator_number NUMBER,
        first_name                      VARCHAR2(25 BYTE),
        last_name                       VARCHAR2(25 BYTE),
        email                           VARCHAR2(50 BYTE),
        phone_number                    VARCHAR2(15 BYTE),
        dob                             DATE,
        passport_number                 VARCHAR2(10 BYTE),
        employment_type_id              NUMBER(*, 0),
        employment_designation_id       NUMBER(*, 0),
        employment_status_id            NUMBER(*, 0),
        comments                        VARCHAR2(200 BYTE),
        created_by                      VARCHAR2(15 BYTE),
        created_on                      DATE,
        updated_by                      VARCHAR2(15 BYTE),
        updated_on                      DATE
    )';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('administrator table created');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -955 THEN
        DBMS_OUTPUT.PUT_LINE('administrator table already exists');
      ELSE
        RAISE;
      END IF;
  END;

  -- Add primary key constraint for administrator table
  v_sql := '
    ALTER TABLE ums.administrator ADD CONSTRAINT administrator_pk PRIMARY KEY (id)
  ';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('Primary key CONSTRAINT administrator_pk added successfully.');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -2260 THEN
        DBMS_OUTPUT.PUT_LINE('Primary key CONSTRAINT administrator_pk already exists.');
      ELSE
        RAISE;
      END IF;
  END;

  -- Create building table
  v_sql := '
    CREATE TABLE ums.building (
        id          NUMBER NOT NULL,
        name        VARCHAR2(25 BYTE),
        description VARCHAR2(25 BYTE),
        comments    VARCHAR2(25 BYTE),
        created_by  VARCHAR2(15 BYTE),
        created_on  DATE,
        updated_by  VARCHAR2(15 BYTE),
        updated_on  DATE
    )';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('building Table created');
  EXCEPTION
    WHEN OTHERS THEN
    IF SQLCODE = -955 THEN
      DBMS_OUTPUT.PUT_LINE('building Table already exists');
    ELSE
      RAISE;
    END IF;
  END;

  -- Add primary key constraint for building table
  v_sql := '
    ALTER TABLE ums.building ADD CONSTRAINT building_pk PRIMARY KEY (id)
  ';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('Primary key CONSTRAINT building_pk added successfully.');
  EXCEPTION
    WHEN OTHERS THEN
    IF SQLCODE = -2260 THEN
      DBMS_OUTPUT.PUT_LINE('Primary key CONSTRAINT building_pk already exists.');
    ELSE
      RAISE;
    END IF;
  END;
END;
/

DECLARE
  v_sql CLOB;
BEGIN
  ------------------college 
  v_sql := '
    CREATE TABLE ums.college (
        id          NUMBER NOT NULL,
        name        VARCHAR2(50 BYTE),
        description VARCHAR2(50 BYTE),
        is_enabled  VARCHAR2(2 BYTE),
        created_by  VARCHAR2(50 BYTE),
        created_on  DATE,
        updated_by  VARCHAR2(50 BYTE),
        updated_on  DATE
    )';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('college Table created');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -955 THEN
        DBMS_OUTPUT.PUT_LINE('college Table already exists');
      ELSE
        RAISE;
      END IF;
  END;

  -- Add primary key constraint for college table
  v_sql := '
    ALTER TABLE ums.college ADD CONSTRAINT college_pk PRIMARY KEY (id)
  ';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('Primary key CONSTRAINT college_pk added successfully.');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -2260 THEN
        DBMS_OUTPUT.PUT_LINE('Primary key CONSTRAINT college_pk already exists.');
      ELSE
        RAISE;
      END IF;
  END;

  -----------course
  v_sql := '
    CREATE TABLE ums.course (
        id                NUMBER NOT NULL,
        course_catalog_id NUMBER,
        crn               NUMBER,
        term_id           NUMBER,
        seating_capacity  NUMBER,
        professor_id      NUMBER,
        created_by        VARCHAR2(15 BYTE),
        created_on        DATE,
        updated_by        VARCHAR2(15 BYTE),
        updated_on        DATE
    )';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('course Table created');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -955 THEN
        DBMS_OUTPUT.PUT_LINE('course Table already exists');
      ELSE
        RAISE;
      END IF;
  END;

  -----------------------CONSTRAINT course_pk
  v_sql := '
    ALTER TABLE ums.course ADD CONSTRAINT course_pk PRIMARY KEY (id)
  ';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('Primary key CONSTRAINT course_pk added successfully.');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -2260 THEN
        DBMS_OUTPUT.PUT_LINE('Primary key CONSTRAINT course_pk already exists.');
      ELSE
        RAISE;
      END IF;
  END;
END;
/



----------------course_assessment
DECLARE
  v_sql CLOB;
BEGIN
  v_sql := '
    CREATE TABLE ums.course_assessment (
        id          NUMBER NOT NULL,
        course_id   NUMBER,
        name        VARCHAR2(20 BYTE),
        weightage   NUMBER,
        total_marks NUMBER,
        comments    VARCHAR2(200 BYTE),
        created_by  VARCHAR2(15 BYTE),
        created_on  DATE,
        updated_by  VARCHAR2(15 BYTE),
        updated_on  DATE
    )';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('course_assessment Table created');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -955 THEN
        DBMS_OUTPUT.PUT_LINE('course_assessment Table already exists');
      ELSE
        RAISE;
      END IF;
  END;
END;
/

--------------------CONSTRAINT course_assessment_pk
DECLARE
  v_sql CLOB;
BEGIN
  v_sql := '
    ALTER TABLE ums.course_assessment ADD CONSTRAINT course_assessment_pk PRIMARY KEY (id)
  ';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('Primary key CONSTRAINT course_assessment_pk added successfully.');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -2260 THEN
        DBMS_OUTPUT.PUT_LINE('Primary key CONSTRAINT course_assessment_pk already exists.');
      ELSE
        RAISE;
      END IF;
  END;
END;
/

--------------------course_catalog
DECLARE
  v_sql CLOB;
BEGIN
  v_sql := '
    CREATE TABLE ums.course_catalog (
        id                 NUMBER NOT NULL,
        course_code        VARCHAR2(50 BYTE),
        course_name        VARCHAR2(50 BYTE),
        description        VARCHAR2(100 BYTE),
        credits            NUMBER,
        program_catalog_id NUMBER,
        comments           VARCHAR2(100 BYTE),
        is_enabled         VARCHAR2(1 BYTE),
        created_by         VARCHAR2(50 BYTE),
        created_on         DATE,
        updated_by         VARCHAR2(50 BYTE),
        updated_on         DATE
    )';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('course_catalog Table created');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -955 THEN
        DBMS_OUTPUT.PUT_LINE('course_catalog Table already exists');
      ELSE
        RAISE;
      END IF;
  END;
END;
/

----------ADD CONSTRAINT course_catalog_pk
DECLARE
  v_sql CLOB;
BEGIN
  v_sql := '
    ALTER TABLE ums.course_catalog ADD CONSTRAINT course_catalog_pk PRIMARY KEY (id)
  ';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('Primary key CONSTRAINT course_catalog_pk added successfully.');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -2260 THEN
        DBMS_OUTPUT.PUT_LINE('Primary key CONSTRAINT course_catalog_pk already exists.');
      ELSE
        RAISE;
      END IF;
  END;
END;
/

---------------course_schedule
DECLARE
  v_sql CLOB;
BEGIN
  v_sql := '
    CREATE TABLE ums.course_schedule (
        id          NUMBER NOT NULL,
        course_id   NUMBER,
        day         VARCHAR2(10 BYTE),
        start_time  TIMESTAMP,
        end_time    TIMESTAMP,
        location_id NUMBER,
        created_by  VARCHAR2(15 BYTE),
        created_on  DATE,
        updated_by  VARCHAR2(15 BYTE),
        updated_on  DATE
    )';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('course_schedule Table created');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -955 THEN
        DBMS_OUTPUT.PUT_LINE('course_schedule Table already exists');
      ELSE
        RAISE;
      END IF;
  END;
END;
/

------------------CONSTRAINT course_schedule_pk
DECLARE
  v_sql CLOB;
BEGIN
  v_sql := '
    ALTER TABLE ums.course_schedule ADD CONSTRAINT course_schedule_pk PRIMARY KEY (id)
  ';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('Primary key CONSTRAINT course_schedule_pk added successfully.');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -2260 THEN
        DBMS_OUTPUT.PUT_LINE('Primary key CONSTRAINT course_schedule_pk already exists.');
      ELSE
        RAISE;
      END IF;
  END;
END;
/



------------------course_teaching_assistant

DECLARE
  v_sql CLOB;
BEGIN
  v_sql := '
    CREATE TABLE ums.course_teaching_assistant (
        id                        NUMBER NOT NULL,
        course_id                 NUMBER,
        student_id                NUMBER,
        start_date                DATE,
        end_date                  DATE,
        employment_type_id        NUMBER,
        employment_designation_id NUMBER,
        employment_status_id      NUMBER,
        comments                  VARCHAR2(200 BYTE),
        created_by                VARCHAR2(15 BYTE),
        created_on                DATE,
        updated_by                VARCHAR2(15 BYTE),
        updated_on                DATE
    )';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('course_teaching_assistant Table created');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -955 THEN
        DBMS_OUTPUT.PUT_LINE('course_teaching_assistant Table already exists');
      ELSE
        RAISE;
      END IF;
  END;
END;
/

------------------------CONSTRAINT course_teaching_assistant_pk

DECLARE
  v_sql CLOB;
BEGIN
  v_sql := '
    ALTER TABLE ums.course_teaching_assistant ADD CONSTRAINT course_teaching_assistant_pk PRIMARY KEY (id)
  ';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('Primary key CONSTRAINT course_teaching_assistant_pk added successfully.');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -2260 THEN
        DBMS_OUTPUT.PUT_LINE('Primary key CONSTRAINT course_teaching_assistant_pk already exists.');
      ELSE
        RAISE;
      END IF;
  END;
END;
/

-----------------------------------------degree_type

DECLARE
  v_sql CLOB;
BEGIN
  v_sql := '
    CREATE TABLE ums.degree_type (
        id          NUMBER NOT NULL,
        name        VARCHAR2(50 BYTE),
        description VARCHAR2(50 BYTE),
        is_enabled  VARCHAR2(1 BYTE),
        created_by  VARCHAR2(50 BYTE),
        created_on  DATE,
        updated_by  VARCHAR2(50 BYTE),
        updated_on  DATE
    )';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('degree_type Table created');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -955 THEN
        DBMS_OUTPUT.PUT_LINE('degree_type Table already exists');
      ELSE
        RAISE;
      END IF;
  END;
END;
/

-------------------------CONSTRAINT degree_type_pk 

DECLARE
  v_sql CLOB;
BEGIN
  v_sql := '
    ALTER TABLE ums.degree_type ADD CONSTRAINT degree_type_pk PRIMARY KEY (id)
  ';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('Primary key CONSTRAINT degree_type_pk added successfully.');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -2260 THEN
        DBMS_OUTPUT.PUT_LINE('Primary key CONSTRAINT degree_type_pk already exists.');
      ELSE
        RAISE;
      END IF;
  END;
END;
/

-------------------------employment_designation
DECLARE
  v_sql CLOB;
BEGIN
  v_sql := '
    CREATE TABLE ums.employment_designation (
        id                  NUMBER NOT NULL,
        name                VARCHAR2(50 BYTE),
        employment_grade_id NUMBER,
        description         VARCHAR2(50 BYTE),
        comments            VARCHAR2(100 BYTE),
        is_enabled          VARCHAR2(1 BYTE),
        created_by          VARCHAR2(50 BYTE),
        created_on          DATE,
        updated_by          VARCHAR2(50 BYTE),
        updated_on          DATE
    )';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('employment_designation Table created');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -955 THEN
        DBMS_OUTPUT.PUT_LINE('employment_designation Table already exists');
      ELSE
        RAISE;
      END IF;
  END;
END;
/

------------------------CONSTRAINT employment_designation_pk

DECLARE
  v_sql CLOB;
BEGIN
  v_sql := '
    ALTER TABLE ums.employment_designation ADD CONSTRAINT employment_designation_pk PRIMARY KEY (id)
  ';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('Primary key CONSTRAINT employment_designation_pk added successfully.');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -2260 THEN
        DBMS_OUTPUT.PUT_LINE('Primary key CONSTRAINT employment_designation_pk already exists.');
      ELSE
        RAISE;
      END IF;
  END;
END;
/

------------------------employment_grade

DECLARE
  v_sql CLOB;
BEGIN
  v_sql := '
    CREATE TABLE ums.employment_grade (
        id          NUMBER NOT NULL,
        name        VARCHAR2(50 BYTE),
        description VARCHAR2(50 BYTE),
        comments    VARCHAR2(100 BYTE),
        is_enabled  VARCHAR2(1 BYTE),
        created_by  VARCHAR2(50 BYTE),
        created_on  DATE,
        updated_by  VARCHAR2(50 BYTE),
        updated_on  DATE
    )';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('employment_grade Table created');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -955 THEN
        DBMS_OUTPUT.PUT_LINE('employment_grade Table already exists');
      ELSE
        RAISE;
      END IF;
  END;
END;
/

-------------------------CONSTRAINT employment_grade_pk

DECLARE
  v_sql CLOB;
BEGIN
  v_sql := '
    ALTER TABLE ums.employment_grade ADD CONSTRAINT employment_grade_pk PRIMARY KEY (id)
  ';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('Primary key CONSTRAINT employment_grade_pk added successfully.');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -2260 THEN
        DBMS_OUTPUT.PUT_LINE('Primary key CONSTRAINT employment_grade_pk already exists.');
      ELSE
        RAISE;
      END IF;
  END;
END;
/



-------------------------employment_status
DECLARE
  v_sql_emp_status CLOB;
BEGIN
  v_sql_emp_status := '
    CREATE TABLE ums.employment_status (
        id         NUMBER(*, 0) NOT NULL,
        name       VARCHAR2(50 BYTE),
        is_enabled VARCHAR2(2 BYTE),
        comments   VARCHAR2(100 BYTE),
        created_by VARCHAR2(50 BYTE),
        created_on DATE,
        updated_by VARCHAR2(50 BYTE),
        updated_on DATE
    )';

  BEGIN
    EXECUTE IMMEDIATE v_sql_emp_status;
    DBMS_OUTPUT.PUT_LINE('employment_status Table created');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -955 THEN
        DBMS_OUTPUT.PUT_LINE('employment_status Table already exists');
      ELSE
        RAISE;
      END IF;
  END;
END;
/

---------------------CONSTRAINT employment_status_pk
DECLARE
  v_sql_emp_status_pk CLOB;
BEGIN
  v_sql_emp_status_pk := '
    ALTER TABLE ums.employment_status ADD CONSTRAINT employment_status_pk PRIMARY KEY (id)
  ';

  BEGIN
    EXECUTE IMMEDIATE v_sql_emp_status_pk;
    DBMS_OUTPUT.PUT_LINE('Primary key CONSTRAINT employment_status_pk added successfully.');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -2260 THEN
        DBMS_OUTPUT.PUT_LINE('Primary key CONSTRAINT employment_status_pk already exists.');
      ELSE
        RAISE;
      END IF;
  END;
END;
/

-------------------------------employment_type
DECLARE
  v_sql_emp_type CLOB;
BEGIN
  v_sql_emp_type := '
    CREATE TABLE ums.employment_type (
        id         NUMBER(*, 0) NOT NULL,
        name       VARCHAR2(50 BYTE),
        is_enabled VARCHAR2(2 BYTE),
        comments   VARCHAR2(100 BYTE),
        created_by VARCHAR2(50 BYTE),
        created_on DATE,
        updated_by VARCHAR2(50 BYTE),
        updated_on DATE
    )';

  BEGIN
    EXECUTE IMMEDIATE v_sql_emp_type;
    DBMS_OUTPUT.PUT_LINE('employment_type Table created');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -955 THEN
        DBMS_OUTPUT.PUT_LINE('employment_type Table already exists');
      ELSE
        RAISE;
      END IF;
  END;
END;
/

------------CONSTRAINT employment_type_pk
DECLARE
  v_sql_emp_type_pk CLOB;
BEGIN
  v_sql_emp_type_pk := '
    ALTER TABLE ums.employment_type ADD CONSTRAINT employment_type_pk PRIMARY KEY (id)
  ';

  BEGIN
    EXECUTE IMMEDIATE v_sql_emp_type_pk;
    DBMS_OUTPUT.PUT_LINE('Primary key CONSTRAINT employment_type_pk added successfully.');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -2260 THEN
        DBMS_OUTPUT.PUT_LINE('Primary key CONSTRAINT employment_type_pk already exists.');
      ELSE
        RAISE;
      END IF;
  END;
END;
/

--------------floor
DECLARE
  v_sql_floor CLOB;
BEGIN
  v_sql_floor := '
    CREATE TABLE ums.floor (
        id         NUMBER NOT NULL,
        name       VARCHAR2(25 BYTE),
        created_by VARCHAR2(15 BYTE),
        created_on DATE,
        updated_by VARCHAR2(15 BYTE),
        updated_on DATE
    )';

  BEGIN
    EXECUTE IMMEDIATE v_sql_floor;
    DBMS_OUTPUT.PUT_LINE('floor Table created');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -955 THEN
        DBMS_OUTPUT.PUT_LINE('floor Table already exists');
      ELSE
        RAISE;
      END IF;
  END;
END;
/

---------------------------CONSTRAINT floor_pk
DECLARE
  v_sql_floor_pk CLOB;
BEGIN
  v_sql_floor_pk := '
    ALTER TABLE ums.floor ADD CONSTRAINT floor_pk PRIMARY KEY (id)
  ';

  BEGIN
    EXECUTE IMMEDIATE v_sql_floor_pk;
    DBMS_OUTPUT.PUT_LINE('Primary key CONSTRAINT floor_pk added successfully.');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -2260 THEN
        DBMS_OUTPUT.PUT_LINE('Primary key CONSTRAINT floor_pk already exists.');
      ELSE
        RAISE;
      END IF;
  END;
END;
/

---------------------------grade
DECLARE
  v_sql_grade CLOB;
BEGIN
  v_sql_grade := '
    CREATE TABLE ums.grade (
        id         NUMBER NOT NULL,
        name       VARCHAR2(20 BYTE),
        comments   VARCHAR2(50 BYTE),
        is_enabled VARCHAR2(2 BYTE),
        created_by VARCHAR2(15 BYTE),
        created_on DATE,
        updated_by VARCHAR2(15 BYTE),
        updated_on DATE
    )';

  BEGIN
    EXECUTE IMMEDIATE v_sql_grade;
    DBMS_OUTPUT.PUT_LINE('grade Table created');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -955 THEN
        DBMS_OUTPUT.PUT_LINE('grade Table already exists');
      ELSE
        RAISE;
      END IF;
  END;
END;
/

-----------------CONSTRAINT grade_pk
DECLARE
  v_sql_grade_pk CLOB;
BEGIN
  v_sql_grade_pk := '
    ALTER TABLE ums.grade ADD CONSTRAINT grade_pk PRIMARY KEY (id)
  ';

  BEGIN
    EXECUTE IMMEDIATE v_sql_grade_pk;
    DBMS_OUTPUT.PUT_LINE('Primary key CONSTRAINT grade_pk added successfully.');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -2260 THEN
        DBMS_OUTPUT.PUT_LINE('Primary key CONSTRAINT grade_pk already exists.');
      ELSE
        RAISE;
      END IF;
  END;
END;
/


