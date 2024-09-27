/*Статья https://info-comp.ru/obucheniest/617-list-of-columns-in-ms-sql-server-table.html*/

SELECT TABLE_NAME AS [Имя таблицы],
		COLUMN_NAME AS [Имя столбца],
		DATA_TYPE AS [Тип данных столбца],
		IS_NULLABLE AS [Значения NULL]
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name='TestTable'

SELECT T.name AS [Имя таблицы],
		C.name AS [Имя столбца],
		DataType.name AS [Тип данных столбца],
		CASE WHEN c.is_nullable=0 THEN 'NO' ELSE 'YES' END AS [Значение NULL]
FROM sys.tables T
LEFT JOIN sys.columns C ON T.object_id=c.object_id
LEFT JOIN sys.types DataType ON c.user_type_id=DataType.user_type_id
WHERE T.name='TestTable'

EXEC sp_columns TestTable