SELECT orderid, custid, val,
	SUM(val) OVER() AS small,
	SUM(val) OVER(PARTITION BY custid) AS sumcust
  FROM Sales.OrderValues AS O1


SELECT orderid, custid, val,
	CAST(100. * val / SUM(val) OVER() AS NUMERIC(5,2)) AS pctall,
	CAST(100. * val / SUM(val) OVER(PARTITION BY custid) AS NUMERIC(5,2)) AS pctcust
  FROM Sales.OrderValues AS O1;


SELECT empid, ordermonth, qty,
	SUM(qty) OVER(PARTITION BY empid
		ORDER BY ordermonth
		ROWS BETWEEN UNBOUNDED PRECEDING
			AND CURRENT ROW) AS runqty
  FROM Sales.EmpOrders;

SELECT empid, ordermonth,
	MAX(qty) OVER(PARTITION BY empid
		ORDER BY ordermonth
		ROWS BETWEEN 1 PRECEDING
			AND 1 PRECEDING) AS prvqty,
	qty AS curqty,
	MAX(qty) OVER(PARTITION BY empid
		ORDER BY ordermonth
		ROWS BETWEEN 1 FOLLOWING
			AND 1 FOLLOWING) AS nxtqty,
	AVG(qty) OVER(PARTITION BY empid
		ORDER BY ordermonth
		ROWS BETWEEN 1 PRECEDING
			AND 1 FOLLOWING) AS nxtqty
  FROM Sales.EmpOrders;

/**********************************************************************************/

SET NOCOUNT ON;
USE TSQLV5;

DROP TABLE IF EXISTS dbo.T1;
GO
CREATE TABLE dbo.T1
(
  keycol INT         NOT NULL CONSTRAINT PK_T1 PRIMARY KEY,
  col1   VARCHAR(10) NOT NULL
);

INSERT INTO dbo.T1 VALUES
  (2, 'A'),(3, 'A'),
  (5, 'B'),(7, 'B'),(11, 'B'),
  (13, 'C'),(17, 'C'),(19, 'C'),(23, 'C');


SELECT keycol, col1,
	COUNT(*) OVER(ORDER BY col1
		ROWS BETWEEN UNBOUNDED PRECEDING
			AND CURRENT ROW) AS cnt
  FROM dbo.T1;

CREATE UNIQUE INDEX idx_col1D_keycol ON dbo.T1
(
	col1 DESC,
	keycol
);


SELECT keycol, col1,
	COUNT(*) OVER(ORDER BY col1, keycol
		ROWS BETWEEN UNBOUNDED PRECEDING
			AND CURRENT ROW) AS cnt
  FROM dbo.T1;

/*Для каждого заказа кол-во документов, оформленных за последние 3 дня*/
WITH C AS
(
	SELECT orderdate,
		SUM(COUNT(*)) OVER(ORDER BY orderdate
							ROWS BETWEEN 2 PRECEDING
								AND CURRENT ROW) AS numordersinlast3days
	  FROM Sales.Orders
	  GROUP BY orderdate
)

SELECT O.orderid, O.orderdate, C.numordersinlast3days
  FROM Sales.Orders AS O
 INNER JOIN C ON O.orderdate=c.orderdate;



WITH C AS
(
	SELECT orderdate,
		SUM(SUM(val)) OVER(ORDER BY orderdate
					ROWS BETWEEN 2 PRECEDING
						AND CURRENT ROW) AS sumval
	  FROM Sales.OrderValues
	 GROUP BY orderdate
)

SELECT O.orderid, O.orderdate,
	CAST(100.00 * O.val / C.sumval AS NUMERIC(5,2)) AS pctoflast3days
  FROM Sales.OrderValues AS O
 INNER JOIN C ON O.orderdate=C.orderdate;



WITH M AS
(
	SELECT DATEADD(MONTH, N.n,
					(SELECT MIN(ordermonth) FROM Sales.EmpOrders)) AS ordermonth
	  FROM dbo.GetNums(0, DATEDIFF(MONTH,
							(SELECT MIN(ordermonth) FROM Sales.EmpOrders),
							(SELECT MAX(ordermonth) FROM Sales.EmpOrders))) AS N
),
C AS
(
	SELECT E.empid, M.ordermonth, EO.qty,
		SUM(EO.qty) OVER(PARTITION BY E.empid
			ORDER BY M.ordermonth
			ROWS 2 PRECEDING) AS sum3month
	  FROM Hr.Employees AS E
	  CROSS JOIN M
	  LEFT OUTER JOIN Sales.EmpOrders AS EO ON e.empid=EO.empid AND M.ordermonth=EO.ordermonth
)
SELECT empid, ordermonth, qty, sum3month
  FROM C
 WHERE qty IS NOT NULL


