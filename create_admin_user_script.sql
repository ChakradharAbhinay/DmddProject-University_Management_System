-- First, drop the user if it exists
BEGIN
    EXECUTE IMMEDIATE 'DROP USER ums CASCADE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -1918 THEN
            RAISE;
        END IF;
END;
/

-- Now, create the user
CREATE USER ums IDENTIFIED BY Password2024#;
GRANT CONNECT TO ums;
GRANT RESOURCE TO ums;
ALTER USER ums QUOTA 10M ON DATA;
GRANT CREATE VIEW TO ums;
