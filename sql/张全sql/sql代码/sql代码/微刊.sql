
 ------΢��ר��
 select PV �������,UV �������,ZRS �ܶ�������,ZJE �ܶ�������,YXRS ��Ч��������,YXDS ��Ч��������,YXJE ��Ч�������,YXJS ��Ч�������� from (
 select count(1) PV,count(distinct vid) UV from  fact_page_view where visit_date_key between to_char(sysdate-4,'yyyymmdd') and to_char(sysdate,'yyyymmdd')
 and url like '%wkzt%') a left join 
 (
 (select count(distinct vid) ZRS,sum(order_amount) ZJE from factec_order  where add_time  between to_char(sysdate-4,'yyyymmdd') and to_char(sysdate,'yyyymmdd')
 and  vid in (select distinct vid from  fact_page_view where visit_date_key between to_char(sysdate-4,'yyyymmdd') and to_char(sysdate,'yyyymmdd')
 and url like '%wkzt%' ))) b  on 1=1
 left join 
  (select count(distinct vid) YXRS,count(1) YXDS,sum(order_amount) YXJE,sum(GOODS_NUM) YXJS from factec_order  where add_time  between to_char(sysdate-4,'yyyymmdd') and to_char(sysdate,'yyyymmdd')
 and  vid in (select distinct vid from  fact_page_view where visit_date_key between to_char(sysdate-4,'yyyymmdd') and to_char(sysdate,'yyyymmdd')
 and url like '%wkzt%' ) and order_state>10) c on 1=1;
 
 
 ----΢����Ʒ
  select PV �������,UV �������,ZRS �ܶ�������,ZJE �ܶ�������,YXRS ��Ч��������,YXDS ��Ч��������,YXJE ��Ч�������,YXJS ��Ч�������� from (
 select count(1) PV,count(distinct vid) UV from  fact_page_view where visit_date_key between to_char(sysdate-4,'yyyymmdd') and to_char(sysdate,'yyyymmdd')
 and url like '%wksp%') a left join 
 (
 (select count(distinct vid) ZRS,sum(order_amount) ZJE from factec_order  where add_time  between to_char(sysdate-4,'yyyymmdd') and to_char(sysdate,'yyyymmdd')
 and ORDER_IP in (select distinct ip from  fact_page_view where visit_date_key between to_char(sysdate-4,'yyyymmdd') and to_char(sysdate,'yyyymmdd')
 and url like '%wksp%' ) and APP_NAME='KLGWX')) b  on 1=1
 left join 
  (select count(distinct vid) YXRS,count(1) YXDS,sum(order_amount) YXJE,sum(GOODS_NUM) YXJS   from factec_order  where add_time  between to_char(sysdate-4,'yyyymmdd') and to_char(sysdate,'yyyymmdd')
 and  ORDER_IP in (select distinct ip from  fact_page_view where visit_date_key between to_char(sysdate-4,'yyyymmdd') and to_char(sysdate,'yyyymmdd')
 and url like '%wksp%' ) and order_state>10 and APP_NAME='KLGWX') c on 1=1;
 
 
 

