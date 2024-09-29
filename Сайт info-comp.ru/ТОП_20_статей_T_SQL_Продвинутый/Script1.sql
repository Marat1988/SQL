/*Статья https://info-comp.ru/obucheniest/562-designer-table-values-in-t-sql.html*/

DROP TABLE IF EXISTS dbo.TestTable;
GO

CREATE TABLE dbo.TestTable
(
	ProductId INT NOT NULL,
	ProductName VARCHAR(50) NULL,
	Summa MONEY NULL,
	CONSTRAINT PK_TestTable PRIMARY KEY CLUSTERED (ProductId ASC)
);

INSERT INTO dbo.TestTable (ProductId, ProductName, Summa)
VALUES (1, 'Компьютер', 500),
	   (2, 'Принтер', 300),
	   (3, 'Монитор', 300)
GO
SELECT *
FROM dbo.TestTable

SELECT *
FROM
(
	VALUES (1, 'Компьютер', 500),
		   (2, 'Принтер', 300),
		   (3, 'Монитор', 300)
) AS TmpTable (ProductId, ProductName, Summa)
