/*Статья https://info-comp.ru/obucheniest/643-openxml-in-t-sql.html*/
DROP TABLE IF EXISTS TestTable
GO

--Инструкция создания таблицы
CREATE TABLE TestTable
(
	ProductId INT IDENTITY(1,1) NOT NULL,
	CategoryId INT NOT NULL,
	ProductName VARCHAR(100) NOT NULL,
	Price MONEY NULL
)
GO
--Инструкция добавления данных
INSERT INTO TestTable
VALUES (1, 'Клавиатура', 100),
	   (1, 'Мышь', 50),
	   (2, 'Телефон', 300)
GO
--Запросы на выборку
SELECT *
FROM TestTable

--Объявляем переменные
DECLARE @XML_Doc XML;
DECLARE @XML_Doc_Handle INT;

--Формируем XML документ
SET @XML_Doc=(SELECT ProductId AS "@Id", ProductName, Price
			  FROM TestTable
			  ORDER BY ProductId
			  FOR XML PATH ('Product'), TYPE, ROOT('Products'));
--Подготавливаем XML документ
EXEC sp_xml_preparedocument @XML_Doc_Handle OUTPUT, @XML_Doc;

--Извлекаем данные из XML документа
SELECT *
FROM OPENXML(@XML_Doc_Handle, '/Products/Product', 2)
WITH
(
	ProductId INT '@Id',
	ProductName VARCHAR(100),
	Price MONEY
);
--Удаляем дескриптор XML документа
EXEC sp_xml_removedocument @XML_Doc_Handle;