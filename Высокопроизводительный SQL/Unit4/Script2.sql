SELECT actid, tranid, val,
  ROW_NUMBER() OVER(PARTITION BY actid ORDER BY val) AS rownum
  FROM dbo.Transactions;


CREATE INDEX idx_actid_val_i_tranid
  ON dbo.Transactions(actid /* P */, val /* O */)
  INCLUDE(tranid /* C*/);

SELECT actid, tranid, val,
  ROW_NUMBER() OVER(ORDER BY actid, val) AS rownum
  FROM dbo.Transactions
 WHERE tranid<1000;

SELECT actid, tranid, val,
  ROW_NUMBER() OVER(ORDER BY actid DESC, val DESC) AS rownum
  FROM dbo.Transactions
 WHERE tranid<1000;

SELECT actid, tranid, val,
  ROW_NUMBER() OVER(PARTITION BY actid ORDER BY val) AS rownum
  FROM dbo.Transactions;

SELECT actid, tranid, val,
  ROW_NUMBER() OVER(PARTITION BY actid ORDER BY val DESC) AS rownum
  FROM dbo.Transactions;

SELECT actid, tranid, val,
  ROW_NUMBER() OVER(PARTITION BY actid ORDER BY val DESC) AS rownum
  FROM dbo.Transactions
 ORDER BY actid DESC;