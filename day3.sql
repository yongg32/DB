/*DML: INSERT ������ ���� */
-- 1. �⺻���� �÷��� ��F��
DROP TABLE ex3_1;
CREATE TABLE ex3_1(
        col1 VARCHAR2(100)
       ,col2 NUMBER
       ,col3 DATE
       );
       INSERT INTO ex3_1(col1, col2, col3)
       VALUES ('nick', 10, SYSDATE);
--        ���ڿ� Ÿ����'' ���� �׳� ���ڷ� ������ '10'�� �޾���.
    INSERT INTO ex3_1(col1, col2)
    VALUES ('judy', 9);
    INSERT INTO ex3_1(col1, col2)
    VALUES ('judy', 20);
-- 2.���̺� �ִ� ��ü �÷��� ���ؼ� �����Ҷ��� �Ƚᵵ��
INSERT INTO ex3_1 VALUES ('�ؼ�', 10, SYSDATE);
-- 3.select ~ insert ��ȸ����� ����
INSERT INTO ex3_1 (col1, col2 )
SELECT emp_name, emplouee_id
FROM employees;
-- �Ʒ� ��ȸ����� ex3_1 ���̺� �����ϼ���
INSERT INTO ex3_1 (col1, col2 )
SELECT nm, team
FROM th_info;

-- DML : UPDATE ������ ����
UPDATE ex3_1
SET col2 =20 -- �����ϰ��� �ϴ� �÷��� ������
   ,col3 = SYSDATE -- �����ؾ��ϴ� �÷��� ��������� , �� �߰��߰�
WHERE col1 = 'nick'; -- �����Ǿ����� �࿡ ���� ����
SELECT *
FROM ex3_1;

UPDATE TB_INFO
SET HOBBY = '���� ������ �ֱ�'
WHERE nm = '�̿��';
SELECT *
FROM TB_INFO;
-- DML :DELETE ������ ����
DELETE ex3_1; --��ü����
DELETE ex3_1
WHERE col1 = 'nick'; -- Ư�������� ����
DELETE dep
WHERE deptno = 3;
select *
from emp;
DELETE emp
WHERE empno = 200; -- dep �����ϰ� �ִ� emp ������ ���� ���� �� ��������

DELETE TABLE dep;
-- �������ǵ� ���� �� ���̺� ���� (�����ϴ� ���̺��� �־ ������ �ȵɋ�)
DROP CASCADE CONSTRAINT ;

-- �ǻ��÷� (���̺��� ������ �ִ°� ó�� ���)
SELECT ROWNUM as rnum
    , pc_no
    , nm
    , hobby
FROM tb_info
WHERE ROWNUM <= 10;

-- �ߺ� ���� (DISTINCT)
SELECT DISTINCT cust_gender      
FROM customers;
-- ǥ���� (���̺� Ư�� �������� ǥ���� �ٲٰ� ������ ���)
SELECT DISTINCT cust_name
      , cust_gender
      ,CASE WHEN cust_gender = 'M' THEN '����'
            WHEN cust_gender = 'F' THEN '����'
            ELSE '?'
            END as gender
FROM customers;
-- salary 10000 �̻� ��׿���, �������� ����
SELECT emp_name
       , salary
       , CASE WHEN salary >= 10000 THEN '��׿���'
                ELSE '����'
            END as salary
FROM employees;
-- NULL ���ǽİ� �����ǽ�(AND,OR, NOT)
SELECT *
FROM dapartments;
WHERE parent_id IS NULL; -- �÷��� ���� null��
SELECT *
FROM dapartments;
WHERE parent_id IS NOT NULL; -- �÷��� ���� null�� �ƴ�
-- IN ���ǽ� (������ or�� �ʿ��ҋ�)
-- ex) 30��, 60�� 80�� �μ���ȸ
SELECT emp_name, department_id
FROM employees
WHERE department_id IN(30, 60, 80);

-- LIKE �˻� ���ڿ� ���ϰ˻�
SELECT *
FROM tb_info
-- WHERE nm LIKE '%��'; -- ������ ������ ���
-- WHERE nm LIKE '%��%'; -- ���� ���Ե� ���
WHERE nm LIKE '��%'; -- ������ �����ϴ� ���

