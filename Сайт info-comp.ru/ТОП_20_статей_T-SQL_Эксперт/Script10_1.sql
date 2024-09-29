/*Статья https://info-comp.ru/sisadminst/486-full-text-search-ms-sql-server.html*/

DROP TABLE IF EXISTS TestTable

--Создание таблицы
CREATE TABLE TestTable
(
	Id INT IDENTITY(1,1) NOT NULL,
	TextData VARCHAR(1000) NULL,
	CONSTRAINT PK_TestTable PRIMARY KEY CLUSTERED (Id ASC)
);
GO
--Добавление данных в таблицу
INSERT INTO TestTable(TextData)
VALUES ('Компонент Database Engine – основная служба для хранения, обработки и защиты данных'),
       ('Службы Integration Services – это платформа для построения решений по интеграции и преобразованию данных уровня предприятия.'),
       ('Службы Reporting Services – это серверная платформа отчетов, предоставляющая возможности для удобной работы с отчетами для разнообразных источников данных.'),
       ('Репликация представляет собой набор технологий копирования и распространения данных и объектов баз данных между базами данных, а также синхронизации баз данных для поддержания согласованности.'),
       ('Компонент SQL Server Service Broker обеспечивает собственную поддержку компонента SQL Server Database Engine для приложений обмена сообщениями и приложений с очередями сообщений.'),
       ('SQL – язык структурированных запросов, применяемый для создания, модификации и управления данными в произвольной реляционной базе данных.'),
       ('C++ – язык программирования общего назначения, который поддерживает как процедурное, так и объектно-ориентированное программирование.'),
       ('Transact-SQL – язык программирования, процедурное расширение языка SQL, разработанное компанией Microsoft.'),
       ('PL/SQL – язык программирования, процедурное расширение языка SQL, разработанное корпорацией Oracle.'),
       ('Microsoft Visual Basic – интегрированная среда разработки программного обеспечения, разработанная корпорацией Microsoft.'),
       ('C# – объектно-ориентированный язык программирования. Разработанный компанией Microsoft как язык разработки приложений для платформы Microsoft .NET Framework.');
GO
--Выборка данных
SELECT *
FROM TestTable;

--Создание полнотекстового каталога
CREATE FULLTEXT CATALOG TestCatalog
WITH ACCENT_SENSITIVITY = ON
AS DEFAULT
AUTHORIZATION dbo
GO

--Изменение полнотекстового каталога
ALTER FULLTEXT CATALOG TestCatalog
REBUILD WITH ACCENT_SENSITIVITY=OFF
GO

--Возвращаем назад
ALTER FULLTEXT CATALOG TestCatalog
REBUILD WITH ACCENT_SENSITIVITY=ON
GO

--Удаление каталога
DROP FULLTEXT CATALOG TestCatalog;

--Создание полнотекстового индекса
CREATE FULLTEXT INDEX ON TestTable(TextData)
KEY INDEX PK_TestTable ON (TestCatalog)
WITH (CHANGE_TRACKING AUTO)
GO

--Изменение полнотектового индекса
ALTER FULLTEXT INDEX ON TestTable
SET CHANGE_TRACKING=MANUAL
GO

ALTER FULLTEXT INDEX ON TestTable
SET CHANGE_TRACKING=AUTO
GO

--Удаление полнотекстового индекса
DROP FULLTEXT INDEX ON TestTable
GO

SELECT *
FROM TestTable
WHERE CONTAINS(TextData, 'Microsoft');
GO

SELECT Table1.Id AS [Id],
        RowRank.Rank AS [RANK],
        Table1.TextData AS [TextData]
FROM TestTable AS Table1
INNER JOIN CONTAINSTABLE(TestTable, TextData, 'Microsoft') AS RowRank ON Table1.Id=RowRank.[KEY]
ORDER BY RowRank.RANK DESC;