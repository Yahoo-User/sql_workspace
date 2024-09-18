-- sample2.sql


-- ------------------------------------------------------
-- 2. Sequence 객체 : 순차번호(Sequential number) 생성기
-- ------------------------------------------------------
--  가. 호출될 때마다, 자동으로 숫자를 생성하는 Oracle 객체
--  나. 테이블의 특정 컬럼의 값을 Numbering 할 때 사용
--      예: 웹 게시판의 글 번호
--  다. 만일 시퀀스를 사용하지 않는다면, 직접 명시적으로,
--      현재 컬럼의 가장 큰값(max) + 1 씩, 더 크게 설정하기
--      위한 추가 작업이 필요(응용프로그램에서)
-- ------------------------------------------------------
-- Basic syntax: 아래 지정 옵션의 순서는 무관(But 가장 일반적)
--
--  CREATE SEQUENCE 시퀀스명
--  [ START WITH n ]
--      순차번호의 시작값 지정. 생략시 1부터 시작
--  [ INCREMENT BY n ]
--      연속적인 순차번호의 증가치 지정. 
--      음수도 가능 (감소치), 생략시 1씩 증가
--  [ MAXVALUE n | NOMAXVALUE ]
--      시퀀스 객체가 생성할 수 있는 순차번호의 최대값 지정
--  [ MINVALUE n | NOMINVALUE ]
--      시퀀스 객체가 생성할 수 있는 순차번호의 최소값 지정
--      아래 CYCLE 옵션이 지정된 경우, 새로 시작하는 값 역할
--  [ CYCLE | NOCYCLE ]
--      시퀀스 객체가 최대값(MAXVALUE) 까지 증가한 경우,
--      START WITH 값 부터 재시작 하는 것이 아니라,
--      MINVALUE 값 부터 재시작.
--
--      ** NOCYCLE 은 최대값까지 도달하게 되면, 에러가 발생 **
--  [ CACHE n | NOCACHE ]
--      성능향상을 위해, 메모리 상에 미리 순차번호를
--      기본으로 20개까지 미리 생성하여 관리.
--      (*주의사항*) DB를 종료 했다가, 재시작하면, 이전에 미리
--      생성하였었던, 메모리에 있는 최대 20개의 순차번호는 재사용불가
--      
--      NOCACHE는 , 필요할 때 마다, 매번 순차번호 계산하여 반환
-- ------------------------------------------------------


-- ------------------------------------------------------
-- 2-1. 시퀀스 객체 생성
-- ------------------------------------------------------

-- 부서번호 자동생성 시퀀스 객체 생성
CREATE SEQUENCE dept_deptno_seq
    START WITH 10       -- 10부터 번호시작
    INCREMENT BY 10     -- 증가치가 10
    MAXVALUE 100        -- 최대값 100
    MINVALUE 5          -- 최소값 5(CYCLE시, 재시작 번호)
    CYCLE               -- 최대값 도달시, MINVALUE 부터 재시작
    NOCACHE ;           -- 최대 20개의 숫자를 메모리에 미리 생성하지 않음!


-- Error: DESCRIBE SEQUENCE is not available
DESC dept_deptno_seq;   -- 테이블 객체에만 사용가능


-- ------------------------------------------------------
-- 2-2. 시퀀스 객체의 NEXTVAL / CURRVAL 속성
-- ------------------------------------------------------
--  가. 시퀀스 객체생성 -> 자동으로 순차번호가 생성되는 것이 아님
--  나. 순차번호를 얻기 위해서는, *반드시 * 시퀀스 객체를 호출해야 함
--  다. 시퀀스 객체의 호출형식: 
--      "시퀀스객체명.NEXTVAL"  -> 다음 순차번호 생성 및 획득
--      "시컨스객체명.CURRVAL"  -> 현재 생성된 순차번호 조회
--  라. (*주의할 점*) 
--      반드시 NEXTVAL 먼저 호출, 나중에 CURRVAL 호출해야 함
-- ------------------------------------------------------

-- 가장 간단한 순차번호 값 확인 방법 : DUAL (Dummy table) 사용
-- 증가를 위한 NEXTVAL과 CURRVAL 사용

SELECT
    dept_deptno_seq.NEXTVAL,    
    dept_deptno_seq.CURRVAL
FROM
    dual;

-- ------------------------------------------------------

-- 음수값 이용한 시퀀스 생성
CREATE SEQUENCE dept_deptno_seq2
    START WITH 100
    INCREMENT BY -10
    MAXVALUE 150
    MINVALUE 10
    CYCLE
    NOCACHE;


-- 감소를 위한 NEXTVAL과 CURRVAL 사용
SELECT
    dept_deptno_seq2.NEXTVAL,
    dept_deptno_seq2.CURRVAL
FROM
    dual;


-- ------------------------------------------------------
-- 2-3. USER_SEQUENCES 데이터 사전
-- ------------------------------------------------------
--  가. 시퀀스 객체 정보를 저장하는 데이터 사전
--  나. 돌이켜 보면,
--      a. USER_TABLES  : 테이블에 대한 데이터 사전
--      b. USER_VIEWS   : 뷰(View)에 대한 데이터 사전
--      c. USER_SEQUENCES : 시퀀스에 대한 데이터 사전
-- ------------------------------------------------------
DESC user_sequences;


