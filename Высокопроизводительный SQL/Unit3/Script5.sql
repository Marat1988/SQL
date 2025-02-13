SELECT custid, orderdate, orderid, val,
  FIRST_VALUE(val) OVER(PARTITION BY custid
						ORDER BY orderdate, orderid) AS val_firstorder,
  LAST_VALUE(val) OVER(PARTITION BY custid
					   ORDER BY orderdate, orderid
					   ROWS BETWEEN CURRENT ROW
					            AND UNBOUNDED FOLLOWING) AS val_lastorder
  FROM Sales.OrderValues;

WITH C AS
(
	SELECT custid,
	  FIRST_VALUE(val) OVER(PARTITION BY custid
							ORDER BY orderdate, orderid) AS val_firstorder,
	  LAST_VALUE(val) OVER(PARTITION BY custid
						   ORDER BY orderdate, orderid
						   ROWS BETWEEN CURRENT ROW
									AND UNBOUNDED FOLLOWING) AS val_lastorder,
	  ROW_NUMBER() OVER(PARTITION BY custid ORDER BY (SELECT NULL)) AS rownum
	  FROM Sales.OrderValues
)
SELECT custid, val_firstorder, val_lastorder
  FROM C
 WHERE rownum=1

WITH C AS
(
	SELECT custid,
	  CONVERT(CHAR(8), orderdate, 112)
      +STR(orderid,10)
	  +STR(val,14,2)
	  COLLATE Latin1_General_BIN2 AS s
      FROM Sales.OrderValues
)
SELECT custid,
  CAST(SUBSTRING(MIN(s),19,14) AS NUMERIC(12,2)) AS firstorderval,
  CAST(SUBSTRING(MAX(s),19,14) AS NUMERIC(12,2)) AS lastorderval
  FROM C
 GROUP BY custid;