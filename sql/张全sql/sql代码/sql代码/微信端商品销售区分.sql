-----һ����Ʒ����������ͨ·�����(ɨ������)
select sum(ORDER_AMOUNT),sum(NUMS),count(distinct MEMBER_KEY),count(1) from  fact_goods_sales where  order_state=1 and GOODS_COMMON_KEY=232297 and
 ORDER_KEY in (
select CRM_ORDER_NO from factec_order where
 add_time =20180223 and order_state>10 and APP_NAME='KLGWX'  and ORDER_FROM=76
and order_id IN(
select order_id from  factec_order_goods where  ITEM_CODE=232297));

----- һ����Ʒ����������ͨ·�����(ԤԼ��������)
select sum(ORDER_AMOUNT),sum(NUMS),count(distinct MEMBER_KEY),count(1) from  fact_goods_sales where  order_state=1 and GOODS_COMMON_KEY=232297 and
 ORDER_KEY in (
select CRM_ORDER_NO  from  factec_order where add_time =20180223 and order_state>10 and APP_NAME='KLGWX' and
ORDER_FROM!=76
and order_id IN(
select order_id from  factec_order_goods where  ITEM_CODE=232297)
and vid in (
select VID from  fact_page_view where visit_date_key=20180223 
and url like '%?fo=YYTX%'));

---- һ����Ʒ����������ͨ·�����(��Ȼ����)
select sum(ORDER_AMOUNT),sum(NUMS),count(distinct MEMBER_KEY),count(1) from  fact_goods_sales where  order_state=1 and GOODS_COMMON_KEY=232297 and
 ORDER_KEY in (
select CRM_ORDER_NO from  factec_order where add_time =20180223 and order_state>10 and APP_NAME='KLGWX' and
ORDER_FROM!=76
and order_id IN(
select order_id from  factec_order_goods where  ITEM_CODE=232297)
and vid  not in (
select VID from  fact_page_view where visit_date_key=20180223 
and url like '%?fo=YYTX%'));
