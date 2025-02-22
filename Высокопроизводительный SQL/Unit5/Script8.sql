CREATE INDEX idx_custid_empid ON Sales.Orders(custid, empid);

SELECT custid, empid, COUNT(*) AS cnt
  FROM Sales.Orders
 GROUP BY custid, empid;


WITH C AS
(
  SELECT custid, empid, COUNT(*) AS cnt,
    ROW_NUMBER() OVER(PARTITION BY custid
                      ORDER BY COUNT(*) DESC, empid DESC) AS rn
    FROM Sales.Orders
   GROUP BY custid, empid
)

SELECT custid, empid, cnt
  FROM C
 WHERE rn=1;

WITH C AS
(
  SELECT custid, empid, COUNT(*) AS cnt,
    RANK() OVER(PARTITION BY custid
                ORDER BY COUNT(*) DESC) AS rn
    FROM Sales.Orders
   GROUP BY custid, empid
)

SELECT custid, empid, cnt
  FROM C
 WHERE rn=1;

WITH C AS
(
  SELECT custid,
    STR(COUNT(*), 10)+STR(empid, 10) COLLATE Latin1_General_BIN2 AS cntemp
    FROM Sales.Orders
   GROUP BY custid, empid
)
SELECT custid,
  CAST(SUBSTRING(MAX(cntemp), 11, 10) AS INT) AS empid,
  CAST(SUBSTRING(MAX(cntemp), 1, 10) AS INT) AS cnt
  FROM C
 GROUP BY custid;

DROP INDEX idx_custid_empid ON Sales.Orders;