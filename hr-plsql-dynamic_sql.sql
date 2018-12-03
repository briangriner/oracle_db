-- dynamic sql
declare
    crs SYS_REFCURSOR;
    v_sql varchar2(4000) := 'select <expression> from employees where salary > :amount';
    v_string_data varchar2(4000);
begin
    --v_sql := replace(v_sql,'<expression>','last_name|| first_name'); -- error using " "?
    v_sql := replace(v_sql, '<expression>', 'employee_id||";"||last_name||";"||first_name||";"||salary'); -- ERRROR: ";" invalid identifier?
    -- using is a bind variable for :amount = 10000
    open crs for v_sql using 10000;
    loop
        fetch crs into v_string_data;    
        exit when crs%notfound;
        dbms_output.put_line(v_string_data);
    end loop;
    close crs;
end; -- ORA-00904: ";": invalid identifier?
