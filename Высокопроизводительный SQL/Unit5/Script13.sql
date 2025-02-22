IF OBJECT_ID('dbo.UserIntervals','IF') IS NOT NULL
  DROP FUNCTION dbo.UserIntervals;
GO

ALTER FUNCTION dbo.UserIntervals(@user AS VARCHAR(14)) RETURNS TABLE
AS
RETURN
    WITH C1 AS
    (
      SELECT username, starttime AS ts, +1 AS type, 1 AS sub
        FROM dbo.Sessions
       WHERE username=@user
       UNION ALL
      SELECT username, endtime AS ts, -1 AS type, 0 AS sub
        FROM dbo.Sessions
        WHERE username=@user
    ),
    C2 AS
    (
      SELECT C1.*,
        SUM(type) OVER(PARTITION BY username
                           ORDER BY ts, type DESC
                       ROWS BETWEEN UNBOUNDED PRECEDING
                                AND CURRENT ROW)-sub AS cnt
        FROM C1
    ),
    C3 AS
    (
      SELECT username, ts,
        FLOOR((ROW_NUMBER() OVER(PARTITION BY username
                                     ORDER BY ts) - 1) / 2 + 1) AS grpnum
        FROM C2
       WHERE cnt=0
    )
    SELECT username, MIN(ts) AS starttime, MAX(ts) AS endtime
      FROM C3
     GROUP BY username, grpnum;
GO

SELECT U.username, A.starttime, A.endtime
  FROM dbo.Users AS U
    CROSS APPLY dbo.UserIntervals(U.username) AS A;