--Создание таблицы
CREATE TABLE TestTable
(
	ProductId INT IDENTITY(1,1) NOT NULL,
	CategoryId INT NOT NULL,
	ProductName VARCHAR(100) NOT NULL,
	Price MONEY NULL
)
GO

--Вставляем в таблицу данные
INSERT INTO TestTable
VALUES (1, 'Клавиатура', 100),
	   (1, 'Мышь', 50),
	   (2, 'Системный блок', 200)
GO

--Выборка данных
SELECT *
FROM TestTable
GO

--Объявляем переменные
DECLARE @SQL_QUERY NVARCHAR(200),
		@Var1 INT;

--Формируем SQL инструкцию
SET @SQL_QUERY = N'SELECT * FROM TestTable WHERE ProductID = @Var1;';

--Смотрим на итоговую строку
SELECT @SQL_QUERY AS [TEXT QUERY]

--Выполняем текстовую строку как SQL инструкцию
EXEC sp_executesql @SQL_QUERY, --Текст SQL инструкции
				   N'@Var1 AS INT', --Объявление переменной @Var1
				   @Var1 = 1 --Передаем значение для переменной @Var1