CREATE UNIQUE INDEX idx_od_oid_i_cid_eid
  ON Sales.Orders(orderdate, orderid)
  INCLUDE(custid, empid);

DECLARE
  @pagenum  AS INT=3,
  @pagesize AS INT=25;

WITH C AS
(
	SELECT ROW_NUMBER() OVER(ORDER BY orderdate, orderid) AS rownum,
	  orderid, orderdate, custid, empid
	  FROM Sales.Orders
)
SELECT orderid, orderdate, custid, empid
  FROM C
  WHERE rownum BETWEEN (@pagenum-1)*@pagesize+1
                   AND @pagenum*@pagesize;
GO

DECLARE
  @pagenum  INT=3,
  @pagesize INT=25;


SELECT orderid, orderdate, custid, empid
  FROM Sales.Orders
  ORDER BY orderdate, orderid
  OFFSET (@pagenum-1)*@pagesize ROWS FETCH NEXT @pagesize ROWS ONLY;

DROP INDEX idx_od_oid_i_cid_eid ON Sales.Orders;