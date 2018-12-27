???create or replace force view bdpuser.v_fact_search_wx as
select "ID","VID","MEMBER_KEY","IP","CREATE_DATE","SKW","APPLICATION_KEY","APPLICATION_NAME","VISITOR_KEY","IP_GEO_KEY","CREATE_DATE_KEY","SEARCH_KEY" from dw_user.fact_search_wx;

