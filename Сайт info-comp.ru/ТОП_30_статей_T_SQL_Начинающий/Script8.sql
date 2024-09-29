/*Статья https://info-comp.ru/obucheniest/736-update-statement-in-t-sql.html*/

USE TestDB;
GO

DROP TABLE IF EXISTS Goods;
DROP TABLE IF EXISTS Categories;

--Создание таблицы Goods
CREATE TABLE Goods
(
	ProductId INT IDENTITY(1,1) NOT NULL,
	Category INT NOT NULL,
	ProductName VARCHAR(100) NOT NULL,
	ProductDescription VARCHAR(300) NULL,
	Price MONEY NULL,
	CONSTRAINT PK_ProductId PRIMARY KEY (ProductId)
);
GO

--Создание таблицы Categories
CREATE TABLE Categories
(
	CategoryId INT IDENTITY(1,1) NOT NULL,
	CategoryName VARCHAR(100) NOT NULL,
	CONSTRAINT PK_CategoryId PRIMARY KEY (CategoryId)
);
GO

--Добавление строк в таблицу Categories
INSERT INTO Categories(CategoryName)
VALUES ('Комплектующие ПК'),
	   ('Мобильные устройства');
GO

--Добавление строк в таблицу Goods
INSERT INTO Goods (Category, ProductName, ProductDescription, Price)
VALUES (1, 'Системный блок', 'Товар', 300),
	   (1, 'Монитор', 'Товар 2', 200),
	   (2, 'Смартфон', 'Товар 3', 100);
GO

--Выборка данных
SELECT *
FROM Goods;

SELECT *
FROM Categories

--Выборка данных
SELECT *
FROM Goods

--Обновление
UPDATE Goods SET ProductDescription='Товар';

--Выборка данных
SELECT *
FROM Goods


--Выборка данных
SELECT *
FROM Goods;

--Обновление
UPDATE Goods SET ProductDescription='Товар NEW', Price=400
WHERE Category=1;

--Выборкат данных
SELECT *
FROM Goods;

--Выборка данных
SELECT *
FROM Goods

--Обновление
UPDATE Goods SET ProductDescription=ProductDescription+' 3', Price = Price * 1.5
WHERE Category=2;

--Выборка данных
SELECT *
FROM Goods

--Выборка данных
SELECT *
FROM Goods;

--Обновление
--Способ 1
UPDATE G SET ProductDescription=C.CategoryName
FROM Goods G
INNER JOIN Categories C ON G.Category=C.CategoryId

--Способ 2 (эквивалент)
UPDATE Goods SET ProductDescription=C.CategoryName
FROM Categories C
WHERE Goods.Category=C.CategoryId;

--Выборка данных
SELECT *
FROM Goods

--Выборка данных
SELECT *
FROM Goods

--Обновление
UPDATE Goods SET ProductDescription='Всего товаров: ' + (SELECT CAST(COUNT(*) AS VARCHAR(10))
														 FROM Goods G
														 WHERE G.Category=Goods.Category)

--Выборка данных
SELECT *
FROM Goods
