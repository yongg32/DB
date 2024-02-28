/*  서브쿼리
    2.인라인뷰(FROM절)
    select 문의 질의 결과를 마치 테이블처럼 사용 
*/
SELECT *
FROM (  SELECT 학생.학번, 학생.이름, 학생.전공
             , COUNT(수강내역.수강내역번호 ) 수강내역건수
        FROM 학생, 수강내역
        WHERE 학생.학번 = 수강내역.학번(+)
        GROUP BY 학생.학번, 학생.이름, 학생.전공
        ORDER BY 4 DESC
       ) a  -- FROM 절에 오는 (select문) <-- 테이블처럼 사용가능
WHERE ROWNUM <=1;

SELECT *
FROM(  SELECT   ROWNUM as rnum
               , a.* -- a테이블전체컬럼
        FROM (SELECT  *
              FROM member
              WHERE mem_name LIKE '%%'
              ORDER BY mem_name
              ) a
     )
WHERE rnum BETWEEN 1 AND 10;

-- 학생들중 평점이 높은 상위 5명만 출력하시오 
SELECT *
FROM (
        SELECT 이름, 평점
        FROM 학생
        ORDER BY 평점 DESC
      )
WHERE ROWNUM <= 5;
-- 5등만 조회
SELECT *
FROM (  SELECT  ROWNUM as rnum
              , a.*
        FROM (  SELECT 이름, 평점
                FROM 학생
                ORDER BY 평점 DESC
              ) a
     )
WHERE rnum = 5;

-- 학생들의 '평점'이 '가장 높은' 학생의 정보를 출력하시오 
SELECT *
FROM(   SELECT *
        FROM 학생
        ORDER BY 전공, 평점 DESC
     ) 
WHERE ROWNUM <=1;

-- 학생들중 경영학 전공학생 중 '평점'이 '가장 높은' 학생의 정보를 출력하시오 

SELECT *
FROM (
        SELECT 이름, 전공, 평점
        FROM 학생 
        WHERE 전공 ='경영학'
        ORDER BY 평점 DESC
     )
WHERE ROWNUM <= 1;
-- 학생들의 '전공별' '평점'이 '가장 높은' 학생의 정보를 출력하시오 
SELECT *
FROM 학생
WHERE (전공, 평점) IN (  SELECT 전공, MAX(평점)
                        FROM 학생
                        GROUP BY 전공);

-- 2000년도 판매(금액)왕을 출력하시오 (sales, employees)
-- (판매관련 컬럼 amount_sold, quantity_sold, sales_date)
-- 스칼라서브쿼리와,  인라인뷰를 사용해보세요 
SELECT (select emp_name 
        from employees 
        where employee_id = a.employee_id ) as 이름 
      , a.employee_id  as 사번 
      , to_char(판매금액,'999,999,999.99') as 판매금액
      , a.판매수량
FROM (SELECT employee_id 
           , sum(amount_sold)   as 판매금액
           , sum(quantity_sold) as 판매수량
      FROM sales
      WHERE to_char(sales_date,'YYYY') = '2000'
      GROUP BY employee_id
      ORDER BY 2 desc
      ) a
WHERE rownum = 1;


