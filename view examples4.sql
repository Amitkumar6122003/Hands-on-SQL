-- Create base tables
CREATE TABLE Department (
  dept_id INT PRIMARY KEY,
  dept_name VARCHAR(50)
);

CREATE TABLE Employee (
  emp_id INT PRIMARY KEY,
  emp_name VARCHAR(50),
  dept_id INT,
  salary INT
);

-- Insert sample data
INSERT INTO Department VALUES 
(1, 'HR'),
(2, 'IT'),
(3, 'Sales');

INSERT INTO Employee VALUES 
(101, 'Amit', 1, 30000),
(102, 'Ravi', 2, 40000),
(103, 'Sneha', 3, 35000),
(104, 'Nilesh', 2, 45000);

-- 1️⃣ Create a simple view
CREATE VIEW emp_view AS
SELECT emp_id, emp_name, salary
FROM Employee;

-- Check data from view
SELECT * FROM emp_view;

-- 2️⃣ Create a join view
CREATE VIEW emp_dept_view AS
SELECT e.emp_id, e.emp_name, d.dept_name, e.salary
FROM Employee e
INNER JOIN Department d
ON e.dept_id = d.dept_id;

-- Fetch data from join view
SELECT * FROM emp_dept_view;

-- 3️⃣ Create a view with condition
CREATE VIEW high_salary_view AS
SELECT emp_name, salary
FROM Employee
WHERE salary > 35000;

SELECT * FROM high_salary_view;

-- 4️⃣ Update view data (if view allows)
UPDATE emp_view
SET salary = 32000
WHERE emp_id = 101;

-- 5️⃣ Drop a view
DROP VIEW high_salary_view;
