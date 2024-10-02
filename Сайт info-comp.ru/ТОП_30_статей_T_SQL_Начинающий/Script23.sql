/*Статья https://info-comp.ru/obucheniest/747-subqueries-in-t-sql.html*/

DROP TABLE IF EXISTS Goods;
DROP TABLE IF EXISTS Categories;

--Создание таблицы Goods
CREATE TABLE Goods
(
	ProductId INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_ProductId PRIMARY KEY,
	Category INT NOT NULL,
	ProductName VARCHAR(100) NOT NULL,
	Price MONEY NULL
);
GO

--Создание таблицы Categories
CREATE TABLE Categories
(
	CategoryId INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_CategoryId PRIMARY KEY,
	CategoryName VARCHAR(100) NOT NULL
);

--Добавление строк в таблицу Categories
INSERT INTO Categories (CategoryName)
VALUES ('Комплектующие ПК'),
	('Мобильные устройства');
GO

--Добавление строк в таблицу Goods
INSERT INTO Goods(Category, ProductName, Price)
VALUES (1, 'Системный блок', 300),
	   (1, 'Монитор', 200),
	   (2, 'Смартфон', 250);
GO

--Выборка данных
SELECT *
FROM Goods;

SELECT *
FROM Categories;
GO

--Выводим название категории с помощью вложенного запроса
SELECT G.ProductName, (SELECT CategoryName FROM Categories C WHERE C.CategoryId=G.Category) AS CategoryName
FROM Goods G;

--Эквивалет с использование объединения JOIN
SELECT G.ProductName, C.CategoryName
FROM Goods G
INNER JOIN Categories C ON g.Category=C.CategoryId

SELECT ProductId, ProductName
FROM (SELECT ProductId, ProductName
	  FROM Goods
	  WHERE Category=1) AS Query

SELECT G.ProductName, C.CategoryName
FROM Goods G
INNER JOIN (SELECT *
		    FROM Categories
			WHERE CategoryId=1) AS C ON G.Category=C.CategoryId

SELECT ProductId, ProductName
FROM Goods G
WHERE Category=(SELECT CategoryId
			    FROM Categories
				WHERE CategoryName='Комплектующие ПК')

SELECT ProductId, ProductName
FROM Goods G
WHERE Category IN (SELECT CategoryId
				   FROM Categories)

SELECT ProductId, ProductName
FROM (SELECT ProductId, ProductName
	  FROM Goods
	  WHERE Category = (SELECT CategoryId
						FROM Categories
						WHERE CategoryName='Комплектующие ПК')) AS Query