-- DEPT_DEPTNO_SEQ2 시퀀스 데이터 사전 조회
SELECT
    *
FROM
    user_sequences
WHERE
    sequence_name = 'DEPT_DEPTNO_SEQ2';


-- ------------------------------------------------------
-- 2-4. 시퀀스(Sequence) 객체의 수정
-- ------------------------------------------------------
--  가. ALTER SEQUENCE 문 사용
--  나. 증가치/최대값/최소값/CYCLE여부/캐시값 등 변경가능
--      "START WITH 시작값"은 변경불가!!! (******)
--  다. 시퀀스 변경후, 다음 순차번호 생성부터 적용
--  라. "START WITH 시작값"의 변경을 꼭 해야한다면?
--      기존 시퀀스를 삭제하고 재 생성 해야함!! (**)
-- ------------------------------------------------------
-- Basic syntax:
--  
--  ALTER SEQUENCE 시퀀스명
--  [ INCREMENT BY n]
--  [ MAXVALUE n | NOMAXVALUE ]
--  [ MINVALUE n | NOMINVALUE ]
--  [ CYCLE | NOCYCLE ]
--  [ CACHE n | NOCACHE ]
--
--  * START WITH 값은 수정불가!!!
-- ------------------------------------------------------

-- 시퀀스 생성 (명시적으로 옵션 설정 안함***)
CREATE SEQUENCE dept_deptno_seq3;


-- 명시적인 옵션설정 없이 생성된 시퀀스의 설정내용은 ??
-- USER_SEQUENCES 데이터 사전 이용
-- DEPT_DEPTNO_SEQ3 시퀀스 데이터 사전 조회
SELECT
    increment_by,       -- Default value: 1
    min_value,          -- Default value: 1
    cache_size,         -- Default value: 20
    cycle_flag,         -- Default value: N
    max_value           -- Default value: 1.0000E+28
FROM
    user_sequences
WHERE
    sequence_name = 'DEPT_DEPTNO_SEQ3';


-- DEPT_DEPTNO_SEQ3 시퀀스 수정
ALTER SEQUENCE dept_deptno_seq3
INCREMENT BY 10
CYCLE;


-- 수정된 사항 확인: 데이터 사전 이용
-- DEPT_DEPTNO_SEQ3 시퀀스 데이터 사전 조회
SELECT
    increment_by,       -- After modifying: 10
    cache_size,         -- After modifying: 20
    cycle_flag          -- After modifying: Y
FROM
    user_sequences
WHERE
    sequence_name = 'DEPT_DEPTNO_SEQ3';

-- ------------------------------------------------------

-- START WITH 옵션은 변경불가!!
-- 그래도 함 고쳐보자!!

-- ORA-02283: cannot alter starting sequence number
ALTER SEQUENCE dept_deptno_seq3
    START WITH 5
    INCREMENT BY 10
    CYCLE;


-- ------------------------------------------------------
-- 2-5. 테이블에 시퀀스 값(순차번호) 저장
-- ------------------------------------------------------
--  가. 시퀀스는 테이블의 특정 컬럼값을 넘버링(numbering)하기
--      위한 용도로 사용(*잊지 말 것!*)
--  나. 따라서 테이블에 데이터를 저장하는 INSERT 문과 함께 사용
-- ------------------------------------------------------

CREATE TABLE dept06 (
    deptno  NUMBER(4)   PRIMARY KEY, -- 시퀀스를 통해 부서번호 생성
    dname   VARCHAR2(15),
    loc     VARCHAR2(15)
);

-- 부서번호 자동생성용, 시퀀스 객체 생성
CREATE SEQUENCE dept_deptno_seq4
    START WITH 10
    INCREMENT BY 10
    NOCYCLE;

-- 시퀀스를 이용한 새로운 행 삽입(INSERT)
INSERT INTO dept06 (deptno, dname, loc)
VALUES (
    dept_deptno_seq4.NEXTVAL,   -- 시퀀스 생성번호 입력

    '개발',
    '서울'
);

INSERT INTO dept06 (deptno, dname, loc)
VALUES (
    dept_deptno_seq4.NEXTVAL,   -- 시퀀스 생성번호 입력

    '인사',
    '경기'
);

INSERT INTO dept06 (deptno, dname, loc)
VALUES (
    dept_deptno_seq4.NEXTVAL,   -- 시퀀스 생성번호 입력

    '관리',
    '부산'
);

COMMIT;


SELECT
    *
FROM
    dept06;


-- ------------------------------------------------------
-- 2-6. 시퀀스 객체 삭제
-- ------------------------------------------------------
--  가. DROP SEQUENCE 문 사용
-- ------------------------------------------------------
-- Basic syntax:
-- 
--  DROP SEQUENCE <삭제할 시퀀스명>;
-- ------------------------------------------------------

DROP SEQUENCE dept_deptno_seq4;



