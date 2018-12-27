???create or replace procedure dw_user.prcoess_page_source(startpoint in number,
endpoint in number
) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;
  /*
  功能说明：调度对SBI层W_SESSION_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-12
  */
begin
  sp_name          := 'prcoess_page_source'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_page_view_click_2'; --此处需要手工录入该PROCEDURE操作的表格
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
  --586386213
  delete from fact_page_view_click;
  delete from fact_page_view_click_2;
  delete from fact_page_view_click3;
  commit;

  insert into fact_page_view_click
  
    select *
      from fact_page_view_hit v1
     where visit_date_key = endpoint
       and hit_is = 1
       and exists (select *
              from dim_resource_2_page v2
             where v2.page_name = v1.page_name);

  commit;
  insert into fact_page_view_click_2
    select l1.*
      from fact_page_view_hit l1
     where l1.visit_date_key between startpoint and endpoint
       and exists (select *
              from dim_resource_1_page l2
             where l2.page_name = l1.page_name);
  commit;

  declare
  
    type type_array is table of fact_page_view_click%rowtype index by binary_integer; --类似二维数组 
    v_date    date;
    p_name    varchar2(50);
    var_array type_array;
  
  begin
  
    select * bulk collect
      into var_array
      from fact_page_view_click e
     order by id;
  
    for i in 1 .. var_array.count loop
    
      select nvl(max(visit_date), sysdate)
        into v_date
        from fact_page_view_click_2 a
       where a.vid = var_array(i).vid
         and a.visit_date < var_array(i).visit_date;
    
      select nvl(max(a.page_name), 'unknown')
        into p_name
        from fact_page_view_click_2 a
       where a.vid = var_array(i).vid
         and a.visit_date = v_date;
    
      insert into fact_page_view_click3
        select p_name, x1.*
          from fact_page_view_click x1
         where x1.id = var_array(i).id;
    
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
  
end prcoess_page_source;
/

