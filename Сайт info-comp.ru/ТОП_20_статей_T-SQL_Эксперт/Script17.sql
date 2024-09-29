/*https://info-comp.ru/obucheniest/596-save-result-stored-procedure-in-table.html*/

CREATE PROCEDURE sp_Test
AS
SELECT *
FROM (VALUES (1, 'Компьютер', 500),
			 (2, 'Принтер', 300),
			 (3, 'Монитор', 300)) AS TmpTable (ProductId, ProductName, Summa)
GO

EXEC sp_Test

--Создаем веременную таблицу
CREATE TABLE #TmpTable
(
	ProductId INT,
	ProductName VARCHAR(30),
	Summa MONEY
);

--Осуществляем вставку
INSERT INTO #TmpTable
EXEC sp_Test

--Проверяем, т.е. делаем выборку из таблицы
SELECT *
FROM #TmpTable

--Удаляем временную таблицу
DROP TABLE #TmpTable

---------------------------------------------------

--Создаем связанный сервер
EXEC sp_addlinkedserver @server=N'CurrentServer',
						@srvproduct=N'',
						@provider=N'SQLOLEDB',
						@datasrc=N'LAPTOP-FO5QIN3I'
GO

--Выполяем запрос с сохранением данных во верменную таблицу
SELECT *
INTO #TmpTable
FROM OPENQUERY(CurrentServer, 'SET FMTONLY OFF EXEC TestBase.dbo.sp_Test')

--Проверяем полученные данные
SELECT *
FROM #TmpTable
--Удаляем временную таблицу
DROP TABLE #TmpTable

---------------------------------------------------

--Включаем параметр Ad Hoc Distributed Queries
EXEC sp_configure 'show advanced options', 1
RECONFIGURE
EXEC sp_configure 'Ad Hoc Distributed Queries', 1
RECONFIGURE
GO

--Выполняем запрос с созранением данных во временну таблицу
SELECT *
INTO
#TmpTable
FROM OPENROWSET
(
	'SQLOLEDB',
	'Server=LAPTOP-FO5QIN3I;Trusted_Connection=Yes;',
	'SET FMTONLY OFF EXEC TestBase.dbo.sp_Test'
)

--Проверяем полученные данные
SELECT *
FROM #TmpTable
--Удаляем временную таблицу
DROP TABLE #TmpTable