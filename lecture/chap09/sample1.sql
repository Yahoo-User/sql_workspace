-- sample1.sql


-- ------------------------------------------------------
-- 1. View
-- ------------------------------------------------------
--  가. 물리적인 테이블 or 다른 View를 기반으로 하는 논리적인 테이블
--  나. 물리적인 테이블처럼, 실제 데이터를 저장하지 않음
--  다. 사용자는 마치 진짜 테이블을 사용하는 것과 동일하게 사용
--  라. 기본테이블(Base table):
--      뷰의 기반의 되는 물리적인 테이블
--  마. 목적
--      a. 데이터를 선택적으로 보여줄 수 있음
--      b. 데이터에 대한 접근을 제한할 수 있음(접근제한)
--      c. 테이블 컬럼 중, 보안과 관련된 민감한 데이터를 가진
--         컬럼들에 대한 접근을 제한 -> 보안 강화
--      d. 검색위한 복잡한 쿼리를 단순쿼리로 변경
--         일반적으로 조인쿼리문은 복잡성을 가짐
--         매번 필요시, 같은 조인쿼리를 사용하지 않고, 뷰로 작성
-- ------------------------------------------------------
-- Basic syntax:
--
--  CREATE [OR REPLACE] VIEW 뷰이름 [ (alias1, alias2, ...) ]
--  AS
--  Sub-query
--  [ WITH CHECK OPTION [ CONSTRAINT 제약조건명 ] ]
--  [ WITH READ ONLY [ CONSTRAINT 제약조건명 ] ] ;
--
--  * (alias1, alias2, ...):
--    a. 서브쿼리가 반환한 컬럼들에 대한 별칭(Alias) 지정
--    b. 생략가능:
--       기본테이블(Base tables)의 컬럼명 또는 서브쿼리의 SELECT절의 컬럼별칭 사용
--  * Sub-query:
--    a. Join, Set, Complicated DQL문장 등의 정의 가능
--    b. 정렬을 위한 ORDER BY 절은 사용불가 (정말??)
--    c. 정렬 필요시, View 이용 검색쿼리에서 기술해야 함 (정말??)
--  * View 의 수정:
--    a. 테이블처럼, ALTER 문을 사용하지 않음
--    b. 새로운 View를 재생성하여, 기존 View를 덮어쓰는 방식으로 처리
--    c. CREATE OR REPLACE 명령 사용
--       기존 View가 존재하면 덮어쓰고, 없으면 새로이 생성 의미
--  * WITH READ ONLY 제약조건
--    a. Read-only mode (읽기전용) 모드로 변경
--    b. View 데이터에 대한 DML 작업불가
--  * WITH CHECK OPTION 제약조건
--    a. 특정 조건과 일치해야 동작하게 함
-- ------------------------------------------------------


-- ------------------------------------------------------
-- 1-1. View 가 필요한 이유 예시
-- ------------------------------------------------------

-- (1) 20번 부서에 속한 사원들의 정보검색을 위한 복잡한 Join 쿼리문
--     매번 사원정보 검색을 위해, 아래의 Join 쿼리를 수행해야 함
SELECT
    empno,
    ename,
    d.dname,
    d.deptno
FROM
    emp e JOIN dept d
    ON e.deptno = d.deptno
WHERE
    e.deptno = 20;


-- (2) View 는 위의 복잡한 쿼리를, 매우 단순한 SQL문으로 처리할 수
--     있도록 지원 (위의 Join쿼리를 View로 정의)

-- CREATE VIEW 권한 필요
-- 현재의 SCOTT 계정은 View를 생성할 권한이 없음 -> 관리자가 권한을 부여해야 함
-- ORA-01031: insufficient privileges
CREATE VIEW emp_view AS
SELECT
    empno,
    ename,
    d.dname,
    d.deptno
FROM
    emp e JOIN dept d
    ON e.deptno = d.deptno
WHERE
    e.deptno = 20;


-- CREATE VIEW 시스템 권한 부여 (by SYSDBA)
-- GRANT <부여할 시스템 권한명> TO <권한을 부여할 계정명>
GRANT CREATE VIEW TO scott;     -- SCOTT사용자에게 권한 할당

