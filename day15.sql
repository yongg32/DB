/*  �м��Լ��� window�� (�׷�ȿ� �κ�����)
    ROWS :�� ������ window ���� ����
    RANGE : ������ ������ window�� ����
    PRECEDING : ��Ƽ������ ���е� ù ��° �ο찡 ������.
    FOLLOWING : ��Ƽ������ ���е� ������ �ο찡 �� ����
    CURRENT ROW : ���� �ο� 
*/
SELECT department_id, emp_name, hire_date, salary
     , SUM(salary) OVER(PARTITION BY department_id ORDER BY hire_date
                        ROWS BETWEEN UNBOUNDED PRECEDING 
                        AND CURRENT ROW) as first_curr
                        -- ���� �Ի簡 ���� ������� ���� �ο� 
     , SUM(salary) OVER(PARTITION BY department_id ORDER BY hire_date
                        ROWS BETWEEN  CURRENT ROW
                        AND UNBOUNDED FOLLOWING) as curr_last
                        -- ���� �ο� ���� ��
     , SUM(salary) OVER(PARTITION BY department_id ORDER BY hire_date
                        ROWS BETWEEN 1 PRECEDING
                        AND CURRENT ROW) as row1_curr      
                        -- 1�� ���� + ���� �ο�
FROM employees
WHERE department_id IN (30, 90);

-- study ������ reservation, order_info ���̺��� �̿��Ͽ� 
-- ���� �����ݾ��� ����Ͻÿ� 
-- RATIO_TO_REPORT : 
-- ���� �� �� �׸��� ������ ��� (���� ������ �ش� ���� �����ϴº���)
SELECT t1.*
      ,ROUND(RATIO_TO_REPORT(t1.sales) OVER() *100,2) || '%' as ����
      ,SUM(t1.sales) OVER(order by months
                           rows between unbounded 
                           preceding and current row) as  ��������
FROM (  SELECT SUBSTR(a.reserv_date, 1, 6) as months
            ,  SUM(b.sales) as sales
        FROM reservation a, order_info b
        WHERE a.reserv_no = b.reserv_no
        GROUP BY SUBSTR(a.reserv_date, 1, 6)
        ORDER BY 1
        ) t1;
        


