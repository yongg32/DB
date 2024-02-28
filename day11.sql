/*
    정규 표현식 (Regular Expression)
    oracle 10g 부터 사용가능 REGEXP_  <- 로 시작하는 함수
    .(dot) or [] 는 모든 문자 1글자를 의미함
    ^ 시작 $끝  [^]<--대괄호 안에는 not 의미 
    반복시퀀스 * : 0개 이상, + : 1개이상 ? : 0,1개 
             {n} :n번, {n,} :n번 이상, {n,m} :n번이상 m번 이하
    REGEXP_LIKE:정규식 패턴검색 */
SELECT *
FROM member
WHERE REGEXP_LIKE(mem_comtel, '^..-'); -- 시작문자2자리- 패턴 
-- MEM_MAIL 의 데이터중 영문자로만 3 ~ 5 자리 이메일 주소패턴 추출
SELECT mem_name, mem_mail
FROM member
WHERE REGEXP_LIKE(mem_mail, '^[a-zA-Z]{3,5}@');
-- MEM_ADD2 주소에서 문자띄어쓰기문자 패턴을 추출하세요
SELECT mem_add2
FROM member
WHERE REGEXP_LIKE(mem_add2, '. .');
-- 한글띄어쓰기숫자 패턴추출 
SELECT mem_add2
FROM member
WHERE REGEXP_LIKE(mem_add2, '[가-힝] [0-9]');
-- 한글로 끝나는 패턴 추출
SELECT mem_add2
FROM member
WHERE REGEXP_LIKE(mem_add2, '[가-힝]$');

-- 한글만 있는 주소검색
SELECT mem_add2
FROM member
WHERE REGEXP_LIKE(mem_add2, '^[가-힝]+$');
-- 한글이 없는 주소검색
SELECT mem_add2
FROM member
WHERE REGEXP_LIKE(mem_add2, '^[^가-힝]+$');
SELECT mem_add2
FROM member
WHERE NOT REGEXP_LIKE(mem_add2,'[가-힝]');
-- | :또는, () :패턴그룹
-- J로 시작하며, 세번째 문자가 m or n 직원의 이름조회
SELECT emp_name
FROM employees
WHERE REGEXP_LIKE(emp_name, '^J.(n|m)');
-- REGEXP_SUBSTR 정규표현식 패턴과 일치하는 문자열을 반환 
-- 이메일 @를 기준으로 앞과 뒤를 출력하시오 
SELECT mem_mail
    ,  REGEXP_SUBSTR(mem_mail, '[^@]+', 1, 1) as 아이디
    ,  REGEXP_SUBSTR(mem_mail, '[^@]+', 1, 2) as 도메인
FROM member;
SELECT REGEXP_SUBSTR('A-B-C', '[^-]+', 1, 1) as ex1
     , REGEXP_SUBSTR('A-B-C', '[^-]+', 1, 2) as ex2
     , REGEXP_SUBSTR('A-B-C', '[^-]+', 1, 3) as ex3
FROM dual;


-- 공백을 기준으로 첫번째 단어 출력
SELECT mem_add1
    , REGEXP_SUBSTR(mem_add1, '[^ ]+',1,1) as sido  -- 매개변수3,4 디폴트 1
FROM member;
-- 중간단어 출력 (패턴이 없으면 null) 
SELECT mem_add1
    , REGEXP_SUBSTR(mem_add1, '[^ ]+',1,2) as gungu  -- 매개변수3,4 디폴트 1
FROM member;
--REGEXP_REPLACE 대상 문자열에서 정규 표현식 패턴을 적용하여 다른 패턴으로 대체
-- Ellen Hildi Smith  -> Smith, Ellen Hildi
SELECT REGEXP_REPLACE('Ellen Hildi Smith', '(.*) (.*) (.*)','\3, \1 \2')
FROM dual;

-- 공백 2자리 이상을 찾아서 1자리로 대체 
SELECT REGEXP_REPLACE('Joe      Smith   Hi', '( ){2,}', ' ') 
      ,REPLACE('Joe      Smith   Hi', '   ', ' ' )
FROM dual;

-- 대전의 주소들을 모두 '대전'으로 출력하시오 id:p001제외
-- 대전광역시 -> 대전
-- 대전시     -> 대전
SELECT mem_add1
    ,REGEXP_REPLACE(mem_add1,'(대전시|대전광역시) (.*)', '대전 \2') as 주소
FROM member
WHERE mem_add1 LIKE '%대전%'
AND mem_id != 'p001';

-- 전화번호 뒷자리에서 동일한 번호가 반복되는 사원을조회 
-- 펄 표기법 \w = [a-zA-Z0-9], \d = [0-9]
SELECT emp_name, phone_number
FROM employees
WHERE REGEXP_LIKE(phone_number, '(\d\d)\1$'); --\1은 첫번째 캡처 그룹을 다시참조
                                              -- 즉 이전에 매칭된 두자리 숫자와 정확히 
                                              -- 일치한 두자리 숫자를 의미함



--DBA권한이있는 system계정에서  'study' 계정 생성, 권한설정 후 
-- study계정으로 접속하여 table create문과 insert문을 순서대로 실행하세요.
ALTER SESSION SET "_ORACLE_SCRIPT"=true;
-- 계정생성  계정명:study 비밀번호 study
CREATE USER study IDENTIFIED BY study;
-- 접속 권한 및 기본 사용권한부여 
GRANT CONNECT, RESOURCE TO study;
-- 테이블 스페이스 접근 권한
GRANT UNLIMITED TABLESPACE TO study;



SELECT *
FROM CUSTOMER;

