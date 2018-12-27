???create or replace procedure dw_user.processrealtime1019(startpoint in number) is
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

  --declare
  --s_date  date;

--begin

 delete from top_realtime1020 where member_id!=271575;
 delete from top_alltime1020 where member_id!=271575;
  --delete from tmp1018qiao;
  delete from  tmp1019qiao;
  
  commit;
  
 -- select sysdate into s_date from dual;
  
   insert into tmp1019qiao
             select
             (select l.member_id
                      from fact_ecmember l
                     where l.member_crmbp = zz1.member_key and rownum=1) as member_id,
             
             
              zz1.goods_name,zz1.goods_pay_price,sysdate,zz2.maxtime
                      from (select yy2.member_key,
                                   yy2.add_time_int,
                                   yy3.goods_name,
                                   sum(yy3.goods_pay_price) as  goods_pay_price
                              from factec_order yy2, factec_order_goods yy3
                             where yy2.add_time = startpoint
                               and yy2.order_id = yy3.order_id
                               and yy2.order_state >= 20
                               and yy3.goods_price>0
                            group by
                            yy2.member_key,
                                   yy2.add_time_int,
                                   yy3.goods_name
                            ) zz1,
                           (select yy2.member_key,
                                   max(unix_to_oracle(yy2.add_time_int)) as maxtime
                              from factec_order yy2, factec_order_goods yy3
                             where yy2.add_time = startpoint
                               and yy2.order_id = yy3.order_id
                               and yy2.order_state >= 20
                             group by yy2.member_key) zz2
                     where zz1.member_key = zz2.member_key
                       and unix_to_oracle(zz1.add_time_int) = zz2.maxtime
                       order by   zz2.maxtime desc;
                       
                         commit;
  
  
  /*insert into tmp1018qiao
    select *
      from (select (select l.member_id
                      from fact_ecmember l
                     where l.member_crmbp = pp1.member_key and rownum=1) as member_id,
                   pp2.goods_name,
                   pp1.total,
                   sysdate
              from (select yy1.member_key, sum(yy1.order_amount) as total
                      from factec_order yy1
                     where yy1.add_time = startpoint
                       and yy1.order_state >= 20
                     group by yy1.member_key) pp1,
                   
                   (select distinct zz1.member_key, zz1.goods_name
                      from (select yy2.member_key,
                                   yy2.add_time_int,
                                   yy3.goods_name
                              from factec_order yy2, factec_order_goods yy3
                             where yy2.add_time = startpoint
                               and yy2.order_id = yy3.order_id
                               and yy2.order_state >= 20
                            
                            ) zz1,
                           (select yy2.member_key,
                                   max(unix_to_oracle(yy2.add_time_int)) as maxtime
                              from factec_order yy2, factec_order_goods yy3
                             where yy2.add_time = startpoint
                               and yy2.order_id = yy3.order_id
                               and yy2.order_state >= 20
                             group by yy2.member_key) zz2
                     where zz1.member_key = zz2.member_key
                       and unix_to_oracle(zz1.add_time_int) = zz2.maxtime) pp2
             where pp1.member_key = pp2.member_key
             order by pp1.total desc); --where rownum<=10;

  commit;*/

  /*delete from tmp1018qiao
   where (member_id) in (select member_id
                           from tmp1018qiao
                          group by member_id
                         having count(member_id) > 1)
     and rowid not in (select min(rowid)
                         from tmp1018qiao
                        group by member_id
                       having count(*) > 1);
  commit;*/

  insert into top_realtime1020
   select * from
                       (select  p3.member_id,p3.goods_name,p3.total,p3.insert_date from  tmp1019qiao p3,
                       (select p2.member_id,max(p2.total) as maxtot from  tmp1019qiao p2
                       group by p2.member_id) p5
                       where p3.member_id=p5.member_id
                       and   p3.total=p5.maxtot
                       order by p3.maxdate desc) where rownum<=30;
  
  
    /*select *
      from (select * from tmp1018qiao order by total desc)
     where rownum <= 10;*/
  commit;

  --delete from  top_realtime1020 oo where oo.sysdate<s_date ;
  
  --commit;

  insert into top_alltime1020
  
    select *
      from (select (select l.member_id
                      from fact_ecmember l
                     where l.member_crmbp = yy1.member_key  and rownum=1) as member_id,
                   sum(yy1.order_amount) as total,
                   sysdate
              from factec_order yy1
             where yy1.add_time between 20181018 and 20181021
               and yy1.order_state >= 20
             group by yy1.member_key
             order by total desc)
     order by total desc;
  commit;
  
   insert into top_alltime1020
  select x.member_id,x.total,sysdate from  tmp_fake x ;
  commit;
  
  --delete from  top_alltime1020 oo2 where oo2.sysdate<s_date ;
-- commit;
--end;
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
end processrealtime1019;
/

