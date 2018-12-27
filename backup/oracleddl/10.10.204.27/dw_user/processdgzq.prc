???create or replace procedure dw_user.processdgzq(startid in number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;
  crmpostdates number;
  --total_nums number;
  
begin

  sp_name          := 'processdgzq'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'tj_dgzq'; --此处需要手工录入该PROCEDURE操作的表格
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
  --crmpostdates := 0;
  select max(member_key) into crmpostdates from tj_dgzq;

  if crmpostdates is null then
    crmpostdates := 0;
  end if;
  declare
  type type_arrays is record(member_key number(20));

  type type_array is table of type_arrays index by binary_integer; --类似二维数组 

  var_array type_array;
  
  begin
  select * bulk collect
      into var_array
      from (select p.member_key
              from (select member_key, rownum rn
                      from ls_member_order
                     where member_key > crmpostdates order by member_key asc) p
             where p.rn between 0 and startid);
  
  for i in 1 .. var_array.count loop
    insert into tj_dgzq (
     member_key,
  first_date,
  last_date,
  four_date,
  days ,
  time1     ,
  time2     ,
  time3     ,
  time4     ,
  time5     ,
  time6     ,
  time7     ,
  time8     ,
  time9     ,
  time10    ,
  time11    ,
  time12    ,
  time13    ,
  time14    ,
  time15    ,
  time16    ,
  time17    ,
  time18    ,
  time19    ,
  time20    ,
  time21    ,
  time22    ,
  time23    ,
  time24    
    ) select var_array(i).member_key as member_key, min(o.posting_date_key) as first_date,max(o.posting_date_key) as last_date,max(p.posting_date_key) as four_date,
to_number(trunc(to_date(max(o.posting_date_key),'yyyy-mm-dd') -to_date(min(o.posting_date_key),'yyyy-mm-dd')))/count(1) as days,
sum(case when posting_hour_key = 1 then 1 else 0 end) as time1,
sum(case when posting_hour_key = 2 then 1 else 0 end) as time2,
sum(case when posting_hour_key = 3 then 1 else 0 end) as time3,
sum(case when posting_hour_key = 4 then 1 else 0 end) as time4,
sum(case when posting_hour_key = 5 then 1 else 0 end) as time5,
sum(case when posting_hour_key = 6 then 1 else 0 end) as time6,
sum(case when posting_hour_key = 7 then 1 else 0 end) as time7,
sum(case when posting_hour_key = 8 then 1 else 0 end) as time8,
sum(case when posting_hour_key = 9 then 1 else 0 end) as time9,
sum(case when posting_hour_key = 10 then 1 else 0 end) as time10,
sum(case when posting_hour_key = 11 then 1 else 0 end) as time11,
sum(case when posting_hour_key = 12 then 1 else 0 end) as time12,
sum(case when posting_hour_key = 13 then 1 else 0 end) as time13,
sum(case when posting_hour_key = 14 then 1 else 0 end) as time14,
sum(case when posting_hour_key = 15 then 1 else 0 end) as time15,
sum(case when posting_hour_key = 16 then 1 else 0 end) as time16,
sum(case when posting_hour_key = 17 then 1 else 0 end) as time17,
sum(case when posting_hour_key = 18 then 1 else 0 end) as time18,
sum(case when posting_hour_key = 19 then 1 else 0 end) as time19,
sum(case when posting_hour_key = 20 then 1 else 0 end) as time20,
sum(case when posting_hour_key = 21 then 1 else 0 end) as time21,
sum(case when posting_hour_key = 22 then 1 else 0 end) as time22,
sum(case when posting_hour_key = 23 then 1 else 0 end) as time23,
sum(case when posting_hour_key = 24 then 1 else 0 end) as time24
from fact_order o left join


(select OOO.posting_date_key,var_array(i).member_key as member_key
                                from (select OO.posting_date_key, rownum rn
                                        from (select o.posting_date_key
                                                from fact_order O
                                               where O.member_key = var_array(i).member_key and o.sales_source_key=20 and order_state=1
                                               order by O.posting_date_key asc) OO) OOO
                               where OOO.rn = 4) p on p.member_key=o.member_key
                               
                               where o.member_key= var_array(i).member_key and o.sales_source_key=20 and o.order_state=1;
  
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
end processdgzq;
/

