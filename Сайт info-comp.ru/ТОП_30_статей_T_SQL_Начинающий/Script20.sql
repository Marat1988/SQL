/*Статья https://info-comp.ru/programmirovanie/636-stored-procedures-in-t-sql.html*/

DROP TABLE IF EXISTS TestTable;
DROP PROCEDURE IF EXISTS TestProcedure;
GO

--Инструкция создания таблицы
CREATE TABLE TestTable
(
	ProductId INT IDENTITY(1,1) NOT NULL,
	CategoryId INT NOT NULL,
	ProductName VARCHAR(100) NOT NULL,
	Price MONEY NULL
);
GO

--Инструкция добавления данных
INSERT INTO TestTable (CategoryId, ProductName, Price)
VALUES (1, 'Мышь', 100),
	   (2, 'Клавиатура', 200),
	   (3, 'Телефон', 400);
GO

--Создаем процедуру
CREATE PROCEDURE TestProcedure
(
	--Входящие параметры
	@CategoryId INT,
	@ProductName VARCHAR(100),
	@Price MONEY = 0
)
AS
BEGIN
	--Инструкции, реализующие Ваш алгоритм

	--Обработка входящих параметров
	--Удаление лишних пробелов в начале и конце текстовой строки
	SET @ProductName=LTRIM(RTRIM(@ProductName));

	--Добавляем запись
	INSERT INTO TestTable (CategoryId, ProductName, Price)
	VALUES (@CategoryId, @ProductName, @Price)

	--Возвращаем данные
	SELECT *
	FROM TestTable
	WHERE CategoryId=@CategoryId
END

--1. Вызываем процедуру без указания цены
EXEC TestProcedure @CategoryId=1, @ProductName='Тестовый товар 1'

--2. Вызываем процедуру с указанием цены
EXEC TestProcedure @CategoryId=1, @ProductName='Тестовый товар 2', @Price=300

--3. Вызываем процедуру, не указывая параметров
EXEC TestProcedure 1, 'Тестовый товар 3', 300
GO

--Создаем процедуру
ALTER PROCEDURE TestProcedure
(
	--Входящие параметры
	@CategoryId INT,
	@ProductName VARCHAR(100),
	@Price MONEY
)
AS
BEGIN
	--Инструкции, реализующие Ваш алгоритм

	--Обработка входящих параметров
	--Удаление лишних пробелов в начале и конце текстовой строки
	SET @ProductName=LTRIM(RTRIM(@ProductName));

	--Добавляем запись
	INSERT INTO TestTable (CategoryId, ProductName, Price)
	VALUES (@CategoryId, @ProductName, @Price)
END

DROP PROCEDURE TestProcedure