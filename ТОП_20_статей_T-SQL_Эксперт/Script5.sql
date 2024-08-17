/*Статья https://info-comp.ru/obucheniest/520-pagination-in-t-sql.html*/

DROP TABLE IF EXISTS TestTable
GO

CREATE TABLE TestTable
(
	Id INT IDENTITY(1,1) NOT NULL,
	ProductName VARCHAR(50) NOT NULL,
	Price MONEY NULL,
	IdGroup INT NULL,
	CONSTRAINT PK_TestTable PRIMARY KEY CLUSTERED (Id ASC)
)
GO

--Переменные
DECLARE @RowNumber AS INT = 1,
		@ProductName AS VARCHAR(20),
		@Price AS MONEY,
		@IdGroup AS INT
--Начальное значение цены
SET @Price = 100
--Запускаем цикл на 10 итераций, т.е. вставим 100 строк
WHILE @RowNumber <= 100
BEGIN
	--Изменяем наименование товара
	SET @ProductName = 'Товар ' + CAST(@RowNumber AS VARCHAR(20))
	--Изменяем цену товара
	SET @Price += @RowNumber
	--Присваиваем случайную группу
	SET @IdGroup = ROUND(Rand() * 10, 0)
	--Вставляем данные
	INSERT INTO TestTable(ProductName, Price, IdGroup)
	VALUES (@ProductName, @Price, @IdGroup)
	--Переходим к следующей итерации
	SET @RowNumber += 1
END
GO

SELECT *
FROM TestTable
GO

CREATE FUNCTION dbo.ft_GetPage
(
	@Page INT, --Номер страницы
	@CntRowOnPage AS INT --Количество записей на странице
)
RETURNS TABLE
RETURN
(
	--Объявляем CTE
	WITH SOURCE
	AS
	(
		SELECT ROW_NUMBER() OVER (ORDER BY Id) AS RowNumber, *
		FROM TestTable
	)
	SELECT *
	FROM SOURCE
	WHERE RowNumber > (@Page * @CntRowOnPage) - @CntRowOnPage
		  AND RowNumber <= @Page * @CntRowOnPage
)
GO

SELECT *
FROM dbo.ft_GetPage(2, 10)
GO

CREATE FUNCTION dbo.ft_GetPageGroup
(
	@Page INT, --Номер страницы
	@CntRowOnPage AS INT --Количество групп на странице
)
RETURNS TABLE
RETURN
(
	--Объявляем CTE
	WITH SOURCE
	AS
	(
		SELECT DENSE_RANK() OVER (ORDER BY IdGroup) AS RowNumber, *
		FROM TestTable
	)
	SELECT *
	FROM SOURCE
	WHERE RowNumber > (@Page * @CntRowOnPage) - @CntRowOnPage
		  AND RowNumber <= @Page * @CntRowOnPage
)
GO

SELECT *
FROM dbo.ft_GetPageGroup(1, 3)