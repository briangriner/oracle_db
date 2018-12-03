-- how to use a cursor parameter

declare
    cursor crs(fname varchar2) is
        select * from employees
        where first_name = fname
        order by first_name;
    
    rec employees%rowtype;
begin
    open crs('David');
        loop
            fetch crs into rec;
            exit when crs%notfound;
            dbms_output.put_line(rec.first_name||' '||rec.last_name);
        end loop;
    close crs;
end; -- PL/SQL procedure successfully completed.
/

/* returned:
vDavid Austin
David Bernstein
David Lee
*/

