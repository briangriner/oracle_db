-- convert int to bool
/*
declare
    l boolean := null; -- false; -- true;

begin
    case
    when sys.diutil.bool_to_int(l)=1 then
        dbms_output.put_line('l is True');
    when sys.diutil.bool_to_int(l)<>1 then
        dbms_output.put_line('l is False');
    when sys.diutil.bool_to_int(l) is null then
        dbms_output.put_line('l is null');
    end case;
end;
*/

-- convert bool to int

declare
    l integer := 0; -- 1; -- null; -- false; -- true;

begin
    case
    when sys.diutil.int_to_bool(l)= true then
        dbms_output.put_line('l is True');
    when sys.diutil.int_to_bool(l)<> true then
        dbms_output.put_line('l is False');
    else
        dbms_output.put_line('l is null');
    end case;
end;

/*
    when sys.diutil.bool_to_int(l) is null then
        dbms_output.put_line('l is null');
    end case;
end;
*/