SELECT empid, ordermonth, qty,
	SUM(qty) OVER(PARTITION BY empid
		ORDER BY ordermonth
		RANGE BETWEEN UNBOUNDED PRECEDING
			AND CURRENT ROW) AS runqty
  FROM Sales.EmpOrders;


SELECT keycol, col1,
	COUNT(*) OVER(ORDER BY col1
		RANGE BETWEEN UNBOUNDED PRECEDING
			AND CURRENT ROW
			) AS cnt
  FROM dbo.T1;

SELECT keycol, col1,
	COUNT(*) OVER(ORDER BY col1, keycol
		ROWS BETWEEN UNBOUNDED PRECEDING
			AND CURRENT ROW) AS cnt
  FROM dbo.T1;

SELECT col1,
	SUM(COUNT(*)) OVER(ORDER BY col1
		ROWS BETWEEN UNBOUNDED PRECEDING
			AND CURRENT ROW) AS cnt
  FROM dbo.T1
 GROUP BY col1;


SELECT empid, ordermonth,
	qty, qty - AVG(CASE WHEN ordermonth<=DATEADD(MONTH, -3, CURRENT_TIMESTAMP) THEN qty END) OVER(PARTITION BY empid) AS diff
  FROM Sales.EmpOrders;

/************************************************************************************/

SET NOCOUNT ON;
USE TSQLV5;

DROP TABLE IF EXISTS dbo.T2;

CREATE TABLE dbo.T2
(
  ordcol  INT NOT NULL,
  datacol INT NOT NULL,
  CONSTRAINT PK_T2
    PRIMARY KEY(ordcol)
);

INSERT INTO dbo.T2 VALUES
  (1,   10),
  (4,   15),
  (5,    5),
  (6,   10),
  (8,   15),
  (10,  20),
  (17,  10),
  (18,  10),
  (20,  30),
  (31,  20);
/************************************************************************************/

WITH C AS
(
	SELECT empid, orderdate, orderid, custid, val,
		CASE WHEN ROW_NUMBER() OVER(PARTITION BY empid, custid
				ORDER BY orderdate)=1
			THEN custid END AS distinct_custid
	 FROM Sales.OrderValues
)
SELECT empid, orderdate, orderid, val,
	COUNT(distinct_custid) OVER(PARTITION BY empid
		ORDER BY orderdate) AS numcusts
  FROM C;

SELECT empid,
	SUM(val) AS emptotal,
	SUM(val)/SUM(SUM(val)) OVER()*100. AS pct
  FROM Sales.OrderValues
 GROUP BY empid;

WITH C AS
(
	SELECT empid, orderdate,
		CASE WHEN ROW_NUMBER() OVER(PARTITION BY empid, custid ORDER BY orderdate)=1 THEN custid END AS distinct_custid
	  FROM Sales.Orders
)
SELECT empid, orderdate,
	SUM(COUNT(distinct_custid)) OVER(PARTITION BY empid
		ORDER BY orderdate) AS numcusts
  FROM C
 GROUP BY empid, orderdate

 /************************************************************************************/

SELECT orderid, val,
	ROW_NUMBER() OVER(ORDER BY orderid) AS rownum
  FROM Sales.OrderValues
 ORDER BY val DESC


SELECT orderid, val,
	COUNT(*) OVER(ORDER BY orderid
		ROWS UNBOUNDED PRECEDING) AS rownum
  FROM Sales.OrderValues

SELECT orderid, orderdate, val,
	ROW_NUMBER() OVER(ORDER BY orderdate DESC) AS rownum
  FROM Sales.OrderValues

SELECT orderid, orderdate, val,
	ROW_NUMBER() OVER(ORDER BY orderdate DESC, orderid DESC) AS rownum
  FROM Sales.OrderValues

SELECT orderid, orderdate, val,
	ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS rownum
  FROM Sales.OrderValues

SELECT orderid, val,
	ROW_NUMBER() OVER(ORDER BY val) AS rownum,
	NTILE(10) OVER(ORDER BY val) AS tile
  FROM Sales.OrderValues

SELECT orderid, val,
	ROW_NUMBER() OVER(ORDER BY val) AS rownum,
	(ROW_NUMBER() OVER(ORDER BY val) - 1)/10 + 1 AS pagenum
  FROM Sales.OrderValues

SELECT orderid, val,
	ROW_NUMBER() OVER(ORDER BY val, orderid) AS rownum,
	NTILE(10) OVER(ORDER BY val, orderid) AS tile
  FROM Sales.OrderValues