-- ------------------------------------------------------

-- CREATE VIEW 시스템 권한 할당받은 후, View 생성 재시도
-- View 생성시, 컬럼별칭(Alias)를 사용하지 않으면, 
-- 기본테이블(Base tables)의 컬럼명 또는 서브쿼리의 SELECT절에 사용된 컬럼별칭 사용
DROP VIEW emp_view;

-- ------------------------------------------------------

CREATE VIEW emp_view AS
-- CREATE OR REPLACE VIEW emp_view AS
SELECT
    -- empno as eno,            -- OK: 컬럼별칭(column alias) 사용가능한 ?
    empno,                       -- 기본테이블(base table) 컬럼
    ename,
    d.dname,
    d.deptno
FROM
    emp e JOIN dept d
    ON e.deptno = d.deptno
WHERE
    e.deptno = 20;
-- ORDER BY                     -- OK: ORDER BY 절이 사용가능한가? Yes!!!
--     1 DESC;

-- ------------------------------------------------------

CREATE OR REPLACE VIEW emp_view (col1, col2, col3, col4) AS
SELECT
    empno as eno,            -- OK: 컬럼별칭(column alias) 사용가능? Yes!!!
    -- empno,                   -- 기본테이블(base table) 컬럼
    ename,
    d.dname,
    d.deptno
FROM
    emp e JOIN dept d
    ON e.deptno = d.deptno
WHERE
    e.deptno = 20
ORDER BY                     -- OK: ORDER BY 절이 사용가능한가? Yes!!!
    1 DESC;

-- ------------------------------------------------------

-- emp_view 뷰(view) 구조 확인
DESC emp_view;      -- 생성된 View 객체의 스키마 확인


-- emp_view 뷰(view)에서 데이터 검색
SELECT
    *
FROM
    emp_view;

-- ------------------------------------------------------

-- (3) 보안강화 : 데이터에 대한 접근제한을 위한 View
--  기본테이블(Base table)에 저장된 특정 컬럼의 데이터를 
--  보호할 목적으로 View 사용가능 (***)

--  emp 테이블에서 월급(sal) 컬럼은 민감한 정보 저장 -> 접근제한필요

CREATE VIEW emp_view2 AS
SELECT
    empno,
    ename,
    job,
    mgr,
    hiredate,
    comm,
    deptno
FROM
    emp;


-- emp_view 뷰(view) 구조 확인
DESC emp_view2;      -- 생성된 View 객체의 스키마 확인


-- emp_view2 뷰(view)에서 데이터 검색
SELECT
    *
FROM
    emp_view2;


-- ------------------------------------------------------
-- 1-2. View 객체정보 관리 데이터 딕셔너리(Data Dictionary)
-- ------------------------------------------------------
-- View 를 사용한 SELECT 문 실행시, USER_VIEWS 데이터 사전에
-- 저장된 해당 View 객체의 Sub-query 문(TEXT 컬럼)이 실행되어
-- 결과값 반환
-- ------------------------------------------------------

-- USER_VIEWS 데이터 사전
DESC user_views;


SELECT
    view_name,      -- 생성된 View의 이름
    text,           -- View 생성시 지정한 서브쿼리문 (***)
    read_only       -- 읽기전용여부(WITH READ ONLY 제약조건 적용시)
FROM
    user_views;


-- ------------------------------------------------------
-- 1-3. View 객체의 수정(ALTER)
-- ------------------------------------------------------
--  가. 테이블 객체의 수정 -> ALTER TABLE 문 사용
--  나. View 객체의 수정 -> CREATE OR REPLACE 문 사용
--      기존에 View 가 존재하면 Overwrite, 없으면 Create
--  다. 기존의 View 객체 수정시, CREATE OR REPLACE VIEW 문을 
--      사용하지 않고, CREATE VIEW 문을 사용하면 오류발생
-- ------------------------------------------------------

