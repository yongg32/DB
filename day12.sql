/*  �� VIEW 338p
    �ϳ� �̻��� ���̺��� ������ ��ġ ���̺��� �� ó�� ����ϴ� ��ü
    ���� �����ʹ� �並 �����ϴ� ���̺� ��������� ���̺�ó�� ��밡��
    ��� ���� :1.���� ����ϴ� SQL���� �Ź� �ۼ��� �ʿ� ���� ��� ��밡��
              2.������ ���� ����(��õ ���̺��� ���� �� ����)
    �� Ư¡ : (1) �ܼ� �� (���̺� 1���� ����)
             - �׷��Լ� ���Ұ�
             - distinct ���Ұ�
             -insert/update/delete ��밡��
             (2) ���� �� (������ ���̺�)
              - �׷� �Լ� ��밡��
              - distinct ��밡��
              - insert/update/delete �Ұ��� 
*/
CREATE OR REPLACE VIEW emp_dep AS
SELECT a.employee_id
     , a.emp_name
     , b.department_id
     , b.department_name
FROM employees a, departments b 
WHERE a.department_id = b.department_id;
-- SYSTEM �������� JAVA ������ �並 ������ִ� ���� �ο�
GRANT CREATE VIEW TO java;
SELECT *
FROM emp_dep;
-- JAVA�������� emp_dep�� ��ȸ�Ҽ��ִ� ������ study�������� ���� �ο�
GRANT SELECT ON emp_dep TO study;
SELECT *
FROM java.emp_dep;  -- �ٸ��������� ��ȸ�� ��� ������.���̺��[view��]

/* ���Ǿ�(Synonim) ��ü 354p
   �ó���� ���Ǿ�� ������ ��ü ������ ������ �̸��� ���� ���Ǿ ����°�
   public synonim : ��� ����� ����
   private synonim : Ư�� ����ڸ� ����
   public �ó���� ���� �� ������ DBA������ �ִ� ����ڸ� ���� 
   ��� ���� : 1.�������� ������(id)�� ���� �߿��� ������ ��������� ��Ī�� ����
              2.���� ���Ǽ� ���� ���̺��� ������ ����ǳʵ� ��Ī���� 
                ����� �ߴٸ� �ڵ带 ���� ���ص���.
*/
-- system�������� �ó�� ���� ���� �ο�
GRANT CREATE SYNONYM TO java;
-- java�������� ���Ǿ����
CREATE OR REPLACE SYNONYM mem FOR member;  -- default private �ó��
-- java�������� study �������� mem �� ��ȸ�� �� �ִ� ���� �ο�
GRANT SELECT ON mem TO study;
-- study�������� ��ȸ
SELECT *
FROM java.mem;
-- public synonim ���� (DBA������ �ִ� system�������� ����)
CREATE OR REPLACE PUBLIC SYNONYM mem2 FOR java.member;
SELECT *
FROM mem2;
-- �ó�� ���� 
DROP PUBLIC SYNONYM mem2;
/* ������ Sequence 348p : ��Ģ�� ���� �ڵ� ������ ��ȯ�ϴ� ��ü
    ���� : pk�� ����� �÷��� ���� ��� 
          ex)�Խ����� �Խñ۹�ȣ 
    ��������.CURRVAL ����������� (���ʿ��� �ȵ�)
    ��������.NEXTVAL ���� �������� 
*/
CREATE SEQUENCE my_seq1
INCREMENT BY 1   -- ��������
START WITH   1   -- ���ۼ���
MINVALUE     1   -- �ּҰ�
MAXVALUE     99999999 -- �ִ밪
NOCYCLE      -- �ִ볪 �ּҿ� �����ϸ� ��������(����Ʈ nocycle)
NOCACHE;     -- �޸𸮿� ������ ���� �̸� �Ҵ� ��������(����Ʈ nocache)

-- ������ ���� 
DROP SEQUENCE my_seq1 -- ������ ������ ���������� ������ ���� ���ؼ��� �����̾ȵ� 
                      -- �����ϰ� �ٽ� ����°� �� ����.

SELECT my_seq1.NEXTVAL -- ��ȸ �Ҷ����� ������.
FROM dual;
SELECT my_seq1.CURRVAL
FROM dual;


CREATE TABLE tb_click(
    seq NUMBER PRIMARY KEY
   ,dt  DATE DEFAULT SYSDATE
);
INSERT INTO tb_click (seq) VALUES (my_seq1.NEXTVAL);
INSERT INTO tb_click (seq) VALUES ((SELECT MAX(NVL(seq,0)) + 1
                                    FROM tb_click));
SELECT MAX(NVL(seq,0)) + 1
FROM tb_click;
-- �ּ� 1, �ִ� 99999999, 1000���� �����ؼ� 2�� �����ϴ� 
-- info_seq �������� ����� ������ 






