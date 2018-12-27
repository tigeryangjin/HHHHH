???create or replace procedure dw_happigo.processztdetail(startpoint in number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;
  --startpoint  number;
  -- endpoint    fact_page_view.id%type;
  /*
  功能说明：调度对SBI层W_SESSION_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-12
  */
begin
  sp_name          := 'processztdetail'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_page_view'; --此处需要手工录入该PROCEDURE操作的表格
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
  
    type type_array is table of fact_page_view%rowtype index by binary_integer; --类似二维数组 
    --s_key     number;
    --p_value     number;
    -- p_vid     VARCHAR2(1000);
    -- etime     date
    -- minid     number;
    var_array type_array;
    -- 153659425 and  154616681 154459428 154699781
  begin
    delete from fact_ztgoods;
    delete from fact_ztorders;
    commit;
  
    select * bulk collect
      into var_array
      from fact_page_view
     where visit_date_key = startpoint
       and page_key in (8101, 8102, 8925, 8926)
       and page_value != 'undefined';
  
    for i in 1 .. var_array.count loop
    
      insert into fact_ztgoods
      
        (zt_type_name, zt_id, goods_code, session_key, vid, visit_date)
        select /*+ index(a1 ZT_IDX) */ var_array(i).page_name,
               to_number(var_array(i).page_value),
               to_number(a1.page_value),
               a1.session_key,
               a1.vid,
               a1.visit_date
          from fact_page_view a1
         where a1.session_key = var_array(i).session_key
           and a1.visit_date >= var_array(i).visit_date
           and a1.visit_date <= var_array(i).visit_date + 300 / 86400
           and a1.page_key in (2841, 1924, 6604, 6391)
           and a1.page_value != 'undefined'
           and exists
         (select *
                  from dim_zhuangti_goods a2
                 where a2.id = to_number(var_array(i).page_value)
                   and a2.zttype = var_array(i).page_name
                   and a2.goods_common_id = to_number(a1.page_value))
        
        ;
      commit;
    
    end loop;
  

   insert into fact_ztorders
      (order_id,
       goods_num,
       goods_pay_price,
       vid,
       goods_commonid,
       goods_name,
       session_key,
       addtime,
       addtime_key)
      select t4.order_id,
             t4.goods_num,
             t4.goods_pay_price,
             t4.vid,
             t4.goods_commonid,
             t4.goods_name,
             t2.session_key,
             t4.addtime,
             t4.add_time
        from (select *
                from fact_session t1
               where t1.start_date_key = startpoint
                 and exists
               (select *
                        from fact_ztgoods p1
                       where p1.session_key = t1.session_key)) t2,
             (select *
                from order_good t3
               where t3.add_time = startpoint
                 and exists
               (select *
                        from fact_ztgoods p2
                       where p2.goods_code = t3.goods_commonid)) t4
       where t2.member_key = t4.cust_no
         and t4.addtime >= t2.start_time
         and t4.addtime <= t2.end_time;
  
   
  
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
  
end processztdetail;
/

