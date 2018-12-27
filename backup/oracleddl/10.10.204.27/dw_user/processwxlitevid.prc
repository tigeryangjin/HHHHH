???create or replace procedure dw_user.processwxlitevid(startpoint in number,
                                             endpoint   in number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;
  -- startpoint  fact_page_view.id%type;
  -- endpoint    fact_page_view.id%type;
  /*
  功能说明：调度对SBI层W_SESSION_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-12
  */
begin
  sp_name          := 'processwxlitevid'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'fact_page_view'; --此处需要手工录入该PROCEDURE操作的表格
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

  delete from tmp_0419;
  delete from fact_page_view_tmp;
  commit;

  insert into fact_page_view_tmp
    select *
      from fact_page_view a
     where a.visit_date_key between startpoint and endpoint
       and a.application_key = 70
       and (a.vid = 'wxlitemall' or a.vid='wxlitebargain');
  commit;

  declare
  
    type type_array is table of fact_page_view_tmp%rowtype index by binary_integer; --类似二维数组 
  
    var_array  type_array;
    count_key  number;
    count_key2 number;
    s_vid      varchar2(100);
    random_vid varchar2(100);
    s_key      number;
    min_id     number;
    max_id     number;
  begin
  
    select * bulk collect
      into var_array
      from fact_page_view_tmp
     order by id asc;
  
    select min(id), max(id) into min_id, max_id from fact_page_view_tmp;
  
    for i in 1 .. var_array.count loop
    
      select count(b.id)
        into count_key
        from fact_page_view b
       where b.visit_date_key = var_array(i).visit_date_key
         and b.visit_date between var_array(i).visit_date and var_array(i)
            .visit_date + 1800 / 86400
         and b.application_key = var_array(i).application_key
         and b.ip = var_array(i).ip
         and b.agent = var_array(i).agent
         and length(b.vid) > 13;
    
      select count(b.id)
        into count_key2
        from fact_page_view b
       where b.visit_date_key = var_array(i).visit_date_key
         and b.visit_date between var_array(i).visit_date and var_array(i)
            .visit_date + 1800 / 86400
         and b.application_key = var_array(i).application_key
         and b.ip = var_array(i).ip
         and b.agent = var_array(i).agent
         and exists (select *
                from tmp_0419 x
               where x.ip = b.ip
                 and x.agent = b.agent);
    
      if count_key = 0 then
        if count_key2 = 0 then
          select dbms_random.string('u', 10) ||
                 trunc(dbms_random.value(1, 100))
            into random_vid
            from dual;
        
          update fact_page_view b
             set b.vid = random_vid
           where b.id = var_array(i).id;
        
          update fact_page_view b
             set b.vid = random_vid
           where b.visit_date_key = var_array(i).visit_date_key
             and b.visit_date between var_array(i).visit_date and var_array(i)
                .visit_date + 1800 / 86400
             and b.application_key = var_array(i).application_key
             and b.ip = var_array(i).ip
             and b.agent = var_array(i).agent;
        
          insert into tmp_0419
          values
            (var_array(i).ip, var_array(i).agent);
        
          commit;
        
        else
        
          update fact_page_view b
             set b.vid = b.vid
           where b.id = var_array(i).id;
          commit;
        
        end if;
      
      else
      
        select b.vid, b.session_key
          into s_vid, s_key
          from fact_page_view b
         where b.visit_date_key = var_array(i).visit_date_key
           and b.visit_date between var_array(i).visit_date and var_array(i)
              .visit_date + 1800 / 86400
           and b.application_key = var_array(i).application_key
           and b.ip = var_array(i).ip
           and b.agent = var_array(i).agent
           and length(b.vid) > 13
           and rownum = 1;
      
        update fact_page_view b
           set b.vid = s_vid, b.session_key = s_key
         where b.id = var_array(i).id;
      
        /*  update fact_page_view b1
          set b1.session_key = var_array(i).session_key
        where b1.visit_date_key = var_array(i).visit_date_key
          and b1.visit_date between var_array(i).visit_date and var_array(i)
             .visit_date + 1800 / 86400
          and b1.application_key = var_array(i).application_key
          and b1.ip = var_array(i).ip
          and b1.agent = var_array(i).agent
          and length(b1.vid) > 10;*/
        commit;
      
      end if;
    
    end loop;
  
    update fact_page_view k1
       set k1.vid =
           (select k2.vid
              from fact_page_view k2
             where k2.visit_date_key between startpoint and endpoint
                  -- to_number(to_char((sysdate - 2), 'yyyymmdd'))
               and k2.application_key = 70
               and k2.ip = k1.ip
               and k2.agent = k1.agent
               and k2.vid != 'wxlitemall'
               and rownum = 1)
     where k1.visit_date_key between startpoint and endpoint
       and k1.id between min_id and max_id
          --to_number(to_char((sysdate - 2), 'yyyymmdd'))
       and k1.vid = 'wxlitemall';
  
    commit;
  
  update fact_page_view k1
       set k1.vid =
           (select k2.vid
              from fact_page_view k2
             where k2.visit_date_key between startpoint and endpoint
                  -- to_number(to_char((sysdate - 2), 'yyyymmdd'))
               and k2.application_key = 70
               and k2.ip = k1.ip
               and k2.agent = k1.agent
               and k2.vid != 'wxlitebargain'
               and rownum = 1)
     where k1.visit_date_key between startpoint and endpoint
       and k1.id between min_id and max_id
          --to_number(to_char((sysdate - 2), 'yyyymmdd'))
       and k1.vid = 'wxlitebargain';
  
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
  
end processwxlitevid;
/

