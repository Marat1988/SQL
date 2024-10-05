/*Статья https://info-comp.ru/obucheniest/683-drop-if-exists-in-t-sql.html*/

IF OBJECT_ID('dbo.TestTable', 'U') IS NOT NULL
	DROP TABLE TestTable;
GO

DROP TABLE IF EXISTS dbo.TestTable;
GO

IF EXISTS(SELECT *
		  FROM sys.objects
		  WHERE object_id=OBJECT_ID(N'dbo.TestFunction') AND type IN (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION TestFunction;

DROP FUNCTION IF EXISTS TestFunction;