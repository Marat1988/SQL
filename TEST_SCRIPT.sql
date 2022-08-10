CREATE DATABASE TestDB
GO
-------------------------------------------------------------------------------
 --Создание таблицы
CREATE TABLE TestTable(
	 ProductId INT IDENTITY(1,1) NOT NULL,
	 CategoryId INT NOT NULL,
	 ProductName VARCHAR(100) NOT NULL,
	 Price Money NULL)
GO
CREATE TABLE TestTable2(
	 CategoryId INT IDENTITY(1,1) NOT NULL,
	 CategoryName VARCHAR(100) NOT NULL
)
GO
CREATE TABLE TestTable3(
	 ProductId INT IDENTITY(1,1) NOT NULL,
	 ProductName VARCHAR(100) NOT NULL,
	 [Weight] DECIMAL(18,2) NULL,
	 Price MONEY NULL,
	 Summa AS ([Weight]*Price) PERSISTED --Создание вычисляемого столбца. PERSISTED - данные должны храниться физически --Новая для меня
)
GO
--Добавление столбца в таблицу.
ALTER TABLE TestTable3 ADD SummaDOP AS ([Weight]*Price) PERSISTED
GO
--Удаление таблицы
DROP TABLE TestTable3
GO
-------------------------------------------------------------------------------
--Производим изменения в стоблце Price таблицы TestTable, а именно делаем его NOT NULL
ALTER TABLE TestTable ALTER COLUMN Price MONEY NOT NULL
GO
--Удаление столбца таблицы
ALTER TABLE TestTable DROP COLUMN Price
GO
--Добавление столбца в таблицу
ALTER TABLE TestTable ADD Price MONEY NULL
-------------------------------------------------------------------------------
--Создание временной таблицы
CREATE TABLE #TestTable(
	Id INT IDENTITY(1,1) NOT NULL,
	ProductName VARCHAR(100) NOT NULL,
	Price MONEY NULL)
GO
--Удаление временной таблицы
DROP TABLE #TestTable
-------------------------------------------------------------------------------
--Глава 4
--Добавление данных в таблицу
INSERT TestTable
VALUES (1,'Клавиатура',100),
	   (1,'Мышь',50),
	   (2,'Телефон',300)
GO
INSERT TestTable2
VALUES('Комплектующие компьютера'),
	  ('Мобильные устройства')
GO
--Выборка данных из таблицы
SELECT ProductId, ProductName, Price FROM TestTable
GO
--Выборка из данных только первых 2-х столбцов
SELECT TOP 2 ProductId, ProductName, Price FROM TestTable
GO
--Вывод первых двух самых дорогих товаров по цене. Но, если товаров с одинаковой ценой может быть несколько, то тогда используем WITH TIES
SELECT TOP 2 WITH TIES ProductId, ProductName, Price FROM TestTable --Новая для меня
ORDER BY Price DESC
GO
--Возвращам 20 процентов итогового результата с учетом сортировки
SELECT TOP 20 PERCENT ProductId, ProductName, Price FROM TestTable
ORDER BY Price DESC
GO
--Получаем уникальные сочетания (ключевое слово DISTINCT) товара и цены
SELECT DISTINCT ProductName, Price FROM TestTable
GO
--Получение всех записей из таблицы (знак *)
SELECT * FROM TestTable
GO
--Запрос с полным указанием источника данных (ИмяБазы.ИмяСхемы.ИмяТаблицы)
SELECT * FROM TestDB.dbo.TestTable
GO
--Использование псевдонимов
SELECT T.ProductId AS ID,
	   T.ProductName AS ProductName,
	   T.Price AS Цена
FROM TestTable AS T
GO
--Предикат, т.е. условие WHERE
SELECT ProductId, ProductName, Price FROM TestTable WHERE Price>10
GO
SELECT ProductId,
	   ProductName,
	   Price
FROM TestTable
WHERE Price>=100 AND Price<=500
GO
SELECT ProductId,
	   ProductName,
	   Price
FROM TestTable
WHERE Price BETWEEN 100 AND 500
GO
--Название товаров, которые начинаются с буквы Т
SELECT ProductId,
	   ProductName,
	   Price
FROM TestTable
WHERE ProductName LIKE 'Т%'
GO
SELECT ProductId,
	   ProductName,
	   Price
FROM TestTable
WHERE Price IN (50, 100)
GO
SELECT ProductId,
	   ProductName,
	   Price
FROM TestTable
WHERE Price=50 OR Price=100
GO
SELECT ProductId,
	   ProductName,
	   Price
FROM TestTable
WHERE Price IS NOT NULL
GO
--Агрегирующие функции
SELECT COUNT(*) AS [Количество строк],
	   SUM(Price) AS [Сумма по столбцу Price],
	   MAX(Price) AS [Максимальное значение в стоблце Price],
	   MIN(Price) AS [Минимальное значение в толбце Price],
	   AVG(Price) AS [Среднее значение в столбце Price]
FROM TestTable
GO
SELECT CategoryId AS [Id категории],
	   COUNT(*) AS [Количество строк],
	   MAX(Price) AS [Максимальное значение в стобце Price],
	   MIN(Price) AS [Минимальное значение в столбце Price],
	   AVG(Price) AS [Среднее значение в столбце Price]
FROM TestTable
GROUP BY CategoryId
GO
--GROUP BY c условием
SELECT CategoryId AS [Id категории],
	   COUNT(*) AS [Количество строк],
	   MAX(Price) AS [Максимальное значение в столбце Price],
	   MIN(Price) AS [Минимальное значение в столбце Price],
	   AVG(Price) AS [Среднее значение в стоблце Price]
FROM TestTable
WHERE ProductId<>1
GROUP BY CategoryId
GO
--HAVING
SELECT CategoryId AS [Id категории],
	   COUNT(*) AS [Количество строк]
FROM TestTable
GROUP BY CategoryId
HAVING COUNT(*)>1
GO
--ORDER BY
SELECT ProductId,
	   ProductName,
	   Price
FROM TestTable
ORDER BY Price
GO
SELECT ProductId,
	   ProductName,
	   Price
FROM TestTable
ORDER BY Price DESC
GO
SELECT ProductId,
	   ProductName,
	   Price
FROM TestTable
ORDER BY Price DESC, ProductId
GO
SELECT ProductId,
       ProductName,
	   Price
FROM TestTable
ORDER BY 3 DESC, 1
GO
SELECT ProductId,
       ProductName,
	   Price
FROM TestTable
ORDER BY Price DESC
OFFSET 1 ROWS --Новое для меня. OFFSET это возвращение данных со второй строки, т.е. OFFSET-1, т.е. первая строка будет в результирующем запросе будет пропущена
GO
SELECT ProductId,
	   ProductName,
	   Price
FROM TestTable
ORDER BY Price DESC
OFFSET 1 ROWS FETCH NEXT 1 ROWS ONLY --Новое для меня. В данном запросе первая строка будет пропущена (OFFSET 1 ROWS).
									 --Но нам вернется только одна следующая строка, т.к. мы указали инструкцию FETCH NEXT 1 ROWS ONLY
									 --Как вы пониматете, значение 1 можно изменять на нужное Вам.
--INNER JOIN
SELECT T1.ProductName,
	   T2.CategoryName,
	   T1.Price
FROM TestTable T1
INNER JOIN TestTable2 T2 ON T1.CategoryId=T2.CategoryId
ORDER BY T1.CategoryId
GO
--LEFT JOIN - записи которые возвращаются из таблицы слева. Даже если в правой таблице не существует.
SELECT T1.ProductName,
	   T2.CategoryName,
	   T1.Price
FROM TestTable T1
LEFT JOIN TestTable2 T2 ON T1.CategoryId=T2.CategoryId
ORDER BY T1.CategoryId
GO
------------
SELECT T1.ProductName,
	   T2.CategoryName,
	   T1.Price
FROM TestTable T1
INNER JOIN TestTable2 T2 ON T1.CategoryId=3
ORDER BY T1.CategoryId
GO
SELECT T1.ProductName,
	   T2.CategoryName,
	   T1.Price
FROM TestTable T1
LEFT JOIN TestTable2 T2 ON T1.CategoryId=3
ORDER BY T1.CategoryId
GO
------------
--RIGHT JOIN - возвращаются все записи из правой таблицы и соответствующие записи из левой
SELECT T1.ProductName,
       T2.CategoryName,
	   T1.Price
FROM TestTable T1
RIGHT JOIN TestTable2 T2 ON T1.CategoryId=T2.CategoryId
ORDER BY T1.CategoryId
GO
SELECT T1.ProductName,
       T2.CategoryName,
	   T1.Price
FROM TestTable T1
RIGHT JOIN TestTable2 T2 ON t1.CategoryId=3
ORDER BY t1.CategoryId
GO
--FULL JOIN Вовзращает все записи как из левой, так и из правй таблицы, даже если условие не выполняется
SELECT T1.ProductName,
	   T2.CategoryName,
	   T1.Price
FROM TestTable T1
FULL JOIN TestTable2 T2 ON T1.CategoryId=3
ORDER BY T1.CategoryId
GO
--CROSS JOIN - Каждая строка из одной таблицы объединятеся со всеми строками в другой таблицы.
			--Произведение количество строк в первой таблице на количество строк во второй таблице
SELECT T1.ProductName,
	   T2.CategoryName,
	   T1.Price
FROM TestTable T1
CROSS JOIN TestTable2 T2
ORDER BY T1.CategoryId
GO
SELECT T1.ProductName,
	   T2.CategoryName,
	   T1.Price
FROM TestTable T1
CROSS JOIN TestTable2 T2
WHERE T1.CategoryId=T2.CategoryId
ORDER BY T1.CategoryId
GO
--UNION  - объединение данных в один набор
SELECT T1.ProductId,
	   T1.ProductName,
	   T1.Price
