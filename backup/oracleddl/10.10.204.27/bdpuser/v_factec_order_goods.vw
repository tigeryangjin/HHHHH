???create or replace force view bdpuser.v_factec_order_goods as
select "REC_ID","EC_GOODS_ID","EC_GOODS_COMMON","ITEM_CODE","ERP_CODE","GOODS_NAME","ORDER_ID","GOODS_NUM","GOODS_PRICE","GOODS_PAY_PRICE","APPORTION_PRICE","TV_DISCOUNT_AMOUNT","GOODS_TYPE" from  dw_user.factec_order_goods;

