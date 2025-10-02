-- FILE: department_mgmt_pkg.pks
CREATE OR REPLACE PACKAGE department_mgmt_pkg AS
  -- Create a new department
  PROCEDURE create_department(p_dept_name IN VARCHAR2, p_location IN VARCHAR2);

  -- Read department details
  PROCEDURE read_department(p_dept_id IN NUMBER, p_dept_name OUT VARCHAR2, p_location OUT VARCHAR2);

  -- Update department details
  PROCEDURE update_department(p_dept_id IN NUMBER, p_dept_name IN VARCHAR2, p_location IN VARCHAR2);

  -- Delete a department
  PROCEDURE delete_department(p_dept_id IN NUMBER);
END department_mgmt_pkg;
/
