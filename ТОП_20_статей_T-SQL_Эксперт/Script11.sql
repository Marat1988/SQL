/*Статья https://info-comp.ru/programmirovanie/557-functions-ms-sql-identity-and-scope-identity.html*/

DROP TABLE IF EXISTS TestTable
GO

CREATE TABLE TestTable
(
	Id INT IDENTITY(1,1) NOT NULL,
	ProductName VARCHAR(50) NULL,
	CONSTRAINT PK_TestTable PRIMARY KEY CLUSTERED (ID ASC)
)
GO

--Пример, когда в таблицу еще никогда не вставлялись даннные
--IDENT_CURRENT возвращает начальное значение идентификатора
SELECT *
FROM TestTable

SELECT IDENT_CURRENT('TestTable') AS [IDENT_CURRENT]

--Пример, когда IDENT_CURRENT возвращает последнее значение идентификатора
INSERT INTO TestTable (ProductName)
VALUES ('Компьтер'),
	   ('Принтер')

SELECT *
FROM TestTable

SELECT IDENT_CURRENT('TestTable') AS [IDENT_CURRENT]

--Пример, когда IDENT_CURRENT возвращает последнее значение идентификатора
--при этом строки с этим идентификатором уже не существует
DELETE TestTable

SELECT *
FROM TestTable

SELECT IDENT_CURRENT('TestTable') AS [IDENT_CURRENT]

--Пример, когда @@IDENTITY вызывают без INSERT
SELECT @@IDENTITY AS [IDENTITY]

--Пример, когда @@IDENTITY возвращает последнее значение идентификатора
INSERT INTO TestTable (ProductName)
VALUES ('Компьютер')

SELECT @@IDENTITY AS [IDENTITY]

--Пример, когда @@IDENTITY возвращает последнее значение идентификатора при этом строки с идентификатором уже не существует
DELETE TestTable
SELECT *
FROM TestTable
SELECT @@IDENTITY AS [IDENTITY]

--Пример, когда SCOPE_IDENTITY вызывают без INSERT
SELECT SCOPE_IDENTITY() AS [SCOPE_IDENTITY]

--Пример, когда SCOPE_IDENTITY() возвращает последнее значение идентификатора
INSERT INTO TestTable
VALUES ('Компьютер')

SELECT *
FROM TestTable

SELECT SCOPE_IDENTITY() AS [SCOPE_INDETITY]

--Пример, когда SCOPE_IDENTITY() возвращает последнее значение идентификатора,
--при этом строки с этим идентификатором уже не существует
DELETE TestTable

SELECT *
FROM TestTable

SELECT SCOPE_IDENTITY() AS [SCOPE_IDENTITY]

--Создаем дополнительную таблицу, начальное значение IDENTITY 100
CREATE TABLE TestTableDOP
(
	ID INT IDENTITY(100,1) NOT NULL,
	ProductName VARCHAR(50) NULL,
	CONSTRAINT PK_TestTableDOP PRIMARY KEY CLUSTERED (ID ASC)
)
GO

--Создаем триггер для TestTable
CREATE TRIGGER TestTRIGGER ON TestTable
FOR INSERT
AS
BEGIN
	INSERT INTO TestTableDOP (ProductName)
	SELECT ProductName
	FROM inserted
END

--Пример, когда SCOPE_IDENTITY и @@IDENTITY
--возвращают разные значения последнего вставленного идентификатора
INSERT INTO TestTable (ProductName)
VALUES ('Компьютер')

SELECT SCOPE_IDENTITY() AS [SCOPE_IDENTITY],
	   @@IDENTITY AS [IDENTITY]

SELECT *
FROM TestTable

SELECT *
FROM TestTableDOP