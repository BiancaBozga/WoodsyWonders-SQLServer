CREATE DATABASE WoodsyWonders
use WoodsyWonders
go
CREATE TABLE Factories
(Fid INT PRIMARY KEY IDENTITY(1,1),
Surface INT CHECK(Surface>0),
City varchar(50) NOT NULL
)
CREATE TABLE Products
(Pid INT PRIMARY KEY IDENTITY(7000,1),
Name varchar(50) NOT NULL,
Quantity int CHECK (Quantity>0),
Price int CHECK (Price>0),
Color varchar(20) default 'brown')

CREATE TABLE Shops
(Sid INT PRIMARY KEY IDENTITY(5000,1),
Name varchar(50) NOT NULL,
City varchar(50) NOT NULL,
OpenTime TIME,
CloseTime TIME,
Fid INT FOREIGN KEY REFERENCES Factories(Fid)
)

CREATE TABLE ShopsProducts
(Pid INT FOREIGN KEY REFERENCES Products(Pid),
Sid INT FOREIGN KEY REFERENCES shops(Sid),
CONSTRAINT pk_Products PRIMARY KEY(Pid,Sid)
)
CREATE TABLE Advertisements
(Adid INT PRIMARY KEY IDENTITY(1,1),
Type varchar(50) NOT NULL,
Cost INT,
Pid INT FOREIGN KEY REFERENCES  Products(Pid)

)
CREATE TABLE Employee
(CNP VARCHAR(13) PRIMARY KEY CHECK (CNP LIKE '5%' OR CNP LIKE '6%'),
Name varchar(50) NOT NULL,
Salary int ,
Hours int CHECK(Hours>0),
 Email VARCHAR(50) UNIQUE,
 Fid INT FOREIGN KEY REFERENCES Factories(Fid),
)
CREATE TABLE DrivingLicense (
    
 CNPDL VARCHAR(13) CHECK (CNPDL LIKE '5%' OR CNPDL LIKE '6%') UNIQUE FOREIGN KEY REFERENCES Employee(CNP),
    LicenseNumber NVARCHAR(20),
  CONSTRAINT pk_DL PRIMARY KEY(CNPDL)
)
CREATE TABLE Transports
(AutoNumber varchar(70) PRIMARY KEY ,
Tip varchar(20) NOT NULL,
Capacity INT 

)

CREATE TABLE Taxes
(Tid INT PRIMARY KEY IDENTITY(1,1),
Cost FLOAT ,
Status VARCHAR(20) CHECK (Status IN ('paid', 'unpaid', 'processing')),
Deadline DATE,
AutoNumber varchar(70) FOREIGN KEY REFERENCES  Transports(AutoNumber)

)
CREATE TABLE TransportsFactories
(Fid INT FOREIGN KEY REFERENCES Factories(Fid),
AutoNumber varchar(70) FOREIGN KEY REFERENCES Transports(AutoNumber),
CONSTRAINT pk_Transportss PRIMARY KEY(Fid,AutoNumber)
)