DECLARE
  v_sql VARCHAR2(200);
BEGIN
  FOR view_rec IN (SELECT view_name FROM user_views) LOOP
    v_sql := 'DROP VIEW ' || view_rec.view_name;
    EXECUTE IMMEDIATE v_sql;
  END LOOP;
END;
/



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



