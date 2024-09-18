-- sample1.sql


-- ------------------------------------------------------
-- 1. To change the password of the specified user
-- ------------------------------------------------------
-- ALTER USER <사용자명> IDENTIFIED BY <비밀번호>;
-- ------------------------------------------------------
ALTER USER hr identified by hr;


-- ------------------------------------------------------
-- 2. To lock the specified user
-- ------------------------------------------------------
-- ALTER USER <사용자명> ACCOUNT LOCK;
-- ------------------------------------------------------
ALTER USER hr ACCOUNT LOCK;

DESC dba_users;

SELECT username, account_status FROM dba_users;


-- ------------------------------------------------------
-- 3. To unlock the specified user
-- ------------------------------------------------------
-- ALTER USER <사용자명> ACCOUNT UNLOCK;
-- ------------------------------------------------------
ALTER USER hr ACCOUNT UNLOCK;

DESC dba_users;

SELECT username, account_status FROM dba_users;


-- ------------------------------------------------------
-- 4. To change the password and [un]lock 
--    of the specified user 
-- ------------------------------------------------------
-- ALTER USER <사용자명> ACCOUNT LOCK   IDENTIFIED BY <비밀번호>;
-- ALTER USER <사용자명> ACCOUNT UNLOCK IDENTIFIED BY <비밀번호>;
--
-- ALTER USER <사용자명> IDENTIFIED BY <비밀번호> ACCOUNT LOCK ;
-- ALTER USER <사용자명> IDENTIFIED BY <비밀번호> ACCOUNT UNLOCK ;
-- ------------------------------------------------------
ALTER USER hr ACCOUNT LOCK IDENTIFIED BY oracle;
ALTER USER hr ACCOUNT UNLOCK IDENTIFIED BY oracle;

ALTER USER hr IDENTIFIED BY oracle ACCOUNT LOCK;
ALTER USER hr IDENTIFIED BY oracle ACCOUNT UNLOCK;

DESC dba_users;

SELECT username, password, account_status FROM dba_users;