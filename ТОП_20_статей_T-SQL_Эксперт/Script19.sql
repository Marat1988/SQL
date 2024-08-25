/*Статья https://info-comp.ru/obucheniest/706-get-column-values-in-string-sql.html*/
DROP TABLE IF EXISTS TestTable
GO
--Создание таблицы
CREATE TABLE TestTable
(
	ProductId INT IDENTITY(1,1) NOT NULL,
	ProductName VARCHAR(100) NOT NULL,
	Price MONEY NULL,
	Dt DATETIME NULL
)
GO
--Добавление строк в таблицу
INSERT INTO TestTable (ProductName, Price, Dt)
VALUES ('Системный блок', 300, '01.12.2018'),
	   ('Монитор', 200, '01.01.2019'),
	   ('Клавиатура', 100, '01.02.2019'),
	   ('Мышь', 50, '01.03.2019'),
	   ('Принтер', 200, '01.04.2019')
GO
--Выборка данных
SELECT *
FROM TestTable

--Объявляем переменную для строки данных
DECLARE @TextProduct NVARCHAR(MAX);
--Формируем строку
SELECT @TextProduct=ISNULL(@TextProduct + ', ','') + QUOTENAME(ProductName)
FROM TestTable;
--Смотрим результат
SELECT @TextProduct AS TextProduct

--Объявляем переменную для строки данных
DECLARE @TextYear NVARCHAR(MAX);
--Обобщенное табличное выражение
WITH SRC AS
(
	--Полкчаем уникальные значения
	SELECT DISTINCT YEAR(Dt) AS ProductYear
	FROM TestTable
)
--Формируем строку
SELECT @TextYear=ISNULL(@TextYear + ', ','') + QUOTENAME(ProductYear)
FROM SRC
--Смотрим результат
SELECT @TextYear AS TextYear

SELECT GROUP_CONCAT()