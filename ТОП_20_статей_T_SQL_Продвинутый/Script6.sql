/*Статья https://info-comp.ru/obucheniest/361-trigger-in-transact-sql.html*/

DROP TABLE IF EXISTS TestTable
GO

CREATE TABLE TestTable
(
	[number] INT NULL,
	[pole1] NVARCHAR(255) NULL,
	[pole2] NVARCHAR(255) NULL
)
GO

INSERT INTO TestTable
VALUES (1, 'Иванов', 'Иван'),
	   (2, 'Петров', 'Петр')
GO

CREATE TABLE dbo.[audit]
(
	id BIGINT IDENTITY(1,1) NOT NULL,
	table_name VARCHAR(50) NOT NULL,
	oper VARCHAR(15) NOT NULL,
	record_old XML NULL,
	record_new XML NULL,
	username VARCHAR(50) NOT NULL,
	data_ch DATETIME NULL
	CONSTRAINT PK_audit PRIMARY KEY CLUSTERED
	(
		id ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TRIGGER dbo.trg_test_table_update ON dbo.TestTable
FOR UPDATE
AS
BEGIN
	SET NOCOUNT ON
	--переменнве для хранения старых и новых данных
	DECLARE @record_new XML
	DECLARE @record_old XML
	--задаем значения этим переменным
	--в таблице deleted хранятся старые данные, или удаленные
	SET @record_old=(SELECT * FROM deleted FOR XML RAW, TYPE);
	--в таблице inserted хранятся измененные данные, или только что созданные
	SET @record_new=(SELECT * FROM inserted FOR XML RAW, TYPE);
	/*Проверяем, действительно ли update обновил хотя бы одну строку,
	т.к. может возникнуть ситуация Вы запустили update
	при этом он не обновил не одной строки, не подошло условие*/
	IF @record_new IS NOT NULL AND @record_old IS NOT NULL
	BEGIN
		INSERT INTO audit (table_name, oper, record_old, record_new, username, data_ch)
		VALUES ('test_table', 'update', @record_old, @record_new, SUSER_NAME(), GETDATE())
	END
END

UPDATE TestTable SET pole1='обновили', pole2='обновили'
WHERE number = 1

SELECT *
FROM TestTable

SELECT *
FROM audit

UPDATE TestTable SET pole1='обновили', pole2='обновили'
WHERE number IN (1,2)

SELECT *
FROM audit