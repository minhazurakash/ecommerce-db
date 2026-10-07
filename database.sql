-- ========================================================
-- DATABASE CREATION
-- ========================================================
DROP DATABASE IF EXISTS ecommerce_db;
CREATE DATABASE ecommerce_db;
USE ecommerce_db;

-- ========================================================
-- TABLE CREATION (Exact Proposal Structure)
-- ========================================================

-- 1. users
CREATE TABLE users (
    userId INT AUTO_INCREMENT PRIMARY KEY,
    fullName VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    phoneNumber VARCHAR(20),
    role VARCHAR(20) DEFAULT 'customer',
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2. userAddresses
CREATE TABLE userAddresses (
    addressId INT AUTO_INCREMENT PRIMARY KEY,
    userId INT,
    streetAddress VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    postalCode VARCHAR(20) NOT NULL,
    isDefault BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (userId) REFERENCES users(userId)
);

-- 3. categories
CREATE TABLE categories (
    categoryId INT AUTO_INCREMENT PRIMARY KEY,
    categoryName VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    parentId INT,
    FOREIGN KEY (parentId) REFERENCES categories(categoryId)
);

-- 4. products
CREATE TABLE products (
    productId INT AUTO_INCREMENT PRIMARY KEY,
    categoryId INT,
    title VARCHAR(200) NOT NULL,
    sku VARCHAR(50) NOT NULL UNIQUE,
    price FLOAT(10),
    stockQuantity INT DEFAULT 0,
    isActive BOOLEAN DEFAULT TRUE,
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (categoryId) REFERENCES categories(categoryId)
);

-- 5. carts
CREATE TABLE carts (
    cartId INT AUTO_INCREMENT PRIMARY KEY,
    userId INT UNIQUE,
    updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (userId) REFERENCES users(userId)
);

-- 6. cartItems
CREATE TABLE cartItems (
    cartItemId INT AUTO_INCREMENT PRIMARY KEY,
    cartId INT,
    productId INT,
    quantity INT DEFAULT 1,
    FOREIGN KEY (cartId) REFERENCES carts(cartId),
    FOREIGN KEY (productId) REFERENCES products(productId)
);

-- 7. orders
CREATE TABLE orders (
    orderId INT AUTO_INCREMENT PRIMARY KEY,
    userId INT,
    addressId INT,
    totalAmount FLOAT(10) NOT NULL,
    discountAmount FLOAT(10) DEFAULT 0.0,
    orderStatus VARCHAR(50) DEFAULT 'pending',
    orderDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (userId) REFERENCES users(userId),
    FOREIGN KEY (addressId) REFERENCES userAddresses(addressId)
);

-- 8. orderItems
CREATE TABLE orderItems (
    orderItemId INT AUTO_INCREMENT PRIMARY KEY,
    orderId INT,
    productId INT,
    unitPrice FLOAT(10) NOT NULL,
    quantity INT NOT NULL,
    subTotal FLOAT(10) NOT NULL,
    FOREIGN KEY (orderId) REFERENCES orders(orderId),
    FOREIGN KEY (productId) REFERENCES products(productId)
);

-- 9. payments
CREATE TABLE payments (
    paymentId INT AUTO_INCREMENT PRIMARY KEY,
    orderId INT,
    paymentMethod VARCHAR(50) NOT NULL,
    transactionId VARCHAR(100) UNIQUE,
    paymentStatus VARCHAR(50) DEFAULT 'pending',
    paymentDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (orderId) REFERENCES orders(orderId)
);

-- 10. coupons
CREATE TABLE coupons (
    couponId INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    discountPercentage FLOAT(10) NOT NULL,
    validUntil DATETIME NOT NULL,
    isActive BOOLEAN DEFAULT TRUE
);

-- 11. reviews
CREATE TABLE reviews (
    reviewId INT AUTO_INCREMENT PRIMARY KEY,
    productId INT,
    userId INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment VARCHAR(255),
    reviewDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (productId) REFERENCES products(productId),
    FOREIGN KEY (userId) REFERENCES users(userId)
);

-- ========================================================
-- DATA INSERTION (Clean and Simple)
-- ========================================================

-- 1. users
INSERT INTO users (userId, fullName, email, password, phoneNumber, role) VALUES
(1, 'Admin User', 'admin@store.com', 'admin123', '01700000001', 'admin'),
(2, 'Minhazur Rahman', 'minhaz@store.com', 'pass123', '01700000002', 'customer'),
(3, 'Sharmin Akhter', 'sharmin@store.com', 'pass123', '01700000003', 'customer'),
(4, 'Tahamina Sadia', 'sadia@store.com', 'pass123', '01700000004', 'customer'),
(5, 'Meherun Nesa', 'meherun@store.com', 'pass123', '01700000005', 'customer');

-- 2. userAddresses
INSERT INTO userAddresses (addressId, userId, streetAddress, city, postalCode, isDefault) VALUES
(1, 2, 'House 12, Road 4', 'Dhaka', '1230', TRUE),
(2, 2, 'Sector 10, Uttara', 'Dhaka', '1230', FALSE),
(3, 3, 'Dhanmondi 27', 'Dhaka', '1209', TRUE),
(4, 4, 'Mirpur 10', 'Dhaka', '1216', TRUE),
(5, 5, 'GEC Circle', 'Chittagong', '4000', TRUE);

-- 3. categories (Parent & Child categories)
INSERT INTO categories (categoryId, categoryName, description, parentId) VALUES
(1, 'Men Fashion', 'Clothing for men', NULL),
(2, 'Women Fashion', 'Clothing for women', NULL),
(3, 'T-Shirts', 'Drop shoulder and round neck tees', 1),
(4, 'Shirts', 'Formal and casual shirts', 1),
(5, 'Traditional', 'Kurtis and dresses', 2);

-- 4. products
INSERT INTO products (productId, categoryId, title, sku, price, stockQuantity, isActive) VALUES
(1, 3, 'Drop Shoulder Black T-Shirt', 'TSHIRT-BLK-01', 850.0, 50, TRUE),
(2, 3, 'Drop Shoulder Olive T-Shirt', 'TSHIRT-OLV-02', 850.0, 40, TRUE),
(3, 4, 'Casual White Shirt', 'SHIRT-WHT-03', 1200.0, 25, TRUE),
(4, 5, 'Cotton Kurti', 'KURTI-RED-04', 1600.0, 15, TRUE),
(5, 3, 'Oversized Navy Tee', 'TSHIRT-NAV-05', 900.0, 30, TRUE);

-- 5. carts
INSERT INTO carts (cartId, userId) VALUES
(1, 2),
(2, 3);

-- 6. cartItems
INSERT INTO cartItems (cartItemId, cartId, productId, quantity) VALUES
(1, 1, 1, 2),
(2, 1, 3, 1),
(3, 2, 4, 1);

-- 7. coupons
INSERT INTO coupons (couponId, code, discountPercentage, validUntil, isActive) VALUES
(1, 'DISCOUNT10', 10.0, '2026-12-31 23:59:59', TRUE),
(2, 'SUMMER20', 20.0, '2026-12-31 23:59:59', TRUE);

-- 8. orders
INSERT INTO orders (orderId, userId, addressId, totalAmount, discountAmount, orderStatus) VALUES
(1, 2, 1, 1700.0, 0.0, 'delivered'),
(2, 3, 3, 1200.0, 0.0, 'shipped'),
(3, 4, 4, 1600.0, 0.0, 'processing'),
(4, 5, 5, 850.0, 0.0, 'pending');

-- 9. orderItems
INSERT INTO orderItems (orderItemId, orderId, productId, unitPrice, quantity, subTotal) VALUES
(1, 1, 1, 850.0, 2, 1700.0),
(2, 2, 3, 1200.0, 1, 1200.0),
(3, 3, 4, 1600.0, 1, 1600.0),
(4, 4, 2, 850.0, 1, 850.0);

-- 10. payments
INSERT INTO payments (paymentId, orderId, paymentMethod, transactionId, paymentStatus) VALUES
(1, 1, 'bkash', 'TRX1001', 'paid'),
(2, 2, 'nagad', 'TRX1002', 'paid'),
(3, 3, 'card', 'TRX1003', 'paid'),
(4, 4, 'cod', 'TRX1004', 'pending');

-- 11. reviews
INSERT INTO reviews (reviewId, productId, userId, rating, comment) VALUES
(1, 1, 2, 5, 'Great quality t-shirt'),
(2, 3, 3, 4, 'Nice fit and comfort'),
(3, 4, 4, 5, 'Very stylish design'),
(4, 2, 5, 4, 'Fabric is very soft');

-- ========================================================
-- DEMONSTRATION & LAB DEFENSE QUERIES
-- (Based on your classroom syllabus)
-- ========================================================

-- Simple SELECT
SELECT * FROM users;
SELECT * FROM products;

-- ORDER BY and WHERE
SELECT * FROM products ORDER BY price ASC;
SELECT * FROM products WHERE price BETWEEN 800 AND 1300;
SELECT * FROM products WHERE title LIKE '%T-Shirt%';

-- Aggregate Functions (COUNT, AVG, SUM, MAX, MIN)
SELECT COUNT(*) AS TotalProducts FROM products;
SELECT AVG(price) AS AveragePrice FROM products;
SELECT SUM(totalAmount) AS TotalRevenue FROM orders;
SELECT MAX(price) AS MostExpensiveProduct FROM products;
SELECT MIN(price) AS CheapestProduct FROM products;

-- GROUP BY and HAVING
SELECT categoryId, COUNT(*) AS TotalItems, AVG(price) AS AvgCategoryPrice 
FROM products 
GROUP BY categoryId 
HAVING AVG(price) >= 800;

-- INNER JOIN (Customer Orders)
SELECT 
    orders.orderId, 
    users.fullName, 
    userAddresses.city, 
    orders.totalAmount, 
    orders.orderStatus
FROM orders
INNER JOIN users ON orders.userId = users.userId
INNER JOIN userAddresses ON orders.addressId = userAddresses.addressId;

-- INNER JOIN (Ordered Products Details)
SELECT 
    orderItems.orderId, 
    products.title AS ProductName, 
    orderItems.unitPrice, 
    orderItems.quantity, 
    orderItems.subTotal
FROM orderItems
INNER JOIN products ON orderItems.productId = products.productId;

-- LEFT JOIN (Products and their Reviews)
SELECT 
    products.title, 
    reviews.rating, 
    reviews.comment 
FROM products 
LEFT JOIN reviews ON products.productId = reviews.productId;

-- SUBQUERY (Orders placed by customers living in Dhaka)
SELECT * FROM orders 
WHERE addressId IN (SELECT addressId FROM userAddresses WHERE city = 'Dhaka');