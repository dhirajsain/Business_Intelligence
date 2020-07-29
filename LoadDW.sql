use LibraryDW;

-- Drop Foreign Keys
ALTER TABLE dbo.FactCirculation
DROP CONSTRAINT FK_Patron;

ALTER TABLE dbo.FactCirculation
DROP CONSTRAINT FK_Book;

ALTER TABLE dbo.FactCirculation
DROP CONSTRAINT FK_CheckOutTime;

ALTER TABLE dbo.FactCirculation
DROP CONSTRAINT FK_ReturnDateTime;

ALTER TABLE dbo.FactCirculation
DROP CONSTRAINT FK_DueDateTime;

-- Truncate Tables
TRUNCATE TABLE dbo.FactCirculation;
TRUNCATE TABLE dbo.DimPatron;
TRUNCATE TABLE dbo.DimBook;
TRUNCATE TABLE DimTime;

-- Reset Foreign Keys
ALTER TABLE dbo.FactCirculation
ADD CONSTRAINT FK_Patron FOREIGN KEY (PatronSK) REFERENCES dbo.DimPatron(PatronSK);

ALTER TABLE dbo.FactCirculation
ADD CONSTRAINT FK_Book FOREIGN KEY (BookSK) REFERENCES dbo.DimBook(BookSK);

ALTER TABLE dbo.FactCirculation
ADD CONSTRAINT FK_CheckOutTime FOREIGN KEY (CheckOutTimeSK) REFERENCES dbo.DimTime(TimeSK);

ALTER TABLE dbo.FactCirculation
ADD CONSTRAINT FK_ReturnDateTime FOREIGN KEY (ReturnDateTimeSK) REFERENCES dbo.DimTime(TimeSK)

ALTER TABLE dbo.FactCirculation
ADD CONSTRAINT FK_DueDateTime FOREIGN KEY (DueDateTimeSK) REFERENCES dbo.DimTime(TimeSK);


-- Load Patron Dimension
INSERT INTO dbo.DimPatron 
	(PatronID
	,PatronFirstName
	,PatronLastName
	,PatronAddress1
	,PatronAddress2
	,PatronCity
	,PatronState
	,PatronZip)
SELECT 
	  PatronID
	 ,PatronFirstName
	 ,PatronLastName
	 ,PatronAddress1
	 ,PatronAddress2
	 ,PatronCity
	 ,PatronState
	 ,PatronZip
FROM LibraryOLTP.dbo.Patron;


-- Load Book Dimension
INSERT INTO DimBook
	(InventoryID
	,ISBN
	,Title
	,IsHardback
	,IsFiction
	,NumPages
	,Publisher)
SELECT
	 Copy.InventoryID
	,Title.ISBN
	,Title.Title
	,Title.IsHardback
	,Title.IsFiction
	,Title.NumPages
	,Title.Publisher
FROM LibraryOLTP.dbo.Title INNER JOIN LibraryOLTP.dbo.Copy
	ON Title.ISBN = Copy.ISBN


-- Load Time Dimension
CREATE TABLE #DateList (LoadDate Date NULL)

INSERT INTO #DateList
SELECT DISTINCT LoanDate FROM LibraryOLTP.dbo.Circulation
UNION
SELECT DISTINCT DueDate FROM LibraryOLTP.dbo.Circulation
UNION
SELECT DISTINCT ReturnDate FROM LibraryOLTP.dbo.Circulation

INSERT INTO dbo.DimTime
	(Date
	,Year
	,Month
	,MonthName
	,Day
	,DayOfWeek
	,WeekNumber
	,Quarter)
SELECT
	 LoadDate
	,YEAR(LoadDate)
	,MONTH(LoadDate)
	,DATENAME(month,LoadDate)
	,DAY(LoadDate)
	,DATENAME(weekday, LoadDate)
	,DATENAME(week, LoadDate)
	,DATENAME(quarter, LoadDate)
FROM #DateList

DROP TABLE #DateList

-- Load Circulation Fact
INSERT INTO dbo.FactCirculation
	(PatronSK
	,BookSK
	,CheckOutTimeSK
	,DueDateTimeSK
	,ReturnDateTimeSK
	,IsCheckedOut
	,IsOverdue)
SELECT 
	 PatronSK
	,BookSK
	,t1.TimeSK as CheckOutTimeSK
	,t2.TimeSK as DueDateTimeSK
	,t3.TimeSK as ReturnDateTimeSK
	,CASE WHEN ReturnDate IS NULL THEN 1 ELSE 0 END as IsCheckedOut
	,CASE WHEN (ReturnDate IS NOT NULL AND DueDate < ReturnDate) OR (ReturnDate IS NULL AND DueDate < GetDate()) THEN 1 ELSE 0 END as IsOverdue
FROM LibraryOLTP.dbo.Circulation circ
INNER JOIN DimPatron dimP
	on circ.PatronID = dimP.PatronID
INNER JOIN DimBook b
	on circ.InventoryID = b.InventoryID
INNER JOIN DimTime t1
	on circ.LoanDate = t1.Date
INNER JOIN DimTime t2
	on circ.DueDate = t2.Date
INNER JOIN DimTime t3
	on ISNULL(circ.ReturnDate, '1/1/2999') = ISNULL(t3.Date,  '1/1/2999')


SELECT * FROM DimPatron
SELECT * FROM DimBook
SELECT * FROM DimTime
SELECT * FROM FactCirculation