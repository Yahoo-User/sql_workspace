-- sample6.sql


-- ------------------------------------------------------
-- 6. Sub-program (서브 프로그램)
-- ------------------------------------------------------
--  가. 이전까지의 PL/SQL block 은 이름이 없는, "익명블록".
--      (Anonymous Block)
--  나. 익명블록은, 실행 때마다, 항상 컴파일(Compile) 수행해야 됨
--  다. 이름이 없기 때문에, 영구저장 불가 그리고 재사용 불가
--  라. 주기적으로 사용하는 로직이 필요한 경우, "익명블록"으로
--      처리하는 것은, 매우 비효율적임
--  마. Oracle 은 테이블이나 뷰와 같이, DB에 객체로 저장하여,
--      필요할 때마다, 호출하여 사용가능한 PL/SQL block 제공
--      이를, "서브프로그램(Sub-program)" 이라고 함
--  바. 파라미터(매개변수) 사용가능
--  사. Oracle SQL*PLUS 같은 tool에서, 호출가능한 PL/SQL block
--  아. 재사용성이 뛰어남
--  자. 종류(2가지):
--      (1) 프로시저(Procedure)
--          a. 일반적으로 특정 작업을 수행 (반환값 없음)
--          b. 보통 임의의 특정 로직을 처리하기만 함
--      (2) 함수(Function)
--          a. 일반적으로 값을 계산하여 반환 (반환값 있음)
--          b. 어떤 로직을 처리하고 처리결과 반환
--          c. SQL 표준함수처럼, SELECT절이나 WHERE절과 같이,
--             SQL 문장 내에서 사용가능 (***)
--  차. 프로시저와 함수의 가장 큰 차이점 -> 반환값의 존재여부
-- ------------------------------------------------------


-- ------------------------------------------------------
-- 6-1. 프로시저(Procedure)
-- ------------------------------------------------------
--  가. 특정 작업을 수행하는, 일종의 서브프로그램(Sub-program)
--  나. DB에 저장되는 Oracle 객체 -> 
--          "내장 프로시저" (Stored Procedure) 라고도 함
--  다. 반복적인 호출 가능
--  라. 실행될 때마다, 별도의 컴파일(compile) 작업 필요없음(***)
--  마. 복잡한 DML 문장들을 필요할 때마다, 매번 작성/실행하지 않고,
--      프로시저에 저장 후, 필요시 호출을 통해 간단하게 실행가능
--  바. 실무에서 많이 사용
-- ------------------------------------------------------
-- Basic syntax: Procedure_creation_syntax.JPG
--
--  a. CREATE PROCEDURE 문: 프로시저 생성
--  b. OR REPLACE : 기존 프로시저 수정(변경)하고자 한는 경우
--      기존 프로시저를 삭제 후/다시 생성
--  c. 파라미터(매개변수): 프로시저 실행 때,
--      호출환경과 프로시저 간에 서로 주고 받는 값 의미
--  d. 파라미터(매개변수)의 3가지 모드(mode):
--      (1) In  (2) OUT  (3) IN OUT
--  e. 3가지 파라미터(매개변수) 의미:
--      Parameter_modes.JPG
--  f. 호출환경과 파라미터 mode:
--      CallEnv_and_ParameterMode.JPG
--  g. 파라미터의 자료형:
--      크기는 지정하지 않고, 자료형만 지정
--  h. 프로시저의 실행(호출) 문법:
--      Procedure_call_syntax.JPG
--
--      EXEC 키워드 사용하여 프로시저 실행 및
--      파라미터에 값 전달(전달인자)도 가능
-- ------------------------------------------------------

-- ------------------------------------------------------
-- 예제1: 'Procedure Test' 문자출력 프로시저
-- ------------------------------------------------------

-- 1. my_test 프로시저 객체 생성
-- ------------------------------------------------------
--    익명블록과의 차이점: 프로시저 이름 지정 및 객체로 생성하여
--                       언제든지 재사용 가능
CREATE OR REPLACE PROCEDURE my_test
IS
BEGIN       -- 실행부(Execution section) 시작

    DBMS_OUTPUT.put_line('Procedure Test');

END;    -- 실행부 끝, PL/SQL Block 의 끝은, 세미콜론(;)으로 마감처리(**주의**)


