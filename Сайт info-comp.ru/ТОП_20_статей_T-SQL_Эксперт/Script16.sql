/*Статья https://info-comp.ru/obucheniest/614-rowcount-function-in-t-sql.html*/

DROP TABLE IF EXISTS TestTable
GO

CREATE TABLE dbo.TestTable
(
	ProductId INT IDENTITY(1,1) NOT NULL,
	ProductName VARCHAR(100) NOT NULL,
	Price MONEY
)
GO

--Инстуркция добавления данных
INSERT INTO dbo.TestTable(ProductName, Price)
VALUES ('Системный блок', 500),
	   ('Монитор', 350),
	   ('Клавиатура', 100),
	   ('Мышь', 50),
	   ('Принтер', 400)
--Вызов функции ROWCOUNT
SELECT @@ROWCOUNT AS [Добавлено строк]

--SQL запрос на выборку
--чтобы просто посмотреть фактический результат добавления строк
SELECT *
FROM dbo.TestTable

--Объявление переменной
DECLARE @CntUpdateRow INT

--Инструкция обновления данных
UPDATE dbo.TestTable SET Price=+10
WHERE Price>200

--Вызов функции ROWCOUNT и сохранение значения в переменной
SET @CntUpdateRow=@@ROWCOUNT

--SQL запрос на выборку
--чтобы просто посмотреть фактический результат обновления строк
SELECT *
FROM dbo.TestTable

--Смотрим что за число у нас сохранено в переменной
SELECT @CntUpdateRow AS [Затронуто строк]

-----------------------------------------------------------------
--Оъявление переменной
DECLARE @TestVar INT

--Инструкция присваивания
SET @TestVar=100

--Вызов функции ROWCOUNT
SELECT @@ROWCOUNT AS [Результат присваивания]

--SQL запрос на выборку
SELECT *
FROM dbo.TestTable
WHERE Price < 500

--Вызов функции ROWCOUNT
SELECT @@ROWCOUNT AS [Выбрано строк]
-----------------------------------------------------------------

--Объявление переменной
DECLARE @CntDeleteRow INT

--Инструкция удаления всех строк в таблице
DELETE dbo.TestTable

--Вызов функции ROWCOUNT и сохранение значения в переменной
SET @CntDeleteRow=@@ROWCOUNT

--Пример того, как можно обрабатывать полученный результат
IF @CntDeleteRow > 0
	SELECT 'Было удалено строк: ' + CAST(@CntDeleteRow AS VARCHAR(10)) AS [Результат]
ELSE
	SELECT 'Ни одной строки не удалено.' AS [Результат]
