SET NOCOUNT ON;
USE TSQL2012;

-- dbo.T1 (numeric sequence with unique values, interval: 1)
IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1;

CREATE TABLE dbo.T1
(
  col1 INT NOT NULL
    CONSTRAINT PK_T1 PRIMARY KEY
);
GO

INSERT INTO dbo.T1(col1)
  VALUES(2),(3),(7),(8),(9),(11),(15),(16),(17),(28);

-- dbo.T2 (temporal sequence with unique values, interval: 1 day)
IF OBJECT_ID('dbo.T2', 'U') IS NOT NULL DROP TABLE dbo.T2;

CREATE TABLE dbo.T2
(
  col1 DATE NOT NULL
    CONSTRAINT PK_T2 PRIMARY KEY
);
GO

INSERT INTO dbo.T2(col1) VALUES
  ('20120202'),
  ('20120203'),
  ('20120207'),
  ('20120208'),
  ('20120209'),
  ('20120211'),
  ('20120215'),
  ('20120216'),
  ('20120217'),
  ('20120228');

/*Пробелы*/
WITH C AS
(
  SELECT col1 AS cur, LEAD(col1) OVER(ORDER BY col1) AS nxt
    FROM dbo.T1
)

SELECT cur + 1 AS rangestart, nxt - 1 AS rangeend
  FROM C
 WHERE nxt-cur>1;


WITH C AS
(
  SELECT col1 AS cur, LEAD(col1) OVER(ORDER BY col1) AS nxt
    FROM dbo.T2
)

SELECT DATEADD(day, 1, cur) AS rangestart, DATEADD(DAY, -1, nxt) AS rangeend
  FROM C
 WHERE DATEDIFF(day, cur, nxt)>1;

/*Островки*/

SELECT col1,
  DENSE_RANK() OVER(ORDER BY col1) AS drnk,
  col1 - DENSE_RANK() OVER(ORDER BY col1) AS diff
  FROM dbo.T1;

WITH C AS
(
  SELECT col1, col1-DENSE_RANK() OVER(ORDER BY col1) AS grp
    FROM dbo.T1
)
SELECT MIN(col1) AS start_range, MAX(col1) AS end_range
  FROM C
 GROUP BY grp;


WITH C AS
(
  SELECT col1, DATEADD(day, -1* DENSE_RANK() OVER(ORDER BY col1), col1) AS grp
    FROM dbo.T2
)

SELECT MIN(col1) AS start_range, MAX(col1) AS end_range
  FROM C
 GROUP BY grp;


 /*Упаковка временных интервалов*/
 IF OBJECT_ID('dbo.Intervals', 'U') IS NOT NULL DROP TABLE dbo.Intervals;

CREATE TABLE dbo.Intervals
(
  id        INT  NOT NULL,
  startdate DATE NOT NULL,
  enddate   DATE NOT NULL
);

INSERT INTO dbo.Intervals(id, startdate, enddate) VALUES
  (1, '20120212', '20120220'),
  (2, '20120214', '20120312'),
  (3, '20120124', '20120201');

DECLARE
  @from AS DATE='20120101',
  @to   AS DATE='20121231';


WITH Dates AS
(
  SELECT DATEADD(DAY, n-1, @from) AS dt
    FROM dbo.GetNums(1, DATEDIFF(DAY, @from, @to)+1) AS Nums
),
Groups AS
(
  SELECT D.dt,
    DATEADD(DAY, -1*DENSE_RANK() OVER(ORDER BY D.dt), D.dt) AS grp
    FROM dbo.Intervals AS I
      JOIN Dates AS D
        ON D.dt BETWEEN I.startdate AND I.enddate
)
SELECT MIN(dt) AS rangestart, MAX(dt) AS rangeend
  FROM Groups
 GROUP BY grp;

WITH C1 AS
(
  SELECT col1,
    CASE WHEN col1-LAG(col1) OVER(ORDER BY col1) <=2 THEN 0 ELSE 1 END AS isstart,
    CASE WHEN LEAD(col1) OVER(ORDER BY col1)-col1<=2 THEN 0 ELSE 1 END AS issend
    FROM dbo.T1
),
C2 AS
(
  SELECT col1 AS rangestart, LEAD(col1, 1-issend) OVER(ORDER BY col1) AS rangeend, isstart
    FROM C1
   WHERE isstart=1 OR issend=1
)
SELECT rangestart, rangeend
  FROM C2
 WHERE isstart=1;