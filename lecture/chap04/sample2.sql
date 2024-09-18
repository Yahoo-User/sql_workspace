-- sample2.sql


-- ******************************************************
-- SELECT 문의 기본구조와 각 절의 실행순서
-- ******************************************************
--  - Clauses -                 - 실행순서 -
--
-- SELECT clause                        (5)
-- FROM clause                          (1)
-- [ WHERE clause ]                     (2)
-- [ GROUP BY clause ]                  (3)
-- [ HAVING clause ]                    (4)
-- [ ORDER BY clause ]                  (6)
-- ******************************************************


-- ------------------------------------------------------
-- 3. 단순컬럼과 그룹 (처리)함수 - 주의: 함께 사용불가!!!
-- ------------------------------------------------------
-- a. 단순컬럼 : 그룹 함수가 적용되지 않음
-- b. 그룹함수 : 여러 행(그룹) 또는 테이블 전체에 대해 적용
--              하나의 값을 반환
-- ------------------------------------------------------
SELECT
    max(salary)     -- return only 1 value.
FROM
    employees;


-- 단순컬럼과 그룹함수 : 함께 사용불가!!!!
-- Error: ORA-00937: not a single-group group function
SELECT
    last_name,      -- return 107 values.
    max(salary)     -- return only 1 value.
FROM
    employees;


