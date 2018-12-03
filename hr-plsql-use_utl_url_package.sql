-- use UTL_URL package - adds delimiters in URL such as $, ?, :, =, /

select utl_url.escape('http://www.oracle.com/url with space.html') from dual;
-- http://www.oracle.com/url%20with%20space.html