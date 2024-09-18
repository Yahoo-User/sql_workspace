-- sample5.sql


-- ------------------------------------------------------
-- (2) UNIQUE 제약조건
-- ------------------------------------------------------
-- 가. 기본키가 아닌 경우에도, 컬럼의 모든 데이터가 유일해야 하는
--     경우에 지정
-- 나. 자동으로 UNIQUE INDEX 생성 -> 빠른 검색효과
-- 다. 기본키(Primary Key)와의 차이점:
--     a. 하나의 테이블에, 여러개의 UNIQUE 제약조건 지정가능
--     b. null 값도 저장가능***
-- 라. 제약조건명 형식: table_column_uk
-- 마. 단순/복합 컬럼에 대해 지정가능
-- ------------------------------------------------------

-- ------------------------------------------------------
-- Basic Syntax1: column-level
--
--  CREATE TABLE [스키마].테이블명 (
--      컬럼명1 데이터타입 [CONSTRAINT 제약조건명] UNIQUE,
--      컬럼명2 데이터타입,
--      ...
--  );
-- ------------------------------------------------------

-- column-level
CREATE TABLE department5 (
    deptno  NUMBER(2)       CONSTRAINT department5_deptno_pk PRIMARY KEY,
    dname   VARCHAR2(15)    CONSTRAINT department5_dname_uk UNIQUE,
    loc     VARCHAR2(15)
);


-- 중복저장 불가 (Primary Key)
INSERT INTO department5 (deptno, dname, loc)
VALUES (10, '인사', '서울');


-- ORA-00001: unique constraint (SCOTT.DEPARTMENT5_DNAME_UK) violated
INSERT INTO department5 (deptno, dname, loc)
VALUES (20, '인사', '경기');


-- null 값 저장 허용
INSERT INTO department5 (deptno, dname, loc)
VALUES (30, NULL, '서울');


SELECT
    *
FROM
    department5;

-- ------------------------------------------------------
-- Basic Syntax2: table-level
--
--  CREATE TABLE [스키마].테이블명 (
--      컬럼명1 데이터타입,
--      컬럼명2 데이터타입,
--      ...
--      [CONSTRAINT 제약조건명] UNIQUE(컬럼명1 [,컬럼명2])
--  );
-- ------------------------------------------------------

-- table-level
CREATE TABLE department6 (
    deptno  NUMBER(2)       CONSTRAINT department6_deptno_pk PRIMARY KEY,
    dname   VARCHAR2(15),
    loc     VARCHAR2(15),

    CONSTRAINT department6_dname_uk UNIQUE(dname, loc)
);


-- 중복저장 불가 (Primary Key)
INSERT INTO department6 (deptno, dname, loc)
VALUES (10, '인사', '서울');


INSERT INTO department6 (deptno, dname, loc)
VALUES (20, '인사', '경기');


-- ORA-00001: unique constraint (SCOTT.DEPARTMENT6_DNAME_UK) violated
INSERT INTO department6 (deptno, dname, loc)
VALUES (30, '인사', '서울');


-- null 값 저장 허용
INSERT INTO department6 (deptno, dname, loc)
VALUES (40, null, '수원');


INSERT INTO department6 (deptno, dname, loc)
VALUES (50, '개발', null);


INSERT INTO department6 (deptno, dname, loc)
VALUES (60, null, null);


SELECT
    *
FROM
    department6;
