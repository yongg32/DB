
-- EXISTS �����ϴ��� üũ 
-- EXISTS ���������� ���̺� �˻������� �����Ͱ� �����ϸ� 
--        �����ϴ� �����Ϳ� ���ؼ� ������������ ��ȸ
SELECT a.department_id 
     , a.department_name
FROM departments a
WHERE EXISTS (SELECT 1
              FROM job_history b
              WHERE b.department_id = a.department_id) ;

SELECT a.department_id 
     , a.department_name
FROM departments a
WHERE NOT EXISTS (SELECT 1    -- NOT EXISTS �������� �ʴ�
                  FROM job_history b
                  WHERE b.department_id = a.department_id) ;
-- �����̷��� ���� �л��� ��ȸ�Ͻÿ� 
SELECT *
FROM �л� a
WHERE NOT EXISTS (SELECT *
                  FROM ��������
                  WHERE �й� = a.�й�);

-- ���̺� ���� 
CREATE TABLE emp_temp AS
SELECT *
FROM employees;  
-- UPDATE �� ��ø�������
-- �� ����� �޿��� ��� �ݾ����� ����
UPDATE emp_temp
SET salary = (SELECT AVG(salary)
              FROM emp_temp);
ROLLBACK ;
SELECT *
FROM emp_temp;
-- ��� �޿����� ���� �޴� ��� ���� 
DELETE emp_temp
WHERE salary >= (SELECT AVG(salary)
                 FROM emp_temp);

--�̱�����ǥ����ȸ ANSI, American National Standards Institute 
--FROM ���� ���������� �� 
--inner join(equi-join)�� ǥ�� ANSI JOIN ������� 
SELECT a.�й�
     , a.�̸� 
     , b.����������ȣ
FROM �л� a
INNER JOIN �������� b
ON( a.�й� = b.�й�)
;
-- ���� ���̺� �߰� INNER JOIN
SELECT a.�й�
     , a.�̸� 
     , b.����������ȣ
     , c.�����̸�
FROM �л� a
INNER JOIN �������� b
ON(a.�й� = b.�й�)
INNER JOIN ���� c
ON(b.�����ȣ = c.�����ȣ)
;
SELECT �й�
     , a.�̸� 
     , b.����������ȣ
     , c.�����̸�
FROM �л� a
INNER JOIN �������� b
USING(�й�)      -- �����ϴ� �÷����� ������ USING ��밡�� BUT select���� 
INNER JOIN ���� c -- ���̺� �� or ���̺� ��Ī�� ���� �ȵ�.
USING(�����ȣ);
-- ANSI OUTER JOIN 
-- LEFT OUTER JOIN or RIGHT OUTEHR JOIN
SELECT *
FROM �л� a
   , �������� b
WHERE a.�й� = b.�й�(+); -- �Ϲ� outer join 

SELECT *
FROM �л� a
LEFT OUTER JOIN 
�������� b
ON (a.�й� = b.�й�);
SELECT *
FROM �������� b
RIGHT OUTER JOIN 
�л� a
ON (a.�й� = b.�й�); -- ���� ����� ����

-- �ų� ��������(Americas, Asia)�� ���Ǹűݾ��� ����Ͻÿ� 
-- sales, customers, countries ���̺� ��� 
-- ������ country_region, �Ǹűݾ��� amount_sold
-- �Ϲ� join ��� or ANSI join ��� (���� ����) 

SELECT to_char(a.sales_date,'YYYY') as yesrs
      ,c.country_region
      ,SUM(a.amount_sold) �Ǹűݾ�
FROM SALES a, CUSTOMERS b, COUNTRIES c
WHERE a.cust_id = b.cust_id
AND   b.country_id = c.country_id 
AND   c.country_region IN ('Americas','Asia')
GROUP BY to_char(a.sales_date,'YYYY')
        ,c.country_region_id, c.country_region
ORDER BY 2;

/*  MERGE (����)
    Ư�� ���ǿ� ���� ������̺� ���� 
    INSERT or UPDATE or DELETE�� �ؾ��Ҷ� 1���� SQL�� ó������
*/
-- ���� ���̺� 
-- �ӽŷ��� ������ ������ INSERT ����2�� 
--               �ִٸ� UPDATE ����3���� 
SELECT MAX(NVL(�����ȣ,0)) + 1
FROM ����;
-- MERGE 1.������̺��� �� ���̺��� ���
MERGE INTO ���� a
 USING DUAL --�� ���̺� dual�� ������̺��� �����̺��϶�
 ON (a.�����̸� ='�ӽŷ���') -- MATCH ����
WHEN MATCHED THEN 
 UPDATE SET a.���� = 3   --merge�� insert �� update(where)�� ���̺� ���� ����
WHEN NOT MATCHED THEN
 INSERT(a.�����ȣ, a.�����̸�, a.����)
 VALUES( (SELECT MAX(NVL(�����ȣ,0)) + 1
          FROM ����)  
         ,'�ӽŷ���', 2);
-- MERGE 2.�ٸ� ���̺� MATCH������ �� ���
-- (1) ������̺��� ������ ��� 146�� ��� ��ȣ�� ��ġ�ϴ� 
      --������ ���ʽ� �ݾ��� �޿��� 1%�� ������Ʈ 
      --����� ��ġ�ϴ°� ���ٸ� �޿��� 8000 �̸��� ����� 0.1%�� �μ�Ʈ
CREATE TABLE emp_info(
     emp_id NUMBER
   , bonus NUMBER default 0
);
INSERT INTO emp_info(emp_id)
SELECT a.employee_id
FROM employees a
WHERE a.emp_name LIKE 'L%';
SELECT *
FROM emp_info;

-- �޴��� ����� 146 ������Ʈ ����
SELECT a.employee_id, a.salary * 0.01, a.manager_id
FROM employees a
WHERE manager_id = 146
AND a.employee_id IN (SELECT emp_id
                      FROM emp_info);            
-- INSERT ���� 
SELECT a.employee_id, a.salary * 0.001, a.manager_id
FROM employees a
WHERE manager_id = 146
AND a.salary > 8000
AND a.employee_id NOT IN (SELECT emp_id
                          FROM emp_info);
MERGE INTO emp_info a
USING (SELECT employee_id, salary, manager_id
       FROM employees 
       WHERE manager_id = 146) b
    ON(a.emp_id = b.employee_id)     -- match ����
WHEN MATCHED THEN 
   UPDATE SET a.bonus = a.bonus + b.salary * 0.01
WHEN NOT MATCHED THEN 
   INSERT (a.emp_id, a.bonus) VALUES (b.employee_id, b.salary * 0.001)
   WHERE (b.salary <8000);

SELECT *
FROM emp_info;


-- ������ mbti, team update
-- ������ insert ssam
MERGE INTO TB_INFO a 
USING (SELECT INFO_NO,TEAM,MBTI
       FROM INFO) b
ON (a.INFO_NO = b.INFO_NO)  -- match����
WHEN MATCHED THEN 
  UPDATE SET a.MBTI = b.MBTI, a.TEAM = b.TEAM

  
  
  
drop table info;  
ALTER TABLE TB_INFO ADD MBTI VARCHAR2(4);

-- 
-- ����1 �츮�� MBTI�� ����ϼ���
-- ����2 ��� 
