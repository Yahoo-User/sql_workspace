-- sample10.sql


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
-- 연산자 우선순위 (The operator's priorities)
-- ------------------------------------------------------
-- (1) 괄호( )
-- (2) 비교 연산자
-- (3) NOT 연산자
-- (4) AND 연산자
-- (5) OR 연산자
--
--  * 우선순위: 괄호( ) > 비교 > NOT > AND > OR
-- ------------------------------------------------------

-- 1. AND 연산자가 우선실행 : 예상치 못한 결과
SELECT
    last_name,
    job_id,
    salary,
    commission_pct
FROM
    employees
WHERE
    job_id ='AC_MGR' OR job_id='MK_REP'
    AND commission_pct IS NULL
    AND salary >= 4000
    AND salary <= 9000;

-- 2. 연산자 우선순위 조정(소괄호 이용): 올바른 결과
SELECT
    last_name,
    job_id,
    salary,
    commission_pct
FROM
    employees
WHERE 
    ( job_id ='AC_MGR' OR job_id='MK_REP' )
    AND commission_pct IS NULL
    AND ( salary BETWEEN 4000 AND 9000 )
    -- AND salary >= 4000
    -- AND salary <= 9000;
