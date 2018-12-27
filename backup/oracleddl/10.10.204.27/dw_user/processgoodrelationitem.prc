???create or replace procedure dw_user.processgoodrelationitem(postday in number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;
  --member_true number;
 -- goods_true  number;
  --insert_ok   number;

  /*
  功能说明：关联商品抽取
       
  
  作者时间：bobo  2016-04-06
  */
begin
  sp_name          := 'processgoodrelationitem'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'FACT_ASSOCIATION_GOOD'; --此处需要手工录入该PROCEDURE操作的表格
  s_etl.proc_name  := sp_name;
  s_etl.start_time := sysdate;
  s_parameter      := 0;
  --member_true      := 0;
  --goods_true       := 0;
  insert_rows      := 0;
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
    type type_arrays_info is record(
      member_key number(10));
  
    type type_array_info is table of type_arrays_info index by binary_integer; --类似二维数组 
    var_array_info type_array_info; --有更新member用户
  
    --type type_arrays is record(
     -- item_code number(10));
  
    --type type_array is table of type_arrays index by binary_integer; --类似二维数组 
    --var_array type_array; --当天有更新的item_code
  begin
    insert_rows := 0;
    select p.* bulk collect
      into var_array_info
      from (select member_key
              from (select member_key
                      from ls_member
                     where status = 0
                     order by total desc)
             where rownum <= postday) p;
    for i in 1 .. var_array_info.count loop
      /*select p.* bulk collect
        into var_array
        from (select item_code
                from fact_association_good_member
               where member_key = var_array_info(i).member_key) p;
      for ii in 1 .. var_array.count loop
        for iii in 1 .. var_array.count loop
          select count(1)
            into goods_true
            from fact_association_good
           where item_code = var_array(ii).item_code
             and ITEM_CODE_RELATION = var_array(iii).item_code;
          if goods_true > 0 then
            update fact_association_good
               set NUMS = NUMS + 1
             where item_code = var_array(ii).item_code
               and ITEM_CODE_RELATION = var_array(iii).item_code;
          else
            insert into fact_association_good
              (item_code, ITEM_CODE_RELATION, nums)
            values
              (var_array(ii).item_code, var_array(iii).item_code, 1);
          end if;
          insert_rows := insert_rows+1;
        end loop;
      end loop;*/
      merge into fact_association_good g --fzq1表是需要更新的表
      using ((select *
                from (select item_code
                        from fact_association_good_member
                       where member_key = var_array_info(i).member_key),
                     (select item_code as ITEM_CODE_RELATION
                        from fact_association_good_member
                       where member_key = var_array_info(i).member_key))) m -- 关联表
      on (m.item_code = g.item_code and m.ITEM_CODE_RELATION = g.ITEM_CODE_RELATION) --关联条件
      when matched then --匹配关联条件，作更新处理
        update set g.NUMS = g.NUMS + 1 --此处只是说明可以同时更新多个字段。
      
      when not matched then --不匹配关联条件，作插入处理。如果只是作更新，下面的语句可以省略。
        insert values (m.item_code, m.ITEM_CODE_RELATION, 1);
      insert_rows := sql%rowcount;
      update ls_member
         set status = 1
       where member_key = var_array_info(i).member_key;
    end loop;
    --insert_rows := var_array_info.count;
    /*update ls_member
      set status =  1
    where member_key in (var_array_info);*/
  end;
  commit;
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
end processgoodrelationitem;
/

