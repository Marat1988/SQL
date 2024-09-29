/*Статья https://info-comp.ru/import-excel-in-ms-sql-server*/
/*Дополнительно https://www.sqlnethub.com/blog/the-ole-db-provider-microsoft-ace-oledb-12-0-has-not-been-registered-how-to-resolve-it/ */

SELECT @@VERSION

EXEC sp_enum_oledb_providers;
GO

sp_configure 'show advanced options', 1;
RECONFIGURE;
GO

sp_configure 'Ad Hoc Distributed Queries', 1;
RECONFIGURE;
GO

EXEC sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'AllowInProcess', 1
GO

EXEC sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'DynamicParameters', 1
GO

SELECT *
FROM OPENROWSET
(
	'Microsoft.ACE.OLEDB.12.0',
	'Excel 12.0;
	Database=C:\Excel\TestExcel.xlsx',
	'SELECT * FROM [Лист1$]'
);

SELECT *
FROM OPENDATASOURCE
(
	'Microsoft.ACE.OLEDB.12.0',
	'Data Source=C:\Excel\TestExcel.xlsx;
	Extended Properties=Excel 12.0'
)...[Лист1$];

--Создание связанного сервера
EXEC sp_addlinkedserver @server='TEST_EXCEL',
						@srvproduct='EXCEL',
						@provider='Microsoft.ACE.OLEDB.12.0',
						@datasrc='C:\Excel\TestExcel.xlsx',
						@provstr='Excel 12.0;IMEX=1;HDR=YES;';
--Настройка безопасности (авторизации)
EXEC dbo.sp_addlinkedsrvlogin @rmtsrvname='TEST_EXCEL',
							  @useself='False',
							  @locallogin=NULL,
							  @rmtuser=NULL,
							  @rmtpassword=NULL;
--Обращение к связанному серверу
SELECT *
FROM OPENQUERY(TEST_EXCEL, 'SELECT * FROM [Лист1$]');

SELECT *
FROM TEST_EXCEL...[Лист1$];