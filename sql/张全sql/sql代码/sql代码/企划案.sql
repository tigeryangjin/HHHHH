---��Ա��  
select  count(distinct(MEMBER_KEY)),APPLICATION_KEY from fact_page_view  where
 VISIT_DATE_KEY between 20180301 and 20180431   

group by APPLICATION_KEY 

---������Ա

select count(1),REGISTER_APPNAME from  fact_ecmember  where MEMBER_TIME between 20170801 and 20170831 
group by REGISTER_APPNAME

---��ʧ��Ա


select count(distinct(MEMBER_KEY)) from fact_session where  
START_DATE_KEY   between 20161101 and 20161131  
and  APPLICATION_KEY  in (50)
and  MEMBER_KEY  not in (
select distinct(MEMBER_KEY) from  fact_session where  
START_DATE_KEY   between 20161201 and 20170131 
and  APPLICATION_KEY in (50)
) 


---���ѻ�Ա

select  count(distinct(MEMBER_KEY)) from fact_session where  
START_DATE_KEY   between 20160701 and 20160731  
and  APPLICATION_KEY in (10,20)
and member_key in

(select MEMBER_CRMBP from fact_ecmember where MEMBER_TIME<=20160431  ) and member_key not in 
(select distinct(MEMBER_KEY) from  fact_session where  
START_DATE_KEY   between 20160501 and 20160631 
and  APPLICATION_KEY in (10,20)
)
---------ǰһ���µ������ڵ�ǰ�µ�����
select count(distinct(vid)) from  fact_session  where START_DATE_KEY  between  20160701 and 20170631  and vid in (
select VID from fact_visitor_register where CREATE_DATE_KEY between 20160601 and 20160631 and 
APPLICATION_KEY in (10,20)
)
---�ٹ���Ա  16236 72713   223888

select count(distinct(MEMBER_KEY)) from fact_order  where  SALES_SOURCE_KEY=20
 and  ORDER_DATE_KEY between 20160801 and 20160831 
 and   ORDER_STATE=1
 and  MEMBER_KEY in
 (
 select MEMBER_KEY from fact_order  where  SALES_SOURCE_KEY=20
 and  ORDER_DATE_KEY between 20160701 and 20160731  
 and   ORDER_STATE=1
 )

----  �û�����Ƶ��
select  chi,count(1) from (
select count(1) as chi ,MEMBER_KEY from fact_order  where  SALES_SOURCE_KEY=20
 and  ORDER_DATE_KEY between 20151031 and 20161031 
 and   ORDER_STATE=1
and MEMBER_KEY in (

select distinct(MEMBER_KEY) from fact_page_view  where
 VISIT_DATE_KEY between 20160901 and 20161031   
)

group by MEMBER_KEY) group by chi


 
 ---��Ʒ����
  select * from( select GOODS_COMMON_KEY,count(distinct(ORDER_KEY)) as dan,count(distinct(MEMBER_KEY)) as ren ,count(distinct(ORDER_KEY))/count(distinct(MEMBER_KEY)) as pinchi
  from fact_goods_sales  where SALES_SOURCE_KEY=20 and ORDER_STATE=1
  and ORDER_DATE_KEY between 20160101 and 20161031
  
  group by GOODS_COMMON_KEY )  a  left join dim_ec_good  b on  a.GOODS_COMMON_KEY =b.item_code
   where ren>200 and pinchi>=1.2  
 
   ---������
   select * from (
   select ITEM_CODE,sum(CART_NUMS) as �ӹ��ﳵ,sum(SC_NUMS)  as �ղش��� 
   ,sum(PV_NUMS) as pv,sum(COMMENT_GOOD) as ����,sum(COMMENT_BETTER) as ����,sum(COMMENT_BEST) as ����,
   sum(EFFECTIVE_NUMS) as ��Ч��������
   
   from  fact_goods_order_dayly  where POSTING_DATE_KEY between 20161001 and 2016103
   
   group by  ITEM_CODE) a left join  dim_ec_good b on a.ITEM_CODE=b.ITEM_CODE
   
--- ��ԱԤ������
select * from (

   select MEMBER_BP,
   (to_number(to_date(END_ACTIVE_DATE_KEY)-to_date(FIRST_ACTIVE_DATE_KEY)+1)/ACTIVE_DAYS)  as ��Ծ����
    ,ACTIVE_TIMES as ��Ծ����,ACTIVE_DAYS  as ��Ծ����
    from dim_member
   
   where MEMBER_BP in (select  distinct(MEMBER_KEY) from fact_page_view  where
 VISIT_DATE_KEY between 20160901 and 20161031  )
 and  END_ACTIVE_DATE_KEY>0 and FIRST_ACTIVE_DATE_KEY>0
 )a left join (  
 
  
 
 
select MEMBER_KEY,count(distinct(ORDER_KEY)) as ��������,sum(ORDER_AMOUNT) as �������  from fact_order  where   ORDER_DATE_KEY>20150731 and  SALES_SOURCE_KEY=20 and  ORDER_STATE=1
 and  MEMBER_KEY in (select  distinct(MEMBER_KEY) from fact_page_view  where
 VISIT_DATE_KEY between 20160901 and 20161031  ) 
 
 group by MEMBER_KEY) b on a.MEMBER_BP=b.MEMBER_KEY
 
 
 
------8655    34575
select count(distinct(MEMBER_KEY)) from factec_order where order_state>10 and add_time between 20170601 and 20170631
and  MEMBER_KEY in (
select MEMBER_KEY from factec_order where order_state>10 and add_time between 20170501 and 20170531
)
-----10248   33061
select count(distinct(MEMBER_KEY)) from factec_order where order_state>10 and add_time between 20170601 and 20170631
and  MEMBER_KEY in (
select count(distinct(MEMBER_CRMBP))  from  fact_ecmember  where MEMBER_TIME between 20170601 and 20170631
)


----
select 
(
select count(distinct(vid)) from fact_session where START_DATE_KEY between 20160601 and 20160631 and vid in (
select vid from fact_visitor_register where CREATE_DATE_KEY between 20160501 and 20160531
and APPLICATION_KEY in (10,20))
)/
(select count(1) from fact_visitor_register where CREATE_DATE_KEY between 20160501 and 20160531
and APPLICATION_KEY in (10,20))
  from dual
  
  
 
---9110 ��8���ϻ�Ա����������   36640��7�»�Ա����������
select count(distinct(MEMBER_KEY)) from factec_order where add_time between  20170801 and 20170831 
and order_state>10 and MEMBER_KEY in (
select distinct(MEMBER_KEY) from factec_order where add_time between  20170701 and 20170731 
and order_state>10)
---12638��8�¶����»�Ա����   54534��8��ע���Ա����
select count(distinct(MEMBER_KEY)) from factec_order where add_time between  20170801 and 20170831 
and order_state>10 and MEMBER_KEY in (
select count( distinct MEMBER_CRMBP) from fact_ecmember where MEMBER_TIME between  20170801 and 20170831
 )


-----
