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

DECLARE
  v_sql CLOB;
BEGIN
  -- Creating the location table
  v_sql := '
    CREATE TABLE ums.location (
        id               NUMBER NOT NULL,
        building_id      NUMBER,
        floor_id         NUMBER,
        room_no          NUMBER,
        location_type_id NUMBER,
        seating_capacity NUMBER,
        created_by       VARCHAR2(15 BYTE),
        created_on       DATE,
        updated_by       VARCHAR2(15 BYTE),
        updated_on       DATE
    )';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('location Table created');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -955 THEN
        DBMS_OUTPUT.PUT_LINE('location Table already exists');
      ELSE
        DBMS_OUTPUT.PUT_LINE('Error creating location Table: ' || SQLERRM);
        RAISE;
      END IF;
  END;

  -- Adding primary key constraint
  v_sql := '
    ALTER TABLE ums.location ADD CONSTRAINT location_pk PRIMARY KEY (id)
  ';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('Primary key CONSTRAINT location_pk added successfully.');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -2260 THEN
        DBMS_OUTPUT.PUT_LINE('Primary key CONSTRAINT location_pk already exists.');
      ELSE
        DBMS_OUTPUT.PUT_LINE('Error adding primary key CONSTRAINT location_pk: ' || SQLERRM);
        RAISE;
      END IF;
  END;
END;
/


DECLARE
  v_sql CLOB;
BEGIN
  -- Create ums.location_type table
  v_sql := '
    CREATE TABLE ums.location_type (
      id           NUMBER NOT NULL,
      name         VARCHAR2(25),
      description  VARCHAR2(100),
      comments     VARCHAR2(100),
      created_by   VARCHAR2(15),
      created_on   DATE,
      updated_by   VARCHAR2(15),
      updated_on   DATE,
      CONSTRAINT location_type_pk PRIMARY KEY (id)
    )';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('Location_Type Table created');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -955 THEN
        DBMS_OUTPUT.PUT_LINE('Location_Type Table already exists');
      ELSE
        RAISE;
      END IF;
  END;

  -- Add primary key constraint to ums.location_type table
  v_sql := '
    ALTER TABLE ums.location_type ADD CONSTRAINT location_type_pk PRIMARY KEY (id)';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('Primary key location_type_pk added successfully');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -2260 THEN
        DBMS_OUTPUT.PUT_LINE('location_type_pk already exists');
      ELSE
        RAISE;
      END IF;
  END;

  -- Create ums.professor table
  v_sql := '
    CREATE TABLE ums.professor (
      id                             NUMBER NOT NULL,
      university_professor_number    VARCHAR2(50),
      first_name                     VARCHAR2(50),
      last_name                      VARCHAR2(50),
      email                          VARCHAR2(50),
      phone_number                   VARCHAR2(20),
      dob                            DATE,
      college_id                     NUMBER,
      employment_type_id             NUMBER,
      employment_designation_id      NUMBER,
      employment_status_id           NUMBER,
      comments                       VARCHAR2(100),
      created_by                     VARCHAR2(50),
      created_on                     DATE,
      updated_by                     VARCHAR2(50),
      updated_on                     DATE,
      CONSTRAINT professor_pk PRIMARY KEY (id)
    )';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('Professor Table created');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -955 THEN
        DBMS_OUTPUT.PUT_LINE('Professor Table already exists');
      ELSE
        RAISE;
      END IF;
  END;

  -- Add primary key constraint to ums.professor table
  v_sql := '
    ALTER TABLE ums.professor ADD CONSTRAINT professor_pk PRIMARY KEY (id)';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('Primary key professor_pk added successfully');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -2260 THEN
        DBMS_OUTPUT.PUT_LINE('professor_pk already exists');
      ELSE
        RAISE;
      END IF;
  END;
END;
/



DECLARE
  v_sql CLOB;
