DECLARE @pct AS FLOAT = 0.5;

SELECT testid, score,
  PERCENTILE_DISC(@pct) WITHIN GROUP(ORDER BY score) OVER(PARTITION BY testid) AS percentiledisc,
  PERCENTILE_CONT(@pct) WITHIN GROUP(ORDER BY score) OVER(PARTITION BY testid) AS percentilecont
  FROM Stats.Scores

DECLARE @pct AS FLOAT=0.5;

SELECT testid,
  PERCENTILE_DISC(@pct) WITHIN GROUP(ORDER BY score) AS percentiledisc,
  PERCENTILE_CONT(@pct) WITHIN GROUP(ORDER BY score) AS percentilecont
  FROM Stats.Scores
 GROUP BY testid;