-- ddl modify trigger

create trigger creation_alert
after create on schema
begin
    dbms_output.put_line('Something has been created in the DB');
end; -- Trigger CREATION_ALERT compiled
/

-- modify trigger
create or replace trigger creation_alert
after create on schema
begin
    dbms_output.put_line(ora_dict_obj_type||' '||ora_dict_obj_name||' has been created in the DB');
end; -- Trigger CREATION_ALERT compiled

-- test trigger
create table test_trigger(id int, fname varchar2(20)); -- Table TEST_TRIGGER created. - ERROR if use create OR REPLACE

drop table test_trigger;