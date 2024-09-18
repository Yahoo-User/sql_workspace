-- sample1.sql


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
-- 1. 단일(행) (반환)함수
-- ------------------------------------------------------
-- 단일(행) (반환)함수의 구분:
--
--  (1) 문자 (처리)함수 : 문자와 관련된 특별한 조작을 위한 함수
--      a. INITCAP  - 첫글자만 대문자로 변경
--      b. UPPER    - 모든 글자를 대문자로 변경 
--      c. LOWER    - 모든 글자를 소문자로 변경
--      d. CONCAT   - 두 문자열 연결
--      e. LENGTH   - 문자열의 길이 반환
--      f. INSTR    - 문자열에서, 특정 문자열의 위치(인덱스) 반환
--      g. SUBSTR   - 문자열에서, 부분문자열(substring) 반환
--      h. REPLACE  - 문자열 치환(replace)
--      i. LPAD     - 문자열 오른쪽 정렬 후, 왼쪽의 빈 공간에 지정문자 채우기(padding)
--      j. RPAD     - 문자열 왼쪽 정렬 후, 오른쪽의 빈 공간에 지정문자 채우기(padding)
--      k. LTRIM    - 문자열의 왼쪽에서, 지정문자 삭제(trim)
--      l. RTRIM    - 문자열의 오른쪽에서, 지정문자 삭제(trim)
--      m. TRIM     - 문자열의 왼쪽/오른쪽/양쪽에서, 지정문자 삭제(trim)
--                    (단, 문자열의 중간은 처리못함)
--  (2) 숫자 (처리)함수 : 
--  (3) 날짜 (처리)함수
--  (4) 변환 (처리)함수
--  (5) 일반 (처리)함수
--
--  단일(행) (반환)함수는, 테이블의 행 단위로 처리됨!
-- ------------------------------------------------------

-- ------------------------------------------------------
-- (1) 문자(처리) 함수 - INITCAP
-- ------------------------------------------------------
--     첫글자만 대문자로 변경
-- ------------------------------------------------------
SELECT
   'ORACLE SQL',
   initcap('ORACLE SQL')
FROM
   dual;


SELECT
   email,
   initcap(email)
FROM
   employees;


-- ------------------------------------------------------
-- (2) 문자(처리) 함수 - UPPER
-- ------------------------------------------------------
--     모든 글자를 대문자로 변경
-- ------------------------------------------------------
SELECT
   'Oracle Sql',
   upper('Oracle Sql')
FROM
   dual;


SELECT
   last_name,
   upper(last_name)
FROM
   employees;


SELECT
   last_name,
   salary
FROM
   employees
-- WHERE
--    upper(last_name) = 'KING';    -- *Decommendation*  : The index with the column cannot be used.
WHERE
   last_name = initcap('KING');  -- *Recommendation*  : The index with the column can be used.

  


-- ------------------------------------------------------
-- (3) 문자(처리) 함수 - LOWER
-- ------------------------------------------------------
--     모든 글자를 소문자로 변경
-- ------------------------------------------------------
SELECT
   'Oracle Sql',
   lower('Oracle Sql')
FROM
   dual;


SELECT
   last_name,
   lower(last_name)
FROM
   employees;


-- ------------------------------------------------------
-- (4) 문자(처리) 함수 - CONCAT
-- ------------------------------------------------------
--     두 문자열 연결(Concatenation)
-- ------------------------------------------------------
SELECT
   -- || (Concatenation Operator) == concat function
   'Oracle' || 'Sql',
   concat('Oracle', 'Sql')
-- SELECT
--    -- || (Concatenation Operator) == concat function
--    'Oracle' || 'Sql' || 'third', 
--    concat( concat('Oracle', 'Sql'), 'third')
FROM
   dual;


SELECT
   -- || (Concatenation Operator) == concat function
   last_name || salary,
   concat(last_name, salary)
FROM
   employees;


SELECT
   -- || (Concatenation Operator) == concat function
   last_name || hire_date,
   concat(last_name, hire_date)
FROM
   employees;


-- ------------------------------------------------------
-- (5) 문자(처리) 함수 - LENGTH
-- ------------------------------------------------------
--     문자열의 길이 반환
-- ------------------------------------------------------
--  A. LENGTH   returns Characters
--  B. LENGTHB  returns Bytes
--  C. LENGTHC  returns unicode characters
--  D. LENGTH2  returns Code units
--  E. LENGTH4  returns Code points
-- ------------------------------------------------------
SELECT
   'Oracle',
   length('Oracle')
FROM
   dual;


SELECT
   last_name,
   length(last_name)
FROM
   employees;


SELECT
   unistr('X'),
   lengthb( unistr('X') ) AS lengthb,
   lengthc( unistr('X') ) AS lengthc,
   lengthb('X') AS lengthXC,
   lengthc('X') AS lengthXB
FROM
   dual;


SELECT
    '한글',
    length('한글')   AS length,
    lengthb('한글')  AS lengthb,
    lengthc('한글')  AS lengthc,
    length2('한글')  AS length2,
    length4('한글')  AS length4
FROM
   dual;


