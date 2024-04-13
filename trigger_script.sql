DECLARE
  CURSOR trigger_cursor IS
    SELECT trigger_name
    FROM user_triggers;

BEGIN
  FOR trigger_rec IN trigger_cursor LOOP
    EXECUTE IMMEDIATE 'DROP TRIGGER ' || trigger_rec.trigger_name;
  END LOOP;
END;
/


CREATE OR REPLACE TRIGGER trigger_insert_student_course
BEFORE INSERT ON student_course
FOR EACH ROW
DECLARE
    v_overlap_count INT;
    v_query1_count NUMBER;
    v_query2_count NUMBER;
    v_query3_count NUMBER;
    v_total_credits NUMBER;
    v_seating_capacity NUMBER;
    v_course_credits NUMBER;
    v_term_id NUMBER;
    v_program_catalog_id_course NUMBER;
    v_program_catalog_id_student NUMBER;
BEGIN
    -- Check if percentage is 100 or more
    IF :NEW.PERCENTAGE >= 100 THEN
        RAISE_APPLICATION_ERROR(-20005, 'Percentage should be less than 100.');
    END IF;

    -- Check for schedule overlaps with other enrolled courses
    SELECT COUNT(*)
    INTO v_overlap_count
    FROM student_course sc
    INNER JOIN course_schedule cs_new ON cs_new.COURSE_ID = :NEW.COURSE_ID
    INNER JOIN course_schedule cs_existing ON sc.COURSE_ID = cs_existing.COURSE_ID
    WHERE sc.STUDENT_ID = :NEW.STUDENT_ID
      AND sc.ID <> :NEW.ID
      AND cs_existing.DAY = cs_new.DAY
      AND (
           (cs_existing.START_TIME < cs_new.END_TIME AND cs_existing.END_TIME > cs_new.START_TIME)
        OR (cs_new.START_TIME < cs_existing.END_TIME AND cs_new.END_TIME > cs_existing.START_TIME)
      );

    IF v_overlap_count > 0 THEN
        -- Raise an error if there is any overlap
        RAISE_APPLICATION_ERROR(-20006, 'Enrollment failed: Course times overlap with another enrolled course.');
    END IF;

    -- Check if student is already enrolled in the same course and not failed
    SELECT COUNT(sc.ID) INTO v_query1_count
    FROM STUDENT_COURSE sc
    WHERE sc.STUDENT_ID = :NEW.STUDENT_ID
      AND sc.COURSE_ID = :NEW.COURSE_ID;

    SELECT COUNT(sc.ID) INTO v_query2_count
    FROM STUDENT_COURSE sc
    WHERE sc.STUDENT_ID = :NEW.STUDENT_ID
      AND sc.COURSE_ID = :NEW.COURSE_ID
      AND sc.STUDENT_COURSE_STATUS_ID = 6; -- Assuming 6 is the status code for 'failed'

    IF v_query1_count <> 0 AND v_query2_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Student can only re-enroll in a course if they have previously failed it.');
    END IF;

    -- Check if course seating capacity has been reached
    SELECT COUNT(*) INTO v_query3_count
    FROM STUDENT_COURSE
    WHERE COURSE_ID = :NEW.COURSE_ID
      AND STUDENT_COURSE_STATUS_ID = 1; -- Assuming 1 is the status code for 'active'

    SELECT SEATING_CAPACITY INTO v_seating_capacity
    FROM COURSE
    WHERE ID = :NEW.COURSE_ID;

    IF v_query3_count >= v_seating_capacity THEN
        RAISE_APPLICATION_ERROR(-20003, 'Course is already full. Student cannot enroll.');
    END IF;

    -- Check if course is within the student's program
    SELECT cc.PROGRAM_CATALOG_ID INTO v_program_catalog_id_course
    FROM COURSE c
    JOIN COURSE_CATALOG cc ON c.COURSE_CATALOG_ID = cc.ID
    WHERE c.ID = :NEW.COURSE_ID;

    SELECT p.PROGRAM_CATALOG_ID INTO v_program_catalog_id_student
    FROM STUDENT s
    JOIN PROGRAM p ON s.PROGRAM_ID = p.ID
    WHERE s.ID = :NEW.STUDENT_ID;

    IF v_program_catalog_id_course <> v_program_catalog_id_student THEN
        RAISE_APPLICATION_ERROR(-20004, 'Student can only enroll for courses offered by their program.');
    END IF;

    -- Check total credits for the term do not exceed limit
    SELECT term_id INTO v_term_id
    FROM course
    WHERE ID = :NEW.COURSE_ID;

    SELECT SUM(cc.CREDITS) INTO v_total_credits
    FROM STUDENT_COURSE sc
    JOIN COURSE c ON sc.COURSE_ID = c.ID
    JOIN TERM t ON c.TERM_ID = t.ID
    JOIN COURSE_CATALOG cc ON c.COURSE_CATALOG_ID = cc.ID
    WHERE sc.STUDENT_ID = :NEW.STUDENT_ID
      AND sc.STUDENT_COURSE_STATUS_ID = 1 -- Active courses
      AND t.ID = v_term_id 
      AND t.IS_ENABLED = 'Y';

    SELECT cc.CREDITS INTO v_course_credits
    FROM COURSE c
    JOIN COURSE_CATALOG cc ON c.COURSE_CATALOG_ID = cc.ID
    WHERE c.ID = :NEW.COURSE_ID AND ROWNUM = 1;

    IF v_total_credits + v_course_credits > 8 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Student cannot enroll for more than 8 credits in a term.');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trigger_course_schedule_checks
