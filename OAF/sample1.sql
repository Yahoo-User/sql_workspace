-- sample1.sql

-- Using the ROLL UP operator


select department_id, job_id, count(employee_id), sum(salary)
from employees
where department_id is not null
group by department_id, job_id
order by department_id, job_id;

--------------------------------------------------------------------

select department_id, job_id, count(employee_id), sum(salary)
from employees
where department_id is not null
group by ROLLUP( department_id, job_id )
order by department_id desc, job_id;

--------------------------------------------------------------------

select department_id, job_id, count(employee_id), sum(salary)
from employees
where department_id is not null
group by department_id, ROLLUP( job_id )
order by department_id desc, job_id;

--------------------------------------------------------------------

select department_id, job_id, count(employee_id), sum(salary)
from employees
-- where department_id is not null
group by ROLLUP( department_id ), job_id
order by department_id desc, job_id;


select department_id, job_id, count(employee_id), sum(salary)
from employees
where department_id is not null
group by ROLLUP( department_id ), job_id
order by department_id desc, job_id;

--------------------------------------------------------------------