-- Logon Counter Trigger exercise

-- 1. Create a table called LOGON_COUNT with a single column of type NUMBER named TOTAL_LOGINS with a single row with a value of zero.
-- 2. Create an AFTER LOGON ON SCHEMA trigger that increments this field each time a user logs in.
-- 3. Query the LOGON_COUNT table.
-- 4. Log off and log on. Verify that the count incremented.
-- 5. Check the status in user_objects and user_triggers. Explain the results.
-- 6. Drop the LOGON_COUNT table. Check the status in user_objects and user_triggers.
-- 7. Drop the trigger, and purge the recycle bin.

-- create table logon_cnt(total_logins number(4) default 0);

-- 1. create table
create or replace table logon_count as 
select 0 as total_logins from dual; -- Table LOGON_COUNT created.

-- 2. create trigger
create or replace trigger logon_count_trigger
after logon on schema
begin
    update logon_count
    set total_logins = total_logins + 1;
end;
/

-- 3. query table
select * from logon_count; -- total_logins = 0

-- 4. logoff (disconnect), logon (connect), check hr table
select * from logon_count; -- total_logins = 1

-- 5. check status - user_objects, user_triggers - CASE SENSITIVE values in oracle tables
select status from user_objects where object_name = 'LOGON_COUNT'; -- status = 'VALID'
select status from user_triggers where trigger_name = 'LOGON_COUNT_TRIGGER'; -- status = 'ENABLED'

-- 6. drop table
drop table logon_count; -- Table LOGON_COUNT dropped.

-- 7. drop trigger + purge recycle bin
drop trigger logon_count_trigger; -- Trigger LOGON_COUNT_TRIGGER dropped.

purge recyclebin; -- Recyclebin purged.

