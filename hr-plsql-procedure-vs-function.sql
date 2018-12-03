/*
create or replace procedure test3
is
v_name varchar2(25);
begin
    v_name := 'Brian';
    dbms_output.put_line('Hello '||v_name||' from a stored procedure');
end;

--execute test3;

create or replace function test2
return varchar2
is
begin
    return 'Hello from a function';
end;
*/

--select test2 from dual;
