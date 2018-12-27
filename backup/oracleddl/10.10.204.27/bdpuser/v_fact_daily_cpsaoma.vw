???create or replace force view bdpuser.v_fact_daily_cpsaoma as
select "VISIT_DATE_KEY","VT_DATE","PV","UV","SMUVCNT","SM_ORDERRS","SMYJ","SMCNT","SMRATE" from dw_user.fact_daily_cpsaoma;

