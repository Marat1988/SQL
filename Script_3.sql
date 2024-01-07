/*По статье https://info-comp.ru/obucheniest/441-ranking-functions-in-transact-sql.html*/

CREATE DATABASE TestBase
GO
--Переходим в созданную базу
USE TestBase
GO
--Создание таблицы
CREATE TABLE selling
(
	id INT IDENTITY(1,1) NOT NULL,
	NameProduct VARCHAR(50) NOT NULL,
	price MONEY NOT NULL,
	category VARCHAR(50) NOT NULL,
	CONSTRAINT PK_selling_id PRIMARY KEY(id)
)
GO
--Заполнение тестовыми данными
INSERT INTO selling (NameProduct, price, category)
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
--Проверка
SELECT *
FROM selling
/*------------------------------*/
SELECT NameProduct, price, category,
		ROW_NUMBER() OVER (PARTITION BY category ORDER BY price DESC) AS [ROW_NUMBER_PART]
FROM selling
GO
/*------------------------------*/
SELECT NameProduct, price, category,
		RANK() OVER (ORDER BY price DESC) AS [RANK],
		ROW_NUMBER() OVER (ORDER BY price DESC) AS [ROW_NUMBER]
FROM selling
GO
/*------------------------------*/
SELECT NameProduct, price, category,
		RANK() OVER (PARTITION BY category ORDER BY price DESC) AS [RANK],
		ROW_NUMBER() OVER (PARTITION BY category ORDER BY price DESC) AS [ROW_NUMBER_PART]
FROM selling
GO
/*------------------------------*/
SELECT NameProduct, price, category,
		RANK() OVER (ORDER BY price DESC) AS [RANK],
		DENSE_RANK() OVER (ORDER BY price DESC) AS [DENSE_RANK],
		ROW_NUMBER() OVER (ORDER BY price DESC) AS [ROW_NUMBER]
FROM selling
/*------------------------------*/
SELECT NameProduct, price, category,
		NTILE(3) OVER (ORDER BY price DESC) AS [NTILE]
FROM selling
/*Итоговый пример*/
SELECT NameProduct, price, category,
		ROW_NUMBER() OVER (ORDER BY price DESC) AS [ROW_NUMBER],
		RANK() OVER (ORDER BY price DESC) AS [RANK],
		DENSE_RANK() OVER (ORDER BY price DESC) AS [DENSE_RANK],
		NTILE(3) OVER (ORDER BY price DESC) AS [NTILE]
FROM selling
