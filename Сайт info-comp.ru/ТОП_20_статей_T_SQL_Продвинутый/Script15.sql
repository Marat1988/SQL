/*Статья https://info-comp.ru/create-or-alter-in-t-sql*/

DROP DATABASE TestBase
GO

CREATE DATABASE TestBase
GO

--Создание таблицы
CREATE TABLE Goods
(
	ProductId INT IDENTITY(1,1) NOT NULL,
	Category INT NOT NULL,
	ProductName VARCHAR(100) NOT NULL,
	Price MONEY NULL,
);
GO

--Добавление строк в таблицу Goods
INSERT INTO Goods(Category, ProductName, Price)
VALUES (1, 'Системный блок', 300),
	   (1, 'Монитор', 200),
	   (2, 'Смартфон', 100);
GO

--Выборка данных
SELECT *
FROM Goods
GO

CREATE OR ALTER VIEW AllGoods
AS
SELECT *
FROM Goods
GO

SELECT *
FROM AllGoods
GO

CREATE OR ALTER VIEW AllGoods
AS
SELECT ProductId, ProductName, Price
FROM Goods;
GO

SELECT *
FROM AllGoods