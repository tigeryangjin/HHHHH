???create or replace procedure dw_user.processmemberordersrate(startid in number) is
  s_etl        w_etl_log%rowtype;
  sp_name      s_parameters2.pname%type;
  s_parameter  s_parameters1.parameter_value%type;
  insert_rows  number;
  crmpostdates number;
  total_nums   number;
  --endid number;
  --onetotal number;--一次取多少个
  /*
  功能说明：张全rfm模型用户数据
       
  
  作者时间：bobo  2016-04-06
  */

begin
  sp_name          := 'processmemberordersrate'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'LS_MEMBER_ORDER_RATE'; --此处需要手工录入该PROCEDURE操作的表格
  s_etl.proc_name  := sp_name;
  s_etl.start_time := sysdate;
  s_parameter      := 0;
  --onetotal         := 50000; --一次取5000记录循环
  begin
    sp_parameter_two(sp_name, s_parameter);
    if s_parameter = '0' then
      s_etl.err_msg := '没有找到对应的过程加载类型数据';
      sp_sbi_w_etl_log(s_etl);
      return;
    end if;
  end;
  declare
    type type_arrays is record(
      member_key number(20));
  
    type type_array is table of type_arrays index by binary_integer; --类似二维数组 
  
    var_array type_array;
  begin
    insert_rows := 0;
    select * bulk collect
      into var_array
      from (select p.member_key
              from (select member_key, rownum rn
                      from ls_member_order_rate
                     where state = 0) p
             where p.rn between 0 and startid);
    for i in 1 .. var_array.count loop
      update ls_member_order_rate l
         set (l.profit_one_amount,
              l.rate_one,
              l.profit_two_amount,
              l.rate_two,
              l.profit_three_amount,
              l.rate_three,
              l.profit_four_amount,
              l.rate_four,
              l.four_average_profit,
              l.four_average_rate,
              l.state) =
             (select p1.profit_one_amount,
                     p1.lilv_one            as rate_one,
                     p2.profit_two_amount,
                     p2.lilv_two            as rate_two,
                     p3.profit_three_amount,
                     p3.lilv_three          as rate_three,
                     p4.profit_four_amount,
                     p4.lilv_four           as rate_four,
                     p5.FOUR_AVERAGE_Profit,
                     p5.FOUR_AVERAGE_lilv   as four_average_rate,
                     1                      as state
                from (select pp.posting_date_key as ORDER_ONE_DATE,
                             pp.order_amount as ORDER_ONE_AMOUNT,
                             pp.Profit_amount as Profit_ONE_AMOUNT,
                             (case when pp.order_amount=0 then -1
                             else pp.Profit_amount / pp.order_amount * 100
                             end)
                              as lilv_one,
                             pp.member_key as member_key
                        from fact_order pp
                       where order_key =
                             (select OOO.order_key
                                from (select OO.order_key, rownum rn
                                        from (select o.order_key
                                                from fact_order O
                                               where O.member_key = var_array(i)
                                                    .member_key
                                                 and o.sales_source_key = 20
                                                 and o.order_state = 1
                                               order by O.posting_date_key asc) OO) OOO
                               where OOO.rn = 1)) p1
                left join (select pp.posting_date_key as ORDER_two_DATE,
                                 pp.order_amount as ORDER_two_AMOUNT,
                                 pp.Profit_amount as Profit_two_AMOUNT,
                                 (case when pp.order_amount=0 then -1
                                 else pp.Profit_amount / pp.order_amount * 100
                                 end) as lilv_two,
                                 pp.member_key as member_key
                            from fact_order pp
                           where order_key =
                                 (select OOO.order_key
                                    from (select OO.order_key, rownum rn
                                            from (select o.order_key
                                                    from fact_order O
                                                   where O.member_key = var_array(i)
                                                        .member_key
                                                     and o.sales_source_key = 20
                                                     and o.order_state = 1
                                                   order by O.posting_date_key asc) OO) OOO
                                   where OOO.rn = 2)) p2
                  on p2.member_key = p1.member_key
                left join (select pp.posting_date_key as ORDER_three_DATE,
                                 pp.order_amount as ORDER_three_AMOUNT,
                                 pp.Profit_amount as Profit_three_AMOUNT,
                                 (case when pp.order_amount=0 then -1
                                 else pp.Profit_amount / pp.order_amount * 100
                                 end) as lilv_three,
                                 pp.member_key as member_key
                            from fact_order pp
                           where order_key =
                                 (select OOO.order_key
                                    from (select OO.order_key, rownum rn
                                            from (select o.order_key
                                                    from fact_order O
                                                   where O.member_key = var_array(i)
                                                        .member_key
                                                     and o.sales_source_key = 20
                                                     and o.order_state = 1
                                                   order by O.posting_date_key asc) OO) OOO
                                   where OOO.rn = 3)) p3
                  on p3.member_key = p1.member_key
                left join (select pp.posting_date_key as ORDER_four_DATE,
                                 pp.order_amount as ORDER_four_AMOUNT,
                                 pp.Profit_amount as Profit_four_AMOUNT,
                                 (case when pp.order_amount=0 then -1
                                 else pp.Profit_amount / pp.order_amount * 100
                                 end) as lilv_four,
                                 pp.member_key as member_key
                            from fact_order pp
                           where order_key =
                                 (select OOO.order_key
                                    from (select OO.order_key, rownum rn
                                            from (select o.order_key
                                                    from fact_order O
                                                   where O.member_key = var_array(i)
                                                        .member_key
                                                     and o.sales_source_key = 20
                                                     and o.order_state = 1
                                                   order by O.posting_date_key asc) OO) OOO
                                   where OOO.rn = 4)) p4
                  on p4.member_key = p1.member_key
                left join (select (case
                                   when ps.total < 1 then
                                    0
                                   else
                                    to_number(ps.Profit_amount / ps.total)
                                 end) as FOUR_AVERAGE_Profit,
                                 (case
                                   when ps.total < 1 then
                                    0
                                   else
                                    to_number(ps.order_amount / ps.total)
                                 end) as FOUR_AVERAGE_order,
                                 (case
                                   when ps.total < 1 then
                                    0
                                    when ps.order_amount=0 then 
                                     -1
                                   else
                                    to_number(ps.Profit_amount / ps.order_amount * 100)
                                 end) as FOUR_AVERAGE_lilv,
                                 ps.member_key as member_key
                            from (
                                  
                                  select sum(ooo.order_amount) as order_amount,
                                          sum(ooo.Profit_amount) as Profit_amount,
                                          count(1) as total,
                                          min(ooo.member_key) as member_key
                                    from (select OO.posting_date_key,
                                                  oo.member_key,
                                                  oo.Profit_amount,
                                                  oo.order_amount,
                                                  rownum rn
                                             from (select o.posting_date_key,
                                                          o.member_key,
                                                          o.Profit_amount,
                                                          o.order_amount
                                                     from fact_order O
                                                    where O.member_key = var_array(i)
                                                         .member_key
                                                      and o.sales_source_key = 20
                                                      and o.order_state = 1
                                                    order by O.posting_date_key asc) OO) OOO
                                   where OOO.rn > 4) ps) p5
                  on p5.member_key = p1.member_key)
       where l.member_key = var_array(i).member_key;
    
      commit;
      insert_rows := insert_rows + 1;
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
end processmemberordersrate;
/

