SELECT orderid, val,
  ROW_NUMBER() OVER(ORDER BY val) AS rownum,
  NTILE(10) OVER(ORDER BY val) AS tile
  FROM Sales.OrderValues

SELECT orderid, orderdate, val,
  ROW_NUMBER() OVER(ORDER BY orderdate DESC) AS rownum,
  RANK()       OVER(ORDER BY orderdate DESC) AS rnk,
  DENSE_RANK() OVER(ORDER BY orderdate DESC) AS drnk
  FROM Sales.OrderValues