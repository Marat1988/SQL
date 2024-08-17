/*По материалам сайта https://info-comp.ru/obucheniest/631-dynamic-pivot-in-t-sql.html*/

--Создаем универсальную процедуру для динамического PIVOT
ALTER PROCEDURE SP_Dynamic_Pivot
(
    @TableSRC NVARCHAR(100),   --Таблица источник (Представление)
    @ColumnName NVARCHAR(100), --Столбец, содержащий значения, которые станут именами столбцов
    @Field NVARCHAR(100),      --Столбец, над которым проводить агрегацию
    @FieldRows NVARCHAR(100),  --Столбец (столбцы) для группировки по строкам (Column1, Column2)
    @FunctionType NVARCHAR(20) = 'SUM',--Агрегатная функция (SUM, COUNT, MAX, MIN, AVG), по умолчанию SUM
    @Condition NVARCHAR(200) = '' --Условие (WHERE и т.д.). По умолчанию без условия
)
AS 
BEGIN

    --Отключаем вывод количества строк
    SET NOCOUNT ON;
        
    --Переменная для хранения строки запроса
    DECLARE @Query NVARCHAR(MAX);                     
    --Переменная для хранения имен столбцов
    DECLARE @ColumnNames NVARCHAR(MAX);              
    --Переменная для хранения заголовков результирующего набора данных
    DECLARE @ColumnNamesHeader NVARCHAR(MAX); 

    --Обработчик ошибок
    BEGIN TRY
        --Таблица для хранения уникальных значений, которые будут использоваться в качестве столбцов      
        CREATE TABLE #ColumnNames(ColumnName NVARCHAR(100) NOT NULL PRIMARY KEY);
        
        --Формируем строку запроса для получения уникальных значений для имен столбцов
        SET @Query = N'INSERT INTO #ColumnNames (ColumnName) SELECT DISTINCT COALESCE(' + @ColumnName + ', ''Пусто'') 
                       FROM ' + @TableSRC + ' ' + @Condition + ';'
                
        --Выполняем строку запроса
        EXEC (@Query);

        --Формируем строку с именами столбцов
        SELECT @ColumnNames = ISNULL(@ColumnNames + ', ','') + QUOTENAME(ColumnName) 
        FROM #ColumnNames;
                
        --Формируем строку для заголовка динамического перекрестного запроса (PIVOT)
        SELECT @ColumnNamesHeader = ISNULL(@ColumnNamesHeader + ', ','') + 'COALESCE(' + QUOTENAME(ColumnName) + ', 0) AS ' + QUOTENAME(ColumnName)
        FROM #ColumnNames;
        
        --Формируем строку с запросом PIVOT
        SET @Query = N'SELECT ' + @FieldRows + ' , ' + @ColumnNamesHeader + ' 
                       FROM (SELECT ' + @FieldRows + ', ' + @ColumnName + ', ' + @Field 
                            + ' FROM ' + @TableSRC  + ' ' + @Condition + ') AS SRC
                       PIVOT ( ' + @FunctionType + '(' + @Field + ')' +' FOR ' + @ColumnName + ' IN (' + @ColumnNames + ')) AS PVT
                       ORDER BY ' + @FieldRows + ';'
                
        --Удаляем временную таблицу
        DROP TABLE #ColumnNames;

        --Выполняем строку запроса с PIVOT
        EXEC (@Query);
                
        --Включаем обратно вывод количества строк
        SET NOCOUNT OFF;
                
END TRY
BEGIN CATCH
    --В случае ошибки, возвращаем номер и описание этой ошибки
    SELECT ERROR_NUMBER() AS [Номер ошибки], 
           ERROR_MESSAGE() AS [Описание ошибки]
END CATCH
END

--Инструкция создания таблицы
DROP TABLE IF EXISTS TestTable;

CREATE TABLE TestTable
(
	ProductId INT IDENTITY(1,1) NOT NULL,
	CategoryName VARCHAR(100) NOT NULL,
	ProductName VARCHAR(100) NOT NULL,
	Summa MONEY NULL,
	YearSales INT NOT NULL
)
GO


--Инстуркция добавления данных
INSERT INTO TestTable(CategoryName, ProductName, Summa, YearSales)
VALUES ('Комплектующие компьютера', 'Мышь', 100, 2015),
	   ('Комплектующие компьютера', 'Мышь', 110, 2016),
	   ('Комплектующие компьютера', 'Мышь', 120, 2017),
	   ('Комплектующие компьютера', 'Мышь', 130, 2018),
	   ('Комплектующие компьютера', 'Мышь', 130, 2016),
	   ('Комплектующие компьютера', 'Клавиатура', 170, 2016),
	   ('Комплектующие компьютера', 'Клавиатура', 180, 2017),
	   ('Комплектующие компьютера', 'Клавиатура', 190, 2018),
	   ('Комплектующие компьютера', 'Клавиатура', 200, 2018),
	   ('Мобильные устрйства', 'Телефон', 400, 2015),
	   ('Мобильные устрйства', 'Телефон', 450, 2016),
	   ('Мобильные устрйства', 'Телефон', 500, 2017),
	   ('Мобильные устрйства', 'Телефон', 550, 2017),
	   ('Мобильные устрйства', 'Телефон', 600, 2018)
GO

--Запрос на выборку (смотрим, какие данные у нас есть)
SELECT *
FROM TestTable

--Пример 1. Получаем суммы по годам с группировкой по категории
EXEC SP_Dynamic_Pivot @TableSRC = 'TestTable', --Таблица источник
					  @ColumnName = 'YearSales', --Столбец, содержащий значения для столбцов в PIVOT
					  @Field = 'Summa', --Столбец, над которым проводить агрегацию
					  @FieldRows = 'CategoryName', --Столбец для группировки по строкам
					  @FunctionType = 'SUM' --Агрегатная функция, по-умолчанию SUM

--Пример 2. Получаем количество по годам с группировкой по категории и товару
EXEC SP_Dynamic_Pivot @TableSRC = 'TestTable', --Таблица источник
					  @ColumnName = 'YearSales', --Столбец, содержащий значения для столбцов в PIVOT
					  @Field = 'Summa', --Столбец, над которым проводить агрегацию
					  @FieldRows = 'CategoryName, ProductName', --Столбец для группировки по строкам
					  @FunctionType = 'COUNT' --Агрегатная функция, по-умолчанию SUM

--Пример 3. Получаем суммы по годам с группировкой по товару в конкретной категории
EXEC SP_Dynamic_Pivot @TableSRC = 'TestTable', --Таблица источник
					  @ColumnName = 'YearSales', --Столбец, содержащий значения для столбцов в PIVOT
					  @Field = 'Summa', --Столбец, над которым проводить агрегацию
					  @FieldRows = 'ProductName', --Столбец для группировки по строкам
					  @FunctionType = 'SUM', --Агрегатная функция, по-умолчанию SUM
                      @Condition = 'WHERE CategoryName = ''Комплектующие компьютера'''
