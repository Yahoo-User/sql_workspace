-- sample6.sql


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
-- 1. IN Operators (집합연산자)
-- ------------------------------------------------------
-- WHERE column IN ( value1, value2, ... )
-- ------------------------------------------------------
SELECT
    employee_id,
    last_name,
    salary,
    hire_date
FROM
    employees
WHERE
    employee_id IN ( 100, 200, 300);

-- 수학의 집합의 성질을 기억해야 합니다!!!
-- (중복 비허용, 순서를 보장하지 않는다!) 
-- WHERE
--    employee_id IN ( 100, 100, 200, 200, 300);    -- 집합원소유형: 1. 숫자


SELECT
    employee_id,
    last_name,
    salary,
    hire_date
FROM
    employees
WHERE
    -- 참고: 논리연산자 (AND, OR, NOT) = (그리고, 또는, 부정)
    employee_id = 100
    OR employee_id = 200
    OR employee_id = 300;


SELECT
    employee_id,
    first_name,
    last_name,
    job_id,
    salary,
    hire_date
FROM
    employees
WHERE
    last_name IN ('King', 'Abel', 'Jones');         -- 집합원소유형: 2. 문자열


SELECT
    employee_id,
    last_name,
    salary,
    hire_date
FROM
    employees
-- WHERE
--    hire_date IN ('01/01/13', '07/02/07');        -- 집합원소유형: 3. 날짜, OK only on the Oracle SQL*Developer
WHERE
    hire_date IN (
        to_date('01/01/13', 'RR/MM/DD'), 
        to_date('07/02/07', 'RR/MM/DD')
    );
