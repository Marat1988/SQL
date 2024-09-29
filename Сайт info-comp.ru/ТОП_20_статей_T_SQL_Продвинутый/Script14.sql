/*Статья https://info-comp.ru/obucheniest/496-cross-apply-operator-in-t-sql.html*/

DROP DATABASE IF EXISTS TestBase

CREATE DATABASE TestBase;
GO

USE TestBase
GO

--Таблица товаров
CREATE TABLE Goods
(
	ProductId INT IDENTITY(1,1) NOT NULL,
	ProductName VARCHAR(100) NOT NULL
);

INSERT INTO Goods(ProductName)
VALUES ('Системный блок'),
	   ('Принтер'),
	   ('Монитор'),
	   ('Клавиатура');

SELECT *
FROM Goods

--Таблица продаж
CREATE TABLE Sales
(
	SaleId INT IDENTITY(1,1) NOT NULL,
	ProductId INT NOT NULL,
	SaleDate DATETIME NOT NULL
);

INSERT INTO Sales (ProductId, SaleDate)
VALUES (1, '01.02.2020'),
	   (1, '10.03.2020'),
	   (1, '25.04.2020'),
	   (1, '15.05.2020'),
	   (2, '25.02.2020'),
	   (2, '15.06.2020'),
	   (2, '01.07.2020'),
	   (3, '01.04.2020'),
	   (3, '05.05.2020');

SELECT *
FROM Goods;

SELECT *
FROM Sales;
GO


CREATE FUNCTION SaleGoods
(
	@ProductID INT
)
RETURNS TABLE
AS
RETURN
(
	SELECT s.SaleId, s.SaleDate, g.ProductName
	FROM Sales s
	INNER JOIN Goods g ON s.ProductId=g.ProductId
	WHERE s.ProductId=@ProductId
);
GO

SELECT *
FROM SaleGoods(1)

SELECT *
FROM Goods g
CROSS APPLY SaleGoods(g.ProductId) AS Sales;

SELECT *
FROM Goods G
CROSS APPLY (
			 SELECT TOP 1 s.SaleDate
			 FROM SaleGoods(g.ProductId) AS S
			 ORDER BY s.SaleDate DESC
			) AS Sales;

SELECT *
FROM Goods G
OUTER APPLY (
			 SELECT TOP 1 s.SaleDate
			 FROM SaleGoods(G.ProductId) AS S
			 ORDER BY s.SaleDate DESC
			) AS Sales;