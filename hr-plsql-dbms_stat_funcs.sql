-- dbms_stat_funcs
select lpad(to_char(min(salary),'9,999.99'),25) "min", lpad(to_char(max(salary),'999,999,999.99'),25) "max",
    lpad(to_char(avg(salary),'9,999.99'),25) "avg", lpad(to_char(variance(salary),'999,999,999.99'),25) "var",
    lpad(to_char(stddev(salary),'9,999.99'),25) "stddev" from employees;
/
-- 2,100.00, 24,000.00, 6,461.83, 15,284,813.67, 3,909.58

declare
    sig number := 3;
    s dbms_stat_funcs.SummaryType;
begin
    dbms_stat_funcs.summary('HR','EMPLOYEES', 'SALARY', sig, s);
    
    dbms_output.put_line('Min:      '||lpad(to_char(s.min,'9,999.99'), 25));
    dbms_output.put_line('Max:      '||lpad(to_char(s.max(salary),'999,999,999.99'),25));
    dbms_output.put_line('Mean:     '||lpad(to_char(s.mean(salary),'9,999.99'),25)); 
    dbms_output.put_line('Variance: '||lpad(to_char(s.variance(salary),'999,999,999.99'),25));
    dbms_output.put_line('Std Dev:  '||lpad(to_char(s.stddev(salary),'9,999.99'),25));
end;
/* Error report -
ORA-06550: line 8, column 58:
PLS-00224: object 'S.MAX' must be of type function or array to be used this way
*/