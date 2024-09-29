/*Статья https://info-comp.ru/obucheniest/650-output-in-t-sql.html*/

DROP TABLE IF EXISTS TestTable
--Создание таблицы
CREATE TABLE TestTable
(
	ProductId INT IDENTITY(1,1) NOT NULL,
	CategoryId INT NOT NULL,
	ProductName VARCHAR(100) NOT NULL,
	Price MONEY NULL
);
GO
INSERT INTO TestTable
OUTPUT inserted.ProductId,
	   inserted.CategoryId,
	   inserted.ProductName,
	   inserted.Price
VALUES (1, 'Клавиатура', 150),
	   (1, 'Мышь', 50),
	   (2, 'Телефон', 300)

UPDATE TestTable SET Price += 10
OUTPUT inserted.ProductId AS [ProductId],
	   deleted.Price AS [Старое значение Price],
	   inserted.Price AS [Новое значение Price]
WHERE Price < 200

--Объявление табличной переменной
DECLARE @TmpTable TABLE
(
	ProductId INT,
	PriceOld MONEY,
	PriceNew MONEY
)

--Выполнение UPDATE с инструкцией OUTPUT
UPDATE TestTable SET Price += 10
OUTPUT inserted.ProductId AS [ProductId],
	   deleted.Price AS [Старое значение Price],
	   inserted.Price AS [Новое значение Price]
INTO @TmpTable (ProductId, PriceOld, PriceNew) --Сохраняем результат в табличной переменной
WHERE Price < 200

--Можем анализировать сохраненные данные
SELECT *
FROM @TmpTable

DELETE TestTable
OUTPUT deleted.*
WHERE ProductId < 3