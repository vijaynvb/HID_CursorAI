-- =============================================
-- Entity Relationship Diagram - T-SQL Schema Script
-- Generated from ER Diagram
-- =============================================

-- Drop tables in reverse order of dependencies (if recreating)
IF OBJECT_ID('Shipments', 'U') IS NOT NULL DROP TABLE Shipments;
IF OBJECT_ID('OrderDetails', 'U') IS NOT NULL DROP TABLE OrderDetails;
IF OBJECT_ID('Orders', 'U') IS NOT NULL DROP TABLE Orders;
IF OBJECT_ID('Products', 'U') IS NOT NULL DROP TABLE Products;
IF OBJECT_ID('Customers', 'U') IS NOT NULL DROP TABLE Customers;
IF OBJECT_ID('Suppliers', 'U') IS NOT NULL DROP TABLE Suppliers;
GO

-- =============================================
-- Table: Suppliers
-- =============================================
CREATE TABLE Suppliers (
    SupplierID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierName NVARCHAR(100) NOT NULL,
    ContactName NVARCHAR(50),
    Address NVARCHAR(200),
    City NVARCHAR(50),
    PostalCode NVARCHAR(20),
    Country NVARCHAR(50),
    Phone NVARCHAR(20)
);
GO

-- =============================================
-- Table: Customers
-- =============================================
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    CompanyName NVARCHAR(100) NOT NULL,
    ContactName NVARCHAR(50),
    ContactTitle NVARCHAR(50),
    Address NVARCHAR(200),
    City NVARCHAR(50),
    PostalCode NVARCHAR(20),
    Country NVARCHAR(50),
    Phone NVARCHAR(20)
);
GO

-- =============================================
-- Table: Products
-- =============================================
CREATE TABLE Products (
    ProductsID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName NVARCHAR(100) NOT NULL,
    SupplierID INT,
    CategoryID INT,
    QuantityPerUnit NVARCHAR(50),
    UnitPrice DECIMAL(10,2),
    UnitsInStock INT DEFAULT 0,
    UnitsOnOrder INT DEFAULT 0,
    ReorderLevel INT DEFAULT 0,
    CONSTRAINT FK_Products_Suppliers FOREIGN KEY (SupplierID) 
        REFERENCES Suppliers(SupplierID)
);
GO

-- =============================================
-- Table: Orders
-- =============================================
CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    EmployeeID INT,
    OrderDate DATETIME,
    RequiredDate DATETIME,
    ShippedDate DATETIME,
    ShipVia INT,
    Freight DECIMAL(10,2),
    ShipName NVARCHAR(100),
    ShipAddress NVARCHAR(200),
    ShipCity NVARCHAR(50),
    ShipPostCode NVARCHAR(20),
    ShipContry NVARCHAR(50), -- Note: Typo preserved from ER diagram (likely should be ShipCountry)
    CONSTRAINT FK_Orders_Customers FOREIGN KEY (CustomerID) 
        REFERENCES Customers(CustomerID)
);
GO

-- =============================================
-- Table: OrderDetails
-- =============================================
CREATE TABLE OrderDetails (
    OrderDetailsID INT IDENTITY(1,1) PRIMARY KEY, -- Surrogate key
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    Quantity INT NOT NULL DEFAULT 1,
    Discount DECIMAL(5,2) DEFAULT 0,
    CONSTRAINT FK_OrderDetails_Orders FOREIGN KEY (OrderID) 
        REFERENCES Orders(OrderID),
    CONSTRAINT FK_OrderDetails_Products FOREIGN KEY (ProductID) 
        REFERENCES Products(ProductsID),
    CONSTRAINT UQ_OrderDetails_OrderProduct UNIQUE (OrderID, ProductID) -- Ensure unique product per order
);
GO

-- =============================================
-- Table: Shipments
-- =============================================
CREATE TABLE Shipments (
    ShipmentID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    ShipperID INT,
    ShipmentDate DATETIME,
    CONSTRAINT FK_Shipments_Orders FOREIGN KEY (OrderID) 
        REFERENCES Orders(OrderID)
);
GO

-- =============================================
-- Create Indexes for Performance
-- =============================================

-- Index on foreign keys for better join performance
CREATE INDEX IX_Products_SupplierID ON Products(SupplierID);
CREATE INDEX IX_Orders_CustomerID ON Orders(CustomerID);
CREATE INDEX IX_OrderDetails_OrderID ON OrderDetails(OrderID);
CREATE INDEX IX_OrderDetails_ProductID ON OrderDetails(ProductID);
CREATE INDEX IX_Shipments_OrderID ON Shipments(OrderID);

