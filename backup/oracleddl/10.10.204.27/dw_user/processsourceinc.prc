???create or replace procedure dw_user.processsourceinc(startpoint in number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processsourceinc'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'member_label_link'; --此处需要手工录入该PROCEDURE操作的表格
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

  insert into member_label_link
  
    select member_key,
           m_label_id,
           m_label_type_id,
           create_date,
           create_user_id,
           last_update_date,
           last_update_user_id,
           member_label_link_seq.nextval
      from (select distinct n1.member_key,
                            143 as m_label_id,
                            1 as m_label_type_id,
                            sysdate as create_date,
                            'liqiao' as create_user_id,
                            sysdate as last_update_date,
                            'liqiao' as last_update_user_id
              from fact_visitor_register n1
             where create_date_key = startpoint
               and application_key in (10, 20)
               and n1.hmsc in (select hmsc from dim_hmsc where hmpl = '推广')
               and member_key != 0
               and not exists
             (select *
                      from member_label_link n2
                     where n2.m_label_id = 143
                       and n2.member_key = n1.member_key));

  insert into member_label_link
    select hh.member_key,
           143 as m_label_id,
           1 as m_label_type_id,
           sysdate as create_date,
           'liqiao' as create_user_id,
           sysdate as last_update_date,
           'liqiao' as last_update_user_id,
           member_label_link_seq.nextval
      from (select distinct z2.member_key
              from (select n1.*
                      from fact_visitor_register n1
                     where create_date_key = startpoint
                       and application_key in (10, 20)
                       and n1.hmsc in
                           (select hmsc from dim_hmsc where hmpl = '推广')
                       and member_key = 0) z1,
                   dim_vid_mem z2
             where z1.vid = z2.vid) hh
     where not exists (select *
              from member_label_link n2
             where n2.m_label_id = 143
               and n2.member_key = hh.member_key);

  insert into member_label_link
    select hh.member_key,
           143 as m_label_id,
           1 as m_label_type_id,
           sysdate as create_date,
           'liqiao' as create_user_id,
           sysdate as last_update_date,
           'liqiao' as last_update_user_id,
           member_label_link_seq.nextval
      from (select distinct z2.member_key
              from (select n1.*
                      from fact_daily_pcpromotion n1
                     where active_date_key = startpoint) z1,
                   dim_vid_mem z2
             where z1.vid = z2.vid) hh
     where not exists (select *
              from member_label_link n2
             where n2.m_label_id = 143
               and n2.member_key = hh.member_key);

  insert into member_label_link
    select hh.member_key,
           143 as m_label_id,
           1 as m_label_type_id,
           sysdate as create_date,
           'liqiao' as create_user_id,
           sysdate as last_update_date,
           'liqiao' as last_update_user_id,
           member_label_link_seq.nextval
      from (select distinct z2.member_key
              from (select n1.*
                      from fact_daily_3gpromotion n1
                     where active_date_key = startpoint) z1,
                   dim_vid_mem z2
             where z1.vid = z2.vid) hh
     where not exists (select *
              from member_label_link n2
             where n2.m_label_id = 143
               and n2.member_key = hh.member_key);

  insert into member_label_link
    select hh.member_key,
           144 as m_label_id,
           1 as m_label_type_id,
           sysdate as create_date,
           'liqiao' as create_user_id,
           sysdate as last_update_date,
           'liqiao' as last_update_user_id,
           member_label_link_seq.nextval
      from (select distinct a2.member_key
              from dim_vid_scan a1, dim_vid_mem a2
             where a1.scan_date_key = startpoint
               and a1.vid = a2.vid
               and not exists
             (select *
                      from member_label_link a3
                     where a3.m_label_id = 144
                       and a3.member_key = a2.member_key)) hh;

  insert into member_label_link
    select m1.member_bp,
           145 as m_label_id,
           1 as m_label_type_id,
           sysdate as create_date,
           'liqiao' as create_user_id,
           sysdate as last_update_date,
           'liqiao' as last_update_user_id,
           member_label_link_seq.nextval
    
      from dim_member m1
     where m1.create_date_key = startpoint
       and not exists (select *
              from member_label_link a3
             where a3.m_label_id in (143, 144)
               and a3.member_key = m1.member_bp)
          /*yangjin 2018-11-18*/
       and not exists (select *
              from member_label_link a3
             where a3.m_label_id = 145
               and a3.member_key = m1.member_bp);

  commit;

  /*日志记录模块*/
  s_etl.end_time       := sysdate;
  s_etl.etl_record_ins := insert_rows;
  s_etl.err_msg        := '输入参数[startpoint]:' || startpoint;
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
end processsourceinc;
/

