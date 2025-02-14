SELECT actid, tranid, val,
  MAX(val) OVER(PARTITION BY actid) AS mx
  FROM dbo.Transactions;

WITH C AS
(
	SELECT actid, tranid, val,
	  MAX(val) OVER(PARTITION BY actid) AS mx
	  FROM dbo.Transactions
)

SELECT actid, tranid, val
  FROM C
 WHERE val=mx;

WITH Aggs AS
(
	SELECT actid, MAX(val) AS mx
	  FROM dbo.Transactions
	 GROUP BY actid
)
SELECT T.actid, T.tranid, T.val, A.mx
  FROM dbo.Transactions AS T
  JOIN Aggs AS A
    ON T.actid=A.actid;

WITH Aggs AS
(
	SELECT actid, MAX(val) AS mx
	  FROM dbo.Transactions
	 GROUP BY actid
)
SELECT T.actid, T.tranid, T.val
  FROM dbo.Transactions AS T
    JOIN Aggs AS A
	  ON T.actid=A.actid
	 AND T.val=A.mx;