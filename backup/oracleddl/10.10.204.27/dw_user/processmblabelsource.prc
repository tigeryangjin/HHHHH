???create or replace procedure dw_user.processmblabelsource(startpoint number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processmblabelsource'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'member_label_link'; --此处需要手工录入该PROCEDURE操作的表格
  s_etl.proc_name  := sp_name;
  s_etl.start_time := sysdate;
  s_parameter      := 0;

  begin
    sp_parameter_two(sp_name, s_parameter);
    if s_parameter = '0'
    then
      s_etl.err_msg := '没有找到对应的过程加载类型数据';
      sp_sbi_w_etl_log(s_etl);
      return;
    end if;
  end;
  --= '00000000';

  declare
  
    type type_array is table of dim_vid_mem%rowtype index by binary_integer; --类似二维数组 
    var_array type_array;
    --v_id      varchar2(1000);
    vidcnt number;
  begin
    /*application_key = 10*/
    select distinct *
      bulk collect
      into var_array
      from dim_vid_mem e
     where e.create_date_key = startpoint -- to_number(to_char(sysdate - 1, 'yyyymmdd'))
       and e.application_key = 10
       and not exists (select *
              from member_label_link e2
             where (e2.m_label_id between 236 and 397 or
                   e2.m_label_id between 404 and 428)
               and e2.member_key = e.member_key);
  
    delete from tmp_0913;
    commit;
  
    for i in 1 .. var_array.count loop
    
      insert into tmp_0913 values (1, var_array(i).member_key);
      commit;
    
      insert into member_label_link
        select var_array(i).member_key,
               (select p6.m_label_id
                  from member_label_head p6
                 where p6.m_label_name = p3.hmsc),
               1,
               sysdate,
               'liqiao',
               sysdate,
               'liqiao',
               member_label_link_seq.nextval
          from fact_visitor_register p3
         where p3.vid = var_array(i).vid
           and not exists
        /*不插入重复记录*/
         (select 1
                  from member_label_link a1, member_label_head a2
                 where p3.member_key = a1.member_key
                   and a1.m_label_id = a2.m_label_id
                   and a2.m_label_name = p3.hmsc);
      commit;
    
    end loop;
    /*application_key = 20*/
    select distinct *
      bulk collect
      into var_array
      from dim_vid_mem e
     where e.create_date_key = startpoint -- to_number(to_char(sysdate - 1, 'yyyymmdd'))
       and e.application_key = 20
       and not exists (select *
              from member_label_link e2
             where (e2.m_label_id between 236 and 397 or
                   e2.m_label_id between 404 and 428)
               and e2.member_key = e.member_key);
  
    delete from tmp_0913;
    commit;
  
    for i in 1 .. var_array.count loop
    
      insert into tmp_0913 values (1, var_array(i).member_key);
      commit;
    
      insert into member_label_link
        select var_array(i).member_key,
               (select p6.m_label_id
                  from member_label_head p6
                 where p6.m_label_name = p3.hmsc),
               1,
               sysdate,
               'liqiao',
               sysdate,
               'liqiao',
               member_label_link_seq.nextval
          from fact_visitor_register p3
         where p3.vid = var_array(i).vid
           and not exists
        /*不插入重复记录*/
         (select 1
                  from member_label_link a1, member_label_head a2
                 where p3.member_key = a1.member_key
                   and a1.m_label_id = a2.m_label_id
                   and a2.m_label_name = p3.hmsc);
      commit;
    
    end loop;
  
    /*application_key = 30*/
    select distinct *
      bulk collect
      into var_array
      from dim_vid_mem e
     where e.create_date_key = startpoint -- to_number(to_char(sysdate - 1, 'yyyymmdd'))
       and e.application_key = 30
       and not exists (select *
              from member_label_link e2
             where e2.m_label_id between 236 and 397
               and e2.member_key = e.member_key);
  
    delete from tmp_0913;
    commit;
  
    for i in 1 .. var_array.count loop
    
      insert into tmp_0913 values (1, var_array(i).member_key);
      commit;
    
      insert into member_label_link
        (member_key,
         m_label_id,
         m_label_type_id,
         create_date,
         create_user_id,
         last_update_date,
         last_update_user_id,
         row_id)
        select s1.member_key,
               s1.m_label_id,
               s1.m_label_type_id,
               s1.create_date,
               s1.create_user_id,
               s1.last_update_date,
               s1.last_update_user_id,
               member_label_link_seq.nextval
          from (select var_array(i).member_key member_key,
                       (select p6.m_label_id
                          from member_label_head p6
                         where p6.m_label_id in (246,
                                                 247,
                                                 248,
                                                 249,
                                                 250,
                                                 251,
                                                 252,
                                                 253,
                                                 254,
                                                 393,
                                                 394)
                           and p6.m_label_name = p33.level2) m_label_id,
                       1 m_label_type_id,
                       sysdate create_date,
                       'liqiao' create_user_id,
                       sysdate last_update_date,
                       'liqiao' last_update_user_id
                  from fact_daily_3gpromotion p33
                 where p33.vid = var_array(i).vid
                      /*不插入重复记录*/
                   and not exists
                 (select 1
                          from member_label_link a1
                         where p33.member_key = a1.member_key
                           and a1.m_label_id in (246,
                                                 247,
                                                 248,
                                                 249,
                                                 250,
                                                 251,
                                                 252,
                                                 253,
                                                 254,
                                                 393,
                                                 394))
                   and rownum = 1) s1
         where s1.m_label_id is not null;
    
      commit;
    
    end loop;
  
    /*application_key = 40*/
    select distinct *
      bulk collect
      into var_array
      from dim_vid_mem e
     where e.create_date_key = startpoint -- to_number(to_char(sysdate - 1, 'yyyymmdd'))
       and e.application_key = 40
       and not exists (select *
              from member_label_link e2
             where e2.m_label_id between 236 and 397
               and e2.member_key = e.member_key);
  
    delete from tmp_0913;
    commit;
  
    for i in 1 .. var_array.count loop
    
      insert into tmp_0913 values (1, var_array(i).member_key);
      commit;
    
      insert into member_label_link
        (member_key,
         m_label_id,
         m_label_type_id,
         create_date,
         create_user_id,
         last_update_date,
         last_update_user_id,
         row_id)
        select s1.member_key,
               s1.m_label_id,
               s1.m_label_type_id,
               s1.create_date,
               s1.create_user_id,
               s1.last_update_date,
               s1.last_update_user_id,
               member_label_link_seq.nextval
          from (select var_array(i).member_key member_key,
                       (select p6.m_label_id
                          from member_label_head p6
                         where p6.m_label_id in (236,
                                                 237,
                                                 238,
                                                 239,
                                                 240,
                                                 241,
                                                 242,
                                                 243,
                                                 244,
                                                 245,
                                                 395,
                                                 396,
                                                 397)
                           and p6.m_label_name = p33.level2) m_label_id,
                       1 m_label_type_id,
                       sysdate create_date,
                       'liqiao' create_user_id,
                       sysdate last_update_date,
                       'liqiao' last_update_user_id
                  from fact_daily_pcpromotion p33
                 where p33.vid = var_array(i).vid
                      /*不插入重复记录*/
                   and not exists
                 (select 1
                          from member_label_link a1
                         where p33.member_key = a1.member_key
                           and a1.m_label_id in (236,
                                                 237,
                                                 238,
                                                 239,
                                                 240,
                                                 241,
                                                 242,
                                                 243,
                                                 244,
                                                 245,
                                                 395,
                                                 396,
                                                 397))
                   and rownum = 1) s1
         where s1.m_label_id is not null;
    
      commit;
    
    end loop;
  
    /*application_key = 50*/
    select distinct *
      bulk collect
      into var_array
      from dim_vid_mem e
     where e.create_date_key = startpoint -- to_number(to_char(sysdate - 1, 'yyyymmdd'))
       and e.application_key = 50
       and not exists (select *
              from member_label_link e2
             where e2.m_label_id between 236 and 397
               and e2.member_key = e.member_key);
  
    delete from tmp_0913;
    commit;
  
    for i in 1 .. var_array.count loop
    
      insert into tmp_0913 values (1, var_array(i).member_key);
      commit;
      select nvl(count(vid), 0)
        into vidcnt
        from dim_vid_scan
       where vid = var_array(i).vid;
    
      if vidcnt > 0
      then
        /*微信扫码*/
        insert into member_label_link
          select var_array(i).member_key,
                 391,
                 1,
                 sysdate,
                 'liqiao',
                 sysdate,
                 'liqiao',
                 member_label_link_seq.nextval
            from dual
          /*不插入重复记录*/
           where not exists (select 1
                    from member_label_link a1
                   where a1.member_key = var_array(i).member_key
                     and a1.m_label_id = 391);
        commit;
      else
        /*微信自然*/
        insert into member_label_link
          select var_array(i).member_key,
                 392,
                 1,
                 sysdate,
                 'liqiao',
                 sysdate,
                 'liqiao',
                 member_label_link_seq.nextval
            from dual
          /*不插入重复记录*/
           where not exists (select 1
                    from member_label_link a1
                   where a1.member_key = var_array(i).member_key
                     and a1.m_label_id = 392);
      
        commit;
      end if;
    
      commit;
    
    end loop;
  
    insert into member_label_link
      select y.member_key,
             402,
             1,
             sysdate,
             'liqiao',
             sysdate,
             'liqiao',
             member_label_link_seq.nextval
        from (select distinct vv.member_key
                from dim_vid_mem vv
               where vv.create_date_key = startpoint
                 and vv.application_key = 40
                 and not exists (select *
                        from member_label_link vv2
                       where vv2.m_label_id between 236 and 397
                         and vv2.member_key = vv.member_key)
                 and not exists
               (select *
                        from member_label_link vv2
                       where vv2.m_label_id in (402, 403)
                         and vv2.member_key = vv.member_key)
              
              ) y
      /*不插入重复记录*/
       where not exists (select 1
                from member_label_link a1
               where y.member_key = a1.member_key
                 and a1.m_label_id = 402);
    commit;
  
    insert into member_label_link
      select y.member_key,
             403,
             1,
             sysdate,
             'liqiao',
             sysdate,
             'liqiao',
             member_label_link_seq.nextval
        from (select distinct vv.member_key
                from dim_vid_mem vv
               where vv.create_date_key = startpoint
                 and vv.application_key = 30
                 and not exists (select *
                        from member_label_link vv2
                       where vv2.m_label_id between 236 and 397
                         and vv2.member_key = vv.member_key)
                 and not exists
               (select *
                        from member_label_link vv2
                       where vv2.m_label_id in (402, 403)
                         and vv2.member_key = vv.member_key)
              
              ) y
      /*不插入重复记录*/
       where not exists (select 1
                from member_label_link a1
               where y.member_key = a1.member_key
                 and a1.m_label_id = 403);
    commit;
  
    /* select vid
      into v_id
      from dim_vid_mem p1
     where p1.create_date_key = var_array(i).min_date_key
       and p1.member_key = var_array(i).member_key
       and rownum = 1;
    
      insert into member_label_link
            select var_array(i).member_key,
                   (select p6.m_label_id
                      from member_label_head p6
                     where p6.m_label_name = p3.hmsc),
                   1,
                   sysdate,
                   'liqiao',
                   sysdate,
                   'liqiao',
                   member_label_link_seq.nextval
              from fact_visitor_register p3
             where p3.vid = v_id;
        
        insert into member_label_link
            select var_array(i).member_key,
                   (select p6.m_label_id
                      from member_label_head p6
                     where p6.m_label_id in (246,
    247,
    248,
    249,
    250,
    251,
    252,
    253,
    254,
    393,
    394
    ) and p6.m_label_name = p33.level2),
                   1,
                   sysdate,
                   'liqiao',
                   sysdate,
                   'liqiao',
                   member_label_link_seq.nextval
              from fact_daily_3gpromotion p33
             where p33.vid = v_id and rownum=1;
             
             insert into member_label_link
            select var_array(i).member_key,
                   (select p6.m_label_id
                      from member_label_head p6
                     where p6.m_label_id in (236,
    237,
    238,
    239,
    240,
    241,
    242,
    243,
    244,
    245,
    395,
    396,
    397
    ) and p6.m_label_name = p33.level2),
                   1,
                   sysdate,
                   'liqiao',
                   sysdate,
                   'liqiao',
                   member_label_link_seq.nextval
              from fact_daily_pcpromotion p33
             where p33.vid = v_id and rownum=1;
             
             */
  
  end;
  /*日志记录模块*/
  s_etl.end_time       := sysdate;
  s_etl.etl_record_ins := insert_rows;
  s_etl.err_msg        := '输入参数startpoint:' || startpoint;
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
end processmblabelsource;
/

