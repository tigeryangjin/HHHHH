???create or replace procedure dw_user.processopermemberorder(postday in number) is
  s_etl        w_etl_log%rowtype;
  sp_name      s_parameters2.pname%type;
  s_parameter  s_parameters1.parameter_value%type;
  insert_rows  number;
  crmpostdates number;
  total_nums   number;
  order_member number;
  order_state  number;

begin

  sp_name          := 'processopermemberorder'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'oper_member_order'; --此处需要手工录入该PROCEDURE操作的表格
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

  --先从ec拉取每天的ec增量用户，到oper_member_order 表
  insert into oper_member_order
    (member_key, register_time)
    (select member_crmbp as member_key, min(member_time) as register_time
       from fact_ecmember
      where member_crmbp != 0
        and member_crmbp not in (select member_key from oper_member_order)
      group by member_crmbp);
  insert_rows := sql%rowcount;
  s_etl.err_msg := postday || '用户增加:' || insert_rows;
  declare
    type type_arrays is record(
      member_key number(20));
  
    type type_array is table of type_arrays index by binary_integer; --类似二维数组 
  
    var_array type_array;
  --每天有变化的member_key进行清洗
  begin
    select * bulk collect
      into var_array
      from (select member_key from oper_member_order where member_key in (select member_key
              from fact_order
             where update_time = postday
               and sales_source_second_key in
                   (20022, 20021, 20020, 20018, 20017)
             group by member_key));
    order_member:=0;
    for i in 1 .. var_array.count loop
      select count(1)
        into total_nums
        from fact_order
       where sales_source_second_key in (20022, 20021, 20020, 20018, 20017)
         and member_key = var_array(i).member_key;
      if total_nums > 0 then
      
        update oper_member_order
        --set oper_member_order
           set (first_order_time,
                LAST_ORDER_TIME,
                order_nums,
                order_amount,
                REVERSE_ORDER_NUMS,
                reverse_last_time,
                reverse_amount,
                state,
                update_time,
                member_grade) =
               
               (select (case
                         when p.order_nums >= 1 then
                          p.first_order_key
                         else
                          0
                       end) as first_order_time,
                       (case
                         when p.order_nums >= 1 then
                          p.LAST_ORDER_key
                         else
                          0
                       end) as LAST_ORDER_TIME,
                       p.order_nums,
                       (case
                         when p.order_nums >= 1 then
                          p.order_amount
                         else
                          0
                       end) as order_amount,
                       (case
                         when (p.reverse_nums + pp.order_nums) >= 1 then
                          (p.reverse_nums + pp.order_nums)
                          when  p.reverse_nums is not null and pp.order_nums is null then p.reverse_nums
                          when  pp.order_nums is not null and p.reverse_nums is null then pp.order_nums
                         else
                          0
                       end) as REVERSE_ORDER_NUMS,
                       (case
                         when pp.cancel_date_key > p.reverse_last_time then
                          pp.cancel_date_key
                         else
                          p.reverse_last_time
                       end) as reverse_last_time,
                       
                       (case
                         when (p.reverse_nums + pp.order_nums) >= 1 then
                          (pp.order_amount + p.reverse_amount)
                          when  p.reverse_nums is not null and pp.order_nums is null then p.reverse_amount
                          when  pp.order_nums is not null and p.reverse_nums is null then pp.order_amount
                         else
                          0
                       end)
                       
                       as reverse_amount,
                       1 as state,
                       to_number(to_char(sysdate, 'yyyymmdd')) as update_time,
                       p.member_level as member_grade
                  from (select mo.member_key,
                               min(o.posting_date_key) as first_order_key,
                               max(o.posting_date_key) as last_order_key,
                               sum(case
                                     when o.posting_date_key is null then
                                      0
                                     else
                                      1
                                   end) as order_nums,
                               sum(o.order_amount) as order_amount,
                               
                               sum(case
                                     when o.Cancel_before_state = 1 then
                                      1
                                     else
                                      0
                                   end) as reverse_nums,
                               max(case
                                     when o.Cancel_before_state = 1 then
                                      o.cancel_date_key
                                     else
                                      0
                                   end) as reverse_last_time,
                               sum(case
                                     when o.Cancel_before_state = 1 then
                                      o.order_amount
                                     else
                                      0
                                   end) as reverse_amount,
                               min(mo.member_level) as member_level
                          from (select m.member_key,
                                       min(mm.member_level) as member_level
                                  from oper_member_order m
                                  left join fact_member_register mm
                                    on m.member_key = mm.member_key
                                 where m.member_key = var_array(i).member_key
                                 group by m.member_key) mo
                          left join fact_order o
                            on o.member_key = mo.member_key
                         where mo.member_key = var_array(i).member_key
                           and o.sales_source_second_key in
                               (20022, 20021, 20020, 20018, 20017)
                         group by mo.member_key) p
                  left join (
                            
                            select sum(case
                                          when cancel_date_key is null then
                                           0
                                          else
                                           1
                                        end) as order_nums,
                                    member_key,
                                    max(cancel_date_key) as cancel_date_key,
                                    sum(order_amount) as order_amount
                              from (
                                     
                                     select ors.order_key,
                                             mo.member_key,
                                             max(ors.posting_date_key) as cancel_date_key,
                                             max(ors.order_amount) as order_amount
                                       from oper_member_order mo
                                       left join fact_order_reverse ors
                                         on ors.member_key = mo.member_key
                                      where mo.member_key = var_array(i)
                                           .member_key
                                        and order_type = 0
                                        and sales_source_second_key in
                                            (20022, 20021, 20020, 20018, 20017)
                                      group by ors.order_key, mo.member_key)
                             group by member_key) pp
                    on pp.member_key = p.member_key)
         where member_key = var_array(i).member_key;
      else
        update oper_member_order
        --set oper_member_order
           set (first_order_time,
                LAST_ORDER_TIME,
                order_nums,
                order_amount,
                REVERSE_ORDER_NUMS,
                reverse_last_time,
                reverse_amount,
                state,
                update_time,
                member_grade) =
               (select 0 as first_order_time,
                       0 as LAST_ORDER_TIME,
                       0 as order_nums,
                       0 as order_amount,
                       0 as REVERSE_ORDER_NUMS,
                       0 as reverse_last_time,
                       0 as reverse_amount,
                       1 as state,
                       to_number(to_char(sysdate, 'yyyymmdd')) as update_time,
                       min(mr.member_level) as member_grade
                
                  from oper_member_order mo
                  left join fact_member_register mr
                    on mo.member_key = mr.member_key
                 where mo.member_key = var_array(i).member_key
                 group by mo.member_key
                
                )
         where member_key = var_array(i).member_key;
      end if;
      order_member := order_member+1;--sql%rowcount;
    end loop;
    insert_rows := insert_rows+order_member;
  s_etl.err_msg := s_etl.err_msg || '订单用户:' || order_member;
  
  end;
  
   --增量后没有变动的进行清洗
  declare
    type type_arrayss is record(
      member_key number(20));
  
    type type_array is table of type_arrayss index by binary_integer; --类似二维数组 
  
    var_arraya type_array;
  begin
    select * bulk collect
      into var_arraya
      from (select member_key from oper_member_order where state = 0);
      
      order_state :=0;
    for i in 1 .. var_arraya.count loop
      select count(1)
        into total_nums
        from fact_order
       where sales_source_second_key in (20022, 20021, 20020, 20018, 20017)
         and member_key = var_arraya(i).member_key;
       
      if total_nums > 0 then
      
        update oper_member_order
        --set oper_member_order
           set (first_order_time,
                LAST_ORDER_TIME,
                order_nums,
                order_amount,
                REVERSE_ORDER_NUMS,
                reverse_last_time,
                reverse_amount,
                state,
                update_time,
                member_grade) =
               
               (select (case
                         when p.order_nums >= 1 then
                          p.first_order_key
                         else
                          0
                       end) as first_order_time,
                       (case
                         when p.order_nums >= 1 then
                          p.LAST_ORDER_key
                         else
                          0
                       end) as LAST_ORDER_TIME,
                       p.order_nums,
                       (case
                         when p.order_nums >= 1 then
                          p.order_amount
                         else
                          0
                       end) as order_amount,
                       (case
                         when (p.reverse_nums + pp.order_nums) >= 1 then
                          (p.reverse_nums + pp.order_nums)
                          when  p.reverse_nums is not null and pp.order_nums is null then p.reverse_nums
                          when  pp.order_nums is not null and p.reverse_nums is null then pp.order_nums
                         else
                          0
                       end) as REVERSE_ORDER_NUMS,
                       (case
                         when pp.cancel_date_key > p.reverse_last_time then
                          pp.cancel_date_key
                         else
                          p.reverse_last_time
                       end) as reverse_last_time,
                       
                       (case
                         when (p.reverse_nums + pp.order_nums) >= 1 then
                          (pp.order_amount + p.reverse_amount)
                          when  p.reverse_nums is not null and pp.order_nums is null then p.reverse_amount
                          when  pp.order_nums is not null and p.reverse_nums is null then pp.order_amount
                         else
                          0
                       end)
                       
                       as reverse_amount,
                       1 as state,
                       to_number(to_char(sysdate, 'yyyymmdd')) as update_time,
                       p.member_level as member_grade
                  from (select mo.member_key,
                               min(o.posting_date_key) as first_order_key,
                               max(o.posting_date_key) as last_order_key,
                               sum(case
                                     when o.posting_date_key is null then
                                      0
                                     else
                                      1
                                   end) as order_nums,
                               sum(o.order_amount) as order_amount,
                               
                               sum(case
                                     when o.Cancel_before_state = 1 then
                                      1
                                     else
                                      0
                                   end) as reverse_nums,
                               max(case
                                     when o.Cancel_before_state = 1 then
                                      o.cancel_date_key
                                     else
                                      0
                                   end) as reverse_last_time,
                               sum(case
                                     when o.Cancel_before_state = 1 then
                                      o.order_amount
                                     else
                                      0
                                   end) as reverse_amount,
                               min(mo.member_level) as member_level
                          from (select m.member_key,
                                       min(mm.member_level) as member_level
                                  from oper_member_order m
                                  left join fact_member_register mm
                                    on m.member_key = mm.member_key
                                 where m.member_key = var_arraya(i).member_key
                                 group by m.member_key) mo
                          left join fact_order o
                            on o.member_key = mo.member_key
                         where mo.member_key = var_arraya(i).member_key
                           and o.sales_source_second_key in
                               (20022, 20021, 20020, 20018, 20017)
                         group by mo.member_key) p
                  left join (
                            
                            select sum(case
                                          when cancel_date_key is null then
                                           0
                                          else
                                           1
                                        end) as order_nums,
                                    member_key,
                                    max(cancel_date_key) as cancel_date_key,
                                    sum(order_amount) as order_amount
                              from (
                                     
                                     select ors.order_key,
                                             mo.member_key,
                                             max(ors.posting_date_key) as cancel_date_key,
                                             max(ors.order_amount) as order_amount
                                       from oper_member_order mo
                                       left join fact_order_reverse ors
                                         on ors.member_key = mo.member_key
                                      where mo.member_key = var_arraya(i)
                                           .member_key
                                        and order_type = 0
                                        and sales_source_second_key in
                                            (20022, 20021, 20020, 20018, 20017)
                                      group by ors.order_key, mo.member_key)
                             group by member_key) pp
                    on pp.member_key = p.member_key)
         where member_key = var_arraya(i).member_key;
      else
        update oper_member_order
        --set oper_member_order
           set (first_order_time,
                LAST_ORDER_TIME,
                order_nums,
                order_amount,
                REVERSE_ORDER_NUMS,
                reverse_last_time,
                reverse_amount,
                state,
                update_time,
                member_grade) =
               (select 0 as first_order_time,
                       0 as LAST_ORDER_TIME,
                       0 as order_nums,
                       0 as order_amount,
                       0 as REVERSE_ORDER_NUMS,
                       0 as reverse_last_time,
                       0 as reverse_amount,
                       1 as state,
                       to_number(to_char(sysdate, 'yyyymmdd')) as update_time,
                       min(mr.member_level) as member_grade
                
                  from oper_member_order mo
                  left join fact_member_register mr
                    on mo.member_key = mr.member_key
                 where mo.member_key = var_arraya(i).member_key
                 group by mo.member_key
                
                )
         where member_key = var_arraya(i).member_key;
      end if;
      order_state := order_state+1;--sql%rowcount;
    end loop;
    insert_rows := insert_rows+order_state;
    s_etl.err_msg := s_etl.err_msg || '新增无订单用户:' || order_state;
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
end processopermemberorder;
/

