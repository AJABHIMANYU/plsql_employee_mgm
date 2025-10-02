-- FILE: trigger.sql
-- Triggers for various tables

-- Auto-assign emp_id using sequence if not provided
CREATE OR REPLACE TRIGGER employees_bi_trg
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
  IF :NEW.emp_id IS NULL THEN
    :NEW.emp_id := employees_seq.NEXTVAL;
  END IF;
END;
/

-- Validate salary to prevent negative values
CREATE OR REPLACE TRIGGER employees_salary_check
BEFORE INSERT OR UPDATE ON employees
FOR EACH ROW
BEGIN
  IF :NEW.salary < 0 THEN
    RAISE_APPLICATION_ERROR(-20007, 'Salary cannot be negative');
  END IF;
END;
/

-- Auto-assign dept_id using sequence if not provided
CREATE OR REPLACE TRIGGER departments_bi_trg
BEFORE INSERT ON departments
FOR EACH ROW
BEGIN
  IF :NEW.dept_id IS NULL THEN
    :NEW.dept_id := dept_seq.NEXTVAL;
  END IF;
END;
/

-- Prevent deletion of department if employees exist
CREATE OR REPLACE TRIGGER departments_bd_trg
BEFORE DELETE ON departments
FOR EACH ROW
DECLARE
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count FROM employees WHERE department_id = :OLD.dept_id;
  IF v_count > 0 THEN
    RAISE_APPLICATION_ERROR(-20008, 'Cannot delete department with existing employees');
  END IF;
END;
/

-- Auto-assign project_id using sequence if not provided
CREATE OR REPLACE TRIGGER projects_bi_trg
BEFORE INSERT ON projects
FOR EACH ROW
BEGIN
  IF :NEW.project_id IS NULL THEN
    :NEW.project_id := project_seq.NEXTVAL;
  END IF;
END;
/

-- Log salary updates in employees (after update)
CREATE OR REPLACE TRIGGER employees_au_trg
AFTER UPDATE OF salary ON employees
FOR EACH ROW
BEGIN
  IF :OLD.salary <> :NEW.salary THEN
    INSERT INTO audit_log (log_id, emp_id, action, details, log_date, log_user)
    VALUES (audit_log_seq.NEXTVAL, :NEW.emp_id, 'SALARY_UPDATE', 'Salary changed from ' || :OLD.salary || ' to ' || :NEW.salary, SYSDATE, USER);
  END IF;
END;
/
