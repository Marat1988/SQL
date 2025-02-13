USE TSQL2012;

SELECT custid, val,
  RANK() OVER(PARTITION BY custid ORDER BY val) AS rnk
  FROM Sales.OrderValues

DECLARE @val AS NUMERIC(12,2)=1000.00

SELECT custid,
  COUNT(CASE WHEN val < @val THEN 1 END)+1 AS rnk
  FROM Sales.OrderValues
 GROUP BY custid


DECLARE @val AS NUMERIC(12,2)=1000.00

SELECT custid,
  COUNT(DISTINCT CASE WHEN val < @val THEN val END)+1 AS densernk
  FROM Sales.OrderValues
 GROUP BY custid