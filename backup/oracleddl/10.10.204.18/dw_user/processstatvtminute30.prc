???CREATE OR REPLACE PROCEDURE DW_USER.PROCESSSTATVTMINUTE30(STARTPOINT IN VARCHAR2) IS
  S_ETL       W_ETL_LOG%ROWTYPE;
  SP_NAME     S_PARAMETERS2.PNAME%TYPE;
  S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
  INSERT_ROWS NUMBER;
  /*
  功能说明：调度对SBI层W_SESSION_F表格数据进行增量抽取
       
  
  作者时间：yangjin  2018-11-02
  */
BEGIN
  SP_NAME          := 'processstatvtminute30'; --需要手工填入所写PROCEDURE的名称
  S_ETL.TABLE_NAME := 'stats_online_visitor_minute'; --此处需要手工录入该PROCEDURE操作的表格
  S_ETL.PROC_NAME  := SP_NAME;
  S_ETL.START_TIME := SYSDATE;
  S_PARAMETER      := 0;

  BEGIN
    SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
    IF S_PARAMETER = '0'
    THEN
      S_ETL.ERR_MSG := '没有找到对应的过程加载类型数据';
      SP_SBI_W_ETL_LOG(S_ETL);
      RETURN;
    END IF;
  END;

  DECLARE
    I DATE;
  
  BEGIN
  
    SELECT NVL(MAX(T.END_TIME),
               TO_DATE('2015-07-01 00:00:00', 'yyyy-mm-dd hh24:mi:ss'))
      INTO I
      FROM STATS_ONLINE_VISITOR_MINUTE T
     WHERE T.FREQUENCY = 30;
  
    LOOP
    
      EXIT WHEN TO_NUMBER(TO_CHAR(I + 30 / 24 / 60, 'yyyymmddhh24mi')) >= TO_NUMBER(STARTPOINT);
    
      INSERT INTO STATS_ONLINE_VISITOR_MINUTE
        (ID,
         APPLICATION_KEY,
         APPLICATION_NAME,
         STATDATE,
         STATHOUR,
         STATMINUTE,
         START_TIME,
         END_TIME,
         ONLINEVISITOR,
         FREQUENCY)
      
        SELECT W_STATID_S.NEXTVAL,
               Z2.APPLICATION_KEY,
               CASE
                 WHEN Z2.APPLICATION_KEY = 10 THEN
                  'app-ios'
                 WHEN Z2.APPLICATION_KEY = 20 THEN
                  'app-android'
                 WHEN Z2.APPLICATION_KEY = 30 THEN
                  '3G'
                 WHEN Z2.APPLICATION_KEY = 40 THEN
                  '官网'
                 WHEN Z2.APPLICATION_KEY = 50 THEN
                  '微信'
               END APPLICATION_NAME,
               TO_NUMBER(TO_CHAR(I + 30 / 24 / 60, 'yyyymmdd')) AS REALDATE,
               TO_NUMBER(TO_CHAR(I + 30 / 24 / 60, 'hh24')) AS REALHOUR,
               TO_NUMBER(TO_CHAR(I + 30 / 24 / 60, 'mi')) AS REALMINUTE,
               
               TO_DATE(TO_CHAR(I, 'yyyy-mm-dd hh24:mi'),
                       'yyyy-mm-dd hh24:mi:ss') AS START_TIME,
               TO_DATE(TO_CHAR(I + 30 / 24 / 60, 'yyyy-mm-dd hh24:mi'),
                       'yyyy-mm-dd hh24:mi:ss') AS END_TIME,
               Z2.UVCOUNT,
               30 FREQUENCY
          FROM (SELECT C.APPLICATION_KEY, NVL(B.UVCOUNT, 0) UVCOUNT
                  FROM (SELECT A.APPLICATION_KEY,
                               COUNT(DISTINCT A.VID) AS UVCOUNT
                          FROM FACT_PAGE_VIEW_VT A
                         WHERE A.VISIT_DATE >= I
                           AND A.VISIT_DATE < I + 30 / 24 / 60
                           AND A.APPLICATION_KEY IN (10, 20, 30, 40, 50)
                         GROUP BY A.APPLICATION_KEY) B,
                       (SELECT 10 APPLICATION_KEY
                          FROM DUAL
                        UNION ALL
                        SELECT 20 APPLICATION_KEY
                          FROM DUAL
                        UNION ALL
                        SELECT 30 APPLICATION_KEY
                          FROM DUAL
                        UNION ALL
                        SELECT 40 APPLICATION_KEY
                          FROM DUAL
                        UNION ALL
                        SELECT 50 APPLICATION_KEY
                          FROM DUAL) C
                 WHERE C.APPLICATION_KEY = B.APPLICATION_KEY(+)) Z2;
      INSERT_ROWS := NVL(INSERT_ROWS, 0) + SQL%ROWCOUNT;
      COMMIT;
    
      I := I + 30 / 24 / 60;
    
    END LOOP;
  
  END;

  /*日志记录模块*/
  S_ETL.END_TIME       := SYSDATE;
  S_ETL.ETL_RECORD_INS := INSERT_ROWS;
  S_ETL.ERR_MSG        := '输入参数[startpoint]:' || STARTPOINT;
  S_ETL.ETL_STATUS     := 'SUCCESS';
  S_ETL.ETL_DURATION   := TRUNC((S_ETL.END_TIME - S_ETL.START_TIME) * 86400);
  SP_SBI_W_ETL_LOG(S_ETL);
EXCEPTION
  WHEN OTHERS THEN
    S_ETL.END_TIME   := SYSDATE;
    S_ETL.ETL_STATUS := 'FAILURE';
    S_ETL.ERR_MSG    := SQLERRM;
    SP_SBI_W_ETL_LOG(S_ETL);
    RETURN;
  
END PROCESSSTATVTMINUTE30;
/

