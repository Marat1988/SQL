/*Статья https://info-comp.ru/obucheniest/723-alter-table-in-ms-sql-server.html*/

--Добавление строк в таблицу
INSERT INTO Categories (CategoryName)
VALUES ('Комплектующие ПК'),
	   ('Мониторы'),
	   ('Компьютерная мелочь');
GO

INSERT INTO Goods(Category, ProductName, Price)
VALUES (1, 'Системный блок', 300),
	   (2, 'Монитор', 200),
	   (3, 'Клавиатура', 100)
GO
--Выборка данных
SELECT *
FROM Goods

ALTER TABLE Goods ADD ProductDescription VARCHAR(300) NULL;
GO

--Выборка данных
SELECT *
FROM Goods

ALTER TABLE Goods DROP COLUMN ProductDescription;
GO

--Выборка данных
SELECT *
FROM Goods

ALTER TABLE Goods ALTER COLUMN Price MONEY NOT NULL

ALTER TABLE Goods ALTER COLUMN ProductName VARCHAR(200) NOT NULL;