-- 기존 View 객체의 수정
-- CREATE VIEW emp_view2   -- ORA-00955: name is already used by an existing object
CREATE OR REPLACE VIEW emp_view2 AS    -- OK: View 객체수정
SELECT
    empno,
    ename,
    job,
    mgr,
    comm,
    deptno
FROM
    emp;


-- emp_view2 뷰(view) 구조 확인
DESC emp_view2;      -- 생성된 View 객체의 스키마 확인


-- emp_view2 뷰(view)에서 데이터 검색
SELECT
    *
FROM
    emp_view2;


-- ------------------------------------------------------
-- 1-4. View 의 종류 (2가지)
-- ------------------------------------------------------
--  가. 단순 View (= Simple View)
--      a. 하나의 기본 테이블(Base table) 에 대해 정의한 View
--      b. By defaujlt, View 에 대해 DML 문장 실행 가능
--      c. View 에 대한 DML 문장의 처리결과는,
--         실제 기본테이블(Base table)에 반영됨
--      d. 새로 생성되는 View에 대해서 별칭(Alias)를 사용하지
--         않으면, 기본테이블(Base table)의 컬럼명을 상속하거나
--         서브쿼리(Sub-query)의 SELECT절에 기술된 컬럼별칭(column alias) 상속
--  나. 복합 View (= Complex View)
--      a. 2개 이상의 기본테이블(Base table)에 대해 정의한 뷰
--      b. 2개 이상의 테이블을 Join해서 사용할 경우, 뷰로 생성
-- ------------------------------------------------------


-- ------------------------------------------------------
-- (1) Simple View 생성
-- ------------------------------------------------------

-- 20번 부서의 사원들의 정보를 가진 View 객체 생성
--
-- View 이름 뒤에, 컬럼별칭 목록을 지정하면, 지정된 별칭으로
-- View 의 컬럼명이 지정됨
-- 기본 테이블의 컬럼명을 상속받지 않고, 명시한 컬럼별칭(alias)
-- 으로 출력

CREATE VIEW emp_view3 (사원번호, 이름, 월급) AS   -- Alias 사용
SELECT
    empno,
    ename,
    sal
FROM
    emp
WHERE
    deptno = 20;


-- emp_view3 뷰(view) 구조 확인
DESC emp_view3;      -- 생성된 View 객체의 스키마 확인


-- emp_view3 뷰(view)에서 데이터 검색
SELECT
    *
FROM
    emp_view3;


-- ------------------------------------------------------
-- (1-1) 예시: 부서별 급여총합 계산 (SUM 집계함수 사용)
-- ------------------------------------------------------
-- (*주의*) View 생성시, 함수를 사용하는 경우에는 **반드시**
--          컬럼별칭(Column Alias) 를 지정하지 않으면, 오류발생
-- ------------------------------------------------------

-- SUM함수 이용한 뷰(view) 생성 에러
-- ORA-00998: must name this expression with a column alias
CREATE VIEW emp_view4 AS
SELECT
    deptno,
    sum(sal)
FROM
    emp
GROUP BY
    deptno;

-- ------------------------------------------------------

-- SUM함수의 별칭(alias) 이용한 뷰(view) 생성
CREATE VIEW emp_view4 AS
SELECT
    deptno,
    sum(sal) AS 총합
FROM
    emp
GROUP BY
    deptno;


-- emp_view4 뷰(view) 구조 확인
DESC emp_view4;      -- 생성된 View 객체의 스키마 확인


-- emp_view4 뷰(view)에서 데이터 검색
SELECT *
FROM emp_view4;


-- ------------------------------------------------------
-- (1-2) Simple View 데이터에 대한 DML 수행
-- ------------------------------------------------------
-- 가. Simple View 객체로 생성시, 데이터에 대한 DML 가능
-- 나. 실제로는 기본테이블(Base table)에 DML 변경반영
-- 다. DML 수행이 불가능한 경우: (******)
--     a. Simple View 에, 
--        GROUP BY / 집계함수 / DISTINCT 키워드가 사용된
--        경우에는, DML 변경 불가!!!! (책)
--     b. DISTINCT 키워드 사용 테스트결과 -> 
--        DML 변경가능!!!( 실제 테스트 **)
-- ------------------------------------------------------

