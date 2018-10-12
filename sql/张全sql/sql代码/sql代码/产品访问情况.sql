select DATE_KEY  ����,
CHANNEL  ����,
( case when PAGE_CNM is null and a.PAGE_NAME='Dau' then '�ջ�'
       when PAGE_CNM is null and a.PAGE_NAME='PayEnd' then '֧���ɹ�ҳ'
         else  PAGE_CNM end) ҳ����,
a.PAGE_NAME  ҳ������,
ALL_PV  ��PV,
ALL_UV  ��UV,
ALL_STAY_TIME  ��ƽ��ͣ��ʱ��,
ALL_BOUNCE_UV  ����ʧUV,
NEW_PV  �¿�PV,
NEW_UV  �¿�UV,
NEW_STAY_TIME  �¿�ƽ��ͣ��ʱ��,
NEW_BOUNCE_UV  �¿���ʧUV,
OLD_PV  �Ͽ�PV,
OLD_UV  �Ͽ�UV,
OLD_STAY_TIME  �Ͽ�ƽ��ͣ��ʱ��,
OLD_BOUNCE_UV  �Ͽ���ʧUV
 from OPER_TRAFFIC_ANALYSIS  a left join (
select PAGE_NAME,PAGE_CNM from  dim_page  where PAGE_CNM is not null  and PAGE_CNM !='unkown'
group by  PAGE_NAME,PAGE_CNM ) b on a.PAGE_NAME=b.PAGE_NAME


select 
(case when PAGE_NAME='SearchResult' or PAGE_NAME='Search' then 'Search'
ELSE  PAGE_NAME END)
PAGE_NAME,VISIT_DATE_KEY,
(CASE  WHEN APPLICATION_NM='ANDROID' OR APPLICATION_NM='IOS' THEN 'APP'
WHEN APPLICATION_NM='wxlite_mall' THEN 'С����' END)   APPLICATION_NM
,sum(ORDERCNT),sum(ORDERUV),sum(GOODS_NUM),sum(GOODS_AMOUNT)  
from fact_daily_goodpage  where  VISIT_DATE_KEY >20180100  and APPLICATION_NM in('ANDROID','IOS','wxlite_mall')
group by (case when PAGE_NAME='SearchResult' or PAGE_NAME='Search' then 'Search'
ELSE  PAGE_NAME END)
,VISIT_DATE_KEY,
(CASE  WHEN APPLICATION_NM='ANDROID' OR APPLICATION_NM='IOS' THEN 'APP'
WHEN APPLICATION_NM='wxlite_mall' THEN 'С����' END) 
