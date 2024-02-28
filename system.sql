--한줄 주석 ctrl + /
/*
 주석 공간 
*/
-- 계정만들기 11g버전 이후 계정명에 특정스타일을
-- 규칙을 지켜야하는데 예전 스타일로 만들려면
-- 아래 명령어를 써야함
ALTER SESSION SET "_ORACLE_SCRIPT"=true;
-- 계정생성  계정명:java 비밀번호 oracle
CREATE USER java IDENTIFIED BY oracle;
-- 접속 권한 및 기본 사용권한부여 
GRANT CONNECT, RESOURCE TO java;
-- 테이블 스페이스 접근 권한
GRANT UNLIMITED TABLESPACE TO java;
