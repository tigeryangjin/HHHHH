???create or replace procedure dw_user.processipdetail is
  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processipdetail'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'dim_ip_geo'; --此处需要手工录入该PROCEDURE操作的表格
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
  
    type type_array is table of dim_ip_geo%rowtype index by binary_integer; --类似二维数组 
    var_array      type_array;
    count1         number;
    count2         number;
    ip_geo_key_1   number;
    startip_1      varchar(50);
    endip_1        varchar(50);
    ip_continent_1 varchar(50);
    ip_nation_1    varchar(50);
    ip_province_1  varchar(50);
    ip_city_1      varchar(50);
    telecoms_1     varchar(50);
    post_code_1    varchar(50);
    nation_nm_1    varchar(50);
    nation_ab_1    varchar(50);
    longitude_1    varchar(50);
    latitude_1     varchar(50);
    ip_area_1      varchar(50);
  
  begin
  
    select ee.* bulk collect
      into var_array
      from dim_ip_geo ee
     where ee.ip_geo_key = 1;
  
    for i in 1 .. var_array.count loop
    
      select e1.ip_start,
             (e1.ip_end - e1.ip_start),
             ip_geo_key,
             startip,
             endip,
             ip_continent,
             ip_nation,
             ip_province,
             ip_city,
             telecoms,
             post_code,
             nation_nm,
             nation_ab,
             longitude,
             latitude,
             ip_area
        into count1,
             count2,
             ip_geo_key_1,
             startip_1,
             endip_1,
             ip_continent_1,
             ip_nation_1,
             ip_province_1,
             ip_city_1,
             telecoms_1,
             post_code_1,
             nation_nm_1,
             nation_ab_1,
             longitude_1,
             latitude_1,
             ip_area_1
        from dim_ip_geo e1
       where e1.ip_geo_key = var_array(i).ip_geo_key;
    
      for k in 0 .. count2 loop
      
        insert into dim_ip_geo_test
          (ip_geo_key,
           ip_int,
           startip,
           endip,
           ip_continent,
           ip_nation,
           ip_province,
           ip_city,
           telecoms,
           post_code,
           nation_nm,
           nation_ab,
           longitude,
           latitude,
           ip_area)
        values
          (ip_geo_key_1,
           count1 + k,
           startip_1,
           endip_1,
           ip_continent_1,
           ip_nation_1,
           ip_province_1,
           ip_city_1,
           telecoms_1,
           post_code_1,
           nation_nm_1,
           nation_ab_1,
           longitude_1,
           latitude_1,
           ip_area_1
           
           );
      
        commit;
      
      end loop;
    
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
end processipdetail;
/

