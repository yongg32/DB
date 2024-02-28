/*  분석함수의 window절 (그룹안에 부분집합)
    ROWS :행 단위로 window 절을 지정
    RANGE : 논리적인 범위로 window를 지정
    PRECEDING : 파티션으로 구분된 첫 번째 로우가 시작점.
    FOLLOWING : 파티션으로 구분된 마지막 로우가 끝 지점
    CURRENT ROW : 현재 로우 
*/
SELECT department_id, emp_name, hire_date, salary
     , SUM(salary) OVER(PARTITION BY department_id ORDER BY hire_date
                        ROWS BETWEEN UNBOUNDED PRECEDING 
                        AND CURRENT ROW) as first_curr
                        -- 가장 입사가 빠른 사원부터 현재 로우 
     , SUM(salary) OVER(PARTITION BY department_id ORDER BY hire_date
                        ROWS BETWEEN  CURRENT ROW
                        AND UNBOUNDED FOLLOWING) as curr_last
                        -- 현재 로우 부터 끝
     , SUM(salary) OVER(PARTITION BY department_id ORDER BY hire_date
                        ROWS BETWEEN 1 PRECEDING
                        AND CURRENT ROW) as row1_curr      
                        -- 1행 이전 + 현재 로우
FROM employees
WHERE department_id IN (30, 90);

-- study 계정의 reservation, order_info 테이블을 이용하여 
-- 월별 누적금액을 출력하시오 
-- RATIO_TO_REPORT : 
-- 집합 내 각 항목의 비율을 계산 (집합 내에서 해당 값이 차지하는비율)
SELECT t1.*
      ,ROUND(RATIO_TO_REPORT(t1.sales) OVER() *100,2) || '%' as 비율
      ,SUM(t1.sales) OVER(order by months
                           rows between unbounded 
                           preceding and current row) as  누적집계
FROM (  SELECT SUBSTR(a.reserv_date, 1, 6) as months
            ,  SUM(b.sales) as sales
        FROM reservation a, order_info b
        WHERE a.reserv_no = b.reserv_no
        GROUP BY SUBSTR(a.reserv_date, 1, 6)
        ORDER BY 1
        ) t1;
        


