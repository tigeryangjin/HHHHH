???create or replace force view bdpuser.v_fact_daily_appsource as
select "START_DATE_KEY","VT_DATE","LEIXIN","UV","PV","ORDERRS","ORDERTOT","ORDERRATE" from dw_user.fact_daily_appsource;

