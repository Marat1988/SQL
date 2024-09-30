/*Статья https://info-comp.ru/programmirovanie/619-compound-operators-in-t-sql.html*/

DECLARE @TestVar INT = 5;
SET @TestVar = @TestVar + 2;
SELECT @TestVar AS [Полная запись присваивания]
GO

DECLARE @TestVar INT = 5;
SET @TestVar += 2;
SELECT @TestVar AS [С помощью составного оператора];

--Объявляем переменные
DECLARE @Var1 INT = 1,
		@Var2 INT = 2,
		@Var3 INT = 3,
		@Var4 INT = 4,
		@Var5 INT = 5,
		@Var6 INT = 6,
		@Var7 INT = 7,
		@Var8 INT = 8

--Операция присваивания с использованием составных операторов
SET @Var1 += 2;
SET @Var2 -= 2;
SET @Var3 *= 2;
SET @Var4 /= 2;
SET @Var5 %= 2;
SET @Var6 &= 2;
SET @Var7 ^= 2;
SET @Var8 |= 2;

--Выводим результат
SELECT @Var1 AS [Сложение],
	   @Var2 AS [Вычитание],
	   @Var3 AS [Умножение],
	   @Var4 AS [Деление],
	   @Var5 AS [Остаток от деления],
	   @Var6 AS [Побитовое И],
	   @Var7 AS [Побитовое исключающее ИЛИ],
	   @Var8 AS [Равно с побитовым ИЛИ]