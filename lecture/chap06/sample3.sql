-- sample3.sql


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
-- 3. 복수 행 Sub-query
-- ------------------------------------------------------
-- 가. 하나 이상의 행을 반환
-- 나. 메인쿼리에서 사용가능한 연산자는 아래와 같음:
--      (1) IN : 메인쿼리와 서브쿼리가 IN 연산자로 비교수행. 
--               서브쿼리 결과값이 복수 개인 경우에 사용.
--      (2) ANY : 서브쿼리에서, > 또는 < 같은 비교 연산자를 사용하고자 
--                할 때 사용. 검색조건이 하나라도 일치하면 참.
--      (3) ALL : 서브쿼리에서 > 또는 < 같은, 비교 연산자를 사용하고자
--                할 때 사용. 검색조건의 모든 값이 일치하면 참.
--      (4) EXISTS : 서브쿼리의 반환값이 존재하면, 메인쿼리를 실행하고,
--                  반환값이 없으면 메인쿼리를 실행하지 않음.
-- ------------------------------------------------------
-- * Please refer to the chapter 06, page 10.
-- ------------------------------------------------------

-- ------------------------------------------------------
-- (1) IN 연산자 사용한 복수행 서브쿼리
-- ------------------------------------------------------
--  가. 서브쿼리 반환값이 복수 개.
--  나. 메인쿼리와 동등비교연산자(=) 방식으로 비교할 때 사용.
-- ------------------------------------------------------

-- 'Whalen' or 'Fay'와 동일한 월급여를 받는 사원조회
SELECT
    last_name,
    salary
FROM
    employees