BEGIN
  -- Create ums.program table
  v_sql := '
    CREATE TABLE ums.program (
      id                    NUMBER NOT NULL,
      program_catalog_id    NUMBER,
      term_id               NUMBER,
      program_status_id     NUMBER,
      comments              VARCHAR2(400),
      created_by            VARCHAR2(200),
      created_on            DATE,
      updated_by            VARCHAR2(200),
      updated_on            DATE,
      CONSTRAINT program_pk PRIMARY KEY (id)
    )';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('Program Table created');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -955 THEN
        DBMS_OUTPUT.PUT_LINE('Program Table already exists');
      ELSE
        RAISE;
      END IF;
  END;

  -- Add primary key constraint to ums.program table
  v_sql := '
    ALTER TABLE ums.program ADD CONSTRAINT program_pk PRIMARY KEY (id)';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('Primary key program_pk added successfully');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -2260 THEN
        DBMS_OUTPUT.PUT_LINE('program_pk already exists');
      ELSE
        RAISE;
      END IF;
  END;

  -- Create ums.program_catalog table
  v_sql := '
    CREATE TABLE ums.program_catalog (
      id                 NUMBER NOT NULL,
      name               VARCHAR2(200),
      description        VARCHAR2(150),
      college_id         NUMBER,
      degree_type_id     NUMBER,
      comments           VARCHAR2(400),
      is_enabled         VARCHAR2(1),
      created_by         VARCHAR2(200),
      created_on         DATE,
      updated_by         VARCHAR2(200),
      updated_on         DATE,
      CONSTRAINT program_catalog_pk PRIMARY KEY (id)
    )';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('Program_Catalog Table created');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -955 THEN
        DBMS_OUTPUT.PUT_LINE('Program_Catalog Table already exists');
      ELSE
        RAISE;
      END IF;
  END;

  -- Add primary key constraint to ums.program_catalog table
  v_sql := '
    ALTER TABLE ums.program_catalog ADD CONSTRAINT program_catalog_pk PRIMARY KEY (id)';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('Primary key program_catalog_pk added successfully');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -2260 THEN
        DBMS_OUTPUT.PUT_LINE('program_catalog_pk already exists');
      ELSE
        RAISE;
      END IF;
  END;
END;
/

DECLARE
  v_sql CLOB;
BEGIN
  -- Creating the program_status table
  v_sql := '
    CREATE TABLE ums.program_status (
      id               NUMBER NOT NULL,
      name             VARCHAR2(200),
      description      VARCHAR2(200),
      comments         VARCHAR2(200),
      is_enabled       VARCHAR2(4),
      created_by       VARCHAR2(200),
      created_on       DATE,
      updated_by       VARCHAR2(200),
      updated_on       DATE,
      CONSTRAINT program_status_pk PRIMARY KEY (id)
    )';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('Program_Status Table created');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -955 THEN
        DBMS_OUTPUT.PUT_LINE('Program_Status Table already exists');
      ELSE
        RAISE;
      END IF;
  END;

  -- Adding primary key constraint
  v_sql := '
    ALTER TABLE ums.program_status ADD CONSTRAINT program_status_pk PRIMARY KEY (id)';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('Primary key program_status_pk added successfully');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -2260 THEN
        DBMS_OUTPUT.PUT_LINE('program_status_pk already exists');
      ELSE
        RAISE;
      END IF;
  END;

  -- Here you can add additional blocks if needed
END;
/


DECLARE
  v_sql CLOB;
BEGIN
  v_sql := '
    CREATE TABLE ums.role (
      id            NUMBER NOT NULL,
      name          VARCHAR2(25),
      description   VARCHAR2(200),
      is_enabled    VARCHAR2(2),
      created_by    VARCHAR2(15),
      created_on    DATE,
      updated_by    VARCHAR2(15),
      updated_on    DATE,
      CONSTRAINT role_pk PRIMARY KEY (id)
    )';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('Role Table created');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -955 THEN
        DBMS_OUTPUT.PUT_LINE('Role Table already exists');
      ELSE
        RAISE;
      END IF;
  END;
---- CONSTRAINT role_pk
  v_sql := '
    ALTER TABLE ums.role ADD CONSTRAINT role_pk PRIMARY KEY (id)';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('Primary key role_pk added successfully');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -2260 THEN
        DBMS_OUTPUT.PUT_LINE('role_pk already exists');
      ELSE
        RAISE;
      END IF;
  END;
END;
/


----STUDENT table
DECLARE
  v_sql CLOB;
BEGIN
  v_sql := '
    CREATE TABLE ums.student (
      id                        NUMBER NOT NULL,
      university_student_number VARCHAR2(50),
      first_name                VARCHAR2(30),
      last_name                 VARCHAR2(30),
      student_status_id         NUMBER,
      email                     VARCHAR2(40),
      phone_number              VARCHAR2(15),
      dob                       DATE,
      passport_number           VARCHAR2(10),
      program_id                NUMBER,
      term_id                   NUMBER,
      term_id1                  NUMBER,
      created_by                VARCHAR2(15),
      created_on                DATE,
      updated_by                VARCHAR2(15),
      updated_on                DATE,
      CONSTRAINT student_pk PRIMARY KEY (id)
    )';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('Student Table created');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -955 THEN
        DBMS_OUTPUT.PUT_LINE('Student Table already exists');
      ELSE
        RAISE;
      END IF;
  END;
