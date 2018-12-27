???create or replace force view dw_user.fact_daily_goodzj as
select
h1.item_code,
h1.goods_name,
h1.gc_id_2,
h1.gc_name,
h1.goods_addtime,
(select distinct h2.group_name from  dim_good h2 where h2.item_code=h1.item_code) as is_tv,
h1.brand_name,
h1.goods_price,
(select distinct h2.matdlt from  dim_good h2 where h2.item_code=h1.item_code) as matdlt,
(select distinct h2.matzlt from  dim_good h2 where h2.item_code=h1.item_code) as matzlt,
(select distinct h2.matxlt from  dim_good h2 where h2.item_code=h1.item_code) as matxlt,
(select distinct h2.matxxlt from  dim_good h2 where h2.item_code=h1.item_code) as matxxlt,
h1.is_shipping_self
 from fact_daily_goodzaijia h1;

