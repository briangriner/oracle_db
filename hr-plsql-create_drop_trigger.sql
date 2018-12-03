-- db triggers

-- business rule - new email = first initial + last name 1st 8 chars

select substr(upper(substr(first_name,1,1)||last_name),1,8) as "new_email", email, e.first_name, e.last_name 
from employees e
where substr(upper(substr(first_name,1,1)||last_name),1,8) != email;

-- create trigger - will fire on each row
    -- uses the colon new - ':new'

create or replace trigger tr_set_email
before insert or update of first_name, last_name, email on employees
for each row
begin
    :new.email := substr(upper(substr(:new.first_name,1,1)||:new.last_name),1,8);
end;
/

-- check trigger with insert

insert into employees(EMPLOYEE_ID, FIRST_NAME, LAST_NAME, HIRE_DATE, JOB_ID)
values(employees_seq.nextval,'Tony','Stark','20-Jul-69','FI_ACCOUNT'); 
--ORA-02291: integrity constraint (HR.EMP_JOB_FK) violated - parent key not found - job_id is case sensitive in jobs table

select email from employees where last_name = 'Stark';

-- next example

select * from employees where email = 'JMURMAN'; -- ORA-00942: table or view does not exist

update employees set email=email where email = 'JMURMAN';

select email from employees where last_name = 'Urman';

-- restore the original data
rollback;

-- drop trigger
drop trigger tr_set_email;