CREATE VIEW emp_view5 AS
SELECT
    empno,
    ename,
    sal,
    deptno
FROM
    emp;


-- emp_view5 뷰(view) 구조 확인
DESC emp_view5;      -- 생성된 View 객체의 스키마 확인


-- emp_view5 뷰(view)에서 데이터 검색
SELECT
    *
FROM
    emp_view5;

-- ------------------------------------------------------

-- 단순 뷰(Simple View) 데이터에 대한 DELETE 문
DELETE FROM emp_view5
WHERE
    deptno = 10;


-- emp_view5 뷰(view)에서 데이터 검색
SELECT
    count(*)
FROM
    emp_view5
WHERE
    deptno = 10;


-- 기본 테이블(Base table)에서 데이터 검색
SELECT
    count(*)
FROM
    emp
WHERE
    deptno = 10;

-- ------------------------------------------------------

CREATE OR REPLACE VIEW emp_view5 AS
SELECT 
    DISTINCT        -- DISTINCT 키워드 사용!!!
    empno,
    ename,
    sal,
    deptno
FROM
    emp;


-- 단순 뷰(Simple View) 데이터에 대한 DELETE 문
DELETE FROM emp_view5
WHERE deptno = 20;


-- emp_view5 뷰(view)에서 데이터 검색
SELECT
    count(*)
FROM
    emp_view5
WHERE
    deptno = 20;


-- 기본 테이블(Base table)에서 데이터 검색
SELECT
    count(*)
FROM
    emp
WHERE
    deptno = 20;

-- ------------------------------------------------------

CREATE OR REPLACE VIEW emp_view5 (deptno, 부서원수) AS
SELECT 
    deptno,
    count(*) 
FROM
    emp
GROUP BY
    deptno;


SELECT
    *
FROM
    emp_view5;


-- 단순 뷰(Simple View) 데이터에 대한 DELETE 문
-- 에러발생: ORA-01732: data manipulation operation not legal on this view
DELETE FROM emp_view5
WHERE
    deptno = 10;


-- emp_view5 뷰(view)에서 데이터 검색
SELECT
    *
FROM
    emp_view5
WHERE
    deptno = 10;


-- 기본 테이블(Base table)에서 데이터 검색
SELECT
    *
FROM
    emp
WHERE
    deptno = 10;



-- ------------------------------------------------------
-- (2) Complex View 생성
-- ------------------------------------------------------

CREATE OR REPLACE VIEW complex_view AS
SELECT
    t2.department_name AS 부서명,
    count(t1.employee_id) AS 인원수
FROM
    employees t1,
    departments t2
WHERE
    t1.department_id = t2.department_id             -- 조인조건
GROUP BY
    t2.department_name;
    

-- complex_view 뷰(view) 구조 확인
DESC complex_view;      -- 생성된 View 객체의 스키마 확인


-- complex_view 뷰(view)에서 데이터 검색
SELECT
    *
FROM
    complex_view;


-- ------------------------------------------------------
-- (3) WITH CHECK OPTION 제약조건
-- ------------------------------------------------------
--  가. 테이블은 무결성을 유지하기 위해, PK/NN 등의 제약조건 설정
--  나. 마찬가지로, View도 WHERE 조건을 만족하는 데이터만,
--      INSERT/UPDATE 가 가능하도록 제약조건 설정가능
--  다. 뷰에 대한 DML 작업이 수행되는 것을, WHERE 조건에 일치하는
--      데이터만 변경가능하도록 제약하는 방법!!!
-- ------------------------------------------------------

-- 30번 부서의 사원정보출력 Simple View
CREATE OR REPLACE VIEW emp_view6 AS
SELECT
    empno,
    ename,
    sal,
    deptno
FROM
    emp
WHERE
    deptno = 30;
    

-- emp_view6 뷰(view) 구조 확인
DESC emp_view6;      -- 생성된 View 객체의 스키마 확인


