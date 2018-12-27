???create or replace procedure dw_user.processgoodunion(startpoint varchar2) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  update_rows number; /*yangjin 2018-03-21*/
  --startpoint  fact_page_view.id%type;
  -- endpoint    fact_page_view.id%type;
  /*
  功能说明：调度对SBI层W_SESSION_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-12
  */
begin
  sp_name          := 'processgoodunion'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'dim_good'; --此处需要手工录入该PROCEDURE操作的表格
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

  declare
  
    type type_array is table of dim_good%rowtype index by binary_integer; --类似二维数组 
    var_array type_array;
    g_id      number;
    gcid      number;
    gcname    varchar2(100);
    bid       number;
    bname     varchar2(100);
    g_state   number;
    g_price   number;
    istv      number;
    iskjg     number;
    cnt       number;
  begin
  
    select *
      bulk collect
      into var_array
      from dim_good e
     where to_char(e.create_time, 'yyyymmdd') = startpoint; /*yangjin 2018-03-21*/
  
    -- between 20160411 and 20160424;
  
    for i in 1 .. var_array.count loop
    
      select nvl(count(1), 0)
        into cnt
        from dim_ec_good
       where item_code = var_array(i).item_code;
    
      if cnt > 0
      then
      
        select nvl(h.goods_commonid, 0)
          into g_id
          from dim_ec_good h
         where h.item_code = var_array(i).item_code;
      
        select nvl(h.gc_id, 0)
          into gcid
          from dim_ec_good h
         where h.item_code = var_array(i).item_code;
      
        select nvl(h.gc_name, '未知')
          into gcname
          from dim_ec_good h
         where h.item_code = var_array(i).item_code;
      
        select nvl(h.brand_id, 0)
          into bid
          from dim_ec_good h
         where h.item_code = var_array(i).item_code;
      
        select nvl(h.brand_name, '未知')
          into bname
          from dim_ec_good h
         where h.item_code = var_array(i).item_code;
      
        select nvl(h.goods_state, -1)
          into g_state
          from dim_ec_good h
         where h.item_code = var_array(i).item_code;
      
        select nvl(h.goods_price, 0)
          into g_price
          from dim_ec_good h
         where h.item_code = var_array(i).item_code;
      
        select nvl(h.is_tv, -1)
          into istv
          from dim_ec_good h
         where h.item_code = var_array(i).item_code;
      
        select nvl(h.is_kjg, -1)
          into iskjg
          from dim_ec_good h
         where h.item_code = var_array(i).item_code;
      
        update dim_good e4
           set e4.goods_commonid = g_id,
               e4.gc_id          = gcid,
               e4.gc_name        = gcname,
               e4.brand_id       = bid,
               e4.brand_name     = bname,
               e4.goods_state    = g_state,
               e4.good_price     = g_price,
               e4.is_tv          = istv,
               e4.is_kjg         = iskjg
         where e4.item_code = var_array(i).item_code;
        commit;
      
      else
      
        update dim_good e4
           set e4.goods_commonid = 0,
               e4.gc_id          = 0,
               e4.gc_name        = '未知',
               e4.brand_id       = 0,
               e4.brand_name     = '未知',
               e4.goods_state    = -1,
               e4.good_price     = 0,
               e4.is_tv          = -1,
               e4.is_kjg         = -1
         where e4.item_code = var_array(i).item_code;
        commit;
      end if;
    end loop;
    update_rows := var_array.count; /*yangjin 2018-03-21*/
  end;

  /*日志记录模块*/
  s_etl.end_time       := sysdate;
  s_etl.etl_record_upd := update_rows; /*yangjin 2018-03-21*/
  s_etl.etl_status     := 'SUCCESS';
  s_etl.err_msg        := '输入参数:startpoint:' || to_char(startpoint); /*yangjin 2018-03-21*/
  s_etl.etl_duration   := trunc((s_etl.end_time - s_etl.start_time) * 86400);
  sp_sbi_w_etl_log(s_etl);
exception
  when others then
    s_etl.end_time   := sysdate;
    s_etl.etl_status := 'FAILURE';
    s_etl.err_msg    := sqlerrm;
    sp_sbi_w_etl_log(s_etl);
    return;
  
end processgoodunion;
/

