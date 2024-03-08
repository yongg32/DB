-- ��������  (DBA���� system����)
ALTER SESSION SET "_ORACLE_SCRIPT"=true;
CREATE USER jdbc IDENTIFIED BY jdbc;
GRANT CONNECT, RESOURCE TO jdbc;
GRANT UNLIMITED TABLESPACE TO jdbc;
-- ���̺� ����
CREATE TABLE members (
    mem_id VARCHAR2 (50) PRIMARY KEY
   ,mem_pw VARCHAR2 (50)
   ,mem_nm VARCHAR2 (100)
   ,use_yn VARCHAR2 (1) default 'Y'
   ,c_dt   DATE default sysdate
);
-- ȸ������ 
INSERT INTO members (mem_id, mem_pw, mem_nm)
VALUES ('admin', 'admin', '������');
COMMIT;
-- ȸ����ȸ
SELECT mem_id
      ,mem_pw
      ,mem_nm
FROM members
WHERE use_yn = 'Y';
-- �÷� �߰� !
ALTER TABLE members ADD profile_img VARCHAR2(1000);
ALTER TABLE members ADD addr VARCHAR2(1000);

--�̸� ����
UPDATE members
SET
mem_nm = '������2'
WHERE
mem_id = 'nick';
SELECT *
FROM members;

CREATE TABLE boards (
    board_no NUMBER(10) PRIMARY KEY 
    , board_title VARCHAR2(1000)
    , mem_id VARCHAR2(100)
    , board_content VARCHAR2(2000)
    , board_date DATE
    ,CONSTRAINT fk_board FOREIGN KEY(mem_id)
    REFERENCES members(mem_id)
);

SELECT RPAD(' ', 4) || 'private ' ||
   CASE
   WHEN A.DATA_TYPE = 'VARCHAR2' THEN 'String'
   WHEN A.DATA_TYPE = 'NUMBER' THEN 'int'
   WHEN A.DATA_TYPE = 'FLOAT' THEN 'Float'
   WHEN A.DATA_TYPE = 'CHAR' AND A.DATA_LENGTH > 1 THEN 'String'
   WHEN A.DATA_TYPE = 'DATE' THEN 'String'
   ELSE 'Object'
   END ||
   ' ' ||
   CONCAT
   (
    LOWER(SUBSTR(B.COLUMN_NAME, 1, 1)),
    SUBSTR(REGEXP_REPLACE(INITCAP(B.COLUMN_NAME), ' |_'), 2)
   ) || CHR(59) || CHR(13)
FROM   ALL_TAB_COLUMNS A
     , ALL_COL_COMMENTS B
WHERE  A.TABLE_NAME = B.TABLE_NAME
AND    A.COLUMN_NAME = B.COLUMN_NAME
AND    A.OWNER = 'JDBC'
AND    B.OWNER = 'JDBC'
AND    A.TABLE_NAME = 'BOARDS'
ORDER BY A.COLUMN_ID;

INSERT INTO boards (board_no,board_title, mem_id, board_content)
VALUES (1,'��������', 'nick', '���������Դϴ�.');

INSERT INTO boards (board_no
                    ,board_title
                    , mem_id
                    , board_content)
VALUES ((SELECT NVL(MAX(board_no),0) + 1 
        FROM boards)
        ,'��������2'
        , 'nick'
        , '��������2�Դϴ�.');
SELECT a.board_no
     , a.board_title
     , a.board_content
     , a.mem_id
     , b.mem_nm
     , a.board_date
FROM boards a, members b
WHERE a.mem_id = b.mem_id
AND a.board_no = 1;
-- �÷� �߰�
ALTER TABLE boards ADD del_yn VARCHAR2(1) DEFAULT 'N';

UPDATE boards
SET del_yn = 'Y'
WHERE board_no = 1;

SELECT *
FROM boards;

--��� ���̺�
CREATE TABLE replys (
    reply_no NUMBER
  , board_no NUMBER(10)
  , mem_id   VARCHAR2(50)
  , reply_content VARCHAR2(1000)
  , reply_date DATE DEFAULT SYSDATE
  , del_yn VARCHAR2(1) DEFAULT 'N'
  , constraint fk_re_bo FOREIGN KEY(board_no) REFERENCES boards(board_no)
  , constraint fk_re_mem FOREIGN KEY(mem_id) REFERENCES members(mem_id)
);
SELECT * FROM boards;

INSERT INTO replys(reply_no, board_no, mem_id, reply_content)
VALUES (1,2,'nick','����Դϴ�');

SELECT  a.reply_no
      , a.mem_id
      , b.mem_nm
      , a.reply_content
      , TO_CHAR(a.reply_date, 'MM/dd HH24:MI') as reply_date
FROM replys a, members b
WHERE a.mem_id = b.mem_id
AND    a.board_no = '2'
AND     a.del_yn = 'N'
ORDER BY reply_date DESC;

SELECT  a.reply_no
      , a.mem_id
      , b.mem_nm
      , a.reply_content
      , TO_CHAR(a.reply_date, 'MM/dd HH24:MI') as reply_date
FROM replys a, members b
WHERE a.mem_id = b.mem_id
AND    a.reply_no = '1'
AND     a.del_yn = 'N';
SELECT *
FROM replys;

