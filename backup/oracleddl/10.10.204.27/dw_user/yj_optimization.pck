???CREATE OR REPLACE PACKAGE DW_USER.YJ_OPTIMIZATION IS

  -- AUTHOR  : YANGJIN
  -- CREATED : 2018-07-03 15:50:42
  -- PURPOSE : oracle优化

  PROCEDURE ATSS(IN_TABLE_NAME IN VARCHAR2);
  /*
  功能名:       ATSS
  目的:         收缩表的高水位线
  作者:         yangjin
  创建时间：    2017/07/26
  最后修改人：
  最后更改日期：
  */

  PROCEDURE ATSSC(IN_TABLE_NAME IN VARCHAR2);
  /*
  功能名:       ATSSC
  目的:         收缩表的高水位线
  作者:         yangjin
  创建时间：    2017/07/26
  最后修改人：
  最后更改日期：
  */

  PROCEDURE TABLE_ATSSC;
  /*
  功能名:       TABLE_ATSSC
  目的:         数据库表优化
  作者:         yangjin
  创建时间：    2018/09/19
  最后修改人：
  最后更改日期：
  */

  PROCEDURE TABLE_ATSS;
  /*
  功能名:       TABLE_ATSS
  目的:         数据库表优化
  作者:         yangjin
  创建时间：    2018/09/19
  最后修改人：
  最后更改日期：
  */

  PROCEDURE TABLE_OPTIMIZATION;
  /*
  功能名:       TABLE_OPTIMIZATION
  目的:         数据库表优化
  作者:         yangjin
  创建时间：    2017/09/27
  最后修改人：
  最后更改日期：
  */

END YJ_OPTIMIZATION;
/

