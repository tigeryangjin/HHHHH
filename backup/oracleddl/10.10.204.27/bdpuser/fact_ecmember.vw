???create or replace force view bdpuser.fact_ecmember as
select "MEMBER_ID","MEMBER_CRMBP","MEMBER_TIME","REGISTER_APPNAME","MEMBER_CREATETIME" from  dw_user.fact_ecmember;