----CONSTRAINT student_pk
  v_sql := '
    ALTER TABLE ums.student ADD CONSTRAINT student_pk PRIMARY KEY (id)';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('Primary key student_pk added successfully');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -2260 THEN
        DBMS_OUTPUT.PUT_LINE('student_pk already exists');
      ELSE
        RAISE;
      END IF;
  END;
END;
/
-----STUDENT_COURSE




DECLARE
  v_sql CLOB;
BEGIN
  v_sql := '
    CREATE TABLE ums.student_course (
      id                          NUMBER NOT NULL,
      student_id                  NUMBER,
      course_id                   NUMBER,
      student_course_status_id    NUMBER,
      percentage                  NUMBER,
      grade_id                    NUMBER,
      created_by                  VARCHAR2(15),
      created_on                  DATE,
      updated_by                  VARCHAR2(15),
      updated_on                  DATE,
      CONSTRAINT student_course_pk PRIMARY KEY (id)
    )';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('STUDENT_COURSE Table created');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -955 THEN
        DBMS_OUTPUT.PUT_LINE('STUDENT_COURSE Table already exists');
      ELSE
        RAISE;
      END IF;
  END;
END;
/
------ CONSTRAINT student_course_pk
DECLARE
  v_sql CLOB;
BEGIN
  v_sql := '
    ALTER TABLE ums.student_course ADD CONSTRAINT student_course_pk PRIMARY KEY (id)';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('Primary key student_course_pk added successfully');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -2260 THEN
        DBMS_OUTPUT.PUT_LINE('student_course_pk already exists');
      ELSE
        RAISE;
      END IF;
  END;
END;
/







----STUDENT_COURSE_MARK
DECLARE
  v_sql CLOB;
BEGIN
  v_sql := '
    CREATE TABLE ums.student_course_mark (
      id                     NUMBER NOT NULL,
      student_course_id      NUMBER,
      course_assessment_id   NUMBER,
      obtained_marks         NUMBER,
      comments               VARCHAR2(200),
      created_by             VARCHAR2(15),
      created_on             DATE,
      updated_by             VARCHAR2(15),
      updated_on             DATE,
      CONSTRAINT student_course_mark_pk PRIMARY KEY (id)
    )';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('STUDENT_COURSE_MARK Table created');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -955 THEN
        DBMS_OUTPUT.PUT_LINE('STUDENT_COURSE_MARK Table already exists');
      ELSE
        RAISE;
      END IF;
  END;
END;
/

DECLARE
  v_sql CLOB;
BEGIN
  v_sql := '
    ALTER TABLE ums.student_course_mark ADD CONSTRAINT student_course_mark_pk PRIMARY KEY (id)';
----CONSTRAINT student_course_mark_pk
  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('Primary key student_course_mark_pk added successfully');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -2260 THEN
        DBMS_OUTPUT.PUT_LINE('student_course_mark_pk already exists');
      ELSE
        RAISE;
      END IF;
  END;
END;
/

-----STUDENT_COURSE_STATUS


DECLARE
  v_sql CLOB;
BEGIN
  v_sql := '
    CREATE TABLE ums.student_course_status (
      id                 NUMBER NOT NULL,
      name               VARCHAR2(20),
      is_enabled         VARCHAR2(2),
      created_by         VARCHAR2(15),
      created_on         DATE,
      updated_by         VARCHAR2(15),
      updated_on         DATE,
      CONSTRAINT student_course_status_pk PRIMARY KEY (id)
    )';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('STUDENT_COURSE_STATUS Table created');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -955 THEN
        DBMS_OUTPUT.PUT_LINE('STUDENT_COURSE_STATUS Table already exists');
      ELSE
        RAISE;
      END IF;
  END;
----CONSTRAINT student_course_status_pk
  v_sql := '
    ALTER TABLE ums.student_course_status ADD CONSTRAINT student_course_status_pk PRIMARY KEY (id)';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('Primary key student_course_status_pk added successfully');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -2260 THEN
        DBMS_OUTPUT.PUT_LINE('student_course_status_pk already exists');
      ELSE
        RAISE;
      END IF;
  END;
END;
/

----STUDENT_STATUS Table
DECLARE
  v_sql CLOB;