-- 2. 프로시저 실행 (Oracle SQL*Developer or SQL*Plus 에서 실행)
-- ------------------------------------------------------
--      EXEC(UTE) my_test;
--      EXEC(UTE) my_test();    -- 파라미터가 없어도 가능
--
--      반복적인 실행 가능

-- DBMS_OUTPUT.put_line() 함수의 출력 설정
SET SERVEROUTPUT ON;


EXEC my_test;           -- OK


EXEC my_test();         -- OK


-- PLS-00306: wrong number or types of arguments in call to 'MY_TEST'
EXEC my_test(1);        -- XX


-- ------------------------------------------------------
-- 예제2: 임의의 사원번호를 전달받아, 해당 사원의 급여를 110%
--        인상하는 프로시저의 작성 및 실행
-- ------------------------------------------------------

-- 1. 급여인상 프로시저 생성
-- ------------------------------------------------------
CREATE OR REPLACE PROCEDURE raise_salary (

    -- 파라미터 선언(자료형만 지정)
    --  실행(호출)시, 전달받은 사원번호 저장용 IN 매개변수
    --  자료형은 %TYPE 형을 사용, emp 테이블의 empno 컬럼 데이터 참조
    p_empno IN emp.empno%TYPE   -- IN 파라미터 선언: %TYPE 형 사용

) IS
BEGIN       -- 실행부(Execution section) 시작

    DBMS_OUTPUT.put_line('- p_empno: ' || p_empno);


    UPDATE emp
    SET
        sal = sal * 1.1         -- 110% 인상 급여로 수정
    WHERE
        empno = p_empno;      -- 전달받은 사원번호로 사원급여 수정


    -- TCL : Transaction Control Language
    COMMIT;                     -- 변경내역 영구 저장

    
    -- 묵시적 커서속성 사용하여, 급여가 수정된 사원 수 출력
    -- 묵시적 커서속성: Implicit_cursor_attrs.JPG
    DBMS_OUTPUT.put_line('- Affected rows: ' || SQL%ROWCOUNT);

END;    -- 실행부 끝, PL/SQL Block 의 끝은, 세미콜론(;)으로 마감처리(**주의**)


-- 2. 급여인상 프로시저 실행 (Oracle SQL*Developer or SQL*Plus 에서 실행)
-- ------------------------------------------------------
SELECT
    empno,
    sal
FROM
    emp;


-- DBMS_OUTPUT.put_line() 함수의 출력 설정
SET SERVEROUTPUT ON;


-- PLS-00103: Encountered the symbol "end-of-file" when expecting one of the following
EXEC raise_salary;          -- XX

-- PLS-00103: Encountered the symbol "end-of-file" when expecting one of the following
EXEC raise_salary();        -- XX


EXEC raise_salary(7900);    -- OK


SELECT
    empno,
    sal
FROM
    emp;


-- ------------------------------------------------------
-- 예제3: 구구단 프로시저 생성. 특정 단수 전달하여 구구단 결과출력
-- ------------------------------------------------------

-- 1. 구구단 프로시저 생성
-- ------------------------------------------------------
CREATE OR REPLACE PROCEDURE gugudan (
    
    -- 파라미터 선언 (mode 를 지정하지 않았음 -> 기본모드)
    --  각 파라미터의 자료형은 지정하되, 크기는 지정하지 않음(***)
    p_dansu NUMBER          -- default mode: IN

) IS
BEGIN       -- 실행부(Execution section) 시작

    DBMS_OUTPUT.put_line('- p_dansu: ' || p_dansu || chr(10));


    -- FOR LOOP 만복문 사용
    FOR i IN 1..9 LOOP

        DBMS_OUTPUT.put_line( p_dansu || ' x ' || i || ' = ' || p_dansu * i );

    END LOOP;

END;    -- 실행부 끝, PL/SQL Block 의 끝은, 세미콜론(;)으로 마감처리(**주의**)


-- 2. 구구단 프로시저 실행 (Oracle SQL*Developer or SQL*Plus 에서 실행)
-- ------------------------------------------------------

-- DBMS_OUTPUT.put_line() 함수의 출력 설정
SET SERVEROUTPUT ON;


-- PLS-00103: Encountered the symbol "end-of-file" when expecting one of the following
EXEC gugudan;       -- XX

-- PLS-00103: Encountered the symbol "end-of-file" when expecting one of the following
EXEC gugudan();     -- XX


EXEC gugudan(3);    -- OK


