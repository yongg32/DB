-- 단순 루프
DECLARE
  vn_num NUMBER := 2;
  vn_cnt NUMBER := 1;
BEGIN
  LOOP
    DBMS_OUTPUT.PUT_LINE(vn_num || '*' || vn_cnt || '=' || vn_num * vn_cnt);
    vn_cnt := vn_cnt + 1;
    EXIT WHEN vn_cnt >9; -- 단순루프는 무조건 탈출 조건이 있어야함.
  END LOOP;
END;
-- 구구단 출력 (중첩 loop는 loop ~ end loop 2개(exit도 2개)
DECLARE
  i NUMBER := 2;
  j NUMBER;
BEGIN
   LOOP
      j :=1;
      DBMS_OUTPUT.PUT_LINE(i || '단');
      LOOP
        DBMS_OUTPUT.PUT_LINE(i|| '*' || j || '=' || (i * j));
        j := j + 1;
        EXIT WHEN j >9; -- 단순루프는 무조건 탈출 조건이 있어야함.
      END LOOP;
      i := i + 1;
      EXIT WHEN i >9;
    END LOOP;
END;
-- FOR 문 
DECLARE 
  dan NUMBER :=2;
BEGIN
  FOR i IN 1..9
  LOOP
    CONTINUE WHEN i=5;
    DBMS_OUTPUT.PUT_LINE(dan || '*' || i || '=' || (dan*i));
  END LOOP;
END;
-- 사용자 정의 함수 
-- oracle 함수는 무조건 리턴값이 1개 있어야함.
CREATE OR REPLACE FUNCTION my_mod(num1 NUMBER, num2 NUMBER)
 RETURN NUMBER -- 반환 타입 정의
IS
    vn_remainder NUMBER := 0; --반환할 나머지
    vn_quotient NUMBER :=0; -- 몫
BEGIN
    vn_quotient := FLOOR(num1/num2);
    vn_remainder := num1 - (num2 * vn_quotient); 
    RETURN vn_remainder;  -- 나머지를 반환
END;

SELECT my_mod(4, 2)
     , mod(4, 2)
FROM dual;
-- 함수 삭제 
DROP FUNCTION my_mod;


/*  mem_id를 입력받아 등급을 리턴하는 함수를 만드시오 
    ( VIP : 마일리지 5000 이상
      GOLD : 마일리지 5000 미만 3000 이상
      SILVER : 나머지)
  매개변수:mem_id(VARCHAR2) 리턴값 : 등급(VARCHAR2)
*/
SELECT mem_name, mem_mileage, fn_grade(mem_id)
FROM member;



CREATE OR REPLACE FUNCTION fn_grade(p_id varchar2)
 RETURN VARCHAR2
IS 
 vn_mileage number;
 vs_grade   varchar2(30);
BEGIN
 SELECT  mem_mileage
   INTO   vn_mileage
   FROM member 
  WHERE mem_id = p_id;
  IF vn_mileage >= 5000 THEN 
    vs_grade := 'VIP';
  ELSIF vn_mileage < 5000 and vn_mileage >= 3000 THEN
    vs_grade := 'GOLD';
  ELSE 
    vs_grade := 'SILVER';
  END IF; 
  RETURN vs_grade;
END;


