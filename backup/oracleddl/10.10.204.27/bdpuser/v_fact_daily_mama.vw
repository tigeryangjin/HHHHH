???create or replace force view bdpuser.v_fact_daily_mama as
select "ACTIVITYID","ACTIVITYNAME","MEMBER_KEY","MEMBER_LEVEL","ORDER_ID","ERP_ORDER_NO","ADD_TIME","ITEM_CODE","GOODS_NAME","GOODS_NUM","GOODS_PAY_PRICE","VOUCHER_PRICE","VOUCHERNAME" from dw_user.fact_daily_mama;

