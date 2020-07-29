USE LibraryDW;

-- Drop tables if they already exist
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'FactCirculation')
DROP TABLE dbo.FactCirculation

IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'DimPatron')
DROP TABLE dbo.DimPatron

IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'DimBook')
DROP TABLE dbo.DimBook

IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'DimTime')
DROP TABLE dbo.DimTime


-- Create Patron Dimension
CREATE TABLE dbo.DimPatron
(
	PatronSK int identity (1,1) NOT NULL,
	PatronID char(7) NOT NULL,
	PatronFirstName varchar(20) NOT NULL,
	PatronLastName varchar(25) NOT NULL,
	PatronAddress1 varchar(50) NOT NULL,
	PatronAddress2 varchar(50) NULL,
	PatronCity varchar(20) NOT NULL,
	PatronState varchar(2) NOT NULL,
	PatronZip char(5) NOT NULL
);


ALTER TABLE dbo.DimPatron
ADD CONSTRAINT PK_PatronSK PRIMARY KEY CLUSTERED (PatronSK);


-- Create Book Dimension
CREATE TABLE DimBook
(
	BookSK int identity(1,1) NOT NULL,
	InventoryID int NOT NULL,
	ISBN char(10) NOT NULL,
	Title varchar(200) NOT NULL,
	IsHardback bit NOT NULL,
	IsFiction bit NOT NULL,
	NumPages int NULL,
	Publisher varchar(100) NULL
)

ALTER TABLE dbo.DimBook
ADD CONSTRAINT PK_BookSK PRIMARY KEY CLUSTERED (BookSK);


-- Create Time Dimension
CREATE TABLE DimTime
(
	TimeSK int identity(1,1) NOT NULL,
	Date Date NULL,
	Year int NULL,
	Month int NULL,
	MonthName varchar(15) NULL,
	Day int NULL,
	DayOfWeek varchar(10) NULL,
	WeekNumber int NULL,
	Quarter int NULL
)

ALTER TABLE dbo.DimTime
ADD CONSTRAINT PK_TimeSK PRIMARY KEY CLUSTERED (TimeSK)


-- Create Circulation Fact
CREATE TABLE FactCirculation
(
	-- Keys
	CirculationSK int NOT NULL identity(1,1),
	PatronSK int NOT NULL,
	BookSK int NOT NULL,
	CheckOutTimeSK int NOT NULL,
	DueDateTimeSK int NOT NULL,
	ReturnDateTimeSK int NOT NULL,
	
	-- Measures
	IsCheckedOut bit NOT NULL,
	IsOverdue bit NOT NULL
)

ALTER TABLE dbo.FactCirculation
ADD CONSTRAINT PK_Circulation PRIMARY KEY CLUSTERED (CirculationSK)

ALTER TABLE dbo.FactCirculation
ADD CONSTRAINT FK_Patron FOREIGN KEY (PatronSK) REFERENCES dbo.DimPatron(PatronSK)

ALTER TABLE dbo.FactCirculation
ADD CONSTRAINT FK_Book FOREIGN KEY (BookSK) REFERENCES dbo.DimBook(BookSK)

ALTER TABLE dbo.FactCirculation
ADD CONSTRAINT FK_CheckOutTime FOREIGN KEY (CheckOutTimeSK) REFERENCES dbo.DimTime(TimeSK)

ALTER TABLE dbo.FactCirculation
ADD CONSTRAINT FK_ReturnDateTime FOREIGN KEY (ReturnDateTimeSK) REFERENCES dbo.DimTime(TimeSK)

ALTER TABLE dbo.FactCirculation
ADD CONSTRAINT FK_DueDateTime FOREIGN KEY (DueDateTimeSK) REFERENCES dbo.DimTime(TimeSK)