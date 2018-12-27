???create or replace force view bdpuser.fact_ecgoods_stock as
select "ITEM_CODE","GOODS_STOCK" from dw_user.fact_ecgoods_stock;

