???create or replace force view bdpuser.v_tmp_daily_source as
select "MEMBER_KEY","FLAG","FLAGNM","INSERT_DATE" from  dw_user.tmp_daily_source;

