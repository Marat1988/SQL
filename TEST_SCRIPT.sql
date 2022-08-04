CREATE DATABASE TestDB
GO
DROP DATABASE TestDB
GO
CREATE TABLE TestTable (
	ProductId		INT IDENTITY(1,1) NOT NULL,
	CategotyId		INT NOT NULL,
	ProductName		VARCHAR(100) NOT NULL,
	Price			Money NULL)
GO
CREATE TABLE TestTable2(
	CategoryId		INT IDENTITY(1,1) NOT NULL,
	CategoryName	VARCHAR(100) NOT NULL)
GO
CREATE TABLE TestTable3(
	ProductId		INT IDENTITY(1,1) NOT NULL,
	ProductName		VARCHAR(100) NOT NULL,
	[Weigth]		DECIMAL(18,2) NULL,
	Price			MONEY NULL,
	Summa AS (Weigth*Price) PERSISTED)
GO
ALTER TABLE TestTable3 ADD SummaDop AS ([Weigth]*[Price]) PERSISTED
GO
DROP TABLE TestTabl-e3
GO
ALTER TABLE TestTable ALTER COLUMN Price Money NOT NULL
GO
ALTER TABLE TestTable DROP COLUMN Price
GO
ALTER TABLE TestTable ADD Price MONEY NULL
GO
CREATE TABLE #TestTable(
	[ID]				INT IDENTITY(1,1) NOT NULL,
	[ProductName]		[VARCHAR](100) NOT NULL,
	[Price]				[Money] NOT NULL)
GO
DROP TABLE #TestTable
GO
INSERT INTO TestTable
	VALUES (1,'Клавиатура',100),
		   (1,'Мышь',50),
		   (2,'Телефон',300)
GO
INSERT INTO TestTable2
	VALUES ('Комплектующие компьютера'),
		   ('Мобильные устройства')
GO
SELECT ProductId, ProductName, Price
FROM TestTable
GO
SELECT TOP 2 ProductId, ProductName, Price
FROM TestTable
GO
SELECT TOP 2 WITH TIES ProductId, ProductName, Price
FROM TestTable
ORDER BY Price DESC
GO
SELECT TOP 20 PERCENT ProductId, ProductName, Price
FROM TestTable
ORDER BY Price DESC
GO
SELECT DISTINCT ProductName, Price
FROM TestTable
GO
SELECT *
FROM TestTable
GO
SELECT *
FROM TestDB.dbo.TestTable
GO
SELECT T.ProductId AS ID,
	   T.ProductName AS ProductName,
	   T.Price AS [Цена]
FROM TestTable AS T
GO
SELECT ProductId,
	   ProductName,
	   Price
FROM TestTable
WHERE Price>=100 AND Price<=500
GO
SELECT ProductId,
	   ProductName,
	   Price
FROM TestTable
WHERE Price BETWEEN 100 AND 500
GO
SELECT ProductId,
	   ProductName,
	   Price
FROM TestTable
WHERE ProductName LIKE 'Т%'
GO
SELECT ProductId,
	   ProductName,
	   Price
FROM TestTable
WHERE Price IN (50,100)
GO
SELECT ProductId,
	   ProductName,
	   Price
FROM TestTable
WHERE Price=50 OR Price=100
GO
SELECT ProductId,
	   ProductName,
	   Price
FROM TestTable
WHERE Price IS NOT NULL
GO
SELECT COUNT(*) AS [Количество строк],
	   SUM(Price) AS [Сумма по столбцу Price],
	   MAX(Price) AS [Максимальное значение в столбце Price],
	   MIN(Price) AS [Минимальное значение в столбце Price],
	   AVG(Price) AS [Среднее значение в столбце Price]
FROM TestTable
GO
SELECT CategoryId AS [Id категории],
	   COUNT(*) AS [Количество строк],
	   SUM(Price) AS [Сумма по столбцу Price],
	   MAX(Price) AS [Максимальное значение в столбце Price],
	   MIN(Price) AS [Минимальное значение в столбце Price],
	   AVG(Price) AS [Среднее значение в столбце Price]
