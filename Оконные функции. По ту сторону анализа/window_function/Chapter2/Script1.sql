SELECT orderid, custid, val,
	SUM(val) OVER() AS small,
	SUM(val) OVER(PARTITION BY custid) AS sumcust
  FROM Sales.OrderValues AS O1


SELECT orderid, custid, val,
	CAST(100. * val / SUM(val) OVER() AS NUMERIC(5,2)) AS pctall,
	CAST(100. * val / SUM(val) OVER(PARTITION BY custid) AS NUMERIC(5,2)) AS pctcust
  FROM Sales.OrderValues AS O1;


SELECT empid, ordermonth, qty,
	SUM(qty) OVER(PARTITION BY empid
		ORDER BY ordermonth
		ROWS BETWEEN UNBOUNDED PRECEDING
			AND CURRENT ROW) AS runqty
  FROM Sales.EmpOrders;

SELECT empid, ordermonth,
	MAX(qty) OVER(PARTITION BY empid
		ORDER BY ordermonth
		ROWS BETWEEN 1 PRECEDING
			AND 1 PRECEDING) AS prvqty,
	qty AS curqty,
	MAX(qty) OVER(PARTITION BY empid
		ORDER BY ordermonth
		ROWS BETWEEN 1 FOLLOWING
			AND 1 FOLLOWING) AS nxtqty,
	AVG(qty) OVER(PARTITION BY empid
		ORDER BY ordermonth
		ROWS BETWEEN 1 PRECEDING
			AND 1 FOLLOWING) AS nxtqty
  FROM Sales.EmpOrders;

/**********************************************************************************/

SET NOCOUNT ON;
USE TSQLV5;

DROP TABLE IF EXISTS dbo.T1;
GO
CREATE TABLE dbo.T1
(
  keycol INT         NOT NULL CONSTRAINT PK_T1 PRIMARY KEY,
  col1   VARCHAR(10) NOT NULL
);

INSERT INTO dbo.T1 VALUES
  (2, 'A'),(3, 'A'),
  (5, 'B'),(7, 'B'),(11, 'B'),
  (13, 'C'),(17, 'C'),(19, 'C'),(23, 'C');


SELECT keycol, col1,
	COUNT(*) OVER(ORDER BY col1
		ROWS BETWEEN UNBOUNDED PRECEDING
			AND CURRENT ROW) AS cnt
  FROM dbo.T1;

CREATE UNIQUE INDEX idx_col1D_keycol ON dbo.T1
(
	col1 DESC,
	keycol
);


SELECT keycol, col1,
	COUNT(*) OVER(ORDER BY col1, keycol
		ROWS BETWEEN UNBOUNDED PRECEDING
			AND CURRENT ROW) AS cnt
  FROM dbo.T1;

/*Для каждого заказа кол-во документов, оформленных за последние 3 дня*/
WITH C AS
(
	SELECT orderdate,
		SUM(COUNT(*)) OVER(ORDER BY orderdate
							ROWS BETWEEN 2 PRECEDING
								AND CURRENT ROW) AS numordersinlast3days
	  FROM Sales.Orders
	  GROUP BY orderdate
)

SELECT O.orderid, O.orderdate, C.numordersinlast3days
  FROM Sales.Orders AS O
 INNER JOIN C ON O.orderdate=c.orderdate;



WITH C AS
(
	SELECT orderdate,
		SUM(SUM(val)) OVER(ORDER BY orderdate
					ROWS BETWEEN 2 PRECEDING
						AND CURRENT ROW) AS sumval
	  FROM Sales.OrderValues
	 GROUP BY orderdate
)

SELECT O.orderid, O.orderdate,
	CAST(100.00 * O.val / C.sumval AS NUMERIC(5,2)) AS pctoflast3days
  FROM Sales.OrderValues AS O
 INNER JOIN C ON O.orderdate=C.orderdate;



WITH M AS
(
	SELECT DATEADD(MONTH, N.n,
					(SELECT MIN(ordermonth) FROM Sales.EmpOrders)) AS ordermonth
	  FROM dbo.GetNums(0, DATEDIFF(MONTH,
							(SELECT MIN(ordermonth) FROM Sales.EmpOrders),
							(SELECT MAX(ordermonth) FROM Sales.EmpOrders))) AS N
),
C AS
(
	SELECT E.empid, M.ordermonth, EO.qty,
		SUM(EO.qty) OVER(PARTITION BY E.empid
			ORDER BY M.ordermonth
			ROWS 2 PRECEDING) AS sum3month
	  FROM Hr.Employees AS E
	  CROSS JOIN M
	  LEFT OUTER JOIN Sales.EmpOrders AS EO ON e.empid=EO.empid AND M.ordermonth=EO.ordermonth
)
SELECT empid, ordermonth, qty, sum3month
  FROM C
 WHERE qty IS NOT NULL


