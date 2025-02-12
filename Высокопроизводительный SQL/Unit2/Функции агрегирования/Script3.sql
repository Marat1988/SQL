WITH C AS
(
    SELECT empid, orderdate, orderid, custid, val,
      CASE
        WHEN ROW_NUMBER() OVER(PARTITION BY empid, custid
                               ORDER BY orderdate)=1
          THEN custid
      END AS distinct_custid
      FROM Sales.OrderValues
)
SELECT empid, orderdate, orderid, val,
  COUNT(distinct_custid) OVER(PARTITION BY empid
                              ORDER BY orderdate) AS numcusts
  FROM C;

SELECT empid,
  SUM(val) AS emptotal,
  SUM(val) / SUM(SUM(val)) OVER() * 100. AS pct
  FROM Sales.OrderValues
 GROUP BY empid;


WITH C AS
(
    SELECT empid, orderdate,
      CASE
        WHEN ROW_NUMBER() OVER(PARTITION BY empid, custid
                               ORDER BY orderdate)=1
          THEN custid
      END AS distinct_custid
      FROM Sales.Orders
)
SELECT empid, orderdate,
  SUM(COUNT(distinct_custid)) OVER(PARTITION BY empid
                                   ORDER BY orderdate) AS numcusts
  FROM C
 GROUP BY empid, orderdate;