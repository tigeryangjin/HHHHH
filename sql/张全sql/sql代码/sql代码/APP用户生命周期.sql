-------APP用户生命周期
truncate table ls_test1;
insert into ls_test1 

select '1',a.vid,num1,
(case
when num3-num2>=365 then '7'
when num3-num2>=185 then '6'
when num3-num2>=92 then '5'
when num3-num2>=31 then '4'  
when num3-num2>=7 then  '3'    
when num3-num2>=1  then '2'

  ELSE    '1'  END),'1'
    from (
select  vid,count(distinct START_DATE_KEY) num1 from fact_session 
where START_DATE_KEY between 20180501 and 20180531
and  APPLICATION_KEY in (10,20) group by  vid)
a join (select VID,CREATE_DATE num2 from fact_visitor_register where APPLICATION_KEY in(10,20)
and  CREATE_DATE_key not in (20170211,20170212,20170213)) b
on a.vid=b.vid 
join 
(
select  vid,max(START_TIME) num3  from fact_session 
where START_DATE_KEY between 20180501 and 20180531
and  APPLICATION_KEY in (10,20) group by vid
) c on a.vid=c.vid
left join  (select distinct VID from dim_vid_scan) d on a.vid=d.vid;
-------------

select  S2,s3,count(1),avg(s1)  from ls_test1
group by S2,s3;



   
----------订购金额 订购人数  订购单数 订购件数 
select S2,s3,count(1),sum(num1),sum(num2),sum(num3),sum(num4) from (
select VID,count(1) num1,sum(GOODS_NUM) num2,sum(order_amount) num3,sum(GOODS_AMOUNT) num4 
from factec_order where  add_time between 20180501 and 20180531
and  order_state>10 group by VID
) a  join (select SNAME,S1,s2,s3 from ls_test1) b on a.vid=b.sname
group by s2,s3;

---------------页面访问
select PAGE_NAME,S2,s3,sum(num1),COUNT(DISTINCT A.VID) from (
select PAGE_NAME,vid,count(1) as num1 from  fact_page_view where visit_date_key  between 20180501 and 20180531
and APPLICATION_KEY in(10,20) group by  PAGE_NAME,vid) a  join (select SNAME,S1,s2,s3 from ls_test1) b on a.vid=b.sname
group by S2,s3,PAGE_NAME;

----------物料大类
select S2,s3,MATDLT,sum(GOODS_NUM),count(distinct a.vid) from (
select VID,ITEM_CODE,ss.GOODS_NUM
from factec_order s join factec_order_goods ss on s.order_id=ss.order_id  
where  add_time between 20180501 and 20180531
and  order_state>10 and GOODS_TYPE in(1,3)
and ITEM_CODE<300000
and  GOODS_PAY_PRICE>=50 group by VID,ITEM_CODE,ss.GOODS_NUM
) a  join (select SNAME,S1,s2,s3 from ls_test1) b on a.vid=b.sname
 join (select GROUP_NAME,MATDLT,goods_name,ITEM_CODE from dim_good) c on  a.ITEM_CODE=c.ITEM_CODE
group by S2,s3,MATDLT;

----提报组

select S2,s3,GROUP_NAME,sum(GOODS_NUM),count(distinct a.vid) from (
select VID,ITEM_CODE,ss.GOODS_NUM
from factec_order s join factec_order_goods ss on s.order_id=ss.order_id  
where  add_time between 20180501 and 20180531
and  order_state>10 and GOODS_TYPE in(1,3)
 and ITEM_CODE<300000 group by VID,ITEM_CODE,ss.GOODS_NUM
) a  join (select SNAME,S1,s2,s3 from ls_test1) b on a.vid=b.sname
 join (select GROUP_NAME,MATDLT,ITEM_CODE from dim_good) c on  a.ITEM_CODE=c.ITEM_CODE
group by S2,s3,GROUP_NAME;



--------------- 商品浏览
select MATDLT,S2,s3,sum(num1),COUNT(DISTINCT A.VID) from (
select PAGE_NAME,vid,page_value,count(1) as num1 from  fact_page_view where visit_date_key  between 20180501 and 20180531
and APPLICATION_KEY in(10,20)
and page_name='Good' group by  PAGE_NAME,vid,page_value) a  join (select SNAME,S1,s2,s3 from ls_test1) b 
on a.vid=b.sname
join (select to_char(GOODS_COMMONID) GOODS_COMMONID,MATDLT  from dim_ec_good where STORE_ID=1) c 
 on a.page_value=c.GOODS_COMMONID
group by S2,s3,MATDLT;


