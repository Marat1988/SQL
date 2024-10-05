/*Статья https://info-comp.ru/obucheniest/561-merge-in-t-sql.html*/

DROP TABLE IF EXISTS TestTable;
GO

--Целевая таблица
CREATE TABLE TestTable
(
	ProductId INT NOT NULL,
	ProductName VARCHAR(50) NULL,
	Summa MONEY NULL,
	CONSTRAINT PK_TestTable PRIMARY KEY CLUSTERED (ProductId ASC)
);
--Таблица источник
CREATE TABLE TestTableDop
(
	ProductId INT NOT NULL,
	ProductName VARCHAR(50) NULL,
	Summa MONEY NULL,
	CONSTRAINT PK_TestTableDop PRIMARY KEY CLUSTERED (ProductId ASC)
);
--Добавляем данные в основную таблицу
INSERT INTO TestTable (ProductId, ProductName, Summa)
VALUES (1, 'Компьютер', 0),
	   (2, 'Принтер', 0),
	   (3, 'Монитор', 0);
--Добавляем данные в таблицу источник
INSERT INTO TestTableDop(ProductId, ProductName, Summa)
VALUES (1, 'Компьютер', 500),
	   (2, 'Принтер', 300),
	   (4, 'Монитор', 400);
GO

SELECT *
FROM TestTable

SELECT *
FROM TestTableDop

MERGE TestTable AS T_Base --Целевая таблица
USING TestTableDop AS T_Source --Таблица источник
ON (T_Base.ProductId=T_Source.ProductId) --Условие объединения
WHEN MATCHED THEN --Если истина (UPDATE)
	UPDATE SET ProductName=T_Source.ProductName, Summa=T_Source.Summa
WHEN NOT MATCHED THEN --Есои не истина (INSERT)
	INSERT (ProductId, ProductName, Summa)
	VALUES (T_Source.ProductId, T_Source.ProductName, T_Source.Summa)
--Посмотрим, что мы сделали
OUTPUT $action AS [Операция], Inserted.ProductId,
	Inserted.ProductName AS ProductNameNEW,
	Inserted.Summa AS SummaNew,
	Deleted.ProductName AS ProductNameOLD,
	Deleted. Summa AS SummaOLD; --Не забываем про точку с запятой
--Итоговый результат
SELECT *
FROM TestTable

SELECT *
FROM TestTableDop

--Удаление строки с ProductId=4
--для того, чтобы отработало условие WHEN NOT MATCHED
DELETE FROM TestTable WHERE ProductId=4

--Запрос MERGE для синхронизации таблиц
MERGE TestTable AS T_Base --Целевая таблица
--Запрос в качестве источника
USING (SELECT ProductId, ProductName, Summa
	   FROM TestTableDop) AS T_Source (ProductId, ProductName, Summa)
ON (T_Base.ProductId=T_Source.ProductId) --Условие объекдинения
WHEN MATCHED THEN --Если нстина (UPDATE)
	UPDATE SET ProductName=T_Source.ProductName, Summa=T_Source.Summa
WHEN NOT MATCHED THEN --Если НЕ истина (INSERT)
	INSERT (ProductId, ProductName, Summa)
	VALUES (T_Source.ProductId, T_Source.ProductName, T_Source.Summa)
--Удаляем строки, если их нет в TestTableDOP
WHEN NOT MATCHED BY SOURCE THEN DELETE
--Посмотрим, что мы сделали
OUTPUT $action AS [Операция], Inserted.ProductId, Inserted.ProductName AS ProductName,
	Inserted.Summa AS SummaNew, Deleted.ProductName AS ProductNameOLD,
	Deleted.Summa AS SummaOLD; --Не забываем про точку с запятой
--Итоговый результат
SELECT *
FROM TestTable

SELECT *
FROM TestTableDop

--Очищаем поле сумма у одной строки в TestTableDop
UPDATE TestTableDop SET Summa=NULL WHERE ProductId=2
--Запрос MERGE
MERGE TestTable AS T_Base --Целевая таблица
USING TestTableDop AS T_Source --Таблица источник
ON (T_Base.ProductId=T_Source.ProductId) --Условие объединения
--Если истина + доп. условие отработало (UPDATE)
WHEN MATCHED AND T_Source.Summa IS NOT NULL THEN
	UPDATE SET ProductName=T_Source.ProductName, Summa=T_Source.Summa
WHEN NOT MATCHED THEN --Если не истина (INSERT)
	INSERT (ProductId, ProductName, Summa)
	VALUES (T_Source.ProductId, T_Source.ProductName, T_Source.Summa)
--Посмотрим, что мы сделали
OUTPUT $action AS [Операция], Inserted.ProductId,
		Inserted.ProductName AS ProductNameNEW,
		Inserted.Summa AS SummaNew,
		Deleted.ProductName AS ProductNameOLD,
		Deleted.Summa AS SummaOLD; --Не забываем про точку с запятой
--Итоговый результат
SELECT *
FROM TestTable

SELECT *
FROM TestTableDop