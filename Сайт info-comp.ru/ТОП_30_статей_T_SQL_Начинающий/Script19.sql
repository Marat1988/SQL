/*Статья https://info-comp.ru/obucheniest/340-sql-union-and-union-all.html*/

DROP TABLE IF EXISTS TestTable;
GO
DROP TABLE IF EXISTS TestTable2;
GO

CREATE TABLE TestTable
(
	Id BIGINT IDENTITY(1,1) NOT NULL,
	number NUMERIC(18,0) NULL,
	text VARCHAR(50) NULL,
	CONSTRAINT PK_test_table PRIMARY KEY CLUSTERED(Id ASC)
	WITH
	(
		PAD_INDEX=OFF,
		STATISTICS_NORECOMPUTE=OFF,
		IGNORE_DUP_KEY=OFF,
		ALLOW_ROW_LOCKS=ON,
		ALLOW_PAGE_LOCKS=ON
	)
);
GO

SET ANSI_PADDING OFF
GO

CREATE TABLE TestTable2
(
	Id BIGINT IDENTITY(1,1) NOT NULL,
	number NUMERIC(18,0) NULL,
	text VARCHAR(50) NULL,
	CONSTRAINT PK_test_table2 PRIMARY KEY CLUSTERED(Id ASC)
	WITH
	(
		PAD_INDEX=OFF,
		STATISTICS_NORECOMPUTE=OFF,
		IGNORE_DUP_KEY=OFF,
		ALLOW_ROW_LOCKS=ON,
		ALLOW_PAGE_LOCKS=ON
	)
);
GO

SET ANSI_PADDING OFF
GO



INSERT INTO TestTable (number, text)
VALUES (1, 'Первая строка'),
	(2, 'Вторая строка таблицы 1'),
	(3, 'Третья строка таблицы 1');

INSERT INTO TestTable2 (number, text)
VALUES (1, 'Первая строка'),
	(2, 'Вторая строка таблицы 2'),
	(3, 'Третья строка таблицы 2')

SELECT number, text
FROM TestTable
UNION
SELECT number, text
FROM TestTable2

SELECT number, text
FROM TestTable
UNION ALL
SELECT number, text
FROM TestTable2
ORDER BY number

SELECT id, number, text
FROM TestTable
UNION ALL
SELECT '', number, text
FROM TestTable2