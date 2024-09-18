-- sample5.sql


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
-- 5. 인라인 뷰(Inline View)
-- ------------------------------------------------------
--  가. 뷰(View) : 실제 존재하지 않는 가상의 테이블이라 할 수 있음
--  나. FROM 절에 사용된 서브쿼리를 의미
--  다. 동작방식이 뷰(View)와 비슷하여 붙여진 이름
--  라. 일반적으로, FROM 절에는 테이블이 와야 하지만, 서브쿼리가
--      마치 하나의 가상의 테이블처럼 사용가능
--  마. 장점:
--      실제로 FROM 절에서 참조하는 테이블의 크기가 클 경우에,
--      필요한 행과 컬럼만으로 구성된 집합(Set)을 재정의하여,
--      쿼리를 효율적으로 구성가능.
-- ------------------------------------------------------
-- Basic Syntax)
--
--  SELECT select_list
--  FROM ( sub-query ) alias
--  [ WHERE 조건식 ];
-- ------------------------------------------------------
-- * Please refer to the chapter 06, page 22.
-- ------------------------------------------------------

-- 각 부서별, 총 사원수 / 월급여 총계 / 월급여 평균 조회
-- Oracle Inner Join( Equal Join ) 사용방식
SELECT
    e.department_id,
    sum(salary) AS 총합,
    avg(salary) AS 평균,
    count(*) AS 인원수
FROM
    -- CROSS JOIN(== Cartesian Product) Size: 107 x 27 = 2,889
    employees e,
    departments d
WHERE
    e.department_id = d.department_id
GROUP BY
    e.department_id
ORDER BY
    1 ASC;


-- 위 조인 쿼리를, 좀 더 효율적으로 수행가능한 형식으로 변경
-- 인라인 뷰(Inline View) 사용
SELECT
    e.department_id,
    총합,
    평균,
    인원수
FROM
    -- CROSS JOIN(== Cartesian Product) Size: 12 x 27 = 324
    
    (   -- 인라인 뷰(Inline View) 크기: 12
        SELECT
            department_id,
            sum(salary) AS 총합,
            avg(salary) AS 평균,
            count(*) AS 인원수
        FROM
            employees
        GROUP BY
            department_id
    ) e,
    departments d   -- 부서크기: 27
WHERE
    e.department_id = d.department_id       -- 조인조건(공통컬럼지정)
ORDER By
    1 ASC;