-- sample3.sql


-- ------------------------------------------------------
-- 3. Synonym (동의어)
-- ------------------------------------------------------
--  가. DB 객체에 대한 별칭
--  나. DB 객체에 대한 접근방법을 단순화 시킴
--  다. 다른 사용자의 객체 접근 -> "스키마.객체" 형식으로 접근
--      a. 반드시 스키마를 지정하여, 객체의 소유자가 누구인지 알려야 함
--      b. 스키마를 지정하지 않으면, 자신의 스키마(계정) 내에서 객체를
--         찾음 --> 오류발생 가능
--      c. 객체이름이 길거나, 스키마를 직접 명시하여 보안에 문제
--         발생가능
--  라. 동의어(Synonym) 사용 시,
--      a. 객체 접근 단순화 가능
--      b. 보안문제도 해결 가능
--  마. "스키마.객체"에 대한 별칭
--      a. 스키마 : 객체를 소유한 사용자명
--      b. 객체 : 동의어를 만들려는 DB객체 이름
--  바. 구분 :
--      (1) private
--          a. 동의어를 만든 사용자만 사용가능
--          b. 일반 계정으로 생성/삭제 가능
--
--      (2) public
--          a. 모든 사용자가 사용가능
--          b. DBA권한 가진 관리자만이 생성/삭제 가능
--
--          ex) DUAL    ->  SYS.DUAL
--  사. DB 객체의 소유권
--      a. 해당 객체를 생성한 사용자
--      b. 다른 사용자가 소유한 객체에 접근 -> 반드시 접근권한이 필요
-- ------------------------------------------------------
-- Basic Syntax:
--
--  CREATE [PUBLIC] SYNONYM 동의어
--  FOR 스키마.객체 ;
-- ------------------------------------------------------


-- ------------------------------------------------------
-- 3-1. Synonym (동의어) 생성 및 활용
-- ------------------------------------------------------

-- HR 계정: employees 테이블에 대한,
--          select 객체권한을 scott 계정에 부여 
-- ------------------------------------------------------
GRANT select
ON employees
TO scott;


-- ------------------------------------------------------
-- **SCOTT 계정**: HR계정 소유의 employees 테이블에, 스키마를 사용하여 접근가능
-- ------------------------------------------------------
SELECT
    *
FROM
    hr.employees;


-- 스키마 사용하지 않는 경우 에러
-- ------------------------------------------------------
-- ORA-00942: table or view does not exist
SELECT
    *
FROM
    employees;


-- ------------------------------------------------------
-- HR스키마를 지정하지 않고, employees 테이블에 접근하기 위해,
-- SCOTT 계정에서, Synonym(동의어) 생성.
-- ------------------------------------------------------
-- (*주의*) 일반계정인 SCOTT 계정은, Synonym 객체를 생성할 권한이 없음
--          SYSDBA 권한을 가지는 SYS계정으로, CREATE SYNONYM 시스템권한을
--          우선 할당받아야 함.
-- ------------------------------------------------------

-- SYS 계정에서 수행
GRANT CREATE SYNONYM TO scott;


-- SCOTT 계정
CREATE SYNONYM emp_synonym
FOR hr.employees;


-- 동의어를 이용한 테이블 접근
-- ------------------------------------------------------
-- (1) HR 스키마명과 employees 테이블명을 직접적으로 
--     명시하지 않기 때문에, 보안강화에 도움
-- (2) 좀 더 단순하게, 다른 사용자 객체접근이 가능
-- ------------------------------------------------------
SELECT
    *
FROM
    emp_synonym;


-- ------------------------------------------------------
-- 3-2. Synonym (동의어) 삭제
-- ------------------------------------------------------
-- Basic syntax:
--
--  DROP SEQUENCE <삭제할 시퀀스 객체명>;
-- ------------------------------------------------------

-- 동의어 삭제
DROP SYNONYM emp_synonym;



