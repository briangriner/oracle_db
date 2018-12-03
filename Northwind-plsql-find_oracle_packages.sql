-- find oracle supplied packages

-- logged in as system (connected to Northwind)
select distinct owner, object_name from SYS.dba_objects
where owner = 'SYS' and object_type = 'PACKAGE'
order by owner, object_type;

-- show subprograms in oracle supplied packages
describe dbms_output;

-- check version of oracle DB
begin
    if DBMS_DB_VERSION.VER_LE_10 then
        dbms_output.put_line('version 10 and earlier');
    elsif DBMS_DB_VERSION.VER_LE_11 then
        dbms_output.put_line('version 11');
    else
        dbms_output.put_line('version 12 and later');
    end if;
end;
/* Error starting at line : 13 in command -
    if DBMS_DB_VERSION.VER_LE_10 then
Error report -
Unknown Command
*/