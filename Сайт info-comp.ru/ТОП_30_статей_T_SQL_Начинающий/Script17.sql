/*Статья https://info-comp.ru/obucheniest/368-transact-sql-group-by.html*/

DROP TABLE IF EXISTS TestTable;
GO

CREATE TABLE TestTable
(
	Id INT NOT NULL,
	name VARCHAR(50) NULL,
	summa MONEY NULL,
	priz INT NULL
);
GO

INSERT INTO TestTable (Id, name, summa, priz)
VALUES (1, 'Иванов', 100, 1),
	   (2, 'Петров', 200, 1),
	   (3, 'Иванов', 150, 1),
	   (4, 'Иванов', 300, 2),
	   (5, 'Петров', 220, 1),
	   (6, 'Петров', 90, 2)
GO

SELECT SUM(summa)
FROM TestTable
WHERE name='Иванов'

SELECT SUM(summa), name
FROM TestTable
GROUP BY name

SELECT SUM(summa) AS [Всего денежных средств],
	COUNT(*) AS [Количество поступлений]
FROM TestTable
GROUP BY name

SELECT SUM(summa) AS [Всего денежных средств],
	COUNT(*) AS [Количествыо поступлений],
	Name AS [Сотрудник],
	priz AS [Источник]
FROM TestTable
GROUP BY name, priz
ORDER BY name


SELECT SUM(summa) AS [Всего денежных средств],
	COUNT(*) AS [Количество поступлений],
	CASE WHEN priz=1 THEN 'Оклад'
		 WHEN priz=2 THEN 'Премия'
		 ELSE 'Без источника'
	END AS [Источник]
FROM TestTable
GROUP BY name, priz
ORDER BY name

SELECT SUM(summa) AS [Всего денежных средств],
	COUNT(*) AS [Количество поступлений],
	CASE WHEN priz = 1 THEN 'Оклад'
		 WHEN priz = 2 THEN 'Премия'
		 ELSE 'Без источника'
	END AS [Источник]
FROM TestTable
GROUP BY name, priz
HAVING SUM(summa) > 200
ORDER BY name
