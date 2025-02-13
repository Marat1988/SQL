DECLARE @score AS TINYINT=80;

WITH C AS
(
	SELECT testid,
	  COUNT(CASE WHEN score<@score THEN 1 END)+1 AS rk,
	  COUNT(*) + 1 AS nr
	  FROM Stats.Scores
	 GROUP BY testid
)
SELECT testid, 1.0*(rk-1)/(nr-1) AS pctrank
  FROM C

DECLARE @score AS TINYINT=80;

WITH C AS
(
	SELECT testid,
	  COUNT(CASE WHEN score<=@score THEN 1 END)+1 AS np,
	  COUNT(*) +1 AS nr
	  FROM Stats.Scores
	 GROUP BY testid
)
SELECT testid, 1.0 * np / nr AS cumedust
  FROM C
