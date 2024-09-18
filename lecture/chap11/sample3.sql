-- sample3.sql


-- ------------------------------------------------------
-- 3. 역할(role) 관리
-- ------------------------------------------------------
--  가. 1, 2에서, 사용자 생성/암호변경, 권한 부여(grant)/회수(revoke)
--  나. 사용자에게, 일일이 권한 부여 or 회수 작업 -> 매우 번거로움
--  다. 이런 번거로운 작업을, 보다 효율적으로 권한의 부여/회수하는 방법
--      으로 사용
--  라. **개념** : 여러 권한들을 하나로 묶어 놓은 것
--  마. 다수 사용자에게, 공통적으로 필요한 권한들을 역할(role)에
--      하나의 그룹으로 묶어서, 사용자에게 개별 권한을 부여/회수하지 않고,
--      역할(role)을 부여/회수
--      a. 동시에 여러 다양한 권한들을 부여/회수 -> 권한관리 용이
--      b. 역할(role)의 권한수정/부여/회수 -> 사용자들의 권한이 
--         자동 수정/부여/회수 됨
--  바. 일시적으로, 활성화/비활성화 가능
--      a. 일시적으로, 사용자들의 권한들을 부여/철회 가능
--      b. 사용자 권한관리를 간편하고 효율적으로 할 수 있음
--  사. **가장 큰 특징** A002: 동적으로 권한들 관리가능
--      a. 기존 역할(role)에 새로운 권한 부여 -> 
--         자동으로, 해당 역할(role)을 부여받은, 모든 사용자에게도 
--         새로운 권한이 동적으로 부여됨
--      b. 기존 역할(role)에서 어떤 권한을 회수(revoke) ->
--         자동으로, 해당 역할(role)을 부여받은, 모든 사용자에게서
--         동적으로 해당 권한이 회수됨
-- ------------------------------------------------------


-- ------------------------------------------------------
-- 3-1. 역할(role) 종류
-- ------------------------------------------------------
--  (1) Built-in Roles (기본제공 Roles)
--      a. 사전에 정의된 기본 제공 역할(roles)
--      b. 아래 이미지 참고: Buil-in_roles.JPG
--      c. DBA_ROLES 데이터 사전을 통해 확인가능
--      d. 신규 생성 계정에, DBA가 일반적으로 부여하는 역할(roles)로,
--         아래의 두가지가 대표적으로 부여됨:
--          - CONNECT   : 해당 신규 계정으로, DB 접속가능
--          - RESOURCE  : 해당 신규 계정으로, 테이블 같은 Oracle 객체 생성가능
--
--  (2) User-defined Roles (사용자 정의 Roles)
--      사용자가 필요에 의해서 정의한 역할(roles)
-- ------------------------------------------------------


-- ------------------------------------------------------
-- 3-1-1. Built-in Roles (기본제공 Roles)
-- ------------------------------------------------------

-- SYS 계정으로 실행:

-- DBA_ROLES 데이터 사전조회: Built-in Roles 조회
SELECT
    role
FROM
    dba_roles;


-- user02 신규 계정 생성
CREATE USER user02
IDENTIFIED BY Oracle12345678;


-- user02 계정에, Built-in Roles 부여(grant)
-- 신규생성 계정에, DBA가 일반적으로 부여하는 역할(roles)
GRANT
    CONNECT,
    RESOURCE
TO
    user02;


-- user02 계정에 부여된 Built-in Roles 회수(revoke)

-- 해당 계정에서 회수할 역할(roles)이 없는 경우, 아래 오류발생:
--  ORA-01951: ROLE 'CONNECT' not granted to 'USER02'
REVOKE 
    CONNECT,
    RESOURCE
FROM
    user02;


-- ------------------------------------------------------
-- 3-1-2. User-defined Roles (사용자 정의 Roles)
-- ------------------------------------------------------
--  사용자가 필요에 의해, 여러 권한들을 묶어, 역할(roles)을
--  생성하고, 이 역할(roles)을 사용자에게 부여(grant)/회수(revoke)
--  할 수 있음.
-- ------------------------------------------------------

-- 1. 신규 사용자 생성 (SYS 계정으로 실행)

CREATE USER user03
IDENTIFIED BY Oracle12345678;


-- 2. 사용자 정의 역할(role) 생성 (SYS 계정으로 실행)

CREATE ROLE clerk;  -- 'clerk' 역할(role) 생성


-- 3. 생성된 역할(role)에,
--  a. 아래 두 개의 시스템 권한 부여(SYS 계정으로 실행)
--    CREATE SESSION, CREATE TABLE

GRANT
    CREATE SESSION,
    CREATE TABLE
TO
    clerk;


--  b. SCOTT.DEPT 테이블에 대한, SELECT 객체권한 부여
--     (SYS 계정으로 실행)

GRANT
    SELECT
ON
    scott.dept
TO
    clerk;


-- 4. 신규생성 사용자(user03)에 직접 정의한 역할(role) 부여
--    (SYS 계정으로 실행)
--
--    user03 사용자는, clerk 역할(role)에 포함된 권한에 의해서,
--    DB접속/테이블 생성/scott.dept테이블 조회 가능

GRANT
    clerk
TO
    user03;


-- 5. DBA_SYS_PRIVS 데이터 사전조회 (SYS 계정으로 실행)
--    위에서 직접 정의한 역할(role)에 부여된 시스템 권한들 확인

SELECT
    grantee,
    privilege
FROM
    dba_sys_privs
WHERE
    grantee = 'CLERK';


-- 6. DBA_TAB_PRIVS 데이터 사전조회 (SYS 계정으로 실행)
--    위에서 직접 정의한 역할(role)에 부여된 객체 권한들 확인

SELECT
    *
FROM
    dba_tab_privs
WHERE
    grantee = 'CLERK';



-- ------------------------------------------------------
-- 3-2. 역할(role)을 이용한, 동적 권한 관리
-- ------------------------------------------------------

-- 1. CLERK 역할(role)에, CREATE VIEW 시스템 권한 추가부여
--    (SYS 계정으로 실행)

GRANT
    CREATE VIEW
TO
    clerk;

-- OR

REVOKE
    CREATE VIEW
FROM
    clerk;


-- 2. CLERK 역할(role)이 부여된, user03 계정의 현재 권한에,
--    위 1에서 추가 부여한, 시스템 권한이 동적으로 부여되었는지 확인
--    (SYS 계정으로 실행)

SELECT
    grantee,
    privilege
FROM
    dba_sys_privs
WHERE
    grantee = 'CLERK';


-- 3. CLERK 역할(role)이 부여된, user03 계정의 현재 권한에,
--    위 1에서 추가 부여한, 객체 권한이 동적으로 부여되었는지 확인
--    (SYS 계정으로 실행)

SELECT
    *
FROM
    dba_tab_privs
WHERE
    grantee = 'CLERK';



