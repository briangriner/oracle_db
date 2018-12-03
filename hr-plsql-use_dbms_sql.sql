-- use dbms_sql package
declare
    v_sql varchar2(32767):= 'select * from employees where rownum = 1';
    v_c number;
    v_execute number;
    v_column_count integer;
    v_recTab DBMS_SQL.DESC_TAB; 
    v_varcharVal varchar2(4000);
    v_numberVal number;
    v_dateVal date;
    v_ret number;
begin
    v_c := DBMS_SQL.OPEN_CURSOR;
    --must have to process sql statement, function will give you a cursor id number
    --must have a parse, check syntax and associates with cursor
    DBMS_SQL.Pearse(v_c, v_sql, DBMS_SQL.NATIVE);
    
    v_execute := DBMS_SQL.EXECUTE(v_c);
    
    DBMS_SQL.DESCRIBE_COLUMNS(v_c, c_columnCount, v_recTab);
    
    FOR j in 1..v_columnCount
    
    LOOP
      CASE v_recTab(j).col_type
        WHEN 1 THEN DBMS_SQL.DEFINE_COLUMN(v_c,j,v_varcharVal,2000);
        WHEN 2 THEN DBMS_SQL.DEFINE_COLUMN(v_c,j,v_numberVal);
        WHEN 12 THEN DBMS_SQL.DEFINE_COLUMN(v_c,j,v_dateVal);
        ELSE DBMS_SQL.DEFINE_COLUMN(v_c,j,v_varcharVal,2000);
      END CASE;
    END LOOP;
    
    LOOP
      v_ret := DBMS_SQL.FETCH_ROWS(v_c);
    EXIT WHEN v_ret = 0;
    
    FOR j in 1..v_columnCount
      LOOP
        CASE v_recTab(j).col_type
          WHEN 1 THEN DBMS_SQL.COLUMN_VALUE(v_c, j, v_varcharVal);
            DBMS_OUTPUT.PUT_LINE(v_recTab(j).col_type || ' ' ||
                      v_recTab(j).col_name || ' ' || v_varcharVal);
          WHEN 2 THEN DBMS_SQL.COLUMN_VALUE(v_c,j,v_numberVal);
            DBMS_OUTPUT.PUT_LINE(v_recTab(j).col_type || ' ' ||
                      v_recTab(j).col_name || ' ' || v_numberVal);
          WHEN 12 THEN DBMS_SQL.COLUMN_VALUE(v_c,j,v_dateVal);
            DBMS_OUTPUT.PUT_LINE(v_recTab(j).col_type || ' ' ||
                      v_recTab(j).col_name || ' ' || v_dateVal);
          ELSE
            DBMS_OUTPUT.PUT_LINE(v_recTab(j).col_type || ' ' ||
                      v_recTab(j).col_name || ' ' || v_varcharVal);
        END CASE;
      END LOOP;
   END LOOP;
END;
/

/*
DECLARE
  v_SQL VARCHAR2(32767) := 'select * from employees where rownum=1';
  v_c 	NUMBER;
  v_execute 	  NUMBER;
  v_columnCount INTEGER;
  v_recTab 	    DBMS_SQL.DESC_TAB;
  v_varcharVal 	VARCHAR2(4000);
  v_numberVal 	NUMBER;
  v_dateVal 	  DATE;
  v_ret 	      NUMBER;  
BEGIN
  v_c := DBMS_SQL.OPEN_CURSOR;
  
  DBMS_SQL.PARSE(v_c, v_SQL, DBMS_SQL.NATIVE);
  
  v_execute := DBMS_SQL.EXECUTE(v_c);
  
  DBMS_SQL.DESCRIBE_COLUMNS(v_c, v_columnCount, v_recTab);
  
  FOR j in 1..v_columnCount
    
    LOOP
      CASE v_recTab(j).col_type
        WHEN 1 THEN DBMS_SQL.DEFINE_COLUMN(v_c,j,v_varcharVal,2000);
        WHEN 2 THEN DBMS_SQL.DEFINE_COLUMN(v_c,j,v_numberVal);
        WHEN 12 THEN DBMS_SQL.DEFINE_COLUMN(v_c,j,v_dateVal);
        ELSE DBMS_SQL.DEFINE_COLUMN(v_c,j,v_varcharVal,2000);
      END CASE;
    END LOOP;
    
    LOOP
      v_ret := DBMS_SQL.FETCH_ROWS(v_c);
    EXIT WHEN v_ret = 0;
    
    FOR j in 1..v_columnCount
      LOOP
        CASE v_recTab(j).col_type
          WHEN 1 THEN DBMS_SQL.COLUMN_VALUE(v_c, j, v_varcharVal);
            DBMS_OUTPUT.PUT_LINE(v_recTab(j).col_type || ' ' ||
                      v_recTab(j).col_name || ' ' || v_varcharVal);
          WHEN 2 THEN DBMS_SQL.COLUMN_VALUE(v_c,j,v_numberVal);
            DBMS_OUTPUT.PUT_LINE(v_recTab(j).col_type || ' ' ||
                      v_recTab(j).col_name || ' ' || v_numberVal);
          WHEN 12 THEN DBMS_SQL.COLUMN_VALUE(v_c,j,v_dateVal);
            DBMS_OUTPUT.PUT_LINE(v_recTab(j).col_type || ' ' ||
                      v_recTab(j).col_name || ' ' || v_dateVal);
          ELSE
            DBMS_OUTPUT.PUT_LINE(v_recTab(j).col_type || ' ' ||
                      v_recTab(j).col_name || ' ' || v_varcharVal);
        END CASE;
      END LOOP;
   END LOOP;
END;
/
*/
    