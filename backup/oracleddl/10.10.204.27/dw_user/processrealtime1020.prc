???create or replace procedure dw_user.processrealtime1020(startpoint in number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processrealtime1020'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'top_realtime1020'; --此处需要手工录入该PROCEDURE操作的表格
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
    cnt1 number;
    cnt2 number;
  begin
    delete from top_realtime1020; 
    delete from top_alltime1020 where member_id!=474619;
  
    commit;
  
    select count(1)
      into cnt1
      from (select (select l.member_id
                      from fact_ecmember l
                     where l.member_crmbp = zz1.member_key
                       and rownum = 1) as member_id,
                   
                   zz1.goods_name,
                   zz1.goods_pay_price,
                   sysdate,
                   zz2.maxtime
              from (select yy2.member_key,
                           yy2.add_time_int,
                           yy3.goods_name,
                           sum(yy3.goods_pay_price) as goods_pay_price
                      from factec_order yy2, factec_order_goods yy3
                     where yy2.add_time = startpoint
                       and unix_to_oracle(yy2.add_time_int) between
                           to_date('2018-12-09 20:00:00',
                                   'yyyy-mm-dd hh24:mi:ss') and
                           to_date('2018-12-12 23:59:59',
                                   'yyyy-mm-dd hh24:mi:ss')
                       and yy2.order_id = yy3.order_id
                       and yy2.order_state >= 20
                       and yy3.goods_price > 0
                     group by yy2.member_key,
                              yy2.add_time_int,
                              yy3.goods_name) zz1,
                   (select yy2.member_key,
                           max(unix_to_oracle(yy2.add_time_int)) as maxtime
                      from factec_order yy2, factec_order_goods yy3
                     where yy2.add_time = startpoint
                       and unix_to_oracle(yy2.add_time_int) between
                           to_date('2018-12-09 20:00:00',
                                   'yyyy-mm-dd hh24:mi:ss') and
                           to_date('2018-12-12 23:59:59',
                                   'yyyy-mm-dd hh24:mi:ss')
                          
                       and yy2.order_id = yy3.order_id
                       and yy2.order_state >= 20
                     group by yy2.member_key) zz2
             where zz1.member_key = zz2.member_key
               and unix_to_oracle(zz1.add_time_int) = zz2.maxtime
             order by zz2.maxtime desc) ff;
  
    select real1020seq.nextval into cnt2 from dual;
  
    if cnt1 > 10
    
     then
    
      insert into tmp1019qiao
      
        select gg.member_id,
               gg.goods_name,
               gg.goods_pay_price,
               gg.realdate,
               gg.maxtime,
               real1020seq.nextval
          from (select (select l.member_id
                          from fact_ecmember l
                         where l.member_crmbp = zz1.member_key
                           and rownum = 1) as member_id,
                       
                       zz1.goods_name,
                       zz1.goods_pay_price,
                       sysdate             as realdate,
                       zz2.maxtime
                  from (select yy2.member_key,
                               yy2.add_time_int,
                               yy3.goods_name,
                               sum(yy3.goods_pay_price * yy3.goods_num) as goods_pay_price
                          from factec_order yy2, factec_order_goods yy3
                         where yy2.add_time = startpoint
                           and unix_to_oracle(yy2.add_time_int) between
                               to_date('2018-12-09 20:00:00',
                                       'yyyy-mm-dd hh24:mi:ss') and
                               to_date('2018-12-12 23:59:59',
                                       'yyyy-mm-dd hh24:mi:ss')
                           and yy2.order_id = yy3.order_id
                           and yy2.order_state >= 20
                           and yy2.order_from != '76'
                           and yy3.goods_price > 0
                         
                         group by yy2.member_key,
                                  yy2.add_time_int,
                                  yy3.goods_name) zz1,
                       (select yy2.member_key,
                               max(unix_to_oracle(yy2.add_time_int)) as maxtime
                          from factec_order yy2, factec_order_goods yy3
                         where yy2.add_time = startpoint
                           and unix_to_oracle(yy2.add_time_int) between
                               to_date('2018-12-09 20:00:00',
                                       'yyyy-mm-dd hh24:mi:ss') and
                               to_date('2018-12-12 23:59:59',
                                       'yyyy-mm-dd hh24:mi:ss')
                           and yy2.order_id = yy3.order_id
                           and yy2.order_state >= 20
                         
                         group by yy2.member_key) zz2
                 where zz1.member_key = zz2.member_key
                   and unix_to_oracle(zz1.add_time_int) = zz2.maxtime
                 order by zz2.maxtime desc) gg;
    
      commit;
    
      delete from tmp1019qiao where realseq < cnt2;
      commit;
    
    else
    
      update tmp1019qiao kk set kk.insert_date = sysdate;
      commit;
    
    end if;
  
    --select count(member_id) into cnt1 from  tmp1019qiao ;
    --select real1020seq.nextval into cnt2 from dual;
  
    insert into top_realtime1020
      select *
        from (select p3.member_id,
                  /*   (select xx.member_name
                        from dim_memid xx
                       where xx.member_id = p3.member_id
                         and rownum = 1),*/
                     p3.goods_name,
                     p3.total,
                     p3.insert_date
              
                from tmp1019qiao p3
              --(select p2.member_id, max(p2.total) as maxtot
              --   from tmp1019qiao p2
              --  group by p2.member_id) p5
              -- where --p3.member_id = p5.member_id
              --and p3.total = p5.maxtot
               order by p3.maxdate desc)
       where rownum <= 20;
  
    commit;
  
  
  
  
  
  
  
  
  
  
  
    
     insert into top_alltime1020
     
     --real1020seq ALLSEQ
       select jj.member_id, 
       -- (select xx.member_name from dim_memid xx where xx.member_id=jj.member_id and rownum=1), 
       jj.total, jj.realdate
       
         from (select (select l.member_id
                         from fact_ecmember l
                        where l.member_crmbp = yy1.member_key
                          and rownum = 1) as member_id,
                     sum(yy3.goods_num*yy3.goods_pay_price) as total,
                      sysdate as realdate
                 from factec_order yy1,factec_order_goods yy3
                where yy1.add_time between 20181209 and 20181212
                and unix_to_oracle(yy1.add_time_int) between
                               to_date('2018-12-09 20:00:00',
                                       'yyyy-mm-dd hh24:mi:ss') and
                               to_date('2018-12-12 23:59:59',
                                       'yyyy-mm-dd hh24:mi:ss')
                  and yy1.order_state >= 20
                  and yy1.order_from!='76'
                  and yy1.order_id=yy3.order_id
                group by yy1.member_key
                order by total desc) jj
                where rownum <= 19
        order by total desc;
     commit;
    
    --insert into top_alltime1020
    --select x.member_id, x.total, sysdate from tmp_fake x;
    -- commit;*/
  
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
end processrealtime1020;
/

