???create or replace procedure dw_user.processmemberorders(startid in number) is
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
  sp_name          := 'processmemberorders'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'LS_MEMBER_ORDER'; --此处需要手工录入该PROCEDURE操作的表格
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
  type type_arrays is record(member_key number(20));

  type type_array is table of type_arrays index by binary_integer; --类似二维数组 

  var_array type_array;
  begin
    insert_rows := 0;
    select * bulk collect
      into var_array
      from (select p.member_key
              from (select member_key, rownum rn
                      from ls_member_order
                     where status = 0) p
             where p.rn between 0 and startid);
  
    for i in 1 .. var_array.count loop
      update ls_member_order l
         set (l.ORDER_NUM,
              l.order_first,
              l.order_last,
              l.ORDER_CANCEL_DATE,
              l.ORDER_CANCEL_NUM,
              l.ORDER_CANCEL_AMOUNT,
              l.ORDER_AMOUNT,
              l.ORDER_EC_NUM,
              l.ORDER_ONE_DATE,
              l.ORDER_One_AMOUNT,
              l.ORDER_one_SOURCE,
              l.ORDER_TWO_DATE,
              l.ORDER_TWO_AMOUNT,
              l.ORDER_two_SOURCE,
              l.ORDER_THREE_DATE,
              l.ORDER_THREE_AMOUNT,
              l.ORDER_THREE_SOURCE,
              l.ORDER_FOUR_DATE,
              l.ORDER_FOUR_AMOUNT,
              l.ORDER_FOUR_SOURCE,
              l.FOUR_AVERAGE_DAY,
              l.status) =
             (select pp1.order_num           as order_num,
                     pp1.ORDER_FIRST         as ORDER_FIRST,
                     pp1.ORDER_LAST          as ORDER_LAST,
                     pp2.ORDER_CANCEL_DATE   as ORDER_CANCEL_DATE,
                     pp3.ORDER_CANCEL_NUM    as ORDER_CANCEL_NUM,
                     pp3.ORDER_CANCEL_AMOUNT as ORDER_CANCEL_AMOUNT,
                     pp4.ORDER_AMOUNT        as ORDER_AMOUNT,
                     pp4.ORDER_EC_NUM        as ORDER_EC_NUM,
                     pp5.ORDER_ONE_DATE      as ORDER_ONE_DATE,
                     pp5.ORDER_ONE_AMOUNT    as ORDER_ONE_AMOUNT,
                     pp5.ORDER_ONE_SOURCE    as ORDER_ONE_SOURCE,
                     p1.ORDER_TWO_DATE       as order_two_date,
                     p1.ORDER_TWO_AMOUNT     as ORDER_TWO_AMOUNT,
                     p1.ORDER_TWO_SOURCE     as ORDER_TWO_SOURCE,
                     p2.ORDER_TWO_DATE       as order_three_date,
                     p2.ORDER_TWO_AMOUNT     as ORDER_three_AMOUNT,
                     p2.ORDER_TWO_SOURCE     as ORDER_three_SOURCE,
                     p3.ORDER_TWO_DATE       as order_four_date,
                     p3.ORDER_TWO_AMOUNT     as ORDER_four_AMOUNT,
                     p3.ORDER_TWO_SOURCE     as ORDER_four_SOURCE,
                     p4.FOUR_AVERAGE_DAY     as FOUR_AVERAGE_DAY,
                     1                       as status
                from (select count(1) as ORDER_NUM,
                             min(o.posting_date_key) as ORDER_FIRST,
                             max(o.posting_date_key) as ORDER_LAST,
                             min(o.member_key) as member_key
                        from fact_order o
                       where ((o.order_state = 1 and o.pre_order_state = 0) or
                             (o.order_state = 1 and o.pre_order_state = 1 and
                             o.order_desc != 'TA10'))
                         AND o.member_key = var_array(i).member_key) pp1 left join
                     (select max(o.posting_date_key) as ORDER_CANCEL_DATE,
                             min(o.member_key) as member_key
                        from fact_order_reverse o
                       where o.Order_type = 0
                         and o.Cancel_state = 0 --退货的，且成功的
                         and o.member_key = var_array(i).member_key) pp2 on pp1.member_key = pp2.member_key left join
                     (select count(1) as ORDER_CANCEL_NUM,
                             sum(o.order_amount) as ORDER_CANCEL_AMOUNT,
                             min(o.member_key) as member_key
                        from fact_order_reverse o
                       where o.Sales_Source_key = 20
                         and o.Order_type = 0
                         and o.Cancel_state = 0
                         and o.member_key = var_array(i).member_key) pp3 on pp1.member_key = pp3.member_key left join
                     (select sum(z.ORDER_AMOUNT) as ORDER_AMOUNT,
                             count(1) as ORDER_EC_NUM,
                             min(z.member_key) as member_key
                        from fact_order z
                       where z.member_key = var_array(i).member_key
                         and ((z.order_state = 1 and z.pre_order_state = 0) or
                             (z.order_state = 1 and z.pre_order_state = 1 and
                             z.order_desc != 'TA10'))
                         and z.Sales_Source_key = 20) pp4 on pp1.member_key = pp4.member_key left join
                     (select pp.posting_date_key        as ORDER_ONE_DATE,
                             pp.order_amount            as ORDER_ONE_AMOUNT,
                             pp.Sales_Source_second_key as ORDER_ONE_SOURCE,
                             pp.member_key              as member_key
                        from fact_order pp
                       where order_key =
                             (select OOO.order_key
                                from (select OO.order_key, rownum rn
                                        from (select o.order_key
                                                from fact_order O
                                               where O.member_key = var_array(i).member_key and o.sales_source_key=20
                                               order by O.posting_date_key asc) OO) OOO
                               where OOO.rn = 1)) pp5 on pp1.member_key = pp5.member_key left join
                     (select pp.posting_date_key        as ORDER_TWO_DATE,
                             pp.order_amount            as ORDER_TWO_AMOUNT,
                             pp.Sales_Source_second_key as ORDER_TWO_SOURCE,
                             pp.member_key              as member_key
                        from fact_order pp
                       where pp.order_key =
                             (select OOO.order_key
                                from (select OO.order_key, rownum rn
                                        from (select o.order_key
                                                from fact_order O
                                               where O.member_key = var_array(i).member_key and o.sales_source_key=20
                                               order by O.posting_date_key asc) OO) OOO
                               where OOO.rn = 2)) p1 on pp1.member_key = p1.member_key left join
                     (select pp.posting_date_key        as ORDER_TWO_DATE,
                             pp.order_amount            as ORDER_TWO_AMOUNT,
                             pp.Sales_Source_second_key as ORDER_TWO_SOURCE,
                             pp.member_key              as member_key
                        from fact_order pp
                       where pp.order_key =
                             (select OOO.order_key
                                from (select OO.order_key, rownum rn
                                        from (select o.order_key
                                                from fact_order O
                                               where O.member_key = var_array(i).member_key and o.sales_source_key=20
                                               order by O.posting_date_key asc) OO) OOO
                               where OOO.rn = 3)) p2 on pp1.member_key = p2.member_key left join
                     (select pp.posting_date_key        as ORDER_TWO_DATE,
                             pp.order_amount            as ORDER_TWO_AMOUNT,
                             pp.Sales_Source_second_key as ORDER_TWO_SOURCE,
                             pp.member_key              as member_key
                        from fact_order pp
                       where pp.order_key =
                             (select OOO.order_key
                                from (select OO.order_key, rownum rn
                                        from (select o.order_key
                                                from fact_order O
                                               where O.member_key = var_array(i).member_key and o.sales_source_key=20
                                               order by O.posting_date_key asc) OO) OOO
                               where OOO.rn = 4)) p3 on pp1.member_key = p3.member_key left join
                     (select (case
                               when ps.total <= 1 then
                                0
                               else
                                to_number(ps.days / (ps.total - 1))
                             end) as FOUR_AVERAGE_DAY,
                             ps.member_key as member_key
                        from (
                              
                              select trunc(to_date(max(OOO.posting_date_key),
                                                    'yyyy-mm-dd') -
                                            to_date(min(OOO.posting_date_key),
                                                    'yyyy-mm-dd')) as days,
                                      count(1) as total,
                                      min(ooo.member_key) as member_key
                                from (select OO.posting_date_key,oo.member_key, rownum rn
                                         from (select o.posting_date_key,o.member_key
                                                 from fact_order O
                                                where O.member_key = var_array(i).member_key and o.sales_source_key=20
                                                order by O.posting_date_key asc) OO) OOO
                               where OOO.rn >= 4) ps) p4 on pp1.member_key = p4.member_key)
       where l.member_key = var_array(i).member_key;
      commit;
      insert_rows := insert_rows+1;
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
  
end processmemberorders;
/

