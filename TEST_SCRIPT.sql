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
DROP TABLE TestTable3
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
	VALUES (1,'����������',100),
		   (1,'����',50),
		   (2,'�������',300)
GO
INSERT INTO TestTable2
	VALUES ('������������� ����������'),
		   ('��������� ����������')
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
	   T.Price AS [����]
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
WHERE ProductName LIKE '�%'
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
SELECT COUNT(*) AS [���������� �����],
	   SUM(Price) AS [����� �� ������� Price],
	   MAX(Price) AS [������������ �������� � ������� Price],
	   MIN(Price) AS [����������� �������� � ������� Price],
	   AVG(Price) AS [������� �������� � ������� Price]
FROM TestTable
GO
SELECT CategoryId AS [Id ���������],
	   COUNT(*) AS [���������� �����],
	   SUM(Price) AS [����� �� ������� Price],
	   MAX(Price) AS [������������ �������� � ������� Price],
	   MIN(Price) AS [����������� �������� � ������� Price],
	   AVG(Price) AS [������� �������� � ������� Price]
FROM TestTable
GROUP BY CategoryId
GO
SELECT CategoryId AS [Id ���������],
	   COUNT(*) AS [���������� �����],
	   MAX(Price) AS [������������ �������� � ������� Price],
	   MIN(Price) AS [����������� �������� � ������� Price],
	   AVG(Price) AS [������� �������� � ������� Price]
FROM TestTable
WHERE ProductId<>1
GROUP BY CategoryId
GO
SELECT CategoryId AS [Id ���������],
	   COUNT(*) AS [���������� �����]
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
SELECT T2.CategoryName AS [�������� ���������],
	   (SELECT COUNT(*)
	   FROM TestTable
	   WHERE CategoryId=T2.CategoryId) AS [���������� ������]
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
	VALUES (1,'����������',100),
		   (1,'����',50),
		   (2,'�������',300)
GO
INSERT INTO TestTable2
	VALUES ('������������� ����������'),
		   ('��������� ����������')
GO
SELECT * 
FROM TestTable
GO
SELECT * 
FROM TestTable2
GO
INSERT INTO TestTable (CategoryId, ProductName, Price)
	VALUES (1,'����������',100),
		   (1,'����',50),
		   (2,'�������',300)
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
UPDATE TestTable SET ProductName='�������� �����', Price=150
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
	VALUES (1,'����������',100),
		   (1,'����',50),
		   (2,'�������',300)
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
	VALUES (1,1,'����������',0),
		   (2,1,'����',0),
		   (4,1,'����',0)
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
	OUTPUT $action AS [��������], Inserted.ProductId,
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
	VALUES (1,'�������� ����� 1',300),
		   (1,'�������� ����� 2',500),
		   (2,'�������� ����� 3',400)
GO
UPDATE TestTable SET Price=0
	OUTPUT inserted.ProductId AS [ProductId],
		   deleted.Price AS [������ �������� Price],
		   inserted.Price AS [����� �������� Price]
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
ALTER TABLE TestTable ALTER COLUMN [Price] [Money] NOT NULL
GO
CREATE TABLE TestTable4(
	[CategoryId] [INT] IDENTITY(1,1) NOT NULL  PRIMARY KEY,
	[CategoryName] [VARCHAR](100) NOT NULL);
GO
CREATE TABLE TestTable4(
	[CategoryId] [INT] IDENTITY(1,1) NOT NULL,
	[CategoryName] [VARCHAR](100) NOT NULL,
	CONSTRAINT PK_CategoryId PRIMARY KEY (CategoryID));
GO
ALTER TABLE TestTable ADD CONSTRAINT PK_TestTable PRIMARY KEY (ProductId)
GO
CREATE TABLE TestTable5(
	[ProductId] [INT] IDENTITY(1,1) NOT NULL,
	[CategoryId] [INT] NOT NULL,
	[ProductName] [VARCHAR](100) NOT NULL,
	[Price] [MONEY] NULL,
	CONSTRAINT PK_TestTable5 PRIMARY KEY (ProductId),
	CONSTRAINT FK_TestTable5 FOREIGN KEY (CategoryId) REFERENCES TestTable4(CategoryId)
		ON DELETE CASCADE
		ON UPDATE NO ACTION
)
GO
ALTER TABLE TestTable2 ADD CONSTRAINT PK_TestTable2 PRIMARY KEY (CategoryId);
GO
ALTER TABLE TestTable ADD CONSTRAINT FK_TestTable FOREIGN KEY (CategoryId) REFERENCES TestTable2 (CategoryId);
GO
CREATE TABLE TestTable6(
	[Column1] [INT] NOT NULL CONSTRAINT PK_TestTable6_C1 UNIQUE,
	[Column2] [INT] NOT NULL,
	[Column3] [INT] NOT NULL,
	CONSTRAINT PK_TestTable6_C2 UNIQUE (Column3)
);
GO
ALTER TABLE TestTable6 ADD CONSTRAINT PK_TestTable6_C3 UNIQUE (Column3);
GO
CREATE TABLE TestTable7(
	[Column1] [INT] NOT NULL,
	[Column2] [INT] NOT NULL,
	CONSTRAINT CK_TestTable7_C1 CHECK (Column1 <> 0)
);
GO
ALTER TABLE TestTable7 ADD CONSTRAINT CK_TestTable7_C2 CHECK (Column2 > Column1);
GO
CREATE TABLE TestTable8(
	[Column1] [INT] NULL CONSTRAINT DF_C1 DEFAULT (1),
	[Column2] [INT] NULL);
