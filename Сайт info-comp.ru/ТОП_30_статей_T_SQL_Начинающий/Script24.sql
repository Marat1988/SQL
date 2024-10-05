/*Статья https://info-comp.ru/programmirovanie/713-examples-case-in-t-sql.html*/

DROP TABLE IF EXISTS TestTable;
GO
--Создание таблицы
CREATE TABLE TestTable
(
	ProductId INT IDENTITY(1,1) NOT NULL,
	ProductName VARCHAR(100) NOT NULL,
	Price MONEY NULL
)
GO

--Добавление строк в таблицу
INSERT INTO TestTable(ProductName, Price)
VALUES ('Системный блок', 300),
		('Монитор', 200),
		('Клавиатура', 100),
		('Мышь', 50),
		('Принтер', 200);
GO
--Выборка данных
SELECT *
FROM TestTable

--Простое выражение CASE
SELECT CASE ProductId WHEN 1 THEN 'Один'
					  WHEN 2 THEN 'Два'
					  WHEN 3 THEN 'Три'
					  WHEN 4 THEN 'Четыре'
					  WHEN 5 THEN 'Пять'
	   ELSE '' END AS IdText,
	  ProductId, ProductName, Price
FROM TestTable

--Пример поискового выражения CASE
SELECT CASE WHEN Price > 100 THEN 'Больше 100'
			WHEN Price=100 THEN 'Равно 100'
			WHEN Price < 100 THEN 'Меньше 100'
			WHEN Price=300 AND ProductId=1 THEN 'Цена равно 300 и Id равен 1'
			ELSE 'Нет подходящего условия'
	   END AS IdText,
	   ProductId, ProductName, Price
FROM TestTable

--Пример выражения CASE в инструкции SET
DECLARE @TestVar VARCHAR(10);
DECLARE @Id INT=1;

SET @TestVar=CASE WHEN @Id=1 THEN 'Один'
				  WHEN @Id=2 THEN 'Два'
				  WHEN @Id=3 THEN 'Три'
				  ELSE ''
			 END;

SELECT @TestVar AS TestVar
