-- ==========================================
-- 🔹 Advanced SQL Views Example (HARD)
-- ==========================================

-- Drop old tables if they exist
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS projects;
DROP TABLE IF EXISTS performance;

-- ==========================================
-- 1️⃣ Create Base Tables
-- ==========================================
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50),
    location VARCHAR(50)
);

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    gender CHAR(1),
    salary DECIMAL(10,2),
    hire_date DATE,
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

CREATE TABLE projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(50),
    budget DECIMAL(12,2),
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

CREATE TABLE performance (
    emp_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    review_year INT,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

-- ==========================================
-- 2️⃣ Insert Sample Data
-- ==========================================
INSERT INTO departments VALUES
(1, 'HR', 'Pune'),
(2, 'IT', 'Mumbai'),
(3, 'Finance', 'Delhi'),
(4, 'Sales', 'Bangalore');

INSERT INTO employees VALUES
(101, 'Amit', 'M', 75000, '2018-04-15', 2),
(102, 'Sneha', 'F', 52000, '2019-09-20', 4),
(103, 'Ravi', 'M', 85000, '2016-11-10', 3),
(104, 'Priya', 'F', 92000, '2017-06-05', 2),
(105, 'Rahul', 'M', 46000, '2020-02-10', 1),
(106, 'Kiran', 'M', 105000, '2015-12-25', 3);

INSERT INTO projects VALUES
(201, 'ERP Upgrade', 250000, 3),
(202, 'AI Automation', 350000, 2),
(203, 'Recruitment Drive', 120000, 1),
(204, 'Client Expansion', 200000, 4);

INSERT INTO performance VALUES
(101, 4, 2024),
(102, 3, 2024),
(103, 5, 2024),
(104, 4, 2024),
(105, 2, 2024),
(106, 5, 2024);

-- ==========================================
-- 3️⃣ Complex View: Department Salary Summary
-- ==========================================
CREATE VIEW dept_salary_summary AS
SELECT 
    d.dept_name,
    COUNT(e.emp_id) AS total_employees,
    ROUND(AVG(e.salary),2) AS avg_salary,
    MAX(e.salary) AS highest_salary,
    MIN(e.salary) AS lowest_salary
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
GROUP BY d.dept_name
HAVING AVG(e.salary) > 50000;

SELECT * FROM dept_salary_summary;

-- ==========================================
-- 4️⃣ View with Subquery (Top Performers)
-- ==========================================
CREATE VIEW top_performers AS
SELECT 
    e.emp_name,
    e.salary,
    d.dept_name,
    p.rating
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
JOIN performance p ON e.emp_id = p.emp_id
WHERE p.rating = (
    SELECT MAX(rating) FROM performance
);

SELECT * FROM top_performers;

-- ==========================================
-- 5️⃣ View Combining Multiple Tables with Conditions
-- ==========================================
CREATE VIEW project_employee_overview AS
SELECT 
    p.project_name,
    d.dept_name,
    d.location,
    COUNT(e.emp_id) AS dept_emp_count,
    SUM(e.salary) AS total_salary_budget,
    ROUND(AVG(e.salary),2) AS avg_salary_involved
FROM projects p
JOIN departments d ON p.dept_id = d.dept_id
JOIN employees e ON d.dept_id = e.dept_id
WHERE p.budget > 150000
GROUP BY p.project_name, d.dept_name, d.location;

SELECT * FROM project_employee_overview;

-- ==========================================
-- 6️⃣ View with CASE (Dynamic Salary Category)
-- ==========================================
CREATE VIEW employee_salary_category AS
SELECT 
    emp_name,
    salary,
    CASE 
        WHEN salary >= 90000 THEN 'High Earner'
        WHEN salary BETWEEN 60000 AND 89999 THEN 'Medium Earner'
        ELSE 'Low Earner'
    END AS salary_category
FROM employees;

SELECT * FROM employee_salary_category;

-- ==========================================
-- 7️⃣ Updatable View Example
-- ==========================================
CREATE VIEW editable_emp_view AS
SELECT emp_id, emp_name, salary, dept_id
FROM employees
WHERE dept_id = 2
WITH CHECK OPTION;

-- Update through view
UPDATE editable_emp_view
SET salary = salary + 10000
WHERE emp_id = 101;

SELECT * FROM editable_emp_view;

-- ==========================================
-- 8️⃣ Drop Views
-- ==========================================
DROP VIEW IF EXISTS top_performers;
DROP VIEW IF EXISTS dept_salary_summary;
DROP VIEW IF EXISTS project_employee_overview;
DROP VIEW IF EXISTS employee_salary_category;
DROP VIEW IF EXISTS editable_emp_view;
