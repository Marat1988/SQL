/*Статья https://info-comp.ru/obucheniest/672-get-first-query-records-sql.html*/

DROP TABLE IF EXISTS TestTable;
GO

--Создание таблицы
CREATE TABLE TestTable
(
	ProductId INT IDENTITY(1,1) NOT NULL,
	ProductName VARCHAR(100) NOT NULL,
	Price MONEY NULL
);
GO

--Добавление строк в таблицу
INSERT INTO TestTable(ProductName, Price)
VALUES ('Системный блок', 300),
	   ('Монитор', 200),
	   ('Мышь', 50),
	   ('Принтер', 200),
	   ('Сканер', 150),
	   ('Телефон', 250),
	   ('Планшет', 300);
GO

--Выборка данных
SELECT *
FROM TestTable

SELECT TOP(5) ProductId, ProductName, Price
FROM TestTable
ORDER BY Price DESC

--Без WITH TIES
SELECT TOP(4) ProductId, ProductName, Price
FROM TestTable
ORDER BY Price DESC

--С WITH TIES
SELECT TOP(4) WITH TIES ProductId, ProductName, Price
FROM TestTable
ORDER BY Price DESC

SELECT TOP(50) PERCENT ProductId, ProductName, Price
FROM TestTable
ORDER BY Price DESC

SELECT ProductId, ProductName, Price
FROM TestTable
ORDER BY Price DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;

WITH SRC AS
(
	--Получаем 5 последних строк в таблице
	SELECT TOP(5) ProductId, ProductName, Price
	FROM TestTable
	ORDER BY ProductId DESC
)
SELECT *
FROM SRC
ORDER BY ProductId --Применяем нужную нам сортировку

--Объявляем переменную
DECLARE @CNT INT;

--Узнаем количество строк в таблице
SELECT @CNT=COUNT(*)
FROM TestTable;

--Получаем 5 последних строк
SELECT ProductId, ProductName, Price
FROM TestTable
ORDER BY ProductId
OFFSET @CNT - 5 ROWS FETCH NEXT 5 ROWS ONLY;