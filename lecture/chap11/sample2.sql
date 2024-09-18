-- sample2.sql


-- ------------------------------------------------------
-- 2. 권한(Privileges) 할당 (DCL: Data Control Language)
-- ------------------------------------------------------
--  가. 특별한 SQL문장을 수행할 수 있는 권리 의미
--  나. 테이블 생성/인덱스 생성/테이블에 데이터 CRUD 같은,
--      SQL 문장을 수행하려면, 각각의 권리가 필요 -> 이것이 "권한"
--  다. 권한은 두가지로 구분:
--      (1) 시스템 권한 (System Privileges)
--          a. Database-level Privileges
--          b. DBA(SYSDBA role)만이 권한부여 가능
--          c. 예: DB 접속, 사용자 생성, 뷰(View) 생성 등
--          d. DB에 특별한 작업을 수행할 수 있게 해줌
-- 
--      (2) 객체 권한 (Object Privileges)
--          a. Database Object-level Privileges
--          b. 해당 객체의 소유자(owner)가 권한부여 가능
--          c. 특정 객체에 대하여, CRUD 같은 작업 수행을 가능하게 함
-- ------------------------------------------------------

-- ------------------------------------------------------
-- 2-1. 시스템 권한(System Privileges) 할당(DCL: GRANT 문장)
-- ------------------------------------------------------
--  가. DBA(SYSDBA role)가 생성한 일반계정은,
--      a. DB 접속불가
--      b. Table, View, Index 등의 Oracle 객체 생성불가
--      c. b의 작업을 수행가능하려면, 각각 권한을 할당받아야 함
--  나. '가'의 작업을 수행가능하게 하는 권한을 의미
--  다. 두가지 종류의 권한이 있음:
--      (1) DBA가 가지는 시스템 권한
--          SystemPrivilges_owned_by_DBA.JPG 참고
--      (2) DBA가 일반사용자에게 부여가능한 시스템 권한
--          (이외에도, 약 100개 이상의 시스템권한이 있음, 헉!!~~)
--          SystemPrivilges_that_could_be_assigned_by_DBA.JPG 참고
--  라. 일단 일반계정 생성 후에, DBA(SYSDBA role)는 기본적인
--      몇가지의 중요한 시스템 권한을 해당 사용자에게 할당해줘야 함
-- ------------------------------------------------------
-- Basic syntax:
--  
--  GRANT 시스템권한1 [, 시스템권한2, ...]
--  TO { 사용자계정 | role | PUBLIC }
--  [WIDTH ADMIN OPTION] ;
--
--  * 시스템권한[1~n]: 부여할 시스템 권한 항목 나열
--  * role(역할): 한 개 이상의 권한들의 집합(****)
--    권한의 부여/취소 작업을 용이하게 하기 위해 사용
--  * PUBLIC: DB내의 모든 계정 의미 (****)
--    DB 내의 모든 사용자 계정에, 특정 시스템 권한을 한번에 부여
--  * WITH ADMIN OPTION :
--      a. 임의의 사용자가, DBA로부터 부여받은 권한을,
--         다른 사용자에게 재부여 할 수 있도록 한다
--      b. 즉, 부여한 시스템 권한을 위임(delegation) 하는 기능(***)
--      c. 따라서, 주의해서 사용해야 함(***)
--      d. (**주의**) DBA가 해당 시스템 권한을 회수(revoke)
--         하더라도, 한번 위임된 시스템 권한은, 연쇄적으로(Cascade)
--         회수(revoke)가 되지 않음.
--      e. Revoking_delegated_system_privileges.JPG 이미지 참고
-- ------------------------------------------------------

-- user01 일반계정에,
--  CREATE SESSION (DB접속 시스템권한),
--  CREATE TABLE (table 생성 시스템권한)
-- 할당(부여)
GRANT
    CREATE SESSION,
    CREATE TABLE
TO
    user01;


-- CREATE SESSION 시스템 권한 테스트
-- 접속설정을 통해 확인 (VSC or Oracle SQL*Developer or Oracle SQL*PLUS)

-- CREATE TABLE 시스템 권한 테스트
CREATE TABLE t (
    dummy CHAR(1)
);


DESC t;


-- ------------------------------------------------------
-- 2-2. SESSION_PRIVS 데이터 사전 조회
-- ------------------------------------------------------
-- 현재 접속한 사용자 계정의 시스템 권한정보 저장
-- ------------------------------------------------------
DESC session_privs;


SELECT
    *
FROM
    session_privs;


