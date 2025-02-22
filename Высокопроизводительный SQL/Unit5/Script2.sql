IF OBJECT_ID('Sales.MyOrders','U') IS NOT NULL
  DROP TABLE Sales.MyOrders;
GO

SELECT 0 AS orderid, custid, empid, orderdate
  INTO Sales.MyOrders
  FROM Sales.Orders;
GO

SELECT *
  FROM Sales.MyOrders;
GO

WITH C AS
(
	SELECT orderid, ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS rownum
	  FROM Sales.MyOrders
)
UPDATE C
   SET orderid=rownum;

SELECT *
  FROM Sales.MyOrders;