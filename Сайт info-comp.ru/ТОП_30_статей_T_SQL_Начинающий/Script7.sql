/*Статья https://info-comp.ru/obucheniest/626-insert-into-in-t-sql.html*/

USE TestDB;
GO

DROP TABLE IF EXISTS TestTable;
GO

CREATE TABLE TestTable
(
	Id INT IDENTITY(1,1) NOT NULL,
	ProductName VARCHAR(100) NOT NULL,
	Price MONEY NOT NULL
);
GO

CREATE PROCEDURE TestProcedure
AS
BEGIN
	SELECT ProductName, Price
	FROM TestTable
END
GO

INSERT INTO TestTable(ProductName, Price)
VALUES ('Компьютер', 100)
GO

SELECT *
FROM TestTable

INSERT INTO TestTable (ProductName, Price)
VALUES ('Компьютер', 100),
	   ('Клавиатура', 20),
	   ('Монитор', 50)
GO

SELECT *
FROM TestTable

INSERT INTO TestTable (ProductName, Price)
SELECT ProductName, Price
FROM TestTable
WHERE Id > 2
GO

SELECT *
FROM TestTable

INSERT INTO TestTable
SELECT ProductName, Price
FROM TestTable
WHERE Id > 2
GO

SELECT *
FROM TestTable

INSERT INTO TestTable(ProductName, Price)
EXEC TestProcedure
GO

SELECT *
FROM TestTable