DECLARE
  l_sql VARCHAR2(200);
BEGIN
  FOR cur_rec IN (SELECT table_name FROM user_tables) LOOP
    l_sql := 'DROP TABLE ' || cur_rec.table_name || ' CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE l_sql;
    DBMS_OUTPUT.PUT_LINE('Dropped table: ' || cur_rec.table_name);
  END LOOP;
  
  FOR cur_rec IN (SELECT object_name FROM user_objects WHERE object_type = 'SEQUENCE') LOOP
    l_sql := 'DROP SEQUENCE ' || cur_rec.object_name;
    EXECUTE IMMEDIATE l_sql;
    DBMS_OUTPUT.PUT_LINE('Dropped sequence: ' || cur_rec.object_name);
  END LOOP;

  FOR cur_rec IN (SELECT object_name FROM user_objects WHERE object_type = 'INDEX') LOOP
    l_sql := 'DROP INDEX ' || cur_rec.object_name;
    EXECUTE IMMEDIATE l_sql;
    DBMS_OUTPUT.PUT_LINE('Dropped index: ' || cur_rec.object_name);
  END LOOP;

  FOR cur_rec IN (SELECT object_name FROM user_objects WHERE object_type = 'TRIGGER') LOOP
    l_sql := 'DROP TRIGGER ' || cur_rec.object_name;
    EXECUTE IMMEDIATE l_sql;
    DBMS_OUTPUT.PUT_LINE('Dropped trigger: ' || cur_rec.object_name);
  END LOOP;
  
  DBMS_OUTPUT.PUT_LINE('All tables, sequences, indexes, and triggers dropped successfully.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/
