SELECT actid, tranid, val,
  SUM(val) OVER(PARTITION BY actid
				ORDER BY tranid
				ROWS BETWEEN 5 PRECEDING
				         AND 2 PRECEDING) AS sumval
  FROM dbo.Transactions;

SELECT actid, tranid, val,
  MAX(val) OVER(PARTITION BY actid
				ORDER BY tranid
				ROWS BETWEEN 100 PRECEDING
				         AND 2 PRECEDING) AS maxval
  FROM dbo.Transactions;

SELECT C.actid, A.*
  FROM dbo.Accounts AS C
    CROSS APPLY (SELECT tranid, val,
	               MAX(val) OVER(ORDER BY tranid
				                 ROWS BETWEEN 100 PRECEDING
										  AND 2 PRECEDING) AS maxval
	               FROM dbo.Transactions AS T
				   WHERE T.actid=C.actid) AS A;


SET STATISTICS IO ON;

SELECT actid, tranid, val,
  MAX(val) OVER(PARTITION BY actid
                ORDER BY tranid
				ROWS BETWEEN 9999 PRECEDING
				         AND 9999 PRECEDING) AS maxval
  FROM dbo.Transactions;

SELECT actid, tranid, val,
  MAX(val) OVER(PARTITION BY actid
                ORDER BY tranid
				ROWS BETWEEN 1000 PRECEDING
				         AND 1000 PRECEDING)
  FROM dbo.Transactions;

SET STATISTICS IO OFF;

CREATE EVENT SESSION xe_window_spool ON SERVER
ADD EVENT sqlserver.window_spool_ondisk_warning
(
	ACTION
	(
		sqlserver.plan_handle, sqlserver.sql_text
	)
)
ADD TARGET package0.asynchronous_file_target
(
	SET FILENAME=N'c:\logs\xe_xe_window_spool.xel',
		metadatafile=N'c:\logs\xe_xe_window_spool.xem'
)

ALTER EVENT SESSION xe_window_spool ON SERVER STATE=START;

DROP EVENT SESSION xe_window_spool ON SERVER;