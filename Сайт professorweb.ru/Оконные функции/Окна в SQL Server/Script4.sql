/*Статья https://professorweb.ru/my/sql-server/window-functions/level1/1_4.php*/

SET NOCOUNT ON;
USE TSQL2012;
IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1;
GO

CREATE TABLE dbo.T1
(
	col1 VARCHAR(10) NOT NULL,
	CONSTRAINT PK_T1 PRIMARY KEY(col1)
);

INSERT INTO dbo.T1(col1)
VALUES ('A'),('B'),('C'),('D'),('E'),('F');
GO

SELECT empid, country
FROM HR.Employees

SELECT DISTINCT country, ROW_NUMBER() OVER(ORDER BY country) AS rownum
FROM HR.Employees;


WITH EmpCountries AS
(
	SELECT DISTINCT country
	FROM HR.Employees
)
SELECT country, ROW_NUMBER() OVER(ORDER BY country) AS rownum
FROM EmpCountries

SELECT O.empid,
	SUM(OD.qty) AS qty,
	RANK() OVER(ORDER BY SUM(OD.qty) DESC) AS rnk
FROM Sales.Orders AS O
JOIN Sales.OrderDetails AS OD ON O.orderid=OD.orderid
WHERE O.orderdate>='20070101' AND O.orderdate<'20080101'
GROUP BY O.empid;

WITH C AS
(
	SELECT orderid, orderdate, val,
		RANK() OVER(ORDER BY val DESC) AS rnk
	FROM Sales.OrderValues
)
SELECT *
FROM C
WHERE rnk<=5;

/*-----------------------------------------------------------------------*/
SET NOCOUNT ON;
USE TSQL2012;
IF OBJECT_ID('dbo.T1','U') IS NOT NULL DROP TABLE dbo.T1;
GO

CREATE TABLE dbo.T1
(
	col1 INT NULL,
	col2 VARCHAR(10) NOT NULL
);

INSERT INTO dbo.T1(col2)
VALUES ('C'),('A'),('B'),('A'),('C'),('B');
GO

WITH C AS
(
	SELECT col1, col2,
		ROW_NUMBER() OVER(ORDER BY col2) AS rownum
	FROM dbo.T1
)
UPDATE C SET col1=rownum

SELECT *
FROM dbo.T1;

/*-----------------------------------------------------------------------*/

SELECT empid, ordermonth, qty,
	SUM(qty) OVER (PARTITION BY empid
				   ORDER BY ordermonth
				   ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS run_sum_qty,
	AVG(qty) OVER (PARTITION BY empid
				   ORDER BY ordermonth
				   ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS run_avg_qty,
	MIN(qty) OVER (PARTITION BY empid
				   ORDER BY ordermonth
				   ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS run_min_qty,
	MAX(qty) OVER (PARTITION BY empid
				   ORDER BY ordermonth
				   ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS run_max_qty
FROM Sales.EmpOrders

/*Не работает в SQL SERVER*/
SELECT empid, ordermonth, qty,
	SUM(qty) OVER W1 AS run_sum_qty,
	AVG(qty) OVER W1 AS run_avg_qty,
	MIN(qty) OVER W1 AS run_min_qty,
	MAX(qty) OVER W1 AS run_max_qty
FROM Sales.EmpOrders
WINDOW W1 AS (PARTITION BY empid
			  ORDER BY ordermonth
			  ROWS BETWEEN UNBOUNDED PRECEDING
						AND CURRENT ROW);