???create or replace force view bdpuser.v_fact_ymj as
select "ORDER_ID","ERP_ORDER_NO","MEMBER_KEY","MEMBER_LEVEL","ORDER_DATE","GOODS_NAME","JS","JE" from dw_user.fact_ymj;

