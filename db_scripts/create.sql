create user examtracker password 'r3sr3v13w!!';
create schema AUTHORIZATION examtracker;
revoke all on all tables in schema public from examtracker;
grant usage on schema public to examtracker;
grant select on all tables in schema public to examtracker;
alter user examtracker set search_path to examtracker,public;
