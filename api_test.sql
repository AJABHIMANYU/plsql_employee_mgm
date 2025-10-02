-- FILE: api_test.sql
-- test_api_operations.sql
-- Script to test API-equivalent operations for all packages and standalone components
-- Modified to ensure all operations succeed without errors, test all components, and demonstrate multiple entities

SET SERVEROUTPUT ON;

DECLARE
  v_name employees.name%TYPE;
  v_salary employees.salary%TYPE;
  v_dept_id employees.department_id%TYPE;
  v_bonus NUMBER;
  v_count NUMBER;
  v_total NUMBER;
  v_dept_name departments.dept_name%TYPE;
  v_location departments.location%TYPE;
  v_project_name projects.project_name%TYPE;
  v_project_dept_id projects.dept_id%TYPE;
BEGIN
  -- 1. Create Department (POST /api/DepartmentMgmtPkgs/create-department)
  DBMS_OUTPUT.PUT_LINE('Creating department: IT, Location = New York');
  BEGIN
    department_mgmt_pkg.create_department('IT', 'New York');
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error creating department IT: ' || SQLERRM);
  END;

  -- 1b. Create Second Department
  DBMS_OUTPUT.PUT_LINE('Creating department: HR, Location = London');
  BEGIN
    department_mgmt_pkg.create_department('HR', 'London');
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error creating department HR: ' || SQLERRM);
  END;

  -- 2. Create Project in Dept 1
  DBMS_OUTPUT.PUT_LINE('Creating project: Project Alpha, DeptId = 1');
  BEGIN
    project_mgmt_pkg.create_project('Project Alpha', 1);
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error creating project Alpha: ' || SQLERRM);
  END;

  -- 3. Create Employee (POST /api/SimpleEmployeeMgmtPkgs/create-employee)
  DBMS_OUTPUT.PUT_LINE('Creating employee: John Doe, Salary = 75000, DeptId = 1');
  BEGIN
    simple_employee_mgmt_pkg.create_employee('John Doe', 75000, 1);
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error creating employee John Doe: ' || SQLERRM);
  END;

  -- 3b. Create Second Employee
  DBMS_OUTPUT.PUT_LINE('Creating employee: Jane Smith, Salary = 80000, DeptId = 2');
  BEGIN
    simple_employee_mgmt_pkg.create_employee('Jane Smith', 80000, 2);
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error creating employee Jane Smith: ' || SQLERRM);
  END;

  -- 4. Assign Employee to Project
  DBMS_OUTPUT.PUT_LINE('Assigning employee 1 to project 1');
  BEGIN
    project_mgmt_pkg.assign_employee_to_project(1, 1);
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error assigning employee 1 to project 1: ' || SQLERRM);
  END;

  -- 5. Read Employee (GET /api/SimpleEmployeeMgmtPkgs/read-employee/1)
  DBMS_OUTPUT.PUT_LINE('Reading employee ID 1');
  BEGIN
    simple_employee_mgmt_pkg.read_employee(1, v_name, v_salary, v_dept_id);
    DBMS_OUTPUT.PUT_LINE('Employee 1: Name = ' || v_name || ', Salary = ' || v_salary || ', Dept = ' || v_dept_id);
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error reading employee 1: ' || SQLERRM);
  END;

  -- 6. Update Employee (POST /api/SimpleEmployeeMgmtPkgs/update-employee)
  DBMS_OUTPUT.PUT_LINE('Updating employee ID 2: Name = Jane S. Smith, DeptId = 1');
  BEGIN
    simple_employee_mgmt_pkg.update_employee(2, 'Jane S. Smith', 1);
    DBMS_OUTPUT.PUT_LINE('Employee 2 updated successfully');
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error updating employee 2: ' || SQLERRM);
  END;

  -- 7. Give Raise (POST /api/SimpleEmployeeMgmtPkgs/give-raise)
  DBMS_OUTPUT.PUT_LINE('Giving raise to employee ID 1: Amount = 5000, User = postman_admin');
  BEGIN
    simple_employee_mgmt_pkg.give_raise(1, 5000, 'postman_admin');
    DBMS_OUTPUT.PUT_LINE('Raise applied successfully for employee 1');
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error giving raise to employee 1: ' || SQLERRM);
  END;

  -- 8. Read Department
  DBMS_OUTPUT.PUT_LINE('Reading department ID 1');
  BEGIN
    department_mgmt_pkg.read_department(1, v_dept_name, v_location);
    DBMS_OUTPUT.PUT_LINE('Department 1: Name = ' || v_dept_name || ', Location = ' || v_location);
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error reading department 1: ' || SQLERRM);
  END;

  -- 9. Update Department
  DBMS_OUTPUT.PUT_LINE('Updating department ID 2: Name = Human Resources, Location = Paris');
  BEGIN
    department_mgmt_pkg.update_department(2, 'Human Resources', 'Paris');
    DBMS_OUTPUT.PUT_LINE('Department 2 updated successfully');
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error updating department 2: ' || SQLERRM);
  END;

  -- 10. Read Project
  DBMS_OUTPUT.PUT_LINE('Reading project ID 1');
  BEGIN
    project_mgmt_pkg.read_project(1, v_project_name, v_project_dept_id);
    DBMS_OUTPUT.PUT_LINE('Project 1: Name = ' || v_project_name || ', Dept = ' || v_project_dept_id);
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error reading project 1: ' || SQLERRM);
  END;

  -- 11. Update Project
  DBMS_OUTPUT.PUT_LINE('Updating project ID 1: Name = Project Beta, DeptId = 2');
  BEGIN
    project_mgmt_pkg.update_project(1, 'Project Beta', 2);
    DBMS_OUTPUT.PUT_LINE('Project 1 updated successfully');
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error updating project 1: ' || SQLERRM);
  END;

  -- 12. Test update_dept_salary procedure (POST /api/SimpleEmployeeMgmtPkgs/update-dept-salary)
  DBMS_OUTPUT.PUT_LINE('Updating dept 1 salary by 10%');
  BEGIN
    update_dept_salary(1, 10);
    DBMS_OUTPUT.PUT_LINE('Dept 1 salaries updated successfully');
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error updating dept 1 salaries: ' || SQLERRM);
  END;

  -- 13. Test get_dept_count function
  v_count := get_dept_count(1);
  DBMS_OUTPUT.PUT_LINE('Employee count in Dept 1: ' || v_count);

  -- 14. Test calculate_bonus function
  v_bonus := simple_employee_mgmt_pkg.calculate_bonus(1);
  DBMS_OUTPUT.PUT_LINE('Calculated bonus for employee 1: ' || v_bonus);

  -- 15. Test get_total_salary function
  v_total := get_total_salary(1);
  DBMS_OUTPUT.PUT_LINE('Total salary in Dept 1: ' || v_total);

  -- 16. Test get_project_count function
  v_count := get_project_count(2);
  DBMS_OUTPUT.PUT_LINE('Project count in Dept 2: ' || v_count);

  -- 17. Remove Employee from Project
  DBMS_OUTPUT.PUT_LINE('Removing employee 1 from project 1');
  BEGIN
    project_mgmt_pkg.remove_employee_from_project(1, 1);
    DBMS_OUTPUT.PUT_LINE('Removal successful');
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error removing employee 1 from project 1: ' || SQLERRM);
  END;

  -- 18. Delete Project
  DBMS_OUTPUT.PUT_LINE('Deleting project ID 1');
  BEGIN
    project_mgmt_pkg.delete_project(1);
    DBMS_OUTPUT.PUT_LINE('Project 1 deleted successfully');
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error deleting project 1: ' || SQLERRM);
  END;

  -- 19. Delete Employee (POST /api/SimpleEmployeeMgmtPkgs/delete-employee/2)
  DBMS_OUTPUT.PUT_LINE('Deleting employee ID 2');
  BEGIN
    simple_employee_mgmt_pkg.delete_employee(2);
    DBMS_OUTPUT.PUT_LINE('Employee 2 deleted successfully');
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error deleting employee 2: ' || SQLERRM);
  END;

  -- 20. Delete Department (after ensuring no employees)
  DBMS_OUTPUT.PUT_LINE('Deleting department ID 2');
  BEGIN
    department_mgmt_pkg.delete_department(2);
    DBMS_OUTPUT.PUT_LINE('Department 2 deleted successfully');
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error deleting department 2: ' || SQLERRM);
  END;

  -- Verify results
  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE('Final state of departments table:');
  FOR rec IN (SELECT dept_id, dept_name, location FROM departments) LOOP
    DBMS_OUTPUT.PUT_LINE('ID: ' || rec.dept_id || ', Name: ' || rec.dept_name || ', Location: ' || rec.location);
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE('Final state of employees table:');
  FOR rec IN (SELECT emp_id, name, salary, department_id FROM employees) LOOP
    DBMS_OUTPUT.PUT_LINE('ID: ' || rec.emp_id || ', Name: ' || rec.name || ', Salary: ' || rec.salary || ', Dept: ' || rec.department_id);
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE('Final state of projects table:');
  FOR rec IN (SELECT project_id, project_name, dept_id FROM projects) LOOP
    DBMS_OUTPUT.PUT_LINE('ID: ' || rec.project_id || ', Name: ' || rec.project_name || ', Dept: ' || rec.dept_id);
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE('Final state of employee_projects table:');
  FOR rec IN (SELECT emp_id, project_id FROM employee_projects) LOOP
    DBMS_OUTPUT.PUT_LINE('Emp ID: ' || rec.emp_id || ', Project ID: ' || rec.project_id);
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE('Final state of audit_log table:');
  FOR rec IN (SELECT log_id, emp_id, dept_id, project_id, action, details, log_date, log_user FROM audit_log) LOOP
    DBMS_OUTPUT.PUT_LINE('Log ID: ' || rec.log_id || ', Emp ID: ' || NVL(TO_CHAR(rec.emp_id), 'NULL') || ', Dept ID: ' || NVL(TO_CHAR(rec.dept_id), 'NULL') || ', Proj ID: ' || NVL(TO_CHAR(rec.project_id), 'NULL') || ', Action: ' || rec.action || ', Details: ' || rec.details || ', User: ' || rec.log_user || ', Date: ' || TO_CHAR(rec.log_date, 'DD-MON-YY'));
  END LOOP;
END;
/
