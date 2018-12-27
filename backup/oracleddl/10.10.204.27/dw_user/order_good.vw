???create or replace force view dw_user.order_good as
select a3.goods_commonid,
       c3.goods_name,
       c3.supplier_id,
       c3.matdl,
       case
         when c3.is_kjg = 1 then
          '(跨境购)' || c3.matdlt
         else
          c3.matdlt
       end as matdlt,
       c3.matzl,
        case
         when c3.is_kjg = 1 then
          '(跨境购)' || c3.matzlt
         else
          c3.matzlt
       end as matzlt,
       c3.matxl,
        case
         when c3.is_kjg = 1 then
          '(跨境购)' || c3.matxlt
         else
          c3.matxlt
       end as matxlt,
       nvl(c3.brand_name, 'UNKNOWN') as brand_name,
       --case when a3.is_kjg=0 then substr(a3.erp_code,1,6)
       -- end  as item_code,
       case
         when a3.is_kjg = 0 then
          (select x.item_code
             from dim_ec_good x
            where x.goods_commonid = a3.goods_commonid)
       end as item_code,
       c3.goods_price,
       c3.gc_name,
       c3.goods_addtime,
       case when c3.is_shipping_self=0 then '直配送'
         else '入库'  end as  is_shipping_self,
       c3.is_own_shop,
       b2.order_id,
       b2.order_sn,
       b2.erp_order_no,
       b2.app_name,
       b2.vid,
       b2.cust_no,
       b2.addtime,
       b2.add_time,
       a3.erp_code,
       a3.goods_name as erp_code_name,
       a3.goods_pay_price,
       a3.goods_num,
       b2.order_ip,
       decode(c3.is_tv, 0, '电商提报组', 1, '非电商提报组') as is_tv,
       case
         when (b2.payment_code = 'offline' or
              b2.order_state>=20) then
          1
         else
          0
       end as iscg,
       b2.order_from,
       b2.payment_code
  from fact_ec_ordergoods a3, fact_ec_order b2, dim_ec_good c3
 where a3.order_id = b2.order_id
   and a3.is_kjg = b2.is_kjg
   and a3.goods_commonid = c3.goods_commonid
   and a3.is_kjg = c3.is_kjg
;

