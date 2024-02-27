CREATE TABLE tb_user(
    user_id VARCHAR2(20) PRIMARY KEY
  , user_pw VARCHAR2(100)
  , user_nm VARCHAR2(100)
  , create_dt DATE
  , update_dt DATE DEFAULT SYSDATE
  , use_yn VARCHAR2(1) DEFAULT 'Y'
);
-- 회원가입 쿼리
INSERT INTO tb_user (user_id, user_pw, create_dt)
VALUES('admin','admin', sysdate);
-- 로그인 쿼리

SELECT user_id
        ,user_pw
        ,user_nm
FROM tb_user
WHERE user_id = '?'
AND use_yn = 'Y';
INSERT INTO tb_user (user_id, user_nm, user_pw)
SELECT mem_id
    , mem_name
    , mem_pass
FROM member;   

SElECT *
FROM tb_user;
