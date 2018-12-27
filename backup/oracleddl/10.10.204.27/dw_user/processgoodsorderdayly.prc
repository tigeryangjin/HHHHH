???create or replace procedure dw_user.processgoodsorderdayly(postday in number) is
  s_etl        w_etl_log%rowtype;
  sp_name      s_parameters2.pname%type;
  s_parameter  s_parameters1.parameter_value%type;
  insert_rows  number;
  --endid number;
  --onetotal number;--一次取多少个
  /*
  功能说明：商品维度计算表
       
  
  作者时间：bobo  2016-07-19
  */

begin

  sp_name          := 'processgoodsorderdayly'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_goods_order_dayly'; --此处需要手工录入该PROCEDURE操作的表格
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

  delete from fact_goods_order_dayly where POSTING_DATE_KEY = postday;

  insert into fact_goods_order_dayly
    (posting_date_key,
     today_nums,
     today_order,
     today_member,
     cancel_nums,
     cancel_order,
     cancel_member,
     rejection_nums,
     rejection_order,
     rejection_member,
     rejection_cancel_nums,
     rejection_cancel_order,
     rejection_cancel_member,
     effective_nums,
     effective_order,
     effective_member,
     zj_state,
     cart_nums,
     sc_nums,
     pv_nums,
     comment_total,
     comment_good,
     comment_better,
     comment_best,
     item_code,
     goods_common_key)
    (select postday AS posting_date_key,
            today_nums,
            today_order,
            today_member,
            cancel_nums,
            cancel_order,
            cancel_member,
            rejection_nums,
            rejection_order,
            rejection_member,
            rejection_cancel_nums,
            rejection_cancel_order,
            rejection_cancel_member,
            (ps.today_nums - ps.cancel_nums - ps.rejection_nums +
            ps.rejection_cancel_nums) as EFFECTIVE_NUMS,
            (ps.today_ORDER - ps.cancel_ORDER - ps.rejection_ORDER +
            ps.rejection_cancel_ORDER) as EFFECTIVE_ORDER,
            (ps.today_MEMBER - ps.cancel_MEMBER - ps.rejection_MEMBER +
            ps.rejection_cancel_MEMBER) as EFFECTIVE_MEMBER,
            zj_state,
            cart_nums,
            fav_nums as sc_nums,
            pv_nums,
            comment_total,
            comment_good,
            comment_better,
            comment_best,
            item_code,
            goods_commonid as goods_common_key
     
       from (select gg.item_code,
                    gg.pv_nums,
                    (case when gg.today_nums is null then 0 else gg.today_nums end) as today_nums,
                    (case when gg.today_order is null then 0 else gg.today_order  end) as today_order,
                    (case when gg.today_member is null then  0 else gg.today_member end) as today_member,
                    (case when gg.cancel_nums is null then 0 else gg.cancel_nums end) as cancel_nums,
                    (case when gg.cancel_order is null then 0 else gg.cancel_order end) as cancel_order,
                    (case when gg.cancel_member is null then 0 else  gg.cancel_member end) as cancel_member,
                    (case when gg.rejection_nums is null then 0 else  gg.rejection_nums end) as rejection_nums,
                    (case when gg.rejection_order is null then 0 else gg.rejection_order end) as rejection_order,
                    (case when gg.rejection_member is null then 0 else gg.rejection_member end) as rejection_member,
                    (case when gg.rejection_cancel_nums is null then 0 else gg.rejection_cancel_nums end) as rejection_cancel_nums,
                    (case when gg.rejection_cancel_order is null then 0 else  gg.rejection_cancel_order end) as rejection_cancel_order,
                    (case  when gg.rejection_cancel_member is null then 0 else gg.rejection_cancel_member end) as rejection_cancel_member,
                    zj.zj_state,
                    (case when cart.total is null then 0 else cart.total end) as cart_nums,
                    (case when ff.nums is null then 0 else ff.nums end) as fav_nums,
                    (case when pll.cp is null then  0 else pll.cp end) as COMMENT_GOOD,
                    (case  when pll.zp is null then  0 else pll.zp end) as COMMENT_better,
                    (case when pll.hp is null then 0 else pll.hp end) as COMMENT_best,
                    (case when pll.total is null then 0 else pll.total end) as COMMENT_total,
                    gg.goods_commonid
               from (select 
                (case when gc.item_code is not null then gc.item_code
                when eg.item_code is not null then eg.item_code
                 else crmg.item_code end) item_code,
                (case when gc.goods_commonid is not null then gc.goods_commonid
                when eg.goods_commonid is not null then eg.goods_commonid
                 else 0 end) goods_commonid,
                (case when gc.pv_nums is null then 0 else gc.pv_nums end) pv_nums,
                gc.goods_common_key,gc.TODAY_NUMS,gc.TODAY_ORDER,
                gc.today_member,gc.CANCEL_NUMS,gc.CANCEL_order,gc.CANCEL_member,
                gc.REJECTION_NUMS,gc.REJECTION_order,gc.REJECTION_member,gc.REJECTION_CANCEL_nums,gc.REJECTION_CANCEL_order,gc.REJECTION_CANCEL_member
                from (

                  select * from (
                  --pv浏览信息统计
                  select g.item_code,g.goods_commonid,p.pv_nums from (
                  select to_number(page_value) as page_value,count(1) as pv_nums from fact_page_view where visit_date_key=postday and page_name='Good' and
                  trim(translate(nvl(page_value,'x'),'0123456789',' ')) is NULL group by page_value)
                  p inner join dim_ec_good g on g.goods_commonid=p.page_value
                  --pv浏览信息统计结束
                        ) ggv full join (

                   --订单数据开始
                  select (case when p.goods_common_key is not null then p.goods_common_key
                  when pp.goods_common_key is not null  then pp.goods_common_key
                  when ppp.goods_common_key is not null  then ppp.goods_common_key
                    else pppp.goods_common_key end) as goods_common_key,
                    sum(case when p.TODAY_NUMS is not null then p.TODAY_NUMS else 0 end) TODAY_NUMS,
                    sum(case when p.TODAY_ORDER is not null then p.TODAY_ORDER else 0 end) TODAY_ORDER,
                    sum(case when p.totay_member is not null then p.totay_member else 0 end) today_member,
                    sum(case when pp.CANCEL_NUMS is not null then pp.CANCEL_NUMS else 0 end) CANCEL_NUMS,
                    sum(case when pp.CANCEL_order is not null then pp.CANCEL_order else 0 end) CANCEL_order,
                    sum(case when pp.CANCEL_member is not null then pp.CANCEL_member else 0 end) CANCEL_member,
                    sum(case when ppp.REJECTION_NUMS is not null then ppp.REJECTION_NUMS else 0 end) REJECTION_NUMS,
                    sum(case when ppp.REJECTION_order is not null then ppp.REJECTION_order else 0 end) REJECTION_order,
                    sum(case when ppp.REJECTION_member is not null then ppp.REJECTION_member else 0 end) REJECTION_member,
                    sum(case when pppp.REJECTION_CANCEL_nums is not null then pppp.REJECTION_CANCEL_nums else 0 end) REJECTION_CANCEL_nums,
                    sum(case when pppp.REJECTION_CANCEL_order is not null then pppp.REJECTION_CANCEL_order else 0 end) REJECTION_CANCEL_order,
                    sum(case when pppp.REJECTION_CANCEL_member is not null then pppp.REJECTION_CANCEL_member else 0 end) REJECTION_CANCEL_member
                       from 
                  --今天总的订单数
                  (select goods_common_key,sum(nums) as TODAY_NUMS,count(distinct(order_key)) as TODAY_ORDER,count(distinct(member_key)) as totay_member
                  from fact_goods_sales where posting_date_key=postday and sales_source_second_key in (20022, 20021, 20020, 20018, 20017)
                  group by goods_common_key) p full join 
                  --今天取消数
                  (select goods_common_key,sum(nums) as CANCEL_NUMS,count(distinct(order_key)) as CANCEL_order,count(distinct(member_key)) as CANCEL_member
                  from fact_goods_sales where cancel_date_key=postday and sales_source_second_key in (20022, 20021, 20020, 20018, 20017)and Cancel_before_state=1
                  group by goods_common_key) pp on p.goods_common_key = pp.goods_common_key full join
                  --今天拒收拒退数
                  (select goods_common_key,sum(nums) as REJECTION_NUMS,count(distinct(order_h_key)) as REJECTION_order,count(distinct(member_key)) as REJECTION_member 
                  from fact_goods_sales_reverse where 
                  posting_date_key=postday and sales_source_second_key in (20022, 20021, 20020, 20018, 20017) and Order_type=0
                  group by goods_common_key) ppp on pp.goods_common_key = ppp.goods_common_key full join
                  --今天拒收取消数
                  (select goods_common_key,sum(nums) as REJECTION_CANCEL_nums,count(distinct(order_h_key)) as REJECTION_CANCEL_order,count(distinct(member_key)) as REJECTION_CANCEL_member 
                  from fact_goods_sales_reverse where 
                  Cancel_date_key=postday and sales_source_second_key in (20022, 20021, 20020, 20018, 20017) and Order_type=0 and Cancel_state=1
                  group by goods_common_key) pppp on pppp.goods_common_key = ppp.goods_common_key

                  group by (case when p.goods_common_key is not null then p.goods_common_key
                  when pp.goods_common_key is not null  then pp.goods_common_key
                  when ppp.goods_common_key is not null  then ppp.goods_common_key
                    else pppp.goods_common_key end)
                --订单数据结束
                  ) gsqs on ggv.item_code=gsqs.goods_common_key
    
                  ) gc left join dim_ec_good eg on gc.goods_common_key=eg.item_code
    left join dim_good crmg on gc.goods_common_key=crmg.item_code) gg
             
    --在架开始
               left join fact_daily_goodszj_stat zj
                 on gg.item_code = zj.item_code
             --在架结束
             --购物车开始
               left join (select item_code, sum(nums) as total
                           from ((select g.item_code, p.nums
                                    from (select scgid, sum(scgq) nums
                                            from fact_shoppingcar
                                           where create_date_key = postday
                                             and application_key != 10
                                           group by scgid) p
                                    left join dim_ec_good g
                                      on p.scgid = g.goods_commonid)
                                
                                 union
                                
                                 (select g.item_code, sum(p.nums) as nums
                                    from (select scgid, sum(scgq) nums
                                            from fact_shoppingcar
                                           where create_date_key = postday
                                             and application_key = 10
                                           group by scgid) p
                                    left join dim_ec_goods g
                                      on p.scgid = g.goods_id
                                   group by g.item_code))
                          group by item_code) cart
                 on cart.item_code = gg.item_code
             --购物车结束
             --收藏开始
               left join (
                         select g.item_code, count(1) as nums
                           from fact_favorites f
                           left join dim_ec_good g
                             on f.fav_id = g.goods_commonid
                          where f.fav_time = postday
                            and f.fav_type = 'goods'
                          group by g.item_code) ff
                 on ff.item_code = gg.item_code
                 --收藏结束
                 --评论开始
               left join (
                         select item_code,
                                 sum(case when geval_scores = 5 then  1 else 0 end) as hp,
                                 count(1) as total,
                                 sum(case when geval_scores = 3 or geval_scores = 4 then 1 else 0 end) as zp,
                                 sum(case when geval_scores != 3 and geval_scores != 4 and geval_scores != 5 then 1 else 0 end) as cp
                           from FACT_GOODS_EVALUATE
                          where geval_addtime_key = postday
                          group by item_code) pll
                          --评论结束
                 on pll.item_code = gg.item_code) ps);

  insert_rows := sql%rowcount;
 if  insert_rows>0 then 
  insert into fact_goods_dim_total
    (item_code,
     goods_common_key,
     goods_name,
     brand_id,
     brand_name,
     ec_cate_id,
     matdl,
     matdl_key,
     matzl,
     matzl_key,
     matxl,
     matxl_key,
     matxxl,
     group_name,
     md,
     supplier_id,
     supplier_name,
     delivery_key)
  
    (select gl.item_code,
            gl.GOODS_COMMON_KEY,
            cg.GOODS_NAME,
            cg.BRAND_ID,
            cg.brand_name,
            eg.gc_id            as ec_cate_id,
            cg.MATDLt           as matdl,
            cg.MATDL            as MATDL_KEY,
            cg.MATzLt           as matzl,
            cg.MATzL            as MATzL_KEY,
            cg.MATxLt           as matxl,
            cg.MATxL            as MATxL_KEY,
            cg.matxxlt          as matxxl,
            cg.GROUP_NAME,
            cg.MD,
            eg.supplier_id      as supplier_key,
            eg.supplier_name,
            eg.is_shipping_self as delivery_key
       from fact_goods_order_dayly gl
       left join dim_good cg
         on cg.item_code = gl.item_code
       left join dim_ec_good eg
         on gl.item_code = eg.item_code
      where gl.item_code not in
            (select item_code from fact_goods_dim_total)
        and gl.posting_date_key = postday);
   
  merge into fact_goods_dim_total m --fzq1表是需要更新的表
  using (select zj.zj_state,
                gs.goods_stock as stock_nums,
                g.firstonselltime as first_sj_time,
                (case
                  when zj.zj_time is null then
                   g.firstonselltime
                  else
                   zj.zj_time
                end) as last_sj_time,
                p.*
           from (
                 
                 select item_code,
                         sum(COMMENT_TOTAL) as comment_total,
                         sum(comment_best) as comment_best,
                         sum(comment_better) as comment_better,
                         sum(comment_good) as comment_good,
                         sum(effective_nums) as effective_total,
                         sum(cancel_nums) as cancel_total,
                         sum(TODAY_NUMS) as sale_total,
                         sum(rejection_nums) as rejection_total,
                         sum(rejection_cancel_nums) as rejection_cancel_total,
                         sum(effective_order) as effective_order_total,
                         sum(cancel_order) as cancel_order_total,
                         sum(TODAY_ORDER) as sale_order_total,
                         sum(rejection_order) as rejection_order_total,
                         sum(rejection_cancel_order) as rejection_order_cancel_total,
                         sum(effective_member) as effective_member_total,
                         sum(cancel_member) as cancel_member_total,
                         sum(TODAY_MEMBER) as sale_member_total,
                         sum(rejection_member) as rejection_member_total,
                         sum(rejection_cancel_member) as rejection_member_cancel_total,
                         sum(cart_nums) as cart_total,
                         sum(sc_nums) as sc_total,
                         sum(pv_nums) as pv_total
                 
                   from fact_goods_order_dayly
                  where item_code in
                        (select item_code
                           from fact_goods_order_dayly
                          where posting_date_key = postday)
                 
                  group by item_code) p
           left join fact_ecgoods_stock gs
             on p.item_code = gs.item_code
         
           left join fact_daily_goodszj_stat zj
             on p.item_code = zj.item_code
           left join dim_ec_good g
             on p.item_code = g.item_code) mm -- 关联表
  on (m.item_code = mm.item_code) --关联条件
  when matched then --匹配关联条件，作更新处理
    update
       set m.zj_state                      = mm.zj_state,
           m.stock_nums                    = mm.stock_nums,
           m.first_sj_time                 = mm.first_sj_time,
           m.last_sj_time                  = mm.last_sj_time,
           m.comment_total                 = mm.comment_total,
           m.comment_best                  = mm.comment_best,
           m.comment_better                = mm.comment_better,
           m.comment_good                  = mm.comment_good,
           m.effective_total               = mm.effective_total,
           m.cancel_total                  = mm.cancel_total,
           m.sale_total                    = mm.sale_total,
           m.rejection_total               = mm.rejection_total,
           m.rejection_cancel_total        = mm.rejection_cancel_total,
           m.effective_order_total         = mm.effective_order_total,
           m.cancel_order_total            = mm.cancel_order_total,
           m.sale_order_total              = mm.sale_order_total,
           m.rejection_order_total         = mm.rejection_order_total,
           m.rejection_order_cancel_total  = mm.rejection_order_cancel_total,
           m.effective_member_total        = mm.effective_member_total,
           m.cancel_member_total           = mm.cancel_member_total,
           m.sale_member_total             = mm.sale_member_total,
           m.rejection_member_total        = mm.rejection_member_total,
           m.rejection_member_cancel_total = mm.rejection_member_cancel_total,
           m.cart_total                    = mm.cart_total,
           m.sc_total                      = mm.sc_total,
           m.pv_total                      = mm.pv_total;
  --此处只是说明可以同时更新多个字段。
  end if;
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
end processgoodsorderdayly;
/

