???create or replace force view bdpuser.v_dim_good as
select "ITEM_CODE","GOODS_COMMONID","GOODS_NAME","GC_ID","GC_NAME","MATDL","MATDLT","MATZL","MATZLT","MATXL","MATXLT","BRAND_ID","BRAND_NAME","GOODS_STATE","CREATE_TIME","GOOD_PRICE","IS_TV","IS_KJG","MD","GROUP_ID","GROUP_NAME","MATL_GROUP","MATXXLT" from  dw_user.dim_good;

