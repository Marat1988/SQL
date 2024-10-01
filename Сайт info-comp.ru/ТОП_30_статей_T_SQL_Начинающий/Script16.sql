/*Статья https://info-comp.ru/programmirovanie/580-truncate-table-ms-sql-server.html*/

DROP TABLE IF EXISTS TestTable;
GO

--Создаем тестовую таблицу
CREATE TABLE TestTable
(
	ProductId INT IDENTITY(1,1) NOT NULL,
	ProductName VARCHAR(100) NOT NULL
);
GO

--Добавляем данные
INSERT INTO TestTable
VALUES ('Компьютер'),
	   ('Монитор'),
	   ('Принтер');
GO

--Выборка данных
SELECT *
FROM TestTable;

--Удаляем все данные инструкцией TRUNCATE TABLE
TRUNCATE TABLE TestTable;
GO

--Снова созраняем данные
INSERT INTO TestTable
VALUES ('Компьютер'),
	   ('Монитор'),
	   ('Принтер');
GO

--Выборка данных
SELECT *
FROM TestTable;
