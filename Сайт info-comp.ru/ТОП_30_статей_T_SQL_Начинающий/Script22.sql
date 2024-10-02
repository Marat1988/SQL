/*Статья https://info-comp.ru/programmirovanie/575-index-basics-in-ms-sql-server.html*/

DROP TABLE IF EXISTS TestTable;
GO

CREATE TABLE TestTable
(
	ProductId INT IDENTITY(1,1) NOT NULL,
	ProductName VARCHAR(50) NOT NULL,
	CategoryId INT NULL
);
GO

CREATE UNIQUE INDEX IX_Clustered ON TestTable
(
	ProductId ASC
);
GO

CREATE NONCLUSTERED INDEX IX_NonClustered ON TestTable
(
	CategoryID ASC
)
INCLUDE (ProductName)
GO

DROP INDEX IX_NonClustered ON TestTable

SELECT OBJECT_NAME(T1.object_id) AS Name_Table,
	T1.index_id AS IndexId,
	T2.name AS IndexName,
	t1.avg_fragmentation_in_percent AS Fragmentation
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, NULL) AS T1
LEFT JOIN sys.indexes AS T2 ON T1.object_id=T2.object_id AND T1.index_id=T2.index_id;

ALTER INDEX IX_NonClustered ON TestTable
REORGANIZE
GO

ALTER INDEX IX_NonClustered ON TestTable
REBUILD
GO

CREATE NONCLUSTERED INDEX IX_NonClustered ON TestTable
(
	CategoryId ASC
)
WITH(DROP_EXISTING=ON)