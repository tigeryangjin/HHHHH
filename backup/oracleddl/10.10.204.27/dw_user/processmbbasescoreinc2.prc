???create or replace procedure dw_user.processmbbasescoreinc2(startpoint number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processmbbasescoreinc2'; --需要手工填入所写PROCEDURE的名称
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

  delete from tmp_member_score2;
  commit;

  insert into tmp_member_score2
    (member_key,
     livecount,
     ec_goods_count,
     tv_goods_count,
     livescore,
     ec_goods_score,
     tv_goods_score)
  
    select b.member_key,
           nvl(count(distinct(case
                                when b.live_state = 1 then
                                 b.order_key
                              end)),
               0) as livecount,
           nvl(count(distinct(case
                                when b.ec_goods_state = 1 then
                                 b.order_key
                              end)),
               0) as ec_goods_count,
           nvl(count(distinct(case
                                when b.tv_goods_state = 1 then
                                 b.order_key
                              end)),
               0) as tv_goods_count,
           nvl(count(distinct(case
                                when b.live_state = 1 then
                                 b.order_key
                              end)),
               0) * 2 as livescore,
           nvl(count(distinct(case
                                when b.ec_goods_state = 1 then
                                 b.order_key
                              end)),
               0) * -1.5 as ec_goods_score,
           nvl(count(distinct(case
                                when b.tv_goods_state = 1 then
                                 b.order_key
                              end)),
               0) * 0.5 as tv_goods_score
    
      from fact_goods_sales b
     where order_date_key = startpoint -- to_number(to_char(sysdate - 1, 'yyyymmdd'))
       and sales_source_key = 20
       and order_state = 1
       and tran_type = 0
     group by b.member_key;

  commit;

  declare
  
    type type_array is table of tmp_member_score2%rowtype index by binary_integer; --类似二维数组 
    var_array type_array;
    --minday    number;
    --maxday    number;
    --daycount  number;
    --timecount number;
  
  begin
  
    select * bulk collect into var_array from tmp_member_score2 j1;
  
    for i in 1 .. var_array.count loop
    
      update dim_member_base k1
         set k1.live_count      = k1.live_count + var_array(i).livecount,
             k1.live_good_score = k1.live_good_score + var_array(i)
                                 .livescore,
             k1.tv_good_count   = k1.tv_good_count + var_array(i)
                                 .tv_goods_count,
             k1.tv_good_score   = k1.tv_good_score + var_array(i)
                                 .tv_goods_score,
             k1.web_good_count  = k1.web_good_count + var_array(i)
                                 .ec_goods_count,
             k1.ec_good_score   = k1.ec_good_score + var_array(i)
                                 .ec_goods_score
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
end processmbbasescoreinc2;
/

