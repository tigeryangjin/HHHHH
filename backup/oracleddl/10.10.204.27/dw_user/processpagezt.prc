???create or replace procedure dw_user.processpagezt(startpoint in number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;
  -- startpoint  fact_page_view.id%type;
  -- endpoint    fact_page_view.id%type;
  /*
  功能说明：调度对SBI层W_SESSION_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-12
  */
begin
  sp_name          := 'processpagezt'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_pagegoods'; --此处需要手工录入该PROCEDURE操作的表格
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
  
    type type_array is table of fact_pagegoods%rowtype index by binary_integer; --类似二维数组 
  
    var_array type_array;
    count_key number;
    p_key     number;
    p_value   varchar2(50);
    p_name    varchar2(50);
    sql_stmt  varchar2(200);
  begin
    sql_stmt := 'create table fact_page_view_daily ' ||
                ' as select * from  fact_page_view' ||
                ' where visit_date_key=' || startpoint;
    execute immediate 'drop table fact_page_view_daily purge';
    execute immediate sql_stmt;
    execute immediate 'create index DAILYID_IDX on FACT_PAGE_VIEW_DAILY (ID) tablespace BIINDEX01';
    execute immediate 'create index SPID_IDX on FACT_PAGE_VIEW_DAILY (SESSION_KEY, PAGE_KEY, ID) tablespace BIINDEX01';
    execute immediate 'analyze index DAILYID_IDX compute statistics';
    execute immediate 'analyze index SPID_IDX compute statistics';
  
    select * bulk collect into var_array from fact_pagegoods;
    delete from tmp_0902;
    commit;
    for i in 1 .. var_array.count loop
    
      insert into tmp_0902 values (1, 123);
      commit;
      select /*+ index(b SPID_IDX) */
       nvl(max(b.id), 0)
        into count_key
        from fact_page_view_daily b
       where b.session_key = var_array(i).session_key
         and b.page_key in (8925,
                            8926,
                            41928,
                            41930,
                            40410,
                            40411,
                            36768,
                            36948,
                            36949,
                            36854,
                            45042,
                            111387,
                            111388,
                            111390,
                            111392
                            
                            )
         and b.id < var_array(i).id;
    
      if count_key > 0 then
      
        select /*+ index(b DAILYID_IDX) */
         b.page_key,
         b.page_value,
         --  to_number(var_array(i).page_value),
         (select nvl(a2.page_name, 'nopage')
            from dim_page_gn a2
           where a2.page_key = b.page_key) as page_name
          into p_key, p_value, p_name
          from fact_page_view_daily b
         where b.id = count_key;
      
        update fact_pagegoods b2
           set b2.page_key   = p_key,
               b2.page_name  = p_name,
               b2.page_value = p_value
         where b2.id = var_array(i).id;
      
      end if;
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
  
end processpagezt;
/

