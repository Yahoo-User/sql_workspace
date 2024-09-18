-- sample10.sql


-- ------------------------------------------------------
-- 3. Flashback Drop
-- ------------------------------------------------------
-- 가. 삭제된 테이블을 복구하는 방법 (from Oracle10g)
-- 나. 테이블 삭제할 때, (DROP TABLE tablename;)
--     삭제된 테이블은 휴지통(RECYCLEBIN)이라는 특별한 객체에,
--     'BIN$' prefix가 붙은, 이름으로 저장됨.
-- 다. 삭제된 테이블을 다시 복구하고 싶을 때, Flashback Drop
--     복구기술을 이용하여, 휴지통(RECYCKEBIN) 객체에서, 삭제된
--     테이블을 복구할 수 있다.
-- ------------------------------------------------------

-- ------------------------------------------------------
-- * Flashback Drop Commands *
-- ------------------------------------------------------
SHOW RECYCLEBIN;                            -- RECYCLEBIN 객체정보 조회


FLASHBACK TABLE tablename TO BEFORE DROP;   -- 삭제된 테이블 복구


DROP TABLE tablename PURGE;                 -- 테이블 완전삭제(복구불가)


PURGE RECYCLEBIN;                           -- RECYCLEBIN 객체정보 삭제
-- ------------------------------------------------------


SELECT * FROM tab;


-- 1. RECYCLEBIN 객체정보 조회
SHOW RECYCLEBIN;                -- Only Oracle SQL*Developer


-- 2. 삭제된 테이블 복구
FLASHBACK TABLE dept02 TO BEFORE DROP;


SELECT * FROM tab;


-- 3. 테이블 완전삭제(복구불가)
DROP TABLE dept02 PURGE;


-- 4. RECYCLEBIN 객체정보 삭제 (휴지통 비우기)
PURGE RECYCLEBIN;


