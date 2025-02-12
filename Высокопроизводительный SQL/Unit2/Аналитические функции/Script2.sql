SELECT testid, studentid, score,
  RANK() OVER(PARTITION BY testid ORDER BY score) AS rnk,
  PERCENT_RANK() OVER(PARTITION BY testid ORDER BY score) AS percentrank,
  CUME_DIST()    OVER(PARTITION BY testid ORDER BY score) AS cumedist
  FROM Stats.Scores

/*По cumedist выше*/
SELECT testid, studentid, score,
  PERCENTILE_DISC(0.5) WITHIN GROUP(ORDER BY score) OVER(PARTITION BY testid) AS percentile
FROM Stats.Scores


/*Работу функции PERCENTILE_CONT (CONT означает «continuous distribution model», «модель непрерывного распределения») объяснить сложнее.
 Пусть у нас сеть функция PERCENTILE_CONT(@pct) WITHIN GROUP(ORDER BY score).
 Допустим, что n — число строк в группе.
 Пусть a равно @pct*(n - 1), при этом i — целая, а f — дробная часть a.
 Допустим, что row0 и row1 — строки с номерами FLOOR(a) и CEILING(a) (нумерация начинается с нуля).
 Здесь предполагается, что номера строк вычисляются на основе того же секционирования и упорядочения окна, что используется при группировке и упорядочении, что и в функции PERCENTILE_CONT.

 Тогда PERCENTILE_CONT вычисляется как row0.score + f * (row1.score - row0.score). Это интерполяция значений в двух строках в предположении непрерывного распределения (основанного на дробной части a).*/

DECLARE @pct AS FLOAT=0.1 --0.5

SELECT testid, score,
  PERCENTILE_DISC(@pct) WITHIN GROUP(ORDER BY score) OVER(PARTITION BY testid) AS percentiledisc,
  PERCENTILE_CONT(@pct) WITHIN GROUP(ORDER BY score) OVER(PARTITION BY testid) AS percentilecont
  FROM Stats.Scores;

  SELECT FLOOR(0.9), CEILING(0.9)