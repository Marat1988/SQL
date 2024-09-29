/*Статья https://info-comp.ru/obucheniest/623-calculated-columns-in-t-sql.html*/

USE TestDB;
GO

DROP TABLE IF EXISTS TestTable;
GO

--Создание таблицы с вычисляемым столбцом
CREATE TABLE TestTable
(
	ProductId INT IDENTITY(1,1) NOT NULL,
	ProductName VARCHAR(100) NOT NULL,
	Quantity SMALLINT NULL,
	Price MONEY NULL,
	Summa AS ([Quantity]*[Price]) PERSISTED --Вычисляемый столбец
)

--Добавление данных в таблицу
INSERT INTO TestTable
VALUES ('Портфель', 1, 500),
	   ('Карандаш', 5, 20),
	   ('Тетрадь', 10, 50);
GO

--Выборка данных
SELECT *
FROM TestTable

--Добавление вычисляемого столбца в таблицу
ALTER TABLE TestTable ADD SummaALL AS ([Quantity] * [Price] * 1.7);

--Выборка данных
SELECT *
FROM TestTable

ALTER TABLE TestTable DROP COLUMN SummaALL;