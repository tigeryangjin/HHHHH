???create or replace procedure dw_user.processecgoodssalesdayly(postday in number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;
  --endid number;
  --onetotal number;--一次取多少个
  /*
  功能说明：商品订购数据统计，以及商品销售品类统计表，商品销售top50
       
  
  作者时间：bobo  2016-07-19
  */

begin

  sp_name          := 'processecgoodssalesdayly'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_ec_goods_sales_dayly'; --此处需要手工录入该PROCEDURE操作的表格
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

  merge into fact_ec_goods_sales_dayly m --fzq1表是需要更新的表
  using (select g.ec_goods_common,
                g.item_code,
                postday as posting_day,
                to_number(e.matxl) as matxl,
                sum(case
                      when o.add_time = postday then
                       g.goods_num
                      else
                       0
                    end) total,
                sum(case
                      when o.last_time_key = postday and o.order_state = 0 then
                       g.goods_num
                      else
                       0
                    end) cancel_total
           from factec_order_goods g
           left join factec_order o
             on o.order_id = g.order_id
           left join dim_ec_good e
             on e.item_code = g.item_code
          where add_time = postday
             or last_time_key = postday
          group by g.ec_goods_common, g.item_code, e.matxl) mm -- 关联表
  on (m.posting_date_key = mm.posting_day and m.item_code = mm.item_code) --关联条件
  when matched then --匹配关联条件，作更新处理
    update set m.sales_nums = mm.total, m.cancel_nums = mm.cancel_total
  when not matched then --不匹配关联条件，作插入处理。如果只是作更新，下面的语句可以省略。
    insert
      (item_code,
       GOODS_COMMONID,
       SALES_NUMS,
       CANCEL_NUMS,
       POSTING_DATE_KEY,
       matxl)
    values
      (mm.item_code,
       mm.ec_goods_common,
       mm.total,
       mm.cancel_total,
       mm.posting_day,
       mm.matxl);
  --此处只是说明可以同时更新多个字段。
  insert_rows := sql%rowcount;

  if insert_rows > 0 then
  
    --7天top50榜单
    delete from FACT_EC_GOODS_SALES_TOP50 where POSTING_DATE_KEY = postday;
  
    insert into FACT_EC_GOODS_SALES_TOP50
      (POSTING_DATE_KEY, item_code, SALES_TOTAL)
      (select pp.POSTING_DATE_KEY, pp.item_code, pp.total as SALES_TOTAL
         from (select p.*, rownum rn
                 from (select postday POSTING_DATE_KEY,
                              item_code,
                              sum(sales_nums - cancel_nums) total
                         from fact_ec_goods_sales_dayly
                        where posting_date_key between
                              (select to_number(to_char(to_date(postday,
                                                                'yyyy-mm-dd') - 6,
                                                        'yyyymmdd'))
                                 from dual) and postday
                        group by item_code
                        order by sum(sales_nums - cancel_nums) desc) p) pp
        where pp.rn <= 50);
  
    --小分类
    merge into FACT_EC_GOODS_SALES_MAT_TOP m --fzq1表是需要更新的表
    using (select postday as POSTING_DATE_KEY,
                  item_code,
                  matxl,
                  sum(sales_nums - cancel_nums) sales_total
             from fact_ec_goods_sales_dayly
            where item_code in
                  (select item_code
                     from fact_ec_goods_sales_dayly
                    where posting_date_key = postday)
              and posting_date_key between
                  (select to_number(to_char(to_date(postday, 'yyyy-mm-dd') - 29,
                                            'yyyymmdd'))
                     from dual) and postday
            group by item_code, matxl
            order by sum(sales_nums - cancel_nums) desc) mm -- 关联表
    on (m.item_code = mm.item_code) --关联条件
    when matched then --匹配关联条件，作更新处理
      update
         set m.POSTING_DATE_KEY = mm.POSTING_DATE_KEY,
             m.MATXL            = mm.MATXL,
             m.sales_total      = mm.sales_total
    when not matched then --不匹配关联条件，作插入处理。如果只是作更新，下面的语句可以省略。
      insert
        (ITEM_CODE, POSTING_DATE_KEY, matxl, sales_total)
      values
        (mm.item_code, mm.POSTING_DATE_KEY, mm.matxl, mm.sales_total);
  end if;

  begin
    EXECUTE IMMEDIATE 'truncate table fact_ec_goods_sales_mat_top4' /*FACT_EC_GOODS_MAT_TOP4修改为fact_ec_goods_sales_mat_top4 by yangjin 2017-06-19*/
    ;
  end;

  insert into fact_ec_goods_sales_mat_top4 /*每个物料小类商品销售排名前4名*/
    (item_code, matxl, sales_total)
    (select cc.item_code, cc.matxl, cc.sales_total
       from (select item_code /*商品编码*/,
                    matxl /*物料小类*/,
                    sales_total /*合计销售数量*/,
                    rank() OVER(PARTITION BY matxl order by sales_total desc, item_code desc) as RANK /*按物料小类排名*/
               from fact_ec_goods_sales_mat_top) cc
      where cc.rank <= 4);

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
end processecgoodssalesdayly;
/

