/*Статья https://info-comp.ru/obucheniest/616-list-of-tables-in-ms-sql-server.html*/

USE TestBase
GO

SELECT TABLE_NAME AS [Название таблицы]
FROM INFORMATION_SCHEMA.TABLES
WHERE table_type='BASE TABLE'

SELECT name AS [Название таблицы],
		create_date AS [Дата создания],
		modify_date AS [Дата редактирования]
FROM sys.tables

EXEC sp_Tables @table_owner='dbo', @table_type="'TABLE'";