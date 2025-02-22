SELECT actid, tranid, val,
  SUM(val) OVER(PARTITION BY actid
                ORDER BY tranid
                ROWS BETWEEN UNBOUNDED PRECEDING
                         AND CURRENT ROW) AS balance
  FROM dbo.Transactions;

SELECT T1.actid, T1.tranid, T1.val,
  SUM(T2.val) AS balance
  FROM dbo.Transactions AS T1
    JOIN dbo.Transactions AS T2
      ON T2.actid=T1.actid
     AND T2.tranid<=T1.tranid
 GROUP BY T1.actid, T1.tranid, T1.val;


EXEC sp_configure 'show advanced options', 1
RECONFIGURE;
EXEC sp_configure 'clr strict security', 0;
RECONFIGURE;

CREATE ASSEMBLY AccountBalances FROM 'C:\AccountBalances\AccountBalances.dll';
GO

CREATE PROCEDURE dbo.AccountBalances
AS EXTERNAL NAME AccountBalances.StoredProcedures.AccountBalances;
GO

EXEC dbo.AccountBalances;
GO

DROP PROCEDURE dbo.AccountBalances;
DROP ASSEMBLY AccountBalances;


SELECT actid, tranid, val,
  ROW_NUMBER() OVER(PARTITION BY actid
                    ORDER BY tranid) AS rownum
  INTO #Transactions
  FROM dbo.Transactions;

CREATE UNIQUE CLUSTERED INDEX idx_rownum_actid ON #Transactions(rownum, actid);

WITH C AS
(
  SELECT 1 AS rownum, actid, tranid, val, val AS sumqty
    FROM #Transactions
   WHERE rownum=1
   UNION ALL
   SELECT PRV.rownum+1, PRV.actid, PRV.tranid, CUR.val, PRV.sumqty+CUR.val
     FROM C AS PRV
       JOIN #Transactions AS CUR
         ON CUR.rownum=PRV.rownum+1
         AND CUR.actid=PRV.actid
)
SELECT actid, tranid, val, sumqty
  FROM C
  OPTION (MAXRECURSION 0);
GO

CREATE TABLE #Transactions
(
  actid   INT,
  tranid  INT,
  val     MONEY,
  balance MONEY
)

CREATE CLUSTERED INDEX idx_actid_tranid ON #Transactions(actid, tranid);

INSERT INTO #Transactions WITH (TABLOCK)(actid, tranid, val, balance)
  SELECT actid, tranid, val, 0.00
    FROM dbo.Transactions
   ORDER BY actid, tranid;

DECLARE @prevaccount AS INT,
        @prevbalance AS MONEY;

UPDATE #Transactions
   SET @prevbalance=balance=CASE
                              WHEN actid=@prevaccount
                                THEN @prevbalance+val
                              ELSE val
                            END,
        @prevaccount=actid
  FROM #Transactions WITH(INDEX(1), TABLOCK)
  OPTION (MAXDOP 1);

SELECT *
  FROM #Transactions;

DROP TABLE #Transactions;