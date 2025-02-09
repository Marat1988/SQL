use TSQL2012;

SELECT orderid, custid, val,
    CAST(100. * val / SUM(val) OVER(PARTITION BY custid) AS NUMERIC(5, 2)) AS pctcust,
    val - AVG(val) OVER(PARTITION BY custid) AS diffcust
FROM Sales.OrderValues;

SELECT orderid, custid, val,
	CAST(100. * val / SUM(val) OVER(PARTITION BY custid) AS NUMERIC(5, 2)) AS pctcust,
	val - AVG(val) OVER(PARTITION BY custid) AS diffcust,
	CAST(100. * val / SUM(val) OVER() AS NUMERIC(5, 2)) AS pctall,
	val - AVG(val) OVER() AS diffall
FROM Sales.OrderValues;

SELECT orderid, custid, val,
  CAST(100.*val/SUM(val) OVER(PARTITION BY custid) AS NUMERIC(5,2)) AS pctcust,
  val - AVG(val) OVER(PARTITION BY custid) AS diffcust,
  CAST(100.*val/SUM(val) OVER() AS NUMERIC(5,2)) AS pctall,
  val-AVG(val) OVER() AS diffall
FROM Sales.OrderValues
WHERE orderdate>='20070101'
  AND orderdate<'20080101';