﻿SET NOCOUNT ON;
USE TSQL2012;

IF OBJECT_ID('dbo.T1','U') IS NOT NULL
	DROP TABLE dbo.T1;
GO

CREATE TABLE dbo.T1
(
	col1 INT NOT NULL
	CONSTRAINT PK_T1 PRIMARY KEY
);

INSERT INTO dbo.T1(col1)
  VALUES(2),(3),(11),(12),(13),(27),(33),(34),(35),(42);

SELECT MIN(col1) AS start_range, MAX(col1) AS end_range
FROM (SELECT col1,
		-- разница является константой и уникальна в рамках островка
		col1 - ROW_NUMBER() OVER(ORDER BY col1) AS grp
      FROM dbo.T1) AS D
GROUP BY grp;