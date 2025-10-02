-- FILE: tables.sql
-- Create departments table
CREATE TABLE departments (
  dept_id NUMBER PRIMARY KEY,
  dept_name VARCHAR2(100) NOT NULL,
  location VARCHAR2(100)
);

-- Create employees table
CREATE TABLE employees (
  emp_id NUMBER PRIMARY KEY,
  name VARCHAR2(100) NOT NULL,
  salary NUMBER(10,2) DEFAULT 0,
  department_id NUMBER,
  CONSTRAINT fk_dept FOREIGN KEY (department_id) REFERENCES departments(dept_id)
);

-- Create projects table
CREATE TABLE projects (
  project_id NUMBER PRIMARY KEY,
  project_name VARCHAR2(100) NOT NULL,
  dept_id NUMBER,
  CONSTRAINT fk_project_dept FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

-- Create employee_projects table (many-to-many)
CREATE TABLE employee_projects (
  emp_id NUMBER,
  project_id NUMBER,
  CONSTRAINT pk_emp_proj PRIMARY KEY (emp_id, project_id),
  CONSTRAINT fk_emp_proj_emp FOREIGN KEY (emp_id) REFERENCES employees(emp_id),
  CONSTRAINT fk_emp_proj_proj FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

-- Create audit_log table
CREATE TABLE audit_log (
  log_id NUMBER PRIMARY KEY,
  emp_id NUMBER,
  dept_id NUMBER,
  project_id NUMBER,
  action VARCHAR2(50),
  details VARCHAR2(500),
  log_date DATE DEFAULT SYSDATE,
  log_user VARCHAR2(50)
);

-- Create sequence for audit_log.log_id
CREATE SEQUENCE audit_log_seq START WITH 1 INCREMENT BY 1;

-- Create sequence for employees.emp_id
CREATE SEQUENCE employees_seq START WITH 1 INCREMENT BY 1;

-- Create sequence for departments.dept_id
CREATE SEQUENCE dept_seq START WITH 1 INCREMENT BY 1;

-- Create sequence for projects.project_id
CREATE SEQUENCE project_seq START WITH 1 INCREMENT BY 1;
