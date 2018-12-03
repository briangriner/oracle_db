-- enable or disable a trigger using alter

-- fire trigger
set serveroutput on
create table x as select * from employees where 0=1;
drop table x;

-- alter trigger
alter trigger creation_alert disable;

select status from user_triggers where trigger_name = 'creation_alert'; -- null status?

create table x as select * from employees where 0=1;

drop table x;

-- enable trigger
alter trigger creation_alert enable;

select status from user_triggers where trigger_name='creation_alert'; -- null - hr connection not monitored?

create table x as select * from employees where 0=1;

drop table x;

