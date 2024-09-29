/*Статья https://info-comp.ru/programmirovanie/567-table-variables-in-ms-sql-server.html*/

DROP TABLE IF EXISTS TestTable
GO
CREATE TABLE TestTable
(
	ProductId INT IDENTITY(1,1) NOT NULL,
	ProductName VARCHAR(50) NULL
	CONSTRAINT PK_TestTable PRIMARY KEY CLUSTERED (ProductId ASC)
)
GO
INSERT INTO TestTable (ProductName)
VALUES ('Компьютер'),
	   ('Монитор'),
	   ('Принтер')
GO

SELECT *
FROM TestTable

--Объявление табличной переменной
DECLARE @TableVar TABLE
(
	ProductId INT NOT NULL,
	Price MONEY NULL
)

--Добавление данных в табличную переменную
INSERT INTO @TableVar(ProductId, Price)
VALUES (1, 500),
	   (2, 300),
	   (3, 200)
--Использование табличной переменной с объединением данных
SELECT TTable.ProductId, TTable.ProductName, TVar.Price
FROM @TableVar TVar
LEFT JOIN TestTable TTable ON TVar.ProductId=TTable.ProductId

--Объявление табличной переменной
DECLARE @TableVar TABLE
(
	ProductId INT NOT NULL PRIMARY KEY, --Первичный ключ
	ProductName VARCHAR(50) NOT NULL,
	Price MONEY NOT NULL
	UNIQUE(ProductName, Price), --Ограничение
	INDEX IX_TableVar NONCLUSTERED (Price) --Некластеризованный индекс
);
--Добавление данных в табличную переменную
INSERT INTO @TableVar (ProductId, ProductName, Price)
VALUES (1, 'Компьютер', 500),
	   (2, 'Монитор', 300),
	   (3, 'Принтер', 200);
--Выборка данных
SELECT ProductName
FROM @TableVar
WHERE Price > 200