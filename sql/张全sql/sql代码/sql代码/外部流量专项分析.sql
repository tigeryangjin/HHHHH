select * from ls_test for update
--- ����
select count(1),create_date_key from fact_visitor_register er where
 er.create_date_key between 20161201 and 20170201  
and er.application_key=20
 and HMSC in (select SNAME from ls_test) 
 group by create_date_key


---�ջ�
select count(1),count(distinct(vid)),count(distinct(ion.member_key)),start_date_key from  fact_session ion 
where ion.start_date_key  between 20161201 and 20170201 
 and ion.application_key=20
 and HMSC  in (select SNAME from ls_test)
 group by start_date_key
 
 ----�û���
 select nian,count(1) from (
 select vid,count(1) nian from (
 select vid,start_date_key from fact_session   ion 
where ion.start_date_key  between 20170107 and 20170113 
 and ion.application_key=20
 --and HMSC in (select SNAME from ls_test) 
 group by vid,start_date_key)  group by vid)  group by nian
 
 ----��Ա��
 select nian,count(1) from (
 select member_key,count(1) nian from (
  select ion.member_key,start_date_key from fact_session   ion 
where ion.start_date_key  between 20170107 and 20170113 
 and ion.application_key=20
 and HMSC in (select SNAME from ls_test) 
 group by member_key,start_date_key)  group by member_key)  group by nian

----����ʱ��
select count(1),to_char(CREATE_DATE,'hh24') from fact_visitor_register er where
 er.create_date_key between 20161201 and 20170201   
-- and create_date_key not in (20161222,20161223,20161224,20161225,20161226,20161227,20161228,20161229,20161230)
and er.application_key=20
 and HMSC in (select SNAME from ls_test) 
 group by to_char(CREATE_DATE,'hh24')
 

 
 ---�ջ�ʱ��
 select count(1),count(distinct(vid)),count(distinct(ion.member_key)),ion.hour from  fact_session ion 
where ion.start_date_key  between 20161201 and 20170201 
 and ion.application_key=20
 and HMSC in (select SNAME from ls_test) 
 group by ion.hour
 
 
 ---  ����������Ծʱ��
  select LIFE_TIME_KEY,count(1) from  fact_session ion 
where ion.start_date_key  between 20161201 and 20170201 
 and ion.application_key=20
  and HMSC in (select SNAME from ls_test)
 group by LIFE_TIME_KEY
 
 ---ҳ��
 select count(distinct(vid)),page_name from fact_page_view where 
 visit_date_key   between 20161201 and 20170201 
 and application_key=20
 and HMSC in (select SNAME from ls_test)
 group by page_name
 
---  �û�����
select REGISTER_RESOURCE,CREATE_DATE_KEY,FIRST_ACTIVE_DATE_KEY,MEMBER_LEVEL,MEMBER_BP from dim_member ber where ber.member_bp in (
 select distinct(ion.member_key) from  fact_visitor_register ion 
where ion.create_date_key  between 20161201 and 20170201 
 and ion.application_key=20
 and    in (select SNAME from ls_test) ) 
 
 ---����

 select IP_INT,IP_PROVINCE,TELECOMS from (
 select IP_INT from fact_page_view ew where
  ew.visit_date_key between 20161201 and 20170201 
 and application_key=20
 and HMSC in (select SNAME from ls_test) group by IP_INT
)a left join dim_ip_geo b on IP_INT between b.ip_start and b.ip_end

----
-----select * from  ls_test for update
select MEMBER_AGE,count(1)  from dim_member ber where ber.member_bp in (
 select distinct(ion.member_key) from  fact_session ion 
where ion.start_date_key  between 20161201 and 20170201 
 and ion.application_key=20
 in (select SNAME from ls_test)) 
 group by MEMBER_AGE
  ---��Ʒҳ��
 select count(distinct(vid)),visit_date_key from fact_page_view where 
 visit_date_key   between 20161201 and 20170201 
 and application_key=20
 and page_name='Good'
 and HMSC in (select SNAME from ls_test)
 group by visit_date_key
 
 ---ҳ��
 select count(distinct(vid)),visit_date_key from fact_page_view where 
 visit_date_key   between 20161201 and 20170201 
 and application_key=20
 and page_name='OrderConfirm'
  and HMSC in (select SNAME from ls_test)
 group by visit_date_key
 
 ---
 select count(1),sum(ORDER_AMOUNT),count(distinct(vid)),add_time from
  factec_order where  add_time between 20161201 and 20170201 
 and  vid in 
 (select vid from  fact_session where 
 start_date_key between 20161201 and 20170201 
  and application_key=20
   and HMSC in (select SNAME from ls_test))
  --and ERP_ORDER_NO is null 
  and ORDER_STATE>10 
   group by add_time
   --------
   
    select count(1),sum(ORDER_AMOUNT),count(distinct(vid)) from
  factec_order where  add_time between 20161201 and 20170201 
 and  vid in 
 (select vid from  fact_session where 
 start_date_key between 20161201 and 20170201 
  and application_key=20
   and HMSC  in (select SNAME from ls_test))
---  and ERP_ORDER_NO is null 
  and ORDER_STATE>10 
  
  
  -----��Ʒ����
  select sd.GOODS_NAME,sd.ITEM_CODE,GOODS_NUM,GOODS_PRICE,GOODS_TYPE,GROUP_NAME,MATDLT from (
  select order_id from
  factec_order where  add_time between 20161201 and 20170201 
 and  vid in 
 (select vid from  fact_session where 
 start_date_key between 20161201 and 20170201 
  and application_key=20
   and HMSC in (select SNAME from ls_test))
---  and ERP_ORDER_NO is null 
  and ORDER_STATE>10 ) a
  left join  factec_order_goods sd on a.order_id =sd.order_id
  left join dim_good ss on sd.item_code=ss.item_code

