-- sample7.sql


-- ------------------------------------------------------
-- 6-4. 함수(Function)
-- ------------------------------------------------------
--  가. SQL의 함수는, 일반적으로 Oracle 이 제공하는 함수 의미
--  나. PL/SQL에서는, 필요에 의해 생성한, 사용자정의 함수 의미
--  다. 프로시저(Procedure)와의 차이점:
--      a. 프로시저는, IN/OUT/IN OUT 모드에 따라, 동작방식 결정
--      b. 함수는 작업후에, 반드시 결과값 반환(return)
--      c. SQL문에서 표현식의 일부로, 함수 사용가능
-- ------------------------------------------------------
--  Basic syntax: Function_creation_syntax.JPG
--
--  a. CREATE FUNCTION 문: 사용자 정의함수 생성
--  b. OR REPLACE 지정: 사용자 정의함수 변경
--                      기존 함수 삭제 후, 다시 생성
--  c. 프로시저와 동일하게, 호출환경에서 함수에 전달할 파라미터
--     사용가능
--  d. RETURN 키워드: 호출환경으로 반환할, 데이터 형 지정
--     PL/SQL block 에서는, 함수의 정해진 작업을 수행하고,
--     반드시 RETURN 키워드를 사용하여 반환값 지정해야 함
--  e. (*주의*) 생성한 함수는, SQL 문에서, 표현식의 일부로 사용
--     SELECT절, WHERE절, HAVING절, UPDATE문, INSERT문 등
-- ------------------------------------------------------

-- ------------------------------------------------------
-- 예제1: 전달된 파라미터를 모두 소문자로 출력하는 함수
-- ------------------------------------------------------

-- 1. 사용자 정의함수 생성
CREATE OR REPLACE FUNCTION mylower (
    p_value VARCHAR2    -- 스칼라 매개변수 선언
)
RETURN VARCHAR2         -- 반환 타입(자료형) 선언

-- 지역변수 선언부
--  a. 반드시 변수의 길이를 지정해야 함
--  b. 변수 선언의 끝은, 세미콜론(;)으로 마감 해야함
IS  
    -- PLS-00215: String length constraints must be in range (1 .. 32767)
    l_value VARCHAR2(32767);   -- 소문자 저장 지역변수(Local variable)

BEGIN       -- 실행부(Execution section) 시작

    DBMS_OUTPUT.put_line('- p_value: ' || p_value);
    -- DBMS_OUTPUT.put_line('- lower(p_value): ' || lower(p_value));


    l_value := lower(p_value);
    DBMS_OUTPUT.put_line('- l_value: ' || l_value);


    -- 전달받은 파라미터의 값을 소문자로 변경 후,
    -- 호출환경으로 처리결과 반환
    RETURN lower(p_value);

END;    -- 실행부 끝, PL/SQL Block 의 끝은, 세미콜론(;)으로 마감처리(**주의**)


-- 2. 사용자 정의함수 호출
SELECT
    ename,
    mylower(ename)
FROM
    emp;


-- ------------------------------------------------------
-- 예제2: 두 정수의 합을 출력하는 함수
-- ------------------------------------------------------

-- 1. 사용자 정의함수 생성
CREATE OR REPLACE FUNCTION mysum (
    p_value1 NUMBER,        -- 스칼라 매개변수 선언
    p_value2 NUMBER         -- 스칼라 매개변수 선언
)
RETURN NUMBER               -- 반환 타입(자료형) 선언

-- 지역변수 선언부
--  a. 반드시 변수의 길이를 지정해야 함
--  b. 변수 선언의 끝은, 세미콜론(;)으로 마감 해야함
IS

BEGIN       -- 실행부(Execution section) 시작

    RETURN p_value1 + p_value2;     -- 두 정수의 합 반환

END;    -- 실행부 끝, PL/SQL Block 의 끝은, 세미콜론(;)으로 마감처리(**주의**)

-- 2. 사용자 정의함수 호출
SELECT
    mysum(10, 20)
FROM
    dual;


-- ------------------------------------------------------
-- 예제3: 다양한 상수를 함수로 구현
-- ------------------------------------------------------

-- 1. 사용자 정의함수 생성
-- 함수에 매개변수가 하나도 없는 경우, 함수선언과 함수사용 할 때에도, 소괄호() 생략 가능
CREATE OR REPLACE FUNCTION UNDEFINED_INT RETURN NUMBER AS BEGIN RETURN 2147483646; END;
CREATE OR REPLACE FUNCTION UNDEFINED_SHORT RETURN NUMBER AS BEGIN RETURN 32766; END;
CREATE OR REPLACE FUNCTION UNDEFINED_LONG RETURN NUMBER AS BEGIN RETURN 223372036854775806; END;
CREATE OR REPLACE FUNCTION UNDEFINED_FLOAT RETURN FLOAT AS BEGIN RETURN .4028233E38; END;

CREATE OR REPLACE FUNCTION UNDEFINED_DOUBLE RETURN BINARY_DOUBLE AS
BEGIN
    RETURN to_binary_double('1.7976931348623155E308');
END;

CREATE OR REPLACE FUNCTION UNDEFINED_STRING RETURN VARCHAR AS BEGIN RETURN '?'; END;

-- 2. 사용자 정의함수 호출
SELECT
    UNDEFINED_INT,
    UNDEFINED_INT(),

    UNDEFINED_SHORT,
    UNDEFINED_SHORT(),

    UNDEFINED_LONG,
    UNDEFINED_LONG(),

    UNDEFINED_FLOAT,
    UNDEFINED_FLOAT(),

    UNDEFINED_DOUBLE,
    UNDEFINED_DOUBLE(),

    UNDEFINED_STRING,
    UNDEFINED_STRING()
FROM
    dual;


-- ------------------------------------------------------
-- 6-5. 함수(Function) 삭제
-- ------------------------------------------------------
--  Basic syntax: Drop_function_syntax.JPG
-- ------------------------------------------------------


-- ------------------------------------------------------
-- 6-6. 함수(Function)와 프로시저(Procedure) 비교
-- ------------------------------------------------------
--  Compare_proc_func.JPG
-- ------------------------------------------------------