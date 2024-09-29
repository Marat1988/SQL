/*Статья https://info-comp.ru/obucheniest/489-coalesce-isnull-in-t-sql.html*/
DECLARE @Var1 VARCHAR(5)
DECLARE @Var2 VARCHAR(5)
DECLARE @Var3 VARCHAR(5)

SET @Var1 = NULL
SET @Var2 = NULL
SET @Var3 = 'Var3'

SELECT COALESCE(@Var1, @Var2, @Var3, 'Все параметры пустые') AS [COALESCE],
	CASE WHEN @Var1 IS NOT NULL THEN @Var1
		 WHEN @Var2 IS NOT NULL THEN @Var2
		 WHEN @Var3 IS NOT NULL THEN @Var3
	ELSE 'Все параметры пустые' END AS [CASE]

DECLARE @Var1 VARCHAR(35)

SET @Var1=NULL

SELECT ISNULL(@Var1, 'Значение первого параметра NULL') AS [ISNULL]

DECLARE @Var1 INT
DECLARE @Var2 INT
DECLARE @Var3 INT

SET @Var1=NULL
SET @Var2=NULL
SET @Var3=1

SELECT COALESCE(@Var1, @Var2, @Var3) AS [COALESCE],
	ISNULL(@Var1, @Var2) AS [ISNULL] --будет ошибка, если указать третий параметр


DECLARE @Var1 VARCHAR(5)
DECLARE @Var2 VARCHAR(20)

SET @Var1 = NULL
SET @Var2 = 'Первый параметр NULL'

/*
	Функция COALESCE вернет значение с типом varchar(20),
	т.е. как у переменной @var2, a ISNULL c типом varchar(5)
	как у первого параметра @var1, т.е. произойдет усечение данных
*/

SELECT COALESCE(@Var1, @Var1) AS [COALESCE],
	ISNULL(@Var1, @Var2) AS [ISNULL]

DECLARE @Var1 TINYINT
DECLARE @Var2 INT

SET @Var1 = NULL
SET @Var2 = -1

/*Функция COALESCE вернет более приоритетный тип данных, т.е. INT,
а функция ISNULL выдаст ошибку,
так как нельзя явно преобразовывать значение -1 в тип TINYINT,
который является типом первого параметра*/

PRINT COALESCE(@Var1, @Var2)
PRINT ISNULL(@Var1, @Var2)

--Таблица будет создана успешно
CREATE TABLE #TempTable1
(
	column1 INTEGER NULL,
	column2 AS ISNULL(column1, 1) PRIMARY KEY
)

IF OBJECT_ID('tempdb..#TempTable1') IS NOT NULL
BEGIN
	PRINT 'Таблица #TempTable1 успешно создана'
	DROP TABLE #TempTable1 --Сразу удаляем ее
END
GO

--Ошибка
CREATE TABLE #TempTable2
(
	column1 INTEGER NULL,
	column2 AS COALESCE(column1, 1) PRIMARY KEY
)