???create or replace procedure dw_user.processhminit is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;
  --startpoint  number;
  -- endpoint    fact_page_view.id%type;
  /*
  功能说明：调度对SBI层W_SESSION_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-12
  */
begin
  sp_name          := 'processhminit'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'tmp_tbl_hmsc'; --此处需要手工录入该PROCEDURE操作的表格
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

  declare
  
    type type_array is table of dim_date%rowtype index by binary_integer; --类似二维数组 
  
    var_array type_array;
  
  begin
  
    select * bulk collect
      into var_array
      from dim_date
     where date_key between 20170101 and 20170630
     order by date_key;
  
    for i in 1 .. var_array.count loop
    
      insert into tmp_tbl_hmsc
        (c_date_key, application_key, hmmd, hmpl, custcnt)
      
        select var_array(i).date_key as c_date_key,
               decode(x1.application_key, 10, 'IOS', 20, 'ANDROID') as application_key,
               (select z1.hmmd from dim_hmsc z1 where z1.hmsc = x1.hmsc) as hmmd,
               (select z1.hmpl from dim_hmsc z1 where z1.hmsc = x1.hmsc) as hmpl,
               
               count(x1.member_key) as custcnt
          from fact_visitor_register x1
         where x1.application_key in (10, 20)
           and exists
         (select *
                  from dim_vid_mem x2
                 where x2.vid = x1.vid
                   and exists
                 (select *
                          from fact_ecmember x3
                         where x3.member_time = var_array(i).date_key
                           and x3.register_appname in
                               ('KLGAndroid', 'KLGiPhone')
                           and x3.member_crmbp = x2.member_key))
         group by var_array(i).date_key, x1.application_key, x1.hmsc;
    
      commit;
    
    end loop;
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
  
end processhminit;
/

