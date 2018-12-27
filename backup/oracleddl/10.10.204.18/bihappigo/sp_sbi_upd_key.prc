???create or replace procedure bihappigo.sp_sbi_upd_key is

  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;
  startpoint  fact_page_view.id%type;
  endpoint    fact_page_view.id%type;

begin

  sp_name          := 'SP_SBI_UPD_KEY'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'W_PAGE_VIEW_F'; --此处需要手工录入该PROCEDURE操作的表格
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

  select min(a.id) into startpoint from fact_page_view a where a.flag = 0;
  select max(a.id) into endpoint from fact_page_view a where   a.flag = 0;

  declare
    type type_array
    
    is varray(800000) of number;
    var_array type_array;
    -- p_value varchar2(100);
    --p_key  number;
    -- p_id   number;
  begin
    select id bulk collect
      into var_array
      from fact_page_view
     where id between startpoint and endpoint
     order by id;
  
    forall j in var_array.first .. var_array.last
      update fact_page_view s
         set s.page_key       =
             (select page_key
                from dim_page
               where  page_name = (select page_name
                                    from fact_page_view
                                   where id = var_array(j))
              and    application_name=(select  application_name
                                    from fact_page_view
                                   where id = var_array(j))
              
              ),
             s.application_key =
             (select application_key
                from dim_application
               where application_name =
                     (select application_name
                        from fact_page_view
                       where id = var_array(j))),
             
             s.device_key =
             (select device_key
                from dim_device
               where device_name = (select device_name
                                      from fact_page_view
                                     where id = var_array(j)))
      
       where s.id = var_array(j);
  
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
  
end sp_sbi_upd_key;
/

