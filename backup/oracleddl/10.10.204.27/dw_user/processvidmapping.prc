???create or replace procedure dw_user.processvidmapping is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processvidmapping'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'dim_vid_mapping'; --此处需要手工录入该PROCEDURE操作的表格
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
  --= '00000000';
  -- delete from tmp_0119 ;
  -- delete from tmp_wx_3g; 
  -- commit;

  insert into tmp_wx_3g
    select w.ip,
           w.agent,
           min(w.visit_date) as min_date,
           min(w.visit_date) + 30 / 24 / 60 as max_date,
           count(distinct w.application_key) as cnt,
           min(w.visit_date_key) as visit_date_key
      from fact_page_view w
     where w.visit_date_key = to_number(to_char((sysdate - 1), 'yyyymmdd'))
       and w.application_key in (50, 30)
     group by w.ip, w.agent
    having count(distinct w.application_key) > 1;

  declare
  
    type type_array is table of tmp_wx_3g%rowtype index by binary_integer; --类似二维数组 
    -- type type_array is table of tmp_20180123%rowtype index by binary_integer; --类似二维数组 
    var_array type_array;
    cnt       number;
  begin
  
    select * bulk collect
      into var_array
      from tmp_wx_3g e
     where e.date_key = to_number(to_char((sysdate - 1), 'yyyymmdd'))
     order by e.date_key;
  
    for i in 1 .. var_array.count loop
    
      /* insert into tmp_app_3g
        select w.ip,
               w.agent,
               min(w.visit_date) as min_date,
               min(w.visit_date) + 30 / 24 / 60 as max_date,
               count(distinct w.application_key) as cnt,
               min(w.visit_date_key) as visit_date_key
          from fact_page_view w
         where w.visit_date_key = var_array(i).date_key
           and w.application_key in (10,20,30)
         group by w.ip, w.agent
        having count(distinct w.application_key) > 1;
      
      commit;*/
    
      select /*+ index(w FPV_DATETIME) */
       count(distinct application_key)
        into cnt
        from fact_page_view w
       where /*w.visit_date_key=var_array(i).date_key and */
       w.visit_date between var_array(i).min_date and var_array(i).max_date
       and w.ip = var_array(i).ip
       and w.agent = var_array(i).agent;
    
      if cnt > 1 then
        insert into dim_vid_mapping
        
          select w_vid_map_seq.nextval,
                 zz.ggvid,
                 zz.wxvid,
                 '',
                 var_array(i).date_key
            from (select z.ggvid, z.wxvid
                    from (select y.vid as ggvid, x.vid as wxvid
                            from (select /*+ index(w FPV_DATETIME) */
                                   vid, visit_date_key
                                    from fact_page_view w
                                   where w.visit_date between var_array(i)
                                        .min_date and var_array(i).max_date
                                     and w.ip = var_array(i).ip
                                     and w.application_key = 50
                                     and w.agent = var_array(i).agent
                                     and rownum = 1) x,
                                 
                                 (select /*+ index(w FPV_DATETIME) */
                                   vid, visit_date_key
                                    from fact_page_view w
                                   where w.visit_date between var_array(i)
                                        .min_date and var_array(i).max_date
                                     and w.ip = var_array(i).ip
                                     and w.application_key = 30
                                     and w.agent = var_array(i).agent
                                     and rownum = 1) y
                           where x.visit_date_key = y.visit_date_key) z
                   where not exists (select *
                            from dim_vid_mapping k
                           where k.gvid = z.ggvid
                             and k.wxvid = z.wxvid)) zz;
      
      end if;
    
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
end processvidmapping;
/

