USE TSQL2012;

IF OBJECT_ID('dbo.T1') IS NOT NULL
  DROP TABLE dbo.T1;

CREATE TABLE dbo.T1
(
  ordcol  INT NOT NULL PRIMARY KEY,
  datacol INT NOT NULL
)

INSERT INTO dbo.T1 
VALUES (1, 10),
	   (4, -15),
	   (5, 5),
	   (6, -10),
	   (8, -15),
	   (10, 20),
	   (17, 10),
	   (18, -10),
	   (20, -30),
	   (31, 20);
GO

WITH C1 AS
(
  SELECT ordcol, datacol, SUM(datacol) OVER(ORDER BY ordcol
										     ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS partsum
    FROM dbo.T1
),
C2 AS
(
  SELECT *, MIN(partsum) OVER(ORDER BY ordcol
							   ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS adjust
    FROM C1
)
SELECT *, partsum - CASE WHEN adjust < 0 THEN adjust ELSE 0 END AS nonnegativesum
  FROM C2;