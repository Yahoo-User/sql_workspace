-- sample2.sql


-- ------------------------------------------------------
-- 1. Index 생성
-- ------------------------------------------------------
--  가. 빠른 데이터 검색을 위해 존재하는 오라클 객체
--  나. 명시적으로 생성하지 않아도, 자동 생성되기도 함
--      (PK/UK 제약조건 생성시, Unique Index 자동생성)
--  다. PK/UK 제약조건에 따른, 자동생성 Unique Index:
--      a. 데이터 무결성을 확인하기 위해, 수시로 데이터 검색 필요
--      b. 따라서, 빠른 검색이 요구됨
--  라. 명시적인 인덱스 생성이 우리가 할 일!!!
-- ------------------------------------------------------
-- Basic syntax:
--
--  CREATE [UNIQUE] INDEX 인덱스명
--  ON 테이블(컬럼1[, 컬럼2, ...]);
--
--
--  (1) Unique Index
--      a. CREATE UNIQUE INDEX 문으로 생성한 인덱스
--      b. Index 내의 Key Columns에 중복값 허용하지 않음
--      c. 성능이 가장 좋은 인덱스
--      d. (*주의*) 중복값이 허용되는 테이블 컬럼에는 절대로 사용불가!!
--
--  (2) Non-unique Index
--      a. CREATE INDEX 문으로 생성한 인덱스
--      b. 중복값이 허용되는 테이블 컬럼에 대해,
--         일반적으로 생성하는 인덱스
-- ------------------------------------------------------

-- Index 없이, Table Full Scan 방식을 통한, 데이터 조회
SELECT
    *
FROM
    emp
WHERE
    ename = 'SMITH';


-- 특정 쿼리의 실행계획(Execute Plan) 보기 
-- (반드시, Oracle SQL*Developer에서 수행)

-- DQL 문장에 대해, 실행계획 생성
EXPLAIN PLAN
    SET statement_id = 'ex_plan1'
    INTO plan_table
FOR
    SELECT
        *
    FROM
        emp
    WHERE
        ename = 'SMITH';


-- 생성된 실행계획 정보 출력
DESC plan_table;            -- 실행계획 저장 테이블 스키마 보기


SELECT
    *
FROM
    plan_table;            -- 실행계획 테이블 모두 조회


SELECT
    * 
FROM
    table( DBMS_XPLAN.display() );


SELECT
    plan_table_output
FROM
    table( DBMS_XPLAN.display() );


SELECT
    plan_table_output
FROM
    table( DBMS_XPLAN.display(NULL,'ex_plan1', 'BASIC') );


SELECT
    cardinality "Rows",
    lpad(' ', level-1) || operation || ' ' || options || ' ' || object_name "Plan"
FROM
    plan_table
CONNECT BY
    prior id = parent_id
    AND prior statement_id = statement_id
START WITH id = 0
    AND statement_id = 'ex_plan1'
ORDER BY
    id;

-- ------------------------------------------------------

-- Index 생성하여, Index Scan 방식을 통한 데이터 조회
DROP INDEX emp_ename_idx;


CREATE INDEX emp_ename_idx
ON emp(ename);


-- 특정 쿼리의 실행계획(Execute Plan) 보기 
-- (반드시, Oracle SQL*Developer에서 수행)

-- DQL 문장에 대해, 실행계획 생성
EXPLAIN PLAN
    SET statement_id = 'ex_plan2'
    INTO plan_table
FOR
    SELECT *
    FROM emp
    WHERE ename = 'SMITH';


-- 생성된 실행계획 정보 출력
DESC plan_table;            -- 실행계획 저장 테이블 스키마 보기


SELECT
    *
FROM
    plan_table;            -- 실행계획 테이블 모두 조회


SELECT
    * 
FROM
    table( DBMS_XPLAN.display() );


SELECT
    plan_table_output
FROM
    table( DBMS_XPLAN.display() );


SELECT
    plan_table_output
FROM
    table( DBMS_XPLAN.display(NULL, 'ex_plan2', 'BASIC') );


SELECT
    cardinality "Rows",
    lpad(' ', level-1) || operation || ' ' || options || ' ' || object_name "Plan"
FROM
    plan_table
CONNECT BY
    prior id = parent_id
    AND prior statement_id = statement_id
START WITH id = 0
    AND statement_id = 'ex_plan2'
ORDER BY
    id;


