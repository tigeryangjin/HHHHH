select DATE_KEY  日期,
CHANNEL  渠道,
( case when PAGE_CNM is null and a.PAGE_NAME='Dau' then '日活'
       when PAGE_CNM is null and a.PAGE_NAME='PayEnd' then '支付成功页'
         else  PAGE_CNM end) 页面名,
a.PAGE_NAME  页面名称,
ALL_PV  总PV,
ALL_UV  总UV,
ALL_STAY_TIME  总平均停留时长,
ALL_BOUNCE_UV  总跳失UV,
NEW_PV  新客PV,
NEW_UV  新客UV,
NEW_STAY_TIME  新客平均停留时长,
NEW_BOUNCE_UV  新客跳失UV,
OLD_PV  老客PV,
OLD_UV  老客UV,
OLD_STAY_TIME  老客平均停留时长,
OLD_BOUNCE_UV  老客跳失UV
 from OPER_TRAFFIC_ANALYSIS  a left join (
select PAGE_NAME,PAGE_CNM from  dim_page  where PAGE_CNM is not null  and PAGE_CNM !='unkown'
group by  PAGE_NAME,PAGE_CNM ) b on a.PAGE_NAME=b.PAGE_NAME


select 
(case when PAGE_NAME='SearchResult' or PAGE_NAME='Search' then 'Search'
ELSE  PAGE_NAME END)
PAGE_NAME,VISIT_DATE_KEY,
(CASE  WHEN APPLICATION_NM='ANDROID' OR APPLICATION_NM='IOS' THEN 'APP'
WHEN APPLICATION_NM='wxlite_mall' THEN '小程序' END)   APPLICATION_NM
,sum(ORDERCNT),sum(ORDERUV),sum(GOODS_NUM),sum(GOODS_AMOUNT)  
from fact_daily_goodpage  where  VISIT_DATE_KEY >20180100  and APPLICATION_NM in('ANDROID','IOS','wxlite_mall')
group by (case when PAGE_NAME='SearchResult' or PAGE_NAME='Search' then 'Search'
ELSE  PAGE_NAME END)
,VISIT_DATE_KEY,
(CASE  WHEN APPLICATION_NM='ANDROID' OR APPLICATION_NM='IOS' THEN 'APP'
WHEN APPLICATION_NM='wxlite_mall' THEN '小程序' END) 