-- emp_view6 뷰(view)에서 데이터 검색
SELECT
    *
FROM
    emp_view6;


-- 7499 사원의 부서정보 변경(UPDATE)
UPDATE emp_view6
SET
    deptno = 40
WHERE
    empno = 7499;


-- 7499 사원의 부서정보가 30 -> 40으로 변경되었으므로, 
-- 기존 View 에서 나타나지 않음 (기본 테이블에 변경반영됨)
SELECT
    *
FROM
    emp_view6
WHERE
    empno=7499;


-- 기본 테이블(Base table)에서 7499 사원조회
SELECT
    *
FROM
    emp
WHERE
    empno = 7499;

-- ------------------------------------------------------

-- 30번 부서의 사원정보출력 Simple view with check option
-- 30번 부서의 사원만 변경(DML) 가능하도록 제약조건 설정

-- WITH CHECK OPTION 이용한 뷰(view) 생성
CREATE OR REPLACE VIEW emp_view6 AS
SELECT
    empno,
    ename,
    sal,
    deptno
FROM
    emp
WHERE
    deptno = 30
WITH CHECK OPTION;
    

-- emp_view6 뷰(view) 구조 확인
DESC emp_view6;      -- 생성된 View 객체의 스키마 확인


-- emp_view6 뷰(view)에서 데이터 검색
SELECT
    *
FROM
    emp_view6;


-- *** 7521 사원의 부서정보 변경(UPDATE) ***
-- 오류발생: ORA-01402: view WITH CHECK OPTION where-clause violation
-- 원인: WITH CHECK OPTION 제약조건 설정으로, WHERE 절에 부서번호가
--       30이 아닌 변경사항에 대해서는, DML 작업불가(오류발생)

-- WITH CHECK OPTION옵션의 데이터 수정 불가
UPDATE emp_view6
SET 
    deptno = 40,        -- XX
    sal = 10000         -- OK
WHERE
    empno = 7521;


-- ------------------------------------------------------
-- (4) WITH READ ONLY 제약조건
-- ------------------------------------------------------
--  가. 뷰에 대한 DML 작업을 불가능하게 함
--      View를 통한, 어떠한 기본 테이블(Base table) 변경도 불가능
--  나. 읽기전용(read-only) 상태로 View 생성
--  다. **제약조건의 제거** --> 다시 새로운 View 를 생성하여 대체
-- ------------------------------------------------------

-- WITH READ ONLY 이용한 뷰(view) 생성
CREATE OR REPLACE VIEW emp_view6 AS
SELECT
    empno,
    ename,
    sal,
    deptno
FROM
    emp
WITH READ ONLY;
    

-- emp_view6 뷰(view) 구조 확인
DESC emp_view6;      -- 생성된 View 객체의 스키마 확인


-- emp_view6 뷰(view)에서 데이터 검색
SELECT
    *
FROM
    emp_view6;

-- ------------------------------------------------------

-- View를 통한 기본테이블(Base table) 수정(UPDATE) 시도

-- WITH READ ONLY옵션의 데이터 수정 불가
-- WITH READ ONLY 제약조건에 따라, DML 시도는 오류발생
-- ORA-42399: cannot perform a DML operation on a read-only view
UPDATE emp_view6
SET
    sal = 8000
WHERE
    deptno = 30;


-- ------------------------------------------------------
-- 1-5. View 의 삭제
-- ------------------------------------------------------
--  가. 기본 테이블(Base table)에는 영향을 주지 않음
--  나. 기본 테이블(Base table) 손실 없이 삭제
--  다. View의 삭제 --> 곧, USER_VIEWS 데이터 사전에 저장된
--               TEXT 컬럼에 저장되어 있는, 서브쿼리의 삭제
-- ------------------------------------------------------
-- Basic Syntax:
--
--  DROP VIEW <삭제할 View객체의 이름>;
-- ------------------------------------------------------

-- View 삭제
DROP VIEW emp_view6;


-- 뷰(view) 삭제에 따른 base 테이블 확인
SELECT
    *
FROM
    emp;