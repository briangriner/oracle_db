-- create object type

-- create object type specification
create type employee_typ as object
    (
    id number,
    first_name varchar2(20),
    last_name varchar2(20),
    hire_date date,
    salary number,
    
    map 
        member function get_id return number,
        member function to_string return varchar2,
        member function days_service return number,
        member function months_service return number
    ); -- Type EMPLOYEE_TYP compiled


-- create object type body
create or replace type body employee_typ as
map 
    member function get_id return number is
        begin
            return id;
        end;
    member function to_string return varchar2 is
        begin
            return to_char(id)||' '||first_name||' '||last_name||' '||'Salary: '||to_char(salary,'$999,999,999.00');
        end;
    member function days_service return number is
        begin
            return trunc(sysdate - hire_date);
        end;
    member function months_service return number is
        begin
            return months_between(sysdate, hire_date);
        end;
end; -- Type Body EMPLOYEE_TYP compiled

-- create table using object
create table employee_obj_table of employee_typ; -- Table EMPLOYEE_OBJ_TABLE created.

-- insert into table using constructor for object type
insert into employee_obj_table values (employee_typ(101, 'Larry', 'Ellison', sysdate - 365, 30000));
insert into employee_obj_table values (employee_typ(102,'Edward','Codd', sysdate - (2*365), 30000));

-- select from table
select p.last_name, p.days_service() from employee_obj_table p;
/*
Ellison	365
Codd	730
*/

-- value function in object table
select value(p) from employee_obj_table p where p.last_name = 'Ellison'; -- [HR.EMPLOYEE_TYP] - NOT what is returned in video?

-- drop object type and table
drop type employee_typ force; -- Type EMPLOYEE_TYP dropped.
drop table employee_obj_table; -- Table EMPLOYEE_OBJ_TABLE dropped.

