-- executing blocks and functions exercise

-- 1. Using a SQL*Plus/SQL Developer command, call a procedure in an Oracle supplied package to print out "Hello Universe!".

exec dbms_output.put_line('Hello Universe!'); -- MUST highlight cmds or error! - double quotes create an error also

-- 2. Create and execute a call to the same procedure that will print out "Hello Universe!" using an anonymous block.

begin
    dbms_output.put_line('Hello Universe!'); -- don't forget ; on cmd and use single quotes or error
end;

-- 3. Execute a function call to print out the structure of the JOBS table using a function from an Oracle supplied package.

select dbms_metadata.get_ddl('TABLE', 'JOBS') from dual; -- must use CAPS for function parameters
