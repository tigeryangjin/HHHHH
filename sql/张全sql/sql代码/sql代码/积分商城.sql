select 
count(1)  页面PV,
count(distinct(vid)) 页面UV,
avg(PAGE_STAYTIME)  页面平均停留时长,
 (case  when page_name = 'HappigoSign'  then '签到'
                     when page_name = 'JFDB_Home' then '积分夺宝'
                       when page_name = 'Gamble' then '大转盘'
                         else '积分商城'
                           end)   页面名称 ,
             VISIT_DATE_KEY    日期           
                     
from fact_page_view where   VISIT_DATE_KEY  between to_char(sysdate-45,'yyyymmdd') and  to_char(sysdate-1,'yyyymmdd')
  and page_name in ('HappigoSign','JFDB_Home','Gamble','MemberRights_Home')
  
  group by VISIT_DATE_KEY,page_name
  
  
  
  select VOUCHER_ACTIVE_DATE,VOUCHER_T_ID,VOUCHER_TITLE,MEMBER_KEY,count(1) from  fact_voucher where VOUCHER_ACTIVE_DATE   between to_char(sysdate-45,'yyyymmdd') and  to_char(sysdate-1,'yyyymmdd')
 and  REMARK='积分兑换'
 group by   VOUCHER_ACTIVE_DATE,VOUCHER_T_ID,VOUCHER_TITLE,MEMBER_KEY
