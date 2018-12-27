???create or replace force view dw_user.order_good as
select a3.goods_commonid,
c3.goods_name,
case when c3.is_kjg=1 then '(跨境购)'||c3.matdlt else
c3.matdlt end as matdlt ,
nvl(c3.brand_name,'UNKNOWN') as brand_name,
case when a3.is_kjg=0 then substr(a3.erp_code,1,6)
  end  as item_code,
b2.order_id,b2.order_sn,b2.erp_order_no,b2.app_name,b2.vid,b2.cust_no,b2.addtime,b2.add_time, a3.goods_pay_price,a3.goods_num,
decode(c3.is_tv,0,'电商提报组',1,'非电商提报组') as is_tv,
case when (b2.payment_code='offline' or b2.ORDER_STATE in (20,30,40,50)) then 1 else 0  end  as iscg
from  fact_ec_ordergoods a3,fact_ec_order b2,dim_ec_good c3
where a3.order_id=b2.order_id
and   a3.is_kjg=b2.is_kjg
and   a3.goods_commonid=c3.goods_commonid
and   a3.is_kjg=c3.is_kjg;

