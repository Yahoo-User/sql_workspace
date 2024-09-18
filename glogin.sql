--
-- Copyright (c) 1988, 2005, Oracle.  All Rights Reserved.
--
-- NAME
--   glogin.sql
--
-- DESCRIPTION
--   SQL*Plus global login "site profile" file
--
--   Add any SQL*Plus commands here that are to be executed when a
--   user starts SQL*Plus, or uses the SQL*Plus CONNECT command.
--
-- USAGE
--   This script is automatically run

SET FEEDBACK OFF
SET TERMOUT OFF
SET TIMING OFF


ALTER SESSION SET nls_date_format = 'YYYY/MM/DD hh24:mi:ss';

SET sqlprompt "( _user'@'_connect_identifier - _date )$ "

SET FEEDBACK ON
SET TERMOUT ON
SET TIMING ON
SET TRIM ON

CLEAR BUFFER
SET LINESIZE 200
SET PAGESIZE 100

SHOW USER