-- sample3.sql

-- With GROUPING SETS expression


select department_id, job_id, manager_id, count(employee_id), sum(salary)
from employees
group by grouping sets(
    (department_id, job_id),
    (job_id, manager_id),
    ()
);

--------------------------------------------------------------------

select department_id, job_id, manager_id, count(employee_id), sum(salary)
from employees
where department_id is not null
group by grouping sets(
    department_id,
    job_id,
    manager_id,
    ()
);

--------------------------------------------------------------------

select department_id, count(employee_id), sum(salary)
from employees
where department_id is not null
group by grouping sets(
    department_id,
    ()
);

--------------------------------------------------------------------

select job_id, count(employee_id), sum(salary)
from employees
where department_id is not null
group by grouping sets(
    job_id,
    ()
);

--------------------------------------------------------------------

select count(employee_id), sum(salary)
from employees
where department_id is not null
group by grouping sets(
    ()
);