FROM TestTable
GROUP BY CategoryId
GO
SELECT CategoryId AS [Id категории],
	   COUNT(*) AS [Количество строк],
	   MAX(Price) AS [Максимальное значение в столбце Price],
	   MIN(Price) AS [Минимальное значение в столбце Price],
	   AVG(Price) AS [Среднее значение в столбце Price]
FROM TestTable
WHERE ProductId<>1
GROUP BY CategoryId
GO
SELECT CategoryId AS [Id категории],
	   COUNT(*) AS [Количество строк]
FROM TestTable
GROUP BY CategoryId
HAVING COUNT(*)>1
GO
SELECT ProductId,
	   ProductName,
	   Price
FROM TestTable
ORDER BY Price
GO
SELECT ProductId,
	   ProductName,
	   Price
FROM TestTable
ORDER BY Price DESC
GO
SELECT ProductId,
	   ProductName,
	   Price
FROM TestTable
ORDER BY Price DESC, ProductId
GO
SELECT ProductId,
	   ProductName,
	   Price
FROM TestTable
ORDER BY 3 DESC, 1
GO
SELECT ProductId,
       ProductName,
	   Price
FROM TestTable
ORDER BY Price DESC
OFFSET 1 ROWS
GO
SELECT ProductId,
	   ProductName,
	   Price
FROM TestTable
ORDER BY Price DESC
OFFSET 1 ROWS FETCH NEXT 1 ROWS ONLY
GO
SELECT T1.ProductName,
	   T2.CategoryName,
	   T1.Price
FROM TestTable T1
INNER JOIN TestTable2 T2 ON t1.CategoryId=T2.CategoryId
ORDER BY T1.CategoryId
GO
SELECT T1.ProductName,
	   T2.CategoryName,
	   T1.Price
FROM TestTable T1
LEFT JOIN TestTable2 T2 ON T1.CategoryId=T2.CategoryId
ORDER BY T1.CategoryId
GO
SELECT T1.ProductName,
       T2.CategoryName,
	   T1.Price
FROM TestTable T1
INNER JOIN TestTable2 T2 ON t1.CategoryId=3
ORDER BY T1.CategoryId
GO
SELECT T1.ProductName,
       T2.CategoryName,
	   T1.Price
FROM TestTable T1
LEFT JOIN TestTable2 T2 ON t1.CategoryId=3
ORDER BY T1.CategoryId
GO
SELECT T1.ProductName,
	   T2.CategoryName,
	   T1.Price
FROM TestTable T1
RIGHT JOIN TestTable2 T2 ON T1.CategoryId=T2.CategoryId
ORDER BY T1.CategoryId
GO
SELECT T1.ProductName,
	   T2.CategoryName,
	   T1.Price
FROM TestTable T1
RIGHT JOIN TestTable2 T2 ON t1.CategoryId=3
ORDER BY T1.CategoryId
GO
SELECT T1.ProductName,
	   T2.CategoryName,
	   T1.Price
FROM TestTable T1
FULL JOIN TestTable2 T2 ON t1.CategoryId=3
ORDER BY T1.CategoryId
GO
SELECT T1.ProductName,
	   T2.CategoryName,
	   T1.Price
FROM TestTable T1
CROSS JOIN TestTable2 T2
ORDER BY T1.CategoryId
GO
SELECT T1.ProductName,
	   T2.CategoryName,
	   T1.Price
FROM TestTable T1
CROSS JOIN TestTable2 T2
WHERE T1.CategoryId=T2.CategoryId
ORDER BY T1.CategoryId
GO
SELECT T1.ProductId,
	   T1.ProductName,
	   T1.Price
FROM TestTable T1
WHERE T1.ProductId=1
UNION
SELECT T1.ProductId,
	   T1.ProductName,
	   T1.Price
FROM TestTable T1
WHERE T1.ProductId=3
GO
SELECT T1.ProductId,
	   T1.ProductName,
	   T1.Price
FROM TestTable T1
WHERE T1.ProductId=1
UNION
SELECT T1.ProductId,
	   T1.ProductName,
	   T1.Price
FROM TestTable T1
WHERE T1.ProductId=1
GO
SELECT T1.ProductId,
	   T1.ProductName,
	   T1.Price
FROM TestTable T1
WHERE T1.ProductId=1
UNION ALL
SELECT T1.ProductId,
	   T1.ProductName,
	   T1.Price
