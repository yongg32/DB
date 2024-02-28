-- SQL 
-- DML (SELECT, INSERT, UPDATE, DELETE)
--       조회, 삽입, 수정, 삭제 
SELECT *    -- *은 전체 컬럼을 의미함
FROM employees;
SELECT employee_id
     , emp_name
FROM employees;

/*   table 테이블 
     1.테이블명 컬럼명의 최대 크기는 30바이트
     2.테이블명 컬럼명으로 예약어는 사용할 수 없음.
     3.테이블명 컬럼명으로 문자, 숫자, _, $, #을
       사용할 수 있지만 첫 글자는 문자만 올 수 있음.
     4.한 테이블에 사용가능한 컬럼은 최대 255개 
*/
CREATE TABLE ex1_1(
    -- 하나의 컬럼은 하나의 타입과 사이즈를 가짐
    col1 CHAR(10)    
   ,col2 VARCHAR2(10)  -- 컬럼을 , 로 구분
);
-- INSERT 데이터 삽입 
INSERT INTO ex1_1 (col1, col2)
VALUES('abc', 'ABC');
INSERT INTO ex1_1 (col1, col2)
VALUES('안녕', '하하하');
SELECT *
FROM ex1_1;
-- 테이블 삭제 DROP
DROP TABLE ex1_1;
-- 명령어는 대소문자를 구별하지 않음. 
-- 명령어를 쉽게 구분하려고 대소문자 사용
-- SQL은 보기 쉽게 들여쓰기를 해서 사용
SELECT emp_name   as nm   -- AS (alias 별칭) 
     , hire_date  hd      -- 콤마를 구분으로 컬럼명 띄어쓰기 이후 쓰면 별칭으로 인식
     , salary     sa_la
     , department_id   "안녕"
FROM employees;
-- 검색 조건이 있다면 where절 사용
SELECT *
FROM employees
WHERE salary >= 10000;  -- 10000이상의 월급받는 직원조회 
-- 검색 조건이 여러개 AND or OR 
SELECT *
FROM employees
WHERE salary >= 10000
AND   salary < 11000;  -- 10000이상 11000 미만 
SELECT *
FROM employees
WHERE department_id = 30
OR  department_id = 60;
-- 정렬조건이 있다면 order by사용 ASC 오름차순, DESC 내림차순
SELECT emp_name, department_id 
FROM employees
WHERE department_id = 30
OR  department_id = 60
ORDER BY department_id DESC, emp_name ASC; -- 디폴트 ASC

SELECT emp_name, department_id 
FROM employees
WHERE department_id = 30
OR  department_id = 60
ORDER BY 2 DESC, 1 ASC;  -- select 절에 컬럼의 순서 

-- 사칙연산 사용가능 
SELECT emp_name
     , ROUND(salary / 30,2)   as 일당
     , salary                 as 월급
     , salary - salary * 0.1  as 실수령액
     , salary * 12            as 연봉
FROM employees
ORDER BY 3 DESC; -- 월급 내림차순 정렬 
-- 논리 연산자 
SELECT * FROM employees WHERE salary = 2600;  -- 같다
SELECT * FROM employees WHERE salary <> 2600; -- 같지않다
SELECT * FROM employees WHERE salary != 2600; -- 같지않다
SELECT * FROM employees WHERE salary < 2600;  -- 미만
SELECT * FROM employees WHERE salary > 2600;  -- 초과
SELECT * FROM employees WHERE salary <= 2600; -- 이하
SELECT * FROM employees WHERE salary >= 2600; -- 이상
/* PRODUCTS 테이블에서 '상품 최저 금액(prod_min_price)가 '
   30 '이상' 50 '미만'의 상품명과 카테고리, 최저금액을 출력하시오 
   '정렬 조건은 카테고리 오름차순, 최저금액 내림차순'
*/
--테이블 타입조회
DESC PRODUCTS;

SELECT prod_name 
     , prod_category
     , prod_min_price
FROM PRODUCTS
WHERE prod_min_price >= 30
AND   prod_min_price < 50
ORDER BY prod_category, prod_min_price DESC;
