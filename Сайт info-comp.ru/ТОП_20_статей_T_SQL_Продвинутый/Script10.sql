/*Статья https://info-comp.ru/obucheniest/441-ranking-functions-in-transact-sql.html*/

CREATE TABLE selling
(
	id INT IDENTITY(1,1) NOT NULL,
	NameProduct VARCHAR(50) NOT NULL,
	Price MONEY NOT NULL,
	Category VARCHAR(50) NOT NULL
)
GO

INSERT INTO selling (NameProduct, Price, Category)
VALUES ('Windows 8', 150, 'Программы'),
	   ('Texet 9751', 200, 'Планшеты'),
	   ('iPhone 6', 400, 'Телефоны'),
	   ('Samsung Galaxy A7', 300, 'Телефоны'),
	   ('Sony Xperia E4', 250, 'Телефоны'),
	   ('iPad 4', 450, 'Планшеты'),
	   ('DELL Inspiron 7347', 400, 'Ноутбуки'),
	   ('ASUS X555LN', 350, 'Ноутбуки'),
	   ('Sony VAIO Tap 11', 400, 'Ноутбуки'),
	   ('HTC One M8', 300, 'Телефоны')
GO

SELECT NameProduct, Price, Category, ROW_NUMBER() OVER (ORDER BY price DESC) AS [ROW_NUMBER]
FROM selling

SELECT NameProduct, Price, Category, ROW_NUMBER() OVER (PARTITION BY category ORDER BY price DESC) AS [ROW_NUMBER_PART]
FROM selling

SELECT NameProduct, Price, Category,
	RANK() OVER(ORDER BY Price DESC) AS [RANK],
	ROW_NUMBER() OVER (ORDER BY Price DESC) AS [ROW_NUMBER]
FROM selling

SELECT NameProduct, Price, Category,
	RANK() OVER(PARTITION BY category ORDER BY Price DESC) AS [RANK],
	ROW_NUMBER() OVER (PARTITION BY category ORDER BY Price DESC) AS [ROW_NUMBER_PART]
FROM selling

SELECT NameProduct, Price, Category,
	RANK() OVER (ORDER BY Price DESC) AS [RANK],
	DENSE_RANK() OVER (ORDER BY Price DESC) AS [DENSE_RANK],
	ROW_NUMBER() OVER (ORDER BY Price DESC) AS [ROW_NUMBER]
FROM selling

SELECT NameProduct, Price, Category,
	NTILE(3) OVER (ORDER BY Price DESC) AS [NTILE]
FROM selling

SELECT NameProduct, Price, Category,
	ROW_NUMBER() OVER (ORDER BY Price DESC) AS [ROW_NUMBER],
	RANK() OVER (ORDER BY Price DESC) AS [RANK],
	DENSE_RANK() OVER (ORDER BY Price DESC) AS [DENSE_RANK],
	NTILE(3) OVER (ORDER BY Price DESC) AS [NTILE]
FROM selling