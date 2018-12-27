???create or replace procedure dw_user.processhmscstat(startpoint in number) is
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
  sp_name          := 'processhmscstat'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_daily_hmscstat'; --此处需要手工录入该PROCEDURE操作的表格
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

  begin
    delete from tmp_0529;
    delete from tmp_hmsc_uv;
    delete from tmp_hmsc_od;
    commit;
  
    insert into tmp_0529
      select distinct h1.vid, h1.member_key
        from fact_session h1
       where h1.start_date_key = startpoint
         and h1.application_key in (10, 20);
    commit;
  
    insert into tmp_hmsc_uv
      select distinct t.hmsc,
                      count(distinct t.vid) over(partition by t.hmsc) as rihuo,
                      count(distinct(case
                                       when t.nvflag = 1 then
                                        t.vid
                                     end)) over(partition by t.hmsc) as xzuv,
                      count(distinct(case
                                       when t.nbflag = 1 then
                                        t.vid
                                     end)) over(partition by t.hmsc) as zcrs
        from (select
              
               (select h2.hmsc
                  from fact_visitor_register h2
                 where h2.vid = h1.vid) as hmsc,
               h1.vid,
               case
                 when exists (select *
                         from fact_visitor_register h3
                        where h3.create_date_key = startpoint
                          and h3.vid = h1.vid) then
                  1
                 else
                  0
               end as nvflag,
               
               case
                 when h1.member_key != 0 and exists
                  (select *
                         from fact_ecmember h5
                        where h5.member_time = startpoint
                          and h5.member_crmbp = h1.member_key) then
                  1
                 else
                  0
               end as nbflag
              
                from tmp_0529 h1) t;
  
    commit;
  
    insert into tmp_hmsc_od
      select y.hmsc,
             sum(y.goods_pay_price * y.goods_num) as tot,
             sum(y.goods_num) as nums,
             count(distinct y.cust_no) as cnt
        from (select (select h2.hmsc
                        from fact_visitor_register h2
                       where h2.vid = p3.vid) as hmsc,
                     p3.goods_pay_price,
                     p3.goods_num,
                     p3.cust_no
                from order_good p3
               where p3.add_time = startpoint
                 and p3.iscg = 1
                 and p3.app_name in ('KLGiPhone', 'KLGAndroid')) y
       group by y.hmsc;
    commit;
  
    insert into fact_daily_hmscstat
      select startpoint as date_key,
             a1.hmsc,
             a1.rihuo,
             a1.xzuv,
             a1.zcrs,
             nvl(a2.tot, 0) as tot,
             nvl(a2.nums, 0) as nums,
             nvl(a2.cnt, 0) as cnt
        from tmp_hmsc_uv a1, tmp_hmsc_od a2
       where a1.hmsc = a2.hmsc(+);
    commit;
  
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
  
end processhmscstat;
/

