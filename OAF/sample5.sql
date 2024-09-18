-- sample5.sql

-- Hirarchical Retrieval


select employee_id, manager_id, last_name, job_id
from employees;

--------------------------------------------------------------------

select LEVEL, employee_id, manager_id, last_name, job_id
from employees
START WITH employee_id = 101
CONNECT BY PRIOR manager_id = employee_id
order SIBLINGS by last_name;

--------------------------------------------------------------------

select LEVEL, employee_id, manager_id, last_name, job_id
from employees
START WITH employee_id = 101
CONNECT BY PRIOR employee_id = manager_id
order SIBLINGS by last_name;

--------------------------------------------------------------------

select LEVEL, employee_id, manager_id, last_name, job_id
from employees
START WITH employee_id = 103
CONNECT BY PRIOR manager_id = employee_id
order SIBLINGS by last_name;

--------------------------------------------------------------------

select LEVEL, employee_id, manager_id, last_name, job_id
from employees
START WITH employee_id = 103
CONNECT BY PRIOR employee_id = manager_id
order SIBLINGS by last_name;

--------------------------------------------------------------------

select LEVEL, employee_id, manager_id, last_name, job_id
from employees
START WITH employee_id = 100
CONNECT BY PRIOR employee_id = manager_id
order SIBLINGS by last_name;

--------------------------------------------------------------------

select LEVEL, employee_id, manager_id, last_name, job_id
from employees
START WITH employee_id = 104
CONNECT BY PRIOR manager_id = employee_id
order SIBLINGS by last_name;

--------------------------------------------------------------------

select LEVEL, employee_id, manager_id, last_name, job_id
from employees
-- START WITH employee_id = 100
CONNECT BY PRIOR employee_id = manager_id
order SIBLINGS by last_name;

--------------------------------------------------------------------

select LEVEL, employee_id, manager_id, last_name, job_id
from employees
START WITH employee_id = 100
-- Error: ORA-01788: CONNECT BY clause required in this query block
-- CONNECT BY PRIOR employee_id = manager_id;
;

--------------------------------------------------------------------

select LEVEL, employee_id, manager_id, last_name, job_id
from employees
where job_id != 'IT_PROG'
START WITH manager_id is null
CONNECT BY PRIOR employee_id = manager_id
    and last_name != 'De Haan'
order SIBLINGS by last_name;