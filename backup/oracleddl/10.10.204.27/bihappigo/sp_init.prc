???create or replace procedure bihappigo.sp_init is
  /*
  功能说明：调度函数总入口
  
  作者时间：liqiao  2015-05-14
  */
begin

 -- sp_ods_resource; --增量抽取数据源表
 --20W
  sp_sbi_pageview_f; --由ODS_REUEST增量抽取生成PV数据  15.178s 
  sp_sbi_w_device_d; --由W_PAGE_VIEW_F 增量抽取设备维表数据2.075
  sp_sbi_w_application_d; --由W_PAGE_VIEW_F 增量抽取应用维表数据 1.248s
  sp_sbi_w_page_d; --由W_PAGE_VIEW_F 增量抽取页面维表数据1.498S
  sp_sbi_upd_key; --批量更新W_PAGE_VIEW_F的page,device,application的key值 19.048
  sp_sbi_upd_pageview;-- 批量更新last_page_key,pageend_time, page_staytime
  sp_sbi_session_f; --遍历W_PAGE_VIEW_F生成SESSION记录
  sp_sbi_visitor_f; --遍历SESSION记录生成VISITOR记录，并向SESSION和PV表回写VISITOR的KEY值

end sp_init;
/

