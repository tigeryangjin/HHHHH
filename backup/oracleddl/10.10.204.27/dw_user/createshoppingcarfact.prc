???create or replace procedure dw_user.createshoppingcarfact(startpoint in ods_shoppingcar.id%type,
                                                  endpoint   in ods_shoppingcar.id%type) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'createshoppingcarfact'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_shoppingcar'; --此处需要手工录入该PROCEDURE操作的表格
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

  insert into fact_shoppingcar
    (id,
     shoppingcar_key,
     application_key,
     application_name,
     vid,
     member_key,
     page_key,
     page_name,
     url,
     ip,
     create_date,
     scgid,
     scgq,
     visitor_key,
     create_date_key,
     ip_geo_key
     
     )
  
    select id,
           id as shoppingcar_key,
           0 as application_key,
           nvl(a, 'unknown') as application_name,
           nvl(vid, 'unknown') as vid,
           to_number(case
                       when regexp_like(mid, '.([a-z]+|[A-Z])') then
                        '0'
                       when regexp_like(mid, '[[:punct:]]+') then
                        '0'
                       when mid is null then
                        '0'
                       when mid like '%null%' then
                        '0'
                       else
                        regexp_replace(mid, '\s', '')
                     end) as member_key,
           0 as page_key,
           nvl(p, 'unknown') as page_name,
           url,
           ip,
           createon as create_date,
           scgid,
           scgq,
           0 as visitor_key,
           to_number(to_char(createon, 'yyyymmdd')) as create_date_key,
           0 as ip_geo_key
      from ods_shoppingcar
     where id between startpoint and endpoint
       and isprocessed = 0;

  insert_rows := sql%rowcount;
  commit;

  update fact_shoppingcar aa
     set aa.visitor_key =
         (select k.vistor_key from fact_visitor_register k where k.vid = aa.vid)
   where aa.id between startpoint and endpoint;

  update fact_shoppingcar c
     set c.application_key =
         (select d.application_key
            from dim_application d
           where d.application_name = c.application_name)
   where c.id between startpoint and endpoint;

  commit;

  update fact_shoppingcar d
     set d.page_key =
         (select e.page_key
            from dim_page e
           where e.page_name = d.page_name
             and e.application_key = d.application_key)
   where d.id between startpoint and endpoint;

  commit;

  update ods_shoppingcar
     set isprocessed = 1
   where id between startpoint and endpoint;

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
end createshoppingcarfact;
/

