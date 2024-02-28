/*
    PL/SQL 절차적 언어와 집합적 언어의 특징을 모두 가지고 있음.
    특정 기능을 처리하는 함수, 프로시져, 트리거 등을 만들 수 있음. 
    DB내부에 만들어져 일반 프로그래밍 언어보다 빠름.
*/
SET SERVEROUTPUT ON; -- PL/SPQ 실행결과를 스크립트 출력에 출력

-- 기본 단위는 블록이라고 하며 블록은 이름부, 선언부, 실행부(예외처리부) 로 구성됨.
DECLARE  --      <-익명블록
 vi_num NUMBER;  --변수선언
BEGIN
 vi_num := 100;  --값 할당 
 DBMS_OUTPUT.PUT_LINE(vi_num); -- 프린트
END;
select *
from departments;
-- 실행부에는 DML문이 들어갈 수 있음.
DECLARE
  vs_emp_name VARCHAR2(80); --number는 사이즈를 안써도됨.
  vs_dep_name departments.department_name%TYPE; --테이블컬럼타입
BEGIN
  SELECT a.emp_name, b.department_name
    INTO vs_emp_name, vs_dep_name -- 변수에 질의결과를 담음.
  FROM employees a, departments b
  WHERE a.department_id = b.department_id
  AND a.employee_id = 100;-- 하나의 변수에는 1개의 행 값만 할당가능
  DBMS_OUTPUT.PUT_LINE(vs_emp_name || ':' || vs_dep_name);
END;

-- 선언이 필요없다면 실행부만 실행가능
BEGIN
 DBMS_OUTPUT.PUT_LINE('3 * 3 =' || 3 * 3);
END;
-- IF문 
DECLARE 
  vn_num1 NUMBER := 5;
  vn_num2 NUMBER := :num;  -- 바인드
BEGIN
  IF vn_num1 > vn_num2 THEN 
    DBMS_OUTPUT.PUT_LINE('vn_num1 더큼');
  ELSIF vn_num1 = vn_num2 THEN
    DBMS_OUTPUT.PUT_LINE('같음');
  ELSE
    NULL;
  END IF; -- end로 꼭 닫아줘야함.
END;
/* 신입생이 들어왔습니다. ^^
   학번을 만들어 줘야해요 
   학생테이블의 학번중 가장 큰 학번의 앞에 4자리(년도)가 
   조건: 올해 년도와 다르다면 올해년도+000001
         같다면 해당학번 + 1 로 학번을 생성해주세요 ^^
*/
-- 신규학생 : 경영학:팽수, 법학:길동
DECLARE
  vn_this_year VARCHAR2(4) := TO_CHAR(SYSDATE,'YYYY');
  vn_max_hak_no NUMBER;
  vn_make_hak_no NUMBER;
BEGIN
   SELECT max(학번)
     INTO vn_max_hak_no
     FROM 학생;
  DBMS_OUTPUT.PUT_LINE('마지막 학번 : ' ||vn_max_hak_no);
  IF vn_this_year = SUBSTR(TO_CHAR(vn_max_hak_no),1,4) THEN
     DBMS_OUTPUT.PUT_LINE('같음');
     vn_make_hak_no := vn_max_hak_no + 1;
  ELSE 
     vn_make_hak_no := TO_NUMBER(vn_this_year || '000001');
  END IF;
  DBMS_OUTPUT.PUT_LINE('생성번호:' || vn_make_hak_no);
  INSERT INTO 학생(학번,이름,전공) VALUES (vn_make_hak_no, :nm, :sub);
  COMMIT;
END;


SELECT * FROM 학생;






  SELECT a.emp_name, b.department_name
    
  FROM employees a, departments b
  WHERE a.department_id = b.departments;






-- PL/SQL실행은 전체 블록을 잡은 뒤 실행해야함.