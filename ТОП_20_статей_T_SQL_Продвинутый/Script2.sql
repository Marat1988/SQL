/*Статья https://info-comp.ru/obucheniest/495-the-with-in-t-sql-or-common-table-expression.html*/

DROP TABLE IF EXISTS TestTable;
GO

CREATE TABLE TestTable
(
	UserId INT NOT NULL IDENTITY(1,1),
	Post VARCHAR(50) NOT NULL,
	ManagerId INT NULL,
	CONSTRAINT PK_UsrId PRIMARY KEY (UserId)
);
GO

INSERT INTO TestTable (Post, ManagerId)
VALUES ('Директор', NULL),
	   ('Главный бухгалтер', 1),
	   ('Бухгалтер', 2),
	   ('Начальник отдела продаж', 1),
	   ('Старший менеджер отдела продаж', 4),
	   ('Менеджер по продажам', 5),
	   ('Начальник отдела информационных технологий', 1),
	   ('Старший программист', 7),
	   ('Программист', 8),
	   ('Системный администратор', 7)
GO

WITH TestCTE (UserId, Post, ManagerId)
AS
(
	SELECT UserId, Post, ManagerId
	FROM TestTable
)
SELECT *
FROM TestCTE;

--Пример рекурсивного запроса
WITH TestCTE (UserId, Post, ManagerId, LevelUser)
AS
(
	--Находим якорь рекурсии
	SELECT UserId, Post, ManagerId, 0 AS LevelUser
	FROM TestTable
	WHERE ManagerId IS NULL
	UNION ALL
	--Делаем объединение с TestCTE (хотя мы его еще не дописали)
	SELECT t1.UserId, t1.Post, t1.ManagerId, t2.LevelUser + 1
	FROM TestTable t1
	INNER JOIN TestCTE t2 ON t1.ManagerId=t2.UserId
)
SELECT *
FROM TestCTE
ORDER BY LevelUser
OPTION (MAXRECURSION 5)