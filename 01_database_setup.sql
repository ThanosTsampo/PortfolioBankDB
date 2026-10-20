-- 1. ΔΗΜΙΟΥΡΓΙΑ ΒΑΣΗΣ ΔΕΔΟΜΕΝΩΝ
CREATE DATABASE PortfolioBankDB;
GO
USE PortfolioBankDB;
GO
-- 2. ΕΙΣΑΓΩΓΗ ΠΙΝΑΚΑ CUSTOMERS ΜΕ IMPORT FLAT FILE ΚΑΙ ΟΡΙΣΜΟ ΤΥΠΟΥ ΜΕΤΑΒΛΗΤΩΝ
-- 3. ΔΗΜΙΟΥΡΓΙΑ ΠΙΝΑΚΩΝ (DDL)
CREATE TABLE dbo.Accounts (
    account_id   INT PRIMARY KEY,
    customer_id  INT NOT NULL,
    account_type VARCHAR(50) NOT NULL,
    open_date    DATE NOT NULL,
    balance      DECIMAL(18, 2) NOT NULL,
    CONSTRAINT FK_Accounts_Customers FOREIGN KEY (customer_id) REFERENCES dbo.Customers(customer_id)
);
CREATE TABLE dbo.Products (
    product_id  INT PRIMARY KEY,
    customer_id INT NOT NULL,
    type        VARCHAR(50) NOT NULL,
    amount      DECIMAL(18, 2) NOT NULL,
    status      VARCHAR(20) NOT NULL,
    CONSTRAINT FK_Products_Customers FOREIGN KEY (customer_id) REFERENCES dbo.Customers(customer_id)
);
CREATE TABLE dbo.Transactions (
    transaction_id   INT PRIMARY KEY,
    account_id       INT NOT NULL,
    transaction_date DATE NOT NULL,
    amount           DECIMAL(18, 2) NOT NULL,
    transaction_type VARCHAR(20) NOT NULL,
    CONSTRAINT FK_Transactions_Accounts FOREIGN KEY (account_id) REFERENCES dbo.Accounts(account_id)
);
GO
-- 4. BULK INSERT ΑΠΟ 2 CSV ARCHIVE FILES 
BULK INSERT dbo.Accounts FROM 'C:\Users\athan\OneDrive\Desktop\accounts.csv' WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n');
BULK INSERT dbo.Products FROM 'C:\Users\athan\OneDrive\Desktop\products.csv' WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n');
-- 5. ΑΜΕΣΗ ΕΙΣΑΓΩΓΗ TRANSACTIONS (INSERT INTO)
INSERT INTO dbo.Transactions (transaction_id, account_id, transaction_date, amount, transaction_type) VALUES (1, 1001, '2024-01-05', 1200.00, 'Deposit'),(2, 1001, '2024-01-20', 300.00, 'Withdrawal'),(3, 1001, '2024-02-10', 1500.00, 'Deposit'),(4, 1001, '2024-02-28', 450.00, 'Withdrawal'),(5, 1001, '2024-03-05', 2000.00, 'Deposit'),(6, 1001, '2024-03-25', 100.00, 'Withdrawal'),(7, 1002, '2023-11-15', 10000.00, 'Deposit'),(8, 1002, '2024-01-10', 5000.00, 'Deposit'),(9, 1002, '2024-03-12', 12000.00, 'Deposit'),(10, 1004, '2023-10-01', 50.00, 'Deposit'),(11, 1004, '2024-02-15', 200.00, 'Withdrawal'),(12, 1004, '2024-03-01', 50.00, 'Withdrawal'),(13, 1006, '2023-08-10', 1000.00, 'Deposit'),(14, 1006, '2023-09-12', 500.00, 'Withdrawal'),(15, 1006, '2024-03-10', 3000.00, 'Deposit'),(16, 1007, '2024-01-12', 800.00, 'Deposit'),(17, 1007, '2024-02-14', 150.00, 'Withdrawal'),(18, 1007, '2024-03-18', 400.00, 'Deposit'),(19, 1008, '2023-12-01', 100.00, 'Deposit'),(20, 1008, '2023-12-20', 600.00, 'Withdrawal'),(21, 1009, '2024-01-08', 50000.00, 'Deposit'),(22, 1009, '2024-02-11', 20000.00, 'Withdrawal'),(23, 1009, '2024-03-02', 100000.00, 'Deposit'),(24, 1010, '2022-05-10', 1500.00, 'Deposit'),(25, 1010, '2022-08-15', 200.00, 'Withdrawal'),(26, 1011, '2024-02-01', 900.00, 'Deposit'),(27, 1011, '2024-03-20', 250.00, 'Withdrawal'),(28, 1012, '2023-01-10', 500.00, 'Deposit'),(29, 1012, '2023-02-11', 500.00, 'Withdrawal'),(30, 1013, '2023-11-05', 3000.00, 'Deposit'),(31, 1013, '2023-12-10', 500.00, 'Withdrawal'),(32, 1013, '2024-01-15', 1200.00, 'Deposit'),(33, 1013, '2024-03-01', 800.00, 'Deposit'),(34, 1014, '2024-01-10', 5000.00, 'Deposit'),(35, 1014, '2024-02-12', 2000.00, 'Withdrawal'),(36, 1014, '2024-03-15', 10000.00, 'Deposit'),(37, 1015, '2024-03-01', 100.00, 'Withdrawal');
GO
-- 6. ΕΠΙΒΕΒΑΙΩΣΗ ΕΙΣΑΓΩΓΗΣ (RECORD COUNT)
SELECT 'Customers' AS TableName, COUNT(*) AS TotalRows FROM dbo.Customers
UNION ALL
SELECT 'Accounts', COUNT(*) FROM dbo.Accounts
UNION ALL
SELECT 'Products', COUNT(*) FROM dbo.Products
UNION ALL
SELECT 'Transactions', COUNT(*) FROM dbo.Transactions;
GO
