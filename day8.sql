
ALTER TABLE 학생 ADD CONSTRAINT PK_학생_학번 PRIMARY KEY (학번);
ALTER TABLE 수강내역 ADD CONSTRAINT PK_수강내역_수강내역번호 PRIMARY KEY (수강내역번호);
ALTER TABLE 과목 ADD CONSTRAINT PK_과목내역_과목번호 PRIMARY KEY (과목번호);
ALTER TABLE 교수 ADD CONSTRAINT PK_교수_교수번호 PRIMARY KEY (교수번호);

ALTER TABLE 수강내역 
ADD CONSTRAINT FK_학생_학번 FOREIGN KEY(학번)
REFERENCES 학생(학번);

ALTER TABLE 수강내역 
ADD CONSTRAINT FK_과목_과목번호 FOREIGN KEY(과목번호)
REFERENCES 과목(과목번호);

ALTER TABLE 강의내역 
ADD CONSTRAINT FK_교수_교수번호 FOREIGN KEY(교수번호)
REFERENCES 교수(교수번호);

ALTER TABLE 강의내역 
ADD CONSTRAINT FK_과목_과목번호2 FOREIGN KEY(과목번호)
REFERENCES 과목(과목번호);



COMMIT;


/* INNER JOIN 내부조인 (동등조인) */
SELECT *
FROM 학생;

SELECT *
FROM 수강내역;

SELECT 학생.이름
     , 학생.평점
     , 학생.학번 
     , 수강내역.수강내역번호
     , 수강내역.과목번호
     , 과목.과목이름
FROM 학생, 수강내역, 과목
WHERE 학생.학번 = 수강내역.학번
AND   수강내역.과목번호 = 과목.과목번호 
AND 학생.이름 = '양지운';

--학생의 수강내역 건수를 조회하시오(평점 소수점 2째자리 까지 표현,이름정렬)




SELECT 학생.이름
     , ROUND(학생.평점,2) as 평점
     , 학생.학번 
     , COUNT(수강내역.수강내역번호) as 수강건수
FROM 학생, 수강내역
WHERE 학생.학번 = 수강내역.학번
GROUP BY 학생.이름, 학생.평점, 학생.학번
ORDER BY 1 ;


/* outer join 외부조인 null값을 포함시키고 싶을때*/
SELECT 학생.이름
     , ROUND(학생.평점,2) as 평점
     , 학생.학번 
     , COUNT(수강내역.수강내역번호) as 수강건수
FROM 학생, 수강내역
WHERE 학생.학번 = 수강내역.학번(+) -- null값을포함시킬 쪽에 (+)
GROUP BY 학생.이름, 학생.평점, 학생.학번
ORDER BY 1 ;
SELECT 학생.이름
     , ROUND(학생.평점,2) as 평점
     , 학생.학번 
     , 수강내역.수강내역번호 as 수강건수
FROM 학생, 수강내역
WHERE 학생.학번 = 수강내역.학번(+) -- null값을포함시킬 쪽에 (+)
ORDER BY 1 ;
-- 학생의 수강내역수와 총 수강학점을 출력하시오 
SELECT 학생.이름
     , ROUND(학생.평점,2) as 평점
     , 학생.학번 
     , COUNT(수강내역.수강내역번호) as 수강건수
     ,SUM(NVL(과목.학점,0)) as 총수강학점
FROM 학생, 수강내역, 과목
WHERE 학생.학번 = 수강내역.학번(+) 
AND   수강내역.과목번호 = 과목.과목번호(+)
GROUP BY 학생.이름, ROUND(학생.평점,2), 학생.학번 
ORDER BY 1 ;

SELECT count(*)
FROM 학생, 수강내역; -- cross join (주의해야함) 
                   -- 9 * 17 = 153
SELECT count(*)
FROM 학생, 수강내역
WHERE 학생.학번 = 수강내역.학번;

SELECT *
FROM member;

SELECT *
FROM cart;

 --김은대씨의 '카트사용횟수, 구매상품 품목 수, 총구매상품수
 --'총구매금액'을 출력하시오 
SELECT a.mem_id
     , a.mem_name
     , COUNT(DISTINCT b.cart_no)   as 카트사용횟수
     , COUNT(DISTINCT b.cart_prod) as 구매상품품목수
     , SUM(NVL(b.cart_qty,0))    as 총구매수량
FROM member a
    ,cart b
WHERE a.mem_id = b.cart_member(+)
AND a.mem_name = '김은대'
GROUP BY a.mem_id
       , a.mem_name;
 
