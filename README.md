# Single-Vendor E-Commerce Database Management System

A normalized relational database system designed for a single-vendor retail platform. Built and tested on MySQL (XAMPP environment), this project models core e-commerce workflows—including role-based user management, category hierarchies, inventory management, dynamic shopping carts, order fulfillment, coupon redemptions, and product reviews.

---

## 📌 Academic Course Information

- **Course Title:** Database Design Lab
- **Course Code:** CSE384.12
- **Topic:** Relational Database Architecture & Query Execution (DDL/DML/DQL)

---

## 👥 Project Team

| Student ID | Student Name | Role |
| :--- | :--- | :--- |
| `2023200010095` | **Minhazur Rahman Akash** | Database Architecture & Query Optimization |
| `2023200010081` | **Mst. Sharmin Akhter** | Schema Design & Normalization |
| `2023200010116` | **Tahamina Akter Sadia** | Data Modeling & Constraint Integrity |
| `2023200010115` | **Meherun Nesa** | Business Logic, Insertion & QA |

---

## 🚀 Key Features

- **User & Profile Management:** Handles customer and administrator roles with multi-address support.
- **Categorization & Self-Referencing:** Implements nested parent/child product categories using recursive foreign keys.
- **Dynamic Carts:** Supports persistent shopping carts with atomic product item additions.
- **Transactional Orders & Order Items:** Tracks order life-cycles (`pending` to `delivered`), locks historical unit prices at purchase time, and records discount amounts.
- **Multi-Channel Payments:** Tracks digital transactions (`bKash`, `Nagad`, `Card`, `Cash on Delivery`) linked to orders.
- **Marketing & Promotions:** Validates discount codes, percentage calculations, and coupon expiration dates.
- **Product Reviews & Integrity:** Enforces star rating bounds (1 to 5) with MySQL `CHECK` constraints.

---

## 🗄️ Database Schema & Entities

The database consists of **11 normalized tables**:

```text
ecommerce_db
├── users (userId, fullName, email, password, phoneNumber, role, createdAt)
├── userAddresses (addressId, userId [FK], streetAddress, city, postalCode, isDefault)
├── categories (categoryId, categoryName, description, parentId [FK])
├── products (productId, categoryId [FK], title, sku, price, stockQuantity, isActive, createdAt)
├── carts (cartId, userId [FK, UNIQUE], updatedAt)
├── cartItems (cartItemId, cartId [FK], productId [FK], quantity)
├── orders (orderId, userId [FK], addressId [FK], totalAmount, discountAmount, orderStatus, orderDate)
├── orderItems (orderItemId, orderId [FK], productId [FK], unitPrice, quantity, subTotal)
├── payments (paymentId, orderId [FK], paymentMethod, transactionId, paymentStatus, paymentDate)
├── coupons (couponId, code, discountPercentage, validUntil, isActive)
└── reviews (reviewId, productId [FK], userId [FK], rating, comment, reviewDate)