-- sample2.sql

-- Using the CUBE operator


select department_id, job_id, count(employee_id), sum(salary)
from employees
where department_id is not null
group by department_id, job_id
order by department_id, job_id;

--------------------------------------------------------------------

select department_id, job_id, count(employee_id), sum(salary)
from employees
where department_id is not null
group by CUBE( department_id, job_id );

--------------------------------------------------------------------

select department_id, job_id, count(employee_id), sum(salary)
from employees
where department_id is not null
group by department_id, CUBE( job_id );

--------------------------------------------------------------------

select department_id, job_id, count(employee_id), sum(salary)
from employees
where department_id is not null
group by CUBE( department_id ), job_id;

--------------------------------------------------------------------