--김은대씨의 '카트사용횟수, 구매상품 품목 수, 총구매상품수
--'총구매금액'을 출력하시오 (상품 금액은 prod_sale사용)



 SELECT a.mem_id
     , a.mem_name
     , COUNT(DISTINCT b.cart_no)   as 카트사용횟수
     , COUNT(DISTINCT b.cart_prod) as 구매상품품목수
     , SUM(NVL(b.cart_qty ,0))    as 총구매수량
     , SUM(NVL(b.cart_qty * c.prod_sale ,0))    as 총구매금액
FROM member a
    ,cart b
    ,prod c
WHERE a.mem_id = b.cart_member(+)
AND   b.cart_prod = c.prod_id(+)
AND a.mem_name = '김은대'
GROUP BY a.mem_id
       , a.mem_name;
       
-- employees, jobs 테이블을 활용하여 
-- salary가 15000 이상인 직원의 사번, 이름, salary, 직업명을 출력하시오   
SELECT employee_id
      ,emp_name
      ,salary
      ,job_id
FROM employees;
       
SELECT job_id
     , job_title
FROM jobs;

SELECT a.employee_id
      ,a.emp_name
      ,a.salary
      ,b.job_title
FROM employees a
   , jobs b 
WHERE a.job_id = b.job_id
AND a.salary >= 15000;       


       
SELECT a.employee_id   /*사번*/
     , a.emp_name      /*이름*/
     , a.salary        /*봉급*/
     , b.job_title     /*직업명*/
FROM employees a       --직원테이블
   , jobs b            --직업테이블
WHERE a.job_id = b.job_id
AND   a.salary >= 15000;

/* subquery (쿼리안에 쿼리)
    1.스칼라 서브쿼리(select 절)
    2.인라인 뷰 (from절)
    3.중첩쿼리(where절)
*/
-- 스칼라 서브쿼리는 단일행 반환
-- 주의할 점은 메인 쿼리테이블의 행 건수 만큼 조회하기때문에(무거운 테이블을 사용하면 오래걸림)
-- 위와같은 상황에는 조인을 이용하는게 더 좋음.
SELECT a.emp_name
--      ,a.department_id  -- 부서 아이디 대신 부서명이 필요할때 
                        -- 부서아이디는 부서테이블의 pk (유니크함 단일행 반환)
      ,(SELECT department_name 
        FROM departments
        WHERE department_id = a.department_id) as dep_nm
--      , a.job_id   -- 스칼라서브쿼리로 job_title을 출력하시오.
      , (SELECT job_title
         FROM jobs
         WHERE job_id = a.job_id) as job_nm
FROM employees a;

-- 중첩서브쿼리(where절)
-- 직원중 salary 전체평균 보다 높은 직원을 출력하시오 
SELECT emp_name, salary
FROM employees
WHERE salary >= (SELECT AVG(salary)
                 FROM employees) --6461.831775700934579439252336448598130841
ORDER BY 2 ;

SELECT emp_name, salary
FROM employees
WHERE salary >= 6461.831775700934579439252336448598130841
ORDER BY 2 ;


-- 학생중 '전체평균 평점' 이상인 학생정보만 출력하시오 
SELECT 학번, 이름, 전공, 평점
FROM 학생
WHERE 평점 >= ( SELECT AVG(평점)
                FROM 학생 )
;
-- 평점이 가장 높은 학생의 정보를 출력하시오 
SELECT 학번, 이름, 전공, 평점
FROM 학생
WHERE 평점 = ( SELECT MAX(평점)
                FROM 학생 )
;
-- 수강 이력이 없는 학생의 이름을 출력하시오 
SELECT 이름
FROM 학생
WHERE 학번 NOT IN(SELECT 학번
                  FROM 수강내역)
;
SELECT 이름
FROM 학생
WHERE 학번 NOT IN(2002110110,1997131542,1998131205,2001211121,1999232102,2001110131);

-- 동시에 2개이상의 컬럼 값이 같은 껀 조회
SELECT employee_id
     , emp_name
     , job_id
FROM employees
WHERE (employee_id, job_id ) IN (SELECT employee_id, job_id
                                 FROM job_history);
                                 
                                 
--지역과 각 년도별 대출총잔액을 구하는 쿼리를 작성해 보자.(kor_loan_status)




   SELECT REGION,
       SUM(CASE WHEN PERIOD LIKE '2011%' THEN LOAN_JAN_AMT ELSE 0 END)  AMT_2011,
       SUM(CASE WHEN PERIOD LIKE '2012%'  THEN LOAN_JAN_AMT ELSE 0 END) AMT_2012, 
       SUM(CASE WHEN PERIOD LIKE '2013%'  THEN LOAN_JAN_AMT ELSE 0 END) AMT_2013 
 FROM KOR_LOAN_STATUS
GROUP BY ROLLUP(REGION)
ORDER BY 1;




SELECT 이름
FROM 학생 
WHERE 학번 NOT IN (SELECT 학번
                   FROM 수강내역);








