???create or replace force view bdpuser.v_fact_session as
select "ID","SESSION_KEY","VID","FIST_IP","PAGE_COUNT","START_PAGE_KEY","LEFT_PAGE_KEY","HMSC_KEY","HMSC","HMMD","HMPL","HMKW","HMCI","APPLICATION_KEY","IP_GEO_KEY","LIFE_TIME","LIFE_TIME_KEY","START_DATE_KEY","END_DATE_KEY","VISITOR_KEY","START_TIME","END_TIME","MEMBER_KEY","BONUS_FLAG","HOUR_KEY","HOUR","CHANNEL_KEY","VER_KEY","VER_NAME","AGENT" from  dw_user.fact_session;

