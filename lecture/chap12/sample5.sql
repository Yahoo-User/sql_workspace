-- sample5.sql


-- ------------------------------------------------------
-- 5. PL/SQL 예외처리 (Exception Handling)
-- ------------------------------------------------------
--  가. 예외란?
--      프로그램 실행도중, 발생되는 의도하지 않은 문제
--  나. 일반적으로, "에러" 라고 부름
--  다. 예외가 발생되면, PL/SQL 프로그램은 비정상 종료
--  라. 결국 원하는 결과값이 나오지 않을 수 있음
--  마. 예외는 언제든지 발생가능
--  바. 예외처리란?
--      a. 예외발생시, 예외가 발생된 이유를 사용자에게 알려줘야 함
--      b. 예외가 발생되면, 발생된 예외를 처리할 수 있는 코드를 제공
--  사. PL/SQL도 예외발생시, 예외처리 방법 제공
--  아. PL/SQL에서 처리가능한 예외의 종류 두가지:
--      (1) Oracle 에서 발생시키는 System Exceptions:
--          System_exceptions.JPG
--
--      (2) 사용자가 발생시키는 User-defined Exceptions
--  자. 예외처리 기본문법:
--      Exception_handling_syntax.JPG
--
--      a. WHEN 절 바로 뒤에, 예외처리할 예외이름 지정
--      b. 예외가 발생되면, 발생된 예외와 일치하는 WHEN절의
--         THEN 절 코드가 실행됨
--      c. 발생된 예외와 일치하는 WHEN절이 없으면,
--         WHEN OTHERS THEN 절이 최종적으로 수행됨
-- ------------------------------------------------------


-- ------------------------------------------------------
-- 5-1. PL/SQL 예외처리: System Exceptions
-- ------------------------------------------------------
--  가. Oracle 에서 발생시키는 예외
--  나. 시스템-정의 예외의 종류: System_exceptions.JPG
-- ------------------------------------------------------

-- ------------------------------------------------------
-- 예1: 단일 행 SELECT에서, 두 개 이상의 행을 반환하여,
--      TOO_MANY_ROWS 시스템 예외가 발생되는 경우의 예외처리
--      부서번호가 20인 사원의 사원번호 출력
-- ------------------------------------------------------
DECLARE     -- 선언부 (스칼라/참조 변수선언 부분)

    v_emp emp%ROWTYPE;  -- 참조변수 선언

BEGIN       -- 실행부(Execution section) 시작

    SELECT
        * INTO v_emp
    FROM
        emp
    WHERE
        deptno = 20;


    DBMS_OUTPUT.put_line( 'empno: ' || v_emp.empno );


    -- 예외처리부
    EXCEPTION

        -- 두개 이상의 행을 반환한 경우 발생예외 처리
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.put_line( '*** 단일 행 위배 예외(TOO_MANY_ROWS) 발생' );

        -- 기타예외 처리
        WHEN OTHERS THEN
            DBMS_OUTPUT.put_line( '*** 기타 예외발생');

END;    -- 실행부 끝, PL/SQL Block 의 끝은, 세미콜론(;)으로 마감처리(**주의**)


-- ------------------------------------------------------
-- 예2: 기본키로 설정된 컬럼값에 중복값을 저장시키는 경우
--      (DUP_VAL_ON_INDEX) 예외 처리방법
-- ------------------------------------------------------
SELECT
    *
FROM
    dept;


BEGIN       -- 실행부(Execution section) 시작

    INSERT INTO dept
    VALUES (40, '인사', '서울');


    DBMS_OUTPUT.put_line( '저장 성공' );


    -- 예외처리부
    EXCEPTION

        -- 기본키로 설정된 컬럼값에 중복값을 저장시키는 경우 발생예외 처리
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.put_line('중복 데터 저장 위배 예외발생');

        -- 기타예외 처리
        WHEN OTHERS THEN
            DBMS_OUTPUT.put_line('예외발생');

END;    -- 실행부 끝, PL/SQL Block 의 끝은, 세미콜론(;)으로 마감처리(**주의**)


-- ------------------------------------------------------
-- 5-2. PL/SQL 예외처리: User-defined Exceptions
-- ------------------------------------------------------
--  가. 사용자가 발생시키는 예외
--  나. 개발자가 직접 예외를 정의
--  다. 필요한 경우에, 명시적으로 예외를 발생시킴
--  라. 사용자가 만든 프로그램에서, 특정한 상황의 위배에 해당
--      하는 경우, 사용되는 예외처리 방법
--  마. (*주의*) 사용자가 생각한 특정상황이기 때문에,
--      Oracle은 그런 상황을 예외로 처리하지 않음
--  바. 결국, Oracle 이 예외로 인지하지 못하는 SQL문의 처리결과
--      를, 사용자가 강제적으로 예외라고 가정하여 처리하는 방법
--  사. 사용법: 3 단계 처리 수행
--      (1) 사용자 예외(User Exceptions) 정의
--          a. 변수 및 상수처럼, 반드시 선언부에 예외를 정의해야 함
--          b. 선언방법: User-defined_exception_declaration.JPG
-- 
--      (2) 사용자 예외 발생시킴
--          a. 시스템 예외인 경우, 자동으로 예외가 발생
--          b. 사용자 예외는, 특정 조건에 위해되는 경우에,
--             명시적으로 예외를 발생시켜야 함
--          c. 명시적으로 예외발생 시키는 방법 -> RAISE 구문 사용
--             Raise_user_exceptions.JPG
--
--      (3) 사용자 예외 처리
--          a. 예외가 발생되면, 정상종료를 위해, 반드시 예외처리를
--             해야 함.
--          b. 예외처리 방법은, 시스템 예외 처리와 동일
-- ------------------------------------------------------

-- ------------------------------------------------------
-- 예1: 조건에 일치하는 사원이 없는 경우, 사용자 정의 예외를
--      사용하여, 처리하는 방법
-- ------------------------------------------------------
DECLARE     -- 선언부 (스칼라/참조 변수선언 부분)

    e_invalid_deptno EXCEPTION;     -- User-defined Exception 선언

BEGIN       -- 실행부(Execution section) 시작

    UPDATE dept
    SET
        dname = 'Engineer'
    WHERE
        deptno = 99;


    -- 사용자 지정 조건 (묵시적 커서속성 사용)
    -- 묵시적 커서 속성: Implicit_cursor_attrs.JPG
    IF SQL%NOTFOUND THEN

        -- 99번 부서가 업어도, Oracle 은 예외로 처리하지 않기 때문에,
        -- 선언부에 선언한, 사용자정의 예외를 명시적으로 발생시킴
        RAISE e_invalid_deptno;     -- 강제로, 사용자정의 예외 발생시킴
    
    END IF;


    DBMS_OUTPUT.put_line( '수정 성공' );


    -- 예외처리부
    EXCEPTION

        -- 사용자정의 예외처리
        WHEN e_invalid_deptno THEN
            DBMS_OUTPUT.put_line( 'No Such deptno 예외발생' );

        -- 기타예외 처리
        WHEN OTHERS THEN
            DBMS_OUTPUT.put_line( '예외발생');

END;    -- 실행부 끝, PL/SQL Block 의 끝은, 세미콜론(;)으로 마감처리(**주의**)

