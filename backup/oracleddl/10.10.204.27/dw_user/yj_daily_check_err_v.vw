???CREATE OR REPLACE FORCE VIEW DW_USER.YJ_DAILY_CHECK_ERR_V AS
SELECT A.IP,
       A."USER",
       A.START_TIME,
       A.END_TIME,
       A.PROC_NAME,
       A.TABLE_NAME,
       A.ETL_STATUS,
       A.ERR_MSG
  FROM (SELECT '10.10.204.27' IP,
               'dw_user' "USER",
               T.START_TIME,
               T.END_TIME,
               T.PROC_NAME,
               T.TABLE_NAME,
               T.ETL_STATUS,
               T.ERR_MSG
          FROM W_ETL_LOG T
         WHERE TRUNC(T.START_TIME) >= TRUNC(SYSDATE) - 1
           AND (T.ETL_STATUS <> 'SUCCESS' OR T.ETL_STATUS IS NULL)
        UNION ALL
        --10.10.204.27-odshappigo
        SELECT '10.10.204.27' IP,
               'odshappigo' "USER",
               T.START_TIME,
               T.END_TIME,
               T.PROC_NAME,
               T.TABLE_NAME,
               T.ETL_STATUS,
               T.ERR_MSG
          FROM ODSHAPPIGO.W_ETL_LOG T
         WHERE TRUNC(T.START_TIME) >= TRUNC(SYSDATE) - 1
           AND (T.ETL_STATUS <> 'SUCCESS' OR T.ETL_STATUS IS NULL)
        UNION ALL
        --10.10.204.18-dw_user
        SELECT '10.10.204.18' IP,
               'dw_user' "USER",
               T.START_TIME,
               T.END_TIME,
               T.PROC_NAME,
               T.TABLE_NAME,
               T.ETL_STATUS,
               T.ERR_MSG
          FROM W_ETL_LOG@BITONEWBI T
         WHERE TRUNC(T.START_TIME) >= TRUNC(SYSDATE) - 1
           AND (T.ETL_STATUS <> 'SUCCESS' OR T.ETL_STATUS IS NULL)
        UNION ALL
        --10.10.204.18-ml
        SELECT '10.10.204.18' IP,
               'ml' "USER",
               T.START_TIME,
               T.END_TIME,
               T.PROC_NAME,
               T.TABLE_NAME,
               T.ETL_STATUS,
               T.ERR_MSG
          FROM W_ETL_LOG@ML18 T
         WHERE TRUNC(T.START_TIME) >= TRUNC(SYSDATE) - 1
           AND (T.ETL_STATUS <> 'SUCCESS' OR T.ETL_STATUS IS NULL)) A
 ORDER BY A.IP, A."USER", A.START_TIME DESC
;