-- tb_info ���� email �� 94 ���Ե� �л��� ��ȸ�Ͻÿ�
SELECT *
FROM tb_info
WHERE email LIKE '%94%';



-- ||  ���ڿ� ���ϱ� 
SELECT pc_no || '[' || nm ||  ']' as info
FROM tb_info;

---- TO_CHAR ���ڿ��� �ٲ��ִ� �Լ�
---- ROUND  �ݿø� �����Լ� (����.�������ڸ�)
-- UPPER :�빮�ڷ� ��ȯ, LOWER :�ҹ��ڷ� ��ȯ �˻� �ҋ� �ٲ��ֱ� ���ؼ� ���
--// REPLACE(1: 2. 3. �ٲܰ�)
--// TRIM ���� ���� ���� LTRIM ���� ���� ���� RTRIM ������ ���� ����
--// SUBSTR ���� �ڸ���
--// LPAD(����(9), ,ä����� �ϴ� ����('0'), RPAD ����ä��°�  ������ä��°� 
--// DECODE 


/*
    oracle ������ �Լ� (��Ī �Լ�)
    ����Ŭ �Լ��� Ư¡�� select���� ���Ǿ�� �ϱ� ������
    ������ ��ȯ���� ����.
    �����Ϲ��� �� Ÿ�Ժ� ����� �� �ִ� �Լ��� ����.
*/
-- ���ڿ� �Լ�
-- LOWWER, UPPER
SELECT LOWER (' I LIKE MAC') as lowers
        , UPPER(' i ilke mac') as uppers
FROM dual; -- �׽�Ʈ�� �ӽ� ���̺�(spl ������ ���߱� ����)
SELECT emp_name, LOWER(emp_name)
FROM employees
WHERE LOWER(emp_name) = LOWER('WILLIAM SMITH');

-- select �� �������
-- (1)FROM --> (2) WHERE --> (3) GROUP BY --> (4) HAVUBG --> (5) WELECT -->(6) ORDER BY
SELECT 'hi'
FROM employees; -- ���̺� �Ǽ���ŭ ��ȸ��.

-- employees ���� �̸� --> willian ���Ե� ������ ��� ��ȸ�Ͻÿ�
SELECT *
FROM employees
-- WHERE LOWER(emp_name) LIKE '%william%';
--WHERE UPPER(emp_name) LIKE UPPER('%willian%');
WHERE UPPER(emp_name) LIKE '%'||UPPER('william')||'%';

-- SUBSTR(char, pos, len) ����ڿ� char�� pos�������� len ���̸�ŭ �ڷ�
-- pos�� 0 ���� 1��(����Ʈ1)
-- pos�� ������ ���� ���ڿ��� �� ������ ������ ����� ��ġ
-- len�� �����Ǹ� pos��° ���� ������ ��� ���ڸ� ��ȯ
SELECT SUBSTR('ABCD EFG', 1, 4)  as ex1
      ,SUBSTR('ABCD EFG', 1)     as ex2
      ,SUBSTR('ABCD EFG', -8, 1) as ex3
FROM dual;

-- INSTR ��� ���ڿ��� ��ġ ã��
-- �Ű����� �� 4�� 2���� �ʼ� �ڿ��� ������ 1,1
SELECT INSTR('���� ���� �ܷο� ����, ���� ���� ���ο� ����', '����') as ex1
     ,INSTR('���� ���� �ܷο� ����, ���� ���� ���ο� ����', '����',5) as ex2
     ,INSTR('���� ���� �ܷο� ����, ���� ���� ���ο� ����', '����',1, 2) as ex3
     ,INSTR('���� ���� �ܷο� ����, ���� ���� ���ο� ����', '��') as ex4 -- ������ 0
FROM dual;
-- tb_info �л��� �̸��� �̸��� �ּҸ� ����Ͻÿ�
-- �� : �̸��� �ּҸ� ���̵�� �������� �и��Ͽ� ����Ͻÿ�
-- leeapgil@gmail.com -->> ���̵�:leeapgil ������:gmail.com

SELECT nm
    ,email 
    ,SUBSTR(email,1 ,INSTR(email,'@') -1) as ���̵�
    ,SUBSTR(email, INSTR(email , '@') +1) as ������
FROM tb_info;

     