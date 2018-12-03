-- how to use dbms_output
declare
    my_out dbms_output.chararr;
    linenum integer := 20;
begin
    my_out(1) := 'This is my first line';
    my_out(17) := 'This is my second line';
    
    dbms_output.put_line('Show first line: '||my_out(1));
    dbms_output.put_line('Show second line: '||my_out(17));
    
    dbms_output.get_lines(my_out,linenum);
    dbms_output.put_line('number of lines: '||to_char(linenum));
    
    for i in 1..linenum 
    loop
        dbms_output.put_line('Show first line: '||my_out(i));
    end loop;
end; -- PL/SQL procedure successfully completed.
/* number of lines: 2
Show first line: Show first line: This is my first line
Show first line: Show second line: This is my second line
*/

    
    