BEFORE INSERT OR UPDATE ON course_schedule
FOR EACH ROW
DECLARE
    v_location_seating_capacity NUMBER;
    v_course_seating_capacity NUMBER;
    v_overlap_count NUMBER;
    v_course_count NUMBER;
    v_professor_id NUMBER;
    v_term_id NUMBER;
BEGIN
    -- Retrieve seating capacities
    SELECT seating_capacity INTO v_course_seating_capacity FROM course WHERE id = :NEW.course_id;
    SELECT seating_capacity INTO v_location_seating_capacity FROM location WHERE id = :NEW.location_id;

    -- Check if the location's seating capacity is sufficient
    IF v_course_seating_capacity > v_location_seating_capacity THEN
        RAISE_APPLICATION_ERROR(-20008, 'Course seating capacity exceeds location seating capacity.');
    END IF;

    -- Check for overlapping course schedules
    SELECT COUNT(*)
    INTO v_overlap_count
    FROM course_schedule
    WHERE course_id = :NEW.course_id
      AND day = :NEW.day
      AND (
           (:NEW.start_time < end_time AND :NEW.end_time > start_time)
        OR (start_time < :NEW.end_time AND end_time > :NEW.start_time)
      )
      AND id != :NEW.id;

    IF v_overlap_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Professor already has a class scheduled for this time slot on the same day.');
    END IF;

    -- Retrieve professor ID and term ID for the course
    SELECT professor_id, term_id INTO v_professor_id, v_term_id FROM course WHERE id = :NEW.course_id;

    -- Check how many courses the professor is currently assigned to for the term
    SELECT COUNT(*)
    INTO v_course_count
    FROM course
    WHERE professor_id = v_professor_id
      AND term_id = v_term_id
      AND id != :NEW.course_id; -- Exclude the current course in update scenarios

    IF v_course_count >= 2 THEN  -- Assuming 2 is the limit
        RAISE_APPLICATION_ERROR(-20007, 'Professor cannot teach more than two courses in the same semester.');
    END IF;
END;
/



CREATE OR REPLACE TRIGGER trigger_before_insert_ta
BEFORE INSERT ON ums.COURSE_TEACHING_ASSISTANT
FOR EACH ROW
DECLARE
  v_course_term_id NUMBER;
  v_count_ta_courses NUMBER;
  v_passed_course_count NUMBER;
BEGIN
  -- Check if the student has passed the course
  SELECT COUNT(*)
  INTO v_passed_course_count
  FROM STUDENT_COURSE sc
  JOIN COURSE c ON sc.COURSE_ID = c.ID
  WHERE sc.STUDENT_ID = :NEW.STUDENT_ID
  AND c.COURSE_CATALOG_ID = (SELECT COURSE_CATALOG_ID FROM COURSE WHERE ID = :NEW.COURSE_ID)
  AND sc.STUDENT_COURSE_STATUS_ID = (SELECT ID FROM STUDENT_COURSE_STATUS WHERE NAME = 'Passed');

  IF v_passed_course_count = 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'The student must have passed the course to become a TA.');
  END IF;

  -- Check if the student is already a TA for two courses in the same semester
  SELECT TERM_ID INTO v_course_term_id FROM COURSE WHERE ID = :NEW.COURSE_ID;
  
  SELECT COUNT(*)
  INTO v_count_ta_courses
  FROM COURSE_TEACHING_ASSISTANT cta
  JOIN COURSE c ON cta.COURSE_ID = c.ID
  WHERE cta.STUDENT_ID = :NEW.STUDENT_ID
  AND c.TERM_ID = v_course_term_id;

  IF v_count_ta_courses >= 2 THEN
    RAISE_APPLICATION_ERROR(-20002, 'A student cannot be a TA for more than two courses in the same semester.');
  END IF;
  
  SELECT COUNT(*)
  INTO v_count_ta_courses
  FROM COURSE_TEACHING_ASSISTANT cta
  JOIN COURSE c ON cta.COURSE_ID = c.ID
  WHERE cta.STUDENT_ID = :NEW.STUDENT_ID and cta.course_id=:NEW.Course_ID
  AND c.TERM_ID = v_course_term_id;
  
  IF v_count_ta_courses >= 1 THEN
    RAISE_APPLICATION_ERROR(-20003, 'no duplicate record of the same TA in same semester is allowed.');
  END IF;
END;
/


CREATE OR REPLACE TRIGGER trigger_professor_course_college_validation
BEFORE INSERT OR UPDATE ON ums.course
FOR EACH ROW
DECLARE
  v_college_id_professor NUMBER;
  v_college_id_course    NUMBER;
BEGIN
  -- Retrieve the college ID of the professor
  SELECT college_id INTO v_college_id_professor
  FROM ums.professor
  WHERE id = :NEW.professor_id;
  
  -- Retrieve the college ID of the course through the course_catalog and program_catalog
  SELECT pc.college_id INTO v_college_id_course
  FROM ums.course_catalog cc
  JOIN ums.program_catalog pc ON cc.program_catalog_id = pc.id
  WHERE cc.id = :NEW.course_catalog_id;
  
  -- Compare the college IDs
  IF v_college_id_professor != v_college_id_course THEN
    RAISE_APPLICATION_ERROR(-20003, 'Professors can only teach courses offered by their college.');
  END IF;
  
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20004, 'Invalid professor ID or course catalog ID.');
END;
/


