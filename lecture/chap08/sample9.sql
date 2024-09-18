-- sample9.sql


-- ------------------------------------------------------
-- 2. 테이블 삭제
-- ------------------------------------------------------
-- 가. 삭제되는 테이블에 저장된 모든 데이터/관련 인덱스/외래키
--     제약조건을 제외한, 모든 제약조건이 같이 삭제된다.
-- 나. 외래키 제약조건은 자동으로 삭제되지 않기 때문에, 자식 테이블
--     에서 부모테이블을 참조하는 상황에서, 부모 테이블을 삭제하면,
--     종속성에 의해서, 삭제가 안됨.
--
--     이 경우에 CASCADE CONSTRAINTS 옵션을 지정하여 삭제하면,
--     연쇄적으로 제약조건도 함께 삭제되기 때문에, 부모 테이블 삭제가능
-- ------------------------------------------------------
-- Basic Syntax:
--
--  DROP TABLE 테이블명 [CASCADE CONSTRAINTS];
-- ------------------------------------------------------

-- 참조키에 의한 테이블 삭제불가.
-- 자식 테이블이 참조하는 상황에서, 부모 테이블 삭제시도

-- ORA-02449: unique/primary keys in table referenced by foreign keys
DROP TABLE dept02;  -- 부모테이블 삭제불가

-- ------------------------------------------------------

-- 자식 테이블에 설정된, 외래키 제약조건까지 연쇄적으로 삭제하기 위해,
-- CASCADE CONSTRAINTS 옵션 추가.

DROP TABLE dept02 CASCADE CONSTRAINTS;


-- 자식 테이블의 외래키 제약조건 삭제 확인
-- USER_CONSTRAINTS 데이터 사전
DESC user_constraints;


SELECT
    table_name,
    constraint_type,
    constraint_name,
    r_constraint_name
FROM
    user_constraints
WHERE
    table_name IN ('DEPT02', 'EMP02', 'EMP03');

