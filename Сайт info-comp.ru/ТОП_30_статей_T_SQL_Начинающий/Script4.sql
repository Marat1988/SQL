/*Статья https://info-comp.ru/obucheniest/716-create-table-in-ms-sql-server.html*/

--Удаление таблиц
--Параметр IF EXISTS доступен начиная с версии 2016 SQL Server
DROP TABLE IF EXISTS Goods;
DROP TABLE IF EXISTS Categories;

--Создание таблиц с товарами
CREATE TABLE Goods
(
	ProductId INT IDENTITY(1,1) NOT NULL,
	Category INT NOT NULL DEFAULT(1),
	ProductName VARCHAR(100) NOT NULL,
	Price MONEY NULL,
	CONSTRAINT PK_ProductId PRIMARY KEY (ProductId)
);
GO

--Создание таблицы с категориями
CREATE TABLE Categories
(
	CategoryId INT IDENTITY(1,1) NOT NULL,
	CategoryName VARCHAR(100) NOT NULL,
	CONSTRAINT PK_CategoryId PRIMARY KEY (CategoryId)
);
GO

--Добавление ограничения внешнего ключа (FOREIGN KEY)
ALTER TABLE Goods
ADD CONSTRAINT FK_Category FOREIGN KEY (Category) REFERENCES Categories (CategoryId) ON DELETE SET DEFAULT ON UPDATE NO ACTION;

