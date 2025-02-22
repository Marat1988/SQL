WITH C AS
(
  SELECT testid, ROW_NUMBER() OVER(PARTITION BY testid
                                       ORDER BY (SELECT NULL)) AS rownum,
    PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY score) OVER (PARTITION BY testid) AS median
    FROM Stats.Scores
)
SELECT *
  FROM C
 WHERE rownum=1;