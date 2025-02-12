SELECT custid, orderdate, orderid, val,
  LAG(val) OVER(PARTITION BY custid
				ORDER BY orderdate, orderid) AS prevval,
  LEAD(val) OVER(PARTITION BY custid
				 ORDER BY orderdate, orderid) AS nextval
  FROM Sales.OrderValues

SELECT custid, orderdate, orderid, val,
  LAG(val,3) OVER(PARTITION BY custid
				  ORDER BY orderdate, orderid) AS prev3val
  FROM Sales.OrderValues