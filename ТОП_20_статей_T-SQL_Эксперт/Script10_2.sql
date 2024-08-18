/*Статья https://info-comp.ru/obucheniest/487-full-text-queries-in-ms-sql-server.html*/

--CONTAINS
SELECT Id, TextData
FROM TestTable
WHERE CONTAINS(TextData, 'Microsoft');

--Строки, содержащие и слово Microsoft, и слово SQL (AND)
SELECT Id, TextData
FROM TestTable
WHERE CONTAINS(TextData, '"Microsoft" AND "SQL"')
GO

--Строки, содержащие слово Microsoft или слово SQL (OR)
SELECT Id, TextData
FROM TestTable
WHERE CONTAINS(TextData, '"Microsoft" OR "SQL"')
GO

--Строки, содержащие слово Microsoft, но которые не содержат слово SQL (AND NOT)
SELECT Id, TextData
FROM TestTable
WHERE CONTAINS(TextData, '"Microsoft" AND NOT "SQL"')
GO

--CONTAINS. Поиск по префиксным выражениям
SELECT Id, TextData
FROM TestTable
WHERE CONTAINS(TextData, '"програм*"')

--CONTAINS. Поиск слова по словоформам
SELECT Id, TextData
FROM TestTable
WHERE CONTAINS(TextData, 'FORMSOF(INFLECTIONAL, "запрос")');
GO

SELECT Id, TextData
FROM TestTable
WHERE CONTAINS(TextData, '"язык программирования" NEAR "Microsoft"');
GO

--CONTAINSTABLE с ограничением строк
SELECT Table1.Id AS [Id],
		RowRank.Rank AS [RANK],
		Table1.TextData AS [TextData]
FROM TestTable AS Table1
INNER JOIN CONTAINSTABLE(TestTable, TextData, '"SQL" OR "Microsoft"') AS RowRank ON Table1.Id=RowRank.[KEY]
ORDER BY RowRank.RANK DESC;

SELECT Table1.Id AS [Id],
		RowRank.Rank AS [RANK],
		Table1.TextData AS [TextData]
FROM TestTable AS Table1
INNER JOIN CONTAINSTABLE(TestTable, TextData, '"SQL" OR "Microsoft"', 3) AS RowRank ON Table1.Id=RowRank.[KEY]
ORDER BY RowRank.RANK DESC;
GO

SELECT Table1.Id AS [Id],
		RowRank.Rank AS [RANK],
		Table1.TextData AS [TextData]
FROM TestTable Table1
INNER JOIN CONTAINSTABLE(TestTable, TextData, 'ISABOUT("SQL" WEIGHT(.9), "Microsoft" WEIGHT(.1))') AS RowRank ON Table1.Id=RowRank.[KEY]
ORDER BY RowRank.RANK DESC;
GO

--FREETEXT
SELECT Id, TextData
FROM TestTable
WHERE FREETEXT(TextData, 'Языки для разработки программ');
GO

--FREETEXTTABLE
SELECT Table1.Id AS [Id],
		RowRank.Rank AS [RANK],
		Table1.TextData AS [TextData]
FROM TestTable Table1
INNER JOIN FREETEXTTABLE(TestTable, TextData, 'Языки для разработки программ') AS RowRank ON Table1.Id=RowRank.[KEY]
ORDER BY RowRank.RANK DESC;

SELECT CASE
	   WHEN FULLTEXTCATALOGPROPERTY('TestCatalog', 'PopulateStatus') = 0 THEN 'Бездействие'
	   WHEN FULLTEXTCATALOGPROPERTY('TestCatalog', 'PopulateStatus') = 1 THEN 'Идет полное заполнение'
	   WHEN FULLTEXTCATALOGPROPERTY('TestCatalog', 'PopulateStatus') = 2 THEN 'Пауза'
	   WHEN FULLTEXTCATALOGPROPERTY('TestCatalog', 'PopulateStatus') = 3 THEN 'Ограниченные режим'
	   WHEN FULLTEXTCATALOGPROPERTY('TestCatalog', 'PopulateStatus') = 4 THEN 'Восстановление'
	   WHEN FULLTEXTCATALOGPROPERTY('TestCatalog', 'PopulateStatus') = 5 THEN 'Выключение'
	   WHEN FULLTEXTCATALOGPROPERTY('TestCatalog', 'PopulateStatus') = 6 THEN 'Идет добавочное заполнение'
	   WHEN FULLTEXTCATALOGPROPERTY('TestCatalog', 'PopulateStatus') = 7 THEN 'Построение индекса'
	   WHEN FULLTEXTCATALOGPROPERTY('TestCatalog', 'PopulateStatus') = 8 THEN 'Диск заполнен. Приостановлено'
	   WHEN FULLTEXTCATALOGPROPERTY('TestCatalog', 'PopulateStatus') = 9 THEN 'Отслеживание изменений'
ELSE '' END AS [Статус]

SELECT OBJECTPROPERTYEX(OBJECT_ID('TestTable'), 'TableHasActiveFulltextIndex') AS [Активный полнотекстовый индекс(TRUE/FALSE)],
	   OBJECTPROPERTYEX(OBJECT_ID('TestTable'), 'TableFulltextChangeTrackingOn') AS [Полнотекстовое отслеживание изменений(TRUE/FALSE)],
	   OBJECTPROPERTYEX(OBJECT_ID('TestTable'), 'TableFulltextCatalogId') AS [Идентификатор полнотекстового каталога]