BEGIN
  v_sql := '
    CREATE TABLE ums.student_status (
      id               NUMBER NOT NULL,
      status_name      VARCHAR2(20),
      is_enabled       VARCHAR2(2),
      created_by       VARCHAR2(15),
      created_on       DATE,
      updated_by       VARCHAR2(15),
      updated_on       DATE,
      CONSTRAINT student_status_pk PRIMARY KEY (id)
    )';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('STUDENT_STATUS Table created');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -955 THEN
        DBMS_OUTPUT.PUT_LINE('STUDENT_STATUS Table already exists');
      ELSE
        RAISE;
      END IF;
  END;
----CONSTRAINT student_status_pk
  v_sql := '
    ALTER TABLE ums.student_status ADD CONSTRAINT student_status_pk PRIMARY KEY (id)';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('Primary key student_status_pk added successfully');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -2260 THEN
        DBMS_OUTPUT.PUT_LINE('student_status_pk already exists');
      ELSE
        RAISE;
      END IF;
  END;
END;
/

----TERM Table


DECLARE
  v_sql CLOB;
BEGIN
  v_sql := '
    CREATE TABLE ums.term (
      id           NUMBER NOT NULL,
      name         VARCHAR2(50),
      start_date   DATE,
      end_date     DATE,
      year         NUMBER,
      comments     VARCHAR2(100),
      is_enabled   VARCHAR2(2),
      created_by   VARCHAR2(50),
      created_on   DATE,
      updated_by   VARCHAR2(50),
      updated_on   DATE,
      CONSTRAINT term_pk PRIMARY KEY (id)
    )';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('Term Table created');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -955 THEN
        DBMS_OUTPUT.PUT_LINE('Term Table already exists');
      ELSE
        RAISE;
      END IF;
  END;
----CONSTRAINT term_pk
  v_sql := '
    ALTER TABLE ums.term ADD CONSTRAINT term_pk PRIMARY KEY (id)';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('Primary key term_pk added successfully');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -2260 THEN
        DBMS_OUTPUT.PUT_LINE('term_pk already exists');
      ELSE
        RAISE;
      END IF;
  END;
END;
/


----TABLE USER_MANAGEMENT


DECLARE
  v_sql CLOB;
BEGIN
  v_sql := '
    CREATE TABLE ums.USER_MANAGEMENT (
      id                         NUMBER NOT NULL,
      university_person_number   VARCHAR2(15),
      password                   VARCHAR2(40),
      is_locked                  VARCHAR2(2),
      comments                   VARCHAR2(200),
      created_by                 VARCHAR2(15),
      created_on                 DATE,
      updated_by                 VARCHAR2(15),
      updated_on                 DATE,
      CONSTRAINT user_management_pk PRIMARY KEY (id)
    )';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('USER_MANAGEMENT Table created');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -955 THEN
        DBMS_OUTPUT.PUT_LINE('USER_MANAGEMENT Table already exists');
      ELSE
        RAISE;
      END IF;
  END;
----CONSTRAINT user_management_pk
  v_sql := '
    ALTER TABLE ums.USER_MANAGEMENT ADD CONSTRAINT user_management_pk PRIMARY KEY (id)';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('Primary key user_management_pk added successfully');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -2260 THEN
        DBMS_OUTPUT.PUT_LINE('user_management_pk already exists');
      ELSE
        RAISE;
      END IF;
  END;
END;
/
-----TABLE USER_ROLE
DECLARE
  v_sql CLOB;
BEGIN
  v_sql := '
    CREATE TABLE ums.user_role (
      role_id             NUMBER NOT NULL,
      id                  NUMBER NOT NULL,
      user_management_id  NUMBER NOT NULL,
      CONSTRAINT user_role_pk PRIMARY KEY (id)
    )';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('User_Role Table created');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -955 THEN
        DBMS_OUTPUT.PUT_LINE('User_Role Table already exists');
      ELSE
        RAISE;
      END IF;
  END;
----CONSTRAINT user_role_pk
  v_sql := '
    ALTER TABLE ums.user_role ADD CONSTRAINT user_role_pk PRIMARY KEY (id)';

  BEGIN
    EXECUTE IMMEDIATE v_sql;
    DBMS_OUTPUT.PUT_LINE('Primary key user_role_pk added successfully');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -2260 THEN
        DBMS_OUTPUT.PUT_LINE('user_role_pk already exists');
      ELSE
        RAISE;
      END IF;
  END;
END;
/


