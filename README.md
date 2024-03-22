# DmddProject-University_Management_System
Guidelines to run the project:

## 1.


## 2.UMS_DDL_SCRIPT.sql
Please execute this script after setting up the UMS (University Management System) environment with administrative privileges. It will ensure the creation of all 30 tables without encountering any ORA errors, as exception handling has been implemented to address any potential issues.

## 3.UMS_DML_SCRIPT.sql
Please execute the provided script to seamlessly insert data into their respective tables without encountering any errors.

## 4.UMS_VIEWS_SCRIPT.sql
Please execute the provided script to verify the views. It should execute successfully without encountering any errors. Views are integral to effective database management, providing a structured and simplified means to access and analyze data stored across multiple tables. They serve as an abstraction layer over intricate queries, thereby bolstering data security and facilitating streamlined data retrieval and reporting processes. By granting access and permissions exclusively to views instead of granting direct access to admin tables, security measures are enhanced, mitigating potential risks associated with unauthorized data access. It's highly recommended to restrict access and permissions to views for other users. Views operate similarly to tables, which is why error messages typically indicate non-existent tables or views to safeguard sensitive data from unauthorized access, such as the error SQL Error: ORA-00942 table or view does not exist