-- Index on commonly queried columns
CREATE INDEX IX_Products_ProductName ON Products(ProductName);
CREATE INDEX IX_Orders_OrderDate ON Orders(OrderDate);
CREATE INDEX IX_Customers_CompanyName ON Customers(CompanyName);
GO

-- =============================================
-- Seed Data
-- =============================================

-- Insert Suppliers
SET IDENTITY_INSERT Suppliers ON;
INSERT INTO Suppliers (SupplierID, SupplierName, ContactName, Address, City, PostalCode, Country, Phone)
VALUES
    (1, 'Exotic Liquids', 'Charlotte Cooper', '49 Gilbert St.', 'London', 'EC1 4SD', 'UK', '(171) 555-2222'),
    (2, 'New Orleans Cajun Delights', 'Shelley Burke', 'P.O. Box 78934', 'New Orleans', '70117', 'USA', '(100) 555-4822'),
    (3, 'Grandma Kelly''s Homestead', 'Regina Murphy', '707 Oxford Rd.', 'Ann Arbor', '48104', 'USA', '(313) 555-5735'),
    (4, 'Tokyo Traders', 'Yoshi Nagase', '9-8 Sekimai Musashino-shi', 'Tokyo', '100', 'Japan', '(03) 3555-5011'),
    (5, 'Cooperativa de Quesos ''Las Cabras''', 'Antonio del Valle Saavedra', 'Calle del Rosal 4', 'Oviedo', '33007', 'Spain', '(98) 598 76 54');
SET IDENTITY_INSERT Suppliers OFF;
GO

-- Insert Customers
SET IDENTITY_INSERT Customers ON;
INSERT INTO Customers (CustomerID, CompanyName, ContactName, ContactTitle, Address, City, PostalCode, Country, Phone)
VALUES
    (1, 'Alfreds Futterkiste', 'Maria Anders', 'Sales Representative', 'Obere Str. 57', 'Berlin', '12209', 'Germany', '030-0074321'),
    (2, 'Ana Trujillo Emparedados y helados', 'Ana Trujillo', 'Owner', 'Avda. de la Constitución 2222', 'México D.F.', '05021', 'Mexico', '(5) 555-4729'),
    (3, 'Antonio Moreno Taquería', 'Antonio Moreno', 'Owner', 'Mataderos 2312', 'México D.F.', '05023', 'Mexico', '(5) 555-3932'),
    (4, 'Around the Horn', 'Thomas Hardy', 'Sales Representative', '120 Hanover Sq.', 'London', 'WA1 1DP', 'UK', '(171) 555-7788'),
    (5, 'Berglunds snabbköp', 'Christina Berglund', 'Order Administrator', 'Berguvsvägen 8', 'Luleå', 'S-958 22', 'Sweden', '0921-12 34 65'),
    (6, 'Blauer See Delikatessen', 'Hanna Moos', 'Sales Representative', 'Forsterstr. 57', 'Mannheim', '68306', 'Germany', '0621-08460'),
    (7, 'Blondesddsl père et fils', 'Frédérique Citeaux', 'Marketing Manager', '24, place Kléber', 'Strasbourg', '67000', 'France', '88.60.15.31'),
    (8, 'Bólido Comidas preparadas', 'Martín Sommer', 'Owner', 'C/ Araquil, 67', 'Madrid', '28023', 'Spain', '(91) 555 22 82');
SET IDENTITY_INSERT Customers OFF;
GO

-- Insert Products
SET IDENTITY_INSERT Products ON;
INSERT INTO Products (ProductsID, ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel)
VALUES
    (1, 'Chai', 1, 1, '10 boxes x 20 bags', 18.00, 39, 0, 10),
    (2, 'Chang', 1, 1, '24 - 12 oz bottles', 19.00, 17, 40, 25),
    (3, 'Aniseed Syrup', 1, 2, '12 - 550 ml bottles', 10.00, 13, 70, 25),
    (4, 'Chef Anton''s Cajun Seasoning', 2, 2, '48 - 6 oz jars', 22.00, 53, 0, 0),
    (5, 'Chef Anton''s Gumbo Mix', 2, 2, '36 boxes', 21.35, 0, 0, 0),
    (6, 'Grandma''s Boysenberry Spread', 3, 2, '12 - 8 oz jars', 25.00, 120, 0, 25),
    (7, 'Uncle Bob''s Organic Dried Pears', 3, 7, '12 - 1 lb pkgs.', 30.00, 15, 0, 10),
    (8, 'Northwoods Cranberry Sauce', 3, 2, '12 - 12 oz jars', 40.00, 6, 0, 0),
    (9, 'Mishi Kobe Niku', 4, 6, '18 - 500 g pkgs.', 97.00, 29, 0, 0),
    (10, 'Ikura', 4, 8, '12 - 200 ml jars', 31.00, 31, 0, 0),
    (11, 'Queso Cabrales', 5, 4, '1 kg pkg.', 21.00, 22, 30, 30),
    (12, 'Queso Manchego La Pastora', 5, 4, '10 - 500 g pkgs.', 38.00, 86, 0, 0);
