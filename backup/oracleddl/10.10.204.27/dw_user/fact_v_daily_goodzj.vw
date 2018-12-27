???create or replace force view dw_user.fact_v_daily_goodzj as
select
p1.item_code as "商品编号",
p1.goods_name as "商品名称",
p1.gc_id_2 as "电商分类编号",
p1.gc_name as "电商类别",
p1.goods_addtime as "上架时间",
p1.is_tv as "提报组",
p1.brand_name as "品牌",
p1.goods_price as "商品单价",
p1.matdlt as "ERP大分类",
p1.matzlt as "ERP中分类",
p1.matxlt as "ERP小分类",
p1.matxxlt as "ERP细分类"
 from fact_daily_goodzj p1;

