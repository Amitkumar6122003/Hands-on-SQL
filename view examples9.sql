-- ==========================================
-- CLEAN OLD STRUCTURE
-- ==========================================
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS customers;

-- ==========================================
-- 1️⃣ CREATE BASE TABLES
-- ==========================================
CREATE TABLE categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(50)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    price DECIMAL(10,2),
    stock INT,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    city VARCHAR(50),
    credit_limit DECIMAL(10,2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    total_amount DECIMAL(10,2),
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- ==========================================
-- 2️⃣ INSERT SAMPLE DATA
-- ==========================================
INSERT INTO categories VALUES
(1,'Electronics'),(2,'Clothing'),(3,'Home'),(4,'Sports');

INSERT INTO products VALUES
(101,'Laptop',75000,10,1),
(102,'Headphones',2500,50,1),
(103,'T-Shirt',800,200,2),
(104,'Football',1500,30,4),
(105,'Mixer Grinder',3500,15,3);

INSERT INTO customers VALUES
(1,'Amit','Pune',100000),
(2,'Sneha','Mumbai',70000),
(3,'Rohan','Delhi',25000),
(4,'Priya','Chennai',50000);

INSERT INTO orders VALUES
(201,1,77500,'2024-04-10'),
(202,2,3300,'2024-04-15'),
(203,3,1600,'2024-04-20'),
(204,1,900,'2024-04-25');

INSERT INTO order_items VALUES
(1,201,101,1),
(2,201,102,1),
(3,202,103,3),
(4,203,104,1),
(5,204,103,1);

-- ==========================================
-- 3️⃣ VIEW 1: CATEGORY SALES SUMMARY (HARD)
-- ==========================================
CREATE VIEW category_sales_summary AS
SELECT 
    c.category_name,
    SUM(oi.quantity * p.price) AS total_revenue,
    COUNT(DISTINCT oi.product_id) AS products_sold,
    ROUND(AVG(p.price),2) AS avg_price,
    SUM(oi.quantity) AS total_units_sold
FROM categories c
JOIN products p ON c.category_id = p.category_id
LEFT JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY c.category_name
HAVING SUM(oi.quantity) IS NOT NULL;

SELECT * FROM category_sales_summary;

-- ==========================================
-- 4️⃣ VIEW 2: TOP SPENDERS (WINDOW FUNCTION)
-- ==========================================
CREATE VIEW top_spenders AS
SELECT 
    customer_name,
    city,
    SUM(total_amount) AS total_spent,
    RANK() OVER (ORDER BY SUM(total_amount) DESC) AS spend_rank
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY customer_name, city
HAVING SUM(total_amount) > 2000;

SELECT * FROM top_spenders;

-- ==========================================
-- 5️⃣ VIEW 3: CROSS JOIN – PRICE COMPARISON MATRIX
-- ==========================================
CREATE VIEW product_price_matrix AS
SELECT 
    p1.product_name AS product_a,
    p2.product_name AS product_b,
    ABS(p1.price - p2.price) AS price_difference
FROM products p1
CROSS JOIN products p2
WHERE p1.product_id <> p2.product_id;

SELECT * FROM product_price_matrix;

-- ==========================================
-- 6️⃣ VIEW 4: RECURSIVE CTE + VIEW
-- Generate sequence 1–10 (any DB that supports recursion)
-- ==========================================
WITH RECURSIVE numbers(n) AS (
    SELECT 1
    UNION ALL
    SELECT n+1 FROM numbers WHERE n < 10
)
CREATE VIEW number_series AS
SELECT * FROM numbers;

SELECT * FROM number_series;

-- ==========================================
-- 7️⃣ VIEW 5: LOW STOCK ITEMS | AUTOMATIC ALERT VIEW
-- ==========================================
CREATE VIEW low_stock_view AS
SELECT 
    product_name,
    stock,
    CASE 
        WHEN stock < 5 THEN 'CRITICAL'
        WHEN stock BETWEEN 5 AND 15 THEN 'LOW'
        ELSE 'OK'
    END AS stock_status
FROM products
WHERE stock < 20;

SELECT * FROM low_stock_view;

-- ==========================================
-- 8️⃣ VIEW 6: VIEW WITH SECURITY FILTER
-- Only show customers whose credit limit > order amount total
-- ==========================================
CREATE VIEW credit_safe_customers AS
SELECT 
    c.customer_name,
    c.credit_limit,
    SUM(o.total_amount) AS total_orders,
    CASE 
        WHEN SUM(o.total_amount) <= c.credit_limit THEN 'SAFE'
        ELSE 'RISK'
    END AS status
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name, c.credit_limit
HAVING SUM(o.total_amount) <= c.credit_limit;

SELECT * FROM credit_safe_customers;

-- ==========================================
-- 9️⃣ DROP VIEWS
-- ==========================================
DROP VIEW IF EXISTS category_sales_summary;
DROP VIEW IF EXISTS top_spenders;
DROP VIEW IF EXISTS product_price_matrix;
DROP VIEW IF EXISTS number_series;
DROP VIEW IF EXISTS low_stock_view;
DROP VIEW IF EXISTS credit_safe_customers;
