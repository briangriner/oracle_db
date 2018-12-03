-- 4. Add code that increments the salary by 5% per year (Compound interest)

DECLARE
    v_name VARCHAR2(45) := 'Larry Ellison';
    v_starting_salary NUMBER := 1;
    v_current_salary number := v_starting_salary;
    v_new_salary number := 0;
    v_raise_amt number := 0.05;
    v_start_date DATE := sysdate;
    v_current_date date;

begin
    for i in 1..10
    loop
        dbms_output.put_line(i);
        dbms_output.put_line('Name: '||v_name);
        dbms_output.put_line('Start Date: '||v_start_date);
        dbms_output.put_line('Starting salary: ' ||trim(to_char(v_starting_salary,'$999,999,999.00')));
        -- add 12 months * number of years (i) to current date
        v_current_date := add_months(v_start_date,12*i);
        dbms_output.put_line('Current date: '||v_current_date);
        dbms_output.put_line('Current salary: '||trim(to_char(v_current_salary,'$999,999,999.00')));
        -- increase salary by 5% annually with compound interest = future_salary*(1+r)^t
        v_new_salary := v_starting_salary * power((1 + v_raise_amt), i); -- OR just v_salary := v_salary*1.05;
        dbms_output.put_line('New salary with raise of '||v_raise_amt*100||'% will be '||trim(to_char(v_new_salary,'$999,999,999.00')));
        v_current_salary := v_new_salary;
    end loop;
end;


-- solution syntax
DECLARE
  v_name VARCHAR2(45) := 'Larry Ellison';
  v_current_date DATE := current_date;
  v_salary NUMBER     := 1.00;  
BEGIN

  FOR i IN 1..10 LOOP
    
    dbms_output.put(lpad(i,2));
    dbms_output.put(' ' || v_name);
    dbms_output.put(' ' ||
                    trim(to_char(v_salary,'$999,999,999.00')));
    dbms_output.put_line(' ' || v_current_date);
 
    v_current_date := add_months(v_current_date,12);
    v_salary := v_salary + (v_salary * (i * .05)); -- is this the formula for compounding interest? Don't we want the current salary
    
  END LOOP;
  
END;
