USE TSQL2012;

SELECT custid, orderid, orderdate, val,
	RANK() OVER(ORDER BY val DESC) AS rnk
FROM Sales.OrderValues
ORDER BY rnk;

WITH Aggregates AS
(
	SELECT custid, SUM(val) AS sumval, AVG(val) AS avgval
	  FROM Sales.OrderValues
	 GROUP BY custid
),
GrandAggregates AS
(
	SELECT SUM(val) AS sumval, AVG(val) AS avgval
	  FROM Sales.OrderValues
)

SELECT O.orderid, O.custid, O.val,
	CAST(100. * O.val / A.sumval AS NUMERIC(5,2)) AS pctcust,
	O.val - A.avgval AS diffcust,
	CAST(100. * O.val / GA.sumval AS NUMERIC(5,2)) AS pctall,
	O.val - GA.avgval AS diffall
FROM Sales.OrderValues AS O
  JOIN Aggregates AS A
    ON O.custid=A.custid
  CROSS JOIN GrandAggregates  AS GA;

-- Вложенные запросы с подробными данными и агрегатами по отдельным клиентам
SELECT orderid, custid, val,
    CAST(100. * val /
        (SELECT SUM(O2.val)
         FROM Sales.OrderValues AS O2
         WHERE O2.custid = O1.custid) AS NUMERIC(5, 2)) AS pctcust,
    val - (SELECT AVG(O2.val)
         FROM Sales.OrderValues AS O2
         WHERE O2.custid = O1.custid) AS diffcust
FROM Sales.OrderValues AS O1;

-- Вложенные запросы с подробными данными и агрегатами по всем и отдельным клиентам
SELECT orderid, custid, val,
    CAST(100. * val /
        (SELECT SUM(O2.val)
         FROM Sales.OrderValues AS O2
         WHERE O2.custid = O1.custid) AS NUMERIC(5, 2)) AS pctcust,
    val - (SELECT AVG(O2.val)
         FROM Sales.OrderValues AS O2
         WHERE O2.custid = O1.custid) AS diffcust,
    CAST(100. * val /
        (SELECT SUM(O2.val)
         FROM Sales.OrderValues AS O2) AS NUMERIC(5, 2)) AS pctall,
    val - (SELECT AVG(O2.val)
         FROM Sales.OrderValues AS O2) AS diffall
FROM Sales.OrderValues AS O1;