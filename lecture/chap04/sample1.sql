-- sample1.sql


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
-- 2. 그룹 (처리)함수
-- ------------------------------------------------------
-- 그룹 (처리)함수의 구분:
--
--  (1) SUM     - 해당 열의 총합계를 구한다
--  (2) AVG     - 해당 열의 평균을 구한다
--  (3) MAX     - 해당 열의 총 행중에 최대값을 구한다
--  (3) MIN     - 해당 열의 총 행중에 최소값을 구한다
--  (4) COUNT   - 행의 개수를 카운트한다
--
--  * 그룹 (처리)함수는, 1) 여러 행 또는 2) 테이블 전체에 대해, 
--    함수가 적용되어, 하나의 결과를 반환!
-- ------------------------------------------------------

-- ------------------------------------------------------
-- (1) 그룹 (처리)함수 - SUM
-- ------------------------------------------------------
-- 해당 열의 총합계를 구한다 (** NULL 값 제외하고 **)
-- ------------------------------------------------------
-- 문법) SUM( [ DISTINCT | ALL ] column )
--          DISTINCT : excluding duplicated values.
--          ALL : including duplicated values.
--                (if abbreviated, default)
-- ------------------------------------------------------
SELECT
    sum(DISTINCT salary),
    sum(ALL salary),
    sum(salary)
FROM
    employees;


-- ------------------------------------------------------
-- (2) 그룹 (처리)함수 - AVG
-- ------------------------------------------------------
-- 해당 열의 평균을 구한다 (** NULL 값 제외하고 **)
-- ------------------------------------------------------
-- 문법) AVG( [ DISTINCT | ALL ] column )
--          DISTINCT : excluding duplicated values.
--          ALL : including duplicated values.
--                (if abbreviated, default)
-- ------------------------------------------------------
SELECT
    sum(salary),
    avg(DISTINCT salary),
    avg(ALL salary),
    avg(salary)
FROM
    employees;


-- ------------------------------------------------------
-- (3) 그룹 (처리)함수 - (** NULL 값 제외하고 **)
--      MAX : 해당 열의 총 행중에 최대값을 구한다
--      MIN : 해당 열의 총 행중에 최소값을 구한다
-- ------------------------------------------------------
-- 문법) MAX( [ DISTINCT | ALL ] column )
--      MIN( [ DISTINCT | ALL ] column )
--          DISTINCT : excluding duplicated values.
--          ALL : including duplicated values.
--                (if abbreviated, default)
-- ------------------------------------------------------
SELECT
    max(salary),
    min(salary)
FROM
    employees;


SELECT
    min( hire_date ),
    max( hire_date)
FROM
    employees;


-- ------------------------------------------------------
-- (4) 그룹 (처리)함수 - COUNT
-- ------------------------------------------------------
-- 행의 개수를 카운트한다(* 컬럼명 지정하는 경우, NULL값 제외 *)
-- ------------------------------------------------------
-- 문법) COUNT( { [[ DISTINCT | ALL ] column] | * } )
--          DISTINCT : excluding duplicated values.
--          ALL : including duplicated values.
--                (if abbreviated, default)
-- ------------------------------------------------------
SELECT
    count(last_name),
    count(commission_pct)
FROM
    employees;


SELECT
    count(job_id),
    count(DISTINCT job_id)
FROM
    employees;


-- 해당 테이블의 전체 레코드 개수 구하기 (*주의필요*)
SELECT
    count(*),               -- Decommended
    count(commission_pct),  -- *Causion (removed all NULLs)
    count(employee_id)      -- *Recommended (Primary Key = Unique + Not NULL)
FROM
    employees;
