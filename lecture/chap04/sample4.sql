-- sample4.sql


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
-- 5. HAVING 조건식
-- ------------------------------------------------------
-- GROUP BY 절에 의해 생성된 결과(그룹들) 중에서, 지정된 조건에
-- 일치하는 데이터를 추출할 때 사용
--  
--  (1) 가장 먼저, FROM 절이 실행되어 테이블이 선택되고,
--  (2) WHERE절에 지정된 검색조건과 일치하는 행들이 추출되고,
--  (3) 이렇게 추출된 행들은, GROUP BY에 의해 그룹핑 되고,
--  (4) HAVING절의 조건과 일치하는 그룹들이 추가로 추출된다!!!
--
-- 이렇게, HAVING 절까지 실행되면, 테이블의 전체 행들이, 2번의
-- 필터링(filtering)이 수행된다.
-- ( WHERE절: 1차 필터링, HAVING절: 2차 필터링 )
-- ------------------------------------------------------
-- *** Chapter04 Page 13 참고할 것
-- ------------------------------------------------------

-- 각 부서별, 월급여 총계 구하기
SELECT
    department_id, sum(salary)      -- 4th.
FROM
    employees                       -- 1st.
GROUP BY
    department_id                   -- 2nd.
HAVING
    sum(salary) >= 90000            -- 3rd.
ORDER BY
    1 ASC;                          -- 5th.


-- 각 부서별, 직원수 구하기
SELECT
    department_id,
    count(department_id)
FROM
    employees
GROUP BY
    department_id                   -- NULL 그룹도 생성됨을 기억할 것!!!
HAVING
    count(salary) >= 6              -- 1st. filtering (for groups).
-- HAVING
--     salary >= 3000                  -- XX: 각 그룹에 대해, 단순컬럼들만 사용불가
-- HAVING
--     department_id IN (10, 20)       -- OK: GROUP BY절에 나열된 단순컬럼들은 사용가능
-- HAVING
--     department_id > 10              -- OK: GROUP BY절에 나열된 단순컬럼들은 사용가능
-- HAVING
--     department_id IS NULL           -- OK: NULL 그룹도 있음을 기억할 것!!
ORDER BY
    1 ASC;


-- 각 부서별, 월급여 총계 구하기
SELECT
    department_id,
    sum(salary)
FROM
    employees
WHERE
    salary >= 3000              -- 1st. filtering (for records).
GROUP BY
    department_id
HAVING
    sum(salary) >= 90000        -- 2nd. filtering (for groups).
ORDER BY
    1 ASC;