SET NOCOUNT ON;
USE TSQL2012;

IF OBJECT_ID('dbo.Transactions', 'U') IS NOT NULL DROP TABLE dbo.Transactions;

CREATE TABLE dbo.Transactions
(
  actid  INT   NOT NULL,                -- столбец секционирования
  tranid INT   NOT NULL,                -- столбец упорядочения
  val    MONEY NOT NULL,                -- мера
  CONSTRAINT PK_Transactions PRIMARY KEY(actid, tranid)
);
GO

-- небольшой набор тестовых данных
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

DECLARE
  @num_partitions      AS INT=10,
  @rows_per_partition AS INT=10000;

TRUNCATE TABLE dbo.Transactions;

INSERT INTO dbo.Transactions WITH (TABLOCK) (actid, tranid, val)
  SELECT NP.n, RPP.n,
    (ABS(CHECKSUM(NEWID())%2)-1) * (1+ABS(CHECKSUM(NEWID())%5))
    FROM dbo.GetNums(1, @num_partitions) AS NP
      CROSS JOIN dbo.GetNums(1, @rows_per_partition) AS RPP;

