???create or replace procedure dw_user.createpaveviewfact(startpoint in ods_pageview.id%type,
                                               endpoint   in ods_pageview.id%type) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'createpaveviewfact'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_page_view'; --此处需要手工录入该PROCEDURE操作的表格
  s_etl.proc_name  := sp_name;
  s_etl.start_time := sysdate;
  s_parameter      := 0;

  begin
    sp_parameter_two(sp_name, s_parameter);
    if s_parameter = '0'
    then
      s_etl.err_msg := '没有找到对应的过程加载类型数据';
      sp_sbi_w_etl_log(s_etl);
      return;
    end if;
  end;

  insert into fact_page_view
    (id,
     page_view_key,
     vid,
     ip,
     url,
     page_key,
     page_name,
     page_value,
     hmsc_key,
     hmsc,
     hmmd,
     hmpl,
     hmkw,
     hmci,
     application_key,
     application_name,
     ip_geo_key,
     visit_date_key,
     pagebegin_time,
     pageend_time,
     page_staytime,
     page_staytime_key,
     device_key,
     session_key,
     member_key,
     visit_date,
     ver_key,
     ver_name,
     agent,
     ip_int,
     visit_month,
     hit_is)
  
    select a.id, --自增ID
           a.id as page_view_key, --PV关键字
           nvl(a.vid, 'unknown') as vid, --访问设备的唯一编号
           nvl(a.ip, '222.247.56.18') as ip, --IP地址
           a.url, --URL
           0 as page_key, --页面关键字
           nvl(a.p, 'unknown') as page_name, --页面名称
           nvl(a.v, 0) as page_value, --页面值 
           0 as hmsc_key, --SF_GET_HMSR_KEY(hmsr) as hmsr_key, --推广渠道关键字
           a.hmsc,
           a.hmmd, --推广媒介
           a.hmpl, --广告系列
           a.hmkw, --广告关键字
           a.hmci, --广告唯一编号
           0 as application_key, --    SF_GET_APPLICATION_KEY(agent) as application_key, --应用关键字
           nvl(a.a, 'unknown') as application_name,
           0 as ip_geo_key, --地理位置关键字（根据IP转换）
           to_number(to_char(a.createon, 'yyyymmdd')) as visit_date_key, --访问日期关键字
           a.createon as pagebegin_time, --进入页面时间
           '' as pageend_time, --离开页面时间
           0 as page_staytime, --页面停留时长（秒）
           0 as page_staytime_key, --停留时间关键字
           0 as visitor_key, --访问者关键字
           0 as session_key, --会话关键字
           
           to_number(case
                       when regexp_like(a.mid, '.([a-z]+|[A-Z])') then
                        '0'
                       when regexp_like(a.mid, '[[:punct:]]+') then
                        '0'
                       when a.mid is null then
                        '0'
                       when a.mid like '%null%' then
                        '0'
                       else
                        regexp_replace(a.mid, '\s', '')
                     end) as member_key, --会员关键字
           a.createon as visit_date, --访问日期
           0 as ver_key,
           nvl(a.ver, 'unknown'),
           agent,
           get_ip_number(nvl(ip, '222.247.56.18')) as ip_int,
           to_number(to_char(a.createon, 'yyyymm')) as visit_month,
           case
             when a.p like 'SL%' then
              1
             when a.p like 'LS%' then
              1
             else
              0
           end
      from odshappigo.ods_pageview a
     where a.id between startpoint and endpoint
       and a.isprocessed = 0;

  insert_rows := sql%rowcount;
  commit;

  update odshappigo.ods_pageview
     set isprocessed = 1
   where id between startpoint and endpoint;

  commit;

  /*屏蔽此段 by yangjin 2018-10-08,w_etl_odsmax更新由/home/liqiao/ods_to_dw.ktr执行*/
  /*delete from w_etl_odsmax;
  commit;
  insert into w_etl_odsmax (id) values (endpoint);
  commit;*/

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
end createpaveviewfact;
/

