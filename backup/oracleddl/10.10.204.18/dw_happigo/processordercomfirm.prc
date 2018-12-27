???create or replace procedure dw_happigo.processordercomfirm is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;
  /*
  功能说明：调度对SBI层W_SESSION_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-12
  */
begin
  sp_name          := 'processordercomfirm'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_odcomfirm'; --此处需要手工录入该PROCEDURE操作的表格
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
  
    type type_array is table of fact_page_view%rowtype index by binary_integer; --类似二维数组 
    -- p_key     number;
    -- etime     date;
    mid number;
    --  minid     number;
    var_array type_array;
    --130876133  132171559
  begin
  
    select * bulk collect
      into var_array
      from fact_page_view j2
     where j2.visit_date_key = 20151122
       and j2.last_page_key in (1924, 2841)
       and j2.page_key in (1272,2844);
       
       
  
       
  
    --e.id between 23057539 and 23700037
    for i in 1 .. var_array.count loop
    
      select max(id)
        into mid
        from fact_page_view a
       where --a.visit_date_key =20151122-- var_array(i).visit_date_key
         a.visitor_key = var_array(i).visitor_key
         and a.application_key = var_array(i).application_key
         and a.id < var_array(i).id
         --and a.page_key in (2664, 3501)
         ;
    
    
    
      insert into fact_odcomfirm
      
        (id,
         hmsc_key,
         visitor_key,
         visit_date_key,
         fromgoods_id,
         fromgoodsstaytime)
      
        select
        
         var_array       (i).id        as id,
         var_array       (i).hmsc_key        as hmsc_key,
         var_array       (i).visitor_key        as visitor_key,
         h.visit_date_key,
         h.page_value     as fromgoods_id,
         h.page_staytime  as fromgoodsstaytime
          from fact_page_view h
         where h.id = mid;
    
      if mod(i, 1000) = 0 then
        commit;
      end if;
    
    end loop;
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
  
end processordercomfirm;
/

