-- ==========================================
-- 🔹 ADVANCED SQL VIEWS (HARD LEVEL – SET 2)
-- ==========================================

-- Drop old tables if they exist
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS attendance;

-- ==========================================
-- 1️⃣ Create Base Tables
-- ==========================================
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50),
    city VARCHAR(50)
);

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    gender CHAR(1),
    hire_date DATE,
    salary DECIMAL(10,2),
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    emp_id INT,
    sale_amount DECIMAL(10,2),
    sale_date DATE,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

CREATE TABLE attendance (
    emp_id INT,
    work_date DATE,
    status VARCHAR(10),
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

-- ==========================================
-- 2️⃣ Insert Sample Data
-- ==========================================
INSERT INTO departments VALUES
(1, 'IT', 'Mumbai'),
(2, 'Sales', 'Pune'),
(3, 'Finance', 'Delhi'),
(4, 'HR', 'Chennai');

INSERT INTO employees VALUES
(101, 'Amit', 'M', '2018-03-15', 85000, 1),
(102, 'Sneha', 'F', '2019-06-01', 72000, 2),
(103, 'Ravi', 'M', '2020-08-20', 55000, 2),
(104, 'Kiran', 'M', '2017-10-05', 96000, 3),
(105, 'Priya', 'F', '2021-01-18', 48000, 4),
(106, 'Vikas', 'M', '2016-04-22', 115000, 1);

INSERT INTO sales VALUES
(1, 102, 150000, '2024-02-10'),
(2, 102, 130000, '2024-03-05'),
(3, 103, 70000, '2024-04-11'),
(4, 103, 95000, '2024-05-08'),
(5, 106, 220000, '2024-06-02');

INSERT INTO attendance VALUES
(101, '2024-09-01', 'Present'),
(101, '2024-09-02', 'Absent'),
(102, '2024-09-01', 'Present'),
(102, '2024-09-02', 'Present'),
(103, '2024-09-01', 'Absent'),
(104, '2024-09-01', 'Present'),
(105, '2024-09-01', 'Present'),
(106, '2024-09-01', 'Present');

-- ==========================================
-- 3️⃣ View 1: Department Performance Summary
-- ==========================================
CREATE VIEW dept_performance_view AS
SELECT 
    d.dept_name,
    COUNT(e.emp_id) AS total_employees,
    ROUND(AVG(e.salary),2) AS avg_salary,
    (SELECT ROUND(AVG(s.sale_amount),2)
     FROM sales s
     JOIN employees e2 ON e2.emp_id = s.emp_id
     WHERE e2.dept_id = d.dept_id) AS avg_sales_amount
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_name;

SELECT * FROM dept_performance_view;

-- ==========================================
-- 4️⃣ View 2: Top 3 Earning Employees (using Subquery)
-- ==========================================
CREATE VIEW top3_salary_view AS
SELECT emp_id, emp_name, salary, dept_id
FROM employees
WHERE salary IN (
    SELECT salary FROM employees
    ORDER BY salary DESC
    LIMIT 3
);

SELECT * FROM top3_salary_view;

-- ==========================================
-- 5️⃣ View 3: Employee Attendance Summary
-- ==========================================
CREATE VIEW emp_attendance_summary AS
SELECT 
    e.emp_name,
    SUM(CASE WHEN a.status = 'Present' THEN 1 ELSE 0 END) AS total_present,
    SUM(CASE WHEN a.status = 'Absent' THEN 1 ELSE 0 END) AS total_absent
FROM employees e
JOIN attendance a ON e.emp_id = a.emp_id
GROUP BY e.emp_name;

SELECT * FROM emp_attendance_summary;

-- ==========================================
-- 6️⃣ View 4: Employee Performance Category
-- ==========================================
CREATE VIEW employee_performance_category AS
SELECT 
    e.emp_name,
    e.salary,
    COALESCE(SUM(s.sale_amount), 0) AS total_sales,
    CASE
        WHEN COALESCE(SUM(s.sale_amount), 0) > 150000 THEN 'Star Performer'
        WHEN COALESCE(SUM(s.sale_amount), 0) BETWEEN 80000 AND 150000 THEN 'Average Performer'
        ELSE 'Needs Improvement'
    END AS performance_category
FROM employees e
LEFT JOIN sales s ON e.emp_id = s.emp_id
GROUP BY e.emp_name, e.salary;

SELECT * FROM employee_performance_category;

-- ==========================================
-- 7️⃣ View 5: City-wise Department Cost Summary
-- ==========================================
CREATE VIEW city_cost_summary AS
SELECT 
    d.city,
    COUNT(e.emp_id) AS total_emp,
    SUM(e.salary) AS total_salary_cost,
    ROUND(AVG(e.salary),2) AS avg_salary
FROM departments d
JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.city
HAVING SUM(e.salary) > 100000;

SELECT * FROM city_cost_summary;

-- ==========================================
-- 8️⃣ View 6: Multi-Level Subquery – “Elite Employees”
-- ==========================================
CREATE VIEW elite_employees AS
SELECT emp_name, salary, dept_id
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
    WHERE dept_id = employees.dept_id
)
AND emp_id IN (
    SELECT emp_id FROM sales WHERE sale_amount > 100000
);

SELECT * FROM elite_employees;

-- ==========================================
-- 9️⃣ Drop Views
-- ==========================================
DROP VIEW IF EXISTS dept_performance_view;
DROP VIEW IF EXISTS top3_salary_view;
DROP VIEW IF EXISTS emp_attendance_summary;
DROP VIEW IF EXISTS employee_performance_category;
DROP VIEW IF EXISTS city_cost_summary;
DROP VIEW IF EXISTS elite_employees;
