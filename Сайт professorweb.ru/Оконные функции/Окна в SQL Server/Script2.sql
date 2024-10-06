/*Статья https://professorweb.ru/my/sql-server/window-functions/level1/1_2.php*/

SET NOCOUNT ON;
USE TSQL2012;

IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1;
GO

CREATE TABLE dbo.T1
(
	col1 INT NOT NULL
	CONSTRAINT PK_T1 PRIMARY KEY
);

INSERT INTO dbo.T1(col1)
VALUES(2),(3),(11),(12),(13),(27),(33),(34),(35),(42);
GO
/*----------------------------------------------------------*/
SELECT col1,
	(SELECT MIN(b.col1)
	 FROM dbo.T1 AS B
	 WHERE B.col1 >= A.col1
	 --является ли текущая строка последней в этой группе
	 AND NOT EXISTS(SELECT * FROM dbo.T1 AS C WHERE C.col1 = B.col1+1)) AS grp
FROM dbo.T1 AS A
/*----------------------------------------------------------*/
SELECT MIN(col1) AS start_range, MAX(col1) AS end_range
FROM (SELECT col1,
			(SELECT MIN(B.col1)
			 FROM dbo.T1 AS B
			 WHERE B.col1 >= A.col1
				AND NOT EXISTS(SELECT * FROM dbo.T1 AS C WHERE C.col1=B.col1+1)) AS grp
	  FROM dbo.T1 AS A) AS D
GROUP BY grp
/*----------------------------------------------------------*/
SELECT col1, ROW_NUMBER() OVER(ORDER BY col1) AS rownum
FROM dbo.T1;

SELECT col1, col1 - ROW_NUMBER() OVER(ORDER BY col1) AS diff
FROM dbo.T1

SELECT MIN(col1) AS start_range, MAX(col1) AS end_range
FROM (SELECT col1,
	  -- разница является константой и уникальна в рамках диапазона (островка)
	  col1 - ROW_NUMBER() OVER(ORDER BY col1) AS grp
	  FROM dbo.T1) AS D
GROUP BY grp