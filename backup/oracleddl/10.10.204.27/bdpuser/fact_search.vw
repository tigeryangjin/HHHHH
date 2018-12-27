???create or replace force view bdpuser.fact_search as
select "ID","VID","MEMBER_KEY","IP","CREATE_DATE","SKW","APPLICATION_KEY","APPLICATION_NAME","VISITOR_KEY","IP_GEO_KEY","CREATE_DATE_KEY","SEARCH_KEY" from dw_user.fact_search;

