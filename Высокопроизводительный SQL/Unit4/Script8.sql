SELECT actid, tranid, val,
  SUM(val) OVER(PARTITION BY actid
				ORDER BY tranid
				ROWS BETWEEN 100 PRECEDING
				         AND 2 PRECEDING) AS sumval
FROM dbo.Transactions;


SELECT C.actid, A.*
  FROM dbo.Accounts AS C
    CROSS APPLY (SELECT tranid, val, SUM(val) OVER(ORDER BY tranid
												   ROWS BETWEEN 100 PRECEDING
															AND 2 PRECEDING) AS sumval
	               FROM dbo.Transactions AS T
				   WHERE T.actid=C.actid) AS A;