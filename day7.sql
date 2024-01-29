SELECT gubun
    , SUM(loan_jan_amt) as �հ�
FROM kor_loan_status
GROUP BY gubun;

-- member ������ ���ϸ����� �հ�� ��ü �Ѱ踦 ���Ͻÿ�
SELECT mem_job
    , SUM(mem_mileage) �հ�
FROM member
GROUP BY ROLLUP(mem_job);

SELECT period
        , gubun
        , sum(loan_jan_amt) �հ�
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY ROLLUP(period, gubun); -- period �� �Ұ�



SELECT    gubun
        , period
        , sum(loan_jan_amt) �հ�
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY ROLLUP(gubun, period);

-- employees ���̺��� ������ �� 
-- �μ��� �������� ��ü �������� �����ÿ�.

-- grouping_id
SELECT department_id
     , grouping(department_id)
     , grouping_id(department_id) as �׷� -- �׷� rollup�� ����� �κ�
     , count(*) as ������
FROM employees
GROUP BY ROLLUP(department_id);
-- ������ �̹� ������ commission_pct ��ŭ �߰����� �Ϸ��� �մϴ�.
-- ���ް�, �߰��ݾ�, �ջ�ݾ��� ����Ͻÿ�
-- MVL(����, ���氪) ������ null �� ��� ���氪���� ��ü
SELECT emp_name 
        ,salary ����
        ,salary * NVL(commission_pct,0) as ��
        ,salary + (salary  * NVL(commission_pct,0)) as �ջ�ݾ�
FROM employees;        


SELECT CASE WHEN department_id IS NULL AND grouping_id(department_id) = 0 THEN '�μ�����'
            WHEN department_id IS NULL AND grouping_id(department_id) = 1 THEN '�Ѱ�'
            ELSE TO_CHAR(department_id)
            END AS �μ�
     , count(*) as ������
FROM employees
GROUP BY ROLLUP(department_id);

-- member ȸ���� ���������� ȸ���� ������ �ο����� ���ϸ��� �հ� �ݾ��� ����Ͻÿ�(�Ѱ赵)
SELECT NVL(mem_job,'�� ��') as ����
     , COUNT(*) as ȸ����
     , SUM(mem_mileage) as ���ϸ���
FROM member
WHERE mem_add1 LIKE '%����%'
GROUP BY ROLLUP(mem_job);


SELECT *
FROM exp_goods_asia;
-- ���� UNION (������), UNION ALL ��ü����, MINUS ������ INTERSECT ������
-- ��ȸ��� �÷����� Ÿ���� ������ �������밡��(������ �������� ����)
SELECT seq, goods
FROM exp_goods_asia
WHERE country = '�ѱ�'
UNION
SELECT seq, goods
FROM exp_goods_asia
WHERE country = '�Ϻ�';


SELECT seq, goods
FROM exp_goods_asia
WHERE country = '�ѱ�'
UNION
SELECT 1, 'hi'
FROM dual;

SELECT mem_job
      , SUM(mem_mileage) as �հ�
FROM member
GROUP BY mem_job
UNION
SELECT '�հ�'
      , SUM(mem_mileage)
FROM member
CRDER BY 2 asc;


SELECT *
FROM member
WHERE mem_name = 'Ź����';

SELECT *
FROM cart
WHERE cart_member= 'n001';
-- INNER JOIN (��������)  (���������̶�� ��.)
SELECT member.mem_id
    ,member.mem_name
    , cart.cart_member
    , cart.cart_prod
    , cart.cart_qty
FROM member, cart
WHERE member.mem_id = cart.cart_member -- mem_id �� cart_member ���� �����Ҷ� ����
AND member.mem_name = '������'; 

SELECT member.mem_id
     , member.mem_name
     , NVL(SUM(cart.cart_qty),0) ��ǰ���ż�
FROM member, cart
WHERE member.mem_id = cart.cart_member(+) -- outer join �ܺ�����
                                          -- null ���� ���Խ��Ѿ� �Ҷ� (+)���
AND member.mem_name = 'Ź����'
GROUP BY member.mem_id
         member,mem_neme;
         
SELECT member.mem_id
     , member.mem_name
     , cart.cart_member
     , cart.cart_qry ��ǰ���ż�
FROM member, cart
WHERE member.mem_id = cart.cart_member(+); -- outer join �ܺ�����

-- ������ �̸��� �μ����� ����Ͻÿ�
SELECT employees.emp_name
      ,employees.department_id
FROM employees;
-- ������ �ҋ��� ���� �� ���̺��� �ʿ��� �÷� ��ȸ sekect�� �ۼ�
-- �� ������ �����Ͱ� ������ Ȯ����
-- ������ �̿��� select�� �ۼ�
SELECT dapartments.dapartment_id
      ,dapartments.dapartment_name
FROM employees, dapartments
WHERE employees.dapartment_id = dapartments.dapartment_id;
                                        
SELECT a.emp_name
     , b.dapartment_name
FROM employees a, dapartments b -- ���̺� ��Ī
WHERE a.dapartment_id = b.dapartment_id;         

SELECT emp_name -- �� ���̺� ���ʿ��� �ִ� �÷��� ���̺���� ���� �ʾƵ���
     , dapartment_name
     , a.dapartment_id  -- �����̺� ������ �÷��� �ִٸ� ��������� �����࿩��
FROM employees a, dapartments b -- ���̺� ��Ī
WHERE a.dapartment_id = b.dapartment_id; 

-- employees, jobs �÷��� �̿��Ͽ�
-- ���, �̸�, �޿� ������ ����Ͻÿ�
SELECT a.employee_id  /*���*/
      ,a.emp_name       /*�̸�*/
      ,a.salary         /*�޿�*/
      ,b.job_title      /*������*/
FROM employees a        -- �������̺�
    , jobs b            --�������̺�
WHERE a.job_id = b.job_id
ORDER BY 1;
