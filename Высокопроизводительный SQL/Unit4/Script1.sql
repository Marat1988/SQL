SET NOCOUNT ON;
USE TSQL2012;

IF OBJECT_ID('dbo.Transactions', 'U') IS NOT NULL DROP TABLE dbo.Transactions;
IF OBJECT_ID('dbo.Accounts', 'U') IS NOT NULL DROP TABLE dbo.Accounts;

CREATE TABLE dbo.Accounts
(
  actid   INT         NOT NULL,
  actname VARCHAR(50) NOT NULL,
  CONSTRAINT PK_Accounts PRIMARY KEY(actid)
);

CREATE TABLE dbo.Transactions
(
  actid  INT   NOT NULL,
  tranid INT   NOT NULL,
  val    MONEY NOT NULL,
  CONSTRAINT PK_Transactions PRIMARY KEY(actid, tranid),
  CONSTRAINT FK_Transactions_Accounts
    FOREIGN KEY(actid)
    REFERENCES dbo.Accounts(actid)
);

INSERT INTO dbo.Accounts(actid, actname) VALUES
  (1,  'account 1'),
  (2,  'account 2'),
  (3,  'account 3');

INSERT INTO dbo.Transactions(actid, tranid, val) VALUES
  (1,  1,  4.00),
  (1,  2, -2.00),
  (1,  3,  5.00),
  (1,  4,  2.00),
  (1,  5,  1.00),
  (1,  6,  3.00),
  (1,  7, -4.00),
  (1,  8, -1.00),
  (1,  9, -2.00),
  (1, 10, -3.00),
  (2,  1,  2.00),
  (2,  2,  1.00),
  (2,  3,  5.00),
  (2,  4,  1.00),
  (2,  5, -5.00),
  (2,  6,  4.00),
  (2,  7,  2.00),
  (2,  8, -4.00),
  (2,  9, -5.00),
  (2, 10,  4.00),
  (3,  1, -3.00),
  (3,  2,  3.00),
  (3,  3, -2.00),
  (3,  4,  1.00),
  (3,  5,  4.00),
  (3,  6, -1.00),
  (3,  7,  5.00),
  (3,  8,  3.00),
  (3,  9,  5.00),
  (3, 10, -3.00);

IF OBJECT_ID('dbo.GetNums', 'IF') IS NOT NULL DROP FUNCTION dbo.GetNums;
GO
CREATE FUNCTION dbo.GetNums(@low AS BIGINT, @high AS BIGINT) RETURNS TABLE
AS
RETURN
  WITH
    L0   AS (SELECT c FROM (VALUES(1),(1)) AS D(c)),
    L1   AS (SELECT 1 AS c FROM L0 AS A CROSS JOIN L0 AS B),
    L2   AS (SELECT 1 AS c FROM L1 AS A CROSS JOIN L1 AS B),
    L3   AS (SELECT 1 AS c FROM L2 AS A CROSS JOIN L2 AS B),
    L4   AS (SELECT 1 AS c FROM L3 AS A CROSS JOIN L3 AS B),
    L5   AS (SELECT 1 AS c FROM L4 AS A CROSS JOIN L4 AS B),
    Nums AS (SELECT ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS rownum
            FROM L5)
  SELECT @low + rownum - 1 AS n
  FROM Nums
  ORDER BY rownum
  OFFSET 0 ROWS FETCH FIRST @high - @low + 1 ROWS ONLY;
GO


DECLARE
  @num_partitions     AS INT = 100,
  @rows_per_partition AS INT = 20000;

TRUNCATE TABLE dbo.Transactions;
DELETE FROM dbo.Accounts;

INSERT INTO dbo.Accounts WITH (TABLOCK) (actid, actname)
  SELECT n AS actid, 'account ' + CAST(n AS VARCHAR(10)) AS actname
  FROM dbo.GetNums(1, @num_partitions) AS P;

INSERT INTO dbo.Transactions WITH (TABLOCK) (actid, tranid, val)
  SELECT NP.n, RPP.n,
    (ABS(CHECKSUM(NEWID())%2)*2-1) * (1 + ABS(CHECKSUM(NEWID())%5))
  FROM dbo.GetNums(1, @num_partitions) AS NP
    CROSS JOIN dbo.GetNums(1, @rows_per_partition) AS RPP;