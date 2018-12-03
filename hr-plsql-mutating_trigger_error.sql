-- mutating trigger error
create or replace trigger emp_mutation
after insert or update of salary on employees
for each row

declare
    v_salary employees.salary%type;
begin
    select min(salary) into v_salary from employees;
    
    if :new.salary < v_salary then
        raise_application_error(-20001,'New salary lower than current salary.');
    end if;
end;

-- test - trigger mutation error
insert into employees(employee_id, first_name, last_name, email, hire_date, job_id) 
values(999,'Joe','Mutant','N/A',sysdate,'AD_PRES');
/
/* Error report -
ORA-04091: table HR.EMPLOYEES is mutating, trigger/function may not see it
ORA-06512: at "HR.EMP_MUTATION", line 4
ORA-04088: error during execution of trigger 'HR.EMP_MUTATION'
*/

-- suggestion: try a for statement rather than for row that is triggering the error
