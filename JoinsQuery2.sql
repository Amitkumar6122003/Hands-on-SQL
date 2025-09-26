-- Create Tables
CREATE TABLE Departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    dept_id INT
);

-- Insert Data
INSERT INTO Departments VALUES (1, 'HR');
INSERT INTO Departments VALUES (2, 'IT');
INSERT INTO Departments VALUES (3, 'Finance');

INSERT INTO Employees VALUES (101, 'Amit', 1);
INSERT INTO Employees VALUES (102, 'Sneha', 2);
INSERT INTO Employees VALUES (103, 'Raj', NULL);
INSERT INTO Employees VALUES (104, 'Priya', 5);

-- INNER JOIN
SELECT e.emp_id, e.emp_name, d.dept_name
FROM Employees e
INNER JOIN Departments d
ON e.dept_id = d.dept_id;

-- LEFT JOIN
SELECT e.emp_id, e.emp_name, d.dept_name
FROM Employees e
LEFT JOIN Departments d
ON e.dept_id = d.dept_id;

-- RIGHT JOIN
SELECT e.emp_id, e.emp_name, d.dept_name
FROM Employees e
RIGHT JOIN Departments d
ON e.dept_id = d.dept_id;

-- FULL OUTER JOIN (works in SQL Server / Oracle / PostgreSQL)
SELECT e.emp_id, e.emp_name, d.dept_name
FROM Employees e
FULL OUTER JOIN Departments d
ON e.dept_id = d.dept_id;

-- CROSS JOIN (all combinations)
SELECT e.emp_id, e.emp_name, d.dept_name
FROM Employees e
CROSS JOIN Departments d;
