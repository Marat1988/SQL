USE TSQL2012;

/*Здесь рассматриваются функции агрегирования*/
SELECT orderid, custid, val,
  SUM(val) OVER() AS sumall,
  SUM(val) OVER(PARTITION BY custid) AS sumcust
  FROM Sales.OrderValues

SELECT orderid, custid, val,
  CAST(100. * val / SUM(val) OVER() AS NUMERIC(5,2)) AS pctall,
  CAST(100. * val / SUM(val) OVER(PARTITION BY custid) AS NUMERIC(5,2)) AS pctcust
  FROM Sales.OrderValues AS O1


SELECT empid, ordermonth, qty,
  SUM(qty) OVER(PARTITION BY empid
				ORDER BY ordermonth
				ROWS BETWEEN UNBOUNDED PRECEDING
						 AND CURRENT ROW) AS runqty
  FROM Sales.EmpOrders

SELECT empid, ordermonth,
	MAX(qty) OVER(PARTITION BY empid
				  ORDER BY ordermonth
				  ROWS BETWEEN 1 PRECEDING
						   AND 1 PRECEDING) AS prvqty,
	qty AS curqty,
	MAX(qty) OVER(PARTITION BY empid
				  ORDER BY ordermonth
				  ROWS BETWEEN 1 FOLLOWING
						   AND 1 FOLLOWING) AS nxtqty,
	AVG(qty) OVER(PARTITION BY empid
				  ORDER BY ordermonth
				  ROWS BETWEEN 1 PRECEDING
						   AND 1 FOLLOWING) AS avgqty
  FROM Sales.EmpOrders

