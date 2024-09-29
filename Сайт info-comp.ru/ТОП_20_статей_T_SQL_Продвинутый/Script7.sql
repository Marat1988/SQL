/*Статья https://info-comp.ru/obucheniest/435-pivot-unpivot-transact-sql.html*/

CREATE TABLE test_table_pivot
(
	fio VARCHAR(50) NULL,
	god INT NULL,
	summa FLOAT NULL
)
GO

INSERT INTO test_table_pivot (fio, god, summa)
VALUES ('Иванов И.И.', 2011, 200),
	   ('Иванов И.И.', 2011, 500),
	   ('Иванов И.И.', 2012, 300),
	   ('Иванов И.И.', 2012, 600),
	   ('Иванов И.И.', 2013, 900),
	   ('Иванов И.И.', 2014, 500),
	   ('Иванов И.И.', 2014, 300),
	   ('Иванов И.И.', 2015, 100),
	   ('Петров П.П.', 2011, 100),
	   ('Иванов И.И.', 2012, 200),
	   ('Иванов И.И.', 2012, 300),
	   ('Иванов И.И.', 2013, 100),
	   ('Иванов И.И.', 2014, 300),
	   ('Иванов И.И.', 2014, 100),
	   ('Сидоров С.С.', 2012, 100),
	   ('Сидоров С.С.', 2013, 1000),
	   ('Сидоров С.С.', 2014, 500),
	   ('Сидоров С.С.', 2014, 300),
	   ('Сидоров С.С.', 2015, 300)
GO

SELECT fio, god, SUM(summa) AS summa
FROM test_table_pivot
GROUP BY fio, god

SELECT fio, god, SUM(summa) AS summa
FROM test_table_pivot
GROUP BY fio, god
ORDER BY fio, god

SELECT fio, [2011], [2012], [2013], [2014], [2015]
FROM test_table_pivot
PIVOT (SUM(summa) FOR god IN ([2011], [2012], [2013], [2014], [2015])) AS test_pivot


CREATE TABLE test_table_unpivot
(
	fio VARCHAR(50) NULL,
	number1 INT NULL,
	number2 INT NULL,
	number3 INT NULL,
	number4 INT NULL,
	number5 INT NULL,
)

INSERT INTO test_table_unpivot
VALUES ('Иванов И.И.', 123, 1234, 12345, 123456, 1234567)

SELECT fio, column_name, number
FROM test_table_unpivot
UNPIVOT
(
	number FOR column_name IN (number1, number2, number3, number4, number5)
) AS test_table_unpivot