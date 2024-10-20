/*Статья https://professorweb.ru/my/sql-server/window-functions/level1/1_6.php*/

-- Не работает в T-SQL
SELECT empid, ordermonth, qty,
	qty - AVG(qty) FILTER (WHERE ordermonth <= DATEADD(MONTH, -3, CURRENT_TIMESTAMP)) OVER(PARTITION BY empid) AS diff
FROM Sales.EmpOrders;

SELECT empid, ordermonth, qty,
	qty - AVG(CASE WHEN ordermonth <= DATEADD(MONTH, -3, CURRENT_TIMESTAMP) THEN qty END) OVER(PARTITION BY empid) AS diff
FROM Sales.EmpOrders

-- Не работает в T-SQL
SELECT orderid, orderdate, empid, custid, val,
	val - AVG(val) FILTER (WHERE custid <> $current_row.custid) OVER(PARTITION BY empid) AS diff
FROM Sales.OrderValues

-- Не работает в T-SQL
SELECT orderid, orderdate, empid, custid, val,
	val - AVG(CASE WHEN custid <> $current_row.custid THEN val END) OVER(PARTITION BY empid) AS diff
FROM Sales.OrderValues

-- Не работает в T-SQL
SELECT empid, orderdate, orderid, val,
	COUNT(DISTINCT custid) OVER(PARTITION BY empid ORDER BY orderdate) AS numcusts
FROM Sales.OrderValues

SELECT empid, orderdate, orderid, custid, val,
	CASE WHEN ROW_NUMBER() OVER(PARTITION BY empid, custid ORDER BY orderdate) = 1 THEN custid END AS distinct_custid
FROM Sales.OrderValues;

WITH C AS
(
	SELECT empid, orderdate, orderid, custid, val,
		CASE WHEN ROW_NUMBER() OVER(PARTITION BY empid, custid ORDER BY orderdate)=1 THEN custid END AS distinct_custid
	FROM Sales.OrderValues
)

SELECT empid, orderdate, orderid, val,
	COUNT(distinct_custid) OVER(PARTITION BY empid ORDER BY orderdate) AS numcusts
FROM C


SELECT empid,
	SUM(val) AS emptotal,
	SUM(val) / SUM(SUM(val)) OVER() * 100. AS pct
FROM Sales.OrderValues
GROUP BY empid

SELECT empid,
	SUM(val) AS emptotal
FROM Sales.OrderValues
GROUP BY empid;

WITH C AS
(
	SELECT empid,
		SUM(val) AS emptotal
	FROM Sales.OrderValues
	GROUP BY empid
)
SELECT empid, emptotal,
	emptotal / SUM(emptotal) OVER() * 100. AS pct
FROM C;

WITH C AS
(
	SELECT empid, orderdate,
		CASE
			WHEN ROW_NUMBER() OVER(PARTITION BY empid, custid ORDER BY orderdate)=1 THEN custid END AS distinct_custid
	FROM Sales.Orders
)



SELECT empid, orderdate, SUM(COUNT(distinct_custid)) OVER(PARTITION BY empid ORDER BY orderdate) AS numcusts
FROM C
GROUP BY empid, orderdate
