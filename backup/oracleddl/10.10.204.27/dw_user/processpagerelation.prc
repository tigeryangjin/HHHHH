???create or replace procedure dw_user.processpagerelation(startpoint1 in number,
                                                startpoint2 in number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;
  startpoint  fact_page_view.id%type;
  endpoint    fact_page_view.id%type;
  /*
  功能说明：调度对SBI层W_SESSION_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-12
  */
begin
  sp_name          := 'processpagerelation'; --需要手工填入所写PROCEDURE的名称
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
  --586386213
  select nvl(min(id), 0)
    into startpoint
    from fact_page_view
   where visit_date_key between startpoint1 and startpoint2 --to_number(to_char((sysdate), 'yyyymmdd'))
     and last_page_key is null;
  select nvl(max(id), 0)
    into endpoint
    from fact_page_view
   where visit_date_key between startpoint1 and startpoint2 --to_number(to_char((sysdate), 'yyyymmdd'))
     and last_page_key is null;

  declare
  
    type type_array is table of fact_page_view%rowtype index by binary_integer; --类似二维数组 
    p_key     number;
    p_value   varchar2(1000);
    mid       number;
    var_array type_array;
  
  begin
  
    select *
      bulk collect
      into var_array
      from fact_page_view e
     where e.id between startpoint and endpoint
     order by e.id;
  
    for i in 1 .. var_array.count loop
    
      select /*+ index(a FPV_VISITOR) */
       nvl(max(a.id), var_array(i).id)
        into mid
        from fact_page_view a
       where a.id < var_array(i).id
         and a.id > 650000000
         and a.device_key = var_array(i).device_key
         and a.application_key = var_array(i).application_key;
    
      select /*+ index(z FPV_ID) */
       z.page_key
        into p_key
        from fact_page_view z
       where z.id = mid;
    
      select /*+ index(z FPV_ID) */
       z.page_value
        into p_value
        from fact_page_view z
       where z.id = mid;
    
      update /*+ index(s FPV_ID) */ fact_page_view s
         set s.last_page_key = p_key, s.hmkw = p_value
       where id = var_array(i).id;
    
      if mod(i, 1000) = 0
      then
        commit;
      end if;
    
    end loop;
    commit;
  
    update fact_page_view h2
       set h2.last_page_key = 0
     where h2.id between startpoint and endpoint
       and h2.last_page_key is null;
    commit;
  end;

  /*日志记录模块*/
  s_etl.end_time       := sysdate;
  s_etl.etl_record_ins := insert_rows;
  s_etl.err_msg        := '输入参数[startpoint1]:' || startpoint1 ||
                          ',[startpoint2]:' || startpoint2;
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
  
end processpagerelation;
/

