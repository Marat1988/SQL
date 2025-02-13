SELECT custid,
  COALESCE
  (
     STUFF
     (
        (SELECT ',' + CAST(orderid AS VARCHAR(10)) AS [text()]
           FROM Sales.Orders AS O
          WHERE O.custid=C.custid
          ORDER BY orderid
          FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,1,''
     ),''
  )
  FROM Sales.Customers AS C;