-- ------------------------------------------------------
-- 예제4: 전달한 전화번호의 포매팅 결과 반환
--       01033334444 전달 -> (010)3333-4444로 포매팅/반환
--       12345678901
-- ------------------------------------------------------

-- 1. 프로시저 생성
-- ------------------------------------------------------
CREATE OR REPLACE PROCEDURE format_phone (
    
    -- 각 파라미터의 자료형은 지정하되, 크기는 지정하지 않음(***)

    -- 파라미터 선언 (IN OUT (입/출력)모드로 지정):
    --  a. 전화번호를 변수로 전달받을 때에는, IN 모드로 사용되고
    --  b. 변수를 호출환경으로 반환할 때에는, OUT 모드로 사용됨
    -- p_phone_no IN VARCHAR2
    p_phone_no IN OUT VARCHAR2

) IS
BEGIN       -- 실행부(Execution section) 시작

    DBMS_OUTPUT.put_line('- p_phone_no: ' || p_phone_no);


    -- 입출력 파라미터(매개변수)인 p_phone_no 변수에 값 저장
    -- substr(string, offset, length): 문자열에서 offset 인덱스 ~ 지정길이의 부분 문자열 반환

    -- if p_phone_no parameter is IN mode,
    --      PLS-00363: expression 'P_PHONE_NO' cannot be used as an assignment target

    p_phone_no := '(' || 
                    substr(p_phone_no, 1, 3) || ')' || 
                    substr(p_phone_no, 4, 4) || '-' || 
                    substr(p_phone_no, 7);

END;    -- 실행부 끝, PL/SQL Block 의 끝은, 세미콜론(;)으로 마감처리(**주의**)


-- 2. "바인드변수"의 선언 (호출환경에서 선언)
-- ------------------------------------------------------
--  a. 프로시저의 파라미터를 OUT 모드로 사용하기 위해 필요 (***)
--  b. "바인드변수" 라 부르는, 변수선언이 필요
--  c. 임의의 값을, 동적으로 저장할 때 사용
--  d. 프로시저의 실행결과를 반환받음
--  e. 프로시저의 IN 파라미터에 값을 전달하고,
--     프로시저의 OUT 파라미터의 값을 전달받는 용도로 사용(***)
-- ------------------------------------------------------
-- Oracle SQL*Developer or SQL*Plus 에서 실행
-- ------------------------------------------------------

-- DBMS_OUTPUT.put_line() 함수의 출력 설정
SET SERVEROUTPUT ON


-- To declare a bind variable with the command, 'VARIABLE'
-- VAR[IABLE] [ <variable> [ 
--      NUMBER | CHAR | CHAR (n [CHAR|BYTE]) |
--      VARCHAR2 (n [CHAR|BYTE]) | NCHAR | NCHAR (n) |
--      NVARCHAR2 (n) | CLOB | NCLOB | BLOB | BFILE
--      REFCURSOR | BINARY_FLOAT | BINARY_DOUBLE ] ]

VARIABLE g_phone_no VARCHAR2;   -- To declare a bind variable.


VARIABLE;   -- To show the list of all the bind variables 
            -- that you have declared in your session.

PRINT;      -- To dislay the current values of all the bind variables 
            -- with their names in the session.

-- To show the definition of any bind variable created in the session. 
-- By definition, the data type and data width of the variable.
VARIABLE g_phone_no;


EXEC :g_phone_no := '01033334444';   -- To initialize the Bind Variable.



-- 3. 프로시저 실행
-- ------------------------------------------------------
-- Oracle SQL*Developer or SQL*Plus 에서 실행
-- ------------------------------------------------------

EXEC format_phone(:g_phone_no);

PRINT;
PRINT g_phone_no;
PRINT :g_phone_no;



-- ------------------------------------------------------
-- 6-2. 프로시저 데이터 사전: USER_SOURCE
-- ------------------------------------------------------
DESC user_source;

SELECT name, text
FROM user_source;



-- ------------------------------------------------------
-- 6-3. 프로시저 삭제
-- ------------------------------------------------------
--  DROP PROCEDURE 문 사용
-- ------------------------------------------------------
-- Basic syntax: Drop_procedure_syntax.JPG
-- ------------------------------------------------------

DROP PROCEDURE my_test;
DROP PROCEDURE raise_salary;
DROP PROCEDURE gugudan;
DROP PROCEDURE format_phone;


