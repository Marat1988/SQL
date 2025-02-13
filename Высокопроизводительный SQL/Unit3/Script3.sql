DECLARE @val AS NUMERIC(12,2)=1000

SELECT custid, rnk, densernk
  FROM Sales.Customers AS P
    CROSS APPLY (SELECT
                   RANK() OVER(ORDER BY val) AS rnk,
                   DENSE_RANK() OVER(ORDER BY val) AS densernk,
                   return_flag
                   FROM (SELECT val, 0 AS return_flag
                           FROM Sales.OrderValues AS D
                          WHERE D.custid=P.custid
                          UNION ALL
                          SELECT @val, 1) AS U) AS A
 WHERE return_flag = 1;


DECLARE @score AS TINYINT=80;

SELECT testid, pctrank, cumedist
  FROM Stats.Scores AS P
    CROSS APPLY (SELECT
                   PERCENT_RANK() OVER(ORDER BY score) AS pctrank,
                   CUME_DIST() OVER(ORDER BY score) AS cumedist,
                   return_flag
                   FROM (SELECT score, 0 AS return_flag
                           FROM Stats.Scores AS D
                          WHERE D.testid=P.testid
                          UNION ALL
                          SELECT @score, 1) AS U) AS A
 WHERE return_flag = 1;



DECLARE @val AS NUMERIC(12,2)=1000

SELECT custid, rnk, densernk
  FROM Sales.Customers AS P
    CROSS APPLY (SELECT
                   RANK() OVER(ORDER BY val) AS rnk,
                   DENSE_RANK() OVER(ORDER BY val) AS densernk,
                   return_flag
                   FROM (SELECT val, 0 AS return_flag
                           FROM Sales.OrderValues AS D
                          WHERE D.custid=P.custid
                          UNION ALL
                          SELECT @val, 1) AS U) AS A
 WHERE return_flag = 1
   AND EXISTS
     (SELECT *
        FROM Sales.OrderValues AS D
        WHERE D.custid=P.custid)