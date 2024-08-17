/*По материалам из сайта https://info-comp.ru/obucheniest/530-creating-an-alias-data-type-in-microsoft-sql-server.html*/

CREATE TYPE dbo.MyTestType FROM VARCHAR (100) NULL
GO

/*Создание табличного типа данных*/
CREATE TYPE dbo.MyTestTableType AS TABLE
(
	ProductName VARCHAR(100) NULL,
	Price MONEY NULL
)
GO

CREATE PROCEDURE dbo.MyTestProcedure @TextComment MyTestType, @TmpTable MyTestTableType READONLY
AS
BEGIN
	SELECT TMP.*, @TextComment
	FROM @TmpTable TMP
END
GO

DECLARE @TextComment MyTestType,
		@TestTable MyTestTableType

SET @TextComment = 'Номер заказа 25.'

INSERT INTO @TestTable (ProductName, Price)
VALUES ('Принтер', 100),
	   ('Монитор', 200)

EXEC dbo.MyTestProcedure @TextComment, @TestTable
GO

DROP PROCEDURE dbo.MyTestProcedure
DROP TYPE dbo.MyTestType
DROP TYPE dbo.MyTestTableType
