/*Статья https://info-comp.ru/programmirovanie/484-introduction-to-programming-in-t-sql.html*/

DECLARE @TestVar1 INT
DECLARE @TestVat2 INT
SET @TestVar1 = 1
SELECT @TestVat2 = 2
SELECT @TestVar1 AS [Переменная 1],
		@TestVat2 AS [Переменная 2],
		@@VERSION AS [Версия SQL Server]

DECLARE @TestVar1 INT
DECLARE @TestVar2 VARCHAR(20)

SET @TestVar1 = 5

IF @TestVar1 > 0
	SET @TestVar2 = 'Больше 0'
ELSE
	SET @TestVar2 = 'Меньше 0'

SELECT @TestVar2 AS [Значение TestVar1]

DECLARE @TestVar VARCHAR(20)
IF EXISTS(SELECT * FROM test_table WHERE id >= 0)
	SET @TestVar='Записи есть'
ELSE
	SET @TestVar='Записей нет'
SELECT @TestVar AS [Наличие записей]

DECLARE @TestVar1 INT
DECLARE @TestVar2 VARCHAR(20)
SET @TestVar1 = 1
SELECT @TestVar2=CASE @TestVar1 WHEN 1 THEN 'Один'
								WHEN 2 THEN 'Два'
								ELSE 'Неизвестное'
				 END
SELECT @TestVar2 AS [Число]

DECLARE @TestVar1 VARCHAR(20)
DECLARE @TestVar2 INT
SET @TestVar2=0
IF EXISTS(SELECT * FROM test_table WHERE id > 0)
BEGIN
	SET @TestVar1='Записи есть'
	UPDATE test_table SET column1=5 WHERE id>=0
	SET @TestVar2=@@ROWCOUNT
END
ELSE
	SET @TestVar1='Записей нет'

SELECT @TestVar1 AS [Начилие записей],
		@TestVar2 AS [Затронуто строк:]

DECLARE @Cnt INT = 1,
		@Result INT = 0,
		@CountRow INT
SELECT @CountRow=COUNT(*)
FROM test_table
WHILE @Cnt <= @CountRow
BEGIN
	SET @Cnt+=1
	SET @Result+=1
	IF @Cnt=20
		BREAK
	ELSE
		CONTINUE
END
SELECT @Result AS [Количество выполнений цикла:]

--Объявляем переменные (Однострочный комментарий)
DECLARE @Cnt INT = 0
/*Запускаем цикл, в котором мы просто увеличиваем счетчик
  (Многострочный комментарий)*/
WHILE @Cnt < 10
	SET @Cnt += 1
SELECT @Cnt AS [Значение Cnt =] --Выводим на экран значение переменной

DECLARE @Cnt INT=0
Metka:
SET @Cnt+=1 --Прибавляем к переменной 1
IF @Cnt < 10
	GOTO Metka --Если значение меньше 10, то переходим к метке
SELECT @Cnt AS [Значение Cnt=]

DECLARE @TimeStart TIME,
		@TimeEnd TIME
SET @TimeStart=CONVERT(TIME, GETDATE()) --Узнаем время
WAITFOR DELAY '00:00:05' --Пауза на 5 секунд
SET @TimeEnd=CONVERT(TIME, GETDATE()) -- Снова узнаем время
--Узнаем, сколько прошло времени в секундах
SELECT DATEDIFF(SS, @TimeStart, @TimeEnd) AS [Прошло Секунд:]

DECLARE @Cnt INT = 1,
		@Result VARCHAR(15)
/*Если значение Cnt меньше 0, то следующие команды не выполняются,
и Вы не увидите колонку [Результат: ]*/
IF @Cnt < 0
	RETURN
SET @Result = 'Cnt больше 0'
SELECT @Result AS [Результат:]

DECLARE @Cnt INT=10,
		@TestVar VARCHAR(100)
IF @Cnt > 0
	SET @TestVar='Значение переменной Cnt больше 0 и равняется ' + CAST(@Cnt AS VARCHAR(10))
ELSE
	SET @TestVar='Значение переменной Cnt меньше 0 и равняется ' + CAST(@Cnt AS VARCHAR(10))
PRINT @TestVar

--Узнаем что у нас в таблице (id=IDENTITY)
SELECT *
FROM test_table
--Начинаем транзакцию
BEGIN TRAN
--Сначала обновим все данные
UPDATE test_table SET column1-=5
--Затем просто добавляем строки с новыми значениями
INSERT INTO test_table
SELECT column1
FROM test_table
--Если ошибка, то все отменяем
IF @@ERROR != 0
BEGIN
	ROLLBACK TRAN
	RETURN
END
COMMIT TRAN
--Смотрим, что получилось
SELECT *
FROM test_table

BEGIN TRY
	DECLARE @TestVar1 INT=10,
			@TestVar2 INT=0,
			@result INT
	SET @Result=@TestVar1/@TestVar2 
END TRY
BEGIN CATCH
	SELECT ERROR_NUMBER() AS [Номер ошибки],
		   ERROR_MESSAGE() AS [Описание ошибки]
END CATCH