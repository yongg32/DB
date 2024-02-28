/*  ��������
    2.�ζ��κ�(FROM��)
    select ���� ���� ����� ��ġ ���̺�ó�� ��� 
*/
SELECT *
FROM (  SELECT �л�.�й�, �л�.�̸�, �л�.����
             , COUNT(��������.����������ȣ ) ���������Ǽ�
        FROM �л�, ��������
        WHERE �л�.�й� = ��������.�й�(+)
        GROUP BY �л�.�й�, �л�.�̸�, �л�.����
        ORDER BY 4 DESC
       ) a  -- FROM ���� ���� (select��) <-- ���̺�ó�� ��밡��
WHERE ROWNUM <=1;

SELECT *
FROM(  SELECT   ROWNUM as rnum
               , a.* -- a���̺���ü�÷�
        FROM (SELECT  *
              FROM member
              WHERE mem_name LIKE '%%'
              ORDER BY mem_name
              ) a
     )
WHERE rnum BETWEEN 1 AND 10;

-- �л����� ������ ���� ���� 5�� ����Ͻÿ� 
SELECT *
FROM (
        SELECT �̸�, ����
        FROM �л�
        ORDER BY ���� DESC
      )
WHERE ROWNUM <= 5;
-- 5� ��ȸ
SELECT *
FROM (  SELECT  ROWNUM as rnum
              , a.*
        FROM (  SELECT �̸�, ����
                FROM �л�
                ORDER BY ���� DESC
              ) a
     )
WHERE rnum = 5;

-- �л����� '����'�� '���� ����' �л��� ������ ����Ͻÿ� 
SELECT *
FROM(   SELECT *
        FROM �л�
        ORDER BY ����, ���� DESC
     ) 
WHERE ROWNUM <=1;

-- �л����� �濵�� �����л� �� '����'�� '���� ����' �л��� ������ ����Ͻÿ� 

SELECT *
FROM (
        SELECT �̸�, ����, ����
        FROM �л� 
        WHERE ���� ='�濵��'
        ORDER BY ���� DESC
     )
WHERE ROWNUM <= 1;
-- �л����� '������' '����'�� '���� ����' �л��� ������ ����Ͻÿ� 
SELECT *
FROM �л�
WHERE (����, ����) IN (  SELECT ����, MAX(����)
                        FROM �л�
                        GROUP BY ����);

-- 2000�⵵ �Ǹ�(�ݾ�)���� ����Ͻÿ� (sales, employees)
-- (�ǸŰ��� �÷� amount_sold, quantity_sold, sales_date)
-- ��Į�󼭺�������,  �ζ��κ並 ����غ����� 
SELECT (select emp_name 
        from employees 
        where employee_id = a.employee_id ) as �̸� 
      , a.employee_id  as ��� 
      , to_char(�Ǹűݾ�,'999,999,999.99') as �Ǹűݾ�
      , a.�Ǹż���
FROM (SELECT employee_id 
           , sum(amount_sold)   as �Ǹűݾ�
           , sum(quantity_sold) as �Ǹż���
      FROM sales
      WHERE to_char(sales_date,'YYYY') = '2000'
      GROUP BY employee_id
      ORDER BY 2 desc
      ) a
WHERE rownum = 1;


