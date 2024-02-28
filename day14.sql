/*
  WITHÀý : º°ÄªÀ¸·Î »ç¿ëÇÑ SELECT ¹®À» ´Ù¸¥ SELECT ¹®¿¡¼­ º°ÄªÀ¸·Î ÂüÁ¶°¡´É
           - ¹Ýº¹µÇ´Â ¼­ºêÄõ¸®°¡ ÀÖ´Ù¸é º¯¼öÃ³·³ ÇÑ¹ø ºÒ·¯¿Í¼­ »ç¿ë
           - º¹ÀâÇÑ Åë°èÄõ¸®³ª Å×ÀÌºíÀ» Å½»öÇÒ¶§ ¸¹ÀÌ »ç¿ë
    temp¶ó´Â ÀÓ½Ã Å×ÀÌºíÀ» »ç¿ëÇØ¼­ Àå½Ã°£ °É¸®´Â Äõ¸®ÀÇ °á°ú¸¦ ÀúÀåÇØ³õ°í
    ÀúÀåÇØ³õÀº µ¥ÀÌÅÍ¸¦ ¿¢¼¼½ºÇÏ±â ¶§¹®¿¡ ¼º´ÉÀÌ ÁÁÀ» ¼ö ÀÖÀ½.
*/
WITH A AS(   -- º°Äª 
       SELECT *
       FROM employees
)
SELECT *
FROM A;

--- 8 ~ 14 ÀÚ¸®, ´ë¹®ÀÚ1,¼Ò¹®ÀÚ1,Æ¯¼ö¹®ÀÚ1 Æ÷ÇÔ Å×½ºÆ®
WITH test_data AS(
   SELECT 'abcd' AS pw FROM dual UNION ALL
   SELECT 'abcd!1A' AS pw FROM dual UNION ALL
   SELECT 'abcdasdfas' AS pw FROM dual UNION ALL
   SELECT 'abcd!1Ad' AS pw FROM dual 
)
SELECT pw
FROM test_data
WHERE LENGTH(pw) BETWEEN 8 AND 14
AND REGEXP_LIKE(pw, '[A-Z]')
AND REGEXP_LIKE(pw, '[a-z]')
AND REGEXP_LIKE(pw, '[^a-zA-Z0-9°¡-ÆR]');
-- °í°´Áß Ä«Æ® »ç¿ëÈ½¼ö°¡ °¡Àå ¸¹Àº °í°´°ú °¡ÀåÀûÀº °í°´ÀÇ Á¤º¸¸¦ Ãâ·ÂÇÏ½Ã¿À
--(±¸¸ÅÀÌ·ÂÀÌ ÀÖ´Â °í°´Áß)
SELECT MAX(cnt) as max_cnt
     , MIN(cnt) as min_cnt
FROM (
    SELECT a.mem_id, a.mem_name, count(DISTINCT b.cart_no) cnt
    FROM member a
       , cart b
    WHERE a.mem_id = b.cart_member
    GROUP BY a.mem_id, a.mem_name );

SELECT *
FROM (  SELECT a.mem_id, a.mem_name, count(DISTINCT b.cart_no) cnt
        FROM member a
           , cart b
        WHERE a.mem_id = b.cart_member
        GROUP BY a.mem_id, a.mem_name)
WHERE cnt = (SELECT MAX(cnt) as max_cnt
                FROM (
                    SELECT a.mem_id, a.mem_name, count(DISTINCT b.cart_no) cnt
                    FROM member a
                       , cart b
                    WHERE a.mem_id = b.cart_member
                    GROUP BY a.mem_id, a.mem_name ))
OR    cnt = ( SELECT MIN(cnt) as min_cnt
                FROM (
                    SELECT a.mem_id, a.mem_name, count(DISTINCT b.cart_no) cnt
                    FROM member a
                       , cart b
                    WHERE a.mem_id = b.cart_member
                    GROUP BY a.mem_id, a.mem_name ) 
                    
                    );
--- À§ÀÇ ³»¿ëÀ» with »ç¿ë
WITH T1 AS (SELECT a.mem_id, a.mem_name, count(DISTINCT b.cart_no) cnt
            FROM member a, cart b
            WHERE a.mem_id = b.cart_member
            GROUP BY a.mem_id, a.mem_name
)
, T2 AS(  SELECT MAX(T1.cnt) as max_cnt, MIN(T1.cnt) as min_cnt
          FROM T1
)
SELECT t1.mem_id, t1.mem_name, t1.cnt FROM t1, t2
WHERE t1.cnt = t2.max_cnt
OR   t1.cnt = t2.min_cnt;

