-- sample7.sql


-- ------------------------------------------------------
-- (4) CHECK 제약조건
-- ------------------------------------------------------
-- 가. 해당 컬럼에 저장되는 데이터를 검사하여,
--     조건과 일치하는 데이터만 저장가능
-- 나. 제약조건명 형식: table_column_ck
-- ------------------------------------------------------

-- ------------------------------------------------------
-- Basic Syntax1: column-level
--
--  CREATE TABLE [스키마].테이블명 (
--      컬럼명1 데이터타입 [CONSTRAINT 제약조건명] CHECK(조건식),
--      컬럼명2 데이터타입,
--      ...
--  );
-- ------------------------------------------------------

CREATE TABLE department8 (
    deptno  NUMBER(2) ,
    dname   VARCHAR2(15)
        CONSTRAINT department8_dname_ck CHECK( dname IN('개발','인사') ),
    loc     VARCHAR2(15)
);


-- CHECK 제약조건에 부합
INSERT INTO department8 (deptno, dname, loc)
VALUES (10, '개발', '서울');


INSERT INTO department8 (deptno, dname, loc)
VALUES (20, '인사', '경기');


-- CHECK 제약조건에 위배
-- ORA-02290: check constraint (SCOTT.DEPARTMENT8_DNAME_CK) violated
INSERT INTO department8 (deptno, dname, loc)
VALUES (30, '개발부', '서울');


SELECT
    *
FROM
    department8;


-- ------------------------------------------------------
-- Basic Syntax2: table-level
--
--  CREATE TABLE [스키마].테이블명 (
--      컬럼명1 데이터타입 ,
--      컬럼명2 데이터타입,
--      ... ,
--
--      [CONSTRAINT 제약조건명] CHECK(조건식)
--  );
-- ------------------------------------------------------

CREATE TABLE department9 (
    deptno  NUMBER(2) ,
    dname   VARCHAR2(15),
    loc     VARCHAR2(15),

    CONSTRAINT department9_dname_ck CHECK( dname IN('개발','인사') )
);


-- CHECK 제약조건에 부합
INSERT INTO department9 (deptno, dname, loc)
VALUES (10, '개발', '서울');


INSERT INTO department9 (deptno, dname, loc)
VALUES (20, '인사', '경기');


-- CHECK 제약조건에 위배
-- ORA-02290: check constraint (SCOTT.DEPARTMENT9_DNAME_CK) violated
INSERT INTO department9 (deptno, dname, loc)
VALUES (30, '개발부', '서울');


SELECT
    *
FROM
    department9;
