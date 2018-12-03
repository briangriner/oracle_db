-- create test package

create or replace package test_package as
    function f1 return varchar2;
    function f2(p_x in varchar2) return varchar2;
    -- no function f3
    function f4 return varchar2;
end test_package;


-- create package body

create or replace package body test_package as

    function f1 return varchar2 as
    begin
        return 'In f1.';
    end f1;
    
    function f2(p_x in varchar2) return varchar2 as
    begin
        return 'In f2.';
    end f2;
    
    function f3 return varchar2 as
    begin
        return 'In f3.';
    end f3;
    
    function f4 return varchar2 as
    begin
        return f3;
    end f4;

end test_package;


-- test pkg

select test_package.f1() from dual;

select test_package.f2() from dual; -- errors

select test_package.f3() from dual; -- errors

select test_package.f4() from dual;
