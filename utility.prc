-- FILE: update_dept_salary.prc
CREATE OR REPLACE PROCEDURE update_dept_salary(p_dept_id IN NUMBER, p_raise_percentage IN NUMBER) IS
BEGIN
  IF p_raise_percentage < 0 THEN
    RAISE_APPLICATION_ERROR(-20003, 'Raise percentage cannot be negative');
  END IF;
  UPDATE employees
  SET salary = salary * (1 + p_raise_percentage / 100)
  WHERE department_id = p_dept_id;
  COMMIT;
END update_dept_salary;
/

-- FILE: assign_project.prc
CREATE OR REPLACE PROCEDURE assign_project(p_emp_id IN NUMBER, p_project_id IN NUMBER) IS
BEGIN
  project_mgmt_pkg.assign_employee_to_project(p_emp_id, p_project_id);
END assign_project;
/
