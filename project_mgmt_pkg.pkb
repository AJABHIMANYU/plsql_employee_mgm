-- FILE: project_mgmt_pkg.pkb
CREATE OR REPLACE PACKAGE BODY project_mgmt_pkg AS
  -- Private procedure to log actions for projects
  PROCEDURE log_action(p_project_id IN NUMBER, p_action IN VARCHAR2, p_details IN VARCHAR2, p_user IN VARCHAR2) IS
  BEGIN
    INSERT INTO audit_log (log_id, project_id, action, details, log_date, log_user)
    VALUES (audit_log_seq.NEXTVAL, p_project_id, p_action, p_details, SYSDATE, p_user);
    COMMIT;
  END log_action;

  PROCEDURE create_project(p_project_name IN VARCHAR2, p_dept_id IN NUMBER) IS
    v_project_id NUMBER;
  BEGIN
    v_project_id := project_seq.NEXTVAL;
    INSERT INTO projects (project_id, project_name, dept_id)
    VALUES (v_project_id, p_project_name, p_dept_id);
    log_action(v_project_id, 'CREATE_PROJ', 'Created project ' || p_project_name || ' in dept ' || p_dept_id, USER);
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20013, 'Error creating project: ' || SQLERRM);
  END create_project;

  PROCEDURE read_project(p_project_id IN NUMBER, p_project_name OUT VARCHAR2, p_dept_id OUT NUMBER) IS
  BEGIN
    SELECT project_name, dept_id
    INTO p_project_name, p_dept_id
    FROM projects
    WHERE project_id = p_project_id;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20014, 'Project ID ' || p_project_id || ' not found');
  END read_project;

  PROCEDURE update_project(p_project_id IN NUMBER, p_project_name IN VARCHAR2, p_dept_id IN NUMBER) IS
  BEGIN
    UPDATE projects
    SET project_name = p_project_name, dept_id = p_dept_id
    WHERE project_id = p_project_id;
    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-20014, 'Project ID ' || p_project_id || ' not found');
    END IF;
    log_action(p_project_id, 'UPDATE_PROJ', 'Updated project to ' || p_project_name || ' in dept ' || p_dept_id, USER);
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20015, 'Error updating project: ' || SQLERRM);
  END update_project;

  PROCEDURE delete_project(p_project_id IN NUMBER) IS
  BEGIN
    DELETE FROM employee_projects WHERE project_id = p_project_id;
    DELETE FROM projects WHERE project_id = p_project_id;
    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-20014, 'Project ID ' || p_project_id || ' not found');
    END IF;
    log_action(p_project_id, 'DELETE_PROJ', 'Deleted project', USER);
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20016, 'Error deleting project: ' || SQLERRM);
  END delete_project;

  PROCEDURE assign_employee_to_project(p_emp_id IN NUMBER, p_project_id IN NUMBER) IS
  BEGIN
    INSERT INTO employee_projects (emp_id, project_id)
    VALUES (p_emp_id, p_project_id);
    log_action(p_project_id, 'ASSIGN_EMP', 'Assigned employee ' || p_emp_id || ' to project ' || p_project_id, USER);
    COMMIT;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20017, 'Employee already assigned to project');
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20018, 'Error assigning employee to project: ' || SQLERRM);
  END assign_employee_to_project;

  PROCEDURE remove_employee_from_project(p_emp_id IN NUMBER, p_project_id IN NUMBER) IS
  BEGIN
    DELETE FROM employee_projects WHERE emp_id = p_emp_id AND project_id = p_project_id;
    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-20019, 'Assignment not found');
    END IF;
    log_action(p_project_id, 'REMOVE_EMP', 'Removed employee ' || p_emp_id || ' from project ' || p_project_id, USER);
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20020, 'Error removing employee from project: ' || SQLERRM);
  END remove_employee_from_project;
END project_mgmt_pkg;
/
