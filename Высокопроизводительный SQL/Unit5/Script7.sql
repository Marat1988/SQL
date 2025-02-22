CREATE UNIQUE INDEX idx_cid_odD_oidD_i_empid
  ON Sales.Orders(custid, orderdate DESC, orderid DESC)
  INCLUDE(empid);

WITH C AS
(
  SELECT custid, orderdate, orderid, empid,
    ROW_NUMBER() OVER(PARTITION BY custid
                      ORDER BY orderdate DESC, orderid DESC) AS rownum
    FROM Sales.Orders
)

SELECT *
  FROM C
 WHERE rownum<=3
 ORDER BY custid, rownum


SELECT C.custid, A.*
  FROM Sales.Customers AS C
    CROSS APPLY (SELECT *
                   FROM Sales.Orders AS O
                  WHERE O.custid=C.custid
                  ORDER BY orderdate DESC, orderid DESC
                  OFFSET 0 ROWS FETCH FIRST 3 ROWS ONLY) AS A

DROP INDEX idx_cid_odD_oidD_i_empid ON Sales.Orders;


WITH C AS
(
  SELECT custid,
    MAX(CONVERT(CHAR(8), orderdate, 112)
        +STR(orderid, 10)
        +STR(empid, 10) COLLATE Latin1_General_BIN2) AS mx
    FROM Sales.Orders
    GROUP BY custid
)
SELECT custid,
  CAST(SUBSTRING(mx, 1, 8) AS DATETIME) AS orderdate,
  CAST(SUBSTRING(mx, 9, 10) AS INT) AS custid,
  CAST(SUBSTRING(mx, 19, 10) AS INT) AS empid
  FROM C;