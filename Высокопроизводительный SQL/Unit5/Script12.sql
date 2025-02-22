SET NOCOUNT ON;
USE TSQL2012;

IF OBJECT_ID('dbo.Sessions') IS NOT NULL DROP TABLE dbo.Sessions;
IF OBJECT_ID('dbo.Users') IS NOT NULL DROP TABLE dbo.Users;

CREATE TABLE dbo.Users
(
  username  VARCHAR(14)  NOT NULL,
  CONSTRAINT PK_Users PRIMARY KEY(username)
);
GO

INSERT INTO dbo.Users(username) VALUES('User1'), ('User2'), ('User3');

CREATE TABLE dbo.Sessions
(
  id        INT          NOT NULL IDENTITY(1, 1),
  username  VARCHAR(14)  NOT NULL,
  starttime DATETIME2(3) NOT NULL,
  endtime   DATETIME2(3) NOT NULL,
  CONSTRAINT PK_Sessions PRIMARY KEY(id),
  CONSTRAINT CHK_endtime_gteq_starttime
    CHECK (endtime >= starttime)
);
GO

INSERT INTO dbo.Sessions(username, starttime, endtime) VALUES
  ('User1', '20121201 08:00:00.000', '20121201 08:30:00.000'),
  ('User1', '20121201 08:30:00.000', '20121201 09:00:00.000'),
  ('User1', '20121201 09:00:00.000', '20121201 09:30:00.000'),
  ('User1', '20121201 10:00:00.000', '20121201 11:00:00.000'),
  ('User1', '20121201 10:30:00.000', '20121201 12:00:00.000'),
  ('User1', '20121201 11:30:00.000', '20121201 12:30:00.000'),
  ('User2', '20121201 08:00:00.000', '20121201 10:30:00.000'),
  ('User2', '20121201 08:30:00.000', '20121201 10:00:00.000'),
  ('User2', '20121201 09:00:00.000', '20121201 09:30:00.000'),
  ('User2', '20121201 11:00:00.000', '20121201 11:30:00.000'),
  ('User2', '20121201 11:32:00.000', '20121201 12:00:00.000'),
  ('User2', '20121201 12:04:00.000', '20121201 12:30:00.000'),
  ('User3', '20121201 08:00:00.000', '20121201 09:00:00.000'),
  ('User3', '20121201 08:00:00.000', '20121201 08:30:00.000'),
  ('User3', '20121201 08:30:00.000', '20121201 09:00:00.000'),
  ('User3', '20121201 09:30:00.000', '20121201 09:30:00.000');

GO;

DECLARE 
  @num_users          AS INT          = 2000,
  @intervals_per_user AS INT          = 2500,
  @start_period       AS DATETIME2(3) = '20120101',
  @end_period         AS DATETIME2(3) = '20120107',
  @max_duration_in_ms AS INT  = 3600000; -- 60 minutes
  
TRUNCATE TABLE dbo.Sessions;
TRUNCATE TABLE dbo.Users;

INSERT INTO dbo.Users(username)
  SELECT 'User' + RIGHT('000000000' + CAST(U.n AS VARCHAR(10)), 10) AS username
  FROM dbo.GetNums(1, @num_users) AS U;

WITH C AS
(
  SELECT 'User' + RIGHT('000000000' + CAST(U.n AS VARCHAR(10)), 10) AS username,
      DATEADD(ms, ABS(CHECKSUM(NEWID())) % 86400000,
        DATEADD(day, ABS(CHECKSUM(NEWID())) % DATEDIFF(day, @start_period, @end_period), @start_period)) AS starttime
  FROM dbo.GetNums(1, @num_users) AS U
    CROSS JOIN dbo.GetNums(1, @intervals_per_user) AS I
)
INSERT INTO dbo.Sessions WITH (TABLOCK) (username, starttime, endtime)
  SELECT username, starttime,
    DATEADD(ms, ABS(CHECKSUM(NEWID())) % (@max_duration_in_ms + 1), starttime) AS endtime
  FROM C;
GO

CREATE UNIQUE INDEX idx_user_start_id ON dbo.Sessions(username, starttime, id);
CREATE UNIQUE INDEX idx_user_end_id ON dbo.Sessions(username, endtime, id);


IF OBJECT_ID('dbo.UserIntervals', 'IF') IS NOT NULL
  DROP FUNCTION dbo.UserIntervals;
GO
ALTER FUNCTION dbo.UserIntervals
(
  @user AS VARCHAR(14)
) RETURNS TABLE
AS
RETURN
    WITH C1 AS
    --Пусть е количество событий начала, а s - завершения сеансов
    (
      SELECT id, username, starttime AS ts, +1 AS type, NULL AS e,
        ROW_NUMBER() OVER(PARTITION BY username
                          ORDER BY starttime, id) AS s
        FROM dbo.Sessions
       WHERE username=@user
        UNION ALL
        SELECT id, username, endtime AS ts, -1 AS type,
          ROW_NUMBER() OVER(PARTITION BY username
                            ORDER BY endtime, id) AS e,
          NULL AS s
          FROM dbo.Sessions
         WHERE username=@user
    ),
    C2 AS
    --Пусть se является количеством событий начала и завершения интервалов,
    --то есть число событий (начала или завершения) до текущего момента
    (
      SELECT C1.*, ROW_NUMBER() OVER(PARTITION BY username
                                     ORDER BY ts, type DESC, id) AS se
        FROM C1
    ),
    C3 AS
    --Для событий начала выражение s-(se-s)-1 показывает,
    --сколько сеансов были активны непосредственно перед текщим сеансов
    --
    --Для собитий завершения выражение (se-e)-e показывает
    --сколько сеансов были активны непосредственно после текущего сеанса
    --
    --Эти два выражения равны точно нулю в моменты соответственно
    --начала и конца упакованных интервалов
    --
    --После фильтрации только событий начала и конца упакованных интервалов
    --группируем отдельные пары соседних начала и завершения
    (
      SELECT username, ts,
        FLOOR((ROW_NUMBER() OVER(PARTITION BY username ORDER BY ts)-1)/2+1) AS grpnum
        FROM C2
       WHERE COALESCE(s-(se-s)-1, (se-e)-e)=0
    )
    SELECT username, MIN(ts) AS starttime, MAX(ts) AS endtime
      FROM C3
     GROUP BY username, grpnum;
GO

SELECT u.username, A.starttime, A.endtime
  FROM dbo.Users AS U
    CROSS APPLY dbo.UserIntervals(U.username) AS A;

