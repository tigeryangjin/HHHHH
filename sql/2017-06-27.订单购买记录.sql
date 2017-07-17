--最近半年购买过美妆(30)、服装配饰(18)、日用(50)、母婴(54)的用户(物料大类)，与这次618订购过美妆的用户剔重  给到BP号
select distinct b.member_key
  from (select a.member_key, a.goods_common_key
          from fact_goods_sales a
         where a.posting_date_key between 20161218 and 20170615
           and a.sales_source_key = 20
           and a.order_state = 1) b,
       dim_good c
 where b.goods_common_key = c.item_code
   and c.matdl in (18, 30, 50, 54)
   and not exists
 (select 1
          from (select f.member_key
                  from (select e.member_key, e.goods_common_key
                          from fact_goods_sales e
                         where e.posting_date_key between 20170616 and
                               20170626
                           and e.sales_source_key = 20
                           and e.order_state = 1) f,
                       dim_good g
                 where f.goods_common_key = g.item_code
                   and g.matdl in (18, 30, 50, 54)) d
         where b.member_key = d.member_key)
 order by 1;
