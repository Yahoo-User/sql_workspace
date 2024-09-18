-- sample4.sql


-- ------------------------------------------------------
-- (1) PRIMARY KEY 제약조건
-- ------------------------------------------------------

-- 컬럼 레벨(column-level) 방식의 기본 키(PRIMARY KEY) 설정
CREATE TABLE department3 (
    deptno  NUMBER(2)       CONSTRAINT department_deptno_pk PRIMARY KEY,
    dname   VARCHAR2(15),
    loc     VARCHAR2(15)
);


-- 테이블 레벨(table-level) 방식의 복합컬럼 기반의 기본키(PRIMARY KEY) 설정
CREATE TABLE department4 (
    deptno  NUMBER(2),
    dname   VARCHAR2(15),
    loc     VARCHAR2(15),

    -- table-level 제약조건 정의하는 경우에만,
    -- 두 개 이상의 컬럼(복합컬럼)에 제약조건 정의가능
    CONSTRAINT department3_deptno_pk PRIMARY KEY(deptno, loc)
);

-- ------------------------------------------------------

-- 중복저장 불가 (Primary Key)
INSERT INTO department (deptno, dname, loc)
VALUES (10, '인사', '서울');


-- ORA-00001: unique constraint (SCOTT.DEPARTMENT_DEPTNO_PK) violated
INSERT INTO department (deptno, dname, loc)
VALUES (10, '개발', '경기');


-- null 값 저장 불가
-- ORA-01400: cannot insert NULL into ("SCOTT"."DEPARTMENT"."DEPTNO")
INSERT INTO department (deptno, dname, loc)
VALUES (NULL, '개발', '경기');


SELECT
    *
FROM
    department;


