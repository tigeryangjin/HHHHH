select 
count(1)  ҳ��PV,
count(distinct(vid)) ҳ��UV,
avg(PAGE_STAYTIME)  ҳ��ƽ��ͣ��ʱ��,
 (case  when page_name = 'HappigoSign'  then 'ǩ��'
                     when page_name = 'JFDB_Home' then '���ֶᱦ'
                       when page_name = 'Gamble' then '��ת��'
                         else '�����̳�'
                           end)   ҳ������ ,
             VISIT_DATE_KEY    ����           
                     
from fact_page_view where   VISIT_DATE_KEY  between to_char(sysdate-45,'yyyymmdd') and  to_char(sysdate-1,'yyyymmdd')
  and page_name in ('HappigoSign','JFDB_Home','Gamble','MemberRights_Home')
  
  group by VISIT_DATE_KEY,page_name
  
  
  
  select VOUCHER_ACTIVE_DATE,VOUCHER_T_ID,VOUCHER_TITLE,MEMBER_KEY,count(1) from  fact_voucher where VOUCHER_ACTIVE_DATE   between to_char(sysdate-45,'yyyymmdd') and  to_char(sysdate-1,'yyyymmdd')
 and  REMARK='���ֶһ�'
 group by   VOUCHER_ACTIVE_DATE,VOUCHER_T_ID,VOUCHER_TITLE,MEMBER_KEY
