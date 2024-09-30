/*Статья https://info-comp.ru/obucheniest/648-command-use-in-t-sql.html*/

USE TestDB
GO

--Инструкции для базы данных TestDB
SELECT DB_NAME() AS [Имя базы данных]

USE master
GO
--Инструкции для базы данных master
SELECT DB_NAME() AS [Имя базы данных]

USE master
GO
SELECT *
FROM TestDB.dbo.TestTable