DROP TABLE IF EXISTS Goods
GO

--Создание таблицы
CREATE TABLE Goods
(
	ProductId INT IDENTITY(1,1),
	ProductName VARCHAR(100) NOT NULL,
	Price MONEY NULL,
	CONSTRAINT PK_ProductId PRIMARY KEY(ProductId)
);
GO
--Добавление строк в таблицу Goods
INSERT INTO Goods (ProductName, Price)
VALUES ('Системный блок', 100),
		('Монитор', 200),
		('Сканер', 150),
		('Принтер', 200),
		('Клавиатура', 50),
		('Смартфон', 300),
		('Мышь', 20),
		('Планшет', 300),
		('Процессор', 200);
GO

--Выборка данных
SELECT ProductId, ProductName, Price
FROM Goods;

--Определям повторяющиеся значение в столбце
SELECT Price, COUNT(*) AS CNT
FROM Goods
GROUP BY Price
HAVING COUNT(*)>1;

--Выволим все строки с повторяющимися значениями
WITH DuplicateValue AS
(
	SELECT Price, COUNT(*) AS CNT
	FROM Goods
	GROUP BY Price
	HAVING COUNT(*)>1
)
SELECT ProductId, ProductName, Price
FROM Goods
WHERE Price IN (SELECT Price FROM DuplicateValue)
ORDER BY Price, ProductId;