SELECT actid, tranid, val,
  SUM(val) OVER(PARTITION BY actid
				ORDER BY tranid
				ROWS BETWEEN UNBOUNDED PRECEDING
				         AND CURRENT ROW) AS balance
  FROM dbo.Transactions



  SET STATISTICS IO ON
SELECT actid, tranid, val,
  SUM(val) OVER(PARTITION BY actid
				ORDER BY tranid
				RANGE BETWEEN UNBOUNDED PRECEDING
						  AND CURRENT ROW) AS balance
  FROM dbo.Transactions;

  SELECT actid, tranid, val,
  SUM(val) OVER(PARTITION BY actid
				ORDER BY tranid) AS balance
  FROM dbo.Transactions;


  SELECT c.actid, A.*
    FROM dbo.Accounts AS C
	  CROSS APPLY (SELECT tranid, val,
	                 SUM(val) OVER(ORDER BY tranid
								   RANGE BETWEEN UNBOUNDED PRECEDING
											 AND CURRENT ROW) AS balance
	                 FROM dbo.Transactions AS T
					 WHERE T.actid=C.actid) AS A;