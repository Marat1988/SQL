/*Статья https://info-comp.ru/obucheniest/427-intersect-except-transact-sql.html*/

DROP TABLE IF EXISTS test_table
GO

CREATE TABLE test_table
(
	id INT NOT NULL,
	tip VARCHAR(50) NULL,
	summa VARCHAR(50) NULL
)
GO

INSERT INTO test_table (id, tip, summa)
VALUES (1, 'Принтер', 100),
	   (2, 'Сканер', 150),
	   (3, 'Монитор', 200)
GO

CREATE TABLE test_table_two
(
	id INT NOT NULL,
	tip VARCHAR(50) NULL,
	summa VARCHAR(50) NULL
)
GO

INSERT INTO test_table_two (id, tip, summa)
VALUES (1, 'Принтер', 100),
	   (2, 'Сканер', 150),
	   (3, 'Монитор', 200),
	   (4, 'Системный блок', 500)
GO

SELECT tip, summa
FROM test_table
INTERSECT
SELECT tip, summa
FROM test_table_two

SELECT tip, summa
FROM test_table_two
EXCEPT
SELECT tip, summa
FROM test_table