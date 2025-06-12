USE TSQLV5;

SELECT orderid, orderdate, val,
	RANK() OVER(ORDER BY val DESC) AS rnk
  FROM Sales.OrderValues
 ORDER BY rnk;

 SELECT orderid, custid, val,
	CAST(100. * val / SUM(val) OVER(PARTITION BY custid) AS NUMERIC(5,2)) AS pctcust,
	val - AVG(val) OVER(PARTITION BY custid) AS diffcust,
	CAST(100. * val / SUM(val) OVER() AS NUMERIC(5,2)) AS pctall,
	val - AVG(val) OVER() AS diffall
   FROM Sales.OrderValues

SELECT orderid, custid, val,
	CAST(100. * val / SUM(val) OVER(PARTITION BY custid) AS NUMERIC(5,2)) AS pctcust,
	val - AVG(val) OVER(PARTITION BY custid) AS diffcust,
	CAST(100. * val / SUM(val) OVER() AS NUMERIC(5,2)) AS pctall,
	val - AVG(val) OVER() AS diffall
  FROM Sales.OrderValues
 WHERE orderdate >= '20180101'
	AND orderdate < '20190101'

/*********************************************************************************/

SET NOCOUNT ON;
USE TSQLV5;

DROP TABLE IF EXISTS dbo.T1;
GO

CREATE TABLE dbo.T1
(
  col1 INT NOT NULL
    CONSTRAINT PK_T1 PRIMARY KEY
);

INSERT INTO dbo.T1(col1) 
  VALUES(2),(3),(11),(12),(13),(27),(33),(34),(35),(42);
GO


WITH C AS
(
	SELECT col1,
		-- разница постоянна и уникальна для каждого острова
		col1 -  ROW_NUMBER() OVER(ORDER BY col1) AS grp
	  FROM dbo.T1
)
SELECT MIN(col1) AS startrange, MAX(col1) AS endrange
  FROM C
 GROUP BY grp;

 /*********************************************************************************/

SELECT custid, orderid, val,
	RANK() OVER(ORDER BY val DESC) AS rnkall,
	RANK() OVER(PARTITION BY custid ORDER BY val DESC) AS rnkcust
  FROM Sales.OrderValues

SELECT empid, ordermonth, qty,
	SUM(qty) OVER(PARTITION BY empid
		ORDER BY ordermonth
		ROWS BETWEEN UNBOUNDED PRECEDING
			AND CURRENT ROW) AS runqty
  FROM Sales.EmpOrders;

/*********************************************************************************/

SET NOCOUNT ON;
USE TSQLV5;

DROP TABLE IF EXISTS dbo.T1;
GO

CREATE TABLE dbo.T1
(
  col1 VARCHAR(10) NOT NULL
    CONSTRAINT PK_T1 PRIMARY KEY
);

INSERT INTO dbo.T1(col1) 
  VALUES('A'),('B'),('C'),('D'),('E'),('F');
GO

/*********************************************************************************/

SELECT O.empid,
	SUM(OD.qty) AS qty,
	RANK() OVER(ORDER BY SUM(OD.qty) DESC) AS rnk 
  FROM Sales.Orders AS O
 INNER JOIN Sales.OrderDetails AS OD ON O.orderid=OD.orderid
 WHERE O.orderdate >= '20180101'
   AND O.orderdate < '20190101'
 GROUP BY O.empid;


SELECT country, ROW_NUMBER() OVER(ORDER BY country) AS rownum
  FROM HR.Employees
 GROUP BY country;


WITH C AS
(
	SELECT orderid, orderdate, val,
		RANK() OVER(ORDER BY val DESC) AS rnk
	  FROM Sales.OrderValues
)
SELECT *
  FROM C
 WHERE rnk<=5;
 /*********************************************************************************/

SET NOCOUNT ON;
USE TSQLV5;

DROP TABLE IF EXISTS dbo.T1;
GO

CREATE TABLE dbo.T1
(
  col1 INT NULL,
  col2 VARCHAR(10) NOT NULL
);

INSERT INTO dbo.T1(col2) 
  VALUES('C'),('A'),('B'),('A'),('C'),('B');
GO

WITH C AS
(
	SELECT col1, col2,
		ROW_NUMBER() OVER(ORDER BY col2) AS rownum
	  FROM dbo.T1
)
UPDATE C
	SET col1=rownum

SELECT col1, col2
  FROM dbo.T1