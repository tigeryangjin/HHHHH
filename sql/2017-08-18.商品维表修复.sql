--1.dim_tv_good.goods_common_id=0 fix
update dim_tv_good a
   set a.goods_common_id =
       (select d.goods_common_id
          from (select distinct b.item_code, b.goods_common_id
                  from dim_tv_good b
                 where b.goods_common_id <> 0
                   and exists (select 1
                          from dim_tv_good c
                         where b.item_code = c.item_code
                           and c.goods_common_id = 0)) d
         where a.item_code = d.item_code)
 where a.goods_common_id = 0;

--2.dim_good.goods_commonid is null and dim_tv_good.goods_common_id<>0 fix
update dim_good a
   set a.goods_commonid =
       (select distinct b.goods_common_id
          from dim_tv_good b
         where b.goods_common_id <> 0
           and a.item_code = b.item_code)
 where a.goods_commonid is null;

--3.dim_tv_good.goods_common_id is null and dim_good.goods_commonid<> fix
update dim_tv_good a
   set a.goods_common_id =
       (select from dim_good b
         where b.goods_commonid <> 0
           and a.item_code = b.item_code)
 where a.goods_common_id is null;

--4.

--5.
