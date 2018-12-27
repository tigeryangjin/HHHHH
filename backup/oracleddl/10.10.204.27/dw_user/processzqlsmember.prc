???create or replace procedure dw_user.processzqlsmember(startid in number) is
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
  sp_name          := 'processzqlsmember'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'ZQLS_MEMBER'; --此处需要手工录入该PROCEDURE操作的表格
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
                      from ZQLS_MEMBER
                     where status = 0) p
             where p.rn between 0 and startid);
  
    for i in 1 .. var_array.count loop
      update zqls_member l
         set (l.source,
              l.ec_status,
              l.status) =
             (select m.media as source,
                     (case
                       when p.nums > 0 then
                        0
                       else
                        1
                     end) ec_status,
                     1 as status
                from (select count(1) as nums, var_array(i).member_key as member_key
                        from fact_order
                       where Sales_Source_key != 20
                         and member_key = var_array(i).member_key
                       ) p
                left join (SELECT member_key, media
                            from fact_member_register
                           where member_key = var_array(i).member_key) m
                  on p.member_key = m.member_key)
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
  
end processzqlsmember;
/

