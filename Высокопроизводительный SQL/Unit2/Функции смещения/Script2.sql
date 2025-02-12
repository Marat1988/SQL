SELECT custid, orderdate, orderid, val,
  FIRST_VALUE(val) OVER(PARTITION BY custid
						ORDER BY orderdate, orderid) AS firstorder,
  LAST_VALUE(val)  OVER(PARTITION BY custid
						ORDER BY orderdate, orderid
						ROWS BETWEEN CURRENT ROW
								 AND UNBOUNDED FOLLOWING) AS val_lastorder
  FROM Sales.OrderValues;

SELECT custid, orderdate, orderid, val,
  val - FIRST_VALUE(val) OVER(PARTITION BY custid
							  ORDER BY orderdate, orderid) AS difffirst,
  val - LAST_VALUE(val)  OVER(PARTITION BY custid
							  ORDER BY orderdate, orderid
							  ROWS BETWEEN CURRENT ROW
									   AND UNBOUNDED FOLLOWING) AS difflast
  FROM Sales.OrderValues;

