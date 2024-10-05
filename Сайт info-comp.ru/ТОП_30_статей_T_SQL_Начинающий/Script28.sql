DROP TABLE IF EXISTS TestTable;
GO

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
		('Клавиатура', 100),
		('Мышь', 50),
		('Принтер', 200),
		('Сканер', 150),
		('Телефон', 250),
		('Планшет', 300)
--Выборка данных
SELECT *
FROM TestTable

--Пропуск первых 3 строк
SELECT *
FROM TestTable
ORDER BY ProductId
OFFSET 3 ROWS

--Пропуск первых 3 строк и возвращение следующих 3
SELECT *
FROM TestTable
ORDER BY ProductId
OFFSET 3 ROWS FETCH NEXT 3 ROWS ONLY

