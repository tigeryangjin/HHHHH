--5.3��7.3 BBC��Ʒ�ĸ����ʣ������������ϵ��û�/���������û���
--���������û�
select count(distinct a.cust_no) order_cust_count
  from fact_ec_order a, fact_ec_ordergoods b
 where a.order_id = b.order_id
   and a.add_time between 20170503 and 20170703
   and exists
 (select 1
          from (select * from dim_ec_good c where c.store_id <> 1) d
         where b.goods_commonid = d.goods_commonid);

--�����������ϵ��û�
select count(1)
  from (select distinct e.cust_no
          from (select a.cust_no, a.order_id
                  from fact_ec_order a, fact_ec_ordergoods b
                 where a.order_id = b.order_id
                   and a.add_time between 20170503 and 20170703
                   and exists
                 (select 1
                          from (select *
                                  from dim_ec_good c
                                 where c.store_id <> 1) d
                         where b.goods_commonid = d.goods_commonid)) e
         group by e.cust_no
        having count(e.order_id) > 2) f;
				
select 422/2983 from dual;
