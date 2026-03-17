

-- Create and select the database
CREATE DATABASE IF NOT EXISTS customer_analysis;
USE customer_analysis;

-- ── Table 1: customers ──────────────────────────────────────
DROP TABLE IF EXISTS orders;      -- drop orders first (foreign key)
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id   VARCHAR(10)  PRIMARY KEY,
    first_name    VARCHAR(50)  NOT NULL,
    last_name     VARCHAR(50)  NOT NULL,
    email         VARCHAR(100) NOT NULL,
    city          VARCHAR(50),
    segment       VARCHAR(20),   -- 'Premium', 'Standard', 'Basic'
    join_date     DATE,
    age           INT
);

-- ── Table 2: orders ────────────────────────────────────────
CREATE TABLE orders (
    order_id      VARCHAR(15)  PRIMARY KEY,
    customer_id   VARCHAR(10)  NOT NULL,
    order_date    DATE         NOT NULL,
    product_id    VARCHAR(10),
    product_name  VARCHAR(100),
    category      VARCHAR(50),
    unit_price    DECIMAL(10,2),
    quantity      INT,
    discount_pct  DECIMAL(5,2),
    revenue       DECIMAL(10,2),
    net_revenue   DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Confirm tables created
SHOW TABLES;
