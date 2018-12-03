-- Subprogram Information in the Oracle Data Dictionary

/* 
1. Create the procedure by executing the script in the Demo below.
2. Locate general information in the Oracle Data Dictionary about the procedure (as well as SQL Developer).
3. Display the Source Code using the Data Dictionary (as well as SQL Developer).
4. Remove the trailing semicolon following the NULL statement from the procedure and compile the procedure again.
5. Look at the results in user source (and notice that the change is reflected here).
6. Retrieve error information from the Oracle Data Dictionary using a query 
    (and notice where the error shows up in SQL Developer). Determine the status of the object by looking at USER_OBJECTS.
7. Add the trailing semicolon following the NULL statement from the procedure and compile the procedure again 
    (it should be valid now). Check the status of the object in USER_OBJECTS.
*/

-- 1. run subprogram
create or replace procedure a_simple_subprogram
is
begin
   null;
end;

-- 2. oracle data dict
select * from user_procedures;

-- 3. oracle source code
select * from user_source 
where name like 'A_SIMPLE%'
order by name, type, line;

-- 4. 
create or replace procedure a_simple_subprogram
is
begin
   null
end;

-- 5. 
select * from user_source 
where name like 'A_SIMPLE%'
order by name, type, line;

-- 6.
select * from user_errors
where name like 'A_S%';

-- 7.
create or replace procedure a_simple_subprogram
is
begin
   null;
end;

select * from user_objects
where object_name like 'A_SIM%';