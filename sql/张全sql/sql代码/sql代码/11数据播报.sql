-----业绩播报 注册人数
select sum(nums) 注册人数,REGISTER_APPNAME 注册通路 from (
select (case
                   when REGISTER_APPNAME = 'KLGWX'  then '微信'
                   when REGISTER_APPNAME = 'KLGPortal'  then 'PC'
                   when REGISTER_APPNAME = 'KLGMPortal'  then 'WAP'
                      when REGISTER_APPNAME = 'KLGAndroid'  then 'Android'
                   else'IOS'   end) REGISTER_APPNAME,count(1) as nums from fact_ecmember 
                   where MEMBER_TIME=20170317 group by REGISTER_APPNAME)
                    group by REGISTER_APPNAME;
                    



--- 订购人数，订购单数，订购金额,订购件数
select count(distinct(MEMBER_KEY)) 订购人数,count(distinct(ORDER_ID)) 订购单数,
sum(ORDER_AMOUNT) 订购金额,sum(GOODS_NUM) 订购件数,
MEMBER_TIME 会员类型,APP_NAME 订购通路
from (
select ORDER_ID,MEMBER_KEY,ADD_TIME,ORDER_AMOUNT,
 (case
                   when APP_NAME = 'KLGWX'  then '微信'
                   when APP_NAME = 'KLGPortal'  then 'PC'
                   when APP_NAME = 'KLGMPortal'  then 'WAP'
                   else'APP'   end) APP_NAME,ORDER_STATE,GOODS_NUM, (case
                   when MEMBER_TIME = 20170317  then  '新用户'
                   else '老用户'end) MEMBER_TIME from 
(select ORDER_ID,MEMBER_KEY,ADD_TIME,ORDER_AMOUNT,APP_NAME,ORDER_STATE,GOODS_NUM from factec_order 
where ORDER_STATE>10 and ADD_TIME=20170317)  ass left join fact_ecmember css
on ass.member_key=css.member_crmbp) group by MEMBER_TIME,APP_NAME;




 
 


