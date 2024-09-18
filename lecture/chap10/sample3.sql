-- sample3.sql


-- ------------------------------------------------------
-- 2. USER_INDEXES 데이터 사전
-- ------------------------------------------------------
--  가. 생성된 인덱스의 정보 저장
-- ------------------------------------------------------
DESC user_indexes;


-- USER_INDEXES 데이터 사전조회 (emp, dept table의 인덱스 정보)
SELECT
    index_name,
    table_name
FROM
    user_indexes
WHERE
    table_name IN ('EMP', 'DEPT');


-- ------------------------------------------------------
-- 3. USER_IND_COLUMNS 데이터 사전
-- ------------------------------------------------------
--  가. 생성된 인덱스의 정보 저장
--  나. 인덱스가 생성된 테이블의 컬럼에 대한 정보까지 저장
-- ------------------------------------------------------
DESC user_ind_columns;


-- USER_IND_COLUMNS 데이터 사전조회 (emp, dept table의 인덱스 정보)
SELECT
    index_name,
    table_name,
    column_name
FROM
    user_ind_columns
WHERE
    table_name IN ('EMP','DEPT');

