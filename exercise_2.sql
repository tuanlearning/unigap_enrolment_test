-- Customer Table
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(100)
);

-- SCD1 Address Table
-- In SCD1, the old data is overwritten with the new data. No history is kept.
-- Pros: light-weight table, save space compare to other type of SCD
-- Cons: no historical data

CREATE TABLE Address_SCD1 (
    CustomerID INT PRIMARY KEY,
    AddressLine1 VARCHAR(100),
    AddressLine2 VARCHAR(100),
    City VARCHAR(50),
    State VARCHAR(50),
    ZipCode VARCHAR(20),
    Country VARCHAR(50),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

-- SCD2 Address Table
-- In SCD2, the history of changes is preserved by adding new rows for each change with effective dates and flags.
-- Pros: can access to full historical data
-- take a lot of space, especially for tables with entities that are continuously being updated

CREATE TABLE Address_SCD2 (
    AddressID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    AddressLine1 VARCHAR(100),
    AddressLine2 VARCHAR(100),
    City VARCHAR(50),
    State VARCHAR(50),
    ZipCode VARCHAR(20),
    Country VARCHAR(50),
    StartDate DATE,
    EndDate DATE,
    IsCurrent BOOLEAN,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

-- SCD3 Address Table
-- In SCD3, only a limited history is kept, usually just the current and previous values.
-- Pros: A balance between SCD1 and SCD2, more light-weight compare to SCD-2 while still being able to maintain some historical data
-- Cons: Cannot access to full historical data like SCD2

CREATE TABLE Address_SCD3 (
    CustomerID INT PRIMARY KEY,
    CurrentAddressLine1 VARCHAR(100),
    CurrentAddressLine2 VARCHAR(100),
    CurrentCity VARCHAR(50),
    CurrentState VARCHAR(50),
    CurrentZipCode VARCHAR(20),
    CurrentCountry VARCHAR(50),
    PreviousAddressLine1 VARCHAR(100),
    PreviousAddressLine2 VARCHAR(100),
    PreviousCity VARCHAR(50),
    PreviousState VARCHAR(50),
    PreviousZipCode VARCHAR(20),
    PreviousCountry VARCHAR(50),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

-- SCD4 Address Tables
-- In SCD4, the current data is maintained in one table, and the historical data is kept in a separate table.
-- Pros: Provide flexibility tailor to each analytical needs. For example if my dashboard only needs to query the latest data, I only need to query from the Current_Address table
-- Cons: still storage requirements, flexibility in ETL process, additional complexity in queries
CREATE TABLE Current_Address_SCD4 (
    CustomerID INT PRIMARY KEY,
    AddressLine1 VARCHAR(100),
    AddressLine2 VARCHAR(100),
    City VARCHAR(50),
    State VARCHAR(50),
    ZipCode VARCHAR(20),
    Country VARCHAR(50),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

CREATE TABLE Historical_Address_SCD4 (
    AddressID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    AddressLine1 VARCHAR(100),
    AddressLine2 VARCHAR(100),
    City VARCHAR(50),
    State VARCHAR(50),
    ZipCode VARCHAR(20),
    Country VARCHAR(50),
    ChangeDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);