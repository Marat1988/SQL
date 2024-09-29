/*Статья https://info-comp.ru/obucheniest/566-checking-whether-user-belongs-to-group-or-role.html*/

IF IS_MEMBER('db_owner')=1
	SELECT 'Пользователь является членом группы db_owner' AS [Результат]
ELSE
	SELECT 'Пользователь не входим в группу db_owner' AS [Результат]

IF IS_SRVROLEMEMBER('sysadmin')=1
	SELECT 'Позьзователь является членом роли сервера sysadmin' AS [Результат]
ELSE
	SELECT 'Позьзователь не является членом роли сервера sysadmin' AS [Результат]