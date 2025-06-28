USE TSQLV5;

SELECT orderid, custid, val,
	RANK() OVER(PARTITION BY custid ORDER BY val) AS rnk
  FROM Sales.OrderValues;

DECLARE @val AS NUMERIC(12,2)=1000.00

SELECT custid,
	COUNT(DISTINCT CASE WHEN val < @val THEN val END) AS densernk
  FROM Sales.OrderValues
 GROUP BY custid


 DECLARE @score AS TINYINT=80;

SELECT testid,
	PERCENT_RANK(@score) WITHIN GROUP(ORDER BY score) AS pctrank
  FROM Status.Scores;


DECLARE @pct AS FLOAT=0.5

SELECT DISTINCT testid,
	PERCENTILE_DISC(@pct) WITHIN GROUP(ORDER BY score) OVER(PARTITION BY testid) AS percentiledisc,
	PERCENTILE_CONT(@pct) WITHIN GROUP (ORDER BY score) OVER(PARTITION BY testid) AS percentilecont
  FROM Stats.Scores;

SELECT custid, orderdate, orderid, val,
	FIRST_VALUE(val) OVER(PARTITION BY custid
			ORDER BY orderdate, orderid
			ROWS BETWEEN UNBOUNDED PRECEDING
				AND CURRENT ROW) AS val_firstorder,
	LAST_VALUE(val) OVER(PARTITION BY custid
			ORDER BY orderdate, orderid
			ROWS BETWEEN CURRENT ROW
				AND UNBOUNDED FOLLOWING) AS val_lastorder
  FROM Sales.OrderValues;


WITH C AS
(
  SELECT custid,
	CONVERT(CHAR(8), orderdate, 112)
			+CASE SIGN(orderid) WHEN -1 THEN '0' ELSE '1' END --отрицательные идут первыми
			+STR(CASE SIGN(orderid)
				WHEN -1 THEN 2147483648 --если отрицательное, добавьте ABS(минимум)
				ELSE 0
				END + orderid, 10)
			+STR(val, 14, 2)
			COLLATE Latin1_General_BIN2 AS s
  FROM Sales.OrderValues
)

SELECT custid,
	CAST(SUBSTRING(MIN(s),20,14) AS NUMERIC(12,2)) AS firstorderval,
	CAST(SUBSTRING(MAX(s),20,14) AS NUMERIC(12,2)) AS lastorderval
  FROM C
 GROUP BY custid

 SELECT custid,
	STRING_AGG(orderid,',') WITHIN GROUP(ORDER BY orderid) AS custorders
   FROM Sales.Orders
 GROUP BY custid;

SELECT custid,
	STRING_AGG(orderid,',') AS custorders
  FROM Sales.Orders
 GROUP BY custid;