???create or replace procedure dw_user.processabpagevidupd (startpoint number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processabpagevidupd'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'abpage_vidscore'; --此处需要手工录入该PROCEDURE操作的表格
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
  
    type type_array is table of dim_vid_mem%rowtype index by binary_integer; --类似二维数组 
    var_array type_array;
    varscore  number;
  begin
  
    select * bulk collect
      into var_array
      from dim_vid_mem t1
     where exists (select *
              from fact_order f
             where order_date_key =startpoint-- to_number(to_char(sysdate - 1, 'yyyymmdd'))
               and order_state = 1
               and f.member_key = t1.member_key);
  
    for i in 1 .. var_array.count loop
    
      -- insert into abpage_vidscore
      --    (vid, vidscore)
      select z.vidscore
        into varscore
        from (select x.vid, sum(vidtot + memtot) as vidscore
                from (select var_array(i).vid as vid,
                             nvl(sum(v1.score), 0) as vidtot
                        from dim_vid_base v1
                       where vid = var_array(i).vid) x,
                     (select var_array(i).vid as vid,
                             nvl(sum(v0.register_score + v0.tv_score +
                                     v0.web_score + v0.ec_good_score +
                                     v0.tv_good_score + v0.live_good_score),
                                 0) as memtot
                        from dim_member_base v0
                       where exists
                       (select *
                                from dim_vid_mem v1
                               where v1.vid = var_array(i).vid
                                 and v1.member_key = v0.member_bp)) y
               where x.vid = y.vid
               group by x.vid) z ;
    
      update abpage_vidscore
         set vidscore = varscore
       where vid = var_array(i).vid;
    
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
end processabpagevidupd;
/

