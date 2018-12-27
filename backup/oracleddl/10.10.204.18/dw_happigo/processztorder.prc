???create or replace procedure dw_happigo.processztorder (startpoint in number)
 is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;
  --startpoint  fact_page_view.id%type;
  -- endpoint    fact_page_view.id%type;
  /*
  功能说明：调度对SBI层W_SESSION_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-12
  */
begin
  sp_name          := 'processztorder'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'FACT_ZTGOODS'; --此处需要手工录入该PROCEDURE操作的表格
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
  
    type type_array is table of fact_ztorders%rowtype index by binary_integer; --类似二维数组 
    --s_key     number;
    --p_value     number;
    -- p_vid     VARCHAR2(1000);
    -- etime     date
    maxid     number;
    var_array type_array;
    -- 153659425 and  154616681 154459428 154699781
  begin
  
  delete from fact_ztordergoods;
  commit;
  
    select * bulk collect into var_array from fact_ztorders where ADDTIME_KEY=startpoint;
  
  
    for i in 1 .. var_array.count loop
    
      select max(id)
        into maxid
        from fact_page_view j0
       where j0.session_key = var_array(i).session_key
         and visit_date < var_array(i).addtime
         and page_key in (8101, 8102, 8925, 8926)
         and exists
       (select *
                from fact_ztgoods p1
               where p1.goods_code = var_array(i).goods_commonid
                 and p1.zt_id = to_number(j0.page_value)
                 and p1.zt_type_name = j0.page_name);
    
      insert into fact_ztordergoods
        (zt_type_name,
         zt_id,
         session_key,
         vid,
         visit_date,
         order_id,
         goods_commonid,
         goods_name,
         goods_num,
         goods_pay_price)
        select j1.page_name,
               to_number(j1.page_value),
               j1.session_key,
               j1.vid,
               j1.visit_date,
               var_array(i).order_id,
               var_array(i).goods_commonid,
               var_array(i).goods_name,
               var_array(i).goods_num,
               var_array(i).goods_pay_price
          from fact_page_view j1
         where j1.id = maxid;
    
      commit;
    
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
  
end processztorder;
/

