???create or replace force view bdpuser.fact_daily_goodzaijia as
select "ITEM_CODE","GOODS_NAME","GC_ID_2","GC_NAME","GOODS_ADDTIME","IS_TV","BRAND_NAME","GOODS_PRICE","MATDLT","MATZLT","MATXLT","MATKLT","CREATE_DATE_KEY","IS_SHIPPING_SELF" from dw_user.fact_daily_goodzaijia;

