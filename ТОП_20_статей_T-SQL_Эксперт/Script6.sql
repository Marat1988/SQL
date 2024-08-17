/*Статья https://info-comp.ru/obucheniest/508-identity-insert-property-tables-in-ms-sql-server.html*/

DROP TABLE IF EXISTS TestTabe
GO

CREATE TABLE TestTable
(
	Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	TextData VARCHAR(50) NOT NULL
);
GO

INSERT INTO TestTable (TextData)
VALUES ('Строка 1'),
	   ('Строка 2'),
	   ('Строка 3'),
	   ('Строка 4'),
	   ('Строка 5')
GO

SELECT *
FROM TestTable
GO

DELETE TestTable
WHERE Id = 4;

SELECT *
FROM TestTable
GO

INSERT INTO TestTable (Id, TextData)
VALUES (3, 'Строка 3')
GO

SET IDENTITY_INSERT TestTable ON;

INSERT INTO TestTable (Id, TextData)
VALUES (4, 'Строка 4')
GO

SET IDENTITY_INSERT TestTable OFF;