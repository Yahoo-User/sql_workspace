-- sample4.sql


-- ******************************************************
-- SELECT 문의 기본구조와 각 절의 실행순서
-- ******************************************************
--  - Clauses -                 - 실행순서 -
--
-- SELECT clause                    (5)
-- FROM clause                      (1)
-- WHERE clause                     (2)
-- GROUP BY clause                  (3)
-- HAVING clause                    (4)
-- ORDER BY clause                  (6)
-- ******************************************************


-- ------------------------------------------------------
--        *** SELECT 문의 기본문법 구조 ***
-- ------------------------------------------------------
-- SELECT [DISTINCT] { *, column [AS] [alias], ... }
-- FROM <테이블명>
-- ------------------------------------------------------

-- ------------------------------------------------------
-- 1. To remove duplicated data (중복제거)
-- ------------------------------------------------------
-- SELECT DISTINCT column1[, column2, ..., columnN]
-- FROM table;
-- ------------------------------------------------------
SELECT
    job_id
FROM
    employees;


SELECT
    DISTINCT job_id
FROM
    employees;


SELECT
    DISTINCT last_name, first_name
-- SELECT DISTINCT *
FROM
    employees;

