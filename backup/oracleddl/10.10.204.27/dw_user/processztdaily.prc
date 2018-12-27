???create or replace procedure dw_user.processztdaily(startpoint in number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processztdaily'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_daily_zt'; --此处需要手工录入该PROCEDURE操作的表格
  s_etl.proc_name  := sp_name;
  s_etl.start_time := sysdate;
  s_parameter      := 0;

  begin
    sp_parameter_two(sp_name, s_parameter);
    if s_parameter = '0' then
      s_etl.err_msg := '没有找到对应的过程加载类型数据';
      sp_sbi_w_etl_log(s_etl);
      return;
    end if;
  end;

  delete from fact_daily_zt;
  --delete from fact_daily_zhuangti;
  commit;
  delete from fact_daily_zhuangti
   where to_char(stats_date, 'yyyy-mm-dd') =to_char(to_date(to_char(startpoint),'yyyy-mm-dd'),'yyyy-mm-dd');
   
   -- to_char(trunc(sysdate - 1),'yyyy-mm-dd');
  commit;

  insert into fact_daily_zt
    (zt_type,
     zt_id,
     zt_name,
     zt_start_date,
     zt_end_date,
     stats_date,
     ztcl_goodsnum,
     ztdx_goodsnum,
     ztpv,
     ztuv,
     ztavgcnt,
     ztavgtime,
     ztordercnt,
     ztorderrs,
     ztzhrate,
     ztorderjs,
     ztordertot,
     ztitemcode,
     ztitemname,
     ztitemprice,
     ztitempv,
     ztitemuv,
     ztitemordercnt,
     ztitemorderjs,
     ztitemordertot,
     ztitemmatdlt,
     ztitembname,
     ztitemistv
     
     )
  
  select pp1.zttypenm as "专题类型",
           pp1.zt_id as "专题编号",
           pp1.zt_name as "专题名称",
           pp1.add_date_key as "专题开始时间",
           pp1.end_date_key as "专题结束时间",
         --to_date(to_char((sysdate - 17),'yyyy-mm-dd'),'yyyy-mm-dd') as "统计日期",
         to_date(to_char(startpoint),'yyyy-mm-dd')  as "统计日期",
           (select nvl(count(pp6.goods_common_id), 0)
              from dim_zhuangti_goods pp6
             where pp6.id = pp1.zt_id
               and pp6.zttype = pp1.zttypenm
             group by pp6.id) as "专题陈列商品数",
           nvl((select nvl(count(distinct pp7.goods_commonid), 0)
                 from fact_ztordergoods pp7
                where pp7.zt_id = pp1.zt_id
                  and pp7.zt_type_name = pp1.zttypenm
                group by pp7.zt_id),
               0) as "专题动销商品数",
           pp1.pvcnt as "进入专题PV",
           pp1.uvcnt as "进入专题UV",
           pp1.avgcnt as "专题平均浏览数",
           pp1.avgtime as "专题平均浏览时长",
           pp1.ordercnt as "专题订单数",
           pp1.orderrs as "专题订购人数",
           trunc((pp1.orderrs / pp1.uvcnt), 3) as "专题转化率",
           pp1.ordernum as "专题订购件数",
           pp1.ordertot as "专题订购金额",
           pp2.item_code as "专题内商品编号",
           pp2.goods_name as "专题内商品名称",
           pp2.goods_price as "专题内商品金额",
           pp2.ztgcnt as "专题商品PV",
           pp2.asztgvt as "专题商品UV",
           pp2.ztocnt as "专题商品订单数",
           pp2.ztjscnt as "专题商品件数",
           pp2.ztotot as "专题商品订单金额",
           pp2.matdlt as "物料大类",
           pp2.brand_name as "品牌",
           pp2.is_tv as "提报组"
      from (select x1.zttypenm,
                   x1.zt_id,
                   x1.zt_name,
                   x1.add_date_key,
                   x1.end_date_key,
                   x1.page_value,
                   x1.pvcnt,
                   x1.uvcnt,
                   x1.avgcnt,
                   x1.avgtime,
                   nvl(x2.orderrs, 0) as orderrs,
                   nvl(x2.ordercnt, 0) as ordercnt,
                   nvl(x2.ordernum, 0) as ordernum,
                   nvl(x2.ordertot, 0) as ordertot
              from (select t0.*
                      from (select (select w1.zttypenm
                                      from dim_zhuangti w1
                                     where w1.zttypenm = ll.page_name
                                       and w1.zt_id = to_number(case
                       when regexp_like(ll.page_value, '.([a-z]+|[A-Z])') then
                        '0'
                       when regexp_like(ll.page_value, '[[:punct:]]+') then
                        '0'
                       when ll.page_value is null then
                        '0'
                       when ll.page_value like '%null%' then
                        '0'
                       else
                        regexp_replace(ll.page_value, '\s', '')
                     end) 
                                       ) as zttypenm,
                                   (select w1.zt_id
                                      from dim_zhuangti w1
                                     where w1.zttypenm = ll.page_name
                                       and w1.zt_id = to_number(case
                       when regexp_like(ll.page_value, '.([a-z]+|[A-Z])') then
                        '0'
                       when regexp_like(ll.page_value, '[[:punct:]]+') then
                        '0'
                       when ll.page_value is null then
                        '0'
                       when ll.page_value like '%null%' then
                        '0'
                       else
                        regexp_replace(ll.page_value, '\s', '')
                     end) ) as zt_id,
                                   (select w1.zt_name
                                      from dim_zhuangti w1
                                     where w1.zttypenm = ll.page_name
                                       and w1.zt_id =to_number(case
                       when regexp_like(ll.page_value, '.([a-z]+|[A-Z])') then
                        '0'
                       when regexp_like(ll.page_value, '[[:punct:]]+') then
                        '0'
                       when ll.page_value is null then
                        '0'
                       when ll.page_value like '%null%' then
                        '0'
                       else
                        regexp_replace(ll.page_value, '\s', '')
                     end) ) as zt_name,
                                   (select w1.add_date_key
                                      from dim_zhuangti w1
                                     where w1.zttypenm = ll.page_name
                                       and w1.zt_id =to_number(case
                       when regexp_like(ll.page_value, '.([a-z]+|[A-Z])') then
                        '0'
                       when regexp_like(ll.page_value, '[[:punct:]]+') then
                        '0'
                       when ll.page_value is null then
                        '0'
                       when ll.page_value like '%null%' then
                        '0'
                       else
                        regexp_replace(ll.page_value, '\s', '')
                     end) ) as add_date_key,
                                   (select w1.end_date_key
                                      from dim_zhuangti w1
                                     where w1.zttypenm = ll.page_name
                                       and w1.zt_id = to_number(case
                       when regexp_like(ll.page_value, '.([a-z]+|[A-Z])') then
                        '0'
                       when regexp_like(ll.page_value, '[[:punct:]]+') then
                        '0'
                       when ll.page_value is null then
                        '0'
                       when ll.page_value like '%null%' then
                        '0'
                       else
                        regexp_replace(ll.page_value, '\s', '')
                     end) ) as end_date_key,
                                   ll.page_value,
                                   count(ll.id) as pvcnt,
                                   count(distinct ll.vid) as uvcnt,
                                   trunc(((count(ll.id) /
                                         count(distinct ll.vid))),
                                         2) as avgcnt,
                                   trunc((sum(ll.page_staytime) / count(ll.id)),
                                         2) as avgtime
                              from fact_page_view ll
                             where ll.visit_date_key = startpoint
                               and ll.page_key in (8101, 8102, 8925, 8926)
                               and ll.page_value != 'undefined'
                             group by ll.page_name, ll.page_value) t0
                     where t0.zttypenm is not null) x1,
                   (select t.zt_type_name,
                           t.zt_id,
                           count(distinct t.vid) as orderrs,
                           count(t.order_id) as ordercnt,
                           sum(t.goods_num) as ordernum,
                           sum(t.goods_num * t.goods_pay_price) as ordertot
                      from fact_ztordergoods t
                     group by t.zt_type_name, t.zt_id) x2
             where x1.zttypenm = x2.zt_type_name(+)
               and x1.page_value = x2.zt_id(+)) pp1,
           (select x0.page_value,
                   (select w1.zttypenm
                      from dim_zhuangti w1
                     where w1.zttypenm = x0.page_name
                       and w1.zt_id = to_number(case
                       when regexp_like(x0.page_value, '.([a-z]+|[A-Z])') then
                        '0'
                       when regexp_like(x0.page_value, '[[:punct:]]+') then
                        '0'
                       when x0.page_value is null then
                        '0'
                       when x0.page_value like '%null%' then
                        '0'
                       else
                        regexp_replace(x0.page_value, '\s', '')
                     end)) as zttypenm,
                   (select w1.zt_name
                      from dim_zhuangti w1
                     where w1.zttypenm = x0.page_name
                       and w1.zt_id = to_number(case
                       when regexp_like(x0.page_value, '.([a-z]+|[A-Z])') then
                        '0'
                       when regexp_like(x0.page_value, '[[:punct:]]+') then
                        '0'
                       when x0.page_value is null then
                        '0'
                       when x0.page_value like '%null%' then
                        '0'
                       else
                        regexp_replace(x0.page_value, '\s', '')
                     end)) as zt_name,
                   (select w1.add_date_key
                      from dim_zhuangti w1
                     where w1.zttypenm = x0.page_name
                       and w1.zt_id = to_number(case
                       when regexp_like(x0.page_value, '.([a-z]+|[A-Z])') then
                        '0'
                       when regexp_like(x0.page_value, '[[:punct:]]+') then
                        '0'
                       when x0.page_value is null then
                        '0'
                       when x0.page_value like '%null%' then
                        '0'
                       else
                        regexp_replace(x0.page_value, '\s', '')
                     end)) as add_date_key,
                   (select o2.item_code
                      from dim_ec_good o2
                     where o2.goods_commonid = x1.goods_code) as item_code,
                   (select o2.goods_name
                      from dim_ec_good o2
                     where o2.goods_commonid = x1.goods_code) as goods_name,
                   (select o2.goods_price
                      from dim_ec_good o2
                     where o2.goods_commonid = x1.goods_code) as goods_price,
                   
                   (select case
                             when o2.is_kjg = 1 then
                              '(跨境购)' || o2.matdlt
                             else
                              o2.matdlt
                           end
                      from dim_ec_good o2
                     where o2.goods_commonid = x1.goods_code) as matdlt,
                   (select nvl(o2.brand_name, 'UNKNOWN')
                      from dim_ec_good o2
                     where o2.goods_commonid = x1.goods_code) as brand_name,
                   (select decode(o2.is_tv,
                                  0,
                                  '电商提报组',
                                  1,
                                  '非电商提报组')
                      from dim_ec_good o2
                     where o2.goods_commonid = x1.goods_code) as is_tv,
                   --x1.goods_code,
                   nvl(x0.ztcnt, 0) as ztcnt,
                   nvl(x0.ztvt, 0) as ztvt,
                   nvl(x1.ztgcnt, 0) as ztgcnt,
                   nvl(x1.ztgvt, 0) asztgvt,
                   nvl(x2.ztocnt, 0) as ztocnt,
                   nvl(x2.ztjscnt, 0) as ztjscnt,
                   nvl(x2.ztotot, 0) as ztotot
              from (select z0.page_name,
                           to_number(case
                       when regexp_like(z0.page_value, '.([a-z]+|[A-Z])') then
                        '0'
                       when regexp_like(z0.page_value, '[[:punct:]]+') then
                        '0'
                       when z0.page_value is null then
                        '0'
                       when z0.page_value like '%null%' then
                        '0'
                       else
                        regexp_replace(z0.page_value, '\s', '')
                     end) as page_value,
                           count(z0.id) as ztcnt,
                           count(distinct device_key) as ztvt
                      from fact_page_view z0
                     where z0.visit_date_key =startpoint
                       and z0.page_key in (8101, 8102, 8925, 8926)
                       and z0.page_value != 'undefined'
                     group by z0.page_name, to_number(case
                       when regexp_like(z0.page_value, '.([a-z]+|[A-Z])') then
                        '0'
                       when regexp_like(z0.page_value, '[[:punct:]]+') then
                        '0'
                       when z0.page_value is null then
                        '0'
                       when z0.page_value like '%null%' then
                        '0'
                       else
                        regexp_replace(z0.page_value, '\s', '')
                     end)) x0,
                   
                   (select z1.zt_type_name,
                           z1.zt_id,
                           z1.goods_code,
                           count(z1.vid) as ztgcnt,
                           count(distinct z1.vid) as ztgvt
                      from fact_ztgoods z1
                     group by z1.zt_type_name, z1.zt_id, z1.goods_code) x1,
                   (select distinct z2.zt_type_name,
                                    z2.zt_id,
                                    z2.goods_commonid,
                                    z2.goods_name,
                                    count(z2.order_id) over(partition by z2.zt_type_name, z2.zt_id, z2.goods_commonid, z2.goods_name order by 1) as ztocnt,
                                    sum(z2.goods_num) over(partition by z2.zt_type_name, z2.zt_id, z2.goods_commonid, z2.goods_name order by 1) as ztjscnt,
                                    sum(z2.goods_num * z2.goods_pay_price) over(partition by z2.zt_type_name, z2.zt_id, z2.goods_commonid, z2.goods_name order by 1) as ztotot
                    --count(distinct z2.goods_commonid) over(partition by z2.zt_type_name,z2.zt_id ) as dxcnt
                      from fact_ztordergoods z2) x2
             where x0.page_name = x1.zt_type_name
               and x0.page_value = x1.zt_id
               and x1.zt_type_name = x2.zt_type_name(+)
               and x1.zt_id = x2.zt_id(+)
               and x1.goods_code = x2.goods_commonid(+)) pp2
     where pp1.zttypenm = pp2.zttypenm
       and pp1.page_value = pp2.page_value;
  
  
  
  
  
  
  
  
  
  
  
  
  
   /* select pp1.zttypenm as "专题类型",
           pp1.zt_id as "专题编号",
           pp1.zt_name as "专题名称",
           pp1.add_date_key as "专题开始时间",
           pp1.end_date_key as "专题结束时间",
         to_date(to_char((sysdate - 28),'yyyy-mm-dd'),'yyyy-mm-dd') as "统计日期",
           (select nvl(count(pp6.goods_common_id), 0)
              from dim_zhuangti_goods pp6
             where pp6.id = pp1.zt_id
               and pp6.zttype = pp1.zttypenm
             group by pp6.id) as "专题陈列商品数",
           nvl((select nvl(count(distinct pp7.goods_commonid), 0)
                 from fact_ztordergoods pp7
                where pp7.zt_id = pp1.zt_id
                  and pp7.zt_type_name = pp1.zttypenm
                group by pp7.zt_id),
               0) as "专题动销商品数",
           pp1.pvcnt as "进入专题PV",
           pp1.uvcnt as "进入专题UV",
           pp1.avgcnt as "专题平均浏览数",
           pp1.avgtime as "专题平均浏览时长",
           pp1.ordercnt as "专题订单数",
           pp1.orderrs as "专题订购人数",
           trunc((pp1.orderrs / pp1.uvcnt), 3) as "专题转化率",
           pp1.ordernum as "专题订购件数",
           pp1.ordertot as "专题订购金额",
           pp2.item_code as "专题内商品编号",
           pp2.goods_name as "专题内商品名称",
           pp2.goods_price as "专题内商品金额",
           pp2.ztgcnt as "专题商品PV",
           pp2.asztgvt as "专题商品UV",
           pp2.ztocnt as "专题商品订单数",
           pp2.ztjscnt as "专题商品件数",
           pp2.ztotot as "专题商品订单金额",
           pp2.matdlt as "物料大类",
           pp2.brand_name as "品牌",
           pp2.is_tv as "提报组"
      from (select x1.zttypenm,
                   x1.zt_id,
                   x1.zt_name,
                   x1.add_date_key,
                   x1.end_date_key,
                   x1.page_value,
                   x1.pvcnt,
                   x1.uvcnt,
                   x1.avgcnt,
                   x1.avgtime,
                   nvl(x2.orderrs, 0) as orderrs,
                   nvl(x2.ordercnt, 0) as ordercnt,
                   nvl(x2.ordernum, 0) as ordernum,
                   nvl(x2.ordertot, 0) as ordertot
              from (select t0.*
                      from (select (select w1.zttypenm
                                      from dim_zhuangti w1
                                     where w1.zttypenm = ll.page_name
                                       and w1.zt_id = ll.page_value) as zttypenm,
                                   (select w1.zt_id
                                      from dim_zhuangti w1
                                     where w1.zttypenm = ll.page_name
                                       and w1.zt_id = ll.page_value) as zt_id,
                                   (select w1.zt_name
                                      from dim_zhuangti w1
                                     where w1.zttypenm = ll.page_name
                                       and w1.zt_id = ll.page_value) as zt_name,
                                   (select w1.add_date_key
                                      from dim_zhuangti w1
                                     where w1.zttypenm = ll.page_name
                                       and w1.zt_id = ll.page_value) as add_date_key,
                                   (select w1.end_date_key
                                      from dim_zhuangti w1
                                     where w1.zttypenm = ll.page_name
                                       and w1.zt_id = ll.page_value) as end_date_key,
                                   ll.page_value,
                                   count(ll.id) as pvcnt,
                                   count(distinct ll.vid) as uvcnt,
                                   trunc(((count(ll.id) /
                                         count(distinct ll.vid))),
                                         2) as avgcnt,
                                   trunc((sum(ll.page_staytime) / count(ll.id)),
                                         2) as avgtime
                              from fact_page_view ll
                             where ll.visit_date_key = startpoint
                               and ll.page_key in (8101, 8102, 8925, 8926)
                               and ll.page_value != 'undefined'
                             group by ll.page_name, ll.page_value) t0
                     where t0.zttypenm is not null) x1,
                   (select t.zt_type_name,
                           t.zt_id,
                           count(distinct t.vid) as orderrs,
                           count(t.order_id) as ordercnt,
                           sum(t.goods_num) as ordernum,
                           sum(t.goods_num * t.goods_pay_price) as ordertot
                      from fact_ztordergoods t
                     group by t.zt_type_name, t.zt_id) x2
             where x1.zttypenm = x2.zt_type_name(+)
               and x1.page_value = x2.zt_id(+)) pp1,
           (select x0.page_value,
                   (select w1.zttypenm
                      from dim_zhuangti w1
                     where w1.zttypenm = x0.page_name
                       and w1.zt_id = x0.page_value) as zttypenm,
                   (select w1.zt_name
                      from dim_zhuangti w1
                     where w1.zttypenm = x0.page_name
                       and w1.zt_id = x0.page_value) as zt_name,
                   (select w1.add_date_key
                      from dim_zhuangti w1
                     where w1.zttypenm = x0.page_name
                       and w1.zt_id = x0.page_value) as add_date_key,
                   (select o2.item_code
                      from dim_ec_good o2
                     where o2.goods_commonid = x1.goods_code) as item_code,
                   (select o2.goods_name
                      from dim_ec_good o2
                     where o2.goods_commonid = x1.goods_code) as goods_name,
                   (select o2.goods_price
                      from dim_ec_good o2
                     where o2.goods_commonid = x1.goods_code) as goods_price,
                   
                   (select case
                             when o2.is_kjg = 1 then
                              '(跨境购)' || o2.matdlt
                             else
                              o2.matdlt
                           end
                      from dim_ec_good o2
                     where o2.goods_commonid = x1.goods_code) as matdlt,
                   (select nvl(o2.brand_name, 'UNKNOWN')
                      from dim_ec_good o2
                     where o2.goods_commonid = x1.goods_code) as brand_name,
                   (select decode(o2.is_tv,
                                  0,
                                  '电商提报组',
                                  1,
                                  '非电商提报组')
                      from dim_ec_good o2
                     where o2.goods_commonid = x1.goods_code) as is_tv,
                   --x1.goods_code,
                   nvl(x0.ztcnt, 0) as ztcnt,
                   nvl(x0.ztvt, 0) as ztvt,
                   nvl(x1.ztgcnt, 0) as ztgcnt,
                   nvl(x1.ztgvt, 0) asztgvt,
                   nvl(x2.ztocnt, 0) as ztocnt,
                   nvl(x2.ztjscnt, 0) as ztjscnt,
                   nvl(x2.ztotot, 0) as ztotot
              from (select z0.page_name,
                           to_number(z0.page_value) as page_value,
                           count(z0.id) as ztcnt,
                           count(distinct device_key) as ztvt
                      from fact_page_view z0
                     where z0.visit_date_key = startpoint
                       and z0.page_key in (8101, 8102, 8925, 8926)
                       and z0.page_value != 'undefined'
                     group by z0.page_name, to_number(z0.page_value)) x0,
                   
                   (select z1.zt_type_name,
                           z1.zt_id,
                           z1.goods_code,
                           count(z1.vid) as ztgcnt,
                           count(distinct z1.vid) as ztgvt
                      from fact_ztgoods z1
                     group by z1.zt_type_name, z1.zt_id, z1.goods_code) x1,
                   (select distinct z2.zt_type_name,
                                    z2.zt_id,
                                    z2.goods_commonid,
                                    z2.goods_name,
                                    count(z2.order_id) over(partition by z2.zt_type_name, z2.zt_id, z2.goods_commonid, z2.goods_name order by 1) as ztocnt,
                                    sum(z2.goods_num) over(partition by z2.zt_type_name, z2.zt_id, z2.goods_commonid, z2.goods_name order by 1) as ztjscnt,
                                    sum(z2.goods_num * z2.goods_pay_price) over(partition by z2.zt_type_name, z2.zt_id, z2.goods_commonid, z2.goods_name order by 1) as ztotot
                    --count(distinct z2.goods_commonid) over(partition by z2.zt_type_name,z2.zt_id ) as dxcnt
                      from fact_ztordergoods z2) x2
             where x0.page_name = x1.zt_type_name
               and x0.page_value = x1.zt_id
               and x1.zt_type_name = x2.zt_type_name(+)
               and x1.zt_id = x2.zt_id(+)
               and x1.goods_code = x2.goods_commonid(+)) pp2
     where pp1.zttypenm = pp2.zttypenm
       and pp1.page_value = pp2.page_value;*/

  insert_rows := sql%rowcount;
  commit;

  /*insert into fact_daily_zhuangti
    (zt_id,
     zt_name,
     zt_start_date,
     zt_end_date,
     stats_date,
     ztcl_goodsnum,
     ztdx_goodsnum,
     ztpv,
     ztuv,
     ztavgcnt,
     ztavgtime,
     ztordercnt,
     ztorderrs,
     ztzhrate,
     ztorderjs,
     ztordertot,
     ztitemcode,
     ztitemname,
     ztitemprice,
     ztitempv,
     ztitemuv,
     ztitemordercnt,
     ztitemorderjs,
     ztitemordertot,
     ZTITEMMATDLT,
     ZTITEMBNAME,
     ZTITEMISTV
     
     
     )
  
    select h3.zt_id,
           h3.zt_name,
           h3.zt_start_date,
           h3.zt_end_date,
           h3.stats_date,
           h3.ztcl_goodsnum,
           h3.ztdx_goodsnum,
           h3.ztpv,
           h3.ztuv,
           h3.ztavgcnt,
           h3.ztavgtime,
           h3.ztordercnt,
           h3.ztorderrs,
           h3.ztzhrate,
           h3.ztorderjs,
           h3.ztordertot,
           h3.ztitemcode,
           h3.ztitemname,
           h3.ztitemprice,
           h3.ztitempv,
           h3.ztitemuv,
           h3.ztitemordercnt,
           h3.ztitemorderjs,
           h3.ztitemordertot,
           h3.ztitemmatdlt,
           h3.ztitembname,
           h3.ztitemistv
      from ((select h1.zt_id,
                    h1.zt_name,
                    h1.zt_start_date,
                    h1.zt_end_date,
                    h1.stats_date,
                    h1.ztcl_goodsnum,
                    h1.ztdx_goodsnum,
                    h1.ztpv,
                    h1.ztuv,
                    h1.ztavgcnt,
                    h1.ztavgtime,
                    h1.ztordercnt,
                    h1.ztorderrs,
                    h1.ztzhrate,
                    h1.ztorderjs,
                    h1.ztordertot,
                    h1.ztitemcode,
                    h1.ztitemname,
                    h1.ztitemprice,
                    h1.ztitempv,
                    h1.ztitemuv,
                    h1.ztitemordercnt,
                    h1.ztitemorderjs,
                    h1.ztitemordertot,
                    h1.ztitemmatdlt,
                    h1.ztitembname,
                    h1.ztitemistv
                    
               from fact_daily_zt h1)
           
            union all
            (select x1.zt_id,
                    x1.zt_name,
                    x1.zt_start_date,
                    x1.zt_end_date,
                    x1.stats_date,
                    x1.ztcl_goodsnum,
                    x1.ztdx_goodsnum,
                    x1.ztpv,
                    x1.ztuv,
                    x1.ztavgcnt,
                    x1.ztavgtime,
                    x1.ztordercnt,
                    x1.ztorderrs,
                    x1.ztzhrate,
                    x1.ztorderjs,
                    x1.ztordertot,
                    x2.ztitemcode,
                    x2.ztitemname,
                    x2.ztitemprice,
                    x1.ztitempv,
                    x1.ztitemuv,
                    x1.ztitemordercnt,
                    x1.ztitemorderjs,
                    x1.ztitemordertot,
                    x1.ztitemmatdlt,
                    x1.ztitembname,
                    x1.ztitemistv
               from (select distinct m1.zt_type,
                                     m1.zt_id,
                                     m1.zt_name,
                                     m1.zt_start_date,
                                     m1.zt_end_date,
                                     m1.stats_date,
                                     m1.ztcl_goodsnum,
                                     m1.ztdx_goodsnum,
                                     m1.ztpv,
                                     m1.ztuv,
                                     m1.ztavgcnt,
                                     m1.ztavgtime,
                                     m1.ztordercnt,
                                     m1.ztorderrs,
                                     m1.ztzhrate,
                                     m1.ztorderjs,
                                     m1.ztordertot,
                                     0                as ztitempv,
                                     0                as ztitemuv,
                                     0                as ztitemordercnt,
                                     0                as ztitemorderjs,
                                     0                as ztitemordertot,
                                      m1.ztitemmatdlt,
                    m1.ztitembname,
                    m1.ztitemistv
                       from fact_daily_zt m1) x1,
                    (select k0.zttype,
                            k0.id,
                            (select o2.item_code
                               from dim_ec_good o2
                              where o2.goods_commonid = k0.goods_common_id) as ztitemcode,
                            (select o2.goods_name
                               from dim_ec_good o2
                              where o2.goods_commonid = k0.goods_common_id) as ztitemname,
                            (select o2.goods_price
                               from dim_ec_good o2
                              where o2.goods_commonid = k0.goods_common_id) as ztitemprice
                       from dim_zhuangti_goods k0
                      where not exists
                      (select *
                               from fact_ztgoods k1
                              where k1.zt_id = k0.id
                                and k1.zt_type_name = k0.zttype
                                and k1.goods_code = k0.goods_common_id)) x2
              where x1.zt_type = x2.zttype
                and x1.zt_id = x2.id)) h3;
  
  commit;*/
  insert into fact_daily_zhuangti
    (zt_id,
     zt_name,
     zt_start_date,
     zt_end_date,
     stats_date,
     ztcl_goodsnum,
     ztdx_goodsnum,
     ztpv,
     ztuv,
     ztavgcnt,
     ztavgtime,
     ztordercnt,
     ztorderrs,
     ztzhrate,
     ztorderjs,
     ztordertot,
     ztitemcode,
     ztitemname,
     ztitemprice,
     ztitempv,
     ztitemuv,
     ztitemordercnt,
     ztitemorderjs,
     ztitemordertot,
     ztitemmatdlt,
     ztitembname,
     ztitemistv
     
     )
  
    select h3.zt_id,
           h3.zt_name,
           h3.zt_start_date,
           h3.zt_end_date,
           h3.stats_date,
           h3.ztcl_goodsnum,
           h3.ztdx_goodsnum,
           h3.ztpv,
           h3.ztuv,
           h3.ztavgcnt,
           h3.ztavgtime,
           h3.ztordercnt,
           h3.ztorderrs,
           h3.ztzhrate,
           h3.ztorderjs,
           h3.ztordertot,
           h3.ztitemcode,
           h3.ztitemname,
           h3.ztitemprice,
           h3.ztitempv,
           h3.ztitemuv,
           h3.ztitemordercnt,
           h3.ztitemorderjs,
           h3.ztitemordertot,
           h3.ztitemmatdlt,
           h3.ztitembname,
           h3.ztitemistv
      from ((select h1.zt_id,
                    h1.zt_name,
                    h1.zt_start_date,
                    h1.zt_end_date,
                    h1.stats_date,
                    h1.ztcl_goodsnum,
                    h1.ztdx_goodsnum,
                    h1.ztpv,
                    h1.ztuv,
                    h1.ztavgcnt,
                    h1.ztavgtime,
                    h1.ztordercnt,
                    h1.ztorderrs,
                    h1.ztzhrate,
                    h1.ztorderjs,
                    h1.ztordertot,
                    h1.ztitemcode,
                    h1.ztitemname,
                    h1.ztitemprice,
                    h1.ztitempv,
                    h1.ztitemuv,
                    h1.ztitemordercnt,
                    h1.ztitemorderjs,
                    h1.ztitemordertot,
                    h1.ztitemmatdlt,
                    h1.ztitembname,
                    h1.ztitemistv
             
               from fact_daily_zt h1)
           
            union all
            (select x1.zt_id,
                    x1.zt_name,
                    x1.zt_start_date,
                    x1.zt_end_date,
                    x1.stats_date,
                    x1.ztcl_goodsnum,
                    x1.ztdx_goodsnum,
                    x1.ztpv,
                    x1.ztuv,
                    x1.ztavgcnt,
                    x1.ztavgtime,
                    x1.ztordercnt,
                    x1.ztorderrs,
                    x1.ztzhrate,
                    x1.ztorderjs,
                    x1.ztordertot,
                    x2.ztitemcode,
                    x2.ztitemname,
                    x2.ztitemprice,
                    x1.ztitempv,
                    x1.ztitemuv,
                    x1.ztitemordercnt,
                    x1.ztitemorderjs,
                    x1.ztitemordertot,
                    x2.ztitemmatdlt,
                    x2.ztitembname,
                    x2.ztitemistv
               from (select distinct m1.zt_type,
                                     m1.zt_id,
                                     m1.zt_name,
                                     m1.zt_start_date,
                                     m1.zt_end_date,
                                     m1.stats_date,
                                     m1.ztcl_goodsnum,
                                     m1.ztdx_goodsnum,
                                     m1.ztpv,
                                     m1.ztuv,
                                     m1.ztavgcnt,
                                     m1.ztavgtime,
                                     m1.ztordercnt,
                                     m1.ztorderrs,
                                     m1.ztzhrate,
                                     m1.ztorderjs,
                                     m1.ztordertot,
                                     0                as ztitempv,
                                     0                as ztitemuv,
                                     0                as ztitemordercnt,
                                     0                as ztitemorderjs,
                                     0                as ztitemordertot
                     
                       from fact_daily_zt m1) x1,
                    (select k0.zttype,
                            k0.id,
                            (select o2.item_code
                               from dim_ec_good o2
                              where o2.goods_commonid = k0.goods_common_id) as ztitemcode,
                            (select o2.goods_name
                               from dim_ec_good o2
                              where o2.goods_commonid = k0.goods_common_id) as ztitemname,
                            (select o2.goods_price
                               from dim_ec_good o2
                              where o2.goods_commonid = k0.goods_common_id) as ztitemprice,
                            (select o2.matdlt
                               from dim_ec_good o2
                              where o2.goods_commonid = k0.goods_common_id) as ztitemmatdlt,
                            (select nvl(o2.brand_name, 'unknown')
                               from dim_ec_good o2
                              where o2.goods_commonid = k0.goods_common_id) as ztitembname,
                            (select decode(o2.is_tv,
                                           0,
                                           '电商提报组',
                                           1,
                                           '非电商提报组')
                               from dim_ec_good o2
                              where o2.goods_commonid = k0.goods_common_id) as ztitemistv
                     
                       from dim_zhuangti_goods k0
                      where not exists
                      (select *
                               from fact_ztgoods k1
                              where k1.zt_id = k0.id
                                and k1.zt_type_name = k0.zttype
                                and k1.goods_code = k0.goods_common_id)) x2
              where x1.zt_type = x2.zttype
                and x1.zt_id = x2.id)) h3;

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
end processztdaily;
/

