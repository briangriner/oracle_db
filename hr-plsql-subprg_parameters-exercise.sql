-- PL/SQL Subprograms with Parameters

-- 1. Recall the first format_phone function you created in the previous challenge exercise. Review it. 
    -- NOTE: This is the format_phone function that does NOT use regular expressions. 
    -- Or, if you did not complete the challenge exercise, review the provided function in the exercises folder.
-- 2. Modify the function to use an input parameter instead of a hard coded variable value. 
    -- Compile and test the function using '123.456.7890' as the input parameter.

-- compile
/*
create or replace function fphone2(p_num1 in varchar2)
return varchar2
is
    num1 varchar2(50) := p_num1;
    fnum1 varchar2(50);
begin
    fnum1 := '('||substr(num1,1,3)||') '||replace(substr(num1,5,12),'.','-')||'.';
    return fnum1;
end;

-- test
declare
    user_num varchar2(50) := '123.456.7890';
begin
    dbms_output.put_line('The formatted phone number is '||fphone2(user_num));
end;  -- The formatted phone number is (123) 456-7890.

-- 3. This function will be used with phone numbers provided in the employees.phone_number field. 
    -- Modify the input parameter and variables to reflect this.

-- compile
create or replace function fphone2b(p_num1 in employees.phone_number%type)
return varchar2
is
    v_num1 employees.phone_number%type; 
begin
    v_num1 := '(' || substr(p_num1,1,3) || ') ' || substr(p_num1,5,3) || '-' || substr(p_num1,9,4);
    return v_num1;
end; -- Function FPHONE2B compiled

-- 4. Some values in the employee phone number field are for international phone numbers. 
    -- Modify the function so that it only processes U.S. phone numbers in the format reflected in the test value specified previously. 
    -- If a phone number is not in U.S. format, simply return the original value.

create or replace function fphone2c(p_num1 in employees.phone_number%type)
return varchar2
is
    v_num1 employees.phone_number%type;
begin
  IF length(p_num1) = 12 and instr(p_num1,'.') = 4 and instr(p_num1,'.', 5) = 8 THEN
    v_num1 := '(' || substr(p_num1,1,3) || ') ' || substr(p_num1,5,3) || '-' || substr(p_num1,9,4);
    return v_num1;
  ELSE
    return p_num1;
  END IF;
END; -- Function FPHONE2C compiled
/
select phone_number, fphone2c(phone_number) from employees; -- worked

-- 5. Write a new stored procedure called employee_report that takes a sys_refcursor as an out parameter.

create or replace procedure employee_report(c out sys_refcursor)
is
begin
    dbms_output.put_line('stored procedure - employee_report');
end; -- Procedure EMPLOYEE_REPORT compiled
    
-- 6. Modify the procedure so that it opens a cursor for a query that returns the employee first name, last name, 
    -- and formatted phone number from the employees table (sort by the last name and first name).
    
create or replace procedure employee_report(c out sys_refcursor)
is
begin
    open c for
    select last_name, first_name, fphone2c(phone_number) from employees
    order by last_name, first_name;
end;

-- 7. Write an anonymous block to test the stored procedure.
 declare 
    cr sys_refcursor;
    fname employees.first_name%type;
    lname employees.last_name%type;
    phone employees.phone_number%type;
    -- tab char(1) := chr(9); -- returns varchar2 - converts ascii code for tab 9 into char
begin
    employee_report(cr);
    loop
        fetch cr into fname, lname, phone;
        exit when cr%notfound;
        dbms_output.put_line(fname||','||lname||','||'    '||phone);
    end loop;
    close cr;
end;
*/

