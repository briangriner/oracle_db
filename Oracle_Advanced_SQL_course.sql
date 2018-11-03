/* Advanced SQL in Oracle course @ Rutgers */
-- Oracle XE 11g docker container + Oracle SQL Developer

/* 1. users & schemas */

-- create a user & schema - MUST BE LOGGED IN AS SYSTEM
create user example_user identified by user_password;
-- drop user example_user cascade;

-- alter user + setup env
alter user example_user default tablespace users;
alter user example_user quota unlimited on users;

-- grant user privilges on specific table
grant create session, resource, create synonym, create view to example_user;
grant select on HR.employees to example_user;
grant insert on HR.employees to example_user;
grant delete on HR.employees to example_user;

-- check new user from system table
select * from all_users; -- EXAMPLE_USER	49	03-NOV-18


/* 2. pseudo cols & functions */

-- system context from dual table - dual is a temp table in memory
SELECT sys_context('USERENV' , 'SESSION_USER') FROM dual; -- SYSTEM

select * from dual; --X
select sysdate, SYSTIMESTAMP from dual; -- 03-NOV-18	03-NOV-18 03.27.59.280335000 PM GMT
select round(152.651 * 3.5,2) from dual; -- 534.28
select sys_context('userenv', 'ip_address') from dual; -- 123.45.6.7 (NOT ACTUAL IP)
select sys_context('userenv', 'host') from dual; -- your_laptop.local
select sys_context('userenv', 'language') from dual; -- AMERICAN_AMERICA.AL32UTF8
select sys_context('userenv', 'isdba') from dual; -- FALSE
select sys_context('userenv', 'session_user') from dual; -- SYSTEM
select sys_context('userenv', 'db_name') from dual; -- XE

-- pseudo-columns

-- rowid - quick access to row within cluster - not unique for entire DB
select rowid from sys.icol$
intersect
select rowid from sys.ind$;
/* All Rows Fetched: 2943 rows in 0.117 seconds
AAAAACAABAAAACRAAA
AAAAACAABAAAACRAAB
AAAAACAABAAAACRAAC
...
AAAAACAABAAAJBxAAB
AAAAACAABAAAJBxAAC
AAAAACAABAAAJBxAAD
*/

-- rownum - index of row order in query
select department_name, rownum from hr.departments
where rownum < 10
order by department_name;
/*
department_name     rownum
Administration	    1
Executive	        9
Human Resources	    4
IT	                6
Marketing	        2
Public Relations	7
Purchasing	        3
Sales	            8
Shipping	        5
*/

-- rownum in subquery
select * from
    (
    select * from hr.departments
    order by department_name
    ) 
where rownum < 10;
/*
department_id   department_name     manager_id  location_id
110	            Accounting	        205	        1700
10	            Administration	    200	        1700
160	            Benefits		                1700
180	            Construction		            1700
190	            Contracting		                1700
140	            Control And Credit		        1700
130	            Corporate Tax		            1700
90	            Executive	        100	        1700
100	            Finance	            108	        1700
*/

-- update table using rownum
create table mytable as select * from hr.departments;
alter table mytable add test_col number;
update mytable set test_col=rownum;

select * from mytable;
/*
department_id   department_name     manager_id  location_id test_col
10	            Administration	    200	        1700        1
20	            Marketing	        201	        1800	    2
30	            Purchasing	        114	        1700	    3
...
250	            Retail Sales		            1700	    25
260	            Recruiting		                1700	    26
270	            Payroll		                    1700	    27
*/


/* 3. subqueries */

-- simple - no join between subquery and query; e.g. nested, in-line views

-- nested - in where clause
select * from hr.employees
where salary =
    (
    select max(salary) from hr.employees
    );

-- in-line views - in from clause
select count(*) from
    (
    select * from hr.employees
    where last_name like 'A%'
    );

-- correlated subquery - contains join between subquery and query
select *
from hr.employees e1
where e1.salary = (
    select max(salary)
    from hr.employees e2
    where e1.department_id = e2.department_id
);

