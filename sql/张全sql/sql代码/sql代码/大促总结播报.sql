------���û��ջ�
select count(distinct vid),visit_date_key
 from  fact_page_view where  visit_date_key  between 20161210 and 20161213
 --and member_key  not in ( select MEMBER_KEY from  factec_order where add_time<20161210 and order_state>10 )
 group by visit_date_key
 
 
 
 ------
 select add_time,count(distinct member_key)��������,count(1),sum(order_amount)	�������,sum(GOODS_NUM)	��������
 from  factec_order where add_time  between 20161210 and 20161213
 and member_key  not  in ( select MEMBER_KEY from  factec_order where add_time<20161210 and order_state>10 )
 and (order_state>10 or (CRM_ORDER_NO>0 and CANCEL_BEFORE_STATE=0 ))
 group by add_time



-----



