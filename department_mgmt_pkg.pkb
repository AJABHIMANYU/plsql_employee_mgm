-- FILE: department_mgmt_pkg.pkb
CREATE OR REPLACE PACKAGE BODY department_mgmt_pkg AS
  -- Private procedure to log actions for departments
  PROCEDURE log_action(p_dept_id IN NUMBER, p_action IN VARCHAR2, p_details IN VARCHAR2, p_user IN VARCHAR2) IS
  BEGIN
    INSERT INTO audit_log (log_id, dept_id, action, details, log_date, log_user)
    VALUES (audit_log_seq.NEXTVAL, p_dept_id, p_action, p_details, SYSDATE, p_user);
    COMMIT;
  END log_action;

  PROCEDURE create_department(p_dept_name IN VARCHAR2, p_location IN VARCHAR2) IS
    v_dept_id NUMBER;
  BEGIN
    v_dept_id := dept_seq.NEXTVAL;
    INSERT INTO departments (dept_id, dept_name, location)
    VALUES (v_dept_id, p_dept_name, p_location);
    log_action(v_dept_id, 'CREATE_DEPT', 'Created department ' || p_dept_name || ' at ' || p_location, USER);
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20009, 'Error creating department: ' || SQLERRM);
  END create_department;

  PROCEDURE read_department(p_dept_id IN NUMBER, p_dept_name OUT VARCHAR2, p_location OUT VARCHAR2) IS
  BEGIN
    SELECT dept_name, location
    INTO p_dept_name, p_location
    FROM departments
    WHERE dept_id = p_dept_id;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20010, 'Department ID ' || p_dept_id || ' not found');
  END read_department;

  PROCEDURE update_department(p_dept_id IN NUMBER, p_dept_name IN VARCHAR2, p_location IN VARCHAR2) IS
  BEGIN
    UPDATE departments
    SET dept_name = p_dept_name, location = p_location
    WHERE dept_id = p_dept_id;
    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-20010, 'Department ID ' || p_dept_id || ' not found');
    END IF;
    log_action(p_dept_id, 'UPDATE_DEPT', 'Updated department to ' || p_dept_name || ' at ' || p_location, USER);
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20011, 'Error updating department: ' || SQLERRM);
  END update_department;

  PROCEDURE delete_department(p_dept_id IN NUMBER) IS
  BEGIN
    -- Delete associated projects first
    DELETE FROM employee_projects WHERE project_id IN (SELECT project_id FROM projects WHERE dept_id = p_dept_id);
    DELETE FROM projects WHERE dept_id = p_dept_id;
    DELETE FROM departments WHERE dept_id = p_dept_id;
    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-20010, 'Department ID ' || p_dept_id || ' not found');
    END IF;
    log_action(p_dept_id, 'DELETE_DEPT', 'Deleted department', USER);
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20012, 'Error deleting department: ' || SQLERRM);
  END delete_department;
END department_mgmt_pkg;
/
