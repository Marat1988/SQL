IF OBJECT_ID('dbo.MySequence','U') IS NOT NULL
  DROP TABLE dbo.MySequence;

CREATE TABLE dbo.MySequence
(
	val INT
)
INSERT INTO dbo.MySequence VALUES (0);
GO

IF OBJECT_ID('dbo.GetSequence','P') IS NOT NULL
  DROP PROC dbo.GetSequence;
GO

CREATE PROCEDURE dbo.GetSequence
  @val AS INT OUTPUT
AS
  UPDATE dbo.MySequence
     SET @val=val+=1;
GO



DECLARE @key AS INT;
EXEC dbo.GetSequence @val=@key OUTPUT
SELECT @key;
GO

ALTER PROCEDURE dbo.GetSequence
  @val AS INT OUTPUT,
  @n   AS INT = 1
AS
  UPDATE dbo.MySequence
     SET @val=val+1,
     val+=@n;
GO

SELECT custid
  FROM Sales.Customers
 WHERE country=N'Великобритания';


DECLARE @firstkey AS INT,
        @rc       AS INT;

DECLARE @CustsStage AS TABLE
(
  custid INT,
  rownum INT
);

INSERT INTO @CustsStage(custid, rownum)
  SELECT custid, ROW_NUMBER() OVER(ORDER BY (SELECT NULL))
    FROM Sales.Customers
   WHERE country=N'Великобритания';

SET @rc=@@ROWCOUNT;

EXEC dbo.GetSequence @val=@firstkey OUTPUT,
                     @n=@rc;
SELECT custid, @firstkey+rownum-1 AS keycol
  FROM @CustsStage;

IF OBJECT_ID('dbo.GetSequence','P') IS NOT NULL
  DROP PROC dbo.GetSequence;

IF OBJECT_ID('dbo.MySequence','U') IS NOT NULL
  DROP TABLE dbo.MySequence;