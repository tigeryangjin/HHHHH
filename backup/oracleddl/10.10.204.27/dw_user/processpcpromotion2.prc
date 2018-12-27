???create or replace procedure dw_user.processpcpromotion2 is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;
  --startpoint  number;
  -- endpoint    fact_page_view.id%type;
  /*
  功能说明：调度对SBI层W_SESSION_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-12
  */
begin
  sp_name          := 'processpcpromotion2'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_daily_pcpromotion_3'; --此处需要手工录入该PROCEDURE操作的表格
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

  declare
  
    type type_array is table of dim_date%rowtype index by binary_integer; --类似二维数组 
  
    var_array type_array;
  
  begin
  
    select * bulk collect
      into var_array
      from dim_date
     where date_key between 20170101 and 20170630
     order by date_key;
  
    for i in 1 .. var_array.count loop
    
      delete from fact_pc_promotion;
      delete from fact_pc_prosesion;
      delete from fact_pc_proorder;
      commit;
    
      insert into fact_pc_promotion
        (vid, maxdate, level1, level2, keyword, plan, adgroup)
        select y1.vid,
               y1.maxdate,
               y1.level1,
               y1.level2,
               y1.keyword,
               y1.plan,
               y1.adgroup
          from (select vid,
                       level1,
                       level2,
                       keyword,
                       plan,
                       adgroup,
                       max(active_date) as maxdate
                  from fact_visitor_active
                 where active_date_key between
                       to_number(to_char(add_months(to_date(to_char(var_array(i)
                                                                    .date_key),
                                                            'yyyymmdd'),
                                                    -1),
                                         'yyyymmdd')) and var_array(i)
                      .date_key
                   and application_key = 40
                   and level1 in ('SEM', 'DSP', 'CPS')
                 group by vid, level1, level2, keyword, plan, adgroup) y1;
      --  (select *
      --   from fact_visitor_active
      --where active_date_key = startpoint
      --and application_key = 40
      --and level1 in ('SEM', 'DSP', 'CPS')) y2
    
      commit;
    
      /*
      更新FACT_PC_PROMOTION表的FIRST_DATE、FIRST_LEVEL2字段，记录首次进入时间和渠道
      yangjin 2017-05-22
      */
      update fact_pc_promotion a
         set (a.first_date, a.first_level2) =
             (select c.maxdate, c.level2
                from fact_pc_promotion c
               where exists (select 1
                        from (select b.vid, min(b.maxdate) first_date
                                from fact_pc_promotion b
                               group by b.vid) d
                       where c.vid = d.vid
                         and c.maxdate = d.first_date)
                 and a.vid = c.vid)
       where exists
       (select 1
                from fact_pc_promotion e
               where exists (select 1
                        from (select g.vid, min(g.maxdate) first_date
                                from fact_pc_promotion g
                               group by g.vid) f
                       where e.vid = f.vid
                         and e.maxdate = f.first_date)
                 and a.vid = e.vid)
         and a.first_date is null;
      commit;
    
      insert into fact_pc_prosesion
        (start_date_key, vid, scount, pagetotal, timetoal)
        select start_date_key,
               vid,
               count(session_key) as scount,
               sum(page_count) as pagetotal,
               sum(life_time) as timetoal
          from fact_session
         where start_date_key = var_array(i).date_key
           and application_key = 40
         group by start_date_key, vid;
      commit;
    
      insert into fact_pc_proorder
        (add_time,
         vid,
         item_code,
         goods_name,
         goods_commonid,
         goods_price,
         js,
         je,
         cgjs,
         cgje)
        select z1.add_time,
               (case
                 when z1.vid like 'webportal%' then
                  z1.vid
                 else
                  'webportal' || z1.vid
               end) as vid,
               --z1.vid,
               z1.item_code,
               z1.goods_name,
               z1.goods_commonid,
               (select z2.goods_price
                  from dim_ec_good z2
                 where z2.goods_commonid = z1.goods_commonid) as goods_price,
               nvl(sum(z1.goods_num), 0) as js,
               nvl(sum(z1.goods_pay_price * z1.goods_num), 0) je,
               nvl(sum(case
                         when z1.iscg = 1 then
                          z1.goods_num
                       end),
                   0) as cgjs,
               nvl(sum(case
                         when z1.iscg = 1 then
                          z1.goods_pay_price * z1.goods_num
                       end),
                   0) as cgje
          from order_good z1
         where add_time = var_array(i).date_key
           and app_name = 'KLGPortal'
         group by z1.add_time,
                  z1.vid,
                  z1.item_code,
                  z1.goods_name,
                  z1.goods_commonid;
      commit;
    
      insert into fact_daily_pcpromotion_3
        (active_date_key,
         vid,
         member_key,
         member_date,
         level1,
         level2,
         plan,
         adgroup,
         keyword,
         mindate,
         scount,
         pagetotal,
         timetoal,
         goods_name,
         goods_price,
         js,
         je,
         cgjs,
         cgje,
         first_date,
         first_level2,
         item_code)
      
        select m2.start_date_key,
               m1.vid,
               nvl((select c2.member_key
                     from dim_vid_mem c2
                    where c2.vid = m1.vid
                      and rownum = 1),
                   0),
               (select nvl(max(k1.member_time), 0)
                  from fact_ecmember k1
                 where k1.member_crmbp = nvl((select c2.member_key
                                               from dim_vid_mem c2
                                              where c2.vid = m1.vid
                                                and rownum = 1),
                                             -1)
                
                ),
               m1.level1,
               m1.level2,
               m1.plan,
               m1.adgroup,
               m1.keyword,
               m1.maxdate,
               m2.scount,
               m2.pagetotal,
               m2.timetoal,
               m3.goods_name,
               m3.goods_price,
               m3.js,
               m3.je,
               m3.cgjs,
               m3.cgje,
               /*第一次进入时间和渠道 yangjin 2017-05-23*/
               m1.first_date,
               m1.first_level2,
               m3.item_code
          from fact_pc_promotion m1,
               fact_pc_prosesion m2,
               fact_pc_proorder  m3
         where m2.start_date_key = var_array(i).date_key
           and m1.vid = m2.vid
           and m2.start_date_key = m3.add_time(+)
           and m2.vid = m3.vid(+);
    
      commit;
    
      update fact_daily_pcpromotion_3
         set member_date = to_number(to_char((to_date(var_array(i).date_key,
                                                      'yyyymmdd') - 7),
                                             'yyyymmdd'))
       where active_date_key = var_array(i).date_key
         and member_key != 0
         and member_date = 0;
      commit;
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
  
end processpcpromotion2;
/

