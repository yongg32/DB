/*
    집계함수 대상 데이터를 특정 그룹으로 묶은 다음 그룹에 대한
    총합, 평균, 최댓값, 최솟값 등을 구하는 함수.    
*/
--SELECT *
--FROM employees;
-- COUNT 로우 수를 반환하는 집계함수
SELECT    COUNT(*)                      -- NULL 포함
        , COUNT(department_id)          -- default ALL
        , COUNT(ALL department_id)      -- 중복 포함, NULL 포함 X
        , COUNT(DISTINCT department_id) -- 중복 제거
        , COUNT(employee_id)            -- employee_id [PK]
FROM employees;

SELECT COUNT(mem_id) -- PK 회원수 카운팅
        , COUNT(*)
FROM member;

SELECT SUM(salary)                as 합계
        , ROUND(AVG(salary), 2)   as 평균 
        , MAX(salary)             as 최대
        , MIN(salary)             as 최소
        , COUNT(employee_id)      as 직원수
--        , employee_id -- 오류 남
FROM employees;

-- 부서별 집계 <-- 그룹의 대상 부서
SELECT department_id
        , SUM(salary)             as 합계
        , ROUND(AVG(salary), 2)   as 평균 
        , MAX(salary)             as 최대
        , MIN(salary)             as 최소
        , COUNT(employee_id)      as 직원수
FROM employees
GROUP BY department_id
ORDER BY 1;

-- 30, 60, 90 부서의 집계
SELECT department_id
        , SUM(salary)                as 합계
        , ROUND(AVG(salary), 2)   as 평균 
        , MAX(salary)             as 최대
        , MIN(salary)             as 최소
        , COUNT(employee_id)      as 직원수
FROM employees
WHERE department_id IN(30, 60, 90)
GROUP BY department_id
ORDER BY 1;

-- member 회원의 직업 별 마일리지의 합계, 평균, 최대, 최소 값을 출력하시오
-- 평균은 소수점 2째 자리까지 표현 (정렬은 마일리지 평균 내림차순)

SELECT * FROM member;

SELECT mem_job
        , COUNT(mem_id)             as 회원수
        , SUM(mem_mileage)          as 마일리지합계
        , ROUND(AVG(mem_mileage),2) as 마일리지평균
        , MAX(mem_mileage)          as 마일리지최대
        , MIN(mem_mileage)          as 마일리지최소
        
FROM member
GROUP BY mem_job
ORDER BY 4 desc;

-- kor_loan_status 테이블에 loan_jan_amt 컬럼을 활용하여
-- 2013년도 기간별 총 대출 잔액을 출력하시오
SELECT *
FROM kor_loan_status;

SELECT period
        , SUM(loan_jan_amt) as 총잔액
FROM kor_loan_status
WHERE period LIKE '2013%'
--WHERE period SUBSTR(period, 1, 4) 위와 같음
GROUP BY PERIOD
ORDER BY 1;

-- 기간별, 지역별, 대출 총 합계를 출력하시오
SELECT period
        , region
        , SUM(loan_jan_amt) as 합계

FROM kor_loan_status
GROUP BY period
        , region
ORDER BY 1;

-- 년도별, 지역별 대출합계
SELECT SUBSTR(period, 1, 4) as 년도
        , region as 지역
        , SUM(loan_jan_amt) as 합계

FROM kor_loan_status
GROUP BY SUBSTR(period, 1, 4)
        , region
ORDER BY 1;

-- 년도별, 대전 지역 대출합계
SELECT SUBSTR(period, 1, 4) as 년도
        , region as 지역
        , SUM(loan_jan_amt) as 합계

FROM kor_loan_status
WHERE region = '대전'
GROUP BY SUBSTR(period, 1, 4)
        , region
ORDER BY 1;

-- employees 직원들의 입사년도별 직원수를 출력하시오 (정렬 : 년도 오름차순)
SELECT *
FROM employees;

SELECT TO_CHAR(hire_date, 'YYYY') as 년도
        , COUNT(employee_id) as 직원수
FROM employees
GROUP BY TO_CHAR(hire_date, 'YYYY')
ORDER BY 년도;

-- 집계 데이터에 대해서 검색조건을 사용하려면 HAVING 사용
-- 입사직원이 10명 이상인 년도에 직원 수 출력
SELECT TO_CHAR(hire_date, 'YYYY') as 년도
        , COUNT(employee_id) as 직원수
FROM employees
GROUP BY TO_CHAR(hire_date, 'YYYY')
HAVING COUNT(employee_id) >= 10
ORDER BY 년도;

-- member 테이블을 활용하여
-- 직업별 마일리지 평균금액을 구하시오
-- (소수점 2째자리까지 반올림하여 출력)
-- (1) 정렬 평균 마일리지 내림차순
-- (2) 평균 마일리지가 3000이상인 데이터만 출력
SELECT * FROM member;

SELECT mem_job
        , ROUND(AVG(mem_mileage),2) as 평균
FROM member
GROUP BY mem_job
HAVING ROUND(AVG(mem_mileage),2) >= 3000
ORDER BY 2 DESC;
-- ORDER BY 평균 DESC; -- 위와 같음

-- customers 회원의 전체 회원 수, 남자 회원 수, 여자 회원수를 출력하시오
SELECT *
FROM customers;

SELECT COUNT(cust_id) as 전체회원
        ,COUNT(DECODE(cust_gender, 'M', '남자')) as 남자회원수
        ,COUNT(DECODE(cust_gender, 'F', '여자')) as 여자회원수
FROM customers;

-- 위와 같은 방법
SELECT COUNT(cust_id) as 전체회원
        ,SUM(DECODE(cust_gender, 'M', 1, 0)) as 남자회원수
        ,SUM(DECODE(cust_gender, 'F', 1, 0)) as 여자회원수
FROM customers;

