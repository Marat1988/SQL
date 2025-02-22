IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1;

CREATE TABLE dbo.T1
(
  id  INT         NOT NULL PRIMARY KEY,
  val VARCHAR(10) NOT NULL
);
GO

INSERT INTO dbo.T1(id, val) VALUES
  (2, 'a'),
  (3, 'a'),
  (5, 'a'),
  (7, 'b'),
  (11, 'b'),
  (13, 'a'),
  (17, 'a'),
  (19, 'a'),
  (23, 'c'),
  (29, 'c'),
  (31, 'a'),
  (37, 'a'),
  (41, 'a'),
  (43, 'a'),
  (47, 'c'),
  (53, 'c'),
  (59, 'c');

WITH C AS
(
  SELECT id, val,
    ROW_NUMBER() OVER(ORDER BY id)-ROW_NUMBER() OVER(ORDER BY val, id) AS grp
    FROM dbo.T1
)
SELECT MIN(id) AS mn, MAX(id) AS mx, val
  FROM C
 GROUP BY val, grp
 ORDER BY mn;