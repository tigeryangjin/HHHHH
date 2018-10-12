
select * from 
(select VID,IP,VISIT_DATE,visit_date_key from fact_page_view  a  
where  a.visit_date_key =to_number(to_char(to_date(SYSDATE,'yyyy-mm-dd hh24:mi:ss')-1,'yyyymmdd'))  
and a.page_name in ('Tvdownload','ScanTvlist','TV_QRC','ScanGoods') and a.page_value )
b
left join 

(select ERP_ORDER_NO,ORDER_IP,ADDTIME,APP_NAME from fact_ec_order  where  ORDER_IP in (select IP from fact_page_view  a  
where  a.visit_date_key =to_number(to_char(to_date(SYSDATE,'yyyy-mm-dd hh24:mi:ss')-1,'yyyymmdd'))   
and a.page_name in ('Tvdownload','ScanTvlist','TV_QRC','ScanGoods'))
and ADD_TIME=to_number(to_char(to_date(SYSDATE,'yyyy-mm-dd hh24:mi:ss')-1,'yyyymmdd')) and  ORDER_STATE>10
) c
 on b.ip=c.ORDER_IP
left join (
(select min(time) as time  , ip from (
select ADDTIME-VISIT_DATE as time,ip from 
(select VID,IP,VISIT_DATE,visit_date_key from fact_page_view  a  
where  a.visit_date_key =to_number(to_char(to_date(SYSDATE,'yyyy-mm-dd hh24:mi:ss')-1,'yyyymmdd'))  
and a.page_name in ('Tvdownload','ScanTvlist','TV_QRC','ScanGoods'))
b
left join 

(select ERP_ORDER_NO,ORDER_IP,ADDTIME,APP_NAME from fact_ec_order  where  ORDER_IP in (select IP from fact_page_view  a  
where  a.visit_date_key =to_number(to_char(to_date(SYSDATE,'yyyy-mm-dd hh24:mi:ss')-1,'yyyymmdd'))   
and a.page_name in ('Tvdownload','ScanTvlist','TV_QRC','ScanGoods'))
and ADD_TIME=to_number(to_char(to_date(SYSDATE,'yyyy-mm-dd hh24:mi:ss')-1,'yyyymmdd')) and  ORDER_STATE>10
)
c
 on b.ip=c.ORDER_IP )  where  time>0  group by ip)) d 
 on b.ip=d.ip and (c.ADDTIME-b.VISIT_DATE)=d.time
 
 
 
select VID  设备编号,IP 进入时IP地址,VISIT_DATE 扫码时间,visit_date_key 扫码日期  from fact_page_view  a  
where  a.visit_date_key =to_number(to_char(to_date(SYSDATE,'yyyy-mm-dd hh24:mi:ss')-1,'yyyymmdd'))  
and a.page_name in ('Tvdownload','ScanTvlist','TV_QRC','ScanGoods') and a.page_value not in ('from_wx_list','from_else_list','from_ali_list')
;

select ERP_ORDER_NO 订单编号,ORDER_IP 下单IP地址,ADDTIME 下单时间,APP_NAME 下单通路 from fact_ec_order  where  
       ORDER_IP in (select ip  from fact_page_view  a  
where  a.visit_date_key =to_number(to_char(to_date(SYSDATE,'yyyy-mm-dd hh24:mi:ss')-1,'yyyymmdd'))  
and a.page_name in ('Tvdownload','ScanTvlist','TV_QRC','ScanGoods') and a.page_value not in ('from_wx_list','from_else_list','from_ali_list')
)
   and ADD_TIME=to_number(to_char(to_date(SYSDATE,'yyyy-mm-dd hh24:mi:ss')-1,'yyyymmdd')) and  ORDER_STATE>10
