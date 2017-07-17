/*
过账日期  拒退通路（直接给编号就好了）  提报组  是否直配  商品  物料大类  拒退原因  拒退金额  拒退件数
*/
select rev.posting_date_key         过账日期,
       rev.sales_source_second_desc 拒退通路,
       goods.group_name             提报组,
       goods.is_shipping_self       是否直配,
       goods.item_code              商品编码,
       goods.goods_name             商品名称,
       goods.matdlt                 物料大类,
       rev.one_reason               拒退原因,
       rev.reverse_amount           拒退金额,
       rev.reverse_qty              拒退件数
  from (select a.posting_date_key /*过账日期key*/,
               a.sales_source_second_desc /*拒退通路*/,
               a.goods_common_key /*goods_common_key*/,
               a.one_reason one_reason /*拒退原因*/,
               sum(a.order_amount) reverse_amount /*拒退金额*/,
               sum(a.nums) reverse_qty /*拒退件数*/
          from fact_goods_sales_reverse a
         where (a.posting_date_key between 20170101 and 20170630 or
               a.posting_date_key between 20160101 and 20160630)
           and a.sales_source_key = 20
           and a.cancel_state = 1
         group by a.posting_date_key,
                  a.sales_source_second_desc,
                  a.goods_common_key,
                  a.one_reason) rev,
       (select b.item_code /*商品编码*/,
               b.goods_commonid goods_common_key /*goods_common_key*/,
               max(b.goods_name) goods_name /*商品名称*/,
               max(b.matdlt) matdlt /*物料大类*/,
               max(b.is_shipping_self) is_shipping_self /*是否直配*/,
               max(b.group_name) group_name /*提报组*/
          from (select g1.item_code,
                       g1.goods_commonid,
                       g1.goods_name,
                       g1.matdlt,
                       g2.is_shipping_self,
                       g1.group_name
                  from dim_good g1, dim_ec_good g2
                 where g1.item_code = g2.item_code) b
         group by b.item_code, b.goods_commonid) goods
 where rev.goods_common_key = goods.item_code
 order by rev.posting_date_key,
          rev.sales_source_second_desc,
          goods.group_name,
          goods.item_code;


