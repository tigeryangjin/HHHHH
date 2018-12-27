???create or replace force view bdpuser.v_fact_daily_plite as
select "VISIT_DATE_KEY","VT_DATE","PVTOT","UVTOT","ORDERRCNT","ORDERTOT","ORDERRATE" from  dw_user.fact_daily_plite;

