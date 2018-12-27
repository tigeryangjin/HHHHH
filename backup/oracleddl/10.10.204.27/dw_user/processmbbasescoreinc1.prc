???create or replace procedure dw_user.processmbbasescoreinc1 (startpoint number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processmbbasescoreinc1'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'dim_member_base'; --此处需要手工录入该PROCEDURE操作的表格
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
  --= '00000000';

  delete from tmp_member_score1;
  commit;

  insert into tmp_member_score1
    (member_key, tvcount, eccount, tvscore, ecscore)
  
    select f.member_key,
           count(distinct(case
                            when f.sales_source_key = 10 then
                             order_key
                          end)) as tvcount,
           count(distinct(case
                            when f.sales_source_key = 20 then
                             order_key
                          end)) as eccount,
           count(distinct(case
                            when f.sales_source_key = 10 then
                             order_key
                          end)) * 1 as tvscore,
           count(distinct(case
                            when f.sales_source_key = 20 then
                             order_key
                          end)) * -1.5 as ecscore
      from fact_order f
     where order_date_key =startpoint-- to_number(to_char(sysdate - 1, 'yyyymmdd'))
       and order_state = 1
     group by f.member_key;

  commit;

  declare
  
    type type_array is table of tmp_member_score1%rowtype index by binary_integer; --类似二维数组 
    var_array type_array;
    --minday    number;
    --maxday    number;
    --daycount  number;
    --timecount number;
  
  begin
  
    select * bulk collect into var_array from tmp_member_score1 j1;
  
    for i in 1 .. var_array.count loop
    
      update dim_member_base k1
         set k1.tv_count  = k1.tv_count + var_array(i).tvcount,
             k1.tv_score  = k1.tv_score + var_array(i).tvscore,
             k1.web_count = k1.web_count + var_array(i).eccount,
             k1.web_score = k1.web_score + var_array(i).ecscore
       where k1.member_bp = var_array(i).member_key;
    
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
end processmbbasescoreinc1;
/

