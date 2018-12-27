???create or replace procedure bihappigo.sp_sbi_pageview_f(startpoint in ods_pageview.id%type,
endpoint in ods_pageview.id%type
 ) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
 -- r_id        ods_pageview.id%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'SP_SBI_PAGEVIEW_F'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'W_PAGE_VIEW_F'; --此处需要手工录入该PROCEDURE操作的表格
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

  --select min(a.id) into r_id from ods_pageview a where a.isprocessed = 0;

  insert into fact_page_view
    (id,
     page_view_key,
     vid,
     ip,
     url,
     page_key,
     page_name,
     page_value,
     hmsr_key,
     hmmd,
     hmpl,
     hmkw,
     hmci,
     application_key,
     application_name,
     ver_key,
     ver_name,
     device_key,
     device_name,
     ip_geo_key,
     visit_date_key,
     pagebegin_time,
     pageend_time,
     page_staytime,
     page_staytime_key,
     visitor_key,
     session_key,
     member_key,
     visit_date)
  
    select a.id, --自增ID
           a.id as page_view_key, --PV关键字
           a.vid, --访问设备的唯一编号
           a.ip, --IP地址
           a.url, --URL
           0 as page_key, --页面关键字
           a.p as page_name, --页面名称
           nvl(a.v,0) as page_value, --页面值 
           0 as hmsr_key, --SF_GET_HMSR_KEY(hmsr) as hmsr_key, --推广渠道关键字
           a.hmmd, --推广媒介
           a.hmpl, --广告系列
           a.hmkw, --广告关键字
           a.hmci, --广告唯一编号
           0 as application_key, --    SF_GET_APPLICATION_KEY(agent) as application_key, --应用关键字
           a.a as application_name,
           0 as ver_key, --SF_GET_DEVICE_KEY(d) as device_key, --设备关键字
           a.ver as ver_name,
           0 as device_key,
           a.agent as device_name,
           '' as ip_geo_key, --地理位置关键字（根据IP转换）
           to_number(to_char(a.createon, 'yyyymmdd')) as visit_date_key, --访问日期关键字
           a.createon as pagebegin_time, --进入页面时间
           '' as pageend_time, --离开页面时间
           '' as page_staytime, --页面停留时长（秒）
           '' as page_staytime_key, --停留时间关键字
           0 as visitor_key, --访问者关键字
           0 as session_key, --会话关键字
           a.mid as member_key, --会员关键字
           a.createon as visit_date --访问日期
    
      from ods_pageview a
     where a.id between startpoint and endpoint;
       --and a.isprocessed = 0;

  insert_rows := sql%rowcount;

  update ods_pageview
     set isprocessed = 1
   where id between startpoint and endpoint;
 
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
end sp_sbi_pageview_f;
/

