DECLARE
  v_sql VARCHAR2(200);
BEGIN
  FOR view_rec IN (SELECT view_name FROM user_views) LOOP
    v_sql := 'DROP VIEW ' || view_rec.view_name;
    EXECUTE IMMEDIATE v_sql;
  END LOOP;
END;
/

-- This view is designed to provide comprehensive information about university students.

-- The view is named 'student_information_view'.
-- The SELECT statement retrieves specific columns from various tables to compose the view.

CREATE VIEW student_information_view AS
SELECT 
    student.university_student_number AS "University Student Number", 
    student.first_name AS "First Name", 
    student.last_name AS "Last Name", 
    student.passport_number AS "Passport Number",
    term.name AS "TERM",  
    program_catalog.name AS "PROGRAM", 
    degree_type.name AS "PROGRAM_LEVEL", 
    student_status.status_name AS "Student Status"
FROM 
    program
    JOIN program_catalog ON program.program_catalog_id = program_catalog.id 
    JOIN degree_type ON program_catalog.degree_type_id = degree_type.id 
    JOIN term ON program.term_id = term.id
    JOIN student ON student.program_id = program.id 
    JOIN student_status ON student.student_status_id = student_status.id;

-- This view is intended to provide information about course enrollments for students.

-- The view is named 'course_enrollment_view'.

CREATE VIEW course_enrollment_view AS
SELECT 
    student.university_student_number, 
    student.first_name, 
    student.last_name, 
    term.name AS term_name,
    course_catalog.course_name, 
    student_course.percentage, 
    grade.name AS grade_name
FROM 
    student
    JOIN student_course ON student.id = student_course.student_id
    JOIN course ON student_course.course_id = course.id
    JOIN course_catalog ON course.course_catalog_id = course_catalog.id
    JOIN term ON course.term_id = term.id
    JOIN grade ON student_course.grade_id = grade.id;

-- This view is designed to provide statistics on course enrollments.

-- The view is named 'course_statistics_view'.

CREATE VIEW course_statistics_view AS
SELECT 
    course_catalog.course_name, 
    COUNT(student_course.id) AS enrollment_count, 
    MAX(student_course.percentage) AS highest_percentage, 
    MIN(student_course.percentage) AS lowest_percentage,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY student_course.percentage) AS median_percentage
FROM 
    student_course
JOIN 
    course ON student_course.course_id = course.id 
JOIN 
    course_catalog ON course.course_catalog_id = course_catalog.id 
WHERE 
    student_course.student_course_status_id = 5 
GROUP BY 
    course_catalog.course_name;

-- This view is intended to summarize the enrollment information for each term.

-- The view is named 'term_enrollment_summary_view'.

CREATE VIEW term_enrollment_summary_view AS
SELECT 
    term.name AS "Term Name",
    COUNT(student.id) AS "Number of Students"
FROM 
    student
JOIN 
    term ON student.term_id = term.id
GROUP BY 
    term.name;

-- This view provides an overview of grades for student courses.

-- The view is named 'grade_overview'.
CREATE VIEW grade_overview AS
SELECT
    sc.id AS student_course_id,
    s.id AS student_id,
    s.first_name || ' ' || s.last_name AS student_name,
    c.id AS course_id,
    c.course_catalog_id,
    c.crn,
    g.name AS grade_name,
    sc.percentage
FROM
    ums.student_course sc
JOIN
    ums.student s ON sc.student_id = s.id
JOIN
    ums.course c ON sc.course_id = c.id
LEFT JOIN
    ums.grade g ON sc.grade_id = g.id;

-- This view is designed to provide a schedule overview for professors, listing the courses they teach.

-- The view is named 'professor_teaching_schedule_view'.

CREATE VIEW professor_teaching_schedule_view AS
SELECT
    cs.id AS course_schedule_id,
    cc.course_name,
    t.name AS term_name,
    cs.day,
    TO_CHAR(cs.start_time, 'HH24:MI') AS start_time,
    TO_CHAR(cs.end_time, 'HH24:MI') AS end_time,
    l.building_id,
    l.floor_id,
    l.room_no,
    p.first_name || ' ' || p.last_name AS professor_name
FROM
    ums.course_schedule cs
JOIN
    ums.course c ON cs.course_id = c.id
JOIN
    ums.term t ON c.term_id = t.id
JOIN
    ums.location l ON cs.location_id = l.id
JOIN
    ums.professor p ON c.professor_id = p.id
JOIN
    ums.course_catalog cc ON c.course_catalog_id = cc.id;

-- This view combines various tables to provide detailed information about courses, their locations, and assigned professors.

-- The view is named 'full_course_detail_view'.

CREATE OR REPLACE VIEW full_course_detail_view AS
SELECT
    location.id AS location_id,
    building.name AS building,
    floor.name AS floor,
    location.room_no AS room_no,
    location_type.name AS location_type,
    course_catalog.course_name AS course_name,
    professor.first_name || ' ' || professor.last_name AS professor_name
FROM
    location
JOIN building ON building.id = location.building_id
JOIN floor ON floor.id = location.floor_id
JOIN location_type ON location_type.id = location.location_type_id
JOIN course_schedule ON course_schedule.location_id = location.id
JOIN course ON course_schedule.course_id = course.id
JOIN course_catalog ON course.course_catalog_id = course_catalog.id
JOIN professor ON professor.id = course.professor_id;

-- This view is designed to provide a student transcript, including details of courses taken, grades received, and other relevant information.

-- The view is named 'student_transcript_view'.

CREATE OR REPLACE VIEW student_transcript_view AS
SELECT
    student.first_name || ' ' || student.last_name AS student_name,
    course_catalog.course_name,
    course.crn,
    course_catalog.credits,
    grade.name,
    professor.first_name || ' ' || professor.last_name AS professor_name,
    term.name AS term,
    student_course_status.name AS outcome
FROM
    student_course
JOIN student ON student.id = student_course.student_id
JOIN course ON course.id = student_course.course_id
JOIN grade ON grade.id = student_course.grade_id
JOIN professor ON professor.id = course.professor_id
JOIN course_catalog ON course_catalog.id = course.course_catalog_id
JOIN term ON term.id = course.term_id
JOIN student_course_status ON student_course_status.id = student_course.student_course_status_id
ORDER BY
    student.first_name;

-- This view is designed to provide information about courses offered in a specific term.

-- The view is named 'course_offered_in_term_view'.

CREATE OR REPLACE VIEW course_offered_in_term_view AS
SELECT
    cc.course_name,
    cc.description,
    c.crn,
    t.name AS term_name,
    t.start_date,
    t.end_date
FROM
    course_catalog cc
RIGHT JOIN course c ON c.course_catalog_id = cc.id
JOIN term t ON t.id = c.term_id
WHERE
    t.name = 'Spring 2023';

commit;

