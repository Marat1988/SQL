/*Статья https://info-comp.ru/programmirovanie/633-try-catch-in-t-sql.html*/

--Начало блока обработки ошибок
BEGIN TRY
	--Инструкции, в которых могут возникнуть ошибки
	DECLARE @TestVar1 INT = 10,
			@TestVar2 INT = 0,
			@Rez INT
	SET @Rez = @TestVar1 / @TestVar2
END TRY
--Начало блока CATCH
BEGIN CATCH
	--Действия, которые будут выполняться в случае возникновения ошибки
	SELECT ERROR_NUMBER() AS [Номер ошибки],
		   ERROR_MESSAGE() AS [Описание ошибки]
	SET @Rez = 0
END CATCH

SELECT @Rez AS Результат