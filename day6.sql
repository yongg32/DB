/*
    �����Լ� ��� �����͸� Ư�� �׷����� ���� ���� �׷쿡 ����
    ����, ���, �ִ�, �ּڰ� ���� ���ϴ� �Լ�.    
*/
--SELECT *
--FROM employees;
-- COUNT �ο� ���� ��ȯ�ϴ� �����Լ�
SELECT    COUNT(*)                      -- NULL ����
        , COUNT(department_id)          -- default ALL
        , COUNT(ALL department_id)      -- �ߺ� ����, NULL ���� X
        , COUNT(DISTINCT department_id) -- �ߺ� ����
        , COUNT(employee_id)            -- employee_id [PK]
FROM employees;

SELECT COUNT(mem_id) -- PK ȸ���� ī����
        , COUNT(*)
FROM member;

SELECT SUM(salary)                as �հ�
        , ROUND(AVG(salary), 2)   as ��� 
        , MAX(salary)             as �ִ�
        , MIN(salary)             as �ּ�
        , COUNT(employee_id)      as ������
--        , employee_id -- ���� ��
FROM employees;

-- �μ��� ���� <-- �׷��� ��� �μ�
SELECT department_id
        , SUM(salary)             as �հ�
        , ROUND(AVG(salary), 2)   as ��� 
        , MAX(salary)             as �ִ�
        , MIN(salary)             as �ּ�
        , COUNT(employee_id)      as ������
FROM employees
GROUP BY department_id
ORDER BY 1;

-- 30, 60, 90 �μ��� ����
SELECT department_id
        , SUM(salary)                as �հ�
        , ROUND(AVG(salary), 2)   as ��� 
        , MAX(salary)             as �ִ�
        , MIN(salary)             as �ּ�
        , COUNT(employee_id)      as ������
FROM employees
WHERE department_id IN(30, 60, 90)
GROUP BY department_id
ORDER BY 1;

-- member ȸ���� ���� �� ���ϸ����� �հ�, ���, �ִ�, �ּ� ���� ����Ͻÿ�
-- ����� �Ҽ��� 2° �ڸ����� ǥ�� (������ ���ϸ��� ��� ��������)

SELECT * FROM member;

SELECT mem_job
        , COUNT(mem_id)             as ȸ����
        , SUM(mem_mileage)          as ���ϸ����հ�
        , ROUND(AVG(mem_mileage),2) as ���ϸ������
        , MAX(mem_mileage)          as ���ϸ����ִ�
        , MIN(mem_mileage)          as ���ϸ����ּ�
        
FROM member
GROUP BY mem_job
ORDER BY 4 desc;

-- kor_loan_status ���̺� loan_jan_amt �÷��� Ȱ���Ͽ�
-- 2013�⵵ �Ⱓ�� �� ���� �ܾ��� ����Ͻÿ�
SELECT *
FROM kor_loan_status;

SELECT period
        , SUM(loan_jan_amt) as ���ܾ�
FROM kor_loan_status
WHERE period LIKE '2013%'
--WHERE period SUBSTR(period, 1, 4) ���� ����
GROUP BY PERIOD
ORDER BY 1;

-- �Ⱓ��, ������, ���� �� �հ踦 ����Ͻÿ�
SELECT period
        , region
        , SUM(loan_jan_amt) as �հ�

FROM kor_loan_status
GROUP BY period
        , region
ORDER BY 1;

-- �⵵��, ������ �����հ�
SELECT SUBSTR(period, 1, 4) as �⵵
        , region as ����
        , SUM(loan_jan_amt) as �հ�

FROM kor_loan_status
GROUP BY SUBSTR(period, 1, 4)
        , region
ORDER BY 1;

-- �⵵��, ���� ���� �����հ�
SELECT SUBSTR(period, 1, 4) as �⵵
        , region as ����
        , SUM(loan_jan_amt) as �հ�

FROM kor_loan_status
WHERE region = '����'
GROUP BY SUBSTR(period, 1, 4)
        , region
ORDER BY 1;

-- employees �������� �Ի�⵵�� �������� ����Ͻÿ� (���� : �⵵ ��������)
SELECT *
FROM employees;

SELECT TO_CHAR(hire_date, 'YYYY') as �⵵
        , COUNT(employee_id) as ������
FROM employees
GROUP BY TO_CHAR(hire_date, 'YYYY')
ORDER BY �⵵;

-- ���� �����Ϳ� ���ؼ� �˻������� ����Ϸ��� HAVING ���
-- �Ի������� 10�� �̻��� �⵵�� ���� �� ���
SELECT TO_CHAR(hire_date, 'YYYY') as �⵵
        , COUNT(employee_id) as ������
FROM employees
GROUP BY TO_CHAR(hire_date, 'YYYY')
HAVING COUNT(employee_id) >= 10
ORDER BY �⵵;

-- member ���̺��� Ȱ���Ͽ�
-- ������ ���ϸ��� ��ձݾ��� ���Ͻÿ�
-- (�Ҽ��� 2°�ڸ����� �ݿø��Ͽ� ���)
-- (1) ���� ��� ���ϸ��� ��������
-- (2) ��� ���ϸ����� 3000�̻��� �����͸� ���
SELECT * FROM member;

SELECT mem_job
        , ROUND(AVG(mem_mileage),2) as ���
FROM member
GROUP BY mem_job
HAVING ROUND(AVG(mem_mileage),2) >= 3000
ORDER BY 2 DESC;
-- ORDER BY ��� DESC; -- ���� ����

-- customers ȸ���� ��ü ȸ�� ��, ���� ȸ�� ��, ���� ȸ������ ����Ͻÿ�
SELECT *
FROM customers;

SELECT COUNT(cust_id) as ��üȸ��
        ,COUNT(DECODE(cust_gender, 'M', '����')) as ����ȸ����
        ,COUNT(DECODE(cust_gender, 'F', '����')) as ����ȸ����
FROM customers;

-- ���� ���� ���
SELECT COUNT(cust_id) as ��üȸ��
        ,SUM(DECODE(cust_gender, 'M', 1, 0)) as ����ȸ����
        ,SUM(DECODE(cust_gender, 'F', 1, 0)) as ����ȸ����
FROM customers;

