???create or replace procedure dw_user.processdimmemberodinc3 is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processdimmemberodinc3'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'dim_member'; --此处需要手工录入该PROCEDURE操作的表格
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
  declare
  
    type type_array is table of dim_member%rowtype index by binary_integer; --类似二维数组 
    var_array type_array;
  
    tv_alive_cnt  number;
    tv_nolive_cnt number;
    self_cnt      number;
  
  begin
  
    select * bulk collect
      into var_array
      from dim_member e
     where e.create_date_key = 20141017; -- between '20060301' and '20061231';
  
    delete from tmp_0902;
    commit;
  
    for i in 1 .. var_array.count loop
    
      insert into tmp_0902 values (1, var_array(i).member_bp);
      commit;
      select /*+ index(t1 GS_EC_ORDER) */
       nvl(count(distinct(case
                            when t1.live_state = 1 and t1.order_state = 1 then
                             t1.order_key
                          end)),
           0),
       nvl(count(distinct(case
                            when t1.live_state != 1 and t1.order_state = 1 then
                             t1.order_key
                          end)),
           0),
       
       nvl(count(distinct(case
                            when t1.ec_goods_state = 1 and t1.order_state = 1 then
                             t1.order_key
                          end)),
           0)
      
        into tv_alive_cnt, tv_nolive_cnt, self_cnt
      
        from fact_goods_sales t1
       where t1.member_key = var_array(i).member_bp
         and t1.order_date_key <=
             to_number(to_char(sysdate - 1, 'yyyymmdd'));
    
      update /*+ index(l MEMBER_BP_IDX) */ dim_member l
         set l.tv_alive_count    = tv_alive_cnt,
             l.tv_nonalive_count = tv_nolive_cnt,
             l.self_count        = self_cnt
       where l.member_bp = var_array(i).member_bp;
    
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
end processdimmemberodinc3;
/

