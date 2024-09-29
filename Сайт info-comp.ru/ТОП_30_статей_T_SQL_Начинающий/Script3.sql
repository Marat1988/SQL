/*Статья https://info-comp.ru/obucheniest/715-create-database-in-ms-sql-server.html*/

DROP DATABASE TestDB;
GO

CREATE DATABASE TestDB;

--Создание БД TestDB
CREATE DATABASE TestDB ON PRIMARY --Первичный файл
(
	Name=N'TestDB', --Логическое имя файла БД
	FILENAME=N'C:\DataBases\TestDB.mdf' --Имя и местоположение
)
LOG ON --Явно указываем файлы журналов
(
	Name=N'TestDB_log', --Логическое имя файла журнала
	FILENAME=N'C:\DataBases\TestDB_log.ldf' --Имя и местоположение файла журнала
)