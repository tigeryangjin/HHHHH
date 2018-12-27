???create or replace force view bdpuser.v_fact_daily_pliteloudou as
select "VISIT_DATE_KEY","VT_DATE","HOMEPV","HOMEUV","GOODPV","GOODUV","ORDERCONFIRMPV","ORDERCONFIRMUV","ORDERCNT","ORDERMEM","GOODRATE","ORDERCONFIRMRATE","ORDERRATE","ORDERYXRATE","ORDERYXMEM" from  dw_user.fact_daily_pliteloudou;

