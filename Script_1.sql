/*По статье https://info-comp.ru/programmirovanie/544-working-with-json-in-microsoft-sql-server.html*/

CREATE DATABASE TestBase
GO
--Переходим в созданную базу
USE TestBase
GO
--Создаем тестовую таблицу
CREATE TABLE TestTable
(
	ID INT IDENTITY(1,1) NOT NULL,
	StrJSON VARCHAR(MAX) NULL,
	Header VARCHAR(100) NULL,
	CONSTRAINT PK_TestTable PRIMARY KEY CLUSTERED (ID ASC)
)
GO
--Заполняем таблицу тестовыми данными
--Переменная для JSON строки
DECLARE @JSON VARCHAR(MAX)
--Записываем в переменную JSON данные
   SET @JSON = '{
                                "Id": 12345,
                                "Title": "Заказ 1",
                                "Buyer": "Иванов Иван",
                                "Goods":[
                                                        { 
                                                          "Name": "Системный блок",
                                                          "Price": 500,
                                                          "Quantity": 1
                                                        },
                                                        { 
                                                          "Name": "Монитор",
                                                          "Price": 400,
                                                          "Quantity": 1
                                                        },
                                                        { 
                                                          "Name": "Клавиатура",
                                                          "Price": 100,
                                                          "Quantity": 1
                                                        }
                                                ],
                                "Properties":{
                                                                "Created": "21.10.2016",
                                                                "Status": "Completed",
                                                                "DeliveryType": "Самовывоз"
                                                         },
                                "ManagerPhones":[
                                                                "123-145-789",
                                                                "987-654-321"
                                                   ]                     
                        }
   '
--Вставляем данные
INSERT INTO TEstTable (StrJSON, Header)
SELECT @JSON, 'Строка JSON'
UNION ALL
SELECT 'Просто текст', 'Просто текст'
UNION ALL
SELECT NULL, 'Пустая строка'
GO
--Посмотрим результат
SELECT *
FROM TestTable
/*-------------------------------------------------------------------------------*/
SELECT ID, ISJSON(StrJSON) AS Status,
		Header, StrJSON
FROM TestTable
GO

SELECT JSON_VALUE(StrJSON, '$.Goods[1].Name') AS [Товар],
		JSON_VALUE(StrJSON, '$.Goods[1].Price') AS [Цена],
		JSON_VALUE(StrJSON, '$.Properties.Created') AS [Дата создания заказа],
		JSON_VALUE(StrJSON, '$.ManagerPhones[0]') AS [Телефон менеджера]
FROM TestTable
WHERE ISJSON(StrJSON) = 1

SELECT JSON_QUERY(StrJSON, '$.Goods') AS [Все товары в заказе],
		StrJSON AS [Заказ]
FROM TestTable
WHERE ISJSON(StrJSON) = 1

--Изменение цены
UPDATE TestTable SET StrJSON = JSON_MODIFY(StrJSON, '$.Goods[1].Price', '450')
WHERE ISJSON(StrJSON) = 1
--Добавляем номера телефона
UPDATE TestTable SET StrJSON = JSON_MODIFY(StrJSON, 'append $.ManagerPhones', '555-666-777')
WHERE ISJSON(StrJSON) = 1
--Проверяем
SELECT JSON_VALUE(StrJSON, '$.Goods[1].Price') AS [Новая цена монитора],
		JSON_QUERY(StrJSON, '$.ManagerPhones') AS [Телефонные номера]
FROM TestTable
WHERE ISJSON(StrJSON) = 1

--Переменная для JSON данных
DECLARE @JSON VARCHAR(MAX)
--Получаем JSON данные
SELECT @JSON = (SELECT StrJSON FROM TestTable WHERE ISJSON(StrJSON) = 1)
--Преобразовываем их в табличный вид (без WITH)
SELECT *
FROM OPENJSON(@JSON, '$.Goods')
--Преобразовываем их в табличный вид (с WITH)
SELECT *
FROM OPENJSON(@JSON, '$.Goods')
		WITH
		(
			Name VARCHAR(200) '$.Name',
			Price MONEY '$.Price',
			Quantity INT '$.Quantity'
		)

--Переменная для JSON данных
DECLARE @JSON VARCHAR(MAX)
--Преобразовываем данные в JSON строку
SELECT @JSON = (SELECT Id, Header FROM TestTable FOR JSON AUTO)

SELECT @JSON AS [Строка JSON]