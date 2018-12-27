???create or replace procedure dw_user.processlable_clvinc(startpoint in number,
                                                endpoint   in number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processlable_clvinc'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'member_label_link'; --此处需要手工录入该PROCEDURE操作的表格
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

  delete /*+ index(f2 MEMBER_LABEL_LINK_I1) */
  from member_label_link f2
   where exists (select *
            from dim_member f
           where f.clv_chgdate_key = endpoint
             and f.member_bp = f2.member_key)
     and f2.m_label_id between 49 and 59;

  commit;

  insert into member_label_link
    select h.member_bp,
           decode(h.clv_type,
                  '0单用户',
                  49,
                  '陌生人',
                  50,
                  '寄居蟹',
                  51,
                  '蝴蝶型',
                  52,
                  '好朋友',
                  53),
           1,
           sysdate,
           'liqiao',
           sysdate,
           'liqiao',
           member_label_link_seq.nextval
      from dim_member h
     where h.create_date_key = startpoint;
  commit;

  insert into member_label_link
    select h.member_bp,
           decode(h.clv_type_w,
                  '0单用户',
                  55,
                  '陌生人',
                  56,
                  '寄居蟹',
                  57,
                  '蝴蝶型',
                  58,
                  '好朋友',
                  59),
           1,
           sysdate,
           'liqiao',
           sysdate,
           'liqiao',
           member_label_link_seq.nextval
      from dim_member h
     where h.create_date_key = startpoint;
  commit;

  insert into member_label_link
    select h.member_bp,
           decode(h.clv_type,
                  '0单用户',
                  49,
                  '陌生人',
                  50,
                  '寄居蟹',
                  51,
                  '蝴蝶型',
                  52,
                  '好朋友',
                  53),
           1,
           sysdate,
           'liqiao',
           sysdate,
           'liqiao',
           member_label_link_seq.nextval
      from dim_member h
     where h.clv_chgdate_key = endpoint
       and h.create_date_key != startpoint;
  commit;

  insert into member_label_link
    select h.member_bp,
           decode(h.clv_type_w,
                  '0单用户',
                  55,
                  '陌生人',
                  56,
                  '寄居蟹',
                  57,
                  '蝴蝶型',
                  58,
                  '好朋友',
                  59),
           1,
           sysdate,
           'liqiao',
           sysdate,
           'liqiao',
           member_label_link_seq.nextval
      from dim_member h
     where h.clv_chgdate_key = endpoint
       and h.create_date_key != startpoint;
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
end processlable_clvinc;
/

