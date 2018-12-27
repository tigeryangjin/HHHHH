???create or replace procedure dw_user.processtopichot is
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
  sp_name          := 'processtopichot'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'g_activity_head'; --此处需要手工录入该PROCEDURE操作的表格
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
  
    type type_array is table of g_activity_head%rowtype index by binary_integer; --类似二维数组 
  
    var_array type_array;
    count_key number;
    z_key     number;
  
  begin
  
    select * bulk collect
      into var_array
      from g_activity_head vv3
     where  vv3.flag=0 and regexp_count(vv3.html_code, 'toProductDetail') > 0
     order by id;
  
    for i in 1 .. var_array.count loop
    
      select regexp_count(vv5.html_code, 'toProductDetail'),var_array(i).id
        into count_key, z_key
        from g_activity_head vv5
       where vv5.id = var_array(i).id;
    
      for i2 in 1 .. count_key loop
      
        insert into fact_htmlcode_item
          select d1.id,
                 d1.groupid,
                 d1.act_id,
                 d1.createtime,
                 --d1.html_code,
                 --INSTR(d1.html_code,'toProductDetail', 1, 2),
                 substr(d1.html_code,
                        instr(d1.html_code, 'toProductDetail', 1, i2) + 16,
                        13) as html_code_item,
                 0
          
            from g_activity_head d1
           where d1.id = z_key;
        commit;
      
      end loop;
    
    end loop;
  
  update g_activity_head set flag=1;
  commit;
  
  
  
  insert into fact_htmlcode_item_real
select wy.id,wy.groupid,wy.act_id,
to_number(to_char(unix_to_oracle(wy.createtime),'yyyymmdd')) as createtime,
to_number(wy.html_item) as html_item
from
(select 
       yy.id,
       yy.groupid,
       yy.act_id,
       yy.createtime,
       --yy.html_code_item,
      substr(yy.html_code_item, 8, 6) as html_item,
      yy.flag
  from fact_htmlcode_item yy) wy where wy.flag=0 and regexp_like(wy.html_item,'(^[0-9])');
  
  
   update fact_htmlcode_item set flag=1;
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
  
end processtopichot;
/

