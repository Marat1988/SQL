/*Статья https://info-comp.ru/programmirovanie/702-between-in-t-sql.html*/

DROP TABLE IF EXISTS TestTable;

--Создание таблицы
CREATE TABLE TestTable
(
	ProductId INT IDENTITY(1,1) NOT NULL,
	ProductName VARCHAR(100) NOT NULL,
	Price MONEY NULL
);
GO

--Добавление строк в таблицу
INSERT INTO TestTable (ProductName, Price)
VALUES ('Системный блок', 300),
	   ('Монитор', 200),
	   ('Клааивтура', 100),
	   ('Мышь', 50),
	   ('Принтер', 200),
	   ('Сканер', 150),
	   ('Телефон', 250),
	   ('Планшет', 300);
GO

--Выборка данных
SELECT *
FROM TestTable

--Условие с применением оператора BETWEEN
SELECT ProductId,
	ProductName,
	Price
FROM TestTable
WHERE Price BETWEEN 100 AND 200

--Условие с применением операторов сравнения
SELECT ProductId,
	ProductName,
	Price
FROM TestTable
WHERE Price>=100 AND Price<=200

DECLARE @TestVar INT=5

IF @TestVar BETWEEN 1 AND 10
	SELECT 'Переменная @TestVar находится в диапазоне от 1 до 10'

--Услоавие с применением оператора NOT BETWEEN
SELECT ProductId,
	ProductName,
	Price
FROM TestTable
WHERE Price NOT BETWEEN 100 AND 200

--Условие с применением оператора сравнения
SELECT ProductId,
	ProductName,
	Price
FROM TestTable
WHERE Price < 100 OR Price > 200