/*
The formatted phone number is (123) 456-7890.

Abel,Ellen,    011.44.1644.429267
Ande,Sundar,    011.44.1346.629268
Atkinson,Mozhe,    (650) 124-6234
Austin,David,    (590) 423-4569
Baer,Hermann,    (515) 123-8888
Baida,Shelli,    (515) 127-4563
Banda,Amit,    011.44.1346.729268
Bates,Elizabeth,    011.44.1343.529268
Bell,Sarah,    (650) 501-1876
Bernstein,David,    011.44.1344.345268
Bissot,Laura,    (650) 124-5234
Bloom,Harrison,    011.44.1343.829268
Bull,Alexis,    (650) 509-2876
Cabrio,Anthony,    (650) 509-4876
Cambrault,Gerald,    011.44.1344.619268
Cambrault,Nanette,    011.44.1344.987668
Chen,John,    (515) 124-4269
Chung,Kelly,    (650) 505-1876
Colmenares,Karen,    (515) 127-4566
Davies,Curtis,    (650) 121-2994
De Haan,Lex,    (515) 123-4569
Dellinger,Julia,    (650) 509-3876
Dilly,Jennifer,    (650) 505-2876
Doran,Louise,    011.44.1345.629268
Ernst,Bruce,    (590) 423-4568
Errazuriz,Alberto,    011.44.1344.429278
Everett,Britney,    (650) 501-2876
Faviet,Daniel,    (515) 124-4169
Fay,Pat,    (603) 123-6666
Feeney,Kevin,    (650) 507-9822
Fleaur,Jean,    (650) 507-9877
Fox,Tayler,    011.44.1343.729268
Fripp,Adam,    (650) 123-2234
Gates,Timothy,    (650) 505-3876
Gee,Ki,    (650) 127-1734
Geoni,Girard,    (650) 507-9879
Gietz,William,    (515) 123-8181
Grant,Douglas,    (650) 507-9844
Grant,Kimberely,    011.44.1644.429263
Greenberg,Nancy,    (515) 124-4569
Greene,Danielle,    011.44.1346.229268
Hall,Peter,    011.44.1344.478968
Hartstein,Michael,    (515) 123-5555
Higgins,Shelley,    (515) 123-8080
Himuro,Guy,    (515) 127-4565
Hunold,Alexander,    (590) 423-4567
Hutton,Alyssa,    011.44.1644.429266
Johnson,Charles,    011.44.1644.429262
Jones,Vance,    (650) 501-4876
Kaufling,Payam,    (650) 123-3234
Khoo,Alexander,    (515) 127-4562
King,Janette,    011.44.1345.429268
King,Steven,    (515) 123-4567
Kochhar,Neena,    (515) 123-4568
Kumar,Sundita,    011.44.1343.329268
Ladwig,Renske,    (650) 121-1234
Landry,James,    (650) 124-1334
Lee,David,    011.44.1346.529268
Livingston,Jack,    011.44.1644.429264
Lorentz,Diana,    (590) 423-5567
Mallin,Jason,    (650) 127-1934
Markle,Steven,    (650) 124-1434
Marlow,James,    (650) 124-7234
Marvins,Mattea,    011.44.1346.329268
Matos,Randall,    (650) 121-2874
Mavris,Susan,    (515) 123-7777
McCain,Samuel,    (650) 501-3876
McEwen,Allan,    011.44.1345.829268
Mikkilineni,Irene,    (650) 124-1224
Mourgos,Kevin,    (650) 123-5234
Nayer,Julia,    (650) 124-1214
OConnell,Donald,    (650) 507-9833
Olsen,Christopher,    011.44.1344.498718
Olson,TJ,    (650) 124-8234
Ozer,Lisa,    011.44.1343.929268
Partners,Karen,    011.44.1344.467268
Pataballa,Valli,    (590) 423-4560
Patel,Joshua,    (650) 121-1834
Perkins,Randall,    (650) 505-4876
Philtanker,Hazel,    (650) 127-1634
Popp,Luis,    (515) 124-4567
Rajs,Trenna,    (650) 121-8009
Raphaely,Den,    (515) 127-4561
Rogers,Michael,    (650) 127-1834
Russell,John,    011.44.1344.429268
Sarchand,Nandita,    (650) 509-1876
Sciarra,Ismael,    (515) 124-4369
Seo,John,    (650) 121-2019
Sewall,Sarath,    011.44.1345.529268
Smith,Lindsey,    011.44.1345.729268
Smith,William,    011.44.1343.629268
Stiles,Stephen,    (650) 121-2034
Sullivan,Martha,    (650) 507-9878
Sully,Patrick,    011.44.1345.929268
Taylor,Jonathon,    011.44.1644.429265
Taylor,Winston,    (650) 507-9876
Tobias,Sigal,    (515) 127-4564
Tucker,Peter,    011.44.1344.129268
Tuvault,Oliver,    011.44.1344.486508
Urman,Jose Manuel,    (515) 124-4469
Vargas,Peter,    (650) 121-2004
Vishney,Clara,    011.44.1346.129268
Vollman,Shanta,    (650) 123-4234
Walsh,Alana,    (650) 507-9811
Weiss,Matthew,    (650) 123-1234
Whalen,Jennifer,    (515) 123-4444
Zlotkey,Eleni,    011.44.1344.429018
*/

-- challenge: regexp

create or replace function fphone2d(p_num1 in employees.phone_number%type)
return varchar2
is
    v_num1 employees.phone_number%type;
begin
    if regexp_instr(p_num1, '(\d{3})\.(\d{3})\.(\d{4})') = 1 then
        v_num1 := regexp_replace(p_num1, '(\d{3})\.(\d{3})\.(\d{4})', '(\1) \2-\3');
        return v_num1;
  else
    return p_num1;
  end if;
end; -- Function FPHONE2D compiled
/
select phone_number, fphone2d(phone_number) formated_phone from employees; -- worked
