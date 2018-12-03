-- out parameters
/*
create or replace procedure out_param(p_varchar2 out varchar2, p_number out number, p_date out date) as
begin
    p_varchar2 := 'Theo MacNaughton';
    p_number := 2018;
    p_date := to_date('30-Aug-2018','dd-mm-yyyy');
end out_param;
*/

-- call with anon blk - example in video with p_var => p_var didn't work

declare
    v_varchar2 varchar2(200); 
    v_number number;
    v_date date;
begin
    out_param(
        p_varchar2 => v_varchar2,
        p_number => v_number,
        p_date => v_date
    );
    dbms_output.put_line('p_varchar2 = '||v_varchar2);
    dbms_output.put_line('p_number = '||v_number);
    dbms_output.put_line('p_date = '||v_date);
end;
