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


-- To Do
-- Load Patron Dimension


-- Load Book Dimension



-- Load Time Dimension


-- Load Circulation Fact


-- Verify
SELECT * FROM DimPatron
SELECT * FROM DimBook
SELECT * FROM DimTime
SELECT * FROM FactCirculation