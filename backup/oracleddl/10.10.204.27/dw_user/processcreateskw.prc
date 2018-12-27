???create or replace procedure dw_user.processcreateskw(startpoint in number,start_date in date) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processcreateskw'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'search_hit_analysis'; --此处需要手工录入该PROCEDURE操作的表格
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

  insert into search_hit_analysis
    select w_shhit_seq.nextval, h2.*
      from (select skw as keyword,
                   h1.cnt as search_times,
                   -1 as hit_times,
                   0 as status,
                   '' as remark,
                   start_date as create_time,
                   startpoint as create_date_key, -- to_number(to_char(SYSDATE,'yyyymmdd'))
                   start_date as modify_time,
                   startpoint as modify_date_key
              from (select skw, count(id) as cnt
                      from fact_search k1
                     where create_date between
                           to_date(to_char(to_date(to_char(start_date,
                                                           'yyyy-mm-dd'),
                                                   'yyyy-mm-dd') - 48 / 24,
                                           'yyyy-mm-dd hh24:mi:ss'),
                                   'yyyy-mm-dd hh24:mi:ss') and
                           to_date(to_char(start_date, 'yyyy-mm-dd'),
                                   'yyyy-mm-dd')
                    -- and not exists  (select * from search_hit_analysis k2 where k2.keyword=k1.skw)
                    
                     group by skw
                    having count(id) >= 3) h1
             order by cnt desc) h2;

  insert_rows := sql%rowcount;
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
end processcreateskw;
/

