-- FILE: project_mgmt_pkg.pks
CREATE OR REPLACE PACKAGE project_mgmt_pkg AS
  -- Create a new project
  PROCEDURE create_project(p_project_name IN VARCHAR2, p_dept_id IN NUMBER);

  -- Read project details
  PROCEDURE read_project(p_project_id IN NUMBER, p_project_name OUT VARCHAR2, p_dept_id OUT NUMBER);

  -- Update project details
  PROCEDURE update_project(p_project_id IN NUMBER, p_project_name IN VARCHAR2, p_dept_id IN NUMBER);

  -- Delete a project
  PROCEDURE delete_project(p_project_id IN NUMBER);

  -- Assign employee to project
  PROCEDURE assign_employee_to_project(p_emp_id IN NUMBER, p_project_id IN NUMBER);

  -- Remove employee from project
  PROCEDURE remove_employee_from_project(p_emp_id IN NUMBER, p_project_id IN NUMBER);
END project_mgmt_pkg;
/
