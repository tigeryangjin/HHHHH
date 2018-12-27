???create or replace procedure dw_user.processdimmember(startpoint varchar2) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processdimmember'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'dim_member'; --此处需要手工录入该PROCEDURE操作的表格
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
  --= '00000000';
  declare
  
  begin
  
    insert into dim_member
      (member_bp,
       member_level,
       member_age,
       member_agenda,
       member_zone,
       member_insert_date,
       register_resource,
       create_date_key,
       ch_date_key,
       clv_type,
       clv_type_w,
       modify_date)
      select distinct to_number(case
                                  when regexp_like(v.zbpartner, '.([a-z]+|[A-Z])') then
                                   '0'
                                  when regexp_like(v.ztcmc020, '[a-z]|[A-Z]') then
                                   '0'
                                  when regexp_like(v.zbpartner, '[[:punct:]]+') then
                                   '0'
                                  when v.zbpartner is null then
                                   '0'
                                  when v.zbpartner like '%null%' then
                                   '0'
                                  else
                                   regexp_replace(v.zbpartner, '\s', '')
                                end) as memberbp,
                      v.ztcmc016 as member_level,
                      to_number(case
                                  when regexp_like(v.zzage, '.([a-z]+|[A-Z])') then
                                   '0'
                                  when regexp_like(v.ztcmc020, '[a-z]|[A-Z]') then
                                   '0'
                                  when regexp_like(v.zzage, '[[:punct:]]+') then
                                   '0'
                                  when v.zzage is null then
                                   '0'
                                  when v.zzage like '%知%' then
                                   '0'
                                  when v.zzage like '%null%' then
                                   '0'
                                  else
                                   regexp_replace(v.zzage, '\s', '')
                                end) as member_age,
                      
                      v.gender as member_agenda,
                      to_number(case
                                  when regexp_like(v.ztcmc020, '.([a-z]+|[A-Z])') then
                                   '0'
                                  when regexp_like(v.ztcmc020, '[a-z]|[A-Z]') then
                                   '0'
                                  when regexp_like(v.ztcmc020, '[[:punct:]]+') then
                                   '0'
                                  when v.ztcmc020 is null then
                                   '0'
                                  when v.ztcmc020 like '%null%' then
                                   '0'
                                  else
                                   regexp_replace(v.ztcmc020, '\s', '')
                                end) as member_zone,
                      v.zthrc011,
                      case
                        when v.zzdatafrm in ('KLGAndroid',
                                             'KLGiPhone',
                                             'KLGMPortal',
                                             'KLGWX',
                                             'web') then
                         'B2C'
                        when v.zzdatafrm = 'o2o' then
                         'unknown'
                        else
                         'TV'
                      end,
                      to_number(v.createdon),
                      to_number(v.ch_on),
                      '0单用户',
                      '0单用户',
                      sysdate
        from ods_zbpartner v
       where v.createdon = startpoint; -- to_char(sysdate - 1, 'yyyymmdd');
    insert_rows := SQL%ROWCOUNT;
    commit;
  
  end;
  /*日志记录模块*/
  s_etl.end_time       := sysdate;
  s_etl.etl_record_ins := insert_rows;
  s_etl.etl_status     := 'SUCCESS';
  s_etl.err_msg        := '输入参数[startpoint]:' || startpoint;
  s_etl.etl_duration   := trunc((s_etl.end_time - s_etl.start_time) * 86400);
  sp_sbi_w_etl_log(s_etl);
exception
  when others then
    s_etl.end_time   := sysdate;
    s_etl.etl_status := 'FAILURE';
    s_etl.err_msg    := sqlerrm;
    sp_sbi_w_etl_log(s_etl);
    return;
end processdimmember;
/

