/*Статья https://info-comp.ru/programmirovanie/539-any-some-all-in-t-sql.html*/

DROP TABLE IF EXISTS TestTable;
GO

--Создание таблицы
CREATE TABLE TestTable
(
	Id INT IDENTITY(1,1) NOT NULL,
	ProductName VARCHAR(50) NOT NULL,
	Price MONEY NULL,
	CategoryId INT NOT NULL,
	CONSTRAINT PK_TestTable PRIMARY KEY CLUSTERED (Id ASC)
)
GO
--Вставляем текстовые данные
INSERT INTO TestTable (ProductName, Price, CategoryId)
VALUES ('Компьютер', 500, 1)
GO
INSERT INTO TestTable (ProductName, Price, CategoryId)
VALUES ('Монитор', 400, 2)
GO
INSERT INTO TestTable (ProductName, Price, CategoryId)
VALUES ('Телефон', 200, 1)
GO
INSERT INTO TestTable (ProductName, Price, CategoryId)
VALUES ('Планшет', 300, 1)
GO
INSERT INTO TestTable (ProductName, Price, CategoryId)
VALUES ('Принтер', 250, 2)
GO

--Цена товаров из второй категории
SELECT *
FROM TestTable
WHERE CategoryId=2

--ANY
SELECT *
FROM TestTable
WHERE CategoryId=1 AND Price > ANY(SELECT Price
								   FROM TestTable
								   WHERE CategoryId=2)

--ALL
SELECT *
FROM TestTable
WHERE CategoryId=1 AND Price > ALL(SELECT Price
								   FROM TestTable
								   WHERE CategoryId=2)

--ANY
SELECT *
FROM TestTable
WHERE CategoryId=1 AND Price > ANY(SELECT Price
								   FROM TestTable
								   WHERE CategoryId=5)

--ALL
SELECT *
FROM TestTable
WHERE CategoryId=1 AND Price > ALL(SELECT Price
								   FROM TestTable
								   WHERE CategoryId=5)

INSERT INTO TestTable (ProductName, Price, CategoryId)
VALUES ('Сканер', NULL, 2)
GO

--ANY
SELECT *
FROM TestTable
WHERE CategoryId=1 AND Price > ANY(SELECT Price
								   FROM TestTable
								   WHERE CategoryId=2)

--ALL
SELECT *
FROM TestTable
WHERE CategoryId=1 AND Price > ALL(SELECT Price
								   FROM TestTable
								   WHERE CategoryId=2)