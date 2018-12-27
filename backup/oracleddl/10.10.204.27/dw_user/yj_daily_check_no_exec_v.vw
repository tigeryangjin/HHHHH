???CREATE OR REPLACE FORCE VIEW DW_USER.YJ_DAILY_CHECK_NO_EXEC_V AS
SELECT '10.10.204.27' IP, 'dw_user' "USER", A.PNAME, A.PTYPE, A.DEVELOPER
  FROM S_PARAMETERS2 A
 WHERE UPPER(A.DEVELOPER) = 'YANGJIN'
   AND NOT EXISTS (SELECT 1
          FROM W_ETL_LOG B
         WHERE A.PNAME = B.PROC_NAME
           AND B.START_TIME >= TRUNC(SYSDATE) - 1)
UNION ALL
--10.10.204.27-odshappigo
SELECT '10.10.204.27' IP,
       'odshappigo' "USER",
       A.PNAME,
       A.PTYPE,
       A.DEVELOPER
  FROM ODSHAPPIGO.S_PARAMETERS2 A
 WHERE UPPER(A.DEVELOPER) = 'YANGJIN'
   AND NOT EXISTS (SELECT 1
          FROM ODSHAPPIGO.W_ETL_LOG B
         WHERE A.PNAME = B.PROC_NAME
           AND B.START_TIME >= TRUNC(SYSDATE) - 1)
UNION ALL
--10.10.204.18-dw_user
SELECT '10.10.204.18' IP, 'dw_user' "USER", A.PNAME, A.PTYPE, A.DEVELOPER
  FROM S_PARAMETERS2@BITONEWBI A
 WHERE UPPER(A.DEVELOPER) = 'YANGJIN'
   AND NOT EXISTS (SELECT 1
          FROM W_ETL_LOG@BITONEWBI B
         WHERE A.PNAME = B.PROC_NAME
           AND B.START_TIME >= TRUNC(SYSDATE) - 1)
UNION ALL
--10.10.204.18-ml
SELECT '10.10.204.18' IP, 'ml' "USER", A.PNAME, A.PTYPE, A.DEVELOPER
  FROM S_PARAMETERS2@ML18 A
 WHERE UPPER(A.DEVELOPER) = 'YANGJIN'
   AND NOT EXISTS (SELECT 1
          FROM W_ETL_LOG@ML18 B
         WHERE A.PNAME = B.PROC_NAME
           AND B.START_TIME >= TRUNC(SYSDATE) - 1)
;

