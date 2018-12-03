-- Use Oracle Object Features

/*
1. Create an object type named car_typ. It should include the attributes for id (NUMBER), maker(VARCHAR2), model_name(VARCHAR2), 
    --year_made (NUMBER) and miles per gallon (NUMBER). It should include functions to get the id and 
    --a string representation of an instance, as well as a function to determine the age of the car (in years) and 
    --the gallons needed to drive a given number of miles.
2. Create the implementation for the car_typ listed above.
3. Create a table named car_obj_table to hold instances if this class.
4. Create a car instance with id set to 101, maker set to Ford, model_name set to Torino, year set to 1971, and 
    --miles per gallon set to 11.
5. Create a query to select the maker, model, age and gallons needed to travel 22 miles for the instance created.
6. Remove the car_obj_table and type car_typ.
*/

-- create obj type
create or replace type car_typ is object (
    id number,
    maker varchar2(25),
    model_name varchar2(25),
    year_made number,
    mpg number,
    
    map
        member function get_id return number,
        member function to_string return varchar2,
        member function age return number,
        member function gallons_needed(v_miles varchar2) return number
    ); -- Type CAR_TYP compiled
/
   
-- create obj type body
create or replace type body car_typ as
map 
    member function get_id return number is
    begin
        return id;
    end;
    member function to_string return varchar2 is
    begin
        return to_char(id) || ' ' || maker || ' ' || model_name || ' ' || year_made || ' ' || mpg; 
    end;
member function age return number is
    begin
        return trunc(months_between(sysdate, to_date('01/01' || year_made, 'MM/DD/YYYY'))/12);
    end;
member function gallons_needed(v_miles varchar2) return number is
    begin
        return round(v_miles / mpg);
    end;
end;
/


-- create table
create table car_obj_table of car_typ;


-- insert into table using object type
insert into car_obj_table
values(car_typ(101, 'Ford', 'Torino', 1971, 11));

-- query object table
select cot.maker, cot.model_name, cot.age(), cot.gallons_needed(22) from car_obj_table cot;

-- drop table and type
drop table car_obj_table;

drop type car_typ;
