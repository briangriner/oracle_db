-- debug
/*
create or replace procedure bg_proc
is
begin
    dbms_output.put_line('In: '||$$plsql_unit);
    dbms_output.put_line('1st line: '||$$plsql_line);
    dbms_output.put_line('2nd line: '||$$plsql_line);
    dbms_output.put_line('3rd line: '||$$plsql_line);
    
    raise value_error;

exception
    when value_error then
        dbms_output.put_line(dbms_utility.format_error_backtrace);
end;


--run proc - IMPORTANT: MUST COMMENT OUT OR USE NEW WKSHEET TO EXECUTE PROCE ELSE ERROR

--execute bg_proc;

-- REMEMBER: MUST DECLARE PARAMS PASSED TO PROC BUT NO DECLARE STATEMENT USED - AFTER 'IS' & BEFORE 'BEGIN' INSTEAD
-- ALSO: declare var after is and before begin - assign param value to var in subprg after begin

create or replace procedure bg_proc2(bg_num in number)
is
num1 number;
begin
    num1 := bg_num;
    dbms_output.put_line('My number is: '||num1);
    
    raise invalid_number;

exception
    when invalid_number then
        dbms_output.put_line(dbms_utility.format_error_backtrace);
end;
*/

--run proc - IMPORTANT: MUST COMMENT OUT OR USE NEW WKSHEET TO EXECUTE PROCE ELSE ERROR

--execute bg_proc2(3);


-- get_employee proc
/*
create or replace procedure get_employee(empid in employees.employee_id%type)
is
name varchar2(150);

    cursor emp
    is
        select first_name||' '||last_name from employees
        where employee_id = empid;
begin
    open emp;
    fetch emp into name;
    if emp%notfound then
        dbms_output.put_line('Employee not found');
    else
        dbms_output.put_line('Employee name is '||name);
    end if;
end;
*/

--execute get_employee(100);