/*Статья https://info-comp.ru/obucheniest/342-sql-join.html*/

DROP TABLE IF EXISTS TestTable;
GO

DROP TABLE IF EXISTS TestTable2;
GO


CREATE TABLE TestTable
(
	number NUMERIC(18,0) NULL,
	text VARCHAR(50) NULL
);
GO

CREATE TABLE TestTable2
(
	number NUMERIC(18,0) NULL,
	text VARCHAR(50) NULL
);
GO



INSERT INTO TestTable (number, text)
VALUES (1, 'Первая строка t1'),
	   (2, 'Вторая строка t1'),
	   (3, 'Третья строка t1'),
	   (4, 'Четвертая строка t1');
GO

INSERT INTO TestTable2 (number, text)
VALUES (1, 'Первая строка t2'),
	   (2, 'Вторая строка t2'),
	   (3, 'Третья строка t2');
GO

SELECT t1.number AS t1_number, t1.text AS t1_text, t2.number AS t2_number, t2.text AS t2_text
FROM TestTable t1
LEFT JOIN TestTable2 t2 ON t1.number=t2.number

SELECT t1.number AS t1_number, t1.text AS t1_text, t2.number AS t2_number, t2.text AS t2_text
FROM TestTable t1
RIGHT JOIN TestTable2 t2 ON t1.number=t2.number

SELECT t1.number AS t1_number, t1.text AS t1_text, t2.number AS t2_number, t2.text AS t2_text
FROM TestTable t1
INNER JOIN TestTable2 t2 ON t1.number=t2.number

ALTER TABLE TestTable ADD number2 INT;
ALTER TABLE TestTable2 ADD number2 INT;

UPDATE TestTable SET number2=1;
UPDATE TestTable2 SET number2=1;

SELECT t1.number AS t1_number, t1.text AS t1_text, t2.number AS t2_number, t2.text AS t2_text
FROM TestTable t1
INNER JOIN TestTable2 t2 ON t1.number=t2.number AND t1.number2=t2.number2

UPDATE TestTable2 SET number2=2
WHERE number=1;

SELECT t1.number AS t1_number, t1.text AS t1_text, t2.number AS t2_number, t2.text AS t2_text
FROM TestTable t1
INNER JOIN TestTable2 t2 ON t1.number=t2.number AND t1.number2=t2.number2

SELECT t1.number AS t1_number, t1.text AS t1_text,
	t2.number AS t2_number, t2.text AS t2_text
FROM TestTable t1
CROSS JOIN TestTable2 t2

SELECT t1.number AS t1_number, t1.text AS t1_text,
	t2.number AS t2_number, t2.text AS t2_text,
	t3.number AS t3_number, t3.text AS t3_text,
	t4.number AS t4_number, t4.text AS t4_text
FROM TestTable t1
LEFT JOIN TestTable2 t2 ON t1.number=t2.number
RIGHT JOIN TestTable2 t3 ON t1.number=t3.number
INNER JOIN TestTable2 t4 ON t1.number=t4.number

