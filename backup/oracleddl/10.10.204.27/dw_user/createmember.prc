???create or replace procedure dw_user.createmember(startpoint varchar2) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'createfactmember'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'FACT_MEMBER_REGISTER'; --此处需要手工录入该PROCEDURE操作的表格
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
  --= '00000000';
  declare
  
  begin
  
    insert into fact_member_register
      (member_id,
       member_key,
       register_date_key,
       register_time_key,
       device_key,
       ip_geo_key,
       register_date,
       media_key,
       media,
       application_key,
       hmsc_key,
       register_time,
       ch_date_key,
       ch_time_key,
       ch_time,
       member_level
       
       )
    
      select
      
       to_number(case
                   when regexp_like(a.zbpartner, '.([a-z]+|[A-Z])') then
                    '0'
                   when regexp_like(a.zbpartner, '[[:punct:]]+') then
                    '0'
                   when a.zbpartner is null then
                    '0'
                   when a.zbpartner like '%null%' then
                    '0'
                   else
                    regexp_replace(a.zbpartner, '\s', '')
                 end) as member_id,
       to_number(case
                   when regexp_like(a.zbpartner, '.([a-z]+|[A-Z])') then
                    '0'
                   when regexp_like(a.zbpartner, '[[:punct:]]+') then
                    '0'
                   when a.zbpartner is null then
                    '0'
                   when a.zbpartner like '%null%' then
                    '0'
                   else
                    regexp_replace(a.zbpartner, '\s', '')
                 end) as member_key,
       to_number(a.createdon),
       0,
       0,
       0,
       to_date(a.createdon, 'yyyy-mm-dd'),
       0,
      case
                        when a.zzdatafrm in ('KLGAndroid',
                                             'KLGiPhone',
                                             'KLGMPortal',
                                             'KLGWX',
                                             'web') then
                         'B2C'
                        when a.zzdatafrm = 'o2o' then
                         'unknown'
                        else
                         'TV'
                      end,
       0,
       0,
       to_number(substr(a.crea_time, 1, 2)),
       to_number(a.ch_on),
       0,
       to_number(substr(a.ch_at, 1, 2)),
       nvl(a.ztcmc016, 'unknown')
        from ods_zbpartner a
       where a.createdon = startpoint;
  
    -- insert_rows := sql%rowcount;
    commit;
  
    update fact_member_register j1
       set j1.register_time_key =
           (select j2.time_key
              from dim_time j2
             where j2.start_value = j1.register_time),
           j1.ch_time_key      =
           (select j3.time_key
              from dim_time j3
             where j3.start_value = j1.ch_time),
           j1.media_key        =
           (select j4.media_key from dim_media j4 where j4.media = j1.media)
     where j1.register_date_key = to_number(startpoint);
    commit;
  
  end;
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
end createmember;
/

