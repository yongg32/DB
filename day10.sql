
-- EXISTS 존재하는지 체크 
-- EXISTS 서브쿼리에 테이블에 검색조건의 데이터가 존재하면 
--        존재하는 데이터에 대해서 메인쿼리에서 조회
SELECT a.department_id 
     , a.department_name
FROM departments a
WHERE EXISTS (SELECT 1
              FROM job_history b
              WHERE b.department_id = a.department_id) ;

SELECT a.department_id 
     , a.department_name
FROM departments a
WHERE NOT EXISTS (SELECT 1    -- NOT EXISTS 존재하지 않는
                  FROM job_history b
                  WHERE b.department_id = a.department_id) ;
-- 수강이력이 없는 학생을 조회하시오 
SELECT *
FROM 학생 a
WHERE NOT EXISTS (SELECT *
                  FROM 수강내역
                  WHERE 학번 = a.학번);

-- 테이블 복사 
CREATE TABLE emp_temp AS
SELECT *
FROM employees;  
-- UPDATE 문 중첩쿼리사용
-- 전 사원의 급여를 평균 금액으로 갱신
UPDATE emp_temp
SET salary = (SELECT AVG(salary)
              FROM emp_temp);
ROLLBACK ;
SELECT *
FROM emp_temp;
-- 평균 급여보다 많이 받는 사원 삭제 
DELETE emp_temp
WHERE salary >= (SELECT AVG(salary)
                 FROM emp_temp);

--미국국립표준협회 ANSI, American National Standards Institute 
--FROM 절에 조인조건이 들어감 
--inner join(equi-join)을 표준 ANSI JOIN 방법으로 
SELECT a.학번
     , a.이름 
     , b.수강내역번호
FROM 학생 a
INNER JOIN 수강내역 b
ON( a.학번 = b.학번)
;
-- 과목 테이블 추가 INNER JOIN
SELECT a.학번
     , a.이름 
     , b.수강내역번호
     , c.과목이름
FROM 학생 a
INNER JOIN 수강내역 b
ON(a.학번 = b.학번)
INNER JOIN 과목 c
ON(b.과목번호 = c.과목번호)
;
SELECT 학번
     , a.이름 
     , b.수강내역번호
     , c.과목이름
FROM 학생 a
INNER JOIN 수강내역 b
USING(학번)      -- 조인하는 컬럼명이 같을때 USING 사용가능 BUT select에도 
INNER JOIN 과목 c -- 테이블 명 or 테이블 별칭이 들어가면 안됨.
USING(과목번호);
-- ANSI OUTER JOIN 
-- LEFT OUTER JOIN or RIGHT OUTEHR JOIN
SELECT *
FROM 학생 a
   , 수강내역 b
WHERE a.학번 = b.학번(+); -- 일반 outer join 

SELECT *
FROM 학생 a
LEFT OUTER JOIN 
수강내역 b
ON (a.학번 = b.학번);
SELECT *
FROM 수강내역 b
RIGHT OUTER JOIN 
학생 a
ON (a.학번 = b.학번); -- 위에 결과와 같음

-- 매년 국가지역(Americas, Asia)의 총판매금액을 출력하시오 
-- sales, customers, countries 테이블 사용 
-- 국가는 country_region, 판매금액은 amount_sold
-- 일반 join 사용 or ANSI join 사용 (국가 정렬) 

SELECT to_char(a.sales_date,'YYYY') as yesrs
      ,c.country_region
      ,SUM(a.amount_sold) 판매금액
FROM SALES a, CUSTOMERS b, COUNTRIES c
WHERE a.cust_id = b.cust_id
AND   b.country_id = c.country_id 
AND   c.country_region IN ('Americas','Asia')
GROUP BY to_char(a.sales_date,'YYYY')
        ,c.country_region_id, c.country_region
ORDER BY 2;

/*  MERGE (병합)
    특정 조건에 따라 대상테이블에 대해 
    INSERT or UPDATE or DELETE를 해야할때 1개의 SQL로 처리가능
*/
-- 과목 테이블에 
-- 머신러닝 과목이 없으면 INSERT 학점2로 
--               있다면 UPDATE 학점3으로 
SELECT MAX(NVL(과목번호,0)) + 1
FROM 과목;
-- MERGE 1.대상테이블이 비교 테이블인 경우
MERGE INTO 과목 a
 USING DUAL --비교 테이블 dual은 대상테이블이 비교테이블일때
 ON (a.과목이름 ='머신러닝') -- MATCH 조건
WHEN MATCHED THEN 
 UPDATE SET a.학점 = 3   --merge문 insert 와 update(where)는 테이블 기입 안함
WHEN NOT MATCHED THEN
 INSERT(a.과목번호, a.과목이름, a.학점)
 VALUES( (SELECT MAX(NVL(과목번호,0)) + 1
          FROM 과목)  
         ,'머신러닝', 2);
-- MERGE 2.다른 테이블에 MATCH조건이 들어갈 경우
-- (1) 사원테이블에서 관리자 사번 146인 사원 번호가 일치하는 
      --직원의 보너스 금액을 급여의 1%로 업데이트 
      --사번과 일치하는게 없다면 급여가 8000 미만인 사원만 0.1%로 인서트
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

-- 메니저 사번이 146 업데이트 대상건
SELECT a.employee_id, a.salary * 0.01, a.manager_id
FROM employees a
WHERE manager_id = 146
AND a.employee_id IN (SELECT emp_id
                      FROM emp_info);            
-- INSERT 대상건 
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
    ON(a.emp_id = b.employee_id)     -- match 조건
WHEN MATCHED THEN 
   UPDATE SET a.bonus = a.bonus + b.salary * 0.01
WHEN NOT MATCHED THEN 
   INSERT (a.emp_id, a.bonus) VALUES (b.employee_id, b.salary * 0.001)
   WHERE (b.salary <8000);

SELECT *
FROM emp_info;


-- 있으면 mbti, team update
-- 없으면 insert ssam
MERGE INTO TB_INFO a 
USING (SELECT INFO_NO,TEAM,MBTI
       FROM INFO) b
ON (a.INFO_NO = b.INFO_NO)  -- match조건
WHEN MATCHED THEN 
  UPDATE SET a.MBTI = b.MBTI, a.TEAM = b.TEAM

  
  
  
drop table info;  
ALTER TABLE TB_INFO ADD MBTI VARCHAR2(4);

-- 
-- 문제1 우리반 MBTI를 출력하세요
-- 문제2 통계 
