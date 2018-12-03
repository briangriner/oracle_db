-- grant debug priviledges to user
-- IMPORTANT: MUST BE LOGGED IN AS SYSTEM FIRST

--grant debug any procedure, debug connect session to hr;

-- parameters

-- in parameter
/*
create or replace procedure in_param(p_varchar2 in varchar2, p_number in number, p_date in date) as

begin
    dbms_output.put_line('p_varchar2: '||p_varchar2);
    dbms_output.put_line('p_number: '||p_number);
    dbms_output.put_line('p_date: '||p_date);
end in_param;
*/

-- test proc with anon blk - NO DBMS output?

declare
    p_varchar2 varchar2(200);
    p_number number;
    p_date  date;
begin
    p_varchar2 := null;
    p_number := null;
    p_date := null;
    
    in_param(p_varchar2 => 'Ray Bendure', p_number => 451, p_date => to_date('22-AUG-1920', 'dd-mm-yyyy'));
end;


