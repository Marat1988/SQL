/*Статья https://info-comp.ru/obucheniest/622-select-into-in-t-sql.html*/

USE TestDB;
GO

DROP TABLE IF EXISTS TestTable;
GO

CREATE TABLE TestTable
(
	ProductId INT IDENTITY(1,1) NOT NULL,
	CategoryId INT NOT NULL,
	ProductName VARCHAR(100) NOT NULL,
	Price MONEY NULL
)
GO

CREATE TABLE TestTable2
(
	CategoryId INT IDENTITY(1,1) NOT NULL,
	CategoryName VARCHAR(100) NOT NULL
);
GO

INSERT INTO TestTable
VALUES (1, 'Клавиатура', 100),
	   (1, 'Мышь', 50),
	   (2, 'Телефон', 300);
GO

INSERT INTO TestTable2
VALUES ('Комплектующие компьютера'),
	   ('Мобильные устройства')
GO

SELECT *
FROM TestTable;
GO

SELECT *
FROM TestTable2;
GO

--Операция SELECT INTO
SELECT T1.ProductId, T2.CategoryName, T1.ProductName, T1.Price
INTO TestTable3
FROM TestTable T1
LEFT JOIN TestTable2 T2 ON T1.CategoryId=T2.CategoryId

--Выборка данных из новой таблицы
SELECT *
FROM TestTable3

--Создаем временную таблицу (#TestTable) с помощью инструкции SELECT INTO
SELECT T2.CategoryName, COUNT(T1.ProductId) AS CntProduct
INTO #TestTable
FROM TestTable T1
LEFT JOIN TestTable2 T2 ON T1.CategoryId=T2.CategoryId
GROUP BY T2.CategoryName

--Выборка данных из временной таблицы
SELECT *
FROM #TestTable

DROP TABLE #TestTable