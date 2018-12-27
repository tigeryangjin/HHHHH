???create or replace procedure dw_user.createfactscancode(date_nums in number) is
s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：张全扫码购数据统计
       
  
  作者时间：bobo  2016-04-11
  */

begin

  sp_name          := 'createfactscancode'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_scan_code'; --此处需要手工录入该PROCEDURE操作的表格
  s_etl.proc_name  := sp_name;
  s_etl.start_time := sysdate;
  s_parameter      := 0;

  begin
    sp_parameter_two(sp_name, s_parameter);
    if s_parameter = '0' then
      s_etl.err_msg := '没有找到对应的过程加载类型数据';
      sp_sbi_w_etl_log(s_etl);
      return;
    end if;
  end;
  
  /*IF date_nums<=20150001 then
    SELECT to_number(to_char(to_date(max(SYSDATE),'yyyy-mm-dd hh24:mi:ss')-1,'yyyymmdd')) into DATE_NUMS FROM DUAL;
  end if;*/
  
  DELETE FROM fact_scan_code WHERE  VISIT_DATE_KEY=date_nums;--先删除当天数据，在重新导入那天数据

   insert into fact_scan_code
     (ID,
      PAGE_VIEW_KEY,
      VID,
      DEVICE_KEY,
      IP,
      IP_GEO_KEY,
      IP_INT,
      URL,
      PAGE_KEY,
      PAGE_NAME,
      PAGE_VALUE,
      LAST_PAGE_KEY,
      HMSC_KEY,
      HMSC,
      APPLICATION_KEY,
      APPLICATION_NAME,
      VISIT_DATE_KEY,
      VISIT_DATE,
      PAGEBEGIN_TIME,
      PAGEEND_TIME,
      PAGE_STAYTIME_KEY,
      PAGE_STAYTIME,
      MEMBER_KEY,
      VISIT_HOUR_KEY,
      VISIT_HOUR,
      VER_KEY,
      VER_NAME,
      AGENT,
      HMMD,
      HMPL,
      HMKW,
      HMCI,
      VISIT_MONTH,
      SESSION_KEY,
      CHANNEL_KEY)
     SELECT ID,
            PAGE_VIEW_KEY,
            VID,
            DEVICE_KEY,
            IP,
            IP_GEO_KEY,
            IP_INT,
            URL,
            PAGE_KEY,
            PAGE_NAME,
            PAGE_VALUE,
            LAST_PAGE_KEY,
            HMSC_KEY,
            HMSC,
            APPLICATION_KEY,
            APPLICATION_NAME,
            VISIT_DATE_KEY,
            VISIT_DATE,
            PAGEBEGIN_TIME,
            PAGEEND_TIME,
            PAGE_STAYTIME_KEY,
            PAGE_STAYTIME,
            MEMBER_KEY,
            VISIT_HOUR_KEY,
            VISIT_HOUR,
            VER_KEY,
            VER_NAME,
            AGENT,
            HMMD,
            HMPL,
            HMKW,
            HMCI,
            VISIT_MONTH,
            SESSION_KEY,
            CHANNEL_KEY
       FROM FACT_PAGE_VIEW
      where (page_name = 'appdownload' or page_name = 'Tvdownload' or page_name='TV_QRC' or
            page_name = 'ScanTvlist' or page_name = 'ScanGoods' or page_name='bannerdownload')
        and VISIT_DATE_KEY = date_nums;
    insert_rows := sql%rowcount;
    if insert_rows>=1 then
      begin
        DELETE FROM dim_scan_code_day WHERE DAY_KEY = date_nums; --先删除那天数据
      
        insert into dim_scan_code_day --重新计算  当天时间段的pv，uv
          (DAY_KEY,
           HOUR_KEY,
           SCAN_CODE_NAME,
           uv_total,
           pv_total,
           page_name,
           page_value)
          select visit_date_key as DAY_KEY,
                 visit_hour_key as HOUR_KEY,
                 (case
                   when page_name = 'appdownload' and page_value = 'fromwx' then
                    '服务号导流'
                   when page_name = 'appdownload' and
                        page_value = 'fromqfdx' then
                    '会员短信'
                   when page_name = 'appdownload' and page_value = 'frompc' then
                    'PC官网导流'
                   when page_name = 'appdownload' and page_value = 'fromdyh' then
                    '订阅号导流'
                   when page_name = 'appdownload' and
                        page_value = 'frombaozx' then
                    '包装箱'
                   when page_name = 'Tvdownload' and page_value = 'fromWX' then
                    'TV扫码下载微信'
                   when page_name = 'Tvdownload' and
                        page_value = 'fromAlipay' then
                    'TV扫码下载支付宝'
                   when page_name = 'ScanTvlist' and page_value = 'fromWX' then
                    'TV扫码列表订购微信'
                   when page_name = 'ScanTvlist' and
                        page_value = 'fromAlipay' then
                    'TV扫码列表订购支付宝'
                   when page_name = 'ScanGoods' and page_value = 'fromWX' then
                    'TV扫码商品订购微信'
                   when page_name = 'bannerdownload' then
                    '移动浮层站'
                   when page_name = 'ScanGoods' and
                        page_value = 'fromAlipay' then
                    'TV扫码商品订购支付宝'
                   when page_name = 'TV_QRC' and
                        page_value = 'from_else' then
                    'TV扫码二维码其他'
                   when page_name = 'TV_QRC' and
                        page_value = 'from_wx' then
                    'TV扫码二维码微信'
                   when page_name = 'TV_QRC' and
                        page_value = 'from_ali' then
                    'TV扫码支付宝'
                   else
                    'APP下载'
                 end) as SCAN_CODE_NAME,
                 count(distinct(VID)) as uv_total,
                 count(VID) as pv_total,
                 page_name as page_name,
                 page_value as page_value
            from fact_scan_code
           where visit_date_key = date_nums
           group by page_name, page_value, visit_date_key, visit_hour_key;
      
        --按天统计数据
        declare
          type type_arrays_day is record(
            uv_total   number(20),
            page_name  varchar2(200),
            page_value varchar2(200)--,
            --DAY_KEY    number(20)
            );
        
          type type_array_day is table of type_arrays_day index by binary_integer; --类似二维数组 
        
          var_array_day type_array_day;
        begin
          select p.* bulk collect
            into var_array_day
            from (select --visit_date_key as DAY_KEY,
                         count(distinct(VID)) as uv_total,
                         to_char(page_name) as page_name,
                         to_char(page_value) as page_value
                    from fact_scan_code
                   where visit_date_key = date_nums
                   group by page_name, page_value, visit_date_key) p;
            
          for i in 1 .. var_array_day.count loop
            update dim_scan_code_day
               set UV_TOTAL_DAY = to_number(var_array_day(i).uv_total)
             where DAY_KEY = date_nums
               and page_name = to_char(var_array_day(i).page_name)
               and page_value = to_char(var_array_day(i).page_value);
          end loop;
        end;
      end;
      --先删除那天的计算销售数据
      begin
      DELETE FROM dim_scan_code_sales WHERE  DAY_KEY=date_nums; --先删除那天数据
      declare
      type type_arrays is record
      (
        page_name  varchar2(200),
        page_value  varchar2(200)
      );
  
      type type_array is table of type_arrays index by binary_integer; --类似二维数组 

    
      var_array type_array;
    
  
      begin
        select p.* bulk collect
          into var_array from 
          (select page_name,page_value from fact_scan_code where visit_date_key=date_nums group by page_name,page_value) p;
      
          for i in 1 .. var_array.count loop
            insert into dim_scan_code_sales (
            DAY_KEY,
            SCAN_CODE_NAME,
            DEVICE_TOTAL,
            wx_ORDER_PE_NUMS,
            wx_ORDER_NUMS,
            wx_ORDER_AMOUNT,
            m_ORDER_PE_NUMS,
            m_ORDER_NUMS,
            m_ORDER_AMOUNT,
            app_ORDER_PE_NUMS,
            app_ORDER_NUMS,
            app_ORDER_AMOUNT,
            PAGE_NAME,
            PAGE_VALUE
            ) select 
            date_nums as DAY_KEY,
            
            (case 
               when var_array(i).page_name='appdownload' and var_array(i).page_value='fromwx' then '服务号导流'
               when var_array(i).page_name='appdownload' and var_array(i).page_value='fromqfdx' then '会员短信'
               when var_array(i).page_name='appdownload' and var_array(i).page_value='frompc' then 'PC官网导流'
               when var_array(i).page_name='appdownload' and var_array(i).page_value='fromdyh' then '订阅号导流'
               when var_array(i).page_name='appdownload' and var_array(i).page_value='frombaozx' then '包装箱'
               when var_array(i).page_name='Tvdownload' and var_array(i).page_value='fromWX' then 'TV扫码下载微信'
               when var_array(i).page_name='Tvdownload' and var_array(i).page_value='fromAlipay' then 'TV扫码下载支付宝'
               when var_array(i).page_name='ScanTvlist' and var_array(i).page_value='fromWX' then 'TV扫码列表订购微信'
               when var_array(i).page_name='ScanTvlist' and var_array(i).page_value='fromAlipay' then 'TV扫码列表订购支付宝'
               when var_array(i).page_name='ScanGoods' and var_array(i).page_value='fromWX' then 'TV扫码商品订购微信'
               when var_array(i).page_name='ScanGoods' and var_array(i).page_value='fromAlipay' then 'TV扫码商品订购支付宝'
               when var_array(i).page_name='TV_QRC' and var_array(i).page_value='from_else' then 'TV扫码二维码其他'
               when var_array(i).page_name='TV_QRC' and var_array(i).page_value='from_wx' then 'TV扫码二维码微信'
               when var_array(i).page_name='TV_QRC' and var_array(i).page_value='from_ali' then 'TV扫码支付宝'
               when var_array(i).page_name='bannerdownload' then '移动浮层站'
               else 'APP下载' 
       end) as SCAN_CODE_NAME,
            
            VISTOR_KEY as DEVICE_TOTAL,
            cust_no as wx_ORDER_PE_NUMS,
            goods_num as wx_ORDER_NUMS,
            order_amount as wx_ORDER_AMOUNT,
            cust_no_m as m_ORDER_PE_NUMS,
            goods_num_m as m_ORDER_NUMS,
            order_amount_m as m_ORDER_AMOUNT,
            cust_no_app as app_ORDER_PE_NUMS,
            goods_num_app as app_ORDER_NUMS,
            order_amount_app as app_ORDER_AMOUNT,
            var_array(i).page_name as page_name,
            var_array(i).page_value as page_value 
            from (select count(distinct(cc.VISTOR_KEY)) as VISTOR_KEY
          from fact_visitor_register cc,
               (select distinct (ip) as ip, visit_date
                  from fact_scan_code
                 where visit_date_key = date_nums
                   and page_name = var_array(i).page_name
                   and page_value = var_array(i).page_value) pp
         where cc.CREATE_DATE_KEY = date_nums
           and (application_key = 10 or application_key = 20)
           and cc.first_ip = pp.ip
           and cc.create_date >= pp.visit_date),
       
       --订购计算  金额，数量
       (select count(cust_no) as cust_no, sum(order_amount) as order_amount
          from (select distinct (o.cust_no),
                                min(o.order_amount) over(partition by o.order_id order by 1) as order_amount,
                                min(o.order_id) over(partition by o.order_id order by 1) as order_id
                  from fact_ec_order o
                  left join (select distinct (ip) as ip, visit_date
                              from fact_scan_code
                             where visit_date_key = date_nums
                               and page_name = var_array(i).page_name
                   and page_value = var_array(i).page_value) pp
                    on o.order_ip = pp.ip
                 where o.add_time = date_nums
                   and o.order_state >= 20
                   and o.App_Name in ('KLGWX') --KLGWX--'KLGiPhone','KLGAndroid'
                   and o.order_ip = pp.ip
                   and o.addtime >= pp.visit_date)),
       
       --订购计算 订购数量          
       (select sum(GOODS_NUM) as goods_num
          from fact_ec_ordergoods
         where order_id in
               (select distinct (o.order_id)
                  from fact_ec_order o
                  left join (select distinct (ip) as ip, visit_date
                              from fact_scan_code
                             where visit_date_key = date_nums
                               and page_name = var_array(i).page_name
                   and page_value = var_array(i).page_value) pp
                    on o.order_ip = pp.ip
                 where o.add_time = date_nums
                   and o.order_state >= 20
                   and o.App_Name in ('KLGWX') --KLGWX--'KLGiPhone','KLGAndroid'
                   and o.order_ip = pp.ip
                   and o.addtime >= pp.visit_date)),
       
       --订购计算  金额，数量
       (select count(cust_no) as cust_no_app, sum(order_amount) as order_amount_app
          from (select distinct (o.cust_no),
                                min(o.order_amount) over(partition by o.order_id order by 1) as order_amount,
                                min(o.order_id) over(partition by o.order_id order by 1) as order_id
                  from fact_ec_order o
                  left join (select distinct (ip) as ip, visit_date
                              from fact_scan_code
                             where visit_date_key = date_nums
                               and page_name = var_array(i).page_name
                   and page_value = var_array(i).page_value) pp
                    on o.order_ip = pp.ip
                 where o.add_time = date_nums
                   and o.order_state >= 20
                   and o.App_Name in ('KLGiPhone', 'KLGAndroid') --KLGWX--'KLGiPhone','KLGAndroid'
                   and o.order_ip = pp.ip
                   and o.addtime >= pp.visit_date)),
       --订购计算 订购数量          
       (select sum(GOODS_NUM) as goods_num_app
          from fact_ec_ordergoods
         where order_id in
               (select distinct (o.order_id)
                  from fact_ec_order o
                  left join (select distinct (ip) as ip, visit_date
                              from fact_scan_code
                             where visit_date_key = date_nums
                               and page_name = var_array(i).page_name
                   and page_value = var_array(i).page_value) pp
                    on o.order_ip = pp.ip
                 where o.add_time = date_nums
                   and o.order_state >= 20
                   and o.App_Name in ('KLGiPhone', 'KLGAndroid') --KLGWX--'KLGiPhone','KLGAndroid'
                   and o.order_ip = pp.ip
                   and o.addtime >= pp.visit_date)),
        --订购计算  金额，数量
       (select count(cust_no) as cust_no_m, sum(order_amount) as order_amount_m
          from (select distinct (o.cust_no),
                                min(o.order_amount) over(partition by o.order_id order by 1) as order_amount,
                                min(o.order_id) over(partition by o.order_id order by 1) as order_id
                  from fact_ec_order o
                  left join (select distinct (ip) as ip, visit_date
                              from fact_scan_code
                             where visit_date_key = date_nums
                               and page_name = var_array(i).page_name
                   and page_value = var_array(i).page_value) pp
                    on o.order_ip = pp.ip
                 where o.add_time = date_nums
                   and o.order_state >= 20
                   and o.App_Name in ('KLGMPortal') --KLGWX--'KLGiPhone','KLGAndroid'
                   and o.order_ip = pp.ip
                   and o.addtime >= pp.visit_date)),
       --订购计算 订购数量          
       (select sum(GOODS_NUM) as goods_num_m
          from fact_ec_ordergoods
         where order_id in
               (select distinct (o.order_id)
                  from fact_ec_order o
                  left join (select distinct (ip) as ip, visit_date
                              from fact_scan_code
                             where visit_date_key = date_nums
                               and page_name = var_array(i).page_name
                   and page_value = var_array(i).page_value) pp
                    on o.order_ip = pp.ip
                 where o.add_time = date_nums
                   and o.order_state >= 20
                   and o.App_Name in ('KLGMPortal') --KLGWX--'KLGiPhone','KLGAndroid'
                   and o.order_ip = pp.ip
                   and o.addtime >= pp.visit_date));
          end loop;
      end;
     
  end;
  end if;
 commit;
  /*日志记录模块*/
  s_etl.end_time       := sysdate;
  s_etl.etl_record_ins := insert_rows;
  s_etl.etl_status     := 'SUCCESS';
  s_etl.etl_duration   := trunc((s_etl.end_time - s_etl.start_time) * 86400);
  sp_sbi_w_etl_log(s_etl);
exception
  when others then
    s_etl.end_time   := sysdate;
    s_etl.etl_status := 'FAILURE';
    s_etl.err_msg    := sqlerrm;
    sp_sbi_w_etl_log(s_etl);
    return;
end createfactscancode;
/

