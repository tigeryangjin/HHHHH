---查询直播商品
select  * from dim_tv_good  where TV_START_TIME in (
select TV_START_TIME from dim_tv_good  where ITEM_CODE=206867)


----扫码人数
select count(1),count(distinct(vid)) from fact_page_view s where s.page_name='TV_QRC' AND S.VISIT_DATE_KEY=20161011
 AND  (S.VISIT_HOUR_KEY=11 OR  S.VISIT_HOUR_KEY=15)
 
 ---订购人数
 select COUNT(DISTInCT(ORDER_ID)),sum(GOODS_NUM),sum(GOODS_PAY_PRICE*GOODS_NUM) 
 from fact_ec_ordergoods  where ERP_CODE  in (206868)
 and ORDER_ID in (
 
 select ORDER_ID  from fact_ec_order q where  q.ADD_TIME=20161011 
 and q.ORDER_STATE>0 
 and q.vid in (
 select vid from fact_page_view  aw where aw.visit_date_key=q.ADD_TIME and aw.application_key=50
 and aw.ip in ( 
 select IP from fact_page_view s where s.page_name='TV_QRC' AND S.VISIT_DATE_KEY=q.add_time
-- AND  (S.VISIT_HOUR_KEY=11 OR  S.VISIT_HOUR_KEY=15)
 )))
 
 
 select * from fact_ec_ordergoods where ERP_CODE  in (206868)
 
 
 
 select  * from factec_order_ten_total where DATE_KEY=20161017 and TIME_KEY=15
 
 
 
SELECT
to_date(statdate ,'YYYY-MM-DD HH24:MI:ss')    统计日期,
STATHOUR                                      浏览小时,
STATMINUTE                                    浏览分钟,
application_name                              应用渠道名称,
good_code                                     商品编号,
pv  当前点击,
uv  当前人数,
rangepv  当天点击,
rangeuv  当天人数,
END_TIME  最新时间
FROM
STATS_ONLINE_GOOD_MINUTE where
select 
to_number(to_date(to_char(sysdate,'YYYYMMDD'))-to_date(20161018 ,'YYYYMMDD')) from dual


SQL 

select a.ITEM_CODE   商品编号,
b.GOODS_STOCK        商品库存
from fact_daily_goodzaijia a left join fact_ecgoods_stock  b  on a.ITEM_CODE=b.ITEM_CODE



select max(STATMINUTE) from STATS_ONLINE_GOOD_MINUTE where STATDATE=20161020 and STATHOUR=14


select max(VISIT_DATE) from fact_page_view 

select count(1) from fact_visitor_register 
where CREATE_DATE_KEY=20161020 and  APPLICATION_KEY in (10,20)


select * from(
 select VID,EC_GOODS_COMMON,ORDER_STATE,GOODS_AMOUNT,a.ORDER_ID from 
  (select * from  factec_order where ADD_TIME=20161020 and   ORDER_FROM in(63,61) and ORDER_STATE>0 ) a left join factec_order_goods b
  on a.ORDER_ID =b.ORDER_ID ) a left join   ( select vid,PAGE_VALUE,IP_GEO_KEY,LAST_PAGE_KEY from fact_page_view sa  where  sa.visit_date_key=20161020 
  and sa.application_key in (10,20)  and   IP_GEO_KEY>0 ) b on a.vid=b.vid and a.EC_GOODS_COMMON=b.PAGE_VALUE and (IP_GEO_KEY =969 or IP_GEO_KEY =2851 or IP_GEO_KEY =1740 or IP_GEO_KEY =2899 ) 

select  count(distinct(vid)),visit_hour_key  from fact_page_view  s where s.visit_date_key=20151111 and s.application_key
in(10,20)  and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')

 group by s.visit_hour_key

select   count(distinct(vid)),visit_hour_key from fact_page_view  s where s.visit_date_key=20161020 and s.application_key
in(10,20)  and HMSC in ('as','klg','yyb','hw','oppo','xm','vivo','t360','bd','meizu','wdj','ppzs')
group by s.visit_hour_key


---- 


---- 新客 贡献
select  ORDER_FROM,count(1),count(distinct(vid)),sum(ORDER_AMOUNT) from fact_ec_order where vid in (
select VID from fact_visitor_register 
where CREATE_DATE_KEY=20161020 and  APPLICATION_KEY in (10,20))  and  ORDER_STATE>0
group by ORDER_FROM
--61 ios  63 anzhuo
select * from fact_ec_order
