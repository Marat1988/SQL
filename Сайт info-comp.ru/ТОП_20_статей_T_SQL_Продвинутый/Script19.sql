/*Статья https://info-comp.ru/obucheniest/698-get-year-from-date-in-t-sql.html*/

SELECT GETDATE() AS [GETDATE],
	CURRENT_TIMESTAMP AS [CURRENT_TIMESTAMP],
	SYSDATETIME() AS [SYSDATETIME]

--Объявляем переменную для хранения даты
DECLARE @TestDate DATETIME
--Присваиваем значение переменной (текущая дата)
SET @TestDate=GETDATE()

--Запрос SELECT

--Передаем переменную в качестве параметра
SELECT @TestDate AS [Дата],
	YEAR(@TestDate) AS [Год YEAR],
	DATEPART(YY, @TestDate) AS [Год DATEPART],
	YEAR('01.01.2019') AS [Год YEAR],
	DATEPART(YY, GETDATE()) AS [Год DATEPART]

--Объявляем переменную для хранения даты
DECLARE @TestDate DATETIME
--Присваиваем значение переменной (текущая дата)
SET @TestDate=GETDATE()

--Запрос SELECT
SELECT @TestDate AS [Дата],
	--Передаем переменную в качестве параметра
	MONTH(@TestDate) AS [Месяц, MONTH],
	DATEPART(MM, @TestDate) AS [Месяц DATEPART],
	--Передаем выражение, приводящее к типу DATE
	MONTH('01.01.2019') AS [Месяц MONTH],
	--В качестве паракметра указываем функцию
	DATEPART(MM, GETDATE()) AS [Месяц DATEPART]

--Объявляем переменную для хранения даты
DECLARE @TestDate DATETIME
--Присваиваем значение переменной (текущая дата)
SET @TestDate = GETDATE()

--Запрос SELECT
SELECT @TestDate AS [Дата],
	DAY(@TestDate) AS [День DAY],
	DATEPART(DD, @TestDate) AS [День DATEPART],
	DAY('01.01.2019') AS [День DAY],
	DATEPART(DD, GETDATE()) AS [День DATEPART]

--Объявляем переменную для хранения даты
DECLARE @TestDate DATETIME
--Присваиваем значение переменной (текущая дата)
SET @TestDate = GETDATE()

--Запрос SELECT
SELECT @TestDate AS [Дата],
	DATEPART(HH,@TestDate) AS [Час],
	DATEPART(HH, GETDATE()) AS [Час]