GO
ALTER TABLE TestTable8 ADD CONSTRAINT DF_C2 DEFAULT (2) FOR Column2;
GO
ALTER TABLE TestTable7 DROP CONSTRAINT CK_TestTable7_C1;
ALTER TABLE TestTable7 DROP CONSTRAINT CK_TestTable7_C2;
ALTER TABLE TestTable8 DROP CONSTRAINT DF_C1;
ALTER TABLE TestTable8 DROP CONSTRAINT DF_C2;
GO
DECLARE @TestVar INT
SET @TestVar = 10
SELECT @TestVar=10
SELECT @TestVar*5 AS [���������]
GO
DECLARE @TestTable TABLE (ProductId INT IDENTITY(1,1) NOT NULL,
					      CategoryId INT NOT NULL,
						  ProductName VARCHAR(100) NOT NULL,
						  Price Money NULL);
INSERT INTO @TestTable
	SELECT CategoryId, ProductName, Price
	FROM TestTable
	WHERE ProductId<=3
SELECT *
FROM @TestTable
GO
SELECT @@SERVERNAME [��� ���������� �������],
	   @@VERSION AS [������ SQL �������]
GO
--���������� ����������: ���������� � �����
DECLARE @Cnt INT, @Summa MONEY
SET @Cnt = 10
SET @Summa = 150
/*
	��������� �������� ���������.
	������ ���������������� �����������
*/
SELECT @Cnt*@Summa AS [���������]
GO
DECLARE @TestVar1 INT
DECLARE @TestVar2 VARCHAR(20)
SET @TestVar1=5
IF @TestVar1>0
	SET @TestVar2='������ 0'
ELSE
	SET @TestVar2='������ 0'
SELECT @TestVar2 AS [�������� TestVar1]
GO
DECLARE @TestVar1 INT
DECLARE @TestVar2 VARCHAR(20)
SET @TestVar1 = 0
IF @TestVar1>0
	SET @TestVar2='������ 0'
SELECT @TestVar2 AS [�������� TestVar1]
GO
DECLARE @TestVar1 INT
DECLARE @TestVar2 VARCHAR(20)
SET @TestVar1=-5
IF @TestVar1>0 OR @TestVar1=-5
	SET @TestVar2='�������� ��������'
SELECT @TestVar2 AS [�������� TestVar1]
GO
DECLARE @TestVar VARCHAR(20)
IF EXISTS(SELECT * FROM TestTable)
	SET @TestVar='������ ����'
ELSE
	SET @TestVar='������� ���'
SELECT @TestVar AS [������� �������]
GO
DECLARE @TestVar1 INT
DECLARE @TestVar2 VARCHAR(20)
SET @TestVar1=1
SELECT @TestVar2=CASE @TestVar1 WHEN 1 THEN '����'
							    WHEN 2 THEN '���'
								ELSE '����������'
				 END
SELECT @TestVar2 AS [�����]
GO
DECLARE @TestVar1 INT
DECLARE @TestVar2 VARCHAR(20), @TestVar3 VARCHAR(20)
SET @TestVar1=5
IF @TestVar1 NOT IN (0,1,2)
BEGIN
	SET @TestVar2='������ ����������'
	SET @TestVar3='������ ����������'
END
SELECT @TestVar2 AS [�������� TestVar2],
	   @TestVar3 AS [�������� TestVar3]
GO
DECLARE @CountAll INT=0
--��������� ����
WHILE @CountAll<10
BEGIN
	SET @CountAll+=1;
END
SELECT @CountAll AS [���������]
GO
DECLARE @CountAll INT=0
--��������� ����
WHILE @CountAll<10
BEGIN
	SET @CountAll+=1
	IF @CountAll=5
		BREAK;
END
SELECT @CountAll AS [���������]
GO
DECLARE @Cnt INT=0
DECLARE @CountAll INT=0
--��������� ����
WHILE @CountAll<10
BEGIN
	SET @CountAll+=1
	IF @CountAll=5
		CONTINUE
	SET @Cnt+=1
END
SELECT @CountAll AS [CountAll],
	   @Cnt AS [Cnt]
GO
DECLARE @TestVar INT = 1
IF @TestVar > 0
	PRINT '�������� ���������� ������ 0'
ELSE
	PRINT '�������� ���������� ������ ��� ����� 0'
GO
DECLARE @TestVar INT=1
IF @TestVar < 0
	RETURN
SELECT @TestVar AS [���������]
GO
DECLARE @TestVar INT=0
�����: --������������� �����
SET @TestVar+=1 --����������� �������� ����������
--��������� �������� ����������
IF @TestVar<10
	--���� ��� ������ 10, �� ������������ ����� � �����
	GOTO �����
SELECT @TestVar AS [���������]
GO
DECLARE @TestVar INT=2
DECLARE @Rez INT=0
IF @TestVar<=0
	GOTO �����
SET @Rez=10/@TestVar
�����:
SELECT @Rez AS [���������]
GO
--����� �� 5 ������
WAITFOR DELAY '00:00:05'
	SELECT '����������� ���������� ����������' AS [Test]
--����� �� 10 �����
WAITFOR TIME '10:00:00'
	SELECT '����������� ���������� ����������' AS [Test]
GO
--������ ����� ��������� ������
BEGIN TRY
	--����������, � ������� ����� ���������� ������
	DECLARE @TestVar1 INT=10,
		    @TestVar2 INT=0,
			@Rez INT

	SET @Rez=@TestVar1/@TestVar2
END TRY
--������ ����� CATCH
BEGIN CATCH
	--��������, ������� ����� ����������� � ������ ������������� ������
	SELECT ERROR_NUMBER() AS [����� ������],
		   ERROR_MESSAGE() AS [�������� ������]
	SET @Rez=0
END CATCH
SELECT @Rez AS [���������]
GO