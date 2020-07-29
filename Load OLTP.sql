USE LibraryOLTP;

-- Drop tables if they already exist
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Circulation')
DROP TABLE dbo.Circulation

IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Patron')
DROP TABLE dbo.Patron

IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Copy')
DROP TABLE dbo.Copy

IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Title')
DROP TABLE dbo.Title

-- Create Patron Table
CREATE TABLE dbo.Patron
(
	PatronID char(7) NOT NULL,
	PatronFirstName varchar(20) NOT NULL,
	PatronLastName varchar(25) NOT NULL,
	PatronAddress1 varchar(50) NOT NULL,
	PatronAddress2 varchar(50) NULL,
	PatronCity varchar(20) NOT NULL,
	PatronState varchar(2) NOT NULL,
	PatronZip char(5) NOT NULL,
);

ALTER TABLE dbo.Patron
ADD CONSTRAINT PK_PatronID PRIMARY KEY CLUSTERED (PatronID);


-- Create Title Table
CREATE TABLE dbo.Title
(
	ISBN char(10) NOT NULL,
	Title varchar(200) NOT NULL,
	IsHardback bit NOT NULL,
	IsFiction bit NOT NULL,
	NumPages int NULL,
	Publisher varchar(100) NULL
);

ALTER TABLE dbo.Title
ADD CONSTRAINT PK_ISBN PRIMARY KEY CLUSTERED (ISBN);


-- Create Copy Table
CREATE TABLE dbo.Copy
(
	InventoryID int NOT NULL,
	ISBN char(10) NOT NULL,
);

ALTER TABLE dbo.Copy
ADD CONSTRAINT PK_InventoryID PRIMARY KEY CLUSTERED (InventoryID);

ALTER TABLE dbo.Copy
ADD CONSTRAINT FK_ISBN FOREIGN KEY (ISBN) REFERENCES dbo.Title(ISBN);


-- Create Circulation Table
CREATE TABLE dbo.Circulation
(
	TransactionID int identity(1,1) NOT NULL,
	InventoryID int NOT NULL,
	PatronID char(7) NOT NULL,
	LoanDate date NULL,
	DueDate date NULL,
	ReturnDate date
)

ALTER TABLE dbo.Circulation
ADD CONSTRAINT PK_TransactionID PRIMARY KEY CLUSTERED (TransactionID)

ALTER TABLE dbo.Circulation
ADD CONSTRAINT FK_InventoryID FOREIGN KEY (InventoryID) REFERENCES dbo.Copy(InventoryID)

ALTER TABLE dbo.Circulation
ADD CONSTRAINT FK_Patron FOREIGN KEY (PatronID) REFERENCES dbo.Patron(PatronID)


-- Load Data
-- Load Patron Table

INSERT INTO dbo.Patron(PatronID,PatronFirstName,PatronLastName,PatronAddress1,PatronAddress2,PatronCity,PatronState,PatronZip)
VALUES ('A446RPH','Ralph','Kimball','123 Main Street','Apt 1A','Las Vegas','NV','89123');

INSERT INTO dbo.Patron(PatronID,PatronFirstName,PatronLastName,PatronAddress1,PatronAddress2,PatronCity,PatronState,PatronZip)
VALUES ('THX1138','George','Lucas','234 Han Solo Drive',NULL,'Henderson','NV','89074');

INSERT INTO dbo.Patron(PatronID,PatronFirstName,PatronLastName,PatronAddress1,PatronAddress2,PatronCity,PatronState,PatronZip)
VALUES ('8675309','Jenny','Tutone','1981 Columbia Lane',NULL,'Boulder','NV','89002');

-- Load Title Table

INSERT INTO dbo.Title(ISBN,Title,IsHardback,IsFiction,NumPages,Publisher)
Values ('1783982802','Mastering Predictive Analytics with R',0,0,300,'Packt Publishing');

INSERT INTO dbo.Title(ISBN,Title,IsHardback,IsFiction,NumPages,Publisher)
Values ('1451635621','Gone With the Wind',0,1,960,'Scribner');

INSERT INTO dbo.Title(ISBN,Title,IsHardback,IsFiction,NumPages,Publisher)
Values ('B000HBXY96','Gone With the Wind',1,1,960,'Macmillan');

-- Load Copy Table

INSERT INTO dbo.Copy(InventoryID, ISBN)
VALUES (1,'1783982802')

INSERT INTO dbo.Copy(InventoryID, ISBN)
VALUES (2,'1783982802')

INSERT INTO dbo.Copy(InventoryID, ISBN)
VALUES (3,'1783982802')

INSERT INTO dbo.Copy(InventoryID, ISBN)
VALUES (4,'1451635621')

INSERT INTO dbo.Copy(InventoryID, ISBN)
VALUES (5,'1451635621')

INSERT INTO dbo.Copy(InventoryID, ISBN)
VALUES (6,'B000HBXY96')

INSERT INTO dbo.Copy(InventoryID, ISBN)
VALUES (7,'B000HBXY96')

-- Load Circulation Table

INSERT INTO dbo.Circulation(InventoryID,PatronID,LoanDate,DueDate,ReturnDate)
VALUES(1,'A446RPH','1/20/2018','2/20/2018','2/12/2018')


INSERT INTO dbo.Circulation(InventoryID,PatronID,LoanDate,DueDate,ReturnDate)
VALUES(3,'THX1138','12/1/2017','12/30/2017','1/5/2018')


INSERT INTO dbo.Circulation(InventoryID,PatronID,LoanDate,DueDate,ReturnDate)
VALUES(4,'THX1138','4/2/2018','5/2/2018','5/4/2018')


INSERT INTO dbo.Circulation(InventoryID,PatronID,LoanDate,DueDate,ReturnDate)
VALUES(4,'A446RPH','6/13/2018','7/13/2018','6/14/2018')


INSERT INTO dbo.Circulation(InventoryID,PatronID,LoanDate,DueDate,ReturnDate)
VALUES(5,'8675309','3/4/2018','4/4/2018','4/4/2018')


INSERT INTO dbo.Circulation(InventoryID,PatronID,LoanDate,DueDate,ReturnDate)
VALUES(6,'THX1138','5/3/2018','6/3/2018','7/2/2018')


INSERT INTO dbo.Circulation(InventoryID,PatronID,LoanDate,DueDate,ReturnDate)
VALUES(7,'8675309','9/5/2018','10/5/2018',NULL)


INSERT INTO dbo.Circulation(InventoryID,PatronID,LoanDate,DueDate,ReturnDate)
VALUES(2,'8675309','8/1/2018','9/1/2018',NULL)


INSERT INTO dbo.Circulation(InventoryID,PatronID,LoanDate,DueDate,ReturnDate)
VALUES(3,'A446RPH','1/18/2018','2/18/2018','2/10/2018')


-- Data Check

SELECT * FROM dbo.Circulation
SELECT * FROM dbo.Copy
SELECT * FROM dbo.Title
SELECT * FROM dbo.Patron
