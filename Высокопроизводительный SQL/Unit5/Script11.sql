SET NOCOUNT ON;
USE TSQL2012;

IF OBJECT_ID('dbo.Sessions','U') IS NOT NULL
  DROP TABLE dbo.Sessions;

CREATE TABLE dbo.Sessions
(
  keycol    INT         NOT NULL,
  app       VARCHAR(10) NOT NULL,
  usr       VARCHAR(10) NOT NULL,
  host      VARCHAR(10) NOT NULL,
  starttime DATETIME    NOT NULL,
  endtime   DATETIME    NOT NULL,
  CONSTRAINT PK_Sessions PRIMARY KEY(keycol),
  CHECK(endtime>starttime)
);
GO

CREATE UNIQUE INDEX idx_nc_app_st_et
  ON dbo.Sessions(app, starttime, keycol)
INCLUDE (endtime);

CREATE UNIQUE INDEX idx_nc_app_et_st
  ON dbo.Sessions(app, endtime, keycol)
INCLUDE(starttime);

TRUNCATE TABLE dbo.Sessions;

INSERT INTO dbo.Sessions(keycol, app, usr, host, starttime, endtime) VALUES
  (2,  'app1', 'user1', 'host1', '20120212 08:30', '20120212 10:30'),
  (3,  'app1', 'user2', 'host1', '20120212 08:30', '20120212 08:45'),
  (5,  'app1', 'user3', 'host2', '20120212 09:00', '20120212 09:30'),
  (7,  'app1', 'user4', 'host2', '20120212 09:15', '20120212 10:30'),
  (11, 'app1', 'user5', 'host3', '20120212 09:15', '20120212 09:30'),
  (13, 'app1', 'user6', 'host3', '20120212 10:30', '20120212 14:30'),
  (17, 'app1', 'user7', 'host4', '20120212 10:45', '20120212 11:30'),
  (19, 'app1', 'user8', 'host4', '20120212 11:00', '20120212 12:30'),
  (23, 'app2', 'user8', 'host1', '20120212 08:30', '20120212 08:45'),
  (29, 'app2', 'user7', 'host1', '20120212 09:00', '20120212 09:30'),
  (31, 'app2', 'user6', 'host2', '20120212 11:45', '20120212 12:00'),
  (37, 'app2', 'user5', 'host2', '20120212 12:30', '20120212 14:00'),
  (41, 'app2', 'user4', 'host3', '20120212 12:45', '20120212 13:30'),
  (43, 'app2', 'user3', 'host3', '20120212 13:00', '20120212 14:00'),
  (47, 'app2', 'user2', 'host4', '20120212 14:00', '20120212 16:30'),
  (53, 'app2', 'user1', 'host4', '20120212 15:30', '20120212 17:00');


TRUNCATE TABLE dbo.Sessions;

DECLARE
  @numrows AS INT=100000, --Общее число строк
  @numapps AS INT=10;     --число приложений

INSERT INTO dbo.Sessions WITH(TABLOCK)
    (keycol, app, usr, host, starttime, endtime)
  SELECT
    ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS keycol,
    D.*,
    DATEADD(
      SECOND,
      1+ABS(CHECKSUM(NEWID())) %(20*60),
      starttime) AS endtime
    FROM
    (
      SELECT 'app' + CAST(1+ABS(CHECKSUM(NEWID()))%@numapps AS VARCHAR(10)) AS app,
        'user1' AS usr,
        'host1' AS host,
        DATEADD(
            SECOND,
            1 + ABS(CHECKSUM(NEWID()))%(30*24*60*60),
            '20120101') AS starttime
        FROM dbo.GetNums(1, @numrows) AS Nums
    ) AS D

WITH TimePoints AS
(
    SELECT app, starttime AS ts
      FROM dbo.Sessions
),
Counts AS
(
    SELECT app, ts,
      (SELECT COUNT(*)
        FROM dbo.Sessions AS S
       WHERE p.app=s.app
         AND p.ts >= S.starttime
         AND p.ts < s.endtime) AS concurrent
      FROM TimePoints AS P
)
SELECT app, MAX(concurrent) AS mx
  FROM Counts
 GROUP BY app;
 GO

WITH C1 AS
(
  SELECT app, starttime AS ts, +1 AS type
    FROM dbo.Sessions
   UNION ALL
   SELECT app, endtime, -1
     FROM dbo.Sessions
),
C2 AS
(
  SELECT *, SUM(type) OVER(PARTITION BY app
                           ORDER BY ts, type
                           ROWS BETWEEN UNBOUNDED PRECEDING
                                    AND CURRENT ROW) AS cnt
    FROM C1
)
SELECT app, MAX(cnt) AS mx
  FROM C2
 GROUP BY app;