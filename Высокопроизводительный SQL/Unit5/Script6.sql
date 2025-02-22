WITH C AS
(
  SELECT YEAR(orderdate)  AS orderyear, MONTH(orderdate) AS ordermonth, val
    FROM Sales.OrderValues
)
SELECT *
 FROM C
   PIVOT(SUM(val)
     FOR ordermonth IN ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])) AS P;
GO

WITH C AS
(
  SELECT custid, val,
    ROW_NUMBER() OVER(PARTITION BY custid
                    ORDER BY orderdate DESC, orderid DESC) AS rownum
    FROM Sales.OrderValues
)
SELECT *
  FROM C
    PIVOT (MAX(val)
      FOR rownum IN ([1],[2],[3],[4],[5])) AS P;
GO

WITH C AS
(
  SELECT custid, CAST(orderid AS VARCHAR(11)) AS sorderid,
    ROW_NUMBER() OVER(PARTITION BY custid
                      ORDER BY orderdate DESC, orderid DESC) AS rownum
    FROM Sales.OrderValues
)
SELECT custid, CONCAT([1],
                      ', '+[2],
                      ', '+[3],
                      ', '+[4],
                      ', '+[5]) AS orderids
  FROM C
    PIVOT(MAX(sorderid)
      FOR rownum IN ([1],[2],[3],[4],[5])) AS P;