-- scalar subquery - returns single row
select * from hr.employees
where salary = (select min(salary)
    from hr.employees
);

-- nesting subqueries - no limit in from, 255 limit in where
select count(*) from
    (
    select salary,
        (
        select avg(salary) from hr.employees
        ) avg_sal from hr.employees
    )
where salary > avg_sal;

/* 4. joins */

-- joins
select count(*) from hr.employees;

select count(*) from hr.employees e
inner join hr.departments d on e.department_id = d.department_id;

select * from hr.employees
where department_id is null;

select first_name, last_name from hr.employees e
where e.employee_id = 178;

-- inner join will NOT return employee with missing id
select first_name, last_name from hr.employees e
inner join hr.departments d on d.department_id = e.department_id
where e.employee_id = 178;

-- left outer join WILL return this employee
select first_name, last_name from hr.employees e
left outer join hr.departments d on d.department_id = e.department_id
where e.employee_id = 178;

-- right outer join exercise
insert into hr.departments(department_id,department_name,manager_id,location_id)
values(999,'Vacant Dept',null,null);

-- does not return any records
select first_name, last_name, department_name from hr.employees e
inner join hr.departments d on d.department_id = e.department_id
where e.employee_id = 178 or d.department_id = 999;

-- left outer join
select first_name, last_name, department_name from hr.employees e
left outer join hr.departments d on d.department_id = e.department_id
where e.employee_id = 178 or d.department_id = 999;

-- right outer join - returns inserted data in dept table only
select first_name, last_name, department_name from hr.employees e
right outer join hr.departments d on d.department_id = e.department_id
where e.employee_id = 178 or d.department_id = 999;

-- full outer join
select first_name, last_name, department_name from hr.employees e
full outer join hr.departments d on d.department_id = e.department_id
where e.employee_id = 178 or d.department_id = 999;

-- oracle syntax for left outer join using (+) for table where null is acceptable
select first_name, last_name, department_name from hr.employees e, hr.departments d
where(e.employee_id = 178 or d.department_id = 999) and d.department_id = e.department_id(+);

-- cross joins (cartesion product) aka theta joins
select first_name, last_name, department_name from hr.employees, hr.departments
order by first_name, last_name, department_name;

-- reflexive joins
select first_name, last_name from hr.employees
where employee_id = 103;

select first_name, last_name from hr.employees
where manager_id = 103;

-- pull manager + employees in same row using reflexive join - table m stored in memory
select e.first_name, e.last_name, m.first_name as manager_first_name, m.last_name as manager_last_name
from employees e
inner join hr.employees m
on e.manager_id = m.employee_id;

-- hierarchical queries
select employee_id, manager_id from hr.employees
start with manager_id is null
connect by prior employee_id = manager_id;

-- sys_connect_by_path shows org chart relationship assuming employee_id is ordered chonologically
select employee_id, manager_id, sys_connect_by_path(last_name, '->') as path
from hr.employees
start with manager_id is null
connect by prior employee_id = manager_id;

-- non key join - silly example to show join between country abbrv. and first 2 ltrs of first name
select country_id, country_name, first_name from hr.employees e
inner join countries c on c.country_id = upper(substr(e.first_name,1,2));

-- natural joins - join using cols with same name in different tables

-- using inner join
select * from hr.regions r
inner join hr.countries c on c.region_id = r.region_id;

-- using natural join - much faster but NOT recommended - e.g. if col renamed can change query results
select * from hr.regions
natural join hr.countries;

-- semi join - returns matches - uses in or exists
select * from hr.jobs
where job_id in (select job_id from hr.job_history);

-- anti join - returns records where NO match - uses not in or not exists

-- selects unfilled jobs
select * from hr.jobs
where job_id not in (select job_id from hr.job_history);

-- named subquery / inline view - returns employee managers
select first_name, last_name, department_id from hr.employees
where manager_id is null or employee_id in (select manager_id from hr.employees);

-- named subquery with alias managers defined in subquery
select managers.first_name, managers.last_name, d.department_name from 
    (select first_name, last_name, department_id from hr.employees
    where manager_id is null or employee_id in 
        (select manager_id from hr.employees)
    ) managers
