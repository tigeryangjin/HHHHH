begin
  -- Call the procedure
  happigo_kpi_pkg.kpi_asmt_app_item_cvr_dt_proc(20180311);
	happigo_kpi_pkg.KPI_ASMT_TOTAL_MONTH_PROC(20180311);
end;
/

begin
  -- Call the procedure
  oper_member_like_pkg.oper_member_like_item_proc(20180311);
	oper_member_like_pkg.OPER_MEMBER_LIKE_MATXL_PROC(20180311);
end;
/

begin
  -- Call the procedure
  OPER_MEMBER_MARKETING_PKG.PROC_MBR_FIRST_ORDER_15DAYS(20180311);
	OPER_MEMBER_MARKETING_PKG.PROC_MBR_ORDER_PUSH(20180311);
	OPER_MEMBER_MARKETING_PKG.PROC_MBR_REG_WITHOUT_ORDER(20180311);
	OPER_MEMBER_MARKETING_PKG.PROC_MBR_SECOND_ORDER_20DAYS(20180311);
	OPER_MEMBER_MARKETING_PKG.PROC_MBR_THIRD_ORDER_30DAYS(20180311);
end;
/

begin
  -- Call the procedure
	oper_member_like_pkg.OPER_ITEM_RECOMMEND_AR_PROC(20180311);
	oper_member_like_pkg.OPER_ITEM_RECOMMEND_SR_PROC(20180311);
	oper_member_like_pkg.OPER_ITEM_RECOMMEND_UNION_PROC(20180311);
end;
/

begin
	member_filter_pkg.SYNC_MEMBER_LABEL_HEAD(20180311);
	member_filter_pkg.SYNC_MEMBER_LABEL_LINK(20180311);
end;
/  