WHERE
    -- 메인쿼리: 복수행 서브쿼리가 사용되었으므로, 복수 값과 연산가능한 연산자 사용가능 (IN)
    salary IN (

    -- 복수행에 단일행 연산자 사용한 경우:
    --  ORA-01427: single-row subquery returns more than one row
    -- salary = (

        -- 복수 행 비상관 서브쿼리: 'Whalen' 와 'Fay' 월급여 반환
        -- 메인쿼리로 결과값 전달
        SELECT
            salary
        FROM
            employees
        WHERE
            last_name IN ('Whalen', 'Fay')

    );


-- 월급여를 13000 보다 많이 받는 부서에 속한 모든 사원 조회
SELECT
    last_name,
    department_id,
    salary
FROM
    employees
WHERE
    -- 메인쿼리: 복수행 서브쿼리가 사용되었으므로, 복수 값과 연산가능한 연산자 사용가능 (IN)
    department_id IN (

        -- 복수 행 비상관 서브쿼리: 월급여 > 13000인 사원목록 반환
        -- 메인쿼리로 결과값 전달
        SELECT
            department_id
        FROM
            employees
        WHERE
            salary > 13000

    );


-- ------------------------------------------------------
-- (2) ALL 연산자 사용한 복수행 서브쿼리
-- ------------------------------------------------------
--  가. 서브쿼리 반환값이 복수 개.
--  나. 메인쿼리에서, < or > 같은 비교연산자 사용하고자 할 때 사용.
--  다. 메인쿼리의 비교연산자는 단일 행 연산자이기 때문에,
--      메인쿼리의 복수행 연산자에 ALL 키워드 없이 사용하면 오류발생.
--  라. ALL 연산자:
--      서브쿼리에서 반환된 전체 행들에 대해서, 조건이 모두(all)
--      만족해야 된다는 것을 의미.
--  마. 구분:
--      (1) > ALL (서브쿼리)
--          - 서브쿼리에서 반환된 모든 데이터보다 큰 데이터 조회
--          - 결국, 서브쿼리에서 반환된 모든 데이터 중,
--            *최대값보다 큰* 데이터 조회
--
--      (2) < ALL (서브쿼리)
--          - 서브쿼리에서 반환된 모든 데이터보다 작은 데이터 조회
--          - 결국, 서브쿼리에서 반환된 모든 데이터 중, 
--            *최소값보다 작은* 데이터 조회
-- ------------------------------------------------------

-- 직책이 IT_PROG인 사원 월급 조회
SELECT
    salary
FROM
    employees
WHERE
    job_id = 'IT_PROG'
ORDER BY
    1 ASC;


-- 직책이 IT_PROG인 사원의 월급보다 *작은* 사원 정보 조회
SELECT
    last_name,
    department_id,
    salary
FROM
    employees
WHERE
    -- 메인쿼리1: 복수행 서브쿼리가 사용되었으므로, 복수 값과 연산가능한 연산자 사용가능.
    --
    -- 아래조건은, 단일 값 연산자인 비교연산자(<) 사용 --> *오류발생*
    -- 왜? 오라클 입장에서는, 여러 월급 중에서, 과연 어떤 월급보다 작아야 하는지
    -- 판단할 수 없기 때문.
    -- ORA-01427: single-row subquery returns more than one row
    -- salary < (

    -- 메인쿼리2: 복수행 서브쿼리가 사용되었으므로, 복수 값과 연산가능한 연산자 사용가능.
    --
    -- 아래조건은, 단일값 연산자인 비교연산자(<) 사용 --> *오류발생* 가능하나,
    -- 오라클이 반환된 여러 월급 중에서, 가장 작은(최소 급여) 급여를 기준으로,
    -- 메인쿼리 조건을 수행가능하도록 ALL 키워드 적용.
    --
    -- 결과적으로, 복수행 서브쿼리가 반환한 모든 값 중, *최소값 보다 작은* 사원 필터링
    salary < ALL (

        -- 복수 행 비상관 서브쿼리: 직책이 IT_PROG인 사원의 월급 반환
        -- 메인쿼리로 결과값 전달
        SELECT
            salary
        FROM
            employees
        WHERE
            job_id = 'IT_PROG'

    );


-- 직책이 IT_PROG인 사원의 월급보다 *많은* 사원 정보 조회
SELECT
    last_name,
    department_id,
    salary
FROM
    employees
WHERE
    -- 메인쿼리: 복수행 서브쿼리가 사용되었으므로, 복수 값과 연산가능한 연산자 사용가능.
    --
    -- 아래조건은, 단일값 연산자인 비교연산자(>) 사용 --> *오류발생* 가능하나,
    -- 오라클이 반환된 여러 월급 중에서, 가장 큰(최대 급여) 급여를 기준으로,
    -- 메인쿼리 조건을 수행가능하도록 ALL 키워드 적용
    --
    -- 결과적으로, 복수행 서브쿼리가 반환한 모든 값 중, *최대값 보다 큰* 사원 필터링
    salary > ALL (

        -- 복수 행 비상관 서브쿼리: 직책이 IT_PROG인 사원의 월급 반환
        -- 메인쿼리로 결과값 전달
        SELECT
            salary
        FROM
            employees
        WHERE
            job_id = 'IT_PROG'

    );


-- ------------------------------------------------------
-- (3) ANY 연산자 사용한 복수행 서브쿼리
-- ------------------------------------------------------
--  가. 서브쿼리 반환값이 복수 개.
--  나. 서브쿼리에서, < or > 같은 비교연산자 사용하고자 할 때 사용.
--  다. 메인쿼리의 비교연산자는 단일 행 연산자이기 때문에,
--      메인쿼리의 단일행 연산자에 ANY 키워드 없이 사용하면 오류발생.
--  라. ANY 연산자:
--      서브쿼리에서 반환된 전체 행들에 대해서, 조건이 하나라도(any)
--      만족해야 된다는 것을 의미.
--  마. 구분:
--      (1) > ANY (서브쿼리)
--          - 서브쿼리에서 반환된 모든 데이터보다 큰 데이터 조회
--          - 결국, 서브쿼리에서 반환된 모든 데이터 중,
--            *최소값보다 큰* 데이터 조회
--
--      (2) < ANY (서브쿼리)
--          - 서브쿼리에서 반환된 모든 데이터보다 작은 데이터 조회
--          - 결국, 서브쿼리에서 반환된 모든 데이터 중, 
--            *최대값보다 작은* 데이터 조회
-- ------------------------------------------------------

-- 직책이 IT_PROG인 사원의 *최소 월급여보다 큰* 사원 정보 조회
SELECT
    last_name,
    department_id,
    salary
FROM
    employees
WHERE
    -- 메인쿼리: 복수행 서브쿼리가 사용되었으므로, 복수 값과 연산가능한 연산자 사용가능.
    --
    -- 아래조건은, 단일값 연산자인 비교연산자(>) 사용 --> *오류발생* 가능하나,
    -- 오라클이 반환된 여러 월급 중에서, 가장 작은(최소 급여) 급여를 기준으로,
    -- 메인쿼리 조건을 수행가능하도록 ANY 키워드 적용
    -- 
    -- 결과적으로, 복수행 서브쿼리가 반환한 모든 값 중, *최소값 보다 큰* 사원 필터링
    salary > ANY (

        -- 복수 행 비상관 서브쿼리: 직책이 IT_PROG인 사원의 월급 반환
        -- 메인쿼리로 결과값 전달
        SELECT
            salary
        FROM
            employees
        WHERE
            job_id = 'IT_PROG'

    );


-- 직책이 IT_PROG인 사원의 *최대 월급여보다 작은* 사원 정보 조회
SELECT
    last_name,
    department_id,
    salary
FROM
    employees
WHERE
    -- 메인쿼리: 복수행 서브쿼리가 사용되었으므로, 복수 값과 연산가능한 연산자 사용가능.
    --
    -- 아래조건은, 단일값 연산자인 비교연산자(<) 사용 --> *오류발생* 가능하나,
    -- 오라클이 반환된 여러 월급 중에서, 가장 큰(최대 급여) 급여를 기준으로,
    -- 메인쿼리 조건을 수행가능하도록 ANY 키워드 적용
    --
    -- 결과적으로, 복수행 서브쿼리가 반환한 모든 값 중, *최대값 보다 작은* 사원 필터링
    salary < ANY (

        -- 복수 행 비상관 서브쿼리: 직책이 IT_PROG인 사원의 월급 반환
        -- 메인쿼리로 결과값 전달
        SELECT
            salary
        FROM
            employees
        WHERE
            job_id = 'IT_PROG'

    );


-- ------------------------------------------------------
-- (4) EXISTS 연산자 사용한 복수행 서브쿼리
-- ------------------------------------------------------
--  가. 서브쿼리 반환값이 복수 개.
--  나. 메인쿼리의 값이, 서브쿼리에서 반환된 결과 중에 하나라도
--      존재하는지 여부를 확인할 때 사용하는 복수행 연산자.
--  다. 만일, 서브쿼리의 반환결과가 하나라도 없으면(false),
--      메인쿼리를 수행하지 않음.
--  라. 만일, 서브쿼리의 반환결과가 하나라도 있으면(true),
--      메인쿼리를 수행.
-- ------------------------------------------------------

SELECT
    last_name,
    department_id,
    salary,
    commission_pct
FROM
    employees
WHERE
    -- 메인쿼리: 복수행 서브쿼리가 사용되었으므로, 복수값과 연산가능한 연산자 사용가능.
    --          복수행 연산자로 EXISTS 사용
    --
    -- 모든 사원조회 (if 커밋션을 받는 사원이 한명이라도 있다면...)
    EXISTS (

        -- 복수행 비상관 서브쿼리: 커밋션을 받는 사원번호 반환
        -- 메인쿼리로 결과값 전달
        SELECT
            employee_id
        FROM
            employees
        WHERE
            commission_pct IS NOT NULL

    );


SELECT
    last_name,
    department_id,
    salary
FROM
    employees
WHERE
    -- 모든 사원조회 (if 5000000보다 큰 월급여를 받는 사원이 한명이라도 있다면...)
    EXISTS (
        
        -- 복수 행 비상관 서브쿼리: 월급여가 500000보다 큰 사원번호 반환 (*없음*)
        -- 메인쿼리로 결과값 전달(하나도 조회된 결과가 없으므로, false가 전달)
        SELECT
            employee_id
        FROM
            employees
        WHERE
            salary > 500000

    );