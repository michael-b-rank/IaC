-- schema.sql

----------------------------------------------------------
-- 1. Create Schema (Optional but recommended for organization)
----------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'app')
EXEC('CREATE SCHEMA app');
GO

----------------------------------------------------------
-- 2. Create Table: Users
----------------------------------------------------------
IF OBJECT_ID('app.Users', 'U') IS NULL
BEGIN
    CREATE TABLE app.Users
    (
        UserID INT IDENTITY(1,1) PRIMARY KEY,
        FirstName NVARCHAR(50) NOT NULL,
        LastName NVARCHAR(50) NOT NULL,
        Email NVARCHAR(100) NOT NULL UNIQUE,
        CreatedAt DATETIME2(7) DEFAULT GETUTCDATE()
    );

    -- Create a non-clustered index on the email column for fast lookups
    CREATE UNIQUE NONCLUSTERED INDEX IDX_Users_Email 
    ON app.Users (Email);
END
GO

----------------------------------------------------------
-- 3. Create Table: Orders
----------------------------------------------------------
IF OBJECT_ID('app.Orders', 'U') IS NULL
BEGIN
    CREATE TABLE app.Orders
    (
        OrderID INT IDENTITY(1000,1) PRIMARY KEY,
        UserID INT NOT NULL,
        OrderDate DATETIME2(7) DEFAULT GETUTCDATE(),
        TotalAmount DECIMAL(10, 2) NOT NULL,
        
        -- Define Foreign Key constraint to link to Users table
        CONSTRAINT FK_Orders_Users FOREIGN KEY (UserID)
        REFERENCES app.Users (UserID)
    );

    -- Create a non-clustered index on UserID for efficient joining/lookup
    CREATE NONCLUSTERED INDEX IDX_Orders_UserID 
    ON app.Orders (UserID);
END
GO

----------------------------------------------------------
-- 4. Sample Data Insertion (Optional - often done in a separate seed script)
----------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM app.Users WHERE Email = 'jane.doe@example.com')
BEGIN
    INSERT INTO app.Users (FirstName, LastName, Email)
    VALUES ('Jane', 'Doe', 'jane.doe@example.com');
END
GO