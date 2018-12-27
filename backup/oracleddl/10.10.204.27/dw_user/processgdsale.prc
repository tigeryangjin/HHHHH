???create or replace procedure dw_user.processgdsale(startpoint number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processgdsale'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_goods_sales'; --此处需要手工录入该PROCEDURE操作的表格
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
  
    type type_array is table of fact_goods_sales%rowtype index by binary_integer; --类似二维数组 
    var_array type_array;
    ordercnt  number;
  begin
    --20160801 and 20170117
    select * bulk collect
      into var_array
      from fact_goods_sales e
     where e.order_date_key=startpoint;--to_number(to_char(sysdate - 1, 'yyyymmdd'));
  
    delete from tmp_0902;
    commit;
  
    for i in 1 .. var_array.count loop
    
      insert into tmp_0902 values (1, var_array(i).member_key);
      commit;
    
      select nvl(max(distinct
                     to_number(substr(to_char(cc.goods_key), 1, 6))),
                 0)
        into ordercnt
        from fact_goods_sales cc
       where cc.order_key = var_array(i).order_key
         and cc.goods_key = var_array(i).goods_key;
    

    
    
      if get_mdgroup(ordercnt) = 2000 then
        update fact_goods_sales cc
           set cc.ec_goods_state = 1
         where cc.order_key = var_array(i).order_key
           and cc.goods_key = var_array(i).goods_key;
        commit;
      else
      
        update fact_goods_sales cc
           set cc.tv_goods_state = 1
         where cc.order_key = var_array(i).order_key
           and cc.goods_key = var_array(i).goods_key;
        commit;
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
  
end processgdsale;
/

