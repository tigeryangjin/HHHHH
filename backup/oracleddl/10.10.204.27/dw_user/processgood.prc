???create or replace procedure dw_user.processgood(startpoint varchar2) is

  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;
  update_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processgood'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'dim_good'; --此处需要手工录入该PROCEDURE操作的表格
  s_etl.proc_name  := sp_name;
  s_etl.start_time := sysdate;
  s_parameter      := 0;

  begin
    sp_parameter_two(sp_name, s_parameter);
    if s_parameter = '0'
    then
      s_etl.err_msg := '没有找到对应的过程加载类型数据';
      sp_sbi_w_etl_log(s_etl);
      return;
    end if;
  end;
  --= '00000000';
  declare
  
  begin
  
    insert into dim_good
      (item_code,
       goods_name,
       matdl,
       matdlt,
       matzl,
       matzlt,
       matxl,
       matxlt,
       matl_group,
       matxxlt,
       create_time,
       md,
       group_id,
       group_name,
       w_insert_dt,
       w_update_dt,
       row_wid,
       current_flg,
       md_name,
       dxj)
      select ta.col1,
             ta.col2,
             ta.col3,
             ta.col4,
             ta.col5,
             ta.col6,
             ta.col7,
             ta.col8,
             ta.col9,
             ta.col10,
             ta.col11,
             ta.col12,
             ta.col13,
             ta.col14,
             ta.col15,
             ta.col16,
             dim_good_seq.nextval,
             'Y' /*CURRENT_FLG*/,
             ta.col17,
             ta.col18
        from (select distinct --to_number(f.zmater2), --as "商品编号",
                              
                              to_number(case
                                          when regexp_like(f.zmater2, '.([a-z]+|[A-Z])') then
                                           '0'
                                          when regexp_like(f.zmater2, '[[:punct:]]+') then
                                           '0'
                                          when f.zmater2 is null then
                                           '0'
                                          when f.zmater2 like '%null%' then
                                           '0'
                                          else
                                           regexp_replace(f.zmater2, '\s', '')
                                        end) col1,
                              
                              regexp_substr(f.txtmd, '[^,]+', 1, 1) col2, --as "商品名称",
                              -- to_number(f.rpa_wgh3), -- as "大分类",
                              
                              to_number(case
                                          when regexp_like(f.zmatdl, '.([a-z]+|[A-Z])') then
                                           '0'
                                          when regexp_like(f.zmatdl, '[[:punct:]]+') then
                                           '0'
                                          when f.zmatdl is null then
                                           '0'
                                          when f.zmatdl like '%null%' then
                                           '0'
                                          else
                                           regexp_replace(f.zmatdl, '\s', '')
                                        end) col3,
                              
                              (select distinct e.matdlt
                                 from dim_good_class e
                                where e.matdl = to_number(case
                                                            when regexp_like(f.zmatdl,
                                                                             '.([a-z]+|[A-Z])') then
                                                             '0'
                                                            when regexp_like(f.zmatdl,
                                                                             '[[:punct:]]+') then
                                                             '0'
                                                            when f.zmatdl is null then
                                                             '0'
                                                            when f.zmatdl like '%null%' then
                                                             '0'
                                                            else
                                                             regexp_replace(f.zmatdl, '\s', '')
                                                          end)
                               
                               ) col4,
                              --  to_number(f.rpa_wgh2), --as "中分类",
                              
                              to_number(case
                                          when regexp_like(f.zmatzl, '.([a-z]+|[A-Z])') then
                                           '0'
                                          when regexp_like(f.zmatzl, '[[:punct:]]+') then
                                           '0'
                                          when f.zmatzl is null then
                                           '0'
                                          when f.zmatzl like '%null%' then
                                           '0'
                                          else
                                           regexp_replace(f.zmatzl, '\s', '')
                                        end) col5,
                              
                              (select distinct e.matzlt
                                 from dim_good_class e
                                where e.matzl = to_number(case
                                                            when regexp_like(f.zmatzl,
                                                                             '.([a-z]+|[A-Z])') then
                                                             '0'
                                                            when regexp_like(f.zmatzl,
                                                                             '[[:punct:]]+') then
                                                             '0'
                                                            when f.zmatzl is null then
                                                             '0'
                                                            when f.zmatzl like '%null%' then
                                                             '0'
                                                            else
                                                             regexp_replace(f.zmatzl, '\s', '')
                                                          end)) col6,
                              -- to_number(f.rpa_wgh1), --as "小分类",
                              
                              to_number(case
                                          when regexp_like(f.zmatxl, '.([a-z]+|[A-Z])') then
                                           '0'
                                          when regexp_like(f.zmatxl, '[[:punct:]]+') then
                                           '0'
                                          when f.zmatxl is null then
                                           '0'
                                          when f.zmatxl like '%null%' then
                                           '0'
                                          else
                                           regexp_replace(f.zmatxl, '\s', '')
                                        end) col7,
                              (select distinct e.matxlt
                                 from dim_good_class e
                                where e.matxl = to_number(case
                                                            when regexp_like(f.zmatxl,
                                                                             '.([a-z]+|[A-Z])') then
                                                             '0'
                                                            when regexp_like(f.zmatxl,
                                                                             '[[:punct:]]+') then
                                                             '0'
                                                            when f.zmatxl is null then
                                                             '0'
                                                            when f.zmatxl like '%null%' then
                                                             '0'
                                                            else
                                                             regexp_replace(f.zmatxl, '\s', '')
                                                          end)) col8,
                              -- to_number(f.matl_group), --as "细分类",
                              to_number(case
                                          when regexp_like(f.matl_group,
                                                           '.([a-z]+|[A-Z])') then
                                           '0'
                                          when regexp_like(f.matl_group, '[[:punct:]]+') then
                                           '0'
                                          when f.matl_group is null then
                                           '0'
                                          when f.matl_group like '%null%' then
                                           '0'
                                          else
                                           regexp_replace(f.matl_group, '\s', '')
                                        end) col9,
                              
                              (select distinct e.matklt
                                 from dim_good_class e
                                where e.matkl = to_number(case
                                                            when regexp_like(f.matl_group,
                                                                             '.([a-z]+|[A-Z])') then
                                                             '0'
                                                            when regexp_like(f.matl_group,
                                                                             '[[:punct:]]+') then
                                                             '0'
                                                            when f.matl_group is null then
                                                             '0'
                                                            when f.matl_group like '%null%' then
                                                             '0'
                                                            else
                                                             regexp_replace(f.matl_group, '\s', '')
                                                          end)) col10,
                              
                              to_date(f.createdon, 'yyyy-mm-dd') col11, --as "建立日期",
                              to_number(f.zeamc027) col12, --as "MD",
                              to_number(f.ztlhrp) col13, -- as "提报组编号",
                              case
                                when f.ztlhrp = 1000 then
                                 'TV提报组'
                                when f.ztlhrp = 2000 then
                                 '电商提报组'
                                when f.ztlhrp = 3000 then
                                 '道格提报组'
                                when f.ztlhrp = 5000 then
                                 '电商提报组'
                                when f.ztlhrp = 6000 then
                                 '电商提报组'
                                when f.ztlhrp = 7000 then
                                 '全球购提报组'
                                when f.ztlhrp = 2100 then
                                 '京东商品提报'
                                when f.ztlhrp = 2200 then
                                 '网易严选'
                                else
                                 '未知'
                              end col14,
                              sysdate col15,
                              sysdate col16,
                              f.md_name col17,
                              nvl(to_number(f.zdxj), 20) col18
                from ods_zmaterial f
               where f.createdon = startpoint
                 and f.zmaterial not like '%F%'
              --and f.ZEAMC027 is not null
              --and f.zeamc027 != 0
              
              ) ta;
    --and f.Zeamc027!='00000000';
  
    --  000000000000000457 000000000000172388
  
    insert_rows := sql%rowcount;
    commit;
  
    /*更新DIM_GOOD.GOOD_PRICE_LEVEL字段
    by yangjin 2017-08-31*/
    yangjin_pkg.dim_good_price_level_update;
  
    /*修改CURRENT_FLG当前有效标志，每个商品只保留最新插入的一条记录为'Y'
    by yangjin 2017-07-25*/
    update dim_good a
       set a.current_flg = 'N', a.w_update_dt = sysdate
     where exists
     (select 1
              from (select c.item_code, count(1) cnt, max(c.row_wid) row_wid
                      from dim_good c
                     where c.current_flg = 'Y'
                     group by c.item_code
                    having count(1) > 1) b
             where a.item_code = b.item_code
               and a.row_wid <> b.row_wid
               and a.current_flg = 'Y');
    update_rows := sql%rowcount;
    commit;
  
    /*根据DIM_EC_GOOD更新DIM_GOOD的GOODS_COMMONID列
    by yangjin 2018-08-03*/
    UPDATE DIM_GOOD A
       SET A.GOODS_COMMONID = NVL((SELECT B.GOODS_COMMONID
                                    FROM DIM_EC_GOOD B
                                   WHERE A.ITEM_CODE = B.ITEM_CODE),
                                  0)
     WHERE (A.GOODS_COMMONID IS NULL OR A.GOODS_COMMONID = 0) /*GOODS_COMMONID=0或者为空*/
       AND EXISTS
     (SELECT 1 FROM DIM_EC_GOOD C WHERE A.ITEM_CODE = C.ITEM_CODE);
    COMMIT;
  
    /*  delete from  dim_good_cost uu where uu.item_code in
    (select ww.item_code from dim_good_cost ww where ww.item_code
    in
    (select vvv.item_code from dim_good_cost vvv
    group by vvv.item_code  having count(vvv.item_code)>1)) and  uu.cost_price=0.00;
    COMMIT;*/
    execute immediate 'TRUNCATE   TABLE   dim_good_md';
  
    insert into dim_good_md
      select to_number(t.item_code), to_number(t.md), sysdate
        from odshappigo.ods_good_md t;
  
    update dim_good h1
       set h1.md =
           (select h2.md
              from dim_good_md h2
             where h2.item_code = h1.item_code
               and rownum = 1);
  
    update dim_good h1
       set h1.md_name =
           (select h2.md
              from dim_md h2
             where h2.md_no = h1.md
               and rownum = 1);
    commit;
  
  end;
  /*日志记录模块*/
  s_etl.end_time       := sysdate;
  s_etl.etl_record_ins := insert_rows;
  s_etl.etl_record_upd := update_rows;
  s_etl.etl_status     := 'SUCCESS';
  s_etl.err_msg        := '输入参数startpoint:' || startpoint; /*yangjin 2018-04-11*/
  s_etl.etl_duration   := trunc((s_etl.end_time - s_etl.start_time) * 86400);
  sp_sbi_w_etl_log(s_etl);
exception
  when others then
    s_etl.end_time   := sysdate;
    s_etl.etl_status := 'FAILURE';
    s_etl.err_msg    := sqlerrm;
    sp_sbi_w_etl_log(s_etl);
    return;
end processgood;
/

