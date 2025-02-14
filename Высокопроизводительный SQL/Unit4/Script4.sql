SELECT actid, tranid, val,
  ROW_NUMBER() OVER(PARTITION BY actid ORDER BY val) AS rownumasc,
  ROW_NUMBER() OVER(PARTITION BY actid ORDER BY val DESC) AS rownumdesc
  FROM dbo.Transactions;


SELECT c.actid, A.*
  FROM dbo.Accounts AS C
    CROSS APPLY (SELECT tranid, val,
	               ROW_NUMBER() OVER(ORDER BY val) AS rownumasc,
				   ROW_NUMBER() OVER(ORDER BY val DESC) AS rownumdesc
	               FROM dbo.Transactions AS T
				  WHERE T.actid=C.actid) AS A