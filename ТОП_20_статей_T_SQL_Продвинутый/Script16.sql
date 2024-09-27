/*Статья https://info-comp.ru/programmirovanie/615-views-information-scheme-t-sql.html*/

DROP DATABASE TestBase
GO

CREATE DATABASE TestBase
GO

CREATE TABLE TestTable
(
	ProductId INT IDENTITY(1,1) NOT NULL,
	ProductName VARCHAR(100) NOT NULL,
	Price MONEY
)
GO

INSERT INTO TestTable (ProductName, Price)
VALUES ('Системный блок', 600),
	   ('Монитор', 400),
	   ('Клавиатура', 120),
	   ('Принтер', 450),
	   ('Сканер', 300),
	   ('Мышь', 60),
	   ('Телефон', 350)
GO

CREATE VIEW TestView
AS
	SELECT ProductId, ProductName, Price
	FROM TestTable
GO

CREATE PROCEDURE TestProcedure
(
	@ProductId INT = NULL,
	@Price MONEY = NULL
)
AS
BEGIN
	SELECT ProductId, ProductName, Price
	FROM TestTable
	WHERE ProductId=COALESCE(@ProductId, ProductId)
		AND Price=COALESCE(@Price, Price)
END

SELECT ROUTINE_NAME AS [Имя процедуры],
	CREATED AS [Дата создания],
	ROUTINE_DEFINITION AS [Инструкция создания]
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_TYPE='PROCEDURE'
ORDER BY CREATED DESC

SELECT name AS [Имя процедуры],
		create_date AS [Дата создания],
		OBJECT_DEFINITION(object_id) AS [Инструкция создания]
FROM sys.procedures
ORDER BY create_date DESC

SELECT TABLE_NAME AS [Имя представления],
		VIEW_DEFINITION AS [Инструкция создания]
FROM INFORMATION_SCHEMA.VIEWS

SELECT name AS [Имя представления],
		create_date AS [Дата создания],
		OBJECT_DEFINITION(object_id) AS [Инструкция создания]
FROM sys.views
ORDER BY create_date DESC

SELECT SPECIFIC_NAME AS [Имя процедуры],
		ORDINAL_POSITION AS [Порядковый номер параметра],
		PARAMETER_NAME AS [Имя параметра],
		DATA_TYPE AS [Тип данных параметра]
FROM INFORMATION_SCHEMA.PARAMETERS
WHERE SPECIFIC_NAME = 'TestProcedure'

SELECT OBJECT_NAME(OBJECT_ID) AS [Имя процедуры],
		P.parameter_id AS [Порядковый номер параметра],
		P.name AS [Имя параметра],
		T.name AS [Тип данных параметра]
FROM sys.parameters p
LEFT JOIN sys.types T ON p.user_type_id=T.user_type_id
WHERE OBJECT_ID=OBJECT_ID('TestProcedure')