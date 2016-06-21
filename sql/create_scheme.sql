--------------------------------------------------------------------------------
-- DROP SCHEME -----------------------------------------------------------------
--------------------------------------------------------------------------------
drop user ws cascade
/
commit
/
--------------------------------------------------------------------------------
-- WS SCHEME -------------------------------------------------------------------
--------------------------------------------------------------------------------
create user ws identified by ws1 default tablespace users temporary tablespace temp quota unlimited on users
/
grant create session to ws
/
grant create table to ws
/
grant create procedure to ws
/
grant create trigger to ws
/
grant create view to ws
/
grant create sequence to ws
/
grant create view to ws
/
grant delete any table to ws
/
grant drop any table to ws
/
grant drop any procedure to ws
/
grant drop any trigger to ws
/
grant drop any view to ws
/
grant alter any table to ws
/
grant alter any table to ws
/
grant alter any procedure to ws
/
grant alter any trigger to ws
/
commit
/