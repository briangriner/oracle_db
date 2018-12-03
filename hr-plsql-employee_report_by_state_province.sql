-- Employee Report by State/Province

/*
1. Create a stored procedure named employee_report_by_state_prov.
2. Modify the procedure so that it takes an input parameter named v_state of type varchar2.
3. Create a cursor that takes a cursor variable called state of type varchar2. 
    --The query should select all columns from the EMP_DETAILS_VIEW and 
    --return rows that have a STATE_PROVINCE column that matches the state parameter. 
    --Sort the results by last name followed by first name.
4. In the body of the procedure, open the cursor using the parameter passed in through v_state.
5. Loop through the results and output the first name, last name and job id.
6. Test the procedure using Texas, Washington and Bavaria.
*/

-- create stored procedure
create or replace procedure employee_report_by_state_prov(v_state in varchar2) is
    cursor cur(state in varchar2) is
        select * from emp_details_view where state_province = state
        order by last_name, first_name;
    rec emp_details_view%rowtype;
begin
    open cur(v_state);
    loop
        fetch cur into rec;
        exit when cur%notfound;
        dbms_output.put_line(rec.first_name||' '||rec.last_name||' '||rec.job_id||' '||rec.state_province);
    end loop;
    close cur;
end; -- Procedure EMPLOYEE_REPORT_BY_STATE_PROV compiled

-- test
begin 
    employee_report_by_state_prov(v_state => 'Texas');
    employee_report_by_state_prov(v_state => 'Washington');
    employee_report_by_state_prov(v_state => 'Bavaria');
end;

/*
David Austin IT_PROG Texas
Bruce Ernst IT_PROG Texas
Alexander Hunold IT_PROG Texas
Diana Lorentz IT_PROG Texas
Valli Pataballa IT_PROG Texas
Shelli Baida PU_CLERK Washington
John Chen FI_ACCOUNT Washington
Karen Colmenares PU_CLERK Washington
Lex De Haan AD_VP Washington
Daniel Faviet FI_ACCOUNT Washington
William Gietz AC_ACCOUNT Washington
Nancy Greenberg FI_MGR Washington
Shelley Higgins AC_MGR Washington
Guy Himuro PU_CLERK Washington
Alexander Khoo PU_CLERK Washington
Steven King AD_PRES Washington
Neena Kochhar AD_VP Washington
Luis Popp FI_ACCOUNT Washington
Den Raphaely PU_MAN Washington
Ismael Sciarra FI_ACCOUNT Washington
Sigal Tobias PU_CLERK Washington
Jose Manuel Urman FI_ACCOUNT Washington
Jennifer Whalen AD_ASST Washington
Hermann Baer PR_REP Bavaria
*/