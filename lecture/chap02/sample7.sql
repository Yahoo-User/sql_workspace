-- sample7.sql


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
-- WHERE <predicates>
-- ------------------------------------------------------

-- ------------------------------------------------------
-- 1. LIKE Operators (패턴매칭연산자)
-- ------------------------------------------------------
-- WHERE column LIKE <패턴>
-- ------------------------------------------------------
-- <패턴>에 사용가능한 Wildcard 문자들:
--  (1) %       ( x >= 0,     x: 문자개수 )
--  (2) _       ( x == 1,     x: 문자개수 )
-- ------------------------------------------------------
SELECT
    employee_id,
    last_name,
    salary
FROM
    employees
WHERE
    last_name LIKE 'J%';        -- % : x >= 0 (x: 문자개수)


SELECT
    employee_id,
    last_name,
    salary
FROM
    employees
WHERE
    last_name LIKE '%ai%';      -- % : x >= 0 (x: 문자개수)


SELECT
    employee_id,
    last_name,
    salary
FROM
    employees
WHERE
    last_name LIKE '%in';       -- % : x >= 0 (x: 문자개수)


-- ------------------------------------------------------

SELECT
    employee_id,
    last_name,
    salary
FROM
    employees
WHERE
    last_name LIKE '_b%';       -- % : x >= 0, _ : x == 1 (x: 문자개수)

-- ------------------------------------------------------


SELECT
    employee_id,
    last_name,
    salary
FROM
    employees
WHERE
    last_name LIKE '_____d';    -- _ : x == 1 (x: 문자개수)


SELECT
    employee_id,
    last_name,
    salary
FROM
    employees
WHERE
    last_name LIKE '%d';        -- % : x >= 0 (x: 문자개수)

-- ------------------------------------------------------


SELECT
    employee_id,
    last_name,
    salary
FROM
    employees
WHERE
    last_name LIKE '%_%' '_'  '%%' '%';  -- % : x >= 0, _ : x == 1 (x: 문자개수)


SELECT
    employee_id,
    last_name,
    salary,
    job_id
FROM
    employees
WHERE
    job_id LIKE '%E_%' ESCAPE 'E';      -- % : x >= 0, _ : x == 1 (x: 문자개수)


SELECT
    employee_id,
    last_name,
    salary,
    job_id
FROM
    employees
WHERE
    job_id LIKE '%E___' ESCAPE 'E';     -- % : x >= 0, _ : x == 1 (x: 문자개수)

