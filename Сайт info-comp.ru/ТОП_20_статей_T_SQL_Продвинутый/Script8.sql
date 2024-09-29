/*Статья https://info-comp.ru/obucheniest/444-sql-rollup-cube-grouping-sets.html*/

DROP TABLE IF EXISTS test_table

CREATE TABLE test_table
(
	id INT IDENTITY(1,1) NOT NULL,
	manager VARCHAR(50) NULL,
	otdel VARCHAR(50) NULL,
	god INT NULL,
	summa MONEY NULL
)
GO

INSERT INTO test_table (manager, otdel, god, summa)
VALUES ('Сотрудник_1', 'Бухгалтерия', 2014, 200),
	   ('Сотрудник_2', 'Бухгалтерия', 2014, 300),
	   ('Сотрудник_3', 'Отдел покупок', 2014, 150),
	   ('Сотрудник_4', 'Отдел покупок', 2014, 200),
	   ('Сотрудник_5', 'Отдел реализации', 2014, 250),
	   ('Сотрудник_6', 'Отдел реализации', 2014, 300),
	   ('Сотрудник_7', 'Отдел реализации', 2014, 300),
	   ('Сотрудник_1', 'Бухгалтерия', 2015, 230),
	   ('Сотрудник_2', 'Бухгалтерия', 2015, 200),
	   ('Сотрудник_3', 'Отдел покупок', 2015, 200),
	   ('Сотрудник_4', 'Отдел покупок', 2015, 300),
	   ('Сотрудник_5', 'Отдел реализации', 2015, 200),
	   ('Сотрудник_6', 'Отдел реализации', 2015, 250),
	   ('Сотрудник_7', 'Отдел реализации', 2015, 350)
GO

SELECT otdel, god, SUM(summa) AS itog
FROM test_table
GROUP BY otdel, god
ORDER BY otdel, god

SELECT otdel, god, SUM(summa) AS itog
FROM test_table
GROUP BY
ROLLUP (otdel, god)

SELECT otdel, SUM(summa) AS itog
FROM test_table
GROUP BY
ROLLUP (otdel)

SELECT god, SUM(summa) AS itog
FROM test_table
GROUP BY
ROLLUP (god)


SELECT otdel, god, SUM(summa) AS itog
FROM test_table
GROUP BY
CUBE (otdel, god)

SELECT otdel, god, SUM(summa) AS itog
FROM test_table
GROUP BY
GROUPING SETS (otdel, god)

SELECT otdel,
	ISNULL(CAST(god AS VARCHAR(30)), CASE WHEN GROUPING(god)=1 AND GROUPING(otdel)=0 THEN 'Промежуточный итог' ELSE 'Общий итог' END) AS god,
	SUM(summa) AS itog,
	GROUPING(otdel) AS grouping_otdel,
	GROUPING(god) AS grouping_god
FROM test_table
GROUP BY
ROLLUP (otdel,god)