-- validation trigger exercise

-- 1. Create a trigger to raise an error if an employee salary being entered is greater than 25000.
-- 2. Name the trigger TR_VALIDATE_SALARY.
-- 3. The trigger should reference the SALARY field on the EMPLOYEES table.
-- 4. Test the trigger by verifying that you can set the salary of employee_id 100 to an acceptable value but that an error occurs if the salary is above 25000.
-- 5. Drop the trigger when you have finished testing.

create or replace trigger tr_validate_salary
before insert or update of salary on employees
for each row
begin
    if :new.salary > 25000 then
        raise_application_error(-20001, 'Salary > $25,000. Salary entered: '||:new.salary);
    end if;
end;
/

-- test trigger

-- update salary <= $25,000
update employees
set salary = 25000
where employee_id = 100; -- 1 row updated.

-- show
select employee_id, salary from employees
where employee_id = 100;

-- rollback update
rollback;


-- update salary > $25,000
update employees
set salary = 250000
where employee_id = 100; 
/* Error report 
ORA-20001: Salary > $25,000. Salary entered: 250000
ORA-06512: at "HR.TR_VALIDATE_SALARY", line 3
ORA-04088: error during execution of trigger 'HR.TR_VALIDATE_SALARY'
*/

-- drop trigger
drop trigger tr_validate_salary;
