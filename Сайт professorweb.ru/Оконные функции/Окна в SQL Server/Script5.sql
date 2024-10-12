/*Статья https://professorweb.ru/my/sql-server/window-functions/level1/1_5.php*/

SELECT orderid, custid, val,
	SUM(val) OVER() AS sumall,
	SUM(val) OVER(PARTITION BY custid) AS sumcust
FROM Sales.OrderValues AS O1

SELECT orderid, custid, val,
	CAST(100. * val / SUM(val) OVER() AS NUMERIC(5,2)) AS pctall,
	CAST(100. * val / SUM(val) OVER(PARTITION BY custid) AS NUMERIC(5,2)) AS pctcust
FROM Sales.OrderValues AS O1

SELECT empid, ordermonth, qty,
	SUM(qty) OVER(PARTITION BY empid ORDER BY ordermonth ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS runqty
FROM Sales.EmpOrders

SELECT empid, ordermonth, qty,
	SUM(qty) OVER(PARTITION BY empid ORDER BY ordermonth ROWS UNBOUNDED PRECEDING) AS runqty 
FROM Sales.EmpOrders;

SELECT empid, ordermonth, MAX(qty) OVER(PARTITION BY empid ORDER BY ordermonth ROWS BETWEEN 1 PRECEDING AND 1 PRECEDING) AS prvqty,
	qty AS curqty,
	MAX(qty) OVER(PARTITION BY empid ORDER BY ordermonth ROWS BETWEEN 1 FOLLOWING AND 1 FOLLOWING) AS nxtqty,
	AVG(qty) OVER(PARTITION BY empid ORDER BY ordermonth ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS avgqty
FROM Sales.EmpOrders;


SET NOCOUNT ON;
USE TSQL2012;
IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1;
GO
CREATE TABLE dbo.T1
(
	keycol INT NOT NULL CONSTRAINT PK_T1 PRIMARY KEY,
	col1 VARCHAR(10) NOT NULL
);

INSERT INTO dbo.T1
VALUES (2,'A'),(3,'A'),(5,'B'),(7,'B'),(11,'B'),
	   (13,'C'),(17,'C'),(19,'C'),(23,'C');

SELECT keycol, col1,
	COUNT(*) OVER(ORDER BY col1 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cnt
FROM dbo.T1

CREATE UNIQUE INDEX idx_col1D_keycol ON dbo.T1(col1 DESC, keycol);

SELECT keycol, col1, COUNT(*) OVER(ORDER BY col1, keycol ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cnt
FROM dbo.T1

--Не поддерживается в SQL SERVER
SELECT empid, ordermonth, qty,
	SUM(qty) OVER(PARTITION BY empid ORDER BY ordermonth RANGE BETWEEN INTERVAL '2' MONTH PRECEDING AND CURRENT ROW) AS sum3month
FROM Sales.EmpOrders

SELECT empid, ordermonth, qty,
	(SELECT SUM(qty)
	 FROM Sales.EmpOrders AS O2
	 WHERE O2.empid=O1.empid
		AND O2.ordermonth BETWEEN DATEADD(MONTH, -2, O1.ordermonth) AND O1.ordermonth) AS sum3month
FROM Sales.EmpOrders AS O1


SELECT empid, ordermonth, qty,
	SUM(qty) OVER(PARTITION BY empid
				  ORDER BY ordermonth
				  RANGE BETWEEN UNBOUNDED PRECEDING
							AND CURRENT ROW) AS runqty
FROM Sales.EmpOrders

SELECT empid, ordermonth, qty,
	SUM(qty) OVER(PARTITION BY empid
				  ORDER BY ordermonth
				  RANGE UNBOUNDED PRECEDING) AS runqty
FROM Sales.EmpOrders


SELECT empid, ordermonth, qty,
	SUM(qty) OVER(PARTITION BY empid
				  ORDER BY ordermonth) AS runqty
FROM Sales.EmpOrders


SELECT keycol, col1,
	COUNT(*) OVER(ORDER BY col1
				  ROWS BETWEEN UNBOUNDED PRECEDING
							AND CURRENT ROW) AS cnt
FROM dbo.T1


SELECT keycol, col1,
	COUNT(*) OVER(ORDER BY col1
				  RANGE BETWEEN UNBOUNDED PRECEDING
							AND CURRENT ROW) AS cnt
FROM dbo.T1

/*************************************************************/

/*Не поддерживается в SQL SERVER 2012

EXCLUDE NO OTHERS (не исключаем строки)*/
SELECT keycol, col1,
	COUNT(*) OVER(ORDER BY col1 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW EXCLUDE NO OTHERS) AS cnt
FROM dbo.T1

--EXCLUDE CURRENT ROW (исключить текущую строку)
SELECT keycol, col1,
	COUNT(*) OVER(ORDER BY col1
				  ROWS BETWEEN UNBOUNDED PRECEDING
							AND CURRENT ROW
				  EXCLUDE CURRENT ROW) AS cnt
FROM dbo.T1

--EXCLUDE GROUP (исключаем текущую строку и строки,
-- расположенные с ней на одном уровне)
SELECT keycol, col1, COUNT(*) OVER(ORDER BY col1
								   ROWS BETWEEN UNBOUNDED PRECEDING
											AND CURRENT ROW
								   EXCLUDE EXCLUDE GROUP) AS cnt
FROM dbo.T1


--EXCLUDE TIES (оставляем текущую строку и удалаяем строки,
-- расположенные с ней на одном уровне)
SELECT keycol, col1,
	COUNT(*) OVER(ORDER BY col1
				  ROWS BETWEEN UNBOUNDED PRECEDING
							AND CURRENT ROW
				  EXCLUDE TIES) AS cnt
FROM dbo.T1