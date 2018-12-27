???create or replace procedure dw_user.processmemberorder(startid in number,
                                               endid   in number) is
  s_etl        w_etl_log%rowtype;
  sp_name      s_parameters2.pname%type;
  s_parameter  s_parameters1.parameter_value%type;
  insert_rows  number;
  crmpostdates number;
  total_nums   number;
  --endid number;
  --onetotal number;--一次取多少个
  /*
  功能说明：对订单数据进行增量抽取
       
  
  作者时间：bobo  2016-04-06
  */

begin
  sp_name          := 'processmemberorder'; --需要手工填入所写PROCEDURE的名称
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
  --先把未入库的会员先入库
  insert into ls_member_order
    (MEMBER_KEY, REGISTER_DATE_KEY, media)
    select o.*
      from (select to_number(p.member_key) as MEMBER_KEY,
                   pp.register_date_key,
                   pp.media
              from (select distinct (member_key) as member_key
                      from fact_order
                     where posting_date_key between startid and endid
                       and order_state = 1
                       and Sales_Source_key = 20) p
              left join fact_member_register pp
                on p.member_key = pp.member_key) o
     where o.member_key not in (select member_key from ls_member_order);

  s_etl.err_msg := sql%rowcount || '会员';

  --清洗订单方面的数据
  update ls_member_order l
     set (l.ORDER_NUM, l.ORDER_FIRST, l.ORDER_LAST) =
         (select count(1) as ORDER_NUM,
                 min(o.posting_date_key) as ORDER_FIRST,
                 max(o.posting_date_key) as ORDER_LAST
            from fact_order o
           where ((o.order_state = 1 and o.pre_order_state = 0) or
                 (o.order_state = 1 and o.pre_order_state = 1 and
                 o.order_desc != 'TA10'))
             AND o.member_key = l.member_key)
   where l.member_key in (select distinct (member_key) as member_key
                            from fact_order
                           where posting_date_key between startid and endid
                             and order_state = 1
                             and Sales_Source_key = 20);

  --清洗最后一次取消的时间
  update ls_member_order l
     set (ORDER_CANCEL_DATE) =
         (select max(o.posting_date_key) as ORDER_CANCEL_DATE
            from fact_order_reverse o
           where o.Order_type = 0
             and o.Cancel_state = 0 --退货的，且成功的
             and o.member_key = l.member_key)
   where l.member_key in (select distinct (member_key) as member_key
                            from fact_order
                           where posting_date_key between startid and endid
                             and order_state = 1
                             and Sales_Source_key = 20);

  --清洗取消成功次数，以及取消金额      
  update ls_member_order l
     set (l.ORDER_CANCEL_NUM, l.ORDER_CANCEL_AMOUNT) =
         (select count(1) as ORDER_CANCEL_NUM,
                 sum(o.order_amount) as ORDER_CANCEL_AMOUNT
            from fact_order_reverse o
           where o.Sales_Source_key = 20
             and o.Order_type = 0
             and o.Cancel_state = 0
             and o.member_key = l.member_key)
   where l.member_key in (select distinct (member_key) as member_key
                            from fact_order
                           where posting_date_key between startid and endid
                             and order_state = 1
                             and Sales_Source_key = 20);

  --清洗电商有效订购
  update ls_member_order l
     set (l.order_amount,ORDER_EC_NUM) =
         (select sum(z.ORDER_AMOUNT) as ORDER_AMOUNT,count(1) as ORDER_EC_NUM
            from fact_order z
           where z.member_key = l.member_key
             and ((z.order_state = 1 and z.pre_order_state = 0) or
                 (z.order_state = 1 and z.pre_order_state = 1 and
                 z.order_desc != 'TA10'))
             and z.Sales_Source_key = 20)
   where l.member_key in (select distinct (member_key) as member_key
                            from fact_order
                           where posting_date_key between startid and endid
                             and order_state = 1
                             and Sales_Source_key = 20);

  --清洗第一次订购                           
  update ls_member_order l
     set (l.ORDER_ONE_DATE, l.ORDER_ONE_AMOUNT, l.ORDER_ONE_SOURCE) =
         (select pp.posting_date_key        as ORDER_ONE_DATE,
                 pp.order_amount            as ORDER_ONE_AMOUNT,
                 pp.Sales_Source_second_key as ORDER_ONE_SOURCE
            from fact_order pp
           where order_key =
                 (select min(z.order_key) as order_key
                    from fact_order z
                   where z.member_key = l.member_key
                     and ((z.order_state = 1 and z.pre_order_state = 0) or
                         (z.order_state = 1 and z.pre_order_state = 1 and
                         z.order_desc != 'TA10'))
                     and z.Sales_Source_key = 20))
   where l.member_key in (select distinct (member_key) as member_key
                            from fact_order
                           where posting_date_key between startid and endid
                             and order_state = 1
                             and Sales_Source_key = 20);
  --清洗第二次订购                           
  /*update ls_member_order l
     set (l.ORDER_TWO_DATE, l.ORDER_TWO_AMOUNT, l.ORDER_TWO_SOURCE) =
         (select pp.posting_date_key        as ORDER_TWO_DATE,
                 pp.order_amount            as ORDER_TWO_AMOUNT,
                 pp.Sales_Source_second_key as ORDER_TWO_SOURCE
                                from (select O.*, rownum rn
                                                from fact_order O
                                               where o.member_key = pp.member_key
                                               order by O.order_key asc)  pp
                               where pp.rn = 2 and pp.member_key=l.member_key) 
   where l.member_key in (select distinct (member_key) as member_key
                            from fact_order
                           where posting_date_key between startid and endid
                             and order_state = 1
                             and Sales_Source_key = 20);*/
  --第二次，三次，四次订购数据清洗

  declare
  
    type type_array is table of ls_member_order%rowtype index by binary_integer; --类似二维数组 
  
    var_array type_array;
  begin
  
    select * bulk collect
      into var_array
      from ls_member_order
     where member_key in (select distinct (member_key) as member_key
                            from fact_order
                           where posting_date_key between startid and endid
                             and order_state = 1
                             and Sales_Source_key = 20);
    for i in 1 .. var_array.count loop
      update ls_member_order l
         set (l.ORDER_TWO_DATE,
              l.ORDER_TWO_AMOUNT,
              l.ORDER_two_SOURCE,
              l.ORDER_THREE_DATE,
              l.ORDER_THREE_AMOUNT,
              l.ORDER_THREE_SOURCE,
              l.ORDER_FOUR_DATE,
              l.ORDER_FOUR_AMOUNT,
              l.ORDER_FOUR_SOURCE,
              l.FOUR_AVERAGE_DAY) =
             (select p1.ORDER_TWO_DATE   as order_two_date,
                     p1.ORDER_TWO_AMOUNT as ORDER_TWO_AMOUNT,
                     p1.ORDER_TWO_SOURCE as ORDER_TWO_SOURCE,
                     p2.ORDER_TWO_DATE   as order_three_date,
                     p2.ORDER_TWO_AMOUNT as ORDER_three_AMOUNT,
                     p2.ORDER_TWO_SOURCE as ORDER_three_SOURCE,
                     p3.ORDER_TWO_DATE   as order_four_date,
                     p3.ORDER_TWO_AMOUNT as ORDER_four_AMOUNT,
                     p3.ORDER_TWO_SOURCE as ORDER_four_SOURCE,
                     p4.FOUR_AVERAGE_DAY as FOUR_AVERAGE_DAY
                from (select pp.posting_date_key        as ORDER_TWO_DATE,
                             pp.order_amount            as ORDER_TWO_AMOUNT,
                             pp.Sales_Source_second_key as ORDER_TWO_SOURCE
                        from fact_order pp
                       where pp.order_key =
                             (select OOO.order_key
                                from (select OO.order_key, rownum rn
                                        from (select o.order_key
                                                from fact_order O
                                               where O.member_key = var_array(i)
                                                    .member_key
                                               order by O.order_key asc) OO) OOO
                               where OOO.rn = 2)) p1,
                     (select pp.posting_date_key        as ORDER_TWO_DATE,
                             pp.order_amount            as ORDER_TWO_AMOUNT,
                             pp.Sales_Source_second_key as ORDER_TWO_SOURCE
                        from fact_order pp
                       where pp.order_key =
                             (select OOO.order_key
                                from (select OO.order_key, rownum rn
                                        from (select o.order_key
                                                from fact_order O
                                               where O.member_key = var_array(i)
                                                    .member_key
                                               order by O.order_key asc) OO) OOO
                               where OOO.rn = 3)) p2,
                     (select pp.posting_date_key        as ORDER_TWO_DATE,
                             pp.order_amount            as ORDER_TWO_AMOUNT,
                             pp.Sales_Source_second_key as ORDER_TWO_SOURCE
                        from fact_order pp
                       where pp.order_key =
                             (select OOO.order_key
                                from (select OO.order_key, rownum rn
                                        from (select o.order_key
                                                from fact_order O
                                               where O.member_key = var_array(i)
                                                    .member_key
                                               order by O.order_key asc) OO) OOO
                               where OOO.rn = 4)) p3,
                     (select (case
                               when ps.total <= 1 then
                                0
                               else
                                to_number(ps.days / (ps.total - 1))
                             end) as FOUR_AVERAGE_DAY
                        from (
                              
                              select trunc(to_date(max(OOO.posting_date_key),
                                                    'yyyy-mm-dd') -
                                            to_date(min(OOO.posting_date_key),
                                                    'yyyy-mm-dd')) as days,
                                      count(1) as total
                                from (select OO.posting_date_key, rownum rn
                                         from (select o.posting_date_key
                                                 from fact_order O
                                                where O.member_key = var_array(i)
                                                    .member_key
                                                order by O.posting_date_key asc) OO) OOO
                               where OOO.rn >= 4) ps) p4) where l.member_key=var_array(i).member_key;
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
  
end processmemberorder;
/