SELECT empid, ordermonth, qty,
	SUM(qty) OVER(PARTITION BY empid
		ORDER BY ordermonth
		RANGE BETWEEN UNBOUNDED PRECEDING
			AND CURRENT ROW) AS runqty
  FROM Sales.EmpOrders;


SELECT keycol, col1,
	COUNT(*) OVER(ORDER BY col1
		RANGE BETWEEN UNBOUNDED PRECEDING
			AND CURRENT ROW
			) AS cnt
  FROM dbo.T1;

SELECT keycol, col1,
	COUNT(*) OVER(ORDER BY col1, keycol
		ROWS BETWEEN UNBOUNDED PRECEDING
			AND CURRENT ROW) AS cnt
  FROM dbo.T1;

SELECT col1,
	SUM(COUNT(*)) OVER(ORDER BY col1
		ROWS BETWEEN UNBOUNDED PRECEDING
			AND CURRENT ROW) AS cnt
  FROM dbo.T1
 GROUP BY col1;


SELECT empid, ordermonth,
	qty, qty - AVG(CASE WHEN ordermonth<=DATEADD(MONTH, -3, CURRENT_TIMESTAMP) THEN qty END) OVER(PARTITION BY empid) AS diff
  FROM Sales.EmpOrders;

/************************************************************************************/

SET NOCOUNT ON;
USE TSQLV5;

DROP TABLE IF EXISTS dbo.T2;

CREATE TABLE dbo.T2
(
  ordcol  INT NOT NULL,
  datacol INT NOT NULL,
  CONSTRAINT PK_T2
    PRIMARY KEY(ordcol)
);

INSERT INTO dbo.T2 VALUES
  (1,   10),
  (4,   15),
  (5,    5),
  (6,   10),
  (8,   15),
  (10,  20),
  (17,  10),
  (18,  10),
  (20,  30),
  (31,  20);
/************************************************************************************/

WITH C AS
(
	SELECT empid, orderdate, orderid, custid, val,
		CASE WHEN ROW_NUMBER() OVER(PARTITION BY empid, custid
				ORDER BY orderdate)=1
			THEN custid END AS distinct_custid
	 FROM Sales.OrderValues
)
SELECT empid, orderdate, orderid, val,
	COUNT(distinct_custid) OVER(PARTITION BY empid
		ORDER BY orderdate) AS numcusts
  FROM C;

SELECT empid,
	SUM(val) AS emptotal,
	SUM(val)/SUM(SUM(val)) OVER()*100. AS pct
  FROM Sales.OrderValues
 GROUP BY empid;

WITH C AS
(
	SELECT empid, orderdate,
		CASE WHEN ROW_NUMBER() OVER(PARTITION BY empid, custid ORDER BY orderdate)=1 THEN custid END AS distinct_custid
	  FROM Sales.Orders
)
SELECT empid, orderdate,
	SUM(COUNT(distinct_custid)) OVER(PARTITION BY empid
		ORDER BY orderdate) AS numcusts
  FROM C
 GROUP BY empid, orderdate

 /************************************************************************************/

SELECT orderid, val,
	ROW_NUMBER() OVER(ORDER BY orderid) AS rownum
  FROM Sales.OrderValues
 ORDER BY val DESC


SELECT orderid, val,
	COUNT(*) OVER(ORDER BY orderid
		ROWS UNBOUNDED PRECEDING) AS rownum
  FROM Sales.OrderValues

SELECT orderid, orderdate, val,
	ROW_NUMBER() OVER(ORDER BY orderdate DESC) AS rownum
  FROM Sales.OrderValues

SELECT orderid, orderdate, val,
	ROW_NUMBER() OVER(ORDER BY orderdate DESC, orderid DESC) AS rownum
  FROM Sales.OrderValues

SELECT orderid, orderdate, val,
	ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS rownum
  FROM Sales.OrderValues

SELECT orderid, val,
	ROW_NUMBER() OVER(ORDER BY val) AS rownum,
	NTILE(10) OVER(ORDER BY val) AS tile
  FROM Sales.OrderValues

SELECT orderid, val,
	ROW_NUMBER() OVER(ORDER BY val) AS rownum,
	(ROW_NUMBER() OVER(ORDER BY val) - 1)/10 + 1 AS pagenum
  FROM Sales.OrderValues

SELECT orderid, val,
	ROW_NUMBER() OVER(ORDER BY val, orderid) AS rownum,
	NTILE(10) OVER(ORDER BY val, orderid) AS tile
  FROM Sales.OrderValues


SELECT orderid, val,
	ROW_NUMBER() OVER(ORDER BY val, orderid) AS rownum,
	NTILE(100) OVER(ORDER BY val, orderid) AS tile
  FROM Sales.OrderValues

SELECT orderid, orderdate, val,
	ROW_NUMBER() OVER(ORDER BY orderdate DESC) AS rownum,
	RANK()		 OVER(ORDER BY orderdate DESC) AS rnk,
	DENSE_RANK() OVER(ORDER BY orderdate DESC) AS drnk
  FROM Sales.OrderValues


/*****************************************************************************/

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


1) Пусть rk - это ранг строки, вычисленные при помощи функции RANK с использованием той же спецификации,
     окна, которая применяется при выполнении функции распределения;
2) Пусть nr - это количество строк в секции;
3) Пусть np - это количество строк с меньшим или таким же значением упорядочивания, как в текущей строке (также может быть вычислено как минимальное
	 значение rk больше текущего, уменьшенного на единицу, а в случае достижения rk максимума - как nr)

С учетом введенныъ выше переменных можно прописать формулы для вычисления. 
Функция PERCENT_RANK вычисляется как (rk-1)/(nr-1)
Функция CUME_DIST как np/nr

*/

SELECT testid, studentid, score,
    RANK() OVER(PARTITION BY testid ORDER BY score) AS rank,
	PERCENT_RANK() OVER(PARTITION BY testid ORDER BY score) AS percentrank,
	CUME_DIST() OVER(PARTITION BY testid ORDER BY score) AS cumedist
  FROM Stats.Scores;

/*
testid	studentid	score	rank	percentrank	cumedist
Test ABC	Student E	50	1	0	0,111111111111111
Test ABC	Student C	55	2	0,125	0,333333333333333
Test ABC	Student D	55	2	0,125	0,333333333333333
Test ABC	Student H	65	4	0,375	0,444444444444444
Test ABC	Student I	75	5	0,5	0,555555555555556
Test ABC	Student B	80	6	0,625	0,777777777777778
Test ABC	Student F	80	6	0,625	0,777777777777778
Test ABC	Student A	95	8	0,875	1
Test ABC	Student G	95	8	0,875	1
Test XYZ	Student E	50	1	0	0,1
Test XYZ	Student C	55	2	0,111111111111111	0,3
Test XYZ	Student D	55	2	0,111111111111111	0,3
Test XYZ	Student H	65	4	0,333333333333333	0,4
Test XYZ	Student I	75	5	0,444444444444444	0,5
Test XYZ	Student B	80	6	0,555555555555556	0,7
Test XYZ	Student F	80	6	0,555555555555556	0,7
Test XYZ	Student A	95	8	0,777777777777778	1
Test XYZ	Student G	95	8	0,777777777777778	1
Test XYZ	Student J	95	8	0,777777777777778	1

*/

/*Вычисялется процентильный ранг и накопительное распределение по количеству заказов по сотрудникам*/


/*
empid	numorders
1	123
2	96
3	127
4	156
5	42
6	67
7	72
8	104
9	43
*/


SELECT empid, COUNT(*) AS numorders,
	RANK() OVER(ORDER BY COUNT(*)) AS rnk,
	PERCENT_RANK() OVER(ORDER BY COUNT(*)) AS percentrank,
	CUME_DIST() OVER(ORDER BY COUNT(*)) AS cumedist
  FROM Sales.Orders
 GROUP BY empid

/*******************************************************************/


SELECT testid, studentid, score,
  RANK() OVER(PARTITION BY testid ORDER BY score) AS rnk,
  PERCENT_RANK() OVER(PARTITION BY testid ORDER BY score) AS percentrank,
  CUME_DIST()    OVER(PARTITION BY testid ORDER BY score) AS cumedist
  FROM Stats.Scores;


SELECT testid, studentid, score,
  PERCENTILE_DISC(0.3) WITHIN GROUP(ORDER BY score) OVER(PARTITION BY testid) AS percentile
FROM Stats.Scores

DECLARE @pct AS FLOAT=0.7 --0.5

SELECT testid, studentid, score,
  CUME_DIST()    OVER(PARTITION BY testid ORDER BY score) AS cumedist,
  PERCENTILE_DISC(@pct) WITHIN GROUP(ORDER BY score) OVER(PARTITION BY testid) AS percentiledisc,
  PERCENTILE_CONT(@pct)  WITHIN GROUP(ORDER BY score) OVER(PARTITION BY testid) AS percentilecont
FROM Stats.Scores



