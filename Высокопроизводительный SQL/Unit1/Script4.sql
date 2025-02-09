SELECT custid, orderid, val,
	RANK() OVER(ORDER BY val DESC) AS rnk_all,
	RANK() OVER(PARTITION BY custid ORDER BY val DESC) AS rnk_cust
FROM Sales.OrderValues


SELECT empid, ordermonth, qty,
	SUM(qty) OVER(PARTITION BY empid
				  ORDER BY ordermonth
				  ROWS BETWEEN UNBOUNDED PRECEDING
						   AND CURRENT ROW) AS runqty
FROM Sales.EmpOrders;