--BBC��Ʒ����ת����=BBC��Ʒ��������/ ���BBC��Ʒ������  ��һ�����·ݵ�  BBC��Ʒ ��ָ ��dim_ec_good �Ĺ�Ӧ�̱�Ų���1�Ķ���BBC��Ʒ
--daily
select u.date_key, o.order_cust_count, u.uv
  from (select a.add_time date_key,
               count(distinct a.cust_no) order_cust_count
          from fact_ec_order a, fact_ec_ordergoods b
         where a.order_id = b.order_id
           and a.add_time between 20170601 and 20170630
           and exists
         (select 1
                  from (select * from dim_ec_good c where c.store_id <> 1) d
                 where b.goods_commonid = d.goods_commonid)
         group by a.add_time) o,
       (select a.visit_date_key date_key, count(distinct a.member_key) uv
          from fact_page_view a
         where a.visit_date_key between 20170601 and 20170630
           and a.page_name in ('Good', 'good')
           and a.page_value =
               translate(a.page_value,
                         '0' || translate(a.page_value, '#0123456789', '#'),
                         '0')
           and exists
         (select 1
                  from (select * from dim_ec_good b where b.store_id <> 1) c
                 where to_number(a.page_value) = c.goods_commonid)
         group by a.visit_date_key) u
 where o.date_key = u.date_key
 order by 1;

--BBC��Ʒ��������
--1923
select a.add_time date_key, count(distinct a.cust_no) order_cust_count
  from fact_ec_order a, fact_ec_ordergoods b
 where a.order_id = b.order_id
   and a.add_time between 20170601 and 20170630
   and exists
 (select 1
          from (select * from dim_ec_good c where c.store_id <> 1) d
         where b.goods_commonid = d.goods_commonid)
 group by a.add_time;

--���BBC��Ʒ������
--28635
select a.visit_date_key date_key, count(distinct a.member_key) uv
  from fact_page_view a
 where a.visit_date_key between 20170601 and 20170630
   and a.page_name in ('Good', 'good')
   and a.page_value =
       translate(a.page_value,
                 '0' || translate(a.page_value, '#0123456789', '#'),
                 '0')
   and exists
 (select 1
          from (select * from dim_ec_good b where b.store_id <> 1) c
         where to_number(a.page_value) = c.goods_commonid)
 group by a.visit_date_key;

select 1923 / 28635 from dual;

--tmp
select distinct a.page_value,
                translate(a.page_value,
                          '0' || translate(a.page_value, '#0123456789', '#'),
                          '0')
  from fact_page_view a
 where a.visit_date_key between 20170601 and 20170630
   and a.page_name in ('Good', 'good');

translate(col, '0' || translate(col, '#0123456789', '#'), '0')
  select count(distinct a.cust_no)
    from fact_ec_order a
   where a.add_time between 20170601 and 20170630
     and exists (select 1
            from dim_ec_good b
           where b.store_id <> 1
             and a.);
select count(distinct a.member_key)
  from fact_page_view a
 where a.visit_date_key between 20170601 and 20170630;

select distinct a.supplier_id from dim_ec_good a;
select * from dim_ec_good a;
select * from fact_ec_order a where a.add_time = 20170705;
select * from fact_ec_ordergoods;
