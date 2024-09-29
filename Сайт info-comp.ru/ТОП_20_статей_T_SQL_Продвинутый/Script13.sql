/*Статья https://info-comp.ru/iif-in-t-sql*/

SELECT IIF(1<2, 'TRUE', 'FALSE') AS Result

SELECT IIF(1>2, 'TRUE', 'FALSE') AS Result

DECLARE @A INT = 5,
		@B INT = 3,
		@true_value INT = 1,
		@false_value INT = 0;

SELECT IIF(@A>@B, @true_value, @false_value) AS Result;

DECLARE @A INT = 5,
		@B INT = 3,
		@true_value VARCHAR(10) = 'A больше B',
		@false_value VARCHAR(10) =  'A меньше B'

SELECT IIF(@A>@B, @true_value, @false_value) AS Result


DECLARE @A INT = 5,
		@B INT = 3,
		@true_value INT = 1,
		@false_value INT = 0;
SELECT IIF(@A*@B>10, @true_value, @false_value) AS Result

DECLARE @ProductName VARCHAR(100) = 'Монитор';
SELECT IIF(@ProductName='Смартфон','Мобильные устройства',IIF(@ProductName='Монитор', 'Комплектующие ПК', 'Без категории')) AS Result

DECLARE @ProductName VARCHAR(100) = 'Стол';
SELECT IIF(@ProductName='Смартфон','Мобильные устройства',IIF(@ProductName='Монитор','Комплектующие ПК','Без категории')) AS Result

CREATE TABLE Goods
(
	CategoryId INT IDENTITY(1,1),
	ProductName VARCHAR(100) NOT NULL,
	Price MONEY NOT NULL,
	CONSTRAINT UQ_ProductName UNIQUE(ProductName),
	CONSTRAINT CK_ProductName CHECK (ProductName<>''),
	CONSTRAINT CK_Price CHECK (Price>0),
	CONSTRAINT PK_Category PRIMARY KEY (CategoryId)
);
GO

INSERT INTO Goods (ProductName, Price)
VALUES ('Системный блок', 300),
	   ('Монитор', 200),
	   ('Смартфон', 100)

SELECT CategoryId,
	   ProductName,
	   Price,
	   Price + IIF(CategoryId = 1, 10, 15) AS TotalPrice
FROM Goods