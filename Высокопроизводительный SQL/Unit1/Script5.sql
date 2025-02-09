SET NOCOUNT ON;
USE TSQL2012;
IF OBJECT_ID('dbo.T1','U') IS NOT NULL
	DROP TABLE dbo.T1;
GO

CREATE TABLE dbo.T1
(
	col1 VARCHAR(10) NOT NULL
	CONSTRAINT PK_T1 PRIMARY KEY
);
INSERT INTO dbo.T1(col1)
  VALUES('A'),('B'),('C'),('D'),('E'),('F');

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
  JOIN Sales.OrderDetails AS OD
    ON O.orderid=OD.orderid
WHERE O.orderdate>='20070101'
  AND O.orderdate<'20080101'
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