SET IDENTITY_INSERT Products OFF;
GO

-- Insert Orders
SET IDENTITY_INSERT Orders ON;
INSERT INTO Orders (OrderID, CustomerID, EmployeeID, OrderDate, RequiredDate, ShippedDate, ShipVia, Freight, ShipName, ShipAddress, ShipCity, ShipPostCode, ShipContry)
VALUES
    (1, 1, 1, '2024-01-15 10:30:00', '2024-01-22 00:00:00', '2024-01-18 14:20:00', 1, 29.46, 'Alfreds Futterkiste', 'Obere Str. 57', 'Berlin', '12209', 'Germany'),
    (2, 2, 2, '2024-01-16 09:15:00', '2024-01-23 00:00:00', '2024-01-19 11:00:00', 2, 61.02, 'Ana Trujillo Emparedados y helados', 'Avda. de la Constitución 2222', 'México D.F.', '05021', 'Mexico'),
    (3, 3, 3, '2024-01-17 14:45:00', '2024-01-24 00:00:00', '2024-01-20 16:30:00', 3, 23.94, 'Antonio Moreno Taquería', 'Mataderos 2312', 'México D.F.', '05023', 'Mexico'),
    (4, 4, 1, '2024-01-18 11:20:00', '2024-01-25 00:00:00', '2024-01-21 10:15:00', 1, 69.53, 'Around the Horn', '120 Hanover Sq.', 'London', 'WA1 1DP', 'UK'),
    (5, 5, 2, '2024-01-19 08:00:00', '2024-01-26 00:00:00', '2024-01-22 13:45:00', 2, 41.34, 'Berglunds snabbköp', 'Berguvsvägen 8', 'Luleå', 'S-958 22', 'Sweden'),
    (6, 6, 3, '2024-01-20 15:30:00', '2024-01-27 00:00:00', NULL, 1, 17.55, 'Blauer See Delikatessen', 'Forsterstr. 57', 'Mannheim', '68306', 'Germany'),
    (7, 7, 1, '2024-01-21 10:00:00', '2024-01-28 00:00:00', NULL, 2, 52.51, 'Blondesddsl père et fils', '24, place Kléber', 'Strasbourg', '67000', 'France'),
    (8, 8, 2, '2024-01-22 13:15:00', '2024-01-29 00:00:00', NULL, 3, 59.25, 'Bólido Comidas preparadas', 'C/ Araquil, 67', 'Madrid', '28023', 'Spain');
SET IDENTITY_INSERT Orders OFF;
GO

-- Insert OrderDetails
SET IDENTITY_INSERT OrderDetails ON;
INSERT INTO OrderDetails (OrderDetailsID, OrderID, ProductID, UnitPrice, Quantity, Discount)
VALUES
    (1, 1, 1, 18.00, 10, 0.00),
    (2, 1, 2, 19.00, 5, 0.05),
    (3, 2, 3, 10.00, 15, 0.00),
    (4, 2, 4, 22.00, 8, 0.10),
    (5, 3, 5, 21.35, 12, 0.00),
    (6, 3, 6, 25.00, 6, 0.15),
    (7, 4, 7, 30.00, 20, 0.00),
    (8, 4, 8, 40.00, 4, 0.05),
    (9, 5, 9, 97.00, 2, 0.00),
    (10, 5, 10, 31.00, 10, 0.20),
    (11, 6, 11, 21.00, 15, 0.00),
    (12, 6, 12, 38.00, 8, 0.10),
    (13, 7, 1, 18.00, 25, 0.00),
    (14, 7, 3, 10.00, 30, 0.05),
    (15, 8, 2, 19.00, 20, 0.00),
    (16, 8, 5, 21.35, 10, 0.15);
SET IDENTITY_INSERT OrderDetails OFF;
GO

-- Insert Shipments
SET IDENTITY_INSERT Shipments ON;
INSERT INTO Shipments (ShipmentID, OrderID, ShipperID, ShipmentDate)
VALUES
    (1, 1, 1, '2024-01-18 14:20:00'),
    (2, 2, 2, '2024-01-19 11:00:00'),
    (3, 3, 3, '2024-01-20 16:30:00'),
    (4, 4, 1, '2024-01-21 10:15:00'),
    (5, 5, 2, '2024-01-22 13:45:00');
SET IDENTITY_INSERT Shipments OFF;
GO

-- =============================================
-- Script Complete
-- =============================================
PRINT 'Schema and seed data created successfully!';
GO
