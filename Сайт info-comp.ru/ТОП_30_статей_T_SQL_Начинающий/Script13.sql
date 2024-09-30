/*Статья https://info-comp.ru/programmirovanie/691-exists-in-t-sql.html*/

INSERT INTO TestTable2(Id, IdProperty, IsEnabled, IsTest)
VALUES (1,1,1,1)


SELECT *
FROM TestTable
WHERE EXISTS(SELECT * FROM TestTable2)

IF NOT EXISTS(SELECT * FROM TestTable WHERE ProductId > 3)
	SELECT 'Вложенный запрос не возвращает строк.' AS [Результат]