-- ------------------------------------------------------
-- 2-3. 할당한 시스템권한 회수(DCL: REVOKE 문장)
-- ------------------------------------------------------
--  가. DBA(SYSDBA role)가 일반계정에 부여한 시스템 권한은
--      언제든지 회수(revoke) 가능
-- ------------------------------------------------------
-- Basic syntax:
--
--  REVOKE 회수할시스템권한1 [, 회수할시스템권한2, ...]
--  FROM { 사용자계정 | role | PUBLIC };
--
--  * REVOKE clause: 회수할 시스템권한들 나열
--  * FROM clause: 시스템 권한을 회수할 대상 지정
--  * PUBLIC: DB 내에 존재하는 모든 일반계정(사용자)에게서,
--            지정된 시스템 권한을 한번에 회수(revoke)
-- ------------------------------------------------------
REVOKE
    CREATE SESSION,
    CREATE TABLE
FROM
    user01;


-- 시스템 권한 CREATE SESSION 을 회수한 이후에, 재접속 시도

-- ORA-01045: user USER01 lacks CREATE SESSION privilege; logon denied
-- {VSC | Oracle SQL*Developer | Oracle SQL*PLUS} 통해 접속시도     -- XX : 접속실패


-- ------------------------------------------------------
-- 2-4. 객체 권한 (Object Privileges)
-- ------------------------------------------------------
--  가. 특정 테이블/뷰/시퀀스/프로시져 등에 DML 문장을 수행할 수 있는 권리
--  나. 사용자는, 자신의 스키마 내에 저장되어있는,
--      모든 Oracle객체에 대하여 권한을 가짐
--  다. 다른 사용자 or 역할(role)에게, 자신이 소유한 Oracle 객체에
--      대해서, DML 문장을 실행할 수 있는 권한을 부여 or 회수 할 수 있음 
--  라. 다른 사용자에게 부여(grant)/회수(revoke) 할 수 있는,
--      객체 권한의 종류는 아래 이미지를 참고할 것:
--      Object_privileges.JPG
-- ------------------------------------------------------
-- Basic syntax:
--
--  GRANT 객체권한1[(컬럼)], 객체권한2[(컬럼)], ...
--  ON 객체명
--  TO { 사용자계정 | role | PUBLIC }
--  [WITH GRANT OPTION] ;
--
--  * GRANT clause: 부여할 객체권한 항목 나열
--      UDPATE 권한인 경우, 컬럼명과 함께 지정 가능!!(**)
--  * ON clause: 객체권한을 부여할 대상 Oracle 객체 지정
--  * TO clause: 지정된 객체권한을 부여받을 대상 지정
--  * WITH GRANT OPTION: 
--      a. 부여할 객체권한을, TO 절에 지정한 대상에, 
--         위임(delegation) 할 지 여부 지정 옵션(권한위임)
--          아래 이미지 참고:
--              Revoking_delegated_object_privileges.JPG
--      b. 시스템권한의 연쇄회수와 틀리게(연쇄회수불가),
--         위임된 객체권한(delegated object privileges)의
--         연쇄회수는 가능하다!!!(****)
-- ------------------------------------------------------

-- SCOTT 계정으로 실행
-- dept 테이블에 대한, SELECT / INSERT 객체권한을, user01 계정에 부여
GRANT
    SELECT,
    INSERT
ON
    dept
TO
    user01;


-- USER01 계정으로 실행

-- SELECT/INSERT 객체권한을 부여받은, scott.dept 테이블에 대한 조회
SELECT
    *
FROM
    scott.dept;        -- OK


-- ORA-01031: insufficient privileges
DELETE FROM scott.dept
WHERE
    deptno = 50;      -- XX: DELETE 객체권한은 부여받지 못했음


-- ------------------------------------------------------
-- 2-5. 권한(Privileges) 관련, 데이터 사전
-- ------------------------------------------------------
--  a. USER_TAB_PRIVS_MADE
--     현재 사용자가, 다른 사용자에게 부여한 객체권한을 알고자 할 때
--  b. USER_TAB_PRIVS_RECD
--     자신에게 부여된 객체권한을 알고 싶을 때
-- ------------------------------------------------------

-- SCOTT 계정으로 실행:

-- 1. USER_TAB_PRIVS_MADE 데이터 사전
-- SCOTT 사용자가, 다른 사용자에게 부여한 권한정보 조회
DESC user_tab_privs_made;


SELECT
    *
FROM
    user_tab_privs_made;


-- 2. USER_TAB_PRIVS_RECD 데이터 사전
-- SCOTT 사용자가, 다른 사용자에게서 부여받은 권한정보 조회
DESC user_tab_privs_recd;


SELECT
    *
FROM
    user_tab_privs_recd;


