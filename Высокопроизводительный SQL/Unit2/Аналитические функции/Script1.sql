SELECT *
  FROM Stats.Scores

/*
testid	    studentid	score
Test ABC	Student E	50
Test ABC	Student C	55
Test ABC	Student D	55
Test ABC	Student H	65
Test ABC	Student I	75
Test ABC	Student B	80
Test ABC	Student F	80
Test ABC	Student A	95
Test ABC	Student G	95
Test XYZ	Student E	50
Test XYZ	Student C	55
Test XYZ	Student D	55
Test XYZ	Student H	65
Test XYZ	Student I	75
Test XYZ	Student B	80
Test XYZ	Student F	80
Test XYZ	Student A	95
Test XYZ	Student G	95
Test XYZ	Student J	95
*/


/*rk - ранг строки, в котором используется то же опередение окна, что и в определении окна в аналитической функции
 nr - число строк в секции окна.
 np - число строк, которое предшествует или находится на одном уровне с текущей строкой (то же самое, что минимальное значение rk, которое больше, чем текущее значение rk
      за  вычетом единицы или nr, если текущее значение rk является максимальным)
      
PERCENT_RANK = (rk - 1) / (nr - 1)
CUME_DIST = np / nr
*/

SELECT testid, studentid, score,
  RANK() OVER(PARTITION BY testid ORDER BY score) AS rnk,
  PERCENT_RANK() OVER(PARTITION BY testid ORDER BY score) AS percentrank,
  CUME_DIST()    OVER(PARTITION BY testid ORDER BY score) AS cumedist
  FROM Stats.Scores

/*Запрос вычисляет процентильный ранг и интергральное распределение числа заказов у сотрудников*/

SELECT empid, COUNT(*) AS numorders,
  RANK() OVER(ORDER BY COUNT(*)) AS rnk,
  PERCENT_RANK() OVER(ORDER BY COUNT(*)) AS percentrank,
  CUME_DIST() OVER(ORDER BY COUNT(*)) AS cumedist
  FROM Sales.Orders
 GROUP BY empid