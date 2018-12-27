???create or replace procedure dw_user.processmapping(startpoint number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processmapping'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'dim_mapping_mem'; --此处需要手工录入该PROCEDURE操作的表格
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

  declare
  
    type type_array is table of dim_mbdevice%rowtype index by binary_integer; --类似二维数组 
    var_array type_array;
    p_id      varchar2(500);
  
  begin
  
    insert into dim_mapping_mem
      (member_key, vid, open_id, create_date_key)
    
      select k1.member_key,
             k1.vid,
             substr(k2.open_id, 3, length(k2.open_id)) as open_id,
             k1.create_date_key
        from (select * from dim_vid_mem where create_date_key = startpoint) k1,
             dim_wechat k2
       where k1.vid = k2.open_id(+)
       and not exists (select * from dim_mapping_mem k3 where 
       k3.member_key=k1.member_key and
       k3.vid=k1.vid)
       
       ;
  
    commit;
  
    select * bulk collect
      into var_array
      from dim_mbdevice m2
     where exists (select *
              from dim_mapping_mem m1
             where to_number(m2.bp) = m1.member_key
               and m2.vid = m1.vid
               and m1.create_date_key = startpoint);
  
    delete from tmp_0902;
    commit;
  
    for i in 1 .. var_array.count loop
    
      insert into tmp_0902 values (1, var_array(i).bp);
      commit;
    
      select /*+ index(t1 MAPPING2_IDX) */
       t1.baidu_channelid
        into p_id
        from dim_mbdevice t1
       where t1.bp = var_array(i).bp
         and t1.vid = var_array(i).vid
         and rownum = 1;
    
      update /*+ index(l MAPPING_IDX) */ dim_mapping_mem l
         set l.push_id = p_id
       where l.member_key = to_number(var_array(i).bp)
         and l.vid = var_array(i).vid;
    
      commit;
    
    end loop;
  
    insert into dim_mapping_mem
      (member_key, vid, create_date_key, push_id)
      select m2.bp,
             m2.vid,
             to_number(to_char(m2.firstlogintime, 'yyyymmdd')),
             m2.baidu_channelid
        from dim_mbdevice m2
       where not exists (select *
                from dim_mapping_mem m3
               where m3.member_key = m2.bp
                 and m3.vid = m2.vid);
  
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
end processmapping;
/

