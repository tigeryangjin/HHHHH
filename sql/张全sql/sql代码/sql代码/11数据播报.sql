-----ҵ������ ע������
select sum(nums) ע������,REGISTER_APPNAME ע��ͨ· from (
select (case
                   when REGISTER_APPNAME = 'KLGWX'  then '΢��'
                   when REGISTER_APPNAME = 'KLGPortal'  then 'PC'
                   when REGISTER_APPNAME = 'KLGMPortal'  then 'WAP'
                      when REGISTER_APPNAME = 'KLGAndroid'  then 'Android'
                   else'IOS'   end) REGISTER_APPNAME,count(1) as nums from fact_ecmember 
                   where MEMBER_TIME=20170317 group by REGISTER_APPNAME)
                    group by REGISTER_APPNAME;
                    



--- ���������������������������,��������
select count(distinct(MEMBER_KEY)) ��������,count(distinct(ORDER_ID)) ��������,
sum(ORDER_AMOUNT) �������,sum(GOODS_NUM) ��������,
MEMBER_TIME ��Ա����,APP_NAME ����ͨ·
from (
select ORDER_ID,MEMBER_KEY,ADD_TIME,ORDER_AMOUNT,
 (case
                   when APP_NAME = 'KLGWX'  then '΢��'
                   when APP_NAME = 'KLGPortal'  then 'PC'
                   when APP_NAME = 'KLGMPortal'  then 'WAP'
                   else'APP'   end) APP_NAME,ORDER_STATE,GOODS_NUM, (case
                   when MEMBER_TIME = 20170317  then  '���û�'
                   else '���û�'end) MEMBER_TIME from 
(select ORDER_ID,MEMBER_KEY,ADD_TIME,ORDER_AMOUNT,APP_NAME,ORDER_STATE,GOODS_NUM from factec_order 
where ORDER_STATE>10 and ADD_TIME=20170317)  ass left join fact_ecmember css
on ass.member_key=css.member_crmbp) group by MEMBER_TIME,APP_NAME;




 
 