/*  2000³âµµ ÀÌÅ»¸®¾ÆÀÇ '¿¬Æò±Õ ¸ÅÃâ¾×' º¸´Ù Å« '¿ùÀÇ Æò±Õ ¸ÅÃâ¾×'
    ÀÌ¾ú´ø '³â¿ù', '¸ÅÃâ¾×'À» Ãâ·ÂÇÏ½Ã¿À  (¼Ò¼öÁ¡ ¹Ý¿Ã¸²)
*/
SELECT cust_id, sales_month, amount_sold
FROM sales;
SELECT cust_id, country_id
FROM customers;
SELECT country_id, country_name
FROM countries;
-- ¿¬Æò±Õ
SELECT ROUND(AVG(a.amount_sold)) as year_avg
FROM sales a, customers b, countries c
WHERE a.cust_id = b.cust_id
AND   b.country_id = c.country_id
AND   a.sales_month LIKE '2000%'
AND   c.country_name = 'Italy';
--¿ùÆò±Õ
SELECT  a.sales_month
      , ROUND(AVG(a.amount_sold)) as month_avg
FROM sales a, customers b, countries c
WHERE a.cust_id = b.cust_id
AND   b.country_id = c.country_id
AND   a.sales_month LIKE '2000%'
AND   c.country_name = 'Italy'
GROUP BY a.sales_month;

SELECT *
FROM (SELECT  a.sales_month
              , ROUND(AVG(a.amount_sold)) as month_avg
        FROM sales a, customers b, countries c
        WHERE a.cust_id = b.cust_id
        AND   b.country_id = c.country_id
        AND   a.sales_month LIKE '2000%'
        AND   c.country_name = 'Italy'
        GROUP BY a.sales_month
        )
WHERE month_avg > (SELECT ROUND(AVG(a.amount_sold)) as year_avg
                    FROM sales a, customers b, countries c
                    WHERE a.cust_id = b.cust_id
                    AND   b.country_id = c.country_id
                    AND   a.sales_month LIKE '2000%'
                    AND   c.country_name = 'Italy');

----------
WITH T1 as (SELECT  a.sales_month, a.amount_sold
            FROM sales a, customers b, countries c
            WHERE a.cust_id = b.cust_id
            AND   b.country_id = c.country_id
            AND   a.sales_month LIKE '2000%'
            AND   c.country_name = 'Italy'
), T2 as ( SELECT AVG(t1.amount_sold) as year_avg
          FROM t1
), T3 as ( SELECT t1.sales_month
                , ROUND(AVG(t1.amount_sold)) as month_avg
          FROM t1
          GROUP BY t1.sales_month
)
SELECT t3.sales_month, t3.month_avg
FROM t2, t3 WHERE t3.month_avg > t2.year_avg;

/*  ºÐ¼®ÇÔ¼ö ·Î¿ì¼Õ½Ç ¾øÀÌ Áý°è°ªÀ» »êÃâ ÇÒ ¼ö ÀÖÀ½ 
    ³í¸®Àû ±âÁØ or ·Î¿ì¼ø¼­±âÁØÀ¸·Î ºÎºÐÁý°è¸¦ ÇÒ ¼ö ÀÖÀ½
    (ex ¿ùº° ´©ÀûÇÕ°è)
    ºÐ¼®ÇÔ¼ö :AVG, SUM, MAX, MIN, COUNT, DENSE_RANK, RANK, LAG...
    PARTITION BY : ±×·ì 
    ORDER BY : Á¤·Ä Á¶°Ç
    WINDOW : ±×·ì¾È¿¡ »ó¼¼ÇÑ ±×·ìÀ¸·Î ºÐÇÒ ÇÒ ¶§ 
*/
-- ROW_NUMBER ±×·ìº° ·Î¿ì¿¡ ´ëÇÑ ¼ø¹ø¹ÝÈ¯ 
SELECT department_id, emp_name
      ,ROW_NUMBER() OVER(PARTITION BY department_id
                         ORDER BY emp_name) dep_rownum
FROM employees;

-- ºÎ¼­º° ÀÌ¸§¼øÀ¸·Î °¡Àå Ã¹¹øÂ° Á÷¿øÀ» Ãâ·ÂÇÏ½Ã¿À 

SELECT *
FROM (SELECT department_id, emp_name
     ,ROW_NUMBER() OVER(PARTITION BY department_id
                                 ORDER BY emp_name) dep_rownum
      FROM employees)
WHERE dep_rownum =1 ;
--- rank µ¿ÀÏ ¼øÀ§ ÀÖÀ»½Ã °Ç³Ê¶Ü
--- dense_rank °Ç³Ê¶ÙÁö¾ÊÀ½
SELECT department_id, emp_name, salary
     , RANK() OVER(PARTITION BY department_id 
                   ORDER BY salary DESC) as rnk
     , DENSE_RANK() OVER(PARTITION BY department_id 
                   ORDER BY salary DESC) as dense_rnk
FROM employees;

-- ÇÐ»ýµéÀÇ Àü°øº° ÆòÁ¡À» ±âÁØ(³»¸²Â÷¼ø)À¸·Î ¼øÀ§¸¦ Ãâ·ÂÇÏ½Ã¿À 

SELECT ÀÌ¸§, Àü°ø, ÆòÁ¡
       ,RANK() OVER(PARTITION BY Àü°ø 
                    ORDER BY ÆòÁ¡ desc) as Àü°øº°¼øÀ§
       ,RANK() OVER(ORDER BY ÆòÁ¡ desc) as ÀüÃ¼¼øÀ§
FROM ÇÐ»ý;
            
SELECT emp_name, salary, department_id
    , SUM(salary) OVER (PARTITION BY department_id) as ºÎ¼­º°ÇÕ°è
    , SUM(salary) OVER() as ÀüÃ¼ÇÕ°è
FROM employees;

--Àü°øº° ÇÐ»ý¼ö¸¦ ±âÁØÀ¸·Î ¼øÀ§¸¦ ±¸ÇÏ½Ã¿À(ÇÐ»ý¼ö ³»¸²Â÷¼ø±âÁØ)


SELECT Àü°ø, ÇÐ»ý¼ö, 
       RANK()OVER(ORDER BY ÇÐ»ý¼ö DESC) as ¼øÀ§
FROM (
        SELECT Àü°ø, COUNT(*) as ÇÐ»ý¼ö
        FROM ÇÐ»ý 
        GROUP BY Àü°ø
      );

SELECT Àü°ø, COUNT(*) as ÇÐ»ý¼ö, 
       RANK()OVER(ORDER BY COUNT(*) DESC) as ¼øÀ§
FROM ÇÐ»ý
GROUP BY Àü°ø;



-- »óÇ°º° ÃÑÆÇ¸Å±Ý¾×°ú ¼øÀ§¸¦ Ãâ·ÂÇÏ½Ã¿À  
-- 10µî±îÁö »óÇ°¸í, ÇÕ°è, ¼øÀ§ Ãâ·Â (cart, prod) Å×ÀÌºí È°¿ë prod_sale 
SELECT a.cart_prod, a.cart_qty
FROM cart a;
SELECT b.prod_id, b.prod_name, b.prod_sale
FROM prod b;
SELECT *
FROM (SELECT  b.prod_id, b.prod_name
            , SUM(a.cart_qty * b.prod_sale) as ÇÕ°è
            , RANK() OVER(
                ORDER BY SUM(a.cart_qty * b.prod_sale) DESC) as ¼øÀ§
      FROM cart a, prod b
      WHERE a.cart_prod = b.prod_id
      GROUP BY b.prod_id, b.prod_name
     )
WHERE ¼øÀ§ <= 10;
-- NTILE(expr) ÆÄÆ¼¼Çº°·Î expr¿¡ ¸í½ÃµÈ °ª¸¸Å­ ºÐÇÒ
-- NTILE(3) 1 ~ 3»çÀÌ ¼ö¸¦ ¹ÝÈ¯ ºÐÇÒÇÏ´Â ¼ö¸¦ ¹öÅ¶ ¼ö¶ó°í ÇÔ
-- ·Î¿ìÀÇ °Ç¼öº¸´Ù Å« ¼ö¸¦ ¸í½ÃÇÏ¸é ¹ÝÈ¯µÇ´Â ¼ö´Â ¹«½ÃµÊ.
SELECT emp_name, department_id, salary
      ,NTILE(3) OVER(PARTITION BY department_id
                    ORDER BY salary) as nt
FROM employees
WHERE department_id IN (30, 60);
/*  LAG  ¼±Çà ·Î¿ìÀÇ °ªÀ» °¡Á®¿Í¼­ ¹ÝÈ¯
    LEAD ÈÄÇà ·Î¿ìÀÇ °ªÀ» °¡Á®¿Í¼­ ¹ÝÈ¯ 
    ÁÖ¾îÁø ±×·ì°ú ¼ø¼­¿¡ µû¶ó ·Î¿ì¿¡ ÀÖ´Â Æ¯Á¤ ÄÃ·³ÀÇ °ªÀ» ÂüÁ¶ÇÒ¶§ »ç¿ë
*/
SELECT emp_name, department_id, salary
     , LAG(emp_name, 2, '°¡Àå³ôÀ½') OVER(PARTITION BY department_id
                                        ORDER BY salary DESC) as lag
    , LEAD(emp_name, 1, '°¡Àå³·À½') OVER(PARTITION BY department_id
                                        ORDER BY salary DESC) as leads
FROM employees
WHERE department_id IN (30, 60);

-- Àü°øº°·Î °¢ ÇÐ»ýÀÇ ÆòÁ¡º¸´Ù ÇÑ´Ü°è ¹Ù·Î ³ôÀº ÇÐ»ý°úÀÇ ÆòÁ¡Â÷ÀÌ¸¦ Ãâ·ÂÇÏ½Ã¿À
      
SELECT ÀÌ¸§, Àü°ø, ÆòÁ¡ as ³ªÀÇÆòÁ¡
     , LAG(ÀÌ¸§,1,'1µî') OVER(PARTITION BY Àü°ø  
                             ORDER BY ÆòÁ¡ DESC) as ³ªº¸´ÙÀ§ÇÐ»ý
     , LAG(ÆòÁ¡,1,ÆòÁ¡) OVER(PARTITION BY Àü°ø 
                            ORDER BY ÆòÁ¡ DESC)-ÆòÁ¡ as ÆòÁ¡Â÷ÀÌ
FROM ÇÐ»ý;

/*  kor_loan_status Å×ÀÌºí¿¡ ÀÖ´Â µ¥ÀÌÅÍ¸¦ ÀÌ¿ëÇÏ¿©
    '¿¬µµº°' 'ÃÖÁ¾¿ù' ±âÁØ °¡Àå ´ëÃâÀÌ ¸¹Àº µµ½Ã¿Í ÀÜ¾×À» ±¸ÇÏ½Ã¿À
    (1) ³âµµº°·Î ÃÖÁ¾¿øÀÇ µ¥ÀÌÅÍ°¡ ´Ù¸§, 2011Àº 12¿ù, 2013Àº 11¿ù ..
        - ¿¬µµº° °¡ÀåÅ« ¿ùÀ» ±¸ÇÔ.
    (2) ¿¬µµº° ÃÖÁ¾¿øÀ» ´ë»óÀ¸·Î ´ëÃâ ÀÜ¾×ÀÌ °¡Àå Å« ±Ý¾×À» ÃßÃâ 
        - 1¹ø°ú Á¶ÀÎÇÏ¿© °¡Àå Å« ÀÜ¾× ±¸ÇÔ.
    (3) ¿ùº°, Áö¿ªº° ´ëÃâÀÜ¾×°ú (2) °á°ú¸¦ ºñ±³ÇØ ±Ý¾×ÀÌ °°Àº °ÇÀ» Ãâ·Â.
        - 2¿Í Á¶ÀÎÇØ¼­ µÎ ±Ý¾×ÀÌ °°Àº °ÇÀÇ µµ½Ã¿Í ÀÜ¾× Ãâ·Â
    
*/
WITH b2 AS ( SELECT period, region, sum(loan_jan_amt) jan_amt
               FROM kor_loan_status 
              GROUP BY period, region
            ),
     c AS ( SELECT b2.period,  MAX(b2.jan_amt) max_jan_amt
              FROM b2,
                   ( SELECT MAX(PERIOD) max_month
                       FROM kor_loan_status
                      GROUP BY SUBSTR(PERIOD, 1, 4)
                   ) a
             WHERE b2.period = a.max_month
             GROUP BY b2.period
           )
SELECT b2.*
  FROM b2, c
 WHERE b2.period = c.period
   AND b2.jan_amt = c.max_jan_amt
 ORDER BY 1;       
