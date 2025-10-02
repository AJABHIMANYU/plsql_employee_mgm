-- FILE: get_dept_count.fnc
CREATE OR REPLACE FUNCTION get_dept_count(p_dept_id IN NUMBER) RETURN NUMBER IS
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count
  FROM employees
  WHERE department_id = p_dept_id;
  RETURN v_count;
END get_dept_count;
/

-- FILE: get_total_salary.fnc
CREATE OR REPLACE FUNCTION get_total_salary(p_dept_id IN NUMBER) RETURN NUMBER IS
  v_total NUMBER;
BEGIN
  SELECT SUM(salary) INTO v_total
  FROM employees
  WHERE department_id = p_dept_id;
  RETURN NVL(v_total, 0);
END get_total_salary;
/


-- FILE: get_project_count.fnc
CREATE OR REPLACE FUNCTION get_project_count(p_dept_id IN NUMBER) RETURN NUMBER IS
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count
  FROM projects
  WHERE dept_id = p_dept_id;
  RETURN v_count;
END get_project_count;
/

