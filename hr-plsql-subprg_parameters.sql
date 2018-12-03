-- PL/SQL Subprograms with Parameters

-- 1. Recall the first format_phone function you created in the previous challenge exercise. Review it. 
    -- NOTE: This is the format_phone function that does NOT use regular expressions. 
    -- Or, if you did not complete the challenge exercise, review the provided function in the exercises folder.
-- 2. Modify the function to use an input parameter instead of a hard coded variable value. 
    -- Compile and test the function using '123.456.7890' as the input parameter.


-- compile
create or replace function fphone2(p_num1 in out varchar2)
return varchar2
is
    num1 varchar2(50) := p_num1;
    fnum1 varchar2(50);
begin
    fnum1 := '('||substr(num1,1,3)||') '||replace(substr(num1,5,12),'.','-')||'.';
    return fnum1;
end;

-- test
declare
    user_num varchar2(50) := '123.456.7890';
begin
    dbms_output.put_line('The formatted phone number is '||fphone2(user_num));
end;  -- The formatted phone number is (123) 456-7890.

   
-- 3. This function will be used with phone numbers provided in the employees.phone_number field. 
    -- Modify the input parameter and variables to reflect this.
    
-- compile
create or replace function fphone3(p_num1 in employees.phone_number%type)
return varchar2
is
    v_num1 employees.phone_number%type; -- := p_num1;
    -- fnum1 varchar2(50);
begin
    v_num1 := '('||substr(p_num1,1,3)||') '||replace(substr(p_num1,5,12),'.','-')||'.';
    return v_num1;
end; -- Function FPHONE3 compiled


/* 1/28      PLS-00201: identifier 'EMPLOYEES.PHONE_NUMBER' must be declared
Errors: check compiler log */


-- 4. Some values in the employee phone number field are for international phone numbers. 
    -- Modify the function so that it only processes U.S. phone numbers in the format reflected in the test value specified previously. 
    -- If a phone number is not in U.S. format, simply return the original value.

create or replace function fphone4(p_num1 in employees.phone_number%type)
return varchar2
is
    v_num1 employees.phone_number%type;
begin
    if length(p_num1) = 12 and instr(p_num1,'.') = 4 and instr(p_num1,5,'.') = 8 then
        v_num1 := '('||substr(p_num1,1,3)||') '||replace(substr(p_num1,5,12),'.','-');
        return v_num1;
    else
        return p_num1;
    end if;
end;

-- test using sql and calling function

select phone_number, fphone4(phone_number) from employees;

/* Error report -
ORA-06550: line 16, column 1:
PLS-00103: Encountered the symbol "CREATE" 
06550. 00000 -  "line %s, column %s:\n%s"
*Cause:    Usually a PL/SQL compilation error.
*Action: */

-- 5. Write a new stored procedure called employee_report that takes a sys_refcursor as an out parameter.

create or replace procedure employee_report(c out sys_refcursor)
is
begin
    dbms_output.put_line('stored procedure - employee_report');
end;
    
-- 6. Modify the procedure so that it opens a cursor for a query that returns the employee first name, last name, 
    -- and formatted phone number from the employees table (sort by the last name and first name).
    
create or replace procedure employee_report(c out sys_refcursor)
is
begin
    open c for
    select last_name, first_name, fphone4(phone_number) from employees
    order by last_name, first_name;
end;

-- 7. Write an anonymous block to test the stored procedure.
 declare 
    cr sys_refcursor;
    fname employees.first_name%type;
    lname employees.last_name%type;
    phone employees.phone_number%type;
    -- tab char(1) := chr(9); -- returns varchar2 - converts ascii code for tab 9 into char
begin
    employee_report(cr);
    loop
        fetch cr into fname, lname, phone;
        exit when cr%notfound;
        dbms_output.put_line(fname||','||lname||','||'    '||phone);
    end loop;
    close cr;
end;



-- compile
create or replace function fphone2(p_num1 in varchar2)
return varchar2
is
    num1 varchar2(50) := p_num1;
    fnum1 varchar2(50);
begin
    fnum1 := '('||substr(num1,1,3)||') '||replace(substr(num1,5,12),'.','-')||'.';
    return fnum1;
end;  -- Function FPHONE compiled

-- test
begin
    dbms_output.put_line('The formatted phone number is '||fphone2('123.456.7890'));
end; -- The formatted phone number is (123) 456-7890.

