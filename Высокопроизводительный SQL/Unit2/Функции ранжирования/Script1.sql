SELECT orderid, val,
  ROW_NUMBER() OVER(ORDER BY orderid) AS rownum
  FROM Sales.OrderValues
ORDER BY val DESC


SELECT orderid, val,
  COUNT(*) OVER(ORDER BY orderid
				ROWS BETWEEN UNBOUNDED PRECEDING
				        AND CURRENT ROW) AS rownum
  FROM Sales.OrderValues


SELECT orderid, orderdate, val,
  ROW_NUMBER() OVER(ORDER BY orderdate DESC) AS rownum
  FROM Sales.OrderValues

/*Детерминистический*/
SELECT orderid, orderdate, val,
  ROW_NUMBER() OVER(ORDER BY orderdate DESC, orderid DESC) AS rownum
  FROM Sales.OrderValues


CREATE SEQUENCE dbo.Seg1 AS INT START WITH 1 INCREMENT BY 1;
SELECT NEXT VALUE FOR dbo.Seg1;

SELECT orderid, orderdate, val,
  NEXT VALUE FOR dbo.Seg1 AS seqval
  FROM Sales.OrderValues

SELECT orderid, orderdate, val,
  NEXT VALUE FOR dbo.Seg1 OVER(ORDER BY orderdate, orderid) AS seqval
  FROM Sales.OrderValues

SELECT orderid, orderdate, val,
  ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS rownum
  FROM Sales.OrderValues