SELECT
    unistr('한글'),
    length( unistr('한글') )    AS length,
    lengthb( unistr('한글') )   AS lengthb,
    lengthc( unistr('한글') )   AS lengthc,
    length2( unistr('한글') )   AS length2,
    length4( unistr('한글') )   AS length4
FROM
   dual;


SELECT
   substr(table_name, 1, 20) AS tablename,
   length(table_name),
   length2(table_name),
   length4(table_name)
FROM
   user_tables
WHERE
   rownum < 10;


-- ------------------------------------------------------
-- (6) 문자(처리) 함수 - INSTR
-- ------------------------------------------------------
--     문자열에서, 특정 문자열의 (시작)위치(시작 인덱스) 반환
-- ------------------------------------------------------
-- 주의) Oracle 의 인덱스 번호는 1부터 시작함!!!
-- ------------------------------------------------------
SELECT
   instr('MILLER', 'L', 1, 2),   -- 1: offset, 2: occurence
   instr('MILLER', 'X', 1, 2)    -- 1: offset, 2: occurence
FROM
   dual;


-- ------------------------------------------------------
-- (7) 문자(처리) 함수 - SUBSTR
-- ------------------------------------------------------
--     문자열에서, 부분문자열(substring) 반환
-- ------------------------------------------------------
-- 주의) Oracle 의 인덱스 번호는 1부터 시작함!!!
-- ------------------------------------------------------
SELECT
   substr('123456-1234567', 8, 1)
FROM
   dual;


-- In the Oracle SQL*Developer
-- SELECT
--    hire_date AS 입사일,
--    substr(hire_date, 1, 2) AS 입사년도

-- In the Visual Source Code
SELECT
   to_char(hire_date) AS 입사일, 
   substr( to_char(hire_date), 8, 2 ) AS 입사년도
FROM
   employees;


SELECT
   '900303-1234567',
   substr('900303-1234567', 8)
FROM
   dual;


-- 그런데, offset index를 음수를 사용할 수 있다면????ㅠ
SELECT
   '900303-1234567',
   substr('900303-1234567', -7)
FROM
   dual;


-- ------------------------------------------------------
-- (8) 문자(처리) 함수 - REPLACE
-- ------------------------------------------------------
--     문자열 치환(replace)
-- ------------------------------------------------------
SELECT
   replace('JACK and JUE', 'J', 'BL')
FROM
   dual;


-- ------------------------------------------------------
-- (9) 문자(처리) 함수 - LPAD
-- ------------------------------------------------------
--      문자열 오른쪽 정렬 후, 
--      왼쪽의 빈 공간에 지정문자 채우기(padding)
-- ------------------------------------------------------
SELECT
   lpad('MILLER', 10, '*')
FROM
   dual;


-- ------------------------------------------------------
-- (10) 문자(처리) 함수 - RPAD
-- ------------------------------------------------------
--      문자열 왼쪽 정렬 후, 
--      오른쪽의 빈 공간에 지정문자 채우기(padding)
-- ------------------------------------------------------
SELECT
   rpad('MILLER', 10, '*')
FROM
   dual;


SELECT
   substr('900303-1234567', 1, 8) || '******' AS 주민번호
FROM
   dual;


SELECT
   rpad(
      substr('900303-1234567', 1, 8), 14, '*'
   ) AS 주민번호
FROM
   dual;


-- ------------------------------------------------------
-- (11) 문자(처리) 함수 - LTRIM
-- ------------------------------------------------------
--    문자열의 왼쪽에서, 지정문자 삭제(trim)
-- ------------------------------------------------------
SELECT
   ltrim('MMMIMLLER', 'M')
FROM
   dual;


SELECT
   ltrim(' MILLER '),
   length( ltrim(' MILLER ') )
FROM
   dual;


-- ------------------------------------------------------
-- (12) 문자(처리) 함수 - RTRIM
-- ------------------------------------------------------
--    문자열의 오른쪽에서, 지정문자 삭제(trim)
-- ------------------------------------------------------
SELECT
   rtrim('MILLRER', 'R')
FROM
   dual;


SELECT
   rtrim(' MILLER '),
   length( rtrim(' MILLER ') )
FROM
   dual;


-- ------------------------------------------------------
-- (13) 문자(처리) 함수 - TRIM
-- ------------------------------------------------------
--    문자열의 왼쪽/오른쪽/양쪽에서, 지정문자 삭제(trim)
--    (단, 문자열의 중간은 처리못함)
-- ------------------------------------------------------
-- 문법)
--    TRIM( LEADING 'str' FROM 컬럼명|표현식 )
--    TRIM( TRAILING 'str' FROM 컬럼명|표현식 )
--    TRIM( BOTH 'str' FROM 컬럼명|표현식 )
--    TRIM( 'str' FROM 컬럼명|표현식 )     -- BOTH (default)
-- ------------------------------------------------------
SELECT
   trim( '0' FROM '0001234567000' )             -- default: BOTH (양쪽에서 제거)
FROM
   dual;


SELECT
   trim( LEADING '0' FROM '0001234567000' )     -- 문자열 왼쪽에서 제거
FROM
   dual;


SELECT
   trim( TRAILING '0' FROM '0001234567000' )    -- 문자열 오른쪽에서 제거
FROM
   dual;

