Task 3: Online Retail Application Database
Project Summary: Build a database for an online retail application to manage customer sign-ups and product purchases.

Database Design:

Tables:
Customers: CustomerID, Name, Email, Address, SignUpDate
Products: ProductID, ProductName, Category, Price, Stock
Orders: OrderID, CustomerID, OrderDate, TotalAmount
OrderDetails: OrderDetailID, OrderID, ProductID, Quantity, Price
SQL Scripts:

Creating Tables:
sql
Copy code
CREATE DATABASE OnlineRetail;

USE OnlineRetail;

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY,
    Name VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE,
    Address VARCHAR(255),
    SignUpDate DATE
);
select * from customers
CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY,
    ProductName VARCHAR(255) NOT NULL,
    Category VARCHAR(100),
    Price DECIMAL(10, 2),
    Stock INT
);
select * from products
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10, 2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
select * from orders
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY IDENTITY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    Price DECIMAL(10, 2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
select * from OrderDetails
DROP TABLE OrderDetails
Inserting Sample Data:
sql
Copy code
INSERT INTO Customers (Name, Email, Address, SignUpDate)
VALUES
('Alice Brown', 'alice.brown@example.com', '789 Pine St', '2024-03-10'),
('Bob White', 'bob.white@example.com', '101 Maple St', '2024-04-15');

INSERT INTO Products (ProductName, Category, Price, Stock)
VALUES
('Laptop', 'Electronics', 999.99, 10),
('Smartphone', 'Electronics', 599.99, 20);

INSERT INTO Orders (CustomerID, OrderDate, TotalAmount)
VALUES
(1, '2024-05-18', 1599.98);

INSERT INTO OrderDetails (OrderID, ProductID, Quantity, Price)
VALUES
(1, 1, 1, 999.99),
(1, 2, 1, 599.99);
Query to Handle Customer Sign-Up:
sql
Copy code
INSERT INTO Customers (Name, Email, Address, SignUpDate)
VALUES ('Charlie Green', 'charlie.green@example.com', '202 Birch St', '2024-05-19');
Query to Add Products to the Cart:
sql
Copy code
INSERT INTO Orders (CustomerID, OrderDate, TotalAmount)
VALUES (2, '2024-05-19', 0);

INSERT INTO OrderDetails (OrderID, ProductID, Quantity, Price)
VALUES
((SELECT OrderID FROM Orders WHERE CustomerID = 2 AND OrderDate = '2024-05-19'), 1, 2, (SELECT Price FROM Products WHERE ProductID = 1));
Query to Place an Order:
sql
Copy code
UPDATE Orders
SET TotalAmount = (SELECT SUM(Quantity * Price) FROM OrderDetails WHERE OrderID = (SELECT OrderID FROM Orders WHERE CustomerID = 2 AND OrderDate = '2024-05-19'))
WHERE CustomerID = 2 AND OrderDate = '2024-05-19';
Query to View Order History:
