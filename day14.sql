/*
  WITH�� : ��Ī���� ����� SELECT ���� �ٸ� SELECT ������ ��Ī���� ��������
           - �ݺ��Ǵ� ���������� �ִٸ� ����ó�� �ѹ� �ҷ��ͼ� ���
           - ������ ��������� ���̺��� Ž���Ҷ� ���� ���
    temp��� �ӽ� ���̺��� ����ؼ� ��ð� �ɸ��� ������ ����� �����س���
    �����س��� �����͸� �������ϱ� ������ ������ ���� �� ����.
*/
WITH A AS(   -- ��Ī 
       SELECT *
       FROM employees
)
SELECT *
FROM A;

--- 8 ~ 14 �ڸ�, �빮��1,�ҹ���1,Ư������1 ���� �׽�Ʈ
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
AND REGEXP_LIKE(pw, '[^a-zA-Z0-9��-�R]');
-- ���� īƮ ���Ƚ���� ���� ���� ���� �������� ���� ������ ����Ͻÿ�
--(�����̷��� �ִ� ����)
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
--- ���� ������ with ���
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

/*  2000�⵵ ��Ż������ '����� �����' ���� ū '���� ��� �����'
    �̾��� '���', '�����'�� ����Ͻÿ�  (�Ҽ��� �ݿø�)
*/
SELECT cust_id, sales_month, amount_sold
FROM sales;
SELECT cust_id, country_id
FROM customers;
SELECT country_id, country_name
FROM countries;
-- �����
SELECT ROUND(AVG(a.amount_sold)) as year_avg
FROM sales a, customers b, countries c
WHERE a.cust_id = b.cust_id
AND   b.country_id = c.country_id
AND   a.sales_month LIKE '2000%'
AND   c.country_name = 'Italy';
--�����
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

/*  �м��Լ� �ο�ս� ���� ���谪�� ���� �� �� ���� 
    ���� ���� or �ο������������ �κ����踦 �� �� ����
    (ex ���� �����հ�)
    �м��Լ� :AVG, SUM, MAX, MIN, COUNT, DENSE_RANK, RANK, LAG...
    PARTITION BY : �׷� 
    ORDER BY : ���� ����
    WINDOW : �׷�ȿ� ���� �׷����� ���� �� �� 
*/
-- ROW_NUMBER �׷캰 �ο쿡 ���� ������ȯ 
SELECT department_id, emp_name
      ,ROW_NUMBER() OVER(PARTITION BY department_id
                         ORDER BY emp_name) dep_rownum
FROM employees;

-- �μ��� �̸������� ���� ù��° ������ ����Ͻÿ� 

SELECT *
FROM (SELECT department_id, emp_name
     ,ROW_NUMBER() OVER(PARTITION BY department_id
                                 ORDER BY emp_name) dep_rownum
      FROM employees)
WHERE dep_rownum =1 ;
--- rank ���� ���� ������ �ǳʶ�
--- dense_rank �ǳʶ�������
SELECT department_id, emp_name, salary
     , RANK() OVER(PARTITION BY department_id 
                   ORDER BY salary DESC) as rnk
     , DENSE_RANK() OVER(PARTITION BY department_id 
                   ORDER BY salary DESC) as dense_rnk
FROM employees;

-- �л����� ������ ������ ����(��������)���� ������ ����Ͻÿ� 

SELECT �̸�, ����, ����
       ,RANK() OVER(PARTITION BY ���� 
                    ORDER BY ���� desc) as ����������
       ,RANK() OVER(ORDER BY ���� desc) as ��ü����
FROM �л�;
            
SELECT emp_name, salary, department_id
    , SUM(salary) OVER (PARTITION BY department_id) as �μ����հ�
    , SUM(salary) OVER() as ��ü�հ�
FROM employees;

--������ �л����� �������� ������ ���Ͻÿ�(�л��� ������������)


SELECT ����, �л���, 
       RANK()OVER(ORDER BY �л��� DESC) as ����
FROM (
        SELECT ����, COUNT(*) as �л���
        FROM �л� 
        GROUP BY ����
      );

SELECT ����, COUNT(*) as �л���, 
       RANK()OVER(ORDER BY COUNT(*) DESC) as ����
FROM �л�
GROUP BY ����;



-- ��ǰ�� ���Ǹűݾװ� ������ ����Ͻÿ�  
-- 10����� ��ǰ��, �հ�, ���� ��� (cart, prod) ���̺� Ȱ�� prod_sale 
SELECT a.cart_prod, a.cart_qty
FROM cart a;
SELECT b.prod_id, b.prod_name, b.prod_sale
FROM prod b;
SELECT *
FROM (SELECT  b.prod_id, b.prod_name
            , SUM(a.cart_qty * b.prod_sale) as �հ�
            , RANK() OVER(
                ORDER BY SUM(a.cart_qty * b.prod_sale) DESC) as ����
      FROM cart a, prod b
      WHERE a.cart_prod = b.prod_id
      GROUP BY b.prod_id, b.prod_name
     )
WHERE ���� <= 10;
-- NTILE(expr) ��Ƽ�Ǻ��� expr�� ��õ� ����ŭ ����
-- NTILE(3) 1 ~ 3���� ���� ��ȯ �����ϴ� ���� ��Ŷ ����� ��
-- �ο��� �Ǽ����� ū ���� ����ϸ� ��ȯ�Ǵ� ���� ���õ�.
SELECT emp_name, department_id, salary
      ,NTILE(3) OVER(PARTITION BY department_id
                    ORDER BY salary) as nt
FROM employees
WHERE department_id IN (30, 60);
/*  LAG  ���� �ο��� ���� �����ͼ� ��ȯ
    LEAD ���� �ο��� ���� �����ͼ� ��ȯ 
    �־��� �׷�� ������ ���� �ο쿡 �ִ� Ư�� �÷��� ���� �����Ҷ� ���
*/
SELECT emp_name, department_id, salary
     , LAG(emp_name, 2, '�������') OVER(PARTITION BY department_id
                                        ORDER BY salary DESC) as lag
    , LEAD(emp_name, 1, '���峷��') OVER(PARTITION BY department_id
                                        ORDER BY salary DESC) as leads
FROM employees
WHERE department_id IN (30, 60);

-- �������� �� �л��� �������� �Ѵܰ� �ٷ� ���� �л����� �������̸� ����Ͻÿ�
      
SELECT �̸�, ����, ���� as ��������
     , LAG(�̸�,1,'1��') OVER(PARTITION BY ����  
                             ORDER BY ���� DESC) as ���������л�
     , LAG(����,1,����) OVER(PARTITION BY ���� 
                            ORDER BY ���� DESC)-���� as ��������
FROM �л�;

/*  kor_loan_status ���̺� �ִ� �����͸� �̿��Ͽ�
    '������' '������' ���� ���� ������ ���� ���ÿ� �ܾ��� ���Ͻÿ�
    (1) �⵵���� �������� �����Ͱ� �ٸ�, 2011�� 12��, 2013�� 11�� ..
        - ������ ����ū ���� ����.
    (2) ������ �������� ������� ���� �ܾ��� ���� ū �ݾ��� ���� 
        - 1���� �����Ͽ� ���� ū �ܾ� ����.
    (3) ����, ������ �����ܾװ� (2) ����� ���� �ݾ��� ���� ���� ���.
        - 2�� �����ؼ� �� �ݾ��� ���� ���� ���ÿ� �ܾ� ���
    
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
