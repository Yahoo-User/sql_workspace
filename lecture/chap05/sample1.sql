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
-- 0. The relationship between 
--    parent(=master) table and child(=slave) table
-- ------------------------------------------------------
-- * Please refer to Chapter05 page 2.
-- ------------------------------------------------------

-- Child(= Slave) table to refer to others.
DESC employees;


SELECT
    last_name,
    department_id
FROM
    employees
ORDER BY
    2 ASC;


-- Parent(= Master) table to be referred.
DESC departments;   


SELECT
    department_id,
    department_name
FROM
    departments
ORDER BY
    1 ASC;


-- 1. 특정 직원의 부서번호 찾아내기
SELECT
    last_name,
    department_id
FROM
    employees
WHERE
    last_name = 'Whalen';


-- 2. 찾아낸 부서번호를 이용한 부서명 조회
SELECT
    department_name
FROM
    departments
WHERE
    department_id = 10;


-- ------------------------------------------------------
-- "JOIN" : 필요한 데이터가, 여러 테이블에 분산되어 있을 경우에,
-- 여러 테이블의 공통된 컬럼을 연결시켜, 원하는 데이터를 검색하는
-- 방법을 "조인"이라 한다.
--
-- 따라서, 조인은 검색하고자 하는 컬럼이, 두개 이상의 테이블에
-- 분산되어 있는 경우에 사용된다.
-- ------------------------------------------------------
