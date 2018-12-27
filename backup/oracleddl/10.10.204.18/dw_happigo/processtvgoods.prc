???create or replace procedure dw_happigo.processtvgoods is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;
  -- s_startpoint fact_session.id%type;
  --s_endpoint   fact_session.id%type;
  /*
  功能说明：调度对SBI层W_SESSION_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-12
  */
begin
  sp_name          := 'processtvgoods'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'static_ecgoods'; --此处需要手工录入该PROCEDURE操作的表格
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
    --  i  date;
    --  i1 varchar2(100);
    type type_array is table of dim_tvlive%rowtype index by binary_integer; --类似二维数组 
  
    var_array type_array;
  
  begin
  
    select * bulk collect
      into var_array
      from dim_tvlive
     where start_date>=20151204-- < to_number(to_char(sysdate, 'yyyymmdd'))
     order by tv_start_time;
  --stat_date_key>=20151114
    for k in 1 .. var_array.count loop
    
      insert into static_ecgoods
        (stat_date_key,
         stat_duration,
         livegoods,
         uvgoods,
         is_tv,
         tguv,
         ftguv,
         uv,
         cnt,
         tot,
         cgcnt,
         cgtot,
         zhrate
         
         )
      
        select var_array(k).start_date,
               to_char(to_date(var_array(k).tv_start_time,
                               'yyyy-mm-dd hh24:mi:ss'),
                       'hh24:mi') || '-' ||
               to_char(to_date(var_array(k).tv_end_time,
                               'yyyy-mm-dd hh24:mi:ss'),
                       'hh24:mi'),
               var_array(k).tv_name,
               yy.goods_name,
               decode(yy.is_tv, 1, 'TV商品', '新媒体自营商品') as is_tv,
               yy.tguv,
               yy.ftguv,
               yy.uv,
               yy.cnt,
               yy.tot,
               yy.cgcnt,
               yy.cgtot,
               trunc((yy.cgcnt / yy.uv), 2) as zhrate
          from (select x1.page_value as goods_commonid,
                       (select l.goods_name
                          from dim_ec_good l
                         where l.goods_commonid = to_number(x1.page_value)) as goods_name,
                       (select l.is_tv
                          from dim_ec_good l
                         where l.goods_commonid = to_number(x1.page_value)) as is_tv,
                       nvl(x1.tguv, 0) as tguv,
                       nvl(x1.ftguv, 0) as ftguv,
                       nvl(x1.uv, 0) as uv,
                       nvl(x2.cnt, 0) as cnt,
                       nvl(x2.tot, 0) as tot,
                       nvl(x2.cgcnt, 0) as cgcnt,
                       nvl(x2.cgtot, 0) as cgtot
                  from (select to_number(case
                                           when regexp_like(page_value, '.([a-z]+|[A-Z])') then
                                            '0'
                                           when regexp_like(page_value, '[[:punct:]]+') then
                                            '0'
                                           else
                                            page_value
                                         end) as page_value,
                               count(distinct(case
                                                when exists
                                                 (select *
                                                        from (select z01.hmsc_key from dim_hmsc z01 where z01.hmpl = '推广') z1
                                                       where z1.hmsc_key = z0.hmsc_key) then
                                                 z0.visitor_key
                                              end)) as tguv,
                               count(distinct(case
                                                when not exists
                                                 (select *
                                                        from (select z01.hmsc_key from dim_hmsc z01 where z01.hmpl = '推广') z1
                                                       where z1.hmsc_key = z0.hmsc_key) then
                                                 z0.visitor_key
                                              end)) as ftguv,
                               count(distinct z0.visitor_key) as uv
                          from fact_page_view z0
                         where z0.visit_date >=
                               to_date(var_array(k).tv_start_time,
                                       'yyyy-mm-dd hh24:mi:ss')
                           and z0.visit_date <=
                               to_date(var_array(k).tv_end_time,
                                       'yyyy-mm-dd hh24:mi:ss')
                           and z0.application_key in (10, 20)
                           and z0.page_name = 'Good'
                         group by z0.page_value) x1,
                       (select z00.goods_commonid,
                               z00.goods_name,
                               z00.is_tv,
                               nvl(count(z00.order_id), 0) as cnt,
                               nvl(sum(z00.goods_pay_price * z00.goods_num),
                                   0) as tot,
                               nvl(count(case
                                           when z00.iscg = 1 then
                                            z00.order_id
                                         end),
                                   0) as cgcnt,
                               nvl(sum(case
                                         when z00.iscg = 1 then
                                          z00.goods_pay_price * z00.goods_num
                                       end),
                                   0) as cgtot
                        
                          from order_good z00
                         where to_date(z00.addtime, 'yyyy-mm-dd hh24:mi:ss') >=
                               to_date(var_array(k).tv_start_time,
                                       'yyyy-mm-dd hh24:mi:ss')
                           and to_date(z00.addtime, 'yyyy-mm-dd hh24:mi:ss') <=
                               to_date(var_array(k).tv_end_time,
                                       'yyyy-mm-dd hh24:mi:ss')
                         group by z00.goods_commonid,
                                  z00.goods_name,
                                  z00.is_tv) x2
                 where x1.page_value = x2.goods_commonid(+)) yy
         where yy.goods_name is not null;
    
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
  
end processtvgoods;
/

