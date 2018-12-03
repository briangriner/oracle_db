-- create cursor variables

-- strong cursor var type - returns specific var type
declare
    type EmpCurType is ref cursor return employees%rowtype;
    rc EmpCurType;
    rec employees%rowtype;
begin
    open rc for
        select * from employees;
        loop
            fetch rc into rec;
            exit when rc%notfound;
            dbms_output.put_line(rec.first_name||' '||rec.last_name);
        end loop;
    close rc;
end; -- PL/SQL procedure successfully completed.

-- weak cursor var type
declare
    rc sys_refcursor;
    rec employees%rowtype;
begin
    open rc for
        select * from employees;
        loop
            fetch rc into rec;
            exit when rc%notfound;
            dbms_output.put_line(rec.first_name||' '||rec.last_name);
        end loop;
    close rc;
end; -- PL/SQL procedure successfully completed.

-- weak cur type that points to different cursors
declare
    rc sys_refcursor;
    v_string_data varchar2(400);
    v_switch number := 1;
begin
    if v_switch = 1 then
        open rc for select first_name from employees;
    else
        open rc for select department_name from departments;
    end if;
    loop
        fetch rc into v_string_data;
        exit when rc%notfound;
        dbms_output.put_line(v_string_data);
    end loop;
    close rc;
end; -- PL/SQL procedure successfully completed.

/* last query results -
Ellen
Sundar
Mozhe
David
Hermann
Shelli
Amit
Elizabeth
Sarah
David
Laura
Harrison
Alexis
Anthony
Gerald
Nanette
John
Kelly
Karen
Curtis
Lex
Julia
Jennifer
Louise
Bruce
Alberto
Britney
Daniel
Pat
Kevin
Jean
Tayler
Adam
Timothy
Ki
Girard
William
Douglas
Kimberely
Nancy
Danielle
Peter
Michael
Shelley
Guy
Alexander
Alyssa
Charles
Vance
Payam
Alexander
Janette
Steven
Neena
Sundita
Renske
James
David
Jack
Diana
Jason
Steven
James
Mattea
Randall
Susan
Samuel
Allan
Irene
Kevin
Julia
Donald
Christopher
TJ
Lisa
Karen
Valli
Joshua
Randall
Hazel
Luis
Trenna
Den
Michael
John
Nandita
Ismael
John
Sarath
Lindsey
William
Stephen
Martha
Patrick
Jonathon
Winston
Sigal
Peter
Oliver
Jose Manuel
Peter
Clara
Shanta
Alana
Matthew
Jennifer
Eleni
*/

/* same result for queries 1 and 2 -
Steven King
Neena Kochhar
Lex De Haan
Alexander Hunold
Bruce Ernst
David Austin
Valli Pataballa
Diana Lorentz
Nancy Greenberg
Daniel Faviet
John Chen
Ismael Sciarra
Jose Manuel Urman
Luis Popp
Den Raphaely
Alexander Khoo
Shelli Baida
Sigal Tobias
Guy Himuro
Karen Colmenares
Matthew Weiss
Adam Fripp
Payam Kaufling
Shanta Vollman
Kevin Mourgos
Julia Nayer
Irene Mikkilineni
James Landry
Steven Markle
Laura Bissot
Mozhe Atkinson
James Marlow
TJ Olson
Jason Mallin
Michael Rogers
Ki Gee
Hazel Philtanker
Renske Ladwig
Stephen Stiles
John Seo
Joshua Patel
Trenna Rajs
Curtis Davies
Randall Matos
Peter Vargas
John Russell
Karen Partners
Alberto Errazuriz
Gerald Cambrault
Eleni Zlotkey
Peter Tucker
David Bernstein
Peter Hall
Christopher Olsen
Nanette Cambrault
Oliver Tuvault
Janette King
Patrick Sully
Allan McEwen
Lindsey Smith
Louise Doran
Sarath Sewall
Clara Vishney
Danielle Greene
Mattea Marvins
David Lee
Sundar Ande
Amit Banda
Lisa Ozer
Harrison Bloom
Tayler Fox
William Smith
Elizabeth Bates
Sundita Kumar
Ellen Abel
Alyssa Hutton
Jonathon Taylor
Jack Livingston
Kimberely Grant
Charles Johnson
Winston Taylor
Jean Fleaur
Martha Sullivan
Girard Geoni
Nandita Sarchand
Alexis Bull
Julia Dellinger
Anthony Cabrio
Kelly Chung
Jennifer Dilly
Timothy Gates
Randall Perkins
Sarah Bell
Britney Everett
Samuel McCain
Vance Jones
Alana Walsh
Kevin Feeney
Donald OConnell
Douglas Grant
Jennifer Whalen
Michael Hartstein
Pat Fay
Susan Mavris
Hermann Baer
Shelley Higgins
William Gietz
*/
