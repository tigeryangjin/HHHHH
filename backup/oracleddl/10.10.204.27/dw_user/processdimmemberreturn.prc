???create or replace procedure dw_user.processdimmemberreturn is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processdimmemberreturn'; --需要手工填入所写PROCEDURE的名称
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
    --last_return_date number;
    --last_refuse_date number;
    --return_cnt       number;
    --refuse_cnt       number;
    cancel_count number;
  begin
  
    select * bulk collect
      into var_array
      from dim_member e
     where e.member_insert_date between '20160101' and '20160915';
  
    delete from tmp_0902;
    commit;
  
    for i in 1 .. var_array.count loop
    
      insert into tmp_0902 values (1, var_array(i).member_bp);
      commit;
    
      select /*+ index(v MEMBER_CANCEL_KEY) */
       nvl(count(v.order_key),0)
        into cancel_count
        from fact_order v
       where v.member_key = var_array(i).member_bp
         and v.cancel_before_state = 1
         and v.order_date_key <=
             to_number(to_char(sysdate - 1, 'yyyymmdd'));
    
      update dim_member l
         set l.cancer_count = cancel_count
       where l.member_bp = var_array(i).member_bp;
    
      --  select /*+ index(cc FOR_MEM_STAT_KEY) */
      /* nvl(max(case
                 when cc.reject_return = 10 then
                  cc.posting_date_key
               end),
           0) as last_return_date,
       nvl(max(case
                 when cc.reject_return = 20 then
                  cc.posting_date_key
               end),
           0) as last_refuse_date,
       nvl(count(case
                   when cc.reject_return = 10 then
                    cc.order_key
                 end),
           0) as return_count,
       nvl(count(case
                   when cc.reject_return = 20 then
                    cc.order_key
                 end),
           0) as refuse_count
        into last_return_date, last_refuse_date, return_cnt, refuse_cnt
      
        from fact_order_reverse cc
       where cc.member_key = var_array(i).member_bp
         and cc.cancel_state = 0
         and cc.posting_date_key <=
             to_number(to_char(sysdate - 1, 'yyyymmdd'));
      
      update dim_member l
         set l.last_return_date_key = last_return_date,
             l.last_refuse_date_key = last_refuse_date,
             l.return_count         = return_cnt,
             l.refuse_count         = refuse_cnt
       where l.member_bp = var_array(i).member_bp;*/
    
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
end processdimmemberreturn;
/

