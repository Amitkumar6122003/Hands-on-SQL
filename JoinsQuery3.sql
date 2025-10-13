-- Create Tables
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

-- Insert Sample Data
INSERT INTO Department VALUES 
(1, 'HR'),
(2, 'IT'),
(3, 'Sales');

INSERT INTO Employee VALUES 
(101, 'Amit', 1, 30000),
(102, 'Ravi', 2, 40000),
(103, 'Sneha', 4, 35000);

-- 1. INNER JOIN
SELECT e.emp_id, e.emp_name, d.dept_name
FROM Employee e
INNER JOIN Department d
ON e.dept_id = d.dept_id;

-- 2. LEFT JOIN
SELECT e.emp_id, e.emp_name, d.dept_name
FROM Employee e
LEFT JOIN Department d
ON e.dept_id = d.dept_id;

-- 3. RIGHT JOIN
SELECT e.emp_id, e.emp_name, d.dept_name
FROM Employee e
RIGHT JOIN Department d
ON e.dept_id = d.dept_id;

-- 4. FULL OUTER JOIN
SELECT e.emp_id, e.emp_name, d.dept_name
FROM Employee e
FULL OUTER JOIN Department d
ON e.dept_id = d.dept_id;

-- 5. CROSS JOIN
SELECT e.emp_name, d.dept_name
FROM Employee e
CROSS JOIN Department d;

-- 6. SELF JOIN
CREATE TABLE EmployeeManager (
  emp_id INT,
  emp_name VARCHAR(50),
  manager_id INT
);

INSERT INTO EmployeeManager VALUES
(1, 'Amit', 3),
(2, 'Ravi', 1),
(3, 'Snehal', NULL);

SELECT e1.emp_name AS Employee, e2.emp_name AS Manager
FROM EmployeeManager e1
INNER JOIN EmployeeManager e2
ON e1.manager_id = e2.emp_id;
