/*Статья https://info-comp.ru/obucheniest/642-for-xml-in-t-sql.html*/
DROP TABLE IF EXISTS TestTable;
GO

--Инструкция создания таблицы 1
CREATE TABLE TestTable
(
	ProductId INT IDENTITY(1,1) NOT NULL,
	CategoryId INT NOT NULL,
	ProductName VARCHAR(100) NOT NULL,
	Price MONEY NULL
)
GO

--Иструкция создания таблицы 2
CREATE TABLE TestTable2
(
	CategoryId INT IDENTITY(1,1) NOT NULL,
	CategoryName VARCHAR(100) NOT NULL
)
GO
--Инструкция добавления данных
INSERT INTO TestTable
VALUES (1, 'Клавиатура', 100),
	   (1, 'Мышь', 50),
	   (2, 'Телефон', 300)
GO
INSERT INTO TestTable2
VALUES ('Комплектующие устройства'),
	   ('Мобильныке устройства')
GO
--Запросы на выборку
SELECT *
FROM TestTable
SELECT *
FROM TestTable2

SELECT ProductId, ProductName, Price
FROM TestTable
ORDER BY ProductId
FOR XML RAW, TYPE

SELECT ProductId, ProductName, Price
FROM TestTable
FOR XML RAW ('Product'), TYPE, ELEMENTS, ROOT('Products')

SELECT TestTable.ProductId,
	   TestTable.ProductName,
	   TestTable.Price
FROM TestTable
LEFT JOIN TestTable2 ON TestTable.CategoryId=TestTable2.CategoryId
ORDER BY TestTable.ProductId
FOR XML AUTO, TYPE, ROOT('Products')

SELECT 1 AS Tag,
	   NULL AS Parent,
	   ProductId AS [Product!1!Id],
	   ProductName AS [Product!1!ProductName!ELEMENT],
	   Price AS [Product!1!Price!ELEMENT]
FROM TestTable
ORDER BY [Product!1!Id]
FOR XML EXPLICIT, TYPE, ROOT('Products')

SELECT ProductId AS "@Id",
	   ProductName,
	   Price
FROM TestTable
ORDER BY ProductId
FOR XML PATH ('Product'), TYPE, ROOT('Products')