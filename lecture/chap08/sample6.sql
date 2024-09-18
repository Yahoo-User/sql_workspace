-- sample6.sql


-- ------------------------------------------------------
-- (3) NOT NULL 제약조건
-- ------------------------------------------------------
-- 가. 해당 컬럼에 NULL 값 저장 방지
-- 나. 컬럼-레벨 방식만 허용 (** 테이블-레벨 방식 비허용 **)
-- 다. null 값을 허용하는 기존 컬럼의 동작을 수정 --> 
--     제약조건 추가가 아니라, 기존 조건의 수정
-- 라. 제약조건명 형식: table_column_nn
-- ------------------------------------------------------
-- Basic Syntax: column-level
-- 
--  CREATE TABLE [스키마].테이블명 (
--      컬럼명1 데이터타입 [CONSTRAINT 제약조건명] NOT NULL,
--      컬럼명2 데이터타입,
--      ...
--  );
-- ------------------------------------------------------

CREATE TABLE department7 (
    deptno  NUMBER(2)       CONSTRAINT department7_deptno_pk PRIMARY KEY,
    dname   VARCHAR2(15)    CONSTRAINT department7_dname_uk UNIQUE,
    loc     VARCHAR2(15)    CONSTRAINT department7_loc_nn NOT NULL
);


-- 널(null) 값 저장 불가
-- ORA-01400: cannot insert NULL into ("SCOTT"."DEPARTMENT7"."LOC")
INSERT INTO department7 (deptno, dname, loc)
VALUES (30, '인사', NULL);


SELECT
    *
FROM
    department7;

