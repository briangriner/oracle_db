-- wrap utility - used to hide source code
-- have to run from cmd line as admin

-- example ... 

-- create test package

create or replace package test_package as
    function f1 return varchar2;
    function f2(p_x in varchar2) return varchar2;
    -- no function f3
    function f4 return varchar2;
end test_package;