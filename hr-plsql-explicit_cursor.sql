-- explicit cursor
/*
create or replace procedure return_cursor(p_cursor in out SYS_REFCURSOR) as
begin
    open p_cursor for
        select * from employees;
    end return_cursor;
*/

declare 
    c sys_refcursor;
    rec employees%rowtype;
begin
    return_cursor(p_cursor => c);
    loop
        fetch c into rec;
        exit when c%notfound;
        dbms_output.put_line('Name '||rec.first_name||' '||rec.last_name);
    end loop;
    close c;
end;
