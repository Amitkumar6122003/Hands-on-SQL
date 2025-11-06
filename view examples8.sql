-- ==========================================
-- 🔹 ADVANCED SQL VIEWS (HARD LEVEL – SET 3)
-- ==========================================

-- Clean up old tables
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS projects;
DROP TABLE IF EXISTS tasks;

-- ==========================================
-- 1️⃣ Create Tables
-- ==========================================
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50),
    region VARCHAR(50)
);

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    designation VARCHAR(50),
    salary DECIMAL(10,2),
    hire_date DATE,
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

CREATE TABLE projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(100),
    start_date DATE,
    end_date DATE,
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

CREATE TABLE tasks (
    task_id INT PRIMARY KEY,
    emp_id INT,
    project_id INT,
    hours_spent INT,
    status VARCHAR(15),
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

-- ==========================================
-- 2️⃣ Insert Data
-- ==========================================
INSERT INTO departments VALUES
(1,'IT','West'),
(2,'Finance','North'),
(3,'HR','South'),
(4,'Sales','East');

INSERT INTO employees VALUES
(101,'Amit','Manager',120000,'2016-03-10',1),
(102,'Sneha','Analyst',85000,'2018-07-15',2),
(103,'Ravi','Developer',95000,'2019-01-05',1),
(104,'Priya','HR Executive',60000,'2020-04-01',3),
(105,'Kiran','Sales Lead',110000,'2015-11-22',4),
(106,'Neha','Finance Officer',78000,'2021-02-14',2),
(107,'Vikas','Developer',88000,'2019-09-01',1);

INSERT INTO projects VALUES
(201,'ERP System Upgrade','2023-01-10','2023-12-20',1),
(202,'Tax Audit 2024','2023-04-01','2023-11-30',2),
(203,'Recruitment Portal','2023-05-15','2023-10-10',3),
(204,'Sales Expansion Plan','2023-03-01','2023-12-31',4);

INSERT INTO tasks VALUES
(301,101,201,120,'Completed'),
(302,103,201,100,'Completed'),
(303,107,201,90,'In Progress'),
(304,102,202,110,'Completed'),
(305,106,202,70,'In Progress'),
(306,104,203,60,'Completed'),
(307,105,204,140,'Completed');

-- ==========================================
-- 3️⃣ View 1: Department-wise Project Load
-- ==========================================
CREATE VIEW dept_project_load AS
SELECT 
    d.dept_name,
    COUNT(p.project_id) AS total_projects,
    ROUND(AVG(DATEDIFF(p.end_date,p.start_date)),1) AS avg_project_days
FROM departments d
LEFT JOIN projects p ON d.dept_id = p.dept_id
GROUP BY d.dept_name;

SELECT * FROM dept_project_load;

-- ==========================================
-- 4️⃣ View 2: Employee Workload Summary
-- ==========================================
CREATE VIEW employee_workload AS
SELECT 
    e.emp_name,
    e.designation,
    d.dept_name,
    SUM(t.hours_spent) AS total_hours,
    COUNT(DISTINCT t.project_id) AS projects_handled,
    ROUND(AVG(t.hours_spent),1) AS avg_hours_per_task
FROM employees e
JOIN tasks t ON e.emp_id = t.emp_id
JOIN departments d ON e.dept_id = d.dept_id
GROUP BY e.emp_name,e.designation,d.dept_name
HAVING SUM(t.hours_spent) > 50;

SELECT * FROM employee_workload;

-- ==========================================
-- 5️⃣ View 3: Use of CTE + View for Ranking
-- ==========================================
WITH salary_rank_cte AS (
    SELECT 
        emp_id,
        emp_name,
        dept_id,
        salary,
        DENSE_RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS salary_rank
    FROM employees
)
CREATE VIEW dept_salary_rank AS
SELECT 
    e.emp_name,
    d.dept_name,
    e.salary,
    c.salary_rank
FROM salary_rank_cte c
JOIN employees e ON e.emp_id = c.emp_id
JOIN departments d ON d.dept_id = e.dept_id
WHERE c.salary_rank <= 2;  -- Top 2 earners per dept

SELECT * FROM dept_salary_rank;

-- ==========================================
-- 6️⃣ View 4: Multi-Layer Subquery – “Efficient Employees”
-- ==========================================
CREATE VIEW efficient_employees AS
SELECT emp_name, dept_id, salary
FROM employees
WHERE emp_id IN (
    SELECT emp_id FROM tasks
    GROUP BY emp_id
    HAVING SUM(hours_spent) < (
        SELECT AVG(total_hours)
        FROM (
            SELECT SUM(hours_spent) AS total_hours
            FROM tasks
            GROUP BY emp_id
        ) AS avg_table
    )
);

SELECT * FROM efficient_employees;

-- ==========================================
-- 7️⃣ View 5: CASE-Based Performance View
-- ==========================================
CREATE VIEW employee_performance AS
SELECT 
    e.emp_name,
    e.salary,
    d.dept_name,
    COUNT(t.task_id) AS total_tasks,
    SUM(CASE WHEN t.status='Completed' THEN 1 ELSE 0 END) AS completed_tasks,
    CASE
        WHEN SUM(CASE WHEN t.status='Completed' THEN 1 ELSE 0 END) >= 2 THEN 'Excellent'
        WHEN SUM(CASE WHEN t.status='Completed' THEN 1 ELSE 0 END) = 1 THEN 'Good'
        ELSE 'Needs Improvement'
    END AS performance_category
FROM employees e
LEFT JOIN tasks t ON e.emp_id = t.emp_id
JOIN departments d ON e.dept_id = d.dept_id
GROUP BY e.emp_name,e.salary,d.dept_name;

SELECT * FROM employee_performance;

-- ==========================================
-- 8️⃣ Drop Views
-- ==========================================
DROP VIEW IF EXISTS dept_project_load;
DROP VIEW IF EXISTS employee_workload;
DROP VIEW IF EXISTS dept_salary_rank;
DROP VIEW IF EXISTS efficient_employees;
DROP VIEW IF EXISTS employee_performance;
