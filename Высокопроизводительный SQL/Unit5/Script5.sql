IF OBJECT_ID('Sales.MyOrders') IS NOT NULL
  DROP TABLE Sales.MyOrders;

SELECT *
  INTO Sales.MyOrders
  FROM Sales.Orders
 UNION ALL
SELECT *
  FROM Sales.Orders
 UNION ALL
SELECT *
  FROM Sales.Orders;

SELECT orderid,
  ROW_NUMBER() OVER(PARTITION BY orderid
					ORDER BY (SELECT NULL)) AS n
  FROM Sales.MyOrders;

WITH C AS
(
  SELECT orderid,
    ROW_NUMBER() OVER(PARTITION BY orderid
                      ORDER BY (SELECT NULL)) AS N
    FROM Sales.MyOrders
)
DELETE FROM C
 WHERE n>1;
GO
WITH C AS
(
  SELECT *,
    ROW_NUMBER() OVER(PARTITION BY orderid
                      ORDER BY (SELECT NULL)) AS n
    FROM Sales.MyOrders
)

SELECT orderid,custid,empid,orderdate,requireddate,shippeddate,shipperid,freight,
  shipname,shipaddress,shipcity,shipregion,shippostalcode,shipcountry
  INTO Sales.OrdersTmp
  FROM C
WHERE n=1;

DROP TABLE Sales.MyOrders;
EXEC sp_rename 'Sales.OrdersTmp','MyOrders';
--воссоздание индексов, ограничений, триггеров
GO


WITH C AS
(
  SELECT orderid,
    ROW_NUMBER() OVER(ORDER BY orderid) AS rownum,
    RANK() OVER(ORDER BY orderid) AS rnk
    FROM Sales.MyOrders
)
DELETE FROM C
 WHERE rownum<>rnk;

IF OBJECT_ID('Sales.MyOrders') IS NOT NULL
  DROP TABLE Sales.MyOrders;