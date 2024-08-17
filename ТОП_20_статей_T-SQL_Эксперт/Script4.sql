--Создание обычной базы данных для тестов
CREATE DATABASE DBInMemory;
GO
--Переходим в контекст новой базы данных
USE DBInMemory
GO
--Создаем файловую группу, оптимизированную для памяти
ALTER DATABASE DBInMemory ADD FILEGROUP FileGroupInMemory CONTAINS MEMORY_OPTIMIZED_DATA;
GO

--Добавляем контейнер в файловую группу
ALTER DATABASE DBInMemory ADD FILE
(
	name='FileMemory',
	filename='C:\DataBase\FileInMemory'
)
TO FILEGROUP FileGroupInMemory;

--Создаем таблицу, оптимизированную для памяти
CREATE TABLE TestTableInMemory
(
	ProductId INT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED,
	ProductName NVARCHAR(100) NOT NULL,
	Price MONEY
) WITH (MEMORY_OPTIMIZED=ON); --Параметр для создания таблицы, оптимизированной для памяти
GO

--Добавляем данные в таблицу
INSERT INTO TestTableInMemory
VALUES ('Тестовая строка', 100);
GO
--Проверяем
SELECT *
FROM TestTableInMemory