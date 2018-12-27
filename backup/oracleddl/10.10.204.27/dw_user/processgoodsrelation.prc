???create or replace procedure dw_user.processgoodsrelation(postday in number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;
  --member_true number;
  goods_true  number;
  --insert_ok   number;

  /*
  功能说明：关联商品抽取
       
  
  作者时间：bobo  2016-04-06
  */
begin
  sp_name          := 'processgoodsrelation'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'FACT_ASSOCIATION_GOODS'; --此处需要手工录入该PROCEDURE操作的表格
  s_etl.proc_name  := sp_name;
  s_etl.start_time := sysdate;
  s_parameter      := 0;
  --member_true      := 0;
  goods_true       := 0;
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
  --批量插入当天的数据
  insert into fact_association_goods_member
    (member_key, item_code, posting_date_key)
    (
     select p.member_key, p.item_code, postday as posting_date_key
       from (
              
              select member_key,
                      (case
                        when sales_goods_id > 999999 then
                         trunc(sales_goods_id / 1000)
                        else
                         sales_goods_id
                      end) item_code
                from fact_goods_sales
               where posting_date_key = postday
               group by member_key,
                         (case
                           when sales_goods_id > 999999 then
                            trunc(sales_goods_id / 1000)
                           else
                            sales_goods_id
                         end)) p
       left join fact_association_goods_member m
         on m.member_key = p.member_key
        and m.item_code = p.item_code
      where m.member_key is null);
  insert_rows := sql%rowcount;
  if insert_rows > 0 then
    declare
      type type_arrays_info is record(
        member_key number(10));
    
      type type_array_info is table of type_arrays_info index by binary_integer; --类似二维数组 
      var_array_info type_array_info;--有更新member用户
    
      type type_arrays is record(
        item_code number(10));
    
      type type_array is table of type_arrays index by binary_integer; --类似二维数组 
      var_array type_array;--当天有更新的item_code
    
      type type_arrays_member is record(
        item_code number(10));
    
      type type_array_member is table of type_arrays_member index by binary_integer; --类似二维数组 
      var_array_member type_array_member;--全部item_code
    
    begin
      select p.* bulk collect
        into var_array_info
        from (select member_key
                from fact_association_goods_member
               where posting_date_key = postday
               group by member_key) p;
                
      for i in 1 .. var_array_info.count loop
        var_array.delete();
        var_array_member.delete();
        select p.* bulk collect
          into var_array
          from (select item_code
                  from fact_association_goods_member
                 where posting_date_key = postday
                   and member_key = var_array_info(i).member_key) p;
        select p.* bulk collect
          into var_array_member
          from (select item_code
                  from fact_association_goods_member
                 where posting_date_key != postday
                 and member_key = var_array_info(i).member_key) p;
        for j in 1 .. var_array.count loop
          
           --if var_array_member(1).item_code is not null then 
            --老数据要做正反两项处理
            for k in 1 .. var_array_member.count loop
              if var_array_member(k).item_code != var_array(j).item_code then
                select count(1)
                  into goods_true
                  from fact_association_goods
                 where item_code = var_array_member(k).item_code
                   and ITEM_CODE_RELATION = var_array(j).item_code;
                if goods_true > 0 then
                  update fact_association_goods
                     set NUMS = NUMS + 1
                   where item_code = var_array_member(k).item_code
                     and ITEM_CODE_RELATION = var_array(j).item_code;
                else
                  insert into fact_association_goods
                    (item_code, ITEM_CODE_RELATION, nums)
                  values
                    (var_array_member(k).item_code, var_array(j).item_code, 1);
                end if;
              
                select count(1)
                  into goods_true
                  from fact_association_goods
                 where item_code = var_array(j).item_code
                   and ITEM_CODE_RELATION = var_array_member(k).item_code;
                if goods_true > 0 then
                  update fact_association_goods
                     set NUMS = NUMS + 1
                   where item_code = var_array(j).item_code
                     and ITEM_CODE_RELATION = var_array_member(k).item_code;
                else
                  insert into fact_association_goods
                    (item_code, ITEM_CODE_RELATION, nums)
                  values
                    (var_array(j).item_code, var_array_member(k).item_code, 1);
                end if;
              end if;
            end loop;
          --end if;
          --新数据由于会在此循环进来，只需做正向的
          for kk in 1 .. var_array.count loop
            if var_array(kk).item_code != var_array(j).item_code then
              select count(1)
                into goods_true
                from fact_association_goods
               where item_code = var_array(j).item_code
                 and ITEM_CODE_RELATION = var_array(kk).item_code;
              if goods_true > 0 then
                update fact_association_goods
                   set NUMS = NUMS + 1
                 where item_code = var_array(j).item_code
                   and ITEM_CODE_RELATION = var_array(kk).item_code;
              else
                insert into fact_association_goods
                  (item_code, ITEM_CODE_RELATION, nums)
                values
                  (var_array(j).item_code, var_array(kk).item_code, 1);
              end if;
            end if;
          end loop;
          
          
        end loop;
      end loop;
    end;
  end if;
    commit;
  /*declare
    type type_arrays is record(
      member_key number(20),
      item_code  number(10));
  
    type type_array is table of type_arrays index by binary_integer; --类似二维数组 
  
    var_array type_array;
    type type_arrays_info is record(
      item_code number(10));
  
    type type_array_info is table of type_arrays_info index by binary_integer; --类似二维数组 
  
    var_array_info type_array_info;
  begin
    select p.* bulk collect
      into var_array
      from (select to_number(member_key),
                   (case
                     when sales_goods_id > 999999 then
                      trunc(sales_goods_id / 1000)
                     else
                      sales_goods_id
                   end) item_code
              from fact_goods_sales
             where posting_date_key = postday
             group by member_key,
                      (case
                        when sales_goods_id > 999999 then
                         trunc(sales_goods_id / 1000)
                        else
                         sales_goods_id
                      end)) p;
    for i in 1 .. var_array.count loop
      select count(1)
        into member_true
        from fact_association_goods_member
       where member_key = var_array(i).member_key
         and item_code = var_array(i).item_code;
      if member_true = 0 then
        insert into fact_association_goods_member
          (member_key, item_code, posting_date_key)
        values
          (var_array(i).member_key, var_array(i).item_code, postday);
        insert_ok   := sql%rowcount;
        insert_rows := insert_rows + insert_ok;
        if insert_ok > 0 then
          select p.* bulk collect
            into var_array_info
            from (select item_code
                    from fact_association_goods_member
                   where member_key = var_array(i).member_key
                     and item_code != var_array(i).item_code) p;
          for j in 1 .. var_array.count loop
            select count(1)
              into goods_true
              from fact_association_goods
             where item_code = var_array(i).item_code
               and ITEM_CODE_RELATION = var_array(j).item_code;
            if goods_true > 0 then
              update fact_association_goods
                 set NUMS = NUMS + 1
               where item_code = var_array(i).item_code
                 and ITEM_CODE_RELATION = var_array(j).item_code;
            else
              insert into fact_association_goods
                (item_code, ITEM_CODE_RELATION, nums)
              values
                (var_array(i).item_code, var_array(j).item_code, 1);
            end if;
          
            select count(1)
              into goods_true
              from fact_association_goods
             where item_code = var_array(j).item_code
               and ITEM_CODE_RELATION = var_array(i).item_code;
            if goods_true > 0 then
              update fact_association_goods
                 set NUMS = NUMS + 1
               where item_code = var_array(j).item_code
                 and ITEM_CODE_RELATION = var_array(i).item_code;
            else
              insert into fact_association_goods
                (item_code, ITEM_CODE_RELATION, nums)
              values
                (var_array(j).item_code, var_array(i).item_code, 1);
            end if;
          end loop;
        end if;
      end if;
    end loop;
  end;*/
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
end processgoodsrelation;
/

