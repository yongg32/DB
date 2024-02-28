/*
   계층형 쿼리 
   오라클에서 지원하고 있는 기능 
   관계형 데이터베이스의 데이터는 수평적인 데이터로 구성되어있는데 
   계층형쿼리로 수직적 구조로 표현할 수 있음
   메뉴, 부서, 권한 등을 계층형쿼리로 만들수 있음.
*/
SELECT department_id
      ,LPAD(' ', 3 * (LEVEL-1)) || department_name as 부서명
      ,LEVEL as lv -- (계층)트리 내에서 어떤 단계에 있는지 나타내는 정수값
      ,parent_id
FROM  departments
START WITH parent_id IS NULL               -- 시작조건
CONNECT BY PRIOR department_id = parent_id;-- 구조가 어떻게 연결되는지
-- departments 테이블에 데이터를 삽입하시오 
-- IT 헬프데스크 하위 부서로 
-- deparmtnet_id : 280
-- deparmtment_name : CHATBOT팀 
SELECT department_id
FROM departments;

INSERT INTO departments(department_id, department_name, parent_id)
VALUES (280, 'CHATBOT팀', 230);


-- 30 부서를 조회 
SELECT a.employee_id
     , a.manager_id
     , LPAD(' ', 3 * (LEVEL -1)) || a.emp_name as 이름
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
     , LPAD(' ', 3 * (LEVEL -1)) || a.emp_name as 이름
     , b.department_name
     , a.department_id
FROM employees a, departments b
WHERE a.department_id = b.department_id
START WITH a.manager_id  IS NULL
CONNECT BY PRIOR a.employee_id = a.manager_id
--ORDER BY b.department_name; -- 계층형 트리가 깨짐
ORDER SIBLINGS BY b.department_name; --트리를 유지하고 동일 level에서만 정렬



SELECT department_id
      ,LPAD(' ', 3 * (LEVEL-1)) || department_name as 부서명
      ,parent_id
      ,CONNECT_BY_ROOT department_name as rootNm -- root row에 접근
      ,SYS_CONNECT_BY_PATH(department_name, '>') as pathNm
      ,CONNECT_BY_ISLEAF as leafNm -- 마지막노드1, 자식이 있으면0
FROM  departments
START WITH parent_id IS NULL               
CONNECT BY PRIOR department_id = parent_id;

create table 팀 (
  아이디 number
 ,이름 varchar2(10)
 ,직책 varchar2(10)
 ,상위아이디 number
);

SELECT *
FROM 팀;
insert into 팀 values(1,'이사장', '사장', null);
insert into 팀 values(2,'김부장', '부장',1);
insert into 팀 values(3,'서차장', '차장',2);
insert into 팀 values(4,'장과장', '과장',3);
insert into 팀 values(5,'박과장', '과장',3);
insert into 팀 values(6,'이대리', '대리',4);
insert into 팀 values(7,'김대리', '대리',5);
insert into 팀 values(8,'최사원', '사원',6);
insert into 팀 values(9,'강사원', '사원',6);
insert into 팀 values(10,'주사원', '사원',7);
SELECT 
       이름
     , LPAD(' ' , 3 * (LEVEL-1)) || 직책 as 직책
     , LEVEL
     , 아이디
     , 상위아이디
  FROM 팀
  START WITH 상위아이디 IS NULL                  --< 이조건에 맞는 로우부터 시작함.
  CONNECT BY PRIOR 아이디  = 상위아이디; 

/*
    계층형쿼리 응용 (샘플 데이터 생성)
    LEVEL은 가상-열로써 (CONNECT BY 절과 함께 사용)
*/
SELECT  '2013'|| LPAD(LEVEL,2,'0') as 년월
FROM dual
CONNECT BY LEVEL <=12;

SELECT period as 년월
    ,  SUM(loan_jan_amt) as 대출합계
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY period;

SELECT a.년월
     , NVL(b.대출합계,0) as 대출합계
FROM  ( SELECT  '2013'|| LPAD(LEVEL,2,'0') as 년월
        FROM dual
        CONNECT BY LEVEL <=12
        ) a
    , (SELECT period as 년월
            ,  SUM(loan_jan_amt) as 대출합계
        FROM kor_loan_status
        WHERE period LIKE '2013%'
        GROUP BY period
       ) b
WHERE a.년월 = b.년월(+)
ORDER BY 1;

-- 202401 ~ 202412 SYSDATE를 이용하여 출력하시오 
-- connect by level 사용 
SELECT TO_CHAR(SYSDATE, 'YYYY') || LPAD(LEVEL,2,'0') AS mm
FROM dual
CONNECT BY LEVEL <=12;
-- 이번달 1일부터 ~ 마지막날까지 출력하시오 
-- 20240201
-- 20240202 ...

SELECT LEVEL
FROM dual
CONNECT BY LEVEL <= (SELECT TO_CHAR(LAST_DAY(sysdate),'DD')
                     FROM dual);
SELECT LEVEL
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(sysdate),'DD');

-- member  회원의 생일(mem_bir)를 이용하여 
-- 월별 회원수를 출력하시오(모든월이 나오도록)

SELECT a.월 || '월'   as 생일_월
     , NVL(b.회원수,0) as 회원수
FROM (SELECT LPAD(level,2,'0') as 월
        FROM dual
        CONNECT BY LEVEL <=12)a
   , (SELECT to_char(mem_bir,'MM') as 월
             , count(*)              as 회원수
        FROM member
        GROUP BY to_char(mem_bir,'MM') 
      )b
WHERE a.월 = b.월(+)
UNION 
SELECT '합계'
     , COUNT(*) 
FROM member;


SELECT TO_CHAR(SYSDATE,'YYYYMM') || LPAD(LEVEL,2,'0') as 년월일
  FROM DUAL
CONNECT BY LEVEL <= (SELECT TO_CHAR(LAST_DAY(sysdate),'DD')
                     FROM dual)
;




