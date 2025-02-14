SELECT testid, studentid, score,
  PERCENT_RANK() OVER(PARTITION BY testid ORDER BY score) AS percentrank
  FROM Stats.Scores;

SELECT testid, studentid, score,
  CUME_DIST() OVER(PARTITION BY testid ORDER BY score) AS cumedist
  FROM Stats.Scores

SELECT testid, score,
  PERCENTILE_DISC(0.5) WITHIN GROUP(ORDER BY score) OVER(PARTITION BY testid) AS percentiledisc
  FROM Stats.Scores;

SELECT testid, score,
  PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY score) OVER(PARTITION BY testid) AS percentilecont
  FROM Stats.Scores;