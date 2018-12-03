-- show compile errors

begin
    dbms_output.put_line('Line number: '||$$plsql_line);
    dbms_output.put_line('Unit: '||coalesce($$plsql_unit, 'anonymous block'));
    
    raise value_error;
    
exception
    when value_error then
        dbms_output.put_line(dbms_utility.format_error_backtrace);
end;

-- error example proc

create or replace procedure error_example(i1 in number := 2, i2 in number := 3, i3 in number := 4) as
begin
    l1 := i2 + i3;
end;

show errors;

select * from user_errors;