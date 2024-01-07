/*По статье https://info-comp.ru/obucheniest/649-over-in-t-sql.html*/

CREATE DATABASE TestBase
GO
--Переходим в созданную базу
USE TestBase
GO
--Создание таблицы
CREATE TABLE TestTableOver
(
	ProductId INT IDENTITY(1,1) NOT NULL,
	CategoryId INT NOT NULL,
	ProductName VARCHAR(100) NOT NULL,
	Price MONEY NULL
)
GO
--Вставляем в таблицу данные
INSERT INTO TestTableOver
VALUES (1, 'Клавиатура', 100),
		(1, 'Мышь', 50),
		(1, 'Системный блок', 200),
		(1, 'Монитор', 250),
		(2, 'Телефон', 300),
		(2, 'Планшет', 500)
GO
SELECT *
FROM TestTableOver

/*----------------------------------------------------*/
SELECT ProductId, ProductName, CategoryId, Price,
		SUM(Price) OVER (PARTITION BY CategoryId) AS [SUM],
		AVG(Price) OVER (PARTITION BY CategoryId) AS [AVG],
		COUNT(Price) OVER (PARTITION BY CategoryId) AS [COUNT],
		MIN(Price) OVER (PARTITION BY CategoryId) AS [MIN],
		MAX(Price) OVER (PARTITION BY CategoryId) AS [MAX]
FROM TestTableOver
/*----------------------------------------------------*/
SELECT ProductId, ProductName, CategoryId, Price,
		ROW_NUMBER() OVER (PARTITION BY CategoryId ORDER BY ProductId) AS [ROW_NUMBER],
		RANK() OVER (PARTITION BY CategoryId ORDER BY Price) AS [RANK] 
FROM TestTableOver
ORDER BY ProductId
/*----------------------------------------------------*/
SELECT ProductId, ProductName, CategoryId, Price,
		LEAD(ProductId) OVER (PARTITION BY CategoryId ORDER BY ProductId) AS [LEAD],
		LAG(ProductId) OVER (PARTITION BY CategoryId ORDER BY ProductId) AS [LAG],
		FIRST_VALUE(ProductId) OVER (PARTITION BY CategoryId
												ORDER BY ProductId
												ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS [FIRST_VALUE],
		LAST_VALUE(ProductId) OVER (PARTITION BY CategoryId
												ORDER BY ProductId
												ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS [LAST_VALUE],
		LEAD(ProductId, 2) OVER (PARTITION BY CategoryId ORDER BY ProductId) AS [LEAD_2],
		LAG(ProductId, 2, 0) OVER (PARTITION BY CategoryId ORDER BY ProductId) AS [LAG_2]
FROM TestTableOver
ORDER BY ProductId
/*----------------------------------------------------*/
SELECT ProductId, ProductName, CategoryId, Price,
		CUME_DIST() OVER (PARTITION BY CategoryId ORDER BY Price) AS [CUME_DIST],
		PERCENT_RANK() OVER (PARTITION BY CategoryId ORDER BY Price) AS [PERCENT_RANK],
		PERCENTILE_DISC(0.5) WITHIN GROUP(ORDER BY ProductId) OVER(PARTITION BY CategoryId) AS [PERCENTILE_DISC],
		PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY ProductID) OVER(PARTITION BY CategoryId) AS [PERCENTILE_COUNT]
FROM TestTableOver