FROM TestTable T1
WHERE T1.ProductId=1
UNION
SELECT T1.ProductId,
	   T1.ProductName,
	   T1.Price
FROM TestTable T1
WHERE T1.ProductId=3
GO
----------------------
SELECT T1.ProductId,
	   T1.ProductName,
	   T1.Price
FROM TestTable T1
WHERE T1.ProductId=1
UNION
SELECT T1.ProductId,
	   T1.ProductName,
	   T1.Price
FROM TestTable T1
WHERE T1.ProductId=1
GO
SELECT T1.ProductId,
	   T1.ProductName,
	   T1.Price
FROM TestTable T1
WHERE T1.ProductId=1
UNION ALL
SELECT T1.ProductId,
	   T1.ProductName,
	   T1.Price
FROM TestTable T1
WHERE T1.ProductId=1
GO
----------------------
--INTERSECT - новое для меня. Оператор, который выводит одинаковые строки из первого, второго и последующих наборов данных
--Он выведет только те строки, которые есть как в первом результирующем наборе, так и во втором (третьем и так далее), т.е. происходит пересечение этих строк
SELECT T1.ProductId,
	   T1.ProductName,
	   T1.Price
FROM TestTable T1
WHERE T1.ProductId=1
INTERSECT
SELECT T1.ProductId,
	   T1.ProductName,
	   T1.Price
FROM TestTable T1
WHERE T1.ProductId=1
GO
--------------
SELECT T1.ProductId,
	   T1.ProductName,
	   T1.Price
FROM TestTable T1
WHERE T1.ProductId=1
UNION
SELECT T1.ProductId,
	   T1.ProductName,
	   T1.Price
FROM TestTable T1
WHERE T1.ProductId=2
GO
SELECT T1.ProductId,
	   T1.ProductName,
	   T1.Price
FROM TestTable T1
WHERE T1.ProductId=1
INTERSECT
SELECT T1.ProductId,
	   T1.ProductName,
	   T1.Price
FROM TestTable T1
WHERE T1.ProductId=2
GO
--------------
--EXCEPT новое для меня. Этот оператор выводит только те данные из первого набора строк, которых нет во втором наборе.
SELECT T1.ProductId,
	   T1.ProductName,
	   T1.Price
FROM TestTable T1
WHERE T1.ProductId=1
EXCEPT
SELECT T1.ProductId,
	   T1.ProductName,
	   T1.Price
FROM TestTable T1
WHERE T1.ProductId=2
--Подзапросы
SELECT T2.CategoryName AS [Название категории],
       (SELECT COUNT(*)
	    FROM TestTable
	    WHERE CategoryId=T2.CategoryId) AS [Количество товаров]
FROM TestTable2 T2
GO
SELECT ProductId, Price 
FROM (SELECT ProductId,
		     Price
	  FROM TestTable) AS Q1
GO
SELECT Q1.ProductId,Q1.Price, Q2.CategoryName
FROM (SELECT ProductId,
			 Price,
			 CategoryId
	  FROM TestTable) AS Q1
LEFT JOIN (SELECT CategoryId, CategoryName FROM TestTable2) AS Q2 ON 
Q1.CategoryId=Q2.CategoryId
GO
--Представления
CREATE VIEW ViewCntProducts
AS
	SELECT T2.CategoryName AS CategoryName,
		   (SELECT COUNT(*) 
		    FROM TestTable
			WHERE CategoryId = T2.CategoryId) AS CntProducts
	FROM TestTable2 T2
GO
SELECT * FROM ViewCntProducts
GO
ALTER VIEW ViewCntProducts
AS
	SELECT T2.CategoryId AS CategoryId,
		   T2.CategoryName AS CategoryName,
		   (SELECT COUNT(*)
		    FROM TestTable
			WHERE CategoryId=T2.CategoryId) AS CntProducts
	FROM TestTable2 T2
GO
SELECT * FROM ViewCntProducts
GO
DROP VIEW ViewCntProducts
GO
--Системные представления
SELECT * FROM sys.tables --Новое для меня. Представление, которое содержит информацию о таблицах в базе данных
GO
SELECT * FROM sys.columns --Новое для меня. Представление, которое содержит информацию о колонках в таблице TestTable
WHERE object_id=object_id('TestTable')
--Модификация данных
--INSERT
INSERT INTO TestTable
	VALUES (1,'Клавиатура',100),
		   (1,'Мышь',50),
	       (2,'Телефон',300)
GO
INSERT INTO TestTable2
	VALUES ('Комплектующие компьютера'),
		   ('Мобильные устройства')
GO
SELECT * FROM TestTable
GO
SELECT * FROM TestTable2
GO --Новое для меня. GO - это команда отделения одного пакета инструкций от другого
INSERT INTO TestTable (CategoryId, ProductName, Price)
	VALUES (1,'Клавиатура',100),
		   (1,'Мышь',50),
		   (2,'Телефон',300)
GO
SELECT * FROM TestTable
GO
INSERT INTO TestTable(CategoryId, ProductName, Price)
	SELECT CategoryId, ProductName, Price 
	FROM TestTable
	WHERE ProductId>3
--UPDATE
SELECT *
FROM TestTable
WHERE ProductId=1
GO
UPDATE TestTable SET Price=120
WHERE ProductId=1
GO
SELECT *
FROM TestTable
WHERE ProductId=1
GO
SELECT *
FROM TestTable
WHERE ProductId>3
GO
UPDATE TestTable SET ProductName='Тестовый товар', Price=150
WHERE ProductId>3
GO
SELECT *
FROM TestTable
WHERE ProductId>3
GO
SELECT *
FROM TestTable
WHERE ProductId>3
GO
UPDATE TestTable SET ProductName=T2.CategoryName, Price=200
FROM TestTable2 T2
INNER JOIN TestTable T1 ON T1.CategoryId=T2.CategoryId
WHERE T1.ProductId>3
GO
SELECT *
FROM TestTable
WHERE ProductId>3
GO
--DELETE, TRUNCATE --Новое для меня. TRUNCATE - удаляет все строки в таблице, при этом нк записывая удаление отдельных
                   --строки в журнал транзакций. Если в таблице есть столбец идентификаторов (задано свойство IDENTITY), TRUNCATE сбрасывает счетчик на начальное значение,
				   --а DELETE нет. 
SELECT * FROM TestTable
GO
DELETE TestTable
WHERE ProductId>3
GO
SELECT * FROM TestTable
GO
SELECT * FROM TestTable
GO
TRUNCATE TABLE TestTable
GO
SELECT * FROM TestTable
GO
INSERT INTO TestTable
	VALUES (1,'Клавиатура',100),
		   (1,'Мышь',50),
		   (2,'Телефон',300)
GO
SELECT * FROM TestTable
GO
--MERGE - новое для меня. Выполняет операции добавления, обновления или удаления данных для таблицы на
                         --основе результатов соединения с другой таблицей. Другими словами, с помощью MERGE можно в одной инструкции
						 --выполнить INSERT, UPDATE или DELETE на основе выполнения или невыполнения определенного условия.
						 --Например, можно синхронизировать две схожие таблицы за счет выполнения соответствующих операций, если в одной
						 --таблице есть строка, а в другой ее нет, то выполняем вставку данных, если строка есть, то обновляем ее, а если есть строка, которой не должно быть, то удаляем ее.
/*MERGE<Основная таблица>
	  USING <Таблица или запрос источника>
	  [WHEN MATCHED [ AND<Доп. условие> ]
			THEN <UPDATE или DELETE>
	  [WHEN NOT MATCHED [ AND Доп. условие>]
			THEN <INSERT> ]
	  [WHEN NOT MATCHED BY SOURCE [ AND <Доп. условие> ]
			THEN <UPDATE или DELETE>] [...n]
 OUTPUT*/
/*Сначала мы пишем MERGE, затем название таблицы, в которую нам необходимо внести изменения. После мы пишем ключевое слово USING и указываем таблицу,
с которой нам необходимо выполнить объединение, с помощью ключевого стола ON мы указываем условие объединения.*/

/*Если условие, по которому происходит объединение, истина (WHEN MATCHED), то мы можем выполнить обновление или удаления.
Если условие не истина, т.е. отсутствуют данные (WHEN NOT MATCHED), то мы может выполнить операцию вставки (INSERT добавление данных).
Также если в основной таблице присутствуют данные, которые отсутствуют в таблице (или результате запроса) источника (WHEN NOT MATCHED BY SOURCE), то мы может выполнить обновление или удаление таких данных.*/
CREATE TABLE TestTable3(
	[ProductId] [INT] NOT NULL,
	[CategoryId] [INT] NOT NULL,
	[ProductName] [VARCHAR](100) NOT NULL,
	[Price] [Money] NULL)
GO
INSERT INTO TestTable3
	VALUES (1,1,'Клавиатура',0),
		   (2,1,'Мышь',0),
		   (4,1,'Тест',0)
GO
SELECT * FROM TestTable
GO
SELECT * FROM TestTable3
GO
MERGE TestTable3 AS T_Base
	USING TestTable AS T_Source
	ON (T_Base.ProductId=T_Source.ProductId)
	WHEN MATCHED THEN
		  UPDATE SET ProductName=T_Source.ProductName, CategoryId=T_Source.CategoryId, Price=T_Source.Price
	WHEN NOT MATCHED THEN
		  INSERT (ProductId,CategoryId, ProductName, Price)
		  VALUES (T_Source.ProductId, T_Source.CategoryId, T_Source.ProductName, T_Source.Price)
	WHEN NOT MATCHED BY SOURCE THEN
		 DELETE
