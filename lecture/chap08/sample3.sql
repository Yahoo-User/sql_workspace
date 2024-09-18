-- sample3.sql


-- ------------------------------------------------------
-- USER_CONSTRAINTS 데이터 사전
-- ------------------------------------------------------
-- 특정 테이블의 제약조건 확인 (어떤 컬럼에 제약조건이 설정되어 있는지 확인불가)
-- 제약조건 타입(CONSTRAINT_TYPE 컬럼):
--  P: PRIMARY KEY, R: FOREIGN KEY, U: UNIQUE, 
--  C: NOT NULL, CHECK (NOT NULL 제약조건은, NULL 값을 체크하는 조건으로 처리)
DESC USER_CONSTRAINTS;


SELECT
    *
FROM
    USER_CONSTRAINTS
WHERE
    table_name IN ('DEPARTMENT', 'DEPARTMENT2');


-- ------------------------------------------------------
-- USER_CONS_COLUMNS 데이터 사전
-- ------------------------------------------------------
-- 어떤 컬럼에 제약조건이 설정되어 있는지 확인가능
DESC USER_CONS_COLUMNS;


SELECT
    *
FROM
    USER_CONS_COLUMNS
WHERE
    table_name IN ('DEPARTMENT', 'DEPARTMENT2');

