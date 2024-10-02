/*Статья https://info-comp.ru/obucheniest/628-restrictions-in-ms-sql-server.html*/

DROP TABLE IF EXISTS TestTable
GO

--1. Создаем таблицу с ограничениями NOT NULL и DEFAULT
CREATE TABLE TestTable
(
	Column1 INT NOT NULL,
	Column2 INT NULL DEFAULT(0),
	Column3 INT CONSTRAINT DF_C3 DEFAULT(0)
);
GO

--2. Добавляем к столбцу Column2 ограничение NOT NULL
ALTER TABLE TestTable ALTER COLUMN [Column2] INT NOT NULL;
GO

--3. Добавляем к стлбцу Column1 ограничение DEFAULT
ALTER TABLE TestTable ADD CONSTRAINT DF_C1 DEFAULT(0) FOR Column1
GO


--Первый способ определения первичного ключа
CREATE TABLE TestTable2
(
	Column1 INT IDENTITY(1,1) CONSTRAINT PK_Column1_T2 PRIMARY KEY,
	Column2 VARCHAR(100) NOT NULL
);
GO

--Второй способ определения первичного ключа
CREATE TABLE TestTable3
(
	Column1 INT IDENTITY(1,1) NOT NULL,
	Column2 VARCHAR(100) NOT NULL,
	CONSTRAINT PK_Column1_T3 PRIMARY KEY (Column1)
);
GO

ALTER TABLE TestTable ADD CONSTRAINT PK_TestTable PRIMARY KEY (Column1)

--Создаем таблицу, на которую будем ссылаться
CREATE TABLE TestTable4
(
	CategoryId INT IDENTITY(1,1) NOT NULL,
	CategoryName VARCHAR(100) NOT NULL,
	CONSTRAINT PK_TestTable4 PRIMARY KEY (CategoryId)
);

--Создаем таблицу и ограничение FOREIGN KEY
CREATE TABLE TestTable5
(
	ProductId INT IDENTITY(1,1) NOT NULL,
	CategoryId INT NOT NULL,
	ProductName VARCHAR(100) NOT NULL,
	Price MONEY NULL,
	CONSTRAINT PK_TestTable5 PRIMARY KEY(ProductId),
	CONSTRAINT FK_TestTable5 FOREIGN KEY (CategoryId) REFERENCES TestTable4 (CategoryId)
		ON DELETE CASCADE --Не обязательно. Также возможно: NO ACTION | SET NULL | SET DEFAULT
		ON UPDATE CASCADE --Не обязательно. Также возможно: NO ACTION | SET NULL | SET DEFAULT
)

--Создаем проверочное ограничение CHECK в определении таблицы
CREATE TABLE TestTable6
(
	Column1 INT NOT NULL,
	Column2 INT NOT NULL,
	CONSTRAINT CK_TestTable CHECK (Column1 <> 0)
)
--Добавление ограничение CHECK к существующей таблице
ALTER TABLE TestTable6 ADD CONSTRAINT CK_TestTable6_C2 CHECK (Column2 > Column1)

--Создаем таблицу и ограничение UNIQUE
CREATE TABLE TestTable7
(
	Column1 INT NOT NULL CONSTRAINT U_TestTable7_C1 UNIQUE,
	Column2 INT NOT NULL,
	Column3 INT NOT NULL,
	CONSTRAINT U_TestTable7_C2 UNIQUE (Column2)
)
--Добавляем к существующей таблице ограничение UNIQUE
ALTER TABLE TestTable7 ADD CONSTRAINT U_TestTable7_C3 UNIQUE (Column3)