OUTPUT $action AS [Операция], Inserted.ProductId, --Новое для меня. $action - Хранит название операции, которая была выполнена для соответствующей остроки.
		 Inserted.ProductName AS ProductNameNEW, --Системные временные таблицы Inserted и Deleted (находящиеся в оперативной памяти) хранят копии строк, над которыми была произведена операция
		 Inserted.Price AS PriceNew, 
		 Deleted.ProductName AS ProductNameOLD,
		 Deleted.Price AS PriceOLD;
GO
SELECT * FROM TestTable
GO
SELECT * FROM TestTable3
GO
--OUTPUT - новое для меня. Это инструкция, позволяющая получить изменившиеся строки в результате выполнения инструкции INSERT, UPDATE, DELETE или MERGE
--INSERTED указывается для того, чтобы узнать добавленные строки, и новые значения в случае с обновлением.
--DELETED для того, чтобы узнать удаленные строки, и старые значения в случае с обновлением с обновлением данных
INSERT INTO TestTable
	OUTPUT Inserted.ProductId,
		   Inserted.CategoryId,
		   Inserted.ProductName,
		   Inserted.Price
	VALUES (1, 'Тетовый товар 1',300),
		   (1,'Тестовый товар 2',500),
		   (2,'Тестовый товар 3',400)
GO
UPDATE TestTable SET Price = 0
	OUTPUT Inserted.ProductId AS [ProductId],
		   Deleted.Price AS [Старое значение Price],
		   Inserted.Price AS [Новое значение Price]
WHERE ProductId > 3
GO
DELETE TestTable
	OUTPUT Deleted.*
WHERE ProductId>3
GO
--Индексы.
CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON TestTable --Новое для меня. Создание уникального кластеризованного индекса
(
	ProductId ASC
)
GO
CREATE NONCLUSTERED INDEX IX_NonClustered ON TestTable --Новое для меня. Создание некластеризованного индекса
(
	CategoryId ASC
)
GO
DROP INDEX IX_NonClustered ON TestTable
GO
CREATE NONCLUSTERED INDEX IX_NonClustered ON TestTable --Новое для меня. Индекс со включенными столбцами. Это столбцы, которые не являются ключевыми, но включаются в индекс
(													   --За счет этого уменьшается количество дисковых операций ввода-вывода и скорость доступа к данным, соответственно, увеличивается
	CategoryId ASC,
	ProductName ASC
)
	INCLUDE (Price) --Новое для меня. INCLUDE - добавляем в индекс не ключевые столбцы, т.е. включенные
GO
CREATE NONCLUSTERED INDEX IX_NonClustered ON TestTable
(
	CategoryId ASC,
	ProductName ASC
)
	INCLUDE (Price)
WITH (DROP_EXISTING = ON) --Новое для меня DROP_EXISTING - т.е. индекс существует. И его необходимо удалить и заново создать
GO
--Обслуживание индексов
SELECT OBJECT_NAME(T1.object_id) AS NameTable, --Новое для меня. sys.dm_db_index_physical_stats - табличная функция для определения степени фрагментации индекса
	   T1.index_id AS IndexId,
	   T2.name AS IndexName,
	   T1.avg_fragmentation_in_percent AS Fragmentation
FROM sys.dm_db_index_physical_stats(DB_ID(),NULL,NULL,NULL,NULL) AS T1
LEFT JOIN sys.indexes AS T2 ON T1.object_id = T2.object_id AND T1.index_id = T2.index_id
GO
ALTER INDEX IX_NonClustered ON TestTable --Ноове для меня. Реорганизация индекса
	REORGANIZE
GO
ALTER INDEX IX_NonClustered ON TestTable --Новое для меня. Перестроение индекса
	REBUILD
GO
--Ограничения
ALTER TABLE TestTable ALTER COLUMN [Price] [Money] NOT NULL
GO
CREATE TABLE TestTable4( --Новое для меня. Создание ограничения на уровне столбца
	[CategoryId] [INT] IDENTITY(1,1) NOT NULL CONSTRAINT
PK_Category PRIMARY KEY,
	[CategoryName] [VARCHAR](100) NOT NULL)
GO
CREATE TABLE TestTable4( --Новое для меня. Создание ограничения на уровне таблицы
	[CategoryId] [INT] IDENTITY(1,1) NOT NULL,
	[CategoryName] [VARCHAR](100) NOT NULL,
	CONSTRAINT PK_CategoryId PRIMARY KEY (CategoryId))
GO
ALTER TABLE TestTable ADD CONSTRAINT PK_TestTable PRIMARY KEY (ProductId) --Новое для меня. Создание ограничания
GO
CREATE TABLE TestTable5( --Новое для меня. Создание ограничения FOREIGN KEY. Ограничение внешнего ключа у нас будет ссылаться на идентификатор в таблице TestTable4,
	[ProductId] [INT] IDENTITY(1,1) NOT NULL, --другими словами, мы говорим, что значение определенного столбца, которые будут добавляться в таблицу,
	[CategoryId] [INT] NOT NULL,			 --Обязательно должны уже существовать в TestTable4
	[ProductName] [VARCHAR](100) NOT NULL,
	[Price] [MONEY] NULL,
CONSTRAINT PK_TestTable5 PRIMARY KEY (ProductID),
CONSTRAINT FK_TestTable5 FOREIGN KEY (CategoryID) REFERENCES TestTable4(CategoryId) ON DELETE CASCADE ON UPDATE NO ACTION)
GO
--Для инструкции ON DELETE и ON UPDATE доступны следующие изменения: NO ACTION - ничего не делать, просто выводить ошибку,
--CASCADE - каскадное изменение,
--SET NULL - присвоить значение NULL,
--SET DEFAULT - присвоить значение по умолчанию
ALTER TABLE TestTable2 ADD CONSTRAINT PK_TestTable2 PRIMARY KEY (CategoryId); 
GO
ALTER TABLE TestTable ADD CONSTRAINT FK_TestTable FOREIGN KEY (CategoryId) REFERENCES TestTable2 (CategoryId);--Новое для меня. Создали ограничение FOREIGN KEY. 
GO --В данном случае мы не указали инструкции ON DELETE и ON UPDATE, т.е. в случае удаления или изменения ключевого столбца будет появляться ошибка
CREATE TABLE TestTable6( --Новое для меня. Создание ограничения UNIQUE
	[Column1] [INT] NOT NULL CONSTRAINT PK_TestTable6_C1 UNIQUE,
	[Column2] [INT] NOT NULL,
	[Column3] [INT] NOT NULL,
	CONSTRAINT PK_TestTable6_C2 UNIQUE (Column3))
GO
ALTER TABLE TestTable6 ADD CONSTRAINT PK_TestTable6_C3 UNIQUE (Column3)
GO
CREATE TABLE TestTable7( --Новое для меня. Создание ограничения CHECK
	[Column1] [INT] NOT NULL,
	[Column2] [INT] NOT NULL,
	CONSTRAINT CK_TestTable7_C1 CHECK (Column1 <> 0));
GO
ALTER TABLE TestTable7 ADD CONSTRAINT CK_TestTable7_C2 CHECK (Column2>Column1);
GO
CREATE TABLE TestTable8 ( --Новое для меня. Создание ограничения DEFAULT
	[Column1] [INT] NULL CONSTRAINT DF_C1 DEFAULT (1),
	[Column2] [INT] NULL)
GO
ALTER TABLE TestTable8 ADD CONSTRAINT DF_C2 DEFAULT (2) FOR Column2
GO
ALTER TABLE TestTable7 DROP CONSTRAINT CK_TestTable7_C1 --Новое для меня. Удаление ограничений
GO
ALTER TABLE TestTable7 DROP CONSTRAINT CK_TestTable7_C2
GO
ALTER TABLE TestTable8 DROP CONSTRAINT DF_C1
GO
ALTER TABLE TestTable8 DROP CONSTRAINT DF_C2
GO
--Переменные
DECLARE @TestVar INT=10
SET @TestVar=10
SELECT @TestVar=10
SELECT @TestVar*5 AS [Результат]
GO
DECLARE @TestTable TABLE (ProductId INT IDENTITY(1,1) NOT NULL,
						  CategoryID INT NOT NULL,
						  ProductName VARCHAR(50) NOT NULL,
						  Price MONEY NULL)
INSERT INTO @TestTable --Объявление табличное переменной
	SELECT CategoryId, ProductName, Price 
	FROM TestTable
	WHERE ProductId<=3
SELECT * FROM @TestTable
GO
SELECT @@SERVERNAME [Имя локального сервера], --Новое для меня. Глобальные переменные
	   @@VERSION AS [Версия SQL сервера]
--Объявление переменных: количество и сумма
DECLARE @Cnt INT, @Сумма MONEY
SET @Cnt=10
SET @Сумма=150
/*Выполняем операцию умножения.
Пример многострочного комментария*/
SELECT @Cnt*@Сумма AS [Результат]
GO
DECLARE @TestVar1 INT
DECLARE @Testvar2 VARCHAR(20)
SET @TestVar1=5;
IF @TestVar1>0
	SET @Testvar2='Больше 0'
ELSE
	SET @Testvar2='Меньше 0'
SELECT @Testvar2 AS [Значение TestVar1]
GO
DECLARE @TestVar1 INT
DECLARE @TestVar2 VARCHAR(20)
SET @TestVar1=0
IF @TestVar1>0
	SET @TestVar2='Больше 0'
SELECT @TestVar2 AS [Значение TestVar1]
GO
DECLARE @TestVar1 INT
DECLARE @TestVar2 VARCHAR(20)
SET @TestVar1=-5
IF @TestVar1>0 OR @TestVar1=-5
	SET @TestVar2='Значение подходит'
