???create or replace force view dw_happigo.dim_good as
select a.goods_key,a.goods_code,a.goods_name,
a.sort_id,b.sort_name,a.type_id,b.type_name,a.kind_id,b.kind_name
 from  dim_goods a,dim_goods_class b
where a.sort_id=b.sort_id(+)
and   a.type_id=b.type_id(+)
and   a.kind_id=b.kind_id(+);

