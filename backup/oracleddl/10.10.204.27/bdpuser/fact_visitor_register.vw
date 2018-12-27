???create or replace force view bdpuser.fact_visitor_register as
select "ID","VISTOR_KEY","VID","CREATE_DATE","CREATE_DATE_KEY","CREATE_TIME_KEY","IP_GEO_KEY","HMSC_KEY","APPLICATION_KEY","VER_KEY","FIRST_IP","HMSC","CREATE_TIME","OS","OS_KEY","HMMD","HMPL","HMKW","HMCI","MEMBER_KEY","IP_INT","AGENT","VER_NAME","CHANNEL_KEY" from  dw_user.fact_visitor_register;

