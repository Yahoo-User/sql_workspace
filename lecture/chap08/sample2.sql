-- sample2.sql


-- ------------------------------------------------------
-- * 제약조건(Contraints)
-- ------------------------------------------------------
--  가. 테이블에 부적절한 데이터가 저장되는 것을 방지
--  나. 테이블 생성시, 각 컬럼에 대해서 정의하는 규칙
--  다. DB 설계단계에서, 데이터의 무결성을 보장하기 위한 수단
--  라. 예: 성별('남','여'), 부서(NULL 값이 없어야 함)
--  마. 데이터가 저장되기 전에, 무결성을 검사하여,
--      잘못된 데이터가 저장되는 것을 방지
--  바. 테이블에 행이 삽입(INSERT)/수정(UPDATE)/삭제(DELETE)
--      될 때마다 적용
--  사. 필요 시, 제약조건의 기능을 일시적으로, 
--      활성화(Enable)/비활성화(Disable) 가능
--  아. USER_CONSTRAINTS 데이터 딕셔너리에 저장
--  자. 제약조건의 종류:
--      (1) NOT NULL    - Only ( column-level )
--          a. 해당 컬럼값으로 NULL 허용하지 않는다
--      (2) UNIQUE      - Both ( column-level ) and ( table-level )
--          a. 해당 컬럼값은 항상 유일한 값을 갖는다
--          b. ( NOT NULL 허용 )
--      (3) PRIMARY KEY - Both ( column-level ) and ( table-level )
--          a. 해당 컬럼값은 반드시 존재해야 하고 유일해야 한다
--          b. ( NOT NULL + UNIQUE )
--          c. 해당 테이블에서 각 행들을 유일하게 구분해주는 식별기능
--          d. 테이블 당, 반드시 하나만 가질 수 있음
--          e. 단순/복합 컬럼으로 구성 가능
--          f. UNIQUE 성질로 인하여, 자동으로 UNIQUE INDEX 생성됨
--          g. 이 기본키를 이용한 데이터 검색은, 자동생성된 인덱스로 인하여
--             속도가 매우 빠르다
--      (4) FOREIGN KEY - Both ( column-level ) and ( table-level )
--          a. 해당 컬럼의 값이, 다른 테이블의 컬럼의 값을 참조해야 한다
--          b. 참조되는 컬럼에 없는 값은 저장이 불가능하다
--          c. ( NOT NULL 허용 )
--      (5) CHECK       - Both ( column-level ) and ( table-level )
--          a. 해당 컬럼에 가능한, 데이터 값의 범위나 사용자 조건을 지정한다
--  차. 제약조건의 이름짓기
--      a. 명명방법: CONSTRAINT table_column_2자리제약조건종류 (*권장*)
--          - NOT NULL:     table_column_nn
--          - UNIQUE:       table_column_uk
--          - PRIMARY KEY:  table_column_pk
--          - FOREIGN KEY:  table_column_fk
--          - CHECK:        table_column_ck
--      b. 제약조건명으로, 기능을 활성화/비활성화 할 수 있음
--      c. 제약조건명을 직접 지정하지 않으면, 오라클이 자동으로 명명함
--      d. Oracle의 제약조건명 형식: Prefix(SYS_) + 자동이름
-- ------------------------------------------------------
-- * Column-level: 테이블 생성시,
--  가. 각 컬럼을 정의하면서, 같이 제약조건을 지정하는 방법
-- ------------------------------------------------------
-- Basic Syntax:
--
--  CREATE TABLE [스키마].테이블명(
--      컬럼명 데이터타입  [ CONSTRAINT 제약조건명 ]  PRIMARY KEY,
--      컬럼명 데이터타입,
--      ...
--  );
-- ------------------------------------------------------

-- 컬럼 레벨(column-level) 방식의 기본 키(PRIMARY KEY) 설정
CREATE TABLE department (
    deptno  NUMBER(2)       CONSTRAINT department_deptno_pk PRIMARY KEY,
    dname   VARCHAR2(15),
    loc     VARCHAR2(15)
);

-- ------------------------------------------------------
-- * Table-level: 테이블 생성시,
--  가. 모든 컬럼을 정의하고, 맨 마지막에 제약조건을 추가하는 방법
--  나. 하나의 컬럼에 여러 개의 제약조건을 부여할 경우에 사용
-- ------------------------------------------------------
-- Basic Syntax:
--
--  CREATE TABLE [스키마].테이블명 (
--      컬럼명1 데이터타입,
--      ...
--      컬럼명n 데이터타입,
--      [CONSTRAINT 제약조건명] PRIMARY KEY(컬럼명[,컬럼명2, ...])
--  );
-- ------------------------------------------------------

-- 테이블 레벨(table-level) 방식의 기본 키(PRIMARY KEY) 설정
CREATE TABLE department2 (
    deptno  NUMBER(2),
    dname   VARCHAR2(15),
    loc     VARCHAR2(15),

    CONSTRAINT department2_deptno_pk PRIMARY KEY (deptno)
);
