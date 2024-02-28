/*
   ������ ���� 
   ����Ŭ���� �����ϰ� �ִ� ��� 
   ������ �����ͺ��̽��� �����ʹ� �������� �����ͷ� �����Ǿ��ִµ� 
   ������������ ������ ������ ǥ���� �� ����
   �޴�, �μ�, ���� ���� ������������ ����� ����.
*/
SELECT department_id
      ,LPAD(' ', 3 * (LEVEL-1)) || department_name as �μ���
      ,LEVEL as lv -- (����)Ʈ�� ������ � �ܰ迡 �ִ��� ��Ÿ���� ������
      ,parent_id
FROM  departments
START WITH parent_id IS NULL               -- ��������
CONNECT BY PRIOR department_id = parent_id;-- ������ ��� ����Ǵ���
-- departments ���̺� �����͸� �����Ͻÿ� 
-- IT ��������ũ ���� �μ��� 
-- deparmtnet_id : 280
-- deparmtment_name : CHATBOT�� 
SELECT department_id
FROM departments;

INSERT INTO departments(department_id, department_name, parent_id)
VALUES (280, 'CHATBOT��', 230);


-- 30 �μ��� ��ȸ 
SELECT a.employee_id
     , a.manager_id
     , LPAD(' ', 3 * (LEVEL -1)) || a.emp_name as �̸�
     , b.department_name
     , a.department_id
FROM employees a, departments b
WHERE a.department_id = b.department_id
START WITH a.manager_id  IS NULL
CONNECT BY PRIOR a.employee_id = a.manager_id
AND a.department_id = 30
;


SELECT a.employee_id
     , a.manager_id
     , LPAD(' ', 3 * (LEVEL -1)) || a.emp_name as �̸�
     , b.department_name
     , a.department_id
FROM employees a, departments b
WHERE a.department_id = b.department_id
START WITH a.manager_id  IS NULL
CONNECT BY PRIOR a.employee_id = a.manager_id
--ORDER BY b.department_name; -- ������ Ʈ���� ����
ORDER SIBLINGS BY b.department_name; --Ʈ���� �����ϰ� ���� level������ ����



SELECT department_id
      ,LPAD(' ', 3 * (LEVEL-1)) || department_name as �μ���
      ,parent_id
      ,CONNECT_BY_ROOT department_name as rootNm -- root row�� ����
      ,SYS_CONNECT_BY_PATH(department_name, '>') as pathNm
      ,CONNECT_BY_ISLEAF as leafNm -- ���������1, �ڽ��� ������0
FROM  departments
START WITH parent_id IS NULL               
CONNECT BY PRIOR department_id = parent_id;

create table �� (
  ���̵� number
 ,�̸� varchar2(10)
 ,��å varchar2(10)
 ,�������̵� number
);

SELECT *
FROM ��;
insert into �� values(1,'�̻���', '����', null);
insert into �� values(2,'�����', '����',1);
insert into �� values(3,'������', '����',2);
insert into �� values(4,'�����', '����',3);
insert into �� values(5,'�ڰ���', '����',3);
insert into �� values(6,'�̴븮', '�븮',4);
insert into �� values(7,'��븮', '�븮',5);
insert into �� values(8,'�ֻ��', '���',6);
insert into �� values(9,'�����', '���',6);
insert into �� values(10,'�ֻ��', '���',7);
SELECT 
       �̸�
     , LPAD(' ' , 3 * (LEVEL-1)) || ��å as ��å
     , LEVEL
     , ���̵�
     , �������̵�
  FROM ��
  START WITH �������̵� IS NULL                  --< �����ǿ� �´� �ο���� ������.
  CONNECT BY PRIOR ���̵�  = �������̵�; 

/*
    ���������� ���� (���� ������ ����)
    LEVEL�� ����-���ν� (CONNECT BY ���� �Բ� ���)
*/
SELECT  '2013'|| LPAD(LEVEL,2,'0') as ���
FROM dual
CONNECT BY LEVEL <=12;

SELECT period as ���
    ,  SUM(loan_jan_amt) as �����հ�
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY period;

SELECT a.���
     , NVL(b.�����հ�,0) as �����հ�
FROM  ( SELECT  '2013'|| LPAD(LEVEL,2,'0') as ���
        FROM dual
        CONNECT BY LEVEL <=12
        ) a
    , (SELECT period as ���
            ,  SUM(loan_jan_amt) as �����հ�
        FROM kor_loan_status
        WHERE period LIKE '2013%'
        GROUP BY period
       ) b
WHERE a.��� = b.���(+)
ORDER BY 1;

-- 202401 ~ 202412 SYSDATE�� �̿��Ͽ� ����Ͻÿ� 
-- connect by level ��� 
SELECT TO_CHAR(SYSDATE, 'YYYY') || LPAD(LEVEL,2,'0') AS mm
FROM dual
CONNECT BY LEVEL <=12;
-- �̹��� 1�Ϻ��� ~ ������������ ����Ͻÿ� 
-- 20240201
-- 20240202 ...

SELECT LEVEL
FROM dual
CONNECT BY LEVEL <= (SELECT TO_CHAR(LAST_DAY(sysdate),'DD')
                     FROM dual);
SELECT LEVEL
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(sysdate),'DD');

-- member  ȸ���� ����(mem_bir)�� �̿��Ͽ� 
-- ���� ȸ������ ����Ͻÿ�(������ ��������)

SELECT a.�� || '��'   as ����_��
     , NVL(b.ȸ����,0) as ȸ����
FROM (SELECT LPAD(level,2,'0') as ��
        FROM dual
        CONNECT BY LEVEL <=12)a
   , (SELECT to_char(mem_bir,'MM') as ��
             , count(*)              as ȸ����
        FROM member
        GROUP BY to_char(mem_bir,'MM') 
      )b
WHERE a.�� = b.��(+)
UNION 
SELECT '�հ�'
     , COUNT(*) 
FROM member;


SELECT TO_CHAR(SYSDATE,'YYYYMM') || LPAD(LEVEL,2,'0') as �����
  FROM DUAL
CONNECT BY LEVEL <= (SELECT TO_CHAR(LAST_DAY(sysdate),'DD')
                     FROM dual)
;




