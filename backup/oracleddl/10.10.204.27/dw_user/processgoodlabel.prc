???create or replace procedure dw_user.processgoodlabel(startpoint varchar2) is

  s_etl       w_etl_log%rowtype;
  sp_name     s_parameters2.pname%type;
  s_parameter s_parameters1.parameter_value%type;
  insert_rows number;
  update_rows number;

  /*
  功能说明：调度对SBI层W_PAGE_VIEW_F表格数据进行增量抽取
       
  
  作者时间：liqiao  2015-05-11
  */

begin

  sp_name          := 'processgoodlabel'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'goods_label_link'; --此处需要手工录入该PROCEDURE操作的表格
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
  
  begin
    /*商品提报组*/
    insert into goods_label_link
      (item_code,
       g_label_id,
       g_label_type_id,
       create_date,
       create_user_id,
       last_update_date,
       last_update_user_id,
       row_id)
      select a2.item_code,
             a2.g_label_id,
             a2.g_label_type_id,
             a2.create_date,
             a2.create_user_id,
             a2.last_update_date,
             a2.last_update_user_id,
             goods_label_link_seq.nextval
        from (select y1.item_code,
                     case
                       when y1.group_id = 1000 then
                        5
                       when y1.group_id in (2000, 5000, 6000) then
                        6
                       when y1.group_id = 2100 then
                        7
                       when y1.group_id = 2200 then
                        8
                       when y1.group_id = 3000 then
                        9
                       when y1.group_id = 7000 then
                        10
                       else
                        11
                     end g_label_id,
                     1 g_label_type_id,
                     sysdate create_date,
                     'liqiao' create_user_id,
                     sysdate last_update_date,
                     'liqiao' last_update_user_id
                from dim_good y1
               where to_char(y1.create_time, 'yyyymmdd') = startpoint
                 and y1.current_flg = 'Y') a2
       where not exists (select 1
                from goods_label_link a1
               where a1.item_code = a2.item_code
                 and a1.g_label_id = a2.g_label_id);
    commit;
  
    /*物料大类*/
    insert into goods_label_link
      select y5.item_code,
             y5.g_label_id,
             y5.g_label_type_id,
             y5.create_date,
             y5.create_user_id,
             y5.last_update_date,
             y5.last_update_user_id,
             goods_label_link_seq.nextval row_id
        from (select y1.item_code,
                     (select y2.g_label_id
                        from goods_label_head y2
                       where y2.g_label_name = to_char(y1.matdl)) g_label_id,
                     1 g_label_type_id,
                     sysdate create_date,
                     'liqiao' create_user_id,
                     sysdate last_update_date,
                     'liqiao' last_update_user_id
                from dim_good y1
               where to_char(y1.create_time, 'yyyymmdd') = startpoint
                 and y1.current_flg = 'Y'
                 and not exists
               (select 1
                        from goods_label_link y3
                       where y1.item_code = y3.item_code
                         and exists (select 1
                                from goods_label_head_level_v y4
                               where y3.g_label_id = y4.LV3_ID
                                 and y4.LV2_DESC = '物料类别'))) y5
       where y5.g_label_id is not null;
  
    /*物料中类*/
    insert into goods_label_link
      select y5.item_code,
             y5.g_label_id,
             y5.g_label_type_id,
             y5.create_date,
             y5.create_user_id,
             y5.last_update_date,
             y5.last_update_user_id,
             goods_label_link_seq.nextval row_id
        from (select y1.item_code,
                     (select y2.g_label_id
                        from goods_label_head y2
                       where y2.g_label_name = to_char(y1.matzl)) g_label_id,
                     1 g_label_type_id,
                     sysdate create_date,
                     'liqiao' create_user_id,
                     sysdate last_update_date,
                     'liqiao' last_update_user_id
                from dim_good y1
               where to_char(y1.create_time, 'yyyymmdd') = startpoint
                 and y1.current_flg = 'Y'
                 and not exists
               (select 1
                        from goods_label_link y3
                       where y1.item_code = y3.item_code
                         and exists (select 1
                                from goods_label_head_level_v y4
                               where y3.g_label_id = y4.LV4_ID
                                 and y4.LV2_DESC = '物料类别'))) y5
       where y5.g_label_id is not null;
  
    /*物料小类*/
    insert into goods_label_link
      select y5.item_code,
             y5.g_label_id,
             y5.g_label_type_id,
             y5.create_date,
             y5.create_user_id,
             y5.last_update_date,
             y5.last_update_user_id,
             goods_label_link_seq.nextval row_id
        from (select y1.item_code,
                     (select y2.g_label_id
                        from goods_label_head y2
                       where y2.g_label_name = to_char(y1.matxl)) g_label_id,
                     1 g_label_type_id,
                     sysdate create_date,
                     'liqiao' create_user_id,
                     sysdate last_update_date,
                     'liqiao' last_update_user_id
                from dim_good y1
               where to_char(y1.create_time, 'yyyymmdd') = startpoint
                 and y1.current_flg = 'Y'
                 and not exists
               (select 1
                        from goods_label_link y3
                       where y1.item_code = y3.item_code
                         and exists (select 1
                                from goods_label_head_level_v y4
                               where y3.g_label_id = y4.LV5_ID
                                 and y4.LV2_DESC = '物料类别'))) y5
       where y5.g_label_id is not null;
  
    /*ec分类*/
    insert into goods_label_link
      select y5.item_code,
             y5.g_label_id,
             y5.g_label_type_id,
             y5.create_date,
             y5.create_user_id,
             y5.last_update_date,
             y5.last_update_user_id,
             goods_label_link_seq.nextval row_id
        from (select k3.item_code,
                     (select k6.g_label_id
                        from goods_label_head k6
                       where k6.g_label_name = to_char(k3.gc_id)) g_label_id,
                     1 g_label_type_id,
                     sysdate create_date,
                     'liqiao' create_user_id,
                     sysdate last_update_date,
                     'liqiao' last_update_user_id
                from (select y1.item_code,
                             (select distinct y3.gc_id
                                from dim_good_class y3
                               where y3.matdl = y1.matdl) as gc_id
                      
                        from dim_good y1
                       where to_char(y1.create_time, 'yyyymmdd') = startpoint
                         and y1.current_flg = 'Y'
                         and not exists
                       (select 1
                                from goods_label_link y3
                               where y1.item_code = y3.item_code
                                 and exists
                               (select 1
                                        from goods_label_head_level_v y4
                                       where y3.g_label_id = y4.LV3_ID
                                         and y4.LV2_NAME = 'EC_CATEGORY'))) k3) y5
       where y5.g_label_id is not null;
  
    /*配送属性*/
    insert into goods_label_link
      select y1.item_code,
             case
               when y1.dxj = 10 then
                1064
               when y1.dxj = 11 then
                1065
               when y1.dxj = 12 then
                1066
               when y1.dxj = 51 then
                1067
               when y1.dxj = 52 then
                1068
               when y1.dxj = 53 then
                1069
               when y1.dxj = 54 then
                1070
               when y1.dxj = 55 then
                1071
               else
                1071
             end,
             1,
             sysdate,
             'liqiao',
             sysdate,
             'liqiao',
             goods_label_link_seq.nextval
        from dim_good y1
       where to_char(y1.create_time, 'yyyymmdd') = startpoint
         and y1.current_flg = 'Y'
         and y1.dxj != 20
         and not exists
       (select 1
                from goods_label_link y2
               where y1.item_code = y2.item_code
                 and y2.g_label_id in
                     (1064, 1065, 1066, 1067, 1068, 1069, 1070, 1071));
  
    insert_rows := sql%rowcount;
    commit;
  
  end;
  /*日志记录模块*/
  s_etl.end_time       := sysdate;
  s_etl.etl_record_ins := insert_rows;
  s_etl.etl_record_upd := update_rows;
  s_etl.etl_status     := 'SUCCESS';
  s_etl.err_msg        := '输入参数startpoint:' || startpoint; /*yangjin 2018-04-11*/
  s_etl.etl_duration   := trunc((s_etl.end_time - s_etl.start_time) * 86400);
  sp_sbi_w_etl_log(s_etl);
exception
  when others then
    s_etl.end_time   := sysdate;
    s_etl.etl_status := 'FAILURE';
    s_etl.err_msg    := sqlerrm;
    sp_sbi_w_etl_log(s_etl);
    return;
end processgoodlabel;
/

