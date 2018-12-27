???create or replace force view bdpuser.v_fact_daily_apploudou as
select "VISIT_DATE_KEY","VT_DATE","HOMEPV","HOMEUV","GOODPV","GOODUV","ORDERCONFIRMPV","ORDERCONFIRMUV","ORDERCNT","ORDERMEM","ORDERYXCNT","ORDERYXMEM","GOODRATE","ORDERCONFIRMRATE","ORDERRATE","ORDERYXRATE" from dw_user.fact_daily_apploudou;

