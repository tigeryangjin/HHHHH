???create or replace procedure dw_user.processmemberbatv2 is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processmemberbatv2'; --需要手工填入所写PROCEDURE的名称
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
    ordercnt  number;
    ordercnt2 number;
    ordercnt3 number;
  begin
  
    select * bulk collect
      into var_array
      from dim_member_base e
     where e.create_date_key between 20170101 and 20170228;
  
    delete from tmp_0902;
    commit;
  
    for i in 1 .. var_array.count loop
    
      insert into tmp_0902 values (1, var_array(i).member_bp);
      commit;
    
      select
      
       nvl(count(distinct(case
                            when b.live_state = 1 then
                             b.order_key
                          end)),
           0),
       nvl(count(distinct(case
                            when b.ec_goods_state = 1 then
                             b.order_key
                          end)),
           0),
       nvl(count(distinct(case
                            when b.tv_goods_state = 1 then
                             b.order_key
                          end)),
           0)
        into ordercnt, ordercnt2, ordercnt3
      
        from fact_goods_sales b
       where member_key = var_array(i).member_bp
         and order_date_key between 20160901 and 20170228
         and sales_source_key = 20
         and order_state = 1
         and tran_type = 0;
    
      update dim_member_base n
         set n.live_count      = ordercnt,
             n.live_good_score = ordercnt * 1.5,
             n.web_good_count  = ordercnt2,
             n.ec_good_score   = ordercnt2 * -1,
             n.tv_good_count   = ordercnt3,
             n.tv_good_score   = ordercnt3 * 1
       where member_bp = var_array(i).member_bp;
    
      commit;
    
      /*update dim_member_base k set k.register_score=5 
      where k.create_date_key=var_array(i).date_key and k.register_resource='TV';
      
      update dim_member_base k set k.register_score=-5 
      where k.create_date_key=var_array(i).date_key and k.register_resource='B2C';
      
          update dim_member_base k set k.register_score=-5 
      where k.create_date_key=var_array(i).date_key and k.register_resource='unknown';*/
    
      /* insert into dim_member_base
      (member_bp, register_resource, create_date_key, ch_date_key)
      
      select
      to_number(case
                       when regexp_like(v.zbpartner, '.([a-z]+|[A-Z])') then
                        '0'
                       when regexp_like(v.zbpartner, '[[:punct:]]+') then
                        '0'
                       when v.zbpartner is null then
                        '0'
                       when v.zbpartner like '%null%' then
                        '0'
                       else
                        regexp_replace(v.zbpartner, '\s', '')
                     end),
      
             case
               when (v.createdby like '0%' or v.createdby like '1%' or
                    v.createdby like '9%') then
                'TV'
               when v.createdby = 'SVR_HOMA' then
                'TV'
               when v.createdby = 'SVR_TEST999' then
                'TV'
             
               when v.createdby in ('SVR_HETLIMP', 'HAPPIGO') then
                'TV'
             
               when v.createdby in ('SVR_HDEP', 'SVR_WAP') then
                'B2C'
               else
                'unknown'
             end,
             to_number(v.createdon),
             to_number(v.ch_on)
        from ods_zbpartner v
       where v.zthrc011 = var_array(i).datekey;*/
    
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
end processmemberbatv2;
/