SELECT @TestVar2 AS [Значение TestVar1]
GO
DECLARE @TestVar VARCHAR(20)
IF EXISTS(SELECT * FROM TestTable) --Новое для меня. IF EXISTS позволяет определить наличие записей в той или иной таблице
	SET @TestVar='Записи есть'
ELSE
	SET @TestVar='Записей нет'
SELECT @TestVar AS [Наличие записей]
GO
DECLARE @TestVar1 INT
DECLARE @TestVar2 VARCHAR(20)
SET @TestVar1=1
SELECT @TestVar2=CASE @TestVar1 WHEN 1 THEN 'Один'
							    WHEN 2 THEN 'Два'
								ELSE 'Неизвестное'
				 END
SELECT @TestVar2 AS [Число]
GO
DECLARE @TestVar1 INT
DECLARE @testVar2 VARCHAR(20), @Testvar3 VARCHAR(20)
SET @TestVar1 = 5;
IF @TestVar1 NOT IN (0,1,2)
BEGIN
 SET @TestVar2 = 'Первая инструкция'
 SET @TestVar3 = 'Вторая инструкция'
END
SELECT @TestVar2 AS [Значение TestVar1],
	   @TestVar3 AS [Значение TestVar2]
GO
DECLARE @CountAll INT=0
--Запускаем цикл
WHILE @CountAll<10
BEGIN
 SET @CountAll+=1
END
SELECT @CountAll AS [Результат]
GO
DECLARE @CountAll INT=0
--Запускаем цикл
WHILE @CountAll<10
BEGIN
 SET @CountAll+=1
 IF @CountAll=5
	BREAK
END
SELECT @CountAll AS [Результат]
GO
DECLARE @Cnt INT=0
DECLARE @CountAll INT=0
--Запускаем цикл
WHILE @CountAll<10
BEGIN
 SET @CountAll+=1
 IF @CountAll=5
	CONTINUE
 
 SET @Cnt+=1
END
SELECT @CountAll AS [CountAll],
	   @Cnt AS [Cnt]
GO
DECLARE @TestVar INT=1
IF @TestVar>0
	PRINT 'Значение переменной больше 0'
ELSE
	PRINT 'Значение переменной меньше или равно 0'
GO
DECLARE @TestVar INT=1
IF @TestVar<0
	RETURN --Новое для меня. Данную команду полезно использовать тогда, когда Вам в процессе выполнения определенной инструкции необходимо ее полностью прекратить
	       --в случае возникновения определенной ситуации
SELECT @TestVar AS [Результат]
GO
DECLARE @TestVar INT=0
МЕТКА: --Устанавливаем метку
SET @TestVar+=1 --Увеличиваем значение переменной
--Проверяем значение переменной
IF @TestVar<10
	--Если оно меньше 10, то возвращаемся назад к метке
	GOTO МЕТКА --Новое для меня. GOTO - команда осуществляет перевод выполнения инструкции в определенное место к определенной метке.
			   --Иными словами, если Вам вдруг нужно пропустить выполнение части инструкции или возвратиться назад к определенному участку кода,
			   --для того чтобы выполнить его еще раз, команда GOTO будет Вам полезна
--Здесь мы установили метку МЕТКА, и затем, когда нам нужно, мы осуществляли переход к этой метке с помощью команды GOTO.
--Т.е. мы проверяем значение переменной @TestVar и, если оно нас не устраивает, мы возвращаемся назад к метке, все, что после GOTO, не выполнятеся.
--Инструкция выполнилась только тогда, когда значение @TestVar нас устроило, и SELECT выполнился
SELECT @TestVar AS [Результат]
GO
DECLARE @TestVar INT=2
DECLARE @Rez INT=0
IF @TestVar<=0
	GOTO МЕТКА
SET @Rez=10 / @TestVar
МЕТКА:
SELECT @Rez AS [Результат]
GO
--Пауза на 5 секунд
WAITFOR DELAY '00:00:05' --Новое для меня. WAITFOR - чтобы поставить на паузу выполнение инстукции. DELAY - на заданный период времени
	SELECT 'Продолжение выполнение инструкции' AS [Test]
GO
--Паука до 10 часов
WAITFOR TIME '10:00:00' --Новое для меня. WAITFOR - чтобы поставить на паузу выполнение инстукции. TIME - остановка до указанного периода времени
	SELECT 'Продолжение выполнения инструкции' AS [Test]
GO
--Начало блока обрабоки ошибок
BEGIN TRY --Новое для меня. Блок TRY..CATCH
	--Инструкции, в которых могут возникнуть ошибки
	DECLARE @TestVar1 INT = 10,
			@TestVar2 INT=0,
			@Rez INT
	SET @Rez = @TestVar1/@TestVar2
END TRY
--Начало блока CATCH
BEGIN CATCH
  --Действия, которые будут выполняться в случае возникновения ошибки
  SELECT ERROR_NUMBER() AS [Номер ошибки], --Новое для меня. Встроенная функция для вывода номера ошибки
	     ERROR_MESSAGE() AS [Описание ошибки] ----Новое для меня. Встроенная функция для вывода описания ошибки
  SET @Rez=0
END CATCH
SELECT @Rez AS [Результат]
GO
--Функции в T-SQL
CREATE FUNCTION TestFunction --Новое для меня
	(
		@ProductId INT --Объявление входящих параметров
	)
RETURNS VARCHAR(100) --Тип вовзращаемого значения
AS
BEGIN
	--Объявление переменных внутри функции
	DECLARE @ProductName VARCHAR(100);

	--Получение наименования товара по его идентификатору
	SELECT @ProductName=ProductName
	FROM TestTable
	WHERE ProductId=@ProductId
	--Вовзращение результата
	RETURN @ProductName
END
GO
--Вызов функции. Получение наименования конкретного товара
SELECT dbo.TestFunction(1) AS [Наименование товара]
GO
--Вызов функции. Передача наименования конкретного товара
SELECT ProductId,
	   ProductName,
	   dbo.TestFunction(ProductId) AS [Наименование товара]
FROM TestTable
GO
CREATE FUNCTION FT_TestFunction --Новое для меня
(
	@CategotyId INT -- Объявление входящих параметров
)
RETURNS TABLE --Новое для меня
AS
RETURN(
	--Получение всех товаров в определенной категории
	SELECT ProductId,
		   ProductName,
		   CategoryId
	FROM TestTable
	WHERE CategoryId=@CategotyId
)
GO
--Пример обращения к табличной функции
SELECT * FROM FT_TestFunction(2)
GO
CREATE FUNCTION FT_TestFunction2
(
	--Объявление входящих параметров
	@CategoryId INT,
	@Price MONEY
)
--Определяем результирующую таблицу
RETURNS @TMPTable TABLE (ProductID INT, --Новое для меня
						 ProductName VARCHAR(100),
						 Price MONEY,
						 CategoryId INT)
AS
BEGIN
	--Если указана отрицательная цена, то задаем цену равной 0
	IF @Price<0
		SET @Price=0
	--Заполняем данными результирующую таблицу
	INSERT INTO @TMPTable
		SELECT ProductId,
			   ProductName,
			   Price,
			   CategoryId
		FROM TestTable
		WHERE CategoryId=@CategoryId AND Price<=@Price
	--Вовзращаем результат и прекращаем выполнение функции
	RETURN
END
GO
--Пример обращение к табличной функции
SELECT * FROM FT_TestFunction2(2,200)
GO
ALTER FUNCTION TestFunction --Новое для меня. Изменение функции
(
	@ProductId INT --Объявление входящих параметров
)
RETURNS VARCHAR(100) --Тип возвращаемого результатат
AS
BEGIN
	--Объявление переменных
	DECLARE @CategoryName VARCHAR(100);
	--Получение наименование категории товара по идентификатору товара
	SELECT @CategoryName=T2.CategoryName
	FROM TestTable T1
	INNER JOIN TestTable2 T2 ON T1.CategoryId=T2.CategoryId
	WHERE T1.ProductId=@ProductId
	--Вовзращение результата
	RETURN @CategoryName
END
GO
--Пример использования функции
SELECT ProductId,
	  ProductName,
	  dbo.TestFunction(ProductId) AS [CategoryName]
FROM TestTable
GO
DROP FUNCTION FT_TestFunction2 --Новое для меня. Удаление функции
GO
DECLARE @TestVar VARCHAR(100),
	    @TestVar2 VARCHAR(100)
--Присвоение значений с пробелами
SELECT @TestVar='         Teкст',
       @TestVar2='Текст         '
--Без использования функции
SELECT @TestVar AS TestVar,
	   @TestVar2 AS TestVar2
--С использованием функции
SELECT LTRIM(@TestVar) AS TestVar,
	   RTRIM(@TestVar2) AS TestVar2
GO
DECLARE @TestVar VARCHAR(100),
	    @TestVar2 VARCHAR(100)
--Присвоение значения
SELECT @TestVar='ТеКст',
	   @TestVar2='ТЕкст'
--Без использования функции
SELECT @TestVar AS TestVar,
	   @TestVar2 AS TestVar2
--С использованием функции
SELECT UPPER(@TestVar) AS TestVar,
	   LOWER(@TestVar2) AS TestVar2
GO
SELECT LEN('123456789') AS [Количество символов]
GO
DECLARE @TestVar VARCHAR(100),
	    @TestVar2 VARCHAR(100)
--Присвоение значений
SELECT @TestVar='1234567890',
	   @TestVar2='1234567890'
--Выводим первые и последние 5 символов
SELECT LEFT(@TestVar,5) AS TestVar,
	   RIGHT(@TestVar2,5) AS TestVar2
