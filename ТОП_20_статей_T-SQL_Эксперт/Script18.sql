/*Статья https://info-comp.ru/how-to-find-launch-date-ms-sql-server*/

SELECT sqlserver_start_time
FROM sys.dm_os_sys_info

SELECT create_date
FROM sys.databases
WHERE name='tempdb'

EXEC sp_readerrorlog 0,1,'SQL Server is Starting'