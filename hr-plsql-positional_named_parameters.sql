-- use positional & named parameters

-- SQL: positional

select test_package.f2('x') from dual;

-- SQL: named

select test_package.f2(p_x => 'x') from dual;

-- check if named param not in function

select test_package.f2(p_y => 'x') from dual; -- ORA-06553: PLS-306: wrong number or types of arguments in call to 'F2'

-- CAN ONLY USED NAMED PARAMS IN SQL IN ORACLE VERSIONS 11G + 

-- PLSQL: named

begin
    dbms_output.put_line(test_package.f2(p_x => 'x'));
end;

