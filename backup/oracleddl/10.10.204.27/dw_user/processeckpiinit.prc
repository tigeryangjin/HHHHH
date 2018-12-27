???create or replace procedure dw_user.processeckpiinit is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'process_ec_kpi'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'KPI_EC_TBL'; --此处需要手工录入该PROCEDURE操作的表格
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
  
    type type_array is table of tmp_date%rowtype index by binary_integer; --类似二维数组 
    var_array            type_array;
    d_startpoint varchar2(20);
    d_endpoint   varchar2(20);
    w_startpoint varchar2(20);
    w_endpoint   varchar2(20);

begin
  
 select * bulk collect
      into var_array
      from tmp_date e  order by e.datekey;
    
--select to_char(sysdate-1, 'yyyymmdd') as d_startpoint, to_char(sysdate, 'yyyymmdd') as d_endpoint, to_char(sysdate-7, 'yyyymmdd') as w_startpoint, to_char(sysdate, 'yyyymmdd') as w_endpoint 

for i in 1 .. var_array.count loop
  
d_startpoint:=to_char(var_array(i).datekey-1,'yyyymmdd');
d_endpoint:=to_char(var_array(i).datekey,'yyyymmdd');
w_startpoint:=to_char(var_array(i).datekey-7,'yyyymmdd');
w_endpoint:=to_char(var_array(i).datekey,'yyyymmdd');

insert into kpi_ec_tbl
    select w_kpi_d_s.nextval,
           '01',
           '新媒体中心',
           '0101',
           '新媒体',
           '01010019',
           '自营SKU数(在架)',
           d_startpoint,
           d_endpoint,
           0.00,
           0.00,
           hh2.zysku,
           '1508833',
           'D',
           'Y',
           '',
           sysdate
      from (select count(distinct hh1.item_code) as zysku
              from fact_daily_goodzaijia hh1
             where to_char(hh1.insert_date, 'yyyymmdd') >= d_startpoint
               and to_char(hh1.insert_date, 'yyyymmdd') < d_endpoint
               and hh1.store_id = 1 and hh1.is_tv!='非电商提报组') hh2;
  commit;

  insert into kpi_ec_tbl
    select w_kpi_d_s.nextval,
           '01',
           '新媒体中心',
           '0101',
           '新媒体',
           '01010019',
           '自营SKU数(在架)',
           w_startpoint,
           w_endpoint,
           0.00,
           0.00,
           hh2.zysku,
           '1508833',
           'W',
           'Y',
           '',
           sysdate
      from (select count(distinct hh1.item_code) as zysku
              from fact_daily_goodzaijia hh1
             where to_char(hh1.insert_date, 'yyyymmdd') >= w_startpoint
               and to_char(hh1.insert_date, 'yyyymmdd') < w_endpoint
               and hh1.store_id = 1 and hh1.is_tv!='非电商提报组') hh2;
  commit;





 insert into kpi_ec_tbl
  
    select w_kpi_d_s.nextval, x1.*
      from (select '01' as deno,
                   '新媒体中心' as dept,
                   '0101' as deno_1,
                   '新媒体' as dept_1,
                   '01010021' as item_no,
                   '自营新品上架数' as item,
                   d_startpoint as b_date,
                   d_endpoint as e_date,
                   0.00 as item_value1,
                   0.00 as item_value2,
                   count(1) as item_value3,
                   '1508833' as insert_id,
                   'D' as item_type,
                   'Y' as data_type,
                   '' as note,
                   sysdate
              from fact_daily_goodzaijia n
             where to_char(n.goods_addtime, 'yyyymmdd') >= d_startpoint
               and to_char(n.goods_addtime, 'yyyymmdd') < d_endpoint
               and store_id = 1 and is_tv!='非电商提报组') x1;
  commit;

insert into kpi_ec_tbl
  
    select w_kpi_d_s.nextval, x1.*
      from (select '01' as deno,
                   '新媒体中心' as dept,
                   '0101' as deno_1,
                   '新媒体' as dept_1,
                   '01010021' as item_no,
                   '自营新品上架数' as item,
                   w_startpoint as b_date,
                   w_endpoint as e_date,
                   0.00 as item_value1,
                   0.00 as item_value2,
                   count(distinct n.item_code) as item_value3,
                   '1508833' as insert_id,
                   'W' as item_type,
                   'Y' as data_type,
                   '' as note,
                   sysdate
              from fact_daily_goodzaijia n
             where to_char(n.goods_addtime, 'yyyymmdd') >= w_startpoint
               and to_char(n.goods_addtime, 'yyyymmdd') < w_endpoint
               and store_id = 1 and is_tv!='非电商提报组') x1;
  commit;






insert into kpi_ec_tbl
    select w_kpi_d_s.nextval,
           '01',
           '新媒体中心',
           '0101',
           '新媒体',
           '01010022',
           '自营新品周动销率',
           w_startpoint,
           w_endpoint,
           xx.dx,
           yy.sj,
           trunc((xx.dx / yy.sj), 2),
           '1508833',
           'W',
           'Y',
           '',
           sysdate
      from (select count(distinct n6.item_code) as dx,
                   to_number(w_startpoint) as date_key
              from order_good n6
             where to_char(n6.addtime, 'yyyymmdd') >=
                   to_number(w_startpoint)
               and to_char(n6.addtime, 'yyyymmdd') < to_number(w_endpoint)
               and n6.iscg = 1
               and exists (select n.*
                      from fact_daily_goodzaijia n
                     where to_char(n.goods_addtime, 'yyyymmdd') >=
                           to_number(w_startpoint)
                       and to_char(n.goods_addtime, 'yyyymmdd') <
                           to_number(w_endpoint)
                       and store_id = 1 and is_tv!='非电商提报组'
                       and n.item_code = n6.item_code)) xx,
           
           (select count(distinct n.item_code) as sj,
                   to_number(w_startpoint) as date_key
              from fact_daily_goodzaijia n
             where to_char(n.goods_addtime, 'yyyymmdd') >=
                   to_number(w_startpoint)
               and to_char(n.goods_addtime, 'yyyymmdd') <
                   to_number(w_endpoint)
               and store_id = 1 and is_tv!='非电商提报组') yy
     where xx.date_key = yy.date_key;
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
end processeckpiinit;
/

