SELECT empid, ordermonth, qty,
      SUM(qty) OVER (PARTITION BY empid
					  ORDER BY ordermonth
					  ROWS BETWEEN UNBOUNDED PRECEDING
							   AND CURRENT ROW) AS run_sum_qty,
	  AVG(qty) OVER (PARTITION BY empid
					  ORDER BY ordermonth
					  ROWS BETWEEN UNBOUNDED PRECEDING
							   AND CURRENT ROW) AS run_avg_qty,
	  MIN(qty) OVER (PARTITION BY empid
					  ORDER BY ordermonth
					  ROWS BETWEEN UNBOUNDED PRECEDING
							   AND CURRENT ROW) AS run_min_qty,
	  MAX(qty) OVER (PARTITION BY empid
					  ORDER BY ordermonth
					  ROWS BETWEEN UNBOUNDED PRECEDING
							   AND CURRENT ROW) AS run_max_qty
FROM Sales.EmpOrders