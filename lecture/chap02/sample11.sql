-- sample11.sql


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
--        *** SELECT 문의 기본문법 구조 ***
-- ------------------------------------------------------
-- SELECT [DISTINCT] { *, column [AS] [alias], ... }
-- FROM <테이블명>
-- [ WHERE <predicates> ]
-- [ ORDER BY { column|표현식 } [ASC|DESC] ]
-- ------------------------------------------------------

-- ------------------------------------------------------
-- ORDER BY clause
-- ------------------------------------------------------
-- 문법)
--  SELECT [DISTINCT] {*, column [Alias], . . .}
--  FROM 테이블명
--  [ WHERE 조건식 ]
--  [ ORDER BY { column|표현식} [ASC|DESC] ];
-- ------------------------------------------------------

-- ------------------------------------------------------
-- 1. 숫자 데이터 정렬
-- ------------------------------------------------------
SELECT
    employee_id,
    last_name,
    job_id,
    salary
FROM
    employees
ORDER BY
   salary;           -- default: ASC (오름차순 정렬)
-- ORDER BY
--    salary ASC;       -- 오름차순 정렬 (ascending)
-- ORDER BY
--     salary DESC;     -- 내림차순 정렬 (descending)  


-- ORDER BY 절에 별칭(alias) 사용
SELECT
    employee_id,
    last_name,
    job_id,
    salary + 100 AS "월급"
FROM
    employees
-- ORDER BY
--    월급 DESC;            -- 컬럼별칭으로 정렬
ORDER BY
    salary + 100 DESC;  -- 표현식으로 정렬


-- ORDER BY 절에 컬럼인덱스 사용
-- (주의) Oracle은 인덱스가 1부터 시작함을 명심할 것!!
SELECT
    employee_id,        -- 1
    first_name,         -- 2
    last_name,          -- 3
    job_id,             -- 4
    salary AS "월급"     -- 5
FROM
    employees
-- 다른 대안이 없는 경우에만 쓸 것!!!(부작용)
-- (SELECT절의 구성컬럼목록에 변경이 없다 라는 조건하에...)
ORDER BY
    4 DESC;    -- 컬럼인덱스로 정렬


-- ------------------------------------------------------
-- 2. 문자 데이터 정렬
-- ------------------------------------------------------
SELECT
    employee_id,
    last_name AS 이름,
    job_id,
    salary
FROM
    employees
ORDER BY
   last_name ASC;  -- 컬럼명으로 정렬
-- ORDER BY
--    이름 ASC;        -- 컬럼별칭으로 정렬
-- ORDER BY
--     2 ASC;          -- 컬럼인덱스로 정렬


-- ------------------------------------------------------
-- 3. 날짜 데이터 정렬
-- ------------------------------------------------------
SELECT
    employee_id,
    last_name,
    salary,
    hire_date AS 입사일
FROM
    employees
-- ORDER BY
--     hire_date DESC;     -- 컬럼명으로 정렬
-- ORDER BY
--    입사일 DESC;          -- 컬럼별칭으로 정렬
ORDER BY
   4 DESC;              -- 컬럼인덱스로 정렬


-- ------------------------------------------------------
-- 4. 다중컬럼 정렬
-- ------------------------------------------------------
-- 문법)
-- SELECT [DISTINCT] {*, column [Alias], . . .}
-- FROM 테이블명
-- [WHERE 조건식]
-- ORDER BY 
--  {column1|표현식1} [ASC|DESC], 
--  {column2|표현식2} [ASC|DESC];
-- ------------------------------------------------------
SELECT
    employee_id,
    last_name,
    salary,
    hire_date
FROM
    employees
ORDER BY 
    salary DESC,        -- 컬럼명1로 내림차순 정렬
    hire_date;          -- 컬럼명2로 오름차순 정렬


SELECT
    employee_id,
    last_name,
    salary,
    hire_date
FROM
    employees
ORDER BY 
    3 DESC,             -- 컬럼인덱스1로 내림차순 정렬
    4;                  -- 컬럼인덱스2로 오름차순 정렬


-- ------------------------------------------------------
-- 5. NULL값 정렬
-- ------------------------------------------------------
-- (주의) Oracle 에서 가장 큰 값은, NULL 값임!!!
--       (값이 없기 때문에, 값의 크기를 비교불가)
--       따라서, 내림차순 정렬시, 가장 큰 값이 NULL 이 우선
-- ------------------------------------------------------
SELECT
    employee_id,
    last_name,
    commission_pct
FROM
    employees
-- ORDER BY
--    commission_pct DESC;    -- 컬럼명으로 내림차순 정렬
ORDER BY
    commission_pct ASC;

-- (주의) 관계형 데이터베이스의 테이블은, 수학의 집합과 동일
--  즉, 수학의 집합의 성질을 그대로 물려받음:
--       (1) 레코드의 순서를 보장하지 않음(즉, 무작위로 저장)
--       (2) 중복을 허용하지 않음
--           (단, 관계형 테이블은 중복행을 포함할 수는 잇으나
--            기본키(PK)가 지정되어있다면, 당연히 중복음 없음!)
