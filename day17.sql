-- �ܼ� ����
DECLARE
  vn_num NUMBER := 2;
  vn_cnt NUMBER := 1;
BEGIN
  LOOP
    DBMS_OUTPUT.PUT_LINE(vn_num || '*' || vn_cnt || '=' || vn_num * vn_cnt);
    vn_cnt := vn_cnt + 1;
    EXIT WHEN vn_cnt >9; -- �ܼ������� ������ Ż�� ������ �־����.
  END LOOP;
END;
-- ������ ��� (��ø loop�� loop ~ end loop 2��(exit�� 2��)
DECLARE
  i NUMBER := 2;
  j NUMBER;
BEGIN
   LOOP
      j :=1;
      DBMS_OUTPUT.PUT_LINE(i || '��');
      LOOP
        DBMS_OUTPUT.PUT_LINE(i|| '*' || j || '=' || (i * j));
        j := j + 1;
        EXIT WHEN j >9; -- �ܼ������� ������ Ż�� ������ �־����.
      END LOOP;
      i := i + 1;
      EXIT WHEN i >9;
    END LOOP;
END;
-- FOR �� 
DECLARE 
  dan NUMBER :=2;
BEGIN
  FOR i IN 1..9
  LOOP
    CONTINUE WHEN i=5;
    DBMS_OUTPUT.PUT_LINE(dan || '*' || i || '=' || (dan*i));
  END LOOP;
END;
-- ����� ���� �Լ� 
-- oracle �Լ��� ������ ���ϰ��� 1�� �־����.
CREATE OR REPLACE FUNCTION my_mod(num1 NUMBER, num2 NUMBER)
 RETURN NUMBER -- ��ȯ Ÿ�� ����
IS
    vn_remainder NUMBER := 0; --��ȯ�� ������
    vn_quotient NUMBER :=0; -- ��
BEGIN
    vn_quotient := FLOOR(num1/num2);
    vn_remainder := num1 - (num2 * vn_quotient); 
    RETURN vn_remainder;  -- �������� ��ȯ
END;

SELECT my_mod(4, 2)
     , mod(4, 2)
FROM dual;
-- �Լ� ���� 
DROP FUNCTION my_mod;


/*  mem_id�� �Է¹޾� ����� �����ϴ� �Լ��� ����ÿ� 
    ( VIP : ���ϸ��� 5000 �̻�
      GOLD : ���ϸ��� 5000 �̸� 3000 �̻�
      SILVER : ������)
  �Ű�����:mem_id(VARCHAR2) ���ϰ� : ���(VARCHAR2)
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


