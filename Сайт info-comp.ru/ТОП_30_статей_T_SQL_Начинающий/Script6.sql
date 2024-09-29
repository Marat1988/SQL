/*Статья https://info-comp.ru/obucheniest/727-rename-table-column-sql-server.html*/

USE TestDB;
GO

SELECT *
FROM Goods
GO

EXEC sp_rename 'Goods.Price', 'ProductPrice', 'COLUMN'

SELECT *
FROM Goods
GO