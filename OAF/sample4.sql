-- sample4.sql

-- With GROUPING function



select department_id, job_id, count(employee_id), sum(salary), GROUPING(department_id), GROUPING(job_id)
from employees
where department_id is not null
group by ROLLUP(department_id, job_id)
order by department_id, job_id;

--------------------------------------------------------------------

select department_id, job_id, count(employee_id), sum(salary), GROUPING(job_id)
from employees
where department_id is not null
group by department_id, ROLLUP(job_id)
order by department_id, job_id;

--------------------------------------------------------------------

select department_id, job_id, count(employee_id), sum(salary), GROUPING(department_id)
from employees
where department_id is not null
group by ROLLUP(department_id), job_id
order by department_id, job_id;

--------------------------------------------------------------------

select department_id, job_id, count(employee_id), sum(salary), GROUPING(department_id), GROUPING(job_id)
from employees
where department_id is not null
group by CUBE(department_id, job_id)
order by department_id, job_id;

--------------------------------------------------------------------

select department_id, job_id, count(employee_id), sum(salary), GROUPING(job_id)
from employees
where department_id is not null
group by department_id, CUBE(job_id)
order by department_id, job_id;

--------------------------------------------------------------------

select department_id, job_id, count(employee_id), sum(salary), GROUPING(department_id)
from employees
where department_id is not null
group by CUBE(department_id), job_id
order by department_id, job_id;