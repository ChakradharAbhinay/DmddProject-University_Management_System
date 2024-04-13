# DmddProject-University_Management_System

![image](https://github.com/ChakradharAbhinay/DmddProject-University_Management_System/assets/145234036/a3e2fd87-0627-45c8-a34e-3c8b2407fa2e)


# Problem Statement
Managing the massive volume of data related to university operations is becoming more difficult and complex in the current educational environment. A reliable and effective system is needed to manage academic records, course schedules, enrollment information, faculty details, and other administrative tasks due to the various needs of students, faculty, and administrative personnel. Conventional manual systems are no longer adequate, which results in errors, inefficiencies, and challenges with information retrieval. A comprehensive and integrated database system is desperately needed to assist university administration's decision-making processes, simplify data management, and enable easy access to information.


# Project Topic
## University Management System

# Objectives
➢ To Develop a centralized database
➢ To enhance data management
➢ To streamline academic and administrative processes ➢ To facilitate information retrieval
➢ To support academic planning
➢ To enhance reporting capabilities
➢ To provide role-based access control
➢ To support scalability and flexibility


Guidelines to run the project:

## 1. Create_admin_user_script.sql
First, execute the `Create_admin_user_script.sql`, then connect to the created user, and finally run the `UMS_DDL_SCRIPT.sql`.


## 2.UMS_DDL_SCRIPT.sql
Please execute this script after setting up the UMS (University Management System) environment with administrative privileges. It will ensure the creation of all 30 tables without encountering any ORA errors, as exception handling has been implemented to address any potential issues.

## 3.UMS_DML_SCRIPT.sql
Please execute the provided script to seamlessly insert data into their respective tables without encountering any errors.
## 4.trigger_script.sql
After execution of DML pls run the trigger_script.sql file
## 5.procedure_function_package.sql
After execution of trigger_script.sql file please run procedure_function_package.sql
## 6.UMS_VIEWS_SCRIPT.sql
Please execute the provided script to verify the views. It should execute successfully without encountering any errors. Views are integral to effective database management, providing a structured and simplified means to access and analyze data stored across multiple tables. They serve as an abstraction layer over intricate queries, thereby bolstering data security and facilitating streamlined data retrieval and reporting processes. By granting access and permissions exclusively to views instead of granting direct access to admin tables, security measures are enhanced, mitigating potential risks associated with unauthorized data access. It's highly recommended to restrict access and permissions to views for other users. Views operate similarly to tables, which is why error messages typically indicate non-existent tables or views to safeguard sensitive data from unauthorized access, such as the error SQL Error: ORA-00942 table or view does not exist

## 7.create_other_user_script.sql
Then disconnect from ums (admin) and execute create_other_user_script.sql, after this login to appropritate users as needed to work on the views.

## 8. Execute the below queries
select * from student_information_view;
select * from course_enrollment_view;
select * from course_statistics_view;
select * from term_enrollment_summary_view;
select * from grade_overview;
select * from professor_teaching_schedule_view;
select * from full_course_detail_view;
select * from student_transcript_view;
select * from course_offered_in_term_view;

