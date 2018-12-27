???create or replace procedure dw_user.processdimmemberodinc2(startpoint number) is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processdimmemberodinc2'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'dim_member'; --此处需要手工录入该PROCEDURE操作的表格
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
  
    type type_array is table of fact_order%rowtype index by binary_integer; --类似二维数组 
    var_array         type_array;
    max_orderkey      number;
    min_orderkey      number;
    max_web_orderkey  number;
    min_web_orderkey  number;
    first_o_source    number;
    last_o_source     number;
    last_o_address    number;
    first_oweb_source number;
    last_oweb_source  number;
    m_count           number;
    m_web_count       number;
  begin
  
    select * bulk collect
      into var_array
      from fact_order e
     where e.order_date_key = startpoint -- to_number(to_char(sysdate - 1, 'yyyymmdd'))
       and e.order_state = 1;
  
    delete from tmp_0902;
    commit;
  
    for i in 1 .. var_array.count loop
    
      insert into tmp_0902 values (1, var_array(i).member_key);
      commit;
    
      select /*+ index(n1 MEMBER_ORDER_KEY) */
       nvl(count(case
                   when n1.order_state = 1 then
                    n1.member_key
                 end),
           0),
       nvl(count(case
                   when n1.sales_source_key = 20 and
                        n1.sales_source_second_key not in
                        (20003，20013，20016，20018，20019，20023) and n1.order_state = 1 then
                    n1.member_key
                 end),
           0)
        into m_count, m_web_count
        from fact_order n1
       where n1.member_key = var_array(i).member_key
            --and n1.order_state = 1
         and n1.order_date_key <=startpoint;
            -- to_number(to_char(sysdate - 8, 'yyyymmdd'));
    
      if m_count = 0 then
      
        update dim_member l
           set l.first_order_source_key   = 0,
               l.last_order_source_key    = 0,
               l.firstw__order_source_key = 0,
               l.lastw_order_source_key   = 0,
               l.member_last_zone         = 0
         where l.member_bp = var_array(i).member_key;
      
      elsif m_count != 0 and m_web_count != 0 then
      
        select /*+ index(kk MEMBER_ORDER_KEY) */
         min(case
               when kk.order_state = 1 then
                kk.order_key
             end),
         min(case
               when kk.sales_source_key = 20 and kk.sales_source_second_key not in
                    (20003，20013，20016，20018，20019，20023) and kk.order_state = 1 then
                kk.order_key
             end),
         
         max(case
               when kk.order_state = 1 then
                kk.order_key
             end),
         max(case
               when kk.sales_source_key = 20 and kk.sales_source_second_key not in
                    (20003，20013，20016，20018，20019，20023) and kk.order_state = 1 then
                kk.order_key
             end)
        
          into min_orderkey,
               min_web_orderkey,
               max_orderkey,
               max_web_orderkey
        
          from fact_order kk
         where kk.member_key = var_array(i).member_key
              --and kk.order_state = 1
           and kk.order_date_key <=startpoint;
              -- to_number(to_char(sysdate - 8, 'yyyymmdd'));
      
        select /*+ index(v ORDER_MEMBER) */
         nvl(v.sales_source_key, 0)
          into first_o_source
          from fact_order v
         where v.order_key = min_orderkey
           and v.member_key = var_array(i).member_key
        --  and rownum=1
        ;
      
        select /*+ index(v ORDER_MEMBER) */
         nvl(v.sales_source_key, 0)
          into last_o_source
          from fact_order v
         where v.order_key = max_orderkey
           and v.member_key = var_array(i).member_key
        -- and rownum=1
        ;
      
        select /*+ index(v ORDER_MEMBER) */
         nvl(v.address_key, 0)
          into last_o_address
          from fact_order v
         where v.order_key = max_orderkey
           and v.member_key = var_array(i).member_key
        -- and rownum=1
        ;
      
        select /*+ index(v ORDER_MEMBER) */
         nvl(v.sales_source_second_key, 0)
          into first_oweb_source
          from fact_order v
         where v.order_key = min_web_orderkey
           and v.member_key = var_array(i).member_key
        --and rownum=1
        ;
      
        select /*+ index(v ORDER_MEMBER) */
         nvl(v.sales_source_second_key, 0)
          into last_oweb_source
          from fact_order v
         where v.order_key = max_web_orderkey
           and v.member_key = var_array(i).member_key
        --  and rownum=1
        ;
      
        update dim_member l
           set l.first_order_source_key   = first_o_source,
               l.last_order_source_key    = last_o_source,
               l.firstw__order_source_key = first_oweb_source,
               l.lastw_order_source_key   = last_oweb_source,
               l.member_last_zone         = last_o_address,
               l.ch_date_key              = var_array(i).order_date_key
         where l.member_bp = var_array(i).member_key;
      
        commit;
      
      else
      
        select /*+ index(kk MEMBER_ORDER_KEY) */
         min(case
               when kk.order_state = 1 then
                kk.order_key
             end),
         max(case
               when kk.order_state = 1 then
                kk.order_key
             end)
          into min_orderkey, max_orderkey
        
          from fact_order kk
         where kk.member_key = var_array(i).member_key
              --and kk.order_state = 1
           and kk.order_date_key <=startpoint;
              -- to_number(to_char(sysdate - 8, 'yyyymmdd'));
      
        select /*+ index(v ORDER_MEMBER) */
         nvl(v.sales_source_key, 0)
          into first_o_source
          from fact_order v
         where v.order_key = min_orderkey
           and v.member_key = var_array(i).member_key
        --and rownum=1
        ;
      
        select /*+ index(v ORDER_MEMBER) */
         nvl(v.sales_source_key, 0)
          into last_o_source
          from fact_order v
         where v.order_key = max_orderkey
           and v.member_key = var_array(i).member_key
        -- and rownum=1
        ;
      
        select /*+ index(v ORDER_MEMBER) */
         nvl(v.address_key, 0)
          into last_o_address
          from fact_order v
         where v.order_key = max_orderkey
           and v.member_key = var_array(i).member_key;
      
        update dim_member l
           set l.first_order_source_key   = first_o_source,
               l.last_order_source_key    = last_o_source,
               l.member_last_zone         = last_o_address,
               l.firstw__order_source_key = 0,
               l.lastw_order_source_key   = 0,
               l.ch_date_key              = var_array(i).order_date_key
         where l.member_bp = var_array(i).member_key;
      
        commit;
      
      end if;
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
end processdimmemberodinc2;
/

