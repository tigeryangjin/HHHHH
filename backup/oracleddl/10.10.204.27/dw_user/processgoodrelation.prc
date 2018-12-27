???create or replace procedure dw_user.processgoodrelation(postday in number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;
  --member_true number;
  --goods_true  number;
  --insert_ok   number;

  /*
  功能说明：关联商品抽取
       
  
  作者时间：bobo  2016-04-06
  */
begin
  sp_name          := 'processgoodrelation'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'FACT_ASSOCIATION_GOOD_MEMBER'; --此处需要手工录入该PROCEDURE操作的表格
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
  --批量插入当天的数据
  insert into fact_association_good_member
    (member_key, item_code, posting_date_key)
    (
     select p.member_key, p.item_code, postday as posting_date_key
       from (
              
              select member_key,
                      (case
                        when goods_key > 999999 then
                         trunc(GOODS_KEY / 1000)
                        else
                         GOODS_KEY
                      end) item_code
                from fact_goods_sales
               where posting_date_key = postday
               group by member_key,
                         (case
                           when GOODS_KEY > 999999 then
                            trunc(GOODS_KEY / 1000)
                           else
                            GOODS_KEY
                         end)) p
       left join fact_association_good_member m
         on m.member_key = p.member_key
        and m.item_code = p.item_code
      where m.member_key is null);
  insert_rows := sql%rowcount;
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
end processgoodrelation;
/

