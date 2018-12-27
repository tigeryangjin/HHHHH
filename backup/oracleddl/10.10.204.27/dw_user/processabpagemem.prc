???create or replace procedure dw_user.processabpagemem is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processabpagemem'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'dim_member_base'; --此处需要手工录入该PROCEDURE操作的表格
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
  
    type type_array is table of dim_member_base%rowtype index by binary_integer; --类似二维数组 
    var_array type_array;
  begin
  
    select * bulk collect
      into var_array
      from dim_member_base e
     where e.create_date_key between 20170101 and 20170121;
  
    for i in 1 .. var_array.count loop
    
      insert into abpage_memscore
        (member_key, memscore)
        select z.member_key, z.memscore
          from (select x.member_key, sum(vidtot + memtot) as memscore
                  from (select var_array(i).MEMBER_BP as member_key,
                               
                               nvl(sum(v1.register_score + v1.tv_score +
                                       v1.web_score + v1.ec_good_score +
                                       v1.tv_good_score + v1.live_good_score),
                                   0) as memtot
                          from dim_member_base v1
                         where member_bp = var_array(i).MEMBER_BP) x,
                       (select var_array(i).MEMBER_BP as member_key,
                               nvl(sum(v0.score), 0) as vidtot
                          from dim_vid_base v0
                         where exists (select *
                                  from dim_vid_mem v1
                                 where v1.member_key = var_array(i).MEMBER_BP
                                   and v1.vid = v0.vid)) y
                 where x.member_key = y.member_key
                 group by x.member_key) z
         where not exists (select *
                  from abpage_memscore z1
                 where z1.member_key = z.member_key);
    
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
end processabpagemem;
/