inner join departments d on d.department_id = managers.department_id;

-- join exercises

-- 1. create query that returns all employee rows and assign alias e - fetches 50 rows
select * from hr.employees e;

-- 2. modify query to access departments table using theta join syntax - fetches 50 rows (join on manager_id only 43 rows
select * from hr.employees e, hr.departments d
where e.department_id = d.department_id;

-- 3. modify 2 to use inner join using department_id - fetched 50 rows
select * from hr.employees e
join hr.departments d on e.department_id = d.department_id;

-- 4. rewrite query using a semi join -- returns 50 rows - fast
select * from hr.employees e, hr.departments d
where e.department_id in d.department_id;

-- solution syntax - slower than above
select * from hr.employees e
where e.department_id in (select d.department_id from departments d);

-- group by - fetched 4 rows
select region_name, country_name, count(*) from hr.emp_details_view
group by region_name, country_name
order by region_name, country_name;

-- rollup function - generates subtotal on multiply keys (like by statement in SAS)
select region_name, country_name, count(*) from hr.emp_details_view
group by rollup(region_name, country_name)
order by region_name, country_name;

-- grouping and decode - returns crosstab with subtotals (region x country) region and grand total
select decode(grouping(region_name),0,region_name,'GRAND') as region_name,
    decode(grouping(country_name),0,country_name,'TOTAL') as country_name,
    count(*)
from hr.emp_details_view
group by rollup(region_name, country_name);

/* 5. rollup & cube */

-- group by rollup: get subtotals, total by region and grand total by not by name
select region_name, first_name, count(*) from emp_details_view
where first_name like 'Da%'
group by rollup(region_name, first_name);

-- group by cube: totals for all possible combination of region and name
select region_name, first_name, count(*) from emp_details_view
where first_name like 'Da%'
group by cube(region_name, first_name);

-- CHECK
select region_name, country_name, count(*) from emp_details_view
group by cube(region_name, country_name);

-- cube2: CHECK GROUPING DEF - DOES 0 = NULL IN COL WHEN DOING A CROSS JOIN FOR THE TABLE?
select
    decode(grouping(region_name),0,region_name,'Summary') as region_name,
    decode(grouping(first_name),0,first_name,'Total') as first_name,
    count(*)
    from emp_details_view
    where first_name like 'Da%'
    group by cube(region_name, first_name);

-- practice group by, rollup, cube

-- 1. query that returns count of employees by region, country, state and department - fetched 11 rows
select region_name, country_name, state_province, department_name, count(*) from hr.emp_details_view
group by region_name, country_name, state_province, department_name
order by region_name, country_name, state_province, department_name;

--2. add rollup - fetched 25 rows
select region_name, country_name, state_province, department_name, count(*) from hr.emp_details_view
group by rollup(region_name, country_name, state_province, department_name)
order by region_name, country_name, state_province, department_name;

-- CHECK: quiz ques. 1 ok - no subtotals for col2
select region_name, country_name, count(*) from hr.emp_details_view
group by rollup(region_name, country_name);
--order by region_name, country_name;

-- 3. add calls to grouping function at each level - all rows fetched: 25 rows
select 
    decode(grouping(region_name),0,region_name,'r_total') as region_name,
    decode(grouping(country_name),0,country_name,'c_total') as country_name,
    decode(grouping(state_province),0,state_province,'s_total') as state_province,
    decode(grouping(department_name),0,department_name,'d_total') as department_name,
    count(*) 
    from hr.emp_details_view
    group by rollup(region_name, country_name, state_province, department_name)
    order by region_name, country_name, state_province, department_name;
    
-- solution syntax - see grouping functions with no decode?
select
    grouping (region_name) as g1,
    grouping (country_name) as g2,
    grouping (state_province) as g3,
    grouping (department_name) as g4,
    region_name,
    country_name,
    state_province,
    department_name,
    count(*)
    from hr.emp_details_view
    group by rollup(region_name,
    country_name,
    state_province,
    department_name)
    order by region_name,country_name,state_province,department_name;
    
-- 1. Limit results to only display region_name and grand_total levels - fetched 3 rows
select
    region_name,
    country_name,
    state_province,
    department_name,
    count(*)
    from hr.emp_details_view
    group by rollup(
        region_name,
        country_name,
        state_province,
        department_name
        )
    having
        grouping (region_name) ||
        grouping (country_name) ||
        grouping (state_province) ||
        grouping (department_name)
    in ('0111','1111')
    order by region_name,country_name,state_province,department_name;


/* 6. set operators */

-- minus operator
select distinct job_id from hr.jobs; -- 19 rows    
select distinct job_id from hr.job_history; -- 8 rows

-- use minus operator to find how many new jobs are available -- 11 rows as expected
select distinct job_id as "Job ID" from hr.jobs
minus
select distinct job_id from hr.job_history;
        
-- intersect operator - select job ids in both tables - 8 rows - SAME AS INNER JOIN
select distinct job_id from hr.jobs
intersect
select distinct job_id from hr.job_history;

-- intersection - SAME AS INNER JOIN - same 8 rows
select distinct j.job_id from hr.jobs j
join job_history h on j.job_id = h.job_id;

-- union all - 29 rows - INCLUDES DUPLICATE JOB IDS FROM BOTH TABLES - e.g. ac mgr in rows 2 & 22
select job_id from hr.jobs
union all 
select job_id from hr.job_history;

-- set operator exercise

-- 1. select city and state_province from locations table - 23 rows
select city, state_province from hr.locations;

-- 2. use set operator to find names appearing in both city and state_province in locations table 
-- i.e. name = state_province
select city from hr.locations
intersect
select state_province from hr.locations;

-- 3. write query 2 without set operator
select city, state_province from hr.locations
where city = state_province;

-- 4. inline-view (named subquery) of distinct city and (OR) state_province records - 3 rows 
select distinct count(*) from hr.locations
where city in (select state_province from hr.locations);

-- solution syntax - 38 rows
select  count(*) from 
    (
    select city from hr.locations
    union
    select state_province from hr.locations
    );

-- 5. total count of records of city and state_province combined - 46 rows
select count(*) from
    (
    select city from hr.locations
    union all
    select state_province from hr.locations
    );

-- find nulls - 6 rows
select count(*) from
    (
    select city as place from hr.locations
    union all
    select state_province from hr.locations
    )
where place is null;

/* 7. conditional processing - decode + case */

-- decode operator - used for IF THEN, ELSEIF, ELSE
select decode(2,1,'option 1',2,'option 2','anything else') from dual; -- option 2

select decode(99.1,1,'option 1',2,'option 2','anything else') from dual; -- anything else

select decode(99.1,1,'option 1',2,'option 2') from dual; -- (null)

-- find executives in departments
select department_name from hr.departments; -- 27 rows

select decode(department_name,'Executive','THE EXECUTIVES!',department_name) as dept from hr.departments; -- 'THE EXECUTIVES!' in row 9

-- calculate commission pct where applicable
select first_name, last_name, commission_pct from hr.employees; -- 50 rows

select first_name, last_name, decode(commission_pct,null,'none',commission_pct*100 ||'%') as commission_info
from hr.employees
order by first_name, last_name;

-- case expression (case, when ... then, else, end)- SIMILAR TO DECODE

-- ANSI case syntax
select first_name, last_name,
    case first_name
        when 'Adam' then 'is first'
        when 'Alana' then 'is second'
        else 'follows'
    end as statement
from hr.employees
order by first_name, last_name;

select first_name, last_name, salary,
    case
        when salary > 20000 then 'very high'
        when salary > 10000 then 'high'
        when salary < 2600 then 'low'
        else 'average'
    end as category
from hr.employees
order by first_name, last_name;

-- conditional processing exercise

-- 1. select street_address, postal_code, city, state_province and country_id from locations
select street_address, postal_code, city, state_province, country_id from hr.locations;

-- 2. add col location with US=domestic else foreign
select street_address, postal_code, city, state_province, country_id, decode('US',country_id,'Domestic','Foreign') as location
from hr.locations;

-- 3. inner join of employees and jobs tables -- 50 rows
select * from hr.employees e 
join hr.jobs j on j.job_id = e.job_id;

-- 4. add first_name, last_name, job_title, salary increased by 10%, min_salary and max_salary
select first_name, last_name, job_title, 1.1*salary as amount, min_salary, max_salary 
from hr.employees e
join hr.jobs j on j.job_id = e.job_id;

-- 5. add case statement that appends 'Senior' if 1.1*salary > max_salary
select first_name, last_name, job_title, 1.1*salary as amount, min_salary, max_salary,
    case
        when 1.1*salary > max_salary then 'Senior ' || job_title
    end as new_title
from hr.employees e
join hr.jobs j on j.job_id = e.job_id;


/* 8. scalar SQL character functions */

-- character functions

-- || function - max length is 16 characters - returns rows where first + last name = 16 characters (6 rows)
select first_name, last_name, length(first_name), length(last_name) from hr.employees 
where length(first_name || last_name) in
    (
    select max(length(first_name || last_name)) from hr.employees
    );
    
-- concat function - only works with 2 strings
select first_name, last_name, length(first_name), length(last_name) from hr.employees 
where length(concat(first_name, last_name)) in
    (
    select max(length(concat(first_name,last_name))) from hr.employees
    );

-- instr function
select instr(first_name,'an') as position from hr.employees;

-- returns 19 rows
select instr(first_name,'an') as position from hr.employees
where instr(first_name,'an') > 0;

-- replace function - 19 rows
select replace(first_name,'an','AN') as "First name with an" from hr.employees
where instr(first_name,'an') > 0;

-- change case of string - 1 row
select last_name, upper(last_name) as upper_name, lower(last_name) as lower_name, initcap(last_name) as initial_cap
from hr.employees
where last_name like 'McC%';

-- lpad and rpad - col, desired length, pad char - if col length < desired length then pad with pad char
select rpad(first_name,7,'-') as r, lpad(first_name,7,'-') as l, first_name from hr.employees;

-- trim - remove leading and trailing spaces - full=27, trim=21
select length(txt) as full_text, length(trim(txt)) as trimmed_txt
from
    (select '  this has extra spaces    ' as txt from dual
    );

-- to_char function
select first_name, last_name, salary as "No Format Salary", to_char(salary,'$999,999.00') as salary, hire_date as "Default",
to_char(hire_date,'MM/DD/YYYY') as hire_date from hr.employees;

-- soundex function - similar to like but returns words that sound like 'word' but are spelled differently
select soundex('stephen'),soundex('steven') from dual;

select first_name from hr.employees
where soundex(first_name) = soundex('steven'); -- found 3 rows

-- regex expression in oracle (don't forget p - regexp) - 0 is F and > 0 is T? CHECK

-- regexp_instr
select * from hr.locations
where regexp_instr(street_address,'[0-9]') = 0;

select * from hr.locations
where regexp_instr(street_address,'Street| St') > 0;

-- regexp_like
select * from hr.locations
where street_address like '%-%' or street_address like '%(%' or street_address like '%,%'; -- contains - ( ,

select * from hr.locations 
where regexp_like(street_address,'[[:digit:]]$'); -- has a digit as last char

-- regexp_replace
select regexp_replace(street_address, '[[:alpha:]]', 'x') as result from hr.locations; -- replaces any alpha with x

select regexp_replace(phone_number, '[[:digit:]]', 9) as result from hr.employees; -- replaces any digit with 9

-- char functions exercises
/*
-- 1. Create a query that creates an email address for each employee by concatenating first name and last name 
(separated by a dot) with @company.com.
*/
select first_name, last_name, lower(first_name)||'.'||lower(last_name)||'@northwind.com' as email from hr.employees;

/*
-- 2. Create a query that uses the query created in the previous step as an inline view. Set this query aside 
as it will be used again in this exercise.
*/
select * from
    (
    select first_name, last_name, lower(first_name)||'.'||lower(last_name)||'@northwind.com' as email from hr.employees
    );

/*
-- 3. First, modify the query created in the previous step to find the length of the longest email address. Next, add a 
few spaces to the @company.com character string. Now modify the query so that we see the length of the longest email address 
with and without the spaces that were added.
*/

-- max email length = 31
select max(length(email)) from
    (
    select first_name, last_name, lower(first_name)||'.'||lower(last_name)||'@northwind.com' as email from hr.employees
    );

-- max email length with spaces = 34
select max(length(email)) from
    (
    select first_name, last_name, lower(first_name)||'.'||lower(last_name)||'@northwind.com   ' as email from hr.employees
    );

-- max email length trimmed = 31
select max(length(trim(email))) from
    (
    select first_name, last_name, lower(first_name)||'.'||lower(last_name)||'@northwind.com   ' as email from hr.employees
    );

/*
-- 4. Start again with the query created in step two above. In the outer query, change the name of the email domain from 
@company.com to @newcompany.com.
*/
-- max email length trimmed = 34
select max(length(trim(email))) from
    (
    select first_name, last_name, lower(first_name)||'.'||lower(last_name)||'@newnorthwind.com   ' as email from hr.employees
    );

-- 5. Create a query that returns the number of employees with an "a" in their first name. - 70 rows
select count(*) from hr.employees
where regexp_instr(first_name,'A|a') > 0;

-- solution syntax - 70 rows
SELECT count(*)
FROM employees
WHERE instr(upper(first_name),'A') > 0 ;


-- 1. Get a list of all employees who have first names that sound like "daniel" - D540
select soundex('daniel') from dual;

-- 2 rows with D540
select soundex(first_name), first_name, last_name from hr.employees
where soundex(first_name) = soundex('daniel');


/* 9. scalar SQL non-character functions */

-- date/time functions - returns date/time on localhost or server - 6 rows
select sessiontimezone, dbtimezone from dual; -- America/New_York, +00:00

select first_name, last_name, hire_date, to_char(hire_date,'MM/DD/YYYY') as "Hire_date",
to_char(sysdate,'MM/DD/YYYY HH24:MI:SS') as system_date
from hr.employees
where last_name like 'K%';

select to_char(hire_date,'yyyy/mm/dd'), to_char(hire_date,'MONTH DD, YYYY'), to_char(hire_date,'MON DDth, YYYY'),
-- supress zeros - FM prefix
to_char(hire_date,'FMMON DDth, YYYY'), to_char(hire_date,'FMMONTH DD, YYYY'), to_char(hire_date,'FMMon DDth, YYYY')
from hr.employees
where last_name like 'K%';

-- date arithmatic functions

-- months between
select first_name, last_name, hire_date, hire_date + 1, hire_date - 3, next_day(hire_date, 'Tuesday'), add_months(hire_date,2)
from hr.employees
where last_name like 'K%';

select months_between(sysdate,to_date('2006/12/18','yyyy/mm/dd')) from dual; -- 142.4106... months

-- nvl function
select first_name, last_name, salary, commission_pct, nvl(commission_pct,0) as change, salary*nvl(commission_pct,0) as commission
from hr.employees
where last_name like 'K%';

select first_name, last_name, salary, commission_pct, nvl(to_char(commission_pct,'0.99'),'No Commission') as change,
salary*nvl(commission_pct,0) as commission
from hr.employees
where last_name like 'K%';

select first_name, last_name, salary, nvl2(commission_pct,'Has a commission','No commission') as change,
salary*nvl(commission_pct,0) as commission
from hr.employees --hr.emp_details_view
where last_name like 'K%';

-- SQL non-character functions exercise

-- 1. Create a query that selects the department and average salary from the emp_details_view.
select department_name, avg(salary) from hr.emp_details_view
group by department_name
order by avg(salary) desc;

-- 2. Modify the query so that the average salary is truncated.
select department_name, avg(salary) from hr.emp_details_view
group by department_name; 
--order by desc avg(salary);

-- 3. Modify the query so that the average salary is rounded.
select department_name, trunc(avg(salary)) from hr.emp_details_view
group by department_name; 

-- 4. Format the salary so that it includes a dollar sign, decimal point and commas (Hint: $999,999.00).
select department_name, to_char(avg(salary),'$999,999.00') from hr.emp_details_view
group by department_name;

-- 5. Create a query to select the job_id, start_date, end_date from the job_history table.
select job_id, start_date, end_date from hr.job_history;

-- 6. Modify the query so that the start date appears as MM/DD/YYYY format and the end date appears in DAY MONTH D, YYYY format.
select job_id, to_char(start_date,'MM/DD/YYYY'), to_char(end_date,'DAY MONTH, YYYY') from hr.job_history;

-- 7. Round the months between the start date and end date for each record.
select employee_id, round(months_between(end_date,start_date)) as months_at_job 
from hr.job_history; 


/* SQL Data Manipulation Language (DML) */

-- insert
insert into hr.regions
values(5,'Antarctica');
-- check
select * from hr.regions; -- 5 rows
-- remove row
rollback;
-- check
select * from hr.regions; -- 4 rows

describe hr.regions; -- similar to python dtype(s)

insert into hr.regions
values(5,'Antarctica');

commit; -- like GitHub
select * from hr.regions; -- chk: 5 rows

rollback; -- remove all uncommitted transactions
select * from hr.regions; -- chk: still 5 rows?

--best practice: enter field names with insert
insert into hr.regions(region_id,region_name) -- ORA-00001: unique constraint (HR.REG_ID_PK) violated
values(5,'Antarctica');

insert into hr.regions(region_name,region_id)
values('Australia',6);
select * from hr.regions; -- 6 rows

rollback;
select * from hr.regions; -- 5 rows

insert all into hr.regions(region_id,region_name)
values(reg_id,reg_name) -- alias names created in dual table
into hr.countries(country_id, country_name, region_id)
values(ctry_id,ctry_name,reg_id)
select
    7 as reg_id,
    'Africa' as reg_name,
    'ZA' as ctry_id,
    'South Africa' as ctry_name
from dual;

select * from hr.regions; -- 6 rows (removed antarctica with rollback)

-- update
select * from hr.regions
where region_name like 'A%a%a'; -- Antarctica selected

update hr.regions
set region_name = upper(region_name)
where region_name like 'A%a%a'; -- 1 row updated

select * from hr.regions; -- ANTARCTICA

-- delete
select * from hr.regions
where region_name like 'A%A%A'; -- ANTARCTICA

-- safer to use inline query to delete - can still rollback if not commit
delete from hr.regions
where region_id in
    (select region_id from hr.regions
    where region_name like 'A%A%A'
    );

select * from hr.regions; -- ANTARCTICA deleted

-- merge
select * from hr.regions;

create table new_regions as
select
    3 as id,
    'ASIA' as name
from dual;

insert into new_regions(id, name)
values(9, 'MARS');

merge into hr.regions r
using   (
        select *
        from new_regions
        ) n
on (r.region_id = n.id)
when matched then update set r.region_name = n.name
when not matched then insert (r.region_id, r.region_name) values (n.id, n.name);

select * from hr.regions;

delete from hr.regions
where region_id = 9;

update hr.regions set region_name=initcap(region_name)
where region_name ='ASIA';

drop table new_regions;

select * from hr.regions;

-- DML exercise

/*
-- 1. Add a new location with a primary key identifier of 999, an address of 600 Forbes Avenue in Pittsburgh PA (in the US) 
with a zip code of 15282.
*/
insert into hr.locations(location_id, street_address, postal_code, city, state_province, country_id)
values(999,'600 Forbes Avenue','15282','Pittsburgh','PA','US');

-- 2. Change this location address to include "Ave" rather than "Avenue"
update hr.locations set street_address = replace(street_address, 'Avenue', 'Ave')
where location_id = 999;

-- 3. Delete this address based upon its primary key.
delete from hr.locations
where location_id = 999;

-- 4. Rollback the changes.
rollback;


/* NEXT - Oracle PLSQL programming */
