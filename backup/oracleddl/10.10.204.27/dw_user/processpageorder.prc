???create or replace procedure dw_user.processpageorder(startpoint in number) is
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
  sp_name          := 'processpageorder'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_pageorders'; --此处需要手工录入该PROCEDURE操作的表格
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
  
    type type_array is table of fact_pageorders%rowtype index by binary_integer; --类似二维数组 
  
    maxid     number;
    var_array type_array;
  begin
  
    delete from fact_pagegoods_detail;
    commit;
  
    select * bulk collect
      into var_array
      from fact_pageorders
     where add_time = startpoint;
  
    for i in 1 .. var_array.count loop
    
      select max(j0.id)
        into maxid
        from fact_pagegoods j0
       where j0.session_key = var_array(i).session_key
         and j0.goodcode = var_array(i).goods_commonid
         and j0.visit_date < var_array(i).addtime
         and j0.page_key not in (-1, 0, 6376, 7081);
    
      insert into fact_pagegoods_detail
        (page_key,
         page_value,
         page_name,
         application_key,
         goodcode,
         session_key,
         vid,
         visit_date,
         page_staytime,
         order_id,
         vvid,
         goods_num,
         goods_pay_price,
         goods_commonid,
         goods_name,
         addtime,
         add_time,
         matdlt,
         brand_name,
         is_tv
         
         )
        select j1.page_key,
               j1.page_value,
               j1.page_name,
               j1.application_key,
               j1.goodcode,
               j1.session_key,
               j1.vid,
               j1.visit_date,
               j1.page_staytime,
               var_array       (i).order_id,
               var_array       (i).vid,
               var_array       (i).goods_num,
               var_array       (i).goods_pay_price,
               var_array       (i).goods_commonid,
               var_array       (i).goods_name,
               var_array       (i).addtime,
               var_array       (i).add_time,
               var_array       (i).matdlt,
               var_array       (i).brand_name,
               var_array       (i).is_tv
        
          from fact_pagegoods j1
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
  
end processpageorder;
/