GO
DECLARE @TestVar VARCHAR(100)
--Присвоение значения
SELECT @TestVar='1234567890'
--Выводим 5 символов начиная с 3
SELECT SUBSTRING(@TestVar,3,5) AS TestVar
GO
DECLARE @TestDate DATETIME
SET @TestDate=GETDATE()
SELECT GETDATE() AS [Текущая дата],
	   DATENAME(M,@TestDate) AS [[Название месяца],
	   DATEPART(M,@TestDate) AS [[Номер месяца],
	   DAY(@TestDate) AS [День],
	   MONTH(@TestDate) AS [Месяц],
	   YEAR(@TestDate) AS [Год],
	   DATEDIFF(D,'01.01.2018',@TestDate) AS [Количество дней],
	   DATEADD(D,5,GETDATE()) AS [+ 5 Дней]
GO
SELECT ABS(-100) AS [ABS],
	   ROUND(1.567,2) AS [ROUND],
	   CEILING(1.6) AS [CEILING],
	   FLOOR(1.6) AS [FLOOR],
	   SQRT(16) AS [SQRT],
	   SQUARE(4) AS [SQUARE],
	   POWER(4,2) AS [POWER],
	   LOG(10) AS [LOG]
GO
SELECT DB_ID() AS [Идентификатор текущей БД], --Новое для меня
	   DB_NAME() AS [Имя текущей БД], --Новое для меня
	   OBJECT_ID('TestTable') AS [Идентификатор таблицы TestTable], --Новое для меня
	   OBJECT_NAME(149575571) AS [Имя объекта с ИД 149575571] --Новое для меня
GO
SELECT ISNULL(NULL,5) AS [ISNULL],
	   COALESCE(NULL,NULL,5) AS [COALESCE],
	   CAST(1.5 AS INT) AS [CAST],
	   HOST_NAME() AS [HOST_NAME],
	   SUSER_SNAME() AS [SUSER_SNAME],
	   USER_NAME() AS [USER_NAME]
GO
--Хранимые процедуры
--Создаем процедуру
CREATE PROCEDURE TestProcedure
(
	@CategoryId INT,
	@ProductName VARCHAR(100)
)
AS
BEGIN
	--Объявляем переменную
	DECLARE @AVG_Price MONEY
	--Определяем среднюю цену в категории
	SELECT @AVG_Price=ROUND(AVG(Price),2)
	FROM TestTable
	WHERE CategoryId=@CategoryId;
	--Добавляем новуб запись
	INSERT INTO TestTable(CategoryId, ProductName, Price)
		VALUES(@CategoryId, LTRIM(RTRIM(@ProductName)), @AVG_Price);
	--Вовзращаем данные
	SELECT * FROM TestTable
	WHERE CategoryId=@CategoryId
END
GO
--Вызываем процедуру
EXEC TestProcedure @CategoryId=1,
				   @ProductName='Тестовый товар'
GO
EXECUTE TestProcedure 1,'Тестовый товар2'
GO
--Изменяем процедуру
ALTER PROCEDURE TestProcedure
(
	@CategoryId INT,
	@ProductName VARCHAR(100),
	@Price MONEY=NULL
)
AS
BEGIN
	--Если цену не передали, то определяем среднюю цену
	IF @Price IS NULL
		SELECT @Price=ROUND(AVG(Price),2)
		FROM TestTable
		WHERE CategoryId=@CategoryId
	--Добавляем новую запись
	INSERT INTO TestTable(CategoryId, ProductName, Price)
		VALUES (@CategoryId, LTRIM(RTRIM(@ProductName)),@Price)
	--Вовзращаем данные
	SELECT * FROM TestTable
	WHERE CategoryId=@CategoryId
END
GO
--Вызываем процедуру
EXECUTE TestProcedure @CategoryId=1,
					  @ProductName='Тестовый товар 3',
					  @Price=100
GO
EXEC sp_helpdb 'TestDB' --Новое для меня. Получение информации о базу данных
GO
EXEC sp_tables @table_type="'TABLE'" --Новое для меня. Получение информации  о таблицах БД.
								    --Если передать VIEW вместо TABLE, то вернет информацию в представлениях
GO
EXEC sp_rename TestTable_OldName, TestTable_NewName --Новое для меня. Переименовываем таблице TestTable_OldName.
													--И задаем ей новое имя TestTable_NewName
GO
--Триггеры
/*FOR или ALTER - триггер запускается после успешного выполнения инструкции, которая запускает триггер (при разработке триггера можно использовать и
ключевое слово FOR, и ключевое слово ALTER, они эквивалентны, т.е. триггер FOR аналогичен триггеру AFTER)
INSTEAD OF - в данном случае триггер запускается вместо инструкции, которая запускает триггер, тем самым переопределяя ее действие*/

/*В таблице inserted добавляются строки во время операций INSERT и UPDATE, если со вставкой понятно (т.е. там будут копии добавленных записей),
то во время овновления такм будут строки с новыми значениями, на которые мы обновляем*/
/*В таблице deleted добавляются строки во время операций DELETE и UPDATE, при удалении туда попадают удаленные строки, при обновлении - исходные
значения строк до непосредственного обновления*/
/*Иными словами, уже после выполненных операций по изменению данных, мы можем в триггере получить доступ и, соответственно, использовать значения, которые были в таблице до
внесения этих изменений*/
CREATE TABLE AutitTestTable(
	Id INT IDENTITY(1,1) NOT NULL,
	DtChange DATETIME NOT NULL,
	UserName VARCHAR(100) NOT NULL,
	SQL_Command VARCHAR(100) NOT NULL,
	ProductId_Old INT NULL,
	ProductId_New INT NULL,
	CategoryId_Old INT NULL,
	CategoryId_New INT NULL,
	ProductName_Old VARCHAR(100) NULL,
	ProductName_New VARCHAR(100) NULL,
	Price_Old MONEY NULL,
	Price_New MONEY NULL,
CONSTRAINT PK_AutitTestTable PRIMARY KEY(id))
GO
CREATE TRIGGER TGR_Audit_TestTable ON TestTable --Новое для меня.
	AFTER INSERT, UPDATE, DELETE --Новое для меня. Указали, на какое событие должен срабатывать триггер.
AS
BEGIN
	DECLARE @SQL_Command VARCHAR(100);
	/*
	Определяем, что это за операция
	на основе наличия записей в таблицах inserted и deleted.
	На практике, конечно же, лучше делать отдельный триггер для каждой операции*/
	IF EXISTS(SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted)
		SET @SQL_Command='INSERT'
	IF EXISTS(SELECT * FROM inserted) AND EXISTS(SELECT * FROM deleted)
		SET @SQL_Command='UPDATE'
	IF NOT EXISTS(SELECT * FROM inserted) AND EXISTS(SELECT * FROM deleted)
		SET @SQL_Command='DELETE'
	--Инструкция, если происходит добавление или обновление записи
	IF @SQL_Command='UPDATE' OR @SQL_Command='INSERT'
	BEGIN
		INSERT INTO AutitTestTable(DtChange, UserName, SQL_Command, ProductId_Old,
								   ProductId_New, CategoryId_Old, CategoryId_New,
								   ProductName_Old, ProductName_New, Price_Old, Price_New)
		SELECT GETDATE(), SUSER_NAME(), @SQL_Command, D.ProductId, I.ProductId,
			   D.CategoryId, I.CategoryId, D.ProductName, I.ProductName, D.Price, I.Price
		FROM inserted I
		LEFT JOIN deleted D ON I.ProductId=d.ProductId
	END
	--Инструкция если происходит удаление записи
	IF @SQL_Command='DELETE'
	BEGIN
		INSERT INTO AutitTestTable(DtChange, UserName, SQL_Command, ProductId_Old,
								   ProductId_New, CategoryId_Old, CategoryId_New,
								   ProductName_Old, ProductName_New, Price_Old, Price_New)
		SELECT GETDATE(), SUSER_NAME(), @SQL_Command,
				   D.ProductId, NULL,
				   D.CategoryId, NULL,
				   D.ProductName, NULL,
				   D.Price, NULL
		FROM deleted D
	END
END
GO
--Добавляем запись
INSERT INTO TestTable
	VALUES (1,'Новый товар',0)
GO
--Изменяем запись
UPDATE TestTable SET ProductName='Наименование товара',
					 Price=200
WHERE ProductName='Новый товар'
GO
--Удаляем запись
DELETE TestTable WHERE ProductName='Наименование товара'
GO
--Смотрим изменения
SELECT * FROM AutitTestTable
GO
DISABLE TRIGGER TGR_Audit_TestTable ON TestTable;--Новое для меня. Отключение триггера
GO
ENABLE TRIGGER TGR_Audit_TestTable ON TestTable; --Новое для меня. Включение триггера
GO
ALTER TRIGGER TGR_Audit_TestTable ON TestTable
	AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	DECLARE @SQL_Command VARCHAR(100);
	/*
	Определяем, что это за операция
	на основе наличия записей в таблицах inserted и deleted.
	На практике, конечно же, лучше делать отдельных триггер для каждой операции
	*/
	IF EXISTS(SELECT * FROM inserted) AND EXISTS(SELECT * FROM deleted)
		SET @SQL_Command='UPDATE'
	ELSE
		SET @SQL_Command='INSERT'
	INSERT INTO AutitTestTable(DtChange, UserName, SQL_Command, ProductId_Old,
								   ProductId_New, CategoryId_Old, CategoryId_New,
								   ProductName_Old, ProductName_New, Price_Old, Price_New)
	SELECT GETDATE(),SUSER_NAME(),@SQL_Command,
			D.ProductId, I.ProductId,
			D.CategoryId, I.CategoryId,
			D.ProductName, I.ProductName,
			D.Price, I.Price
	FROM inserted I
	LEFT JOIN deleted D ON I.ProductId=D.ProductId
END
GO
DROP TRIGGER TGR_Audit_TestTable --Новое для меня. Удаление триггера
GO
--Курсоры
--1. Объявление переменных --Новое для меня
DECLARE @ProductId INT,
		@ProductName VARCHAR(100),
		@Price MONEY
--2. Объявление курсора --Новое для меня
DECLARE TestCursor CURSOR FOR
	SELECT ProductId, ProductName, Price
	FROM TestTable
	WHERE CategoryId=1
--3. Открываем курсор --Новое для меня
OPEN TestCursor
--4. Считываем данные из первой строки в курсоре
--и записываем из в переменные
FETCH NEXT FROM TestCursor INTO @ProductId, @ProductName, @Price
--Запускаем цикл, выйдем из него, когда закончатся строки в курсоре
WHILE @@FETCH_STATUS=0 --Новое для меня
BEGIN
 --На каждую итерацию цикла выполняем необходимые нам SQL инструкции
 --Для примера изменяем цену по условию
 IF @Price<100
	UPDATE TestTable SET Price+=10
	WHERE ProductId=@ProductId
	--Считываем следующую строку курсора
	FETCH NEXT FROM TestCursor INTO @ProductId, @ProductName, @Price
END
--5. Закрываем курсов
CLOSE TestCursor
--Освобождаем ресурсы
DEALLOCATE TestCursor --Новое для меня
GO
--Транзакции
BEGIN TRY
--Начало транзакции
BEGIN TRANSACTION --Новое для меня
	--Инструкция 1
	UPDATE TestTable SET CategoryId=2
	WHERE ProductId=1
	--Инструкция 2
	UPDATE TestTable SET CategoryId=NULL
	WHERE ProductId=2
	--...Другие инструкции
END TRY
	BEGIN CATCH
		--В случае непредвиденной лшибки
		--Откат транзакции
		ROLLBACK TRANSACTION

		--Выводим сообщение об ошибке
		SELECT ERROR_NUMBER() AS [Номер ошибки],
			   ERROR_MESSAGE() AS [Описание ошибки]

		--Прекращаем выполнение инструкции
		RETURN;
	END CATCH;
--Если все хорошо. Созраняем все изменения
COMMIT TRANSACTION --Новое для меня
GO
ALTER DATABASE TestDB SET ALLOW_SNAPSHOT_ISOLATION ON; --Новое для меня. Включение уровня транзакции SNAPSHOT
--XML
CREATE TABLE TestTableXML(
	Id INT IDENTITY(1,1) NOT NULL,
	NameColumn VARCHAR(100) NOT NULL,
	XMLData XML NULL
 CONSTRAINT PK_TestTableXML PRIMARY KEY (Id)
)
GO
INSERT INTO TestTableXML (NameColumn, XMLData)
	   VALUES('Текст','<Catalog>
					    <Name>Иван</Name>
						<LastName>Иванов</LastName>
					   </Catalog>')
GO
SELECT * FROM TestTableXML
GO
--Новое для меня. Метод query делает выборку в самом XML документа, который хранится в столбце с типом XML.
--Метод принимает один параметр, запрос к xml документу, т.е. что именно Вы хотите получить их XML
SELECT XMLData.query('/Catalog/Name') AS [Тег Name]
FROM TestTableXML
GO
--Новое для меня. Метод value возвращает значение узла. Данный метод утобно использовать, когда Вам нужно в своих SQL
--инструкциях использовать определенное значение, извлеченное их XML документа. Метод имеет два параметра, первыйм - это откуда брать
--значение, а второй - какой тип Вы при этом хотите получить на выходе.
SELECT XMLData, XMLData.value('/Catalog[1]/LastName[1]','VARCHAR(100)') AS [LastName]
FROM TestTableXML
GO
--Новое для меня. Метод exist используется для того, чтобы проверять наличие тех или иных значений, атрибутов или элементов в XML документе.
--Метод возвращает значения типа bit, такие как: 1 - если выражение на языке XQuery при запросе возвращает непустой результат, 0 - если возвращается
--пустой результат, NULL - если данные типа XML, к которым идет обращение, не содержат никаких данные, т.е. NULL.
--Например, чтобы вывести все строки в XML данных, в которых есть элемент LastName, можно написать запрос.
SELECT *
FROM TestTableXML
WHERE XMLData.exist('/Catalog[1]/LastName')=1
GO
--Новое для меня. Modify - это метод ихменяет XML данные. Его можно использовать только в инструкции UPDATE, в качестве
--параметра принимает новое значение, это инструкции по изменению XML документа
--Например, удаление элемента. Сейчас мы удалим элемент LastName
UPDATE TestTableXML SET XMLData.modify('delete /Catalog/LastName')
GO
SELECT * FROM TestTableXML
GO
--Новое для меня. Добавление элемента. В данном случае мы добавим элемент LastName
UPDATE TestTableXML SET XMLData.modify('insert <LastName>Иванов</LastName> as last into (/Catalog)[1] ')
GO
SELECT * FROM TestTableXML
GO
--Новое для меня.Изменение значения в узле. В этом примере мы измененим значение узла Name на "Сергей"
UPDATE TestTableXML
SET XMLData.modify('replace value of(/Catalog/Name[1]/text())[1] with "Сергей" ')
GO 
SELECT * FROM TestTableXML
GO
--Новое для меня.
/*nodes() - метод используется для получения реляционных данных из конкретного XML документа.
В данном случае мотод nodes сформировал таблицу TMP и столбец Col для пути '/Root/row' в XML данных.
Каждый элемент row здесь отдельная строка, методом value мы извлекаем значения атрибутов.
*/
DECLARE @XML_Doc XML;
SET @XML_Doc='<Root>
			   <row id="1" Name="Иван"></row>
			   <row id="2" Name="Сергей"></row>
			  </Root>'
SELECT TMP.Col.value('@id','INT') AS id,
	   TMP.Col.value('@Name','VARCHAR(100)') AS Name
FROM @XML_Doc.nodes('/Root/row') TMP(Col);
GO
--Новое для меня.
/*FOR XML - формирование данных на основе SQL-запроса. Директивы (режимы):
1) RAW - в данном случае в XML документе создается одиночный элемент <row> для каждой строки результирующего набора
   данных инструкции SELECT
2) AUTO - в данном режиме структура XML документа создается автоматически, в зависимости от инструкции SELECT (объединений, вложенных
   запросов и так далее)
3) EXPLICIT - режим, при котром Вы сами формируете структуру итогового XML документа, это самый расширенный режим работы конструкции FOR XML и,
   в тоже время, самый трудоемкий
4) PATH - это своего рода упрощенный режим EXPLICIT, который хорошо справляется с множеством задач по формированию XML документов, включая формирование атрибутов
   для элементов. Если Вам нужно самим сформировать структуру XML данных, то рекомендовано использовать именно этот режим
Сейчас давайте рассмотрим несколько полезных параметров конструкции FOR XML
1) TYPE - возвращает сформированные XML данные с типом XML, если параметр TYPE не указан, данные вовзращаются с типом nvarchar(max). Параметр необходим в тех случаях,
   когда над итоговыми XML данными будут проводиться операции, характерные для XML данных, например, выполнение инструкций на языке XQuery.
2) ELEMENTS - если указать данный параметр, столбцы возвращаются в виде вложенных элементов;
3) ROOT - параметр добавляет в результирующему XML-документу один элемент верхнего уровня (корневой элемент), по умолчанию "root",
   однако название можно указать произвольное
*/
--Пример 1
SELECT ProductId, ProductName, Price
FROM TestTable
ORDER BY ProductId
FOR XML RAW, TYPE
GO
--Пример 2
SELECT ProductId, ProductName, Price
FROM TestTable
ORDER BY ProductId
FOR XML RAW ('Product'), TYPE, ELEMENTS, ROOT('Products')
GO
--Пример 3
SELECT TestTable.ProductId, TestTable.ProductName,
	   TestTable2.CategoryName, TestTable.Price
FROM TestTable
LEFT JOIN TestTable2 ON TestTable.CategoryId=TestTable2.CategoryId
ORDER BY TestTable.ProductId
FOR XML AUTO, TYPE
GO
--Пример 4
SELECT TestTable.ProductId, TestTable.ProductName,
	   TestTable2.CategoryName, TestTable.Price
FROM TestTable
LEFT JOIN TestTable2 ON TestTable.CategoryId=TestTable2.CategoryId
ORDER BY TestTable.ProductId
FOR XML AUTO, TYPE, ELEMENTS
GO
--Пример 5
SELECT ProductId AS "@id",ProductName, Price
FROM TestTable
ORDER BY ProductId
FOR XML PATH('Product'), TYPE, ROOT ('Products')
GO
DECLARE @XML_Doc XML;
DECLARE @XML_Doc_Handle INT;
--Формируем XML документ
SET @XML_Doc=(
				SELECT ProductId AS "@Id", ProductName, Price
				FROM TestTable
				ORDER BY ProductId
				FOR XML PATH ('Product'), TYPE, ROOT ('Products')
			  );
--Подготавливаем XML-документ
EXEC sp_xml_preparedocument @XML_Doc_Handle OUTPUT, @XML_Doc; --Новое для меня. Проводим синтаксический анализ XML данных и возвращает дескриптор XML документа,
															  --который мы передаем в функцию OPENXML для извлечения данных. По русски говоря это подготовка документа
--Извлекаем данные из XML документа
SELECT *
FROM OPENXML(@XML_Doc_Handle,'/Products/Product',2) --Новое для меня. Первый параметр - это дескриптор XML документа
													--Второй - шаблон на языке XPath, используемый для идентификации узлов, которые будут обрабатываться как строки
													--Третий тип сопоставления между XML данными и реляционными, например, 0 - значение по умолчанию, используется артибутивная модель сопоставления,
													--1 - использовать артибутивную модель сопоставления, 2 - использовать сопоставление с использованием элементов	
WITH (
		ProductId INT '@Id', --Новое для меня. @Id - чтобы извлечь атрибут.
		ProductName VARCHAR(100),
		Price MONEY
	);
--Удаляем дескриптор XML документа
EXEC sp_xml_removedocument @XML_Doc_Handle; --Новое для меня. После отработки OPENXML удаляем дексриптор документа
GO
--CTE
--Пишет CTE с названием TestCTE
WITH TestCTE (ProductId, ProductName, Price) AS
	(
		--Запрос, которые вовзращает опередленные логичные данные
		SELECT ProductId, ProductName, Price
		FROM TestTable
		WHERE CategoryId=1
	)
--Запрос, в которм мы может импользоватьб CTE
SELECT * FROM TestCTE
GO
--Пишем CTE с названием TestCTE
WITH TestCTE AS
	(
		--Запрос, который возвращает определенные логичные данные
		SELECT ProductId, ProductName, Price
		FROM TestTable
		WHERE CategoryId=1
	)
--Запрос, в которм мы можем использовать CTE
SELECT * FROM TestCTE
GO
WITH TestCTE1 AS --Первый запрос
	(
		--Представьте, что здесь запрос со своей сложной логикой
		SELECT ProductId, CategoryId, ProductName, Price
		FROM TestTable
	), TestCTE2 AS --Второй запрос
	(
		--Здест также сложный запрос
		SELECT  CategoryId, CategoryName
		FROM TestTable2
	)
--Работаем с результирующими наборами двух запросов
SELECT T1.ProductName, T2.CategoryName, T1.Price
FROM TestCTE1 T1
LEFT JOIN TestCTE2 T2 ON t1.CategoryId=T2.CategoryId
WHERE T1.CategoryId=1
GO
SELECT T1.ProductName, T2.CategoryName, T1.Price
FROM (SELECT ProductId, CategoryId, ProductName, Price
	 FROM TestTable) T1
LEFT JOIN (SELECT CategoryId, CategoryName
		  FROM TestTable2) T2 ON T1.CategoryId=T2.CategoryId
WHERE T1.CategoryId=1
GO
--SELECT INTO
SELECT T1.ProductName, T2.CategoryName, T1.Price
INTO TestTableDop --Новое для меня INTO - создание таблиц на основе результирующих данных
FROM TestTable T1
LEFT JOIN TestTable2 T2 ON T1.CategoryId=T2.CategoryId
WHERE T1.CategoryId=1
GO
--Оконные агрегатные функции
SELECT ProductId, ProductName, CategoryId, Price,
	   SUM(Price) OVER (PARTITION BY CategoryId) AS [SUM], --Новое для меня. Вычисляют значения в определенном окне (наборе данных) для каждой текущей cтроки. 
															--GROUP BY использовать нет нужно.
	   AVG(Price) OVER (PARTITION BY CategoryId) AS [AVG], --Новое для меня
	   COUNT(Price) OVER (PARTITION BY CategoryId) AS [COUNT], --Новое для меня
	   MIN(Price) OVER (PARTITION BY CategoryId) AS [MIN], --Новое для меня
	   MAX(Price) OVER (PARTITION BY CategoryId) AS [MAX] --Новое для меня
FROM TestTable
GO
--Ранжирующие оконные функции
--Новое для меня. ROW_NUMBER - функция нумерации строк в секции результирующего набора данных, которая возвращает просто номер строки
SELECT ROW_NUMBER() OVER (PARTITION BY CategoryId ORDER BY ProductID) AS [ROW_NUMBER],* 
FROM TestTable
GO
--Новое для меня. RANK - ранжируюшая функция, которая возвращает ранг для каждой строки. В случае если в столбце,
--по которому происходит сортировка, есть одинаковые значения, для них возвращается также одинаковый ранг (следующие значения ранга в этом случае пропускается)
SELECT RANK() OVER (PARTITION BY CategoryId ORDER BY Price) AS [RANK],*
FROM TestTable
GO
--Новое для меня. DENSE_RANK  - ранжирующая функция, которая возвращает ранг каждой строки, но в отличие от RANK в случае  нахождения
--одинаковых значений возвращает ранг без пропуска следующего
SELECT DENSE_RANK() OVER (PARTITION BY CategoryId ORDER BY Price) AS [DENSE_RANK],*
FROM TestTable
GO
--Новое для меня. NTILE - ранжирующая оконная функция, которая делит результирующий набор на группы по
--определенному столбцу. Количество групп передается в качестве параметра. В случае если в группах получается
--не одинаковое количество строк, то в самой первой группе будет наибольшее количество, например, в случае если в 
--источнике 10 строк, при этом мы поделим результирующий набор на три группы, то в первой будет 4 строки, а во второй и трерьей по 3
SELECT NTILE (3) OVER (ORDER BY ProductId) AS [NTILE],*
FROM TestTable
GO
--Оконные функции смещения
--Новое для меня.
--1. LEAD - функция обращается к данным из слудующей строки набора данных. Её можно использовать, например, для того чтобы сравнить
--текущее значение строки со следующим. Имеет три параметра: столбец, значение которого необходимо вернуть (обязательный параметр),
--количество строк для смещения (по умолчанию 1), значение, которое необходимо вернуть, если после смещения возвращается значение NULL.
--2. LAG - функция обращается к данным из предыдущей строки набора данных. В данном случае функцию можно использовать для того, чтобы сравнитьэ
--текузее значение строки с предыдущим. Имеет три параметра: столбец, значение, которого необходимо вернуть (обязательный параметр), количество строк для смещения
--(по умолчанию 1), значение которое необходимо вернуть, если после смещения возвращается значение NULL
--3. FIRST_VALUE - функция возвращает первое значение из набора данных, в качестве параметра принимает столбец, значение которого необходимо вернуть.
--4. LAST_VALUE - функция возвращает последнее значение из набора данных, в качестве параметра принимает столбец, значение которого необходтимо вернуть.
SELECT ProductId, ProductName, CategoryId, Price,
	   LEAD(ProductId) OVER (PARTITION BY CategoryId ORDER BY ProductId) AS [LEAD],
	   LAG(ProductId) OVER (PARTITION BY CategoryId ORDER BY ProductId) AS [LAG],
	   FIRST_VALUE(ProductId) OVER (PARTITION BY CategoryId
								    ORDER BY ProductId
									ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS [FIRST_VALUE],
	   LAST_VALUE(ProductId) OVER (PARTITION BY CategoryId
								   ORDER BY ProductId
								   ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS [LAST_VALUE],
	   LEAD(ProductId,2) OVER (ORDER BY ProductId) AS [LEAD_2],
	   LAG(ProductId,2,0) OVER (ORDER BY ProductId) AS [LAG_2]
FROM TestTable
ORDER BY ProductId
/*Данный запрос возвращает следующее [LEAD] и предыдущее [LAG] значение идентификатора товара в категории относительно текущей строки. Чтобы функции
--работали для каждой категории, мы указали инструкцию PARTITION BY CategoryId, инструкцией ORDER BY ProductId мы сотрируем строки в окне по идентификатору.
Также запрос возвращает первое [FIRST_VALUE] и последнее [LAST_VALUE] значение идентификатора товара в категории, при этом в качестве примера я показал, как используется
--синтаксис дополнительного ограничения строки (ROWS)
Чтобы показать, как смещаться на несколько строк в запросе, я дополнительно вызвал функции LEAD и LAG, только уже с передачей необязательных параметров. Таким образом,
в столбце [LEAD_2] происходит смещение на 2 строки вперед, а в столбце [LAG_2] на 2 строки назад, при этом в данном столбце будет выводиться 0,
если после смещения нужной строки не окажется, для этого был указан третитй необязательный параметр со значением 0*/
GO
--Аналитические оконные функции
--Новое для меня.
--1. CUME_DIST - вычисляет и возвращает интегральное распределение значений в наборе данных. Иными словами, она определяет
--относительное положение значения в наборе;
--2. PERCENT_RANK - вычисляет и возвращает относительный ранг строки в наборе данных;
--3. PERCENTILE_COUNT - вычисляет процентиль на основе постоянного распределения значения столбца. В качестве параметра принимает процентиль,
--который необходимо вычислить;
--4. PERCENTILE_DISC - вычисляет определенный процентиль для отсортированных значений в наборе данных. В качестве параметра принимает процентиль,
--который необходимо вычислить.
--У функций PERCENTILE_COUNT и PERCENTILE_DISC синтаксис немого отличается, столбец, по которому сортировать данные, указывается с помощью ключевого стола WITHIN GROUP
SELECT ProductId, ProductName, CategoryId, Price,
	   CUME_DIST() OVER (PARTITION BY CategoryId ORDER BY Price) AS [CUME_DIST],
	   PERCENT_RANK() OVER (PARTITION BY CategoryId ORDER BY Price) AS [PERCENT_RANK],
	   PERCENTILE_DISC(0.5) WITHIN GROUP(ORDER BY ProductId) OVER (PARTITION BY CategoryId) AS [PERCENTILE_DISC],
	   PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY ProductId) OVER(PARTITION BY CategoryId) AS [PERCENTILE_COUNT]
FROM TestTable
GO
--PIVOT и UNPIVOT
--Обычная группировка
SELECT T2.CategoryName, AVG(T1.Price) AS AvgPrice
FROM TestTable T1
LEFT JOIN TestTable2 T2 ON T1.CategoryId=T2.CategoryId
GROUP BY T2.CategoryName
--Новое для меня. Группировка и использованием PIVOT
--PIVOT - это оператор языка T-SQL, который поворачивает результирующий набор данных, преобразуя уникальные значения одного столбца в несколько столбцов
SELECT 'Средняя цена' AS AvgPrice, [Комплектующие компьютера], [Мобильные устройства]
FROM (SELECT T1.Price, T2.CategoryName
	  FROM TestTable T1
	  LEFT JOIN TestTable2 T2 ON T1.CategoryId=T2.CategoryId) AS SourceTable
PIVOT (AVG(Price) FOR CategoryName IN ([Комплектующие компьютера],[Мобильные устройства])) AS PivotTable;
GO
--Создаем временную таблицу с помощью SELECT INTO
SELECT 'Город' AS NamePair,
		'Москва' AS Column1,
		'Калуга' AS Column2,
		'Тамбов' AS Column3
INTO #TestInpivot
--Смотрим, что получилось
SELECT * FROM #TestInpivot
--Применяя оператор UNPIVOT
--Новое для меня. UNPIVOT преобразовывает столбцы итогового набора данных в значения одного столбца
SELECT NamePair, ColumnName, CityNameValue
FROM #TestInpivot
UNPIVOT(CityNameValue FOR ColumnName IN ([Column1],[Column2],[Column3])) AS UnpivotTable
GO
DROP TABLE #TestInpivot
--Аналитические операторы ROLLUP, CUBE и  GROUPING SETS
--Без использования ROLLUP
SELECT CategoryId, SUM(Price) AS Summa
FROM TestTable
GROUP BY CategoryId
GO
--С использованием ROLLUP
--Новое для меня. ROLLUP - оператор, который формирует промежуточные итоги для каждого указанного элемента и общий итог
SELECT CategoryId, SUM(Price) AS Summa
FROM TestTable
GROUP BY
ROLLUP (CategoryId)
GO
--С использованием ROLLUP
SELECT ProductName, CategoryId, SUM(Price) AS Summa
FROM TestTable
GROUP BY
ROLLUP (CategoryId, ProductName)
GO
--С использованием CUBE
--Новое для меня. CUBE - оператор, который формирует результаты для всех возможных перекрестных вичислений. Отличие от ROLLUP состоит в том, что, если мы
--укажем несколько столбцов для группировки, ROLLUP выведет строки подытогов высокого уровня, т.е. для каждого уникального сочетания перечисленных столбцов,
--CUBE выведет подытоги для всех возможных сочетаний этих столбцов.
SELECT ProductName, CategoryId, SUM(Price) AS Summa
FROM TestTable
GROUP BY
CUBE (CategoryId, ProductName)
GO
--GROUPING SETS
--С использованием GROUPING SETS
--Новое для меня. GROUPING SETS - оператор, который формирует результаты нескольких группировок в один набор данных, другими словами,
--в результирующий набор попадают только строки по группировкам. Данный оператор эквивалентен конструкции UNION ALL, если в нем указать запросы
--просто с GROUP BY по каждому указанному столбцу
SELECT ProductName, CategoryId, SUM(Price) AS Summa
FROM TestTable
GROUP BY
GROUPING SETS (CategoryId,ProductName)
GO
--С использованием UNION ALL
SELECT ProductName, NULL AS CategoryId, SUM(Price) AS Summa
FROM TestTable
GROUP BY ProductName
UNION ALL
SELECT NULL AS ProductName, CategoryId, SUM(Price) AS Summa
FROM TestTable
GROUP BY CategoryId
GO
--Оператор APPLY
--Новое для меня
--CROSS APPLY - возвращает только строки из внешней таблицы, которые создает табличная функция;
--OUTER APPLY - возвращает и стоки, который формирует табличная функция, и строки со значениями NULL в столбцах, созданные табличной функцией. Например,
--табличная функция может не возвращать никаких данных для определенных значений, CROSS APPLY в таких случаях подобные строки не выводит, а OUTER APPLY
--выводит.
SELECT T2.CategoryName, FT1.*
FROM TestTable2 T2
CROSS APPLY FT_TestFunction(T2.CategoryId) AS FT1
GO
--Добавление новой строки в таблицу TestTable2
INSERT INTO TestTable2
	VALUES ('Новая категория')
GO
SELECT T2.CategoryName, FT1.*
FROM TestTable2 T2
OUTER APPLY FT_TestFunction(T2.CategoryId) AS FT1
GO
--Получение данных из внешних источников, функции OPENDATASOURCE, OPENROWSET и OPENQUERY
--Новое для меня. Включение возможности использования распределенных запросов на сервере.
/*sp_configure 'show advanced options',1;
RECONFIGURE
GO
sp_configure 'Ad Hoc Distributed Queries',1
RECONFIGURE
GO*/
--С помощью OPENDATASOURCE
--Новое для меня. OPENDATASOURCE - функция возвращает ссылку на источник данных, который может использоваться как часть четырехсоставного имени объекта
SELECT * FROM OPENDATASOURCE('Microsoft.Jet.OLEDB.4.0','Data Source=D:\TestExcel.xls;Extended Properties=Excel 8.0')...[Лист1$]
--С помощью OPENROWSET
--Новое для меня. OPENROWSET - подключается к источнику данных и выполняет необходимый запрос
SELECT * FROM OPENROWSET('Microsoft.Jet.OLEDB.4.0','Excel 8.0;Database=D:\TestExcel.xls',[Лист1$]);
GO
--С помощью OPENROWSET (с запросом)
SELECT * FROM OPENROWSET('Microsoft.Jet.OLEDB.4.0','Excel 8.0; Database=D:\TestExcel.xls','SELECT ProductName, Price FROM [Лист1$]')
--Новое для меня
--Создание связанного сервера
/*EXEC dbo.sp_addlinkedserver @server='TEST_EXCEL',
							@srvproduct='OLE DB',
							@provider='Microsoft.Jet.OLEDB.4.0',
							@datasrc='D:\TestExcel.xls',
							@provstr='Excel 8.0'
--Настройка безопасности (авторизации)
EXEC dbo.sp_addlinkedsrvlogin @rmtsrvname='TEST_EXCEL',
							  @useself='False',
							  @locallogin=NULL,
							  @rmtuser=NULL,
							  @rmtpassword=NULL*/
--Обращение к связанному серверу
SELECT * FROM Test_EXCEL...[Лист1$]
--Или с помощью OPENQUERY (рекомендуется)
--Новое для меня. OPENQUERY - функция обращается к связанному серверу и выполняет указанный запрос. На эту функцию можно
--даже ссылаться в инструкциях по модификации данных, т.е. мы можем изменять данные на связанном сервере
SELECT * FROM OPENQUERY (TEST_EXCEL, 'SELECT * FROM [Лист$]')
--Удаление связанного сервера
EXEC sp_dropserver 'TEST_EXCEL','droplogins'
--Выполнение динамических T-SQL инструкций
--Новое для меня
--Объявляем переменные
DECLARE @SQL_QUERY VARCHAR(200),
		@Var1 INT;
--Присваиваем значение переменным
SET @Var1=1;
--Формируем SQL инструкцию
SET @SQL_QUERY='SELECT * FROM TestTable WHERE ProductID = '+CAST(@Var1 AS VARCHAR(10));
--Смотрим на итоговую строку
SELECT @SQL_QUERY AS [TEXT QUERY]
--Выполняем текстовую строку как SQL инструкцию
EXEC (@SQL_QUERY)
GO
--Пример с использованием хранимой процедуры sp_executesql
--Новое для меня
--Объявляем переменые
DECLARE @SQL_QUERY NVARCHAR(200);
--Формируем SQL инструкцию
SELECT @SQL_QUERY=N'SELECT * FROM TestTable WHERE ProductID = @Var1;';
--Смотрим на итоговую строку
SELECT @SQL_QUERY AS [TEXT QUERY]
--Выполняем текстовую строку как SQL инструкцию
EXEC sp_executesql @SQL_QUERY, --Текст SQL инструкции
				   N'@Var1 AS INT', --Объявление переменных в процедуре
				   @Var1 = 1 --Передаем значение для переменных
GO
--Администрирование БД
--Создание имени входа --Новое для меня
CREATE LOGIN [TestLogin] WITH PASSWORD='Pa$$wOrd',
							  DEFAULT_DATABASE=[TestDB]
GO
--Назначение роль сервера. --Новое для меня
EXEC sp_addsrvrolemember @loginame='TestLogin',
						    @rolename='sysadmin'
GO
--Создание пользователя базы данных и сопоставление с именем входа --Новое для меня
CREATE USER [TestUser] FOR LOGIN [TestLogin]
GO
--Назначение пользователю роли базы данных (права доступа к объектам) --Новое для меня
EXEC sp_addrolemember 'db_owner','TestUser'
GO
--Включение режима чтения для базы данных --Новое для меня
ALTER DATABASE [TestDB] SET READ_ONLY
GO
--Включить обратно возможность изменять данные --Новое для меня
ALTER DATABASE [TestDB] SET READ_WRITE
GO
--Создание архива базы данных --Новое для меня
BACKUP DATABASE [TestDB]
		TO DISK='D:\BACKUP_DB\TestDB.bak'
		WITH NAME=N'База данных TestDB',
		STATS=10
GO
--Восстановление базы данных --Новое для меня
RESTORE DATABASE [TestDB]
		FROM DISK=N'D:\BACKUP_DB\TestDB.bak'
		WITH FILE = 1,
		STATS = 10
GO
--Отсоединение базы данных от нашего экземпляра SQL Server --Новое для меня
EXEC sp_detach_db @dbname='TestDB'
GO
--Присоединение базы данных к нашему экземпляру SQL Server --Новое для меня
CREATE DATABASE TestDB ON
			(FILENAME='D:\DataBase\TestDB.mdf'),
			(FILENAME='D:\DataBase\TestDB_log.ldf')
FOR ATTACH
GO
--Операция сжатия Базы данных. --Новое для меня
DBCC SHRINKDATABASE('TestDB')
--Операция сжатия отдельных файлов базы данных
DBCC SHRINKFILE('TestDB_log',5)