FROM TestTable T1
WHERE T1.ProductId=1
GO
SELECT T1.ProductId,
	   T1.ProductName,
	   T1.Price
FROM TestTable T1
WHERE T1.ProductId=1
INTERSECT
SELECT T1.ProductId,
	   T1.ProductName,
	   T1.Price
FROM TestTable T1
WHERE T1.ProductId=1
GO
SELECT T1.ProductId,
	   T1.ProductName,
	   T1.Price
FROM TestTable T1
WHERE T1.ProductId=1
UNION
SELECT T1.ProductId,
	   T1.ProductName,
	   T1.Price
FROM TestTable T1
WHERE T1.ProductId=2
GO
SELECT T1.ProductId,
	   T1.ProductName,
	   T1.Price
FROM TestTable T1
WHERE T1.ProductId=1
INTERSECT
SELECT T1.ProductId,
	   T1.ProductName,
	   T1.Price
FROM TestTable T1
WHERE T1.ProductId=2
GO
SELECT T1.ProductId,
	   T1.ProductName,
	   T1.Price
FROM TestTable T1
WHERE T1.ProductId=1
EXCEPT
SELECT T1.ProductId,
	   T1.ProductName,
	   T1.Price
FROM TestTable T1
WHERE T1.ProductId=2
GO
SELECT T2.CategoryName AS [Название категории],
	   (SELECT COUNT(*)
	   FROM TestTable
	   WHERE CategoryId=T2.CategoryId) AS [Количество товара]
FROM TestTable2 T2
GO
SELECT ProductId, Price
FROM (SELECT ProductId,
	         Price
	  FROM TestTable) AS Q1
GO
SELECT Q1.ProductId, Q1.Price, Q2.CategoryName 
FROM (SELECT ProductId,
	         Price,
			 CategoryId
	  FROM TestTable) AS Q1
LEFT JOIN (SELECT CategoryId, CategoryName FROM TestTable2) AS Q2 ON
Q1.CategoryId=Q2.CategoryId
GO
CREATE VIEW ViewCntProducts
AS
	SELECT T2.CategoryName AS Categoryname,
		   (SELECT COUNT(*)
		    FROM TestTable
			WHERE CategoryId=T2.CategoryId) AS CntProducts
	FROM TestTable2 T2
GO
SELECT * 
FROM ViewCntProducts
GO
ALTER VIEW ViewCntProducts
AS
	SELECT T2.CategoryId AS CategoryId,
		   T2.CategoryName AS CategoryName,
		   (SELECT COUNT(*)
		    FROM TestTable
			WHERE CategoryId=T2.CategoryId) AS CntProducts
	FROM TestTable2 T2
GO
SELECT * 
FROM ViewCntProducts
GO
DROP VIEW ViewCntProducts
GO
SELECT *
FROM sys.tables
GO
SELECT *
FROM sys.columns
WHERE object_id=object_id('TestTable')
GO
INSERT INTO TestTable
	VALUES (1,'Клавиатура',100),
		   (1,'Мышь',50),
		   (2,'Телефон',300)
GO
INSERT INTO TestTable2
	VALUES ('Комплектующий компьютера'),
		   ('Мобильный устройства')
GO
SELECT * 
FROM TestTable
GO
SELECT * 
FROM TestTable2
GO
INSERT INTO TestTable (CategoryId, ProductName, Price)
	VALUES (1,'Клавиатура',100),
		   (1,'Мышь',50),
		   (2,'Телефон',300)
GO
SELECT *
FROM TestTable
GO
INSERT INTO TestTable (CategoryId, ProductName, Price)
	SELECT CategoryId, ProductName, Price
	FROM TestTable
	WHERE ProductId>3
GO
SELECT *
FROM TestTable
WHERE ProductId=1
GO
UPDATE TestTable SET Price=120
WHERE ProductId=1
GO
SELECT *
FROM TestTable
WHERE ProductId=1
GO
SELECT *
FROM TestTable
WHERE ProductId>3
GO
UPDATE TestTable SET ProductName='тестовый товар', Price=150
WHERE ProductId>3
GO
SELECT *
FROM TestTable
WHERE ProductId>3
GO
SELECT *
FROM TestTable
WHERE ProductId>3
GO
UPDATE TestTable SET ProductName=T2.CategoryName, Price=200
FROM TestTable2 T2
INNER JOIN TestTable T1 ON t1.CategoryId=T2.CategoryId
WHERE T1.ProductId>3
GO
SELECT *
FROM TestTable
WHERE ProductId>3
GO
SELECT *
FROM TestTable
GO
DELETE TestTable
WHERE ProductId>3
GO
SELECT *
FROM TestTable
GO
SELECT *
FROM TestTable
GO
TRUNCATE TABLE TestTable
GO
SELECT *
FROM TestTable
GO
INSERT INTO TestTable
	VALUES (1,'Клавиатура',100),
		   (1,'Мышь',50),
		   (2,'Телефон',300)
GO
SELECT *
FROM TestTable
GO
CREATE TABLE TestTable3(
	ProductId INT NOT NULL,
	CategoryId INT NOT NULL,
	ProductName VARCHAR(100) NOT NULL,
	Price MONEY NULL)
GO
INSERT INTO TestTable3
	VALUES (1,1,'Клавиатура',0),
		   (2,1,'Мышь',0),
		   (4,1,'Тест',0)
GO
SELECT *
FROM TestTable
GO
SELECT *
FROM TestTable3
GO
MERGE TestTable3 AS T_Base
	USING TestTable AS T_Source
	ON (T_Base.ProductId=T_Source.ProductId)
	WHEN MATCHED THEN
		UPDATE SET ProductName=T_Source.ProductName, CategoryId=T_Source.CategoryId,
Price=T_Source.Price
	WHEN NOT MATCHED THEN
		INSERT (ProductId,CategoryId,ProductName,Price)
		VALUES (T_Source.ProductId,T_Source.CategoryId,T_Source.ProductName,T_Source.Price)
	WHEN NOT MATCHED BY SOURCE THEN DELETE
	OUTPUT $action AS [Операция], Inserted.ProductId,
			Inserted.ProductName AS ProductNameNEW,
			Inserted.Price AS PriceNew,
			Deleted.ProductName AS ProductNameOLD,
			Deleted.Price AS PriceOLD;
GO
SELECT *
FROM TestTable
GO
SELECT *
FROM TestTable3
GO
INSERT INTO TestTable
	OUTPUT inserted.ProductId,
		   inserted.CategoryId,
		   inserted.ProductName,
		   inserted.Price
	VALUES (1,'Тестовый товар 1',300),
		   (1,'Тестовый товар 2',500),
		   (2,'Тестовый товар 3',400)
GO
UPDATE TestTable SET Price=0
	OUTPUT inserted.ProductId AS [ProductId],
		   deleted.Price AS [Старое значение Price],
		   inserted.Price AS [Новое значение Price]
WHERE ProductId>3
GO
DELETE TestTable
	OUTPUT deleted.*
WHERE ProductId>3
GO
CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON TestTable
	(
		ProductId ASC
	)
GO
CREATE NONCLUSTERED INDEX IX_NonClustered ON TestTable
	(
		CategoryId ASC
	)
GO
DROP INDEX IX_NonClustered ON TestTable;
GO
CREATE NONCLUSTERED INDEX IX_NonClustered ON TestTable
(
	CategoryId ASC,
	ProductName ASC
)
	INCLUDE (Price);
GO
CREATE NONCLUSTERED INDEX IX_NonClustered ON TestTable
(
	CategoryId ASC,
	ProductName ASC
)
	INCLUDE(Price)
WITH (DROP_EXISTING=ON);
GO
SELECT OBJECT_NAME(T1.object_id) AS NameTable,
	   T1.index_id AS IndexId,
	   T2.name AS IndexName,
	   T1.avg_fragmentation_in_percent AS Fragmentation
FROM sys.dm_db_index_physical_stats (DB_ID(),NULL,NULL,NULL,NULL) AS T1
LEFT JOIN sys.indexes AS T2 ON t1.object_id=T2.object_id AND T1.index_id=T2.index_id
GO
ALTER INDEX IX_NonClustered ON TestTable
	REORGANIZE
GO
ALTER INDEX IX_NonClustered ON TestTable
	REBUILD
GO