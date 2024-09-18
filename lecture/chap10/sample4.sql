-- sample4.sql


-- ------------------------------------------------------
-- 4. Index 적용시점
-- ------------------------------------------------------
--  가. Index 를 사용하면, 검색속도 향상 기대가능
--  나. (**주의1**)index 를 사용한다고, 무조건 검색속도가 향상되는 것은 아님!!
--      - 한 테이블에 너무 많은 인덱스를 생성하면, 오히려 성능저하 발생!!
--  다. (**주의2**) 컬럼의 NULL 값은, 해당 컬럼에 인덱스 생성시, 인덱스에 저장안됨!!
--      - 따라서, 생성된 Index의 크기가 감소가능. 
--      - 그러므로, 이런 컬럼에 인덱스 생성 권고(필요시)
--  라. (**주의3**) 테이블에 DML 작업이 많은 경우, 해당 테이블의 컬럼에 대해서
--      관련된 모든 인덱스도 함께 변경되어야 함 -> 검색/DML 속도 모두 저하!!
--      - DML 작업이 많다 > 테이블 변경이 자주발생 > 인덱스의 B트리구조가 변경
--        > 매우 큰 성능저하 발생
--  마. (**주의4**) Index 가 생성된 컬럼일지라도, 함수를 사용하여 컬럼을 가공하거나,
--      NOT과 같은 부정 논리연산자를 사용하면, Index 적용이 안됨.
-- ------------------------------------------------------

-- ------------------------------------------------------
-- 4-1. Index 적용시점 (언제 index를 생성/사용해야 하는가?)
-- ------------------------------------------------------
--  a. 테이블 데이터가 많을 때.
--  b. 특정 컬럼값의 범위가 넓을 경우.
--  c. WHERE절에 사용되는 컬럼
--  d. Join 조건에 사용되는 컬럼
--  e. DQL 쿼리결과의 크기가, 전체 데이터의 2 ~ 4 % 이내를
--     검색하는 경우
--  f. NULL 값을 많이 포함하는 컬럼의 경우
-- ------------------------------------------------------


-- ------------------------------------------------------
-- 4-2. Index 비적용시점 (언제 index를 사용하지 말아야 하는가?)
-- ------------------------------------------------------
--  a. 테이블 데이터가 적을 때.
--  b. 특정 컬럼값의 범위가 좁을 경우.
--  c. WHERE절에 사용되는 컬럼이 자주 사용되지 않는 경우.
--  d. 테이블에 DML 수행이 많은 경우.
--  e. DQL 쿼리결과의 크기가, 전체 데이터의 10 ~ 15 % 이상을
--     검색하는 경우
--  f. Index 가 생성된 컬럼이, 함수/NOT(부정) 연산자와 같이
--     사용되는 경우
-- ------------------------------------------------------

-- To create a index for emp.ename column
DROP INDEX emp_ename_idx;


CREATE INDEX emp_ename_idx
ON emp(ename);


-- To select data NOT using index for emp.empno
-- 사유) 인덱스가 걸린 컬럼에 대해서, 함수로 가공처리
SELECT
  *
FROM
  emp
WHERE
  to_number(empno) = 7369;

-- ------------------------------------------------------

-- 특정 쿼리의 실행계획(Execute Plan) 보기 
-- (반드시, Oracle SQL*Developer에서 수행)

-- DQL 문장에 대해, 실행계획 생성
EXPLAIN PLAN
    SET statement_id = 'ex_plan3'
    INTO plan_table
FOR
    SELECT
      *
    FROM
      emp
    WHERE
      to_number(empno) = 7369;


-- 생성된 실행계획 정보 출력
SELECT
  * 
FROM
  table( DBMS_XPLAN.display() );


SELECT
  plan_table_output
FROM
  table( DBMS_XPLAN.display(NULL, 'ex_plan3', 'BASIC') );

-- ------------------------------------------------------

-- 부정 연산자 적용시 인덱스 사용불가
SELECT
  *
FROM
  emp
WHERE
  empno != 7369;    -- PK 컬럼에 비동등비교연산자(!=) 사용


-- 특정 쿼리의 실행계획(Execute Plan) 보기 
-- (반드시, Oracle SQL*Developer에서 수행)

-- DQL 문장에 대해, 실행계획 생성
EXPLAIN PLAN
    SET statement_id = 'ex_plan4'
    INTO plan_table
FOR
    SELECT
      *
    FROM
      emp
    WHERE
      empno != 7369;


-- 생성된 실행계획 정보 출력
SELECT
  * 
FROM
  table( DBMS_XPLAN.display() );


SELECT
  plan_table_output
FROM
  table( DBMS_XPLAN.display(NULL, 'ex_plan4', 'BASIC') );


-- ------------------------------------------------------
-- 4-3. DBMS_XPLAN.display() Function
-- ------------------------------------------------------
-- Function Prototype:
--
-- FUNCTION DISPLAY(
--    table_name    VARCHAR2 DEFAULT 'PLAN_TABLE',
--    statement_id  VARCHAR2 DEFAULT NULL,
--    format        VARCHAR2 DEFAULT 'TYPICAL',
--    filter_preds  VARCHAR2 DEFAULT NULL
-- )
-- ------------------------------------------------------
-- Function Parameters
-- ------------------------------------------------------
-- Display_function_parameters.JPG 이미지 참고
-- ------------------------------------------------------

SELECT
  * 
FROM
  table( DBMS_XPLAN.display() );


SELECT
  plan_table_output
FROM
  table( DBMS_XPLAN.display(NULL, 'ex_plan4', 'BASIC') );

-- FROM
--   table( DBMS_XPLAN.display(NULL, 'ex_plan4', 'TYPICAL') );

-- FROM
--   table( DBMS_XPLAN.display(NULL, 'ex_plan4', 'ALL') );

-- FROM
--   table( DBMS_XPLAN.display(NULL, 'ex_plan4', 'OUTLINE') );

-- FROM
--   table( DBMS_XPLAN.display(NULL, 'ex_plan4', 'ADVANCED') );