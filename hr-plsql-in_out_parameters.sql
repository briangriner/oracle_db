-- in out parameter
/*
create or replace procedure in_out_param(p_in_out in out varchar2) as
begin
    p_in_out := 'This value was set within the procedure';
end in_out_param;
*/

-- call with anon blk

declare
    p_in_out varchar2(50) := 'This is the value going in ...';
begin
    in_out_param(p_in_out);
    dbms_output.put_line('p_in_out = '||p_in_out);
end;

