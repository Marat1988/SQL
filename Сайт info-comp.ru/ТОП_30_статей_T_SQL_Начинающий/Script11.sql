/*Статья https://info-comp.ru/programmirovanie/605-data-types-in-t-sql.html*/

USE TestDb;
GO

DROP TABLE IF EXISTS TestTable1
DROP TABLE IF EXISTS TestTable2

--В строке 16 байт
CREATE TABLE TestTable1
(
	Id INT NOT NULL, --4 байта
	IdProperty INT NOT NULL, --4 байта
	IsEnabled INT NOT NULL, --4 байта
	IsTest INT NOT NULL --4 байта
)

--В строке 9 байт
CREATE TABLE TestTable2
(
	Id INT NOT NULL, --4 байта
	IdProperty INT NOT NULL, --4 байта
	IsEnabled BIT NOT NULL, --1 байт
	IsTest BIT NOT NULL --0 байт
)