CREATE OR REPLACE PACKAGE BODY DW_USER.YJ_OPTIMIZATION IS

  PROCEDURE ATSS(IN_TABLE_NAME IN VARCHAR2) IS
  BEGIN
  
    EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';
    EXECUTE IMMEDIATE 'ALTER TABLE ' || TO_CHAR(IN_TABLE_NAME) ||
                      ' ENABLE ROW MOVEMENT';
    EXECUTE IMMEDIATE 'ALTER TABLE ' || TO_CHAR(IN_TABLE_NAME) ||
                      ' SHRINK SPACE';
    EXECUTE IMMEDIATE 'ALTER TABLE ' || TO_CHAR(IN_TABLE_NAME) ||
                      ' DISABLE ROW MOVEMENT';
    EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';
    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'DW_USER',
                                  TABNAME => TO_CHAR(IN_TABLE_NAME),
                                  DEGREE  => 4,
                                  CASCADE => TRUE);
  END ATSS;

  PROCEDURE ATSSC(IN_TABLE_NAME IN VARCHAR2) IS
  BEGIN
  
    EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';
    EXECUTE IMMEDIATE 'ALTER TABLE ' || TO_CHAR(IN_TABLE_NAME) ||
                      ' ENABLE ROW MOVEMENT';
    EXECUTE IMMEDIATE 'ALTER TABLE ' || TO_CHAR(IN_TABLE_NAME) ||
                      ' SHRINK SPACE COMPACT';
    EXECUTE IMMEDIATE 'ALTER TABLE ' || TO_CHAR(IN_TABLE_NAME) ||
                      ' DISABLE ROW MOVEMENT';
    EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';
  END ATSSC;

  PROCEDURE TABLE_ATSSC IS
    S_ETL W_ETL_LOG%ROWTYPE;
  BEGIN
    S_ETL.PROC_NAME  := 'YJ_OPTIMIZATION.TABLE_ATSSC';
    S_ETL.START_TIME := SYSDATE;
  
    /*ATSSC*/
    --YJ_OPTIMIZATION.ATSSC('DATA_ACQUISITION_ITEM');
    --YJ_OPTIMIZATION.ATSSC('DATA_ACQUISITION_ITEM_BASE');
    --YJ_OPTIMIZATION.ATSSC('DATA_ACQUISITION_ITEM_CURRENT');
    YJ_OPTIMIZATION.ATSSC('DATA_ACQUISITION_MONTH_NEW');
    YJ_OPTIMIZATION.ATSSC('DIM_MEMBER');
    YJ_OPTIMIZATION.ATSSC('FACT_EC_ORDER_2');
    YJ_OPTIMIZATION.ATSSC('FACT_EC_ORDER_COMMON');
    YJ_OPTIMIZATION.ATSSC('FACT_EC_ORDER_GOODS');
    YJ_OPTIMIZATION.ATSSC('FACT_EC_P_MANSONG');
    YJ_OPTIMIZATION.ATSSC('FACT_EC_P_MANSONG_GOODS');
    YJ_OPTIMIZATION.ATSSC('FACT_EC_P_XIANSHI');
    YJ_OPTIMIZATION.ATSSC('FACT_EC_P_XIANSHI_GOODS');
    YJ_OPTIMIZATION.ATSSC('FACT_EC_VOUCHER');
    YJ_OPTIMIZATION.ATSSC('FACT_EC_VOUCHER_BATCH');
    YJ_OPTIMIZATION.ATSSC('FACT_EC_GOODS');
    YJ_OPTIMIZATION.ATSSC('FACT_EC_GOODS_COMMON');
    YJ_OPTIMIZATION.ATSSC('FACT_EC_GOODS_MANUAL');
    --YJ_OPTIMIZATION.ATSSC('FACT_GOODS_SALES');
    YJ_OPTIMIZATION.ATSSC('FACT_GOODS_SALES_REVERSE');
    YJ_OPTIMIZATION.ATSSC('FACT_HMSC_ITEM_AREA_MARKET');
    YJ_OPTIMIZATION.ATSSC('FACT_MEMBER_EC_GOODS_SALES');
    YJ_OPTIMIZATION.ATSSC('FACT_MEMBER_PAGE_ORDER');
    YJ_OPTIMIZATION.ATSSC('FACT_ORDER');
    YJ_OPTIMIZATION.ATSSC('FACT_SCAN_CODE');
    YJ_OPTIMIZATION.ATSSC('FACT_SEARCH');
    YJ_OPTIMIZATION.ATSSC('FACT_SESSION');
    --YJ_OPTIMIZATION.ATSSC('FACT_SIGN_EXTRA');
    YJ_OPTIMIZATION.ATSSC('FACT_VIDEO_FEATURE');
    YJ_OPTIMIZATION.ATSSC('FACT_VISITOR_ACTIVE');
    YJ_OPTIMIZATION.ATSSC('FACT_VISITOR_REGISTER');
    YJ_OPTIMIZATION.ATSSC('FACT_VOUCHER');
    YJ_OPTIMIZATION.ATSSC('KPI_ACTIVE_VID_BASE');
    YJ_OPTIMIZATION.ATSSC('MEMBER_LABEL_LINK');
    YJ_OPTIMIZATION.ATSSC('MLOG$_MEMBER_LABEL_LINK');
    YJ_OPTIMIZATION.ATSSC('OPER_GOOD_LABEL_ANALYSIS');
    YJ_OPTIMIZATION.ATSSC('OPER_NM_PROMOTION_ITEM_REPORT');
    YJ_OPTIMIZATION.ATSSC('OPER_NM_PROMOTION_ORDER_REPORT');
    YJ_OPTIMIZATION.ATSSC('OPER_NM_VOUCHER_REPORT');
    YJ_OPTIMIZATION.ATSSC('OPER_PRODUCT_DAILY_REPORT');
    YJ_OPTIMIZATION.ATSSC('OPER_PRODUCT_PVUV_DAILY_REPORT');
    YJ_OPTIMIZATION.ATSSC('PUSH_MSG_LOG');
    YJ_OPTIMIZATION.ATSSC('STATS_ONLINE_GOOD_MINUTE');
    YJ_OPTIMIZATION.ATSSC('STATS_ONLINE_GOOD2_MINUTE');
  
    S_ETL.END_TIME     := SYSDATE;
    S_ETL.ETL_STATUS   := 'SUCCESS';
    S_ETL.ERR_MSG      := '无输入参数';
    S_ETL.ETL_DURATION := TRUNC((S_ETL.END_TIME - S_ETL.START_TIME) * 86400);
    SP_SBI_W_ETL_LOG(S_ETL);
  EXCEPTION
    WHEN OTHERS THEN
      S_ETL.END_TIME   := SYSDATE;
      S_ETL.ETL_STATUS := 'FAILURE';
      S_ETL.ERR_MSG    := SQLERRM;
      SP_SBI_W_ETL_LOG(S_ETL);
      RETURN;
  END TABLE_ATSSC;

  PROCEDURE TABLE_ATSS IS
    S_ETL W_ETL_LOG%ROWTYPE;
  BEGIN
    S_ETL.PROC_NAME  := 'YJ_OPTIMIZATION.TABLE_ATSS';
    S_ETL.START_TIME := SYSDATE;
  
    /*ATSS*/
    --YJ_OPTIMIZATION.ATSS('DATA_ACQUISITION_ITEM');
    --YJ_OPTIMIZATION.ATSS('DATA_ACQUISITION_ITEM_BASE');
    --YJ_OPTIMIZATION.ATSS('DATA_ACQUISITION_ITEM_CURRENT');
    YJ_OPTIMIZATION.ATSS('DATA_ACQUISITION_MONTH_NEW');
    YJ_OPTIMIZATION.ATSS('DIM_MEMBER');
    YJ_OPTIMIZATION.ATSS('FACT_EC_ORDER_2');
    YJ_OPTIMIZATION.ATSS('FACT_EC_ORDER_COMMON');
    YJ_OPTIMIZATION.ATSS('FACT_EC_ORDER_GOODS');
    YJ_OPTIMIZATION.ATSS('FACT_EC_P_MANSONG');
    YJ_OPTIMIZATION.ATSS('FACT_EC_P_MANSONG_GOODS');
    YJ_OPTIMIZATION.ATSS('FACT_EC_P_XIANSHI');
    YJ_OPTIMIZATION.ATSS('FACT_EC_P_XIANSHI_GOODS');
    YJ_OPTIMIZATION.ATSS('FACT_EC_VOUCHER');
    YJ_OPTIMIZATION.ATSS('FACT_EC_VOUCHER_BATCH');
    YJ_OPTIMIZATION.ATSS('FACT_EC_GOODS');
    YJ_OPTIMIZATION.ATSS('FACT_EC_GOODS_COMMON');
    YJ_OPTIMIZATION.ATSS('FACT_EC_GOODS_MANUAL');
    --YJ_OPTIMIZATION.ATSS('FACT_GOODS_SALES');
    YJ_OPTIMIZATION.ATSS('FACT_GOODS_SALES_REVERSE');
    YJ_OPTIMIZATION.ATSS('FACT_HMSC_ITEM_AREA_MARKET');
    YJ_OPTIMIZATION.ATSS('FACT_MEMBER_EC_GOODS_SALES');
    YJ_OPTIMIZATION.ATSS('FACT_MEMBER_PAGE_ORDER');
    YJ_OPTIMIZATION.ATSS('FACT_ORDER');
    YJ_OPTIMIZATION.ATSS('FACT_SCAN_CODE');
    YJ_OPTIMIZATION.ATSS('FACT_SEARCH');
    YJ_OPTIMIZATION.ATSS('FACT_SESSION');
    --YJ_OPTIMIZATION.ATSS('FACT_SIGN_EXTRA');
    YJ_OPTIMIZATION.ATSS('FACT_VIDEO_FEATURE');
    YJ_OPTIMIZATION.ATSS('FACT_VISITOR_ACTIVE');
    YJ_OPTIMIZATION.ATSS('FACT_VISITOR_REGISTER');
    YJ_OPTIMIZATION.ATSS('FACT_VOUCHER');
    YJ_OPTIMIZATION.ATSS('KPI_ACTIVE_VID_BASE');
    YJ_OPTIMIZATION.ATSS('MEMBER_LABEL_LINK');
    YJ_OPTIMIZATION.ATSS('MLOG$_MEMBER_LABEL_LINK');
    YJ_OPTIMIZATION.ATSS('OPER_GOOD_LABEL_ANALYSIS');
    YJ_OPTIMIZATION.ATSS('OPER_NM_PROMOTION_ITEM_REPORT');
    YJ_OPTIMIZATION.ATSS('OPER_NM_PROMOTION_ORDER_REPORT');
    YJ_OPTIMIZATION.ATSS('OPER_NM_VOUCHER_REPORT');
    YJ_OPTIMIZATION.ATSS('OPER_PRODUCT_DAILY_REPORT');
    YJ_OPTIMIZATION.ATSS('OPER_PRODUCT_PVUV_DAILY_REPORT');
    YJ_OPTIMIZATION.ATSS('PUSH_MSG_LOG');
    YJ_OPTIMIZATION.ATSS('STATS_ONLINE_GOOD_MINUTE');
    YJ_OPTIMIZATION.ATSS('STATS_ONLINE_GOOD2_MINUTE');
  
    S_ETL.END_TIME     := SYSDATE;
    S_ETL.ETL_STATUS   := 'SUCCESS';
    S_ETL.ERR_MSG      := '无输入参数';
    S_ETL.ETL_DURATION := TRUNC((S_ETL.END_TIME - S_ETL.START_TIME) * 86400);
    SP_SBI_W_ETL_LOG(S_ETL);
  EXCEPTION
    WHEN OTHERS THEN
      S_ETL.END_TIME   := SYSDATE;
      S_ETL.ETL_STATUS := 'FAILURE';
      S_ETL.ERR_MSG    := SQLERRM;
      SP_SBI_W_ETL_LOG(S_ETL);
      RETURN;
  END TABLE_ATSS;

  PROCEDURE TABLE_OPTIMIZATION IS
    S_ETL W_ETL_LOG%ROWTYPE;
  BEGIN
    S_ETL.PROC_NAME  := 'YJ_OPTIMIZATION.TABLE_OPTIMIZATION';
    S_ETL.START_TIME := SYSDATE;
    /*
    每周六14:00开始执行
    */
    YJ_OPTIMIZATION.TABLE_ATSSC;
    YJ_OPTIMIZATION.TABLE_ATSS;
  
    S_ETL.END_TIME     := SYSDATE;
    S_ETL.ETL_STATUS   := 'SUCCESS';
    S_ETL.ERR_MSG      := '无输入参数';
    S_ETL.ETL_DURATION := TRUNC((S_ETL.END_TIME - S_ETL.START_TIME) * 86400);
    SP_SBI_W_ETL_LOG(S_ETL);
  EXCEPTION
    WHEN OTHERS THEN
      S_ETL.END_TIME   := SYSDATE;
      S_ETL.ETL_STATUS := 'FAILURE';
      S_ETL.ERR_MSG    := SQLERRM;
      SP_SBI_W_ETL_LOG(S_ETL);
      RETURN;
  END TABLE_OPTIMIZATION;

END YJ_OPTIMIZATION;
/

