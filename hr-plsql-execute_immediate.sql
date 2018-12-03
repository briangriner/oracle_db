-- execute immediate statement - used with bind var, e.g. :id
declare
    v_sql varchar2(200):='select <expression> from employees where employee_id = :id';
    v_string_data varchar2(4000);
begin
    v_sql := replace(v_sql, '<expression>', 'last_name');
    execute immediate v_sql into v_string_data using 101;
    dbms_output.put_line(v_string_data);
end; -- PL/SQL procedure successfully completed. - output: Kochhar
-- GOT AN ERROR UNLESS I CUT AND PASTED VAR NAMES FROM DECLARE?