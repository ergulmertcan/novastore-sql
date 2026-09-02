CREATE DATABASE NovaStoreDB;
  GO



USE NovaStoreDB;
 GO

-- kategoriler tablosu
CREATE TABLE Categories
(
     CategoryID INT PRIMARY KEY IDENTITY(1,1),
       CategoryName VARCHAR(50) NOT NULL
);
GO

-- Müşteriler tablosu
CREATE TABLE Customers
(
     CustomerID INT PRIMARY KEY IDENTITY(1,1),
    FullName VARCHAR(50),
      City VARCHAR(20),
     Email VARCHAR(100) UNIQUE
);
GO


-- Ürünler tablosu
CREATE TABLE Products
(
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2),
    Stock INT DEFAULT 0,
    CategoryID INT,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);
GO


-- Siparişler tablosu 
CREATE TABLE Orders 
(
   OrderID INT PRIMARY KEY IDENTITY (1,1),
   CustomerID INT,
   OrderDate DATETIME DEFAULT GETDATE(),
   TotalAmount DECIMAL(10,2),
   FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) 
   );
   GO 

  --Sipariş detayları tablosu

  CREATE TABLE OrderDetails
  (
   DetailID INT PRIMARY KEY IDENTITY(1,1),
   OrderID INT,
   ProductID INT,
   Quantity INT,
   FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
   FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
   );
   GO


   --Kategori verileri

   INSERT INTO Categories (CategoryName)
   VALUES 
   ('Elektronik'),
   ('Bilgisayar'),
   ('Ev ve yasam'),
   ('Kitap'),
   ('Spor');
   GO

   -- Kategori verilerini kontrol etme
SELECT CategoryID, CategoryName
FROM Categories
ORDER BY CategoryID;
GO

-- Ürün verileri
 INSERT INTO Products (ProductName, Price, Stock, CategoryID)
  VALUES
('Kablosuz Kulaklik', 1200.00, 15, 1),
('Akilli Saat', 2500.00, 8, 1),
('Bluetooth Hoparlor', 900.00, 25, 1),
('Oyuncu Mouse', 700.00, 18, 2),
('Mekanik Klavye', 1600.00, 12, 2),
('Laptop Standi', 500.00, 30, 2),
('Kahve Makinesi', 2200.00, 10, 3),
('Masa Lambasi', 600.00, 22, 3),
('SQL Temelleri', 300.00, 40, 4),
('Veritabani Tasarimi', 250.00, 14, 4),
('Yoga Mati', 500.00, 16, 5),
('Direnc Lastigi Seti', 400.00, 35, 5);
GO

-- Müşteri verileri
  INSERT INTO Customers (FullName, City, Email)
  VALUES
('Ergul Mertcan', 'Izmir', 'ergul.mertcan@example.com'),
('Bugra Yilmaz', 'Istanbul', 'bugra.yilmaz@example.com'),
('Tugra Kaya', 'Ankara', 'tugra.kaya@example.com'),
('Hakan Demir', 'Bursa', 'hakan.demir@example.com'),
('Alp Arslan', 'Antalya', 'alp.arslan@example.com');
GO

-- Müşteri ve ürün ID değerlerini kontrol etme
SELECT CustomerID, FullName
FROM Customers
ORDER BY CustomerID;

SELECT ProductID, ProductName
FROM Products
ORDER BY ProductID;
GO

-- Sipariş verileri
INSERT INTO Orders (CustomerID, OrderDate, TotalAmount)
VALUES
(1, '20260701', 3200.00),
(2, '20260705', 1800.00),
(3, '20260712', 2900.00),
(4, '20260720', 1100.00),
(5, '20260725', 1000.00),
(1, '20260801', 3000.00),
(2, '20260805', 1850.00),
(3, '20260810', 2400.00),
(4, '20260812', 2300.00),
(5, '20260815', 3200.00);
GO

-- Sipariş ID değerlerini kontrol etme
SELECT OrderID, CustomerID, OrderDate, TotalAmount
FROM Orders
ORDER BY OrderID;
GO

-- Sipariş detay verileri
  INSERT INTO OrderDetails (OrderID, ProductID, Quantity)
    VALUES
(1, 1, 1),
(1, 5, 1),
(1, 12, 1),
(2, 3, 2),
(3, 7, 1),
(3, 4, 1),
(4, 8, 1),
(4, 11, 1),
(5, 9, 2),
(5, 12, 1),
(6, 2, 1),
(6, 6, 1),
(7, 5, 1),
(7, 10, 1),
(8, 1, 2),
(9, 3, 1),
(9, 4, 2),
(10, 7, 1),
(10, 11, 2);
GO

-- Eklenen kayıt sayılarını kontrol etme
 SELECT COUNT(*) AS KategoriSayisi FROM Categories;
  SELECT COUNT(*) AS UrunSayisi FROM Products;
   SELECT COUNT(*) AS MusteriSayisi FROM Customers;
    SELECT COUNT(*) AS SiparisSayisi FROM Orders;
    SELECT COUNT(*) AS SiparisDetaySayisi FROM OrderDetails;
    GO

    -- Sorgu 1: Stogu 20'den az olan urunler
SELECT ProductName, Stock
FROM Products
WHERE Stock < 20
ORDER BY Stock DESC;
GO

-- Sorgu 2: Musteriler ve siparis bilgileri
SELECT
    Customers.FullName,
    Customers.City,
    Orders.OrderDate,
    Orders.TotalAmount
FROM Customers
INNER JOIN Orders
    ON Customers.CustomerID = Orders.CustomerID;
GO


-- Sorgu 3: Secilen musterinin aldigi urunler
SELECT
    Products.ProductName,
    Products.Price,
    Categories.CategoryName
FROM Customers
INNER JOIN Orders
    ON Customers.CustomerID = Orders.CustomerID
INNER JOIN OrderDetails
    ON Orders.OrderID = OrderDetails.OrderID
INNER JOIN Products
    ON OrderDetails.ProductID = Products.ProductID
INNER JOIN Categories
    ON Products.CategoryID = Categories.CategoryID
WHERE Customers.FullName = 'Ergul Mertcan';
GO


-- Sorgu 4: Her kategorideki toplam urun sayisi
SELECT
    Categories.CategoryName,
    COUNT(Products.ProductID) AS ProductCount
FROM Categories
LEFT JOIN Products
    ON Categories.CategoryID = Products.CategoryID
GROUP BY Categories.CategoryName;
GO


-- Sorgu 5: Her musterinin toplam cirosu
SELECT
    Customers.FullName,
    SUM(Orders.TotalAmount) AS TotalRevenue
FROM Customers
INNER JOIN Orders
    ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.FullName
ORDER BY TotalRevenue DESC;
GO


-- Sorgu 6: Siparislerin uzerinden gecen gun sayisi
SELECT
    OrderID,
    OrderDate,
    DATEDIFF(DAY, OrderDate, GETDATE()) AS DaysPassed
FROM Orders
ORDER BY OrderID;
GO



-- Siparis ozet gorunumu
CREATE VIEW vw_SiparisOzet
AS
SELECT
    Customers.FullName,
    Orders.OrderDate,
    Products.ProductName,
    OrderDetails.Quantity
FROM Customers
INNER JOIN Orders
    ON Customers.CustomerID = Orders.CustomerID
INNER JOIN OrderDetails
    ON Orders.OrderID = OrderDetails.OrderID
INNER JOIN Products
    ON OrderDetails.ProductID = Products.ProductID;
GO


-- Siparis ozet gorunumunu test etme
SELECT *
FROM vw_SiparisOzet;
GO


-- NovaStoreDB veritabaninin yedegini alma
BACKUP DATABASE NovaStoreDB
TO DISK = 'C:\Yedek\NovaStoreDB.bak';
GO