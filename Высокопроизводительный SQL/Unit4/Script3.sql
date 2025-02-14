SELECT actid, tranid, val,
  ROW_NUMBER() OVER(PARTITION BY actid ORDER BY val) AS rownum
  FROM dbo.Transactions

SELECT actid, tranid, val,
  ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS rownum
  FROM dbo.Transactions


SELECT actid, tranid, val,
  NTILE(100) OVER(PARTITION BY actid ORDER BY val) AS rownun
  FROM dbo.Transactions


SELECT actid, tranid, val,
  RANK() OVER(PARTITION BY actid ORDER BY val) AS rownum
  FROM dbo.Transactions


SELECT actid, tranid, val,
  DENSE_RANK() OVER(PARTITION BY actid ORDER BY val) as rownum
  FROM dbo.Transactions