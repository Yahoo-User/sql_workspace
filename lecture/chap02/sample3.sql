-- sample3.sql


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
-- 1. Concatenation Operator: ||
-- ------------------------------------------------------
-- SELECT column1 || column2
-- FROM table;
-- ------------------------------------------------------
-- (1) 문자열 + 숫자
SELECT 
    last_name || salary AS "이름 월급"
FROM
    employees;


-- (2) 문자열 + 날짜
SELECT
    last_name || hire_date AS "이름 날짜"
FROM
    employees;


-- ------------------------------------------------------
-- 2. Concatenation Operator: ||
-- ------------------------------------------------------
-- SELECT column || literal
-- FROM table;
-- ------------------------------------------------------
-- (3) 문자열 + 리터럴(문자열)
SELECT
    last_name || '사원'
FROM
    employees;


-- ------------------------------------------------------
-- 3. Concatenation Operator: ||
-- ------------------------------------------------------
-- SELECT column1 || literal || column2 || literal || column3
-- FROM table;
-- ------------------------------------------------------
SELECT
    last_name || '의 직업은 ' || job_id || ' 입니다.' AS "사원별 직급"
FROM 
    employees;


SELECT
    last_name || ' 의 직업은 ' || job_id
FROM
    employees
WHERE
    last_name = 'Smith';    -- = : 동등비교연산자




