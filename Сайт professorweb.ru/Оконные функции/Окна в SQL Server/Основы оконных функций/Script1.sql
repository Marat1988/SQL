/*Статья https://professorweb.ru/my/sql-server/window-functions/level1/1_1.php*/

USE TSQL2012;
GO

SELECT orderid, orderdate, val,
	RANK() OVER(ORDER BY val DESC) AS 'rank'
FROM Sales.OrderValues
ORDER BY 'rank'

/*---------------------------------------------*/

WITH Aggregates AS
(
	SELECT custid, SUM(val) AS sumval, AVG(val) AS avgval
	FROM Sales.OrderValues
	GROUP BY custid
)
SELECT O.orderId, O.custid, O.val,
	CAST(100. * O.val / A.sumval AS NUMERIC(5, 2)) AS pctcust,
	O.val - A.avgval AS diffcust
FROM Sales.OrderValues AS O
JOIN Aggregates AS A ON O.custid=A.custid;

/*---------------------------------------------*/

WITH CustAggregates AS
(
	SELECT custid, SUM(val) AS sumval, AVG(val) AS avgval
	FROM Sales.OrderValues
	GROUP BY custid
),
GrandAggretes AS
(
	SELECT SUM(val) AS sumval, AVG(val) AS avgval
	FROM Sales.OrderValues
)
SELECT O.orderid, O.custid, O.val,
	CAST(100. * O.val / CA.sumval AS NUMERIC(5,2)) AS pctcust,
	O.val - CA.avgval AS diffcust,
	CAST(100. * O.val / GA.sumval AS NUMERIC(5,2)) AS pctall,
	O.val - GA.avgval AS diffall
FROM Sales.OrderValues AS O
JOIN CustAggregates AS CA ON O.custid=CA.custid
CROSS JOIN GrandAggretes AS GA

/*---------------------------------------------*/

--Вложенные запросы с подробными данными и агрегами по отдельным клиентам
SELECT orderid, custid, val,
	CAST(100. * val / 
				(SELECT SUM(O2.val)
				 FROM Sales.OrderValues AS O2
				 WHERE O2.custid=O1.custid) AS NUMERIC(5,2)) AS pctcust,
	val - (SELECT AVG(O2.val)
		   FROM Sales.OrderValues AS O2
		   WHERE O2.custid=O1.custid) AS diffcust
FROM Sales.OrderValues AS O1;

--Вложенные запросы с подробными и агрегатами по всем и отдельным клиентам
SELECT orderid, custid, val,
	CAST(100. * val /
				(SELECT SUM(O2.val)
				 FROM Sales.OrderValues AS O2
				 WHERE O2.custid=O1.custid) AS NUMERIC(5,2)) AS pctcust,
	val - (SELECT AVG(O2.val)
		   FROM Sales.OrderValues AS O2
		   WHERE O2.custid=O1.custid) AS diffcust,
	CAST(100. * val / 
				(SELECT SUM(O2.val)
				 FROM Sales.OrderValues AS O2) AS NUMERIC(5,2)) AS pctall,
	val - (SELECT AVG(O2.val)
		   FROM Sales.OrderValues AS O2) AS diffall
FROM Sales.OrderValues AS O1;

/*---------------------------------------------*/

SELECT orderid, custid, val,
	CAST(100. * val / SUM(val) OVER(PARTITION BY custid) AS NUMERIC(5,2)) AS pctcust,
	val - AVG(val) OVER(PARTITION BY custid) AS diffcust
FROM Sales.OrderValues

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
WHERE orderdate>='20070101' AND orderdate<'20080101'

SELECT orderid, custid, val,
	CAST(100. * val /
				(SELECT SUM(O2.val)
				 FROM Sales.OrderValues AS O2
				 WHERE O2.custid=O1.custid
				  AND orderdate >= '20070101'
				  AND orderdate < '20080101') AS NUMERIC(5,2)) AS pctcust,
	val - (SELECT AVG(O2.val)
		   FROM Sales.OrderValues AS O2
		   WHERE O2.custid=O1.custid
		    AND orderdate >= '20070101'
			AND orderdate < '20080101') AS diffcust,
	CAST(100. * val / 
				(SELECT SUM(O2.val)
				 FROM Sales.OrderValues AS O2
				 WHERE orderdate >= '20070101'
						AND orderdate < '20080101') AS NUMERIC(5,2)) AS pctall,
	val - (SELECT AVG(O2.val)
		   FROM Sales.OrderValues AS O2
		   WHERE orderdate >= '20070101'
			AND orderdate < '20080101') AS diffall
FROM Sales.OrderValues AS O1
WHERE orderdate >= '20070101' AND orderdate < '20080101'