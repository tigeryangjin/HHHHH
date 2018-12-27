???CREATE OR REPLACE PACKAGE DW_USER.YJ_REPORT IS

  -- AUTHOR  : YANGJIN
  -- CREATED : 2017-09-21 14:40:49
  -- PURPOSE : 商品标签PACKAGE

  PROCEDURE OPER_ACTIVE_MEMBER_REPORT_P(IN_DATE_KEY IN NUMBER);
  /*
  功能名:       OPER_ACTIVE_MEMBER_REPORT_P
  目的:         新媒体中心月报-活跃会员
  作者:         yangjin
  创建时间：    2018/05/29
  最后修改人：
  最后更改日期：
  */

  PROCEDURE OPER_MEMBER_SOURCE_REPORT_P(IN_DATE_KEY IN NUMBER);
  /*
  功能名:       OPER_MEMBER_SOURCE_REPORT_P
  目的:         新媒体中心月报-纳新来源
  作者:         yangjin
  创建时间：    2018/05/29
  最后修改人：
  最后更改日期：
  */

  PROCEDURE OPER_MEMBER_REPUR_RRT_P(IN_DATE_KEY IN NUMBER);
  /*
  功能名:       OPER_MEMBER_REPUR_RRT_P
  目的:         新媒体中心月报-会员订购频次
  作者:         yangjin
  创建时间：    2018/05/29
  最后修改人：
  最后更改日期：
  */

  PROCEDURE OPER_EC_PRODUCT_SUMMARY_PROC(IN_DATE_KEY IN NUMBER);
  /*
  功能名:       OPER_EC_PRODUCT_SUMMARY_PROC
  目的:         在架商品汇总报表
  作者:         yangjin
  创建时间：    2018/07/06
  最后修改人：
  最后更改日期：
  */

  PROCEDURE OPER_MOBILEHOME_REPORT_PROC(IN_DATE_KEY IN NUMBER);
  /*
  功能名:       OPER_MOBILEHOME_REPORT_PROC
  目的:         在架商品汇总报表
  作者:         yangjin
  创建时间：    2018/07/06
  最后修改人：
  最后更改日期：
  */

END YJ_REPORT;
/

CREATE OR REPLACE PACKAGE BODY DW_USER.YJ_REPORT IS

  PROCEDURE OPER_ACTIVE_MEMBER_REPORT_P(IN_DATE_KEY IN NUMBER) IS
    S_ETL                       W_ETL_LOG%ROWTYPE;
    SP_NAME                     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER                 S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS                 NUMBER;
    DELETE_ROWS                 NUMBER;
    S_MONTH_KEY                 NUMBER; /*上月月份KEY*/
    S_AGO_2_MONTH_FIRST_DAY_KEY NUMBER; /*早二个月的第一天*/
    S_AGO_2_MONTH_LAST_DAY_KEY  NUMBER; /*早二个月的最后一天*/
    S_AGO_3_MONTH_FIRST_DAY_KEY NUMBER; /*早三个月的第一天*/
    S_AGO_3_MONTH_LAST_DAY_KEY  NUMBER; /*早三个月的最后一天*/
    S_AGO_4_MONTH_LAST_DAY_KEY  NUMBER; /*早四个月的最后一天*/
    S_LAST_MONTH_LAST_DAY_KEY   NUMBER; /*上月最后一天*/
    S_LAST_MONTH_FIRST_DAY_KEY  NUMBER; /*上月第一天*/
    /*
    功能说明：唤醒会员：  
    作者时间：yangjin  2018-05-28
    */
  BEGIN
    SP_NAME                     := 'YJ_REPORT.OPER_ACTIVE_MEMBER_REPORT'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME            := 'OPER_ACTIVE_MEMBER_REPORT'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME             := SP_NAME;
    S_ETL.START_TIME            := SYSDATE;
    S_PARAMETER                 := 0;
    S_MONTH_KEY                 := TO_CHAR(ADD_MONTHS(TO_DATE(IN_DATE_KEY,
                                                              'YYYYMMDD'),
                                                      -1),
                                           'YYYYMM');
    S_AGO_2_MONTH_FIRST_DAY_KEY := TO_CHAR(TRUNC(ADD_MONTHS(TO_DATE(IN_DATE_KEY,
                                                                    'YYYYMMDD'),
                                                            -2),
                                                 'MONTH'),
                                           'YYYYMMDD');
    S_AGO_2_MONTH_LAST_DAY_KEY  := TO_CHAR(LAST_DAY(ADD_MONTHS(TO_DATE(IN_DATE_KEY,
                                                                       'YYYYMMDD'),
                                                               -2)),
                                           'YYYYMMDD');
    S_AGO_3_MONTH_FIRST_DAY_KEY := TO_CHAR(TRUNC(ADD_MONTHS(TO_DATE(IN_DATE_KEY,
                                                                    'YYYYMMDD'),
                                                            -3),
                                                 'MONTH'),
                                           'YYYYMMDD');
    S_AGO_3_MONTH_LAST_DAY_KEY  := TO_CHAR(LAST_DAY(ADD_MONTHS(TO_DATE(IN_DATE_KEY,
                                                                       'YYYYMMDD'),
                                                               -3)),
                                           'YYYYMMDD');
    S_AGO_4_MONTH_LAST_DAY_KEY  := TO_CHAR(LAST_DAY(ADD_MONTHS(TO_DATE(IN_DATE_KEY,
                                                                       'YYYYMMDD'),
                                                               -4)),
                                           'YYYYMMDD');
    S_LAST_MONTH_LAST_DAY_KEY   := TO_CHAR(LAST_DAY(ADD_MONTHS(TO_DATE(IN_DATE_KEY,
                                                                       'YYYYMMDD'),
                                                               -1)),
                                           'YYYYMMDD');
    S_LAST_MONTH_FIRST_DAY_KEY  := TO_CHAR(TRUNC(ADD_MONTHS(TO_DATE(IN_DATE_KEY,
                                                                    'YYYYMMDD'),
                                                            -1),
                                                 'MONTH'),
                                           'YYYYMMDD');
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.END_TIME := SYSDATE;
        S_ETL.ERR_MSG  := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
    
      MERGE INTO OPER_ACTIVE_MEMBER_REPORT T
      USING (SELECT M.MONTH_KEY,
                    NVL(A1.ALL_MEMBER_COUNT, 0) ALL_MEMBER_COUNT,
                    NVL(A2.NEW_MEMBER_COUNT, 0) NEW_MEMBER_COUNT,
                    NVL(A3.LOST_MEMBER_COUNT, 0) LOST_MEMBER_COUNT,
                    NVL(A4.WAKE_MEMBER_COUNT, 0) WAKE_MEMBER_COUNT,
                    NVL(A5.ORDER_ALL_MEMBER_COUNT, 0) ORDER_ALL_MEMBER_COUNT,
                    NVL(A6.ORDER_NEW_MEMBER_COUNT, 0) ORDER_NEW_MEMBER_COUNT,
                    NVL(A7.ORDER_WAKE_MEMBER_COUNT, 0) ORDER_WAKE_MEMBER_COUNT,
                    NVL(A8.ORDER_KEEP_MEMBER_COUNT, 0) ORDER_KEEP_MEMBER_COUNT,
                    SYSDATE W_INSERT_DT,
                    SYSDATE W_UPDATE_DT
               FROM (SELECT S_MONTH_KEY MONTH_KEY FROM DUAL) M,
                    --A1
                    (SELECT S_MONTH_KEY MONTH_KEY,
                            COUNT(DISTINCT(MEMBER_KEY)) ALL_MEMBER_COUNT
                       FROM FACT_PAGE_VIEW
                      WHERE VISIT_DATE BETWEEN
                            TO_DATE(S_AGO_2_MONTH_FIRST_DAY_KEY, 'YYYYMMDD') AND
                            TO_DATE(S_LAST_MONTH_LAST_DAY_KEY, 'YYYYMMDD')) A1,
                    --A2
                    (SELECT S_MONTH_KEY MONTH_KEY, COUNT(1) NEW_MEMBER_COUNT
                       FROM FACT_ECMEMBER
                      WHERE MEMBER_TIME BETWEEN S_LAST_MONTH_FIRST_DAY_KEY AND
                            S_LAST_MONTH_LAST_DAY_KEY) A2,
                    --A3 流失会员(行为)
                    (SELECT S_MONTH_KEY MONTH_KEY,
                            COUNT(DISTINCT(MEMBER_KEY)) LOST_MEMBER_COUNT
                       FROM FACT_SESSION
                      WHERE START_DATE_KEY BETWEEN
                            S_AGO_3_MONTH_FIRST_DAY_KEY AND
                            S_AGO_3_MONTH_LAST_DAY_KEY
                        AND MEMBER_KEY NOT IN
                            (SELECT DISTINCT (MEMBER_KEY)
                               FROM FACT_SESSION
                              WHERE START_DATE_KEY BETWEEN
                                    S_AGO_2_MONTH_FIRST_DAY_KEY AND
                                    S_LAST_MONTH_LAST_DAY_KEY)) A3,
                    --A4 唤醒会员(行为)
                    (SELECT S_MONTH_KEY MONTH_KEY,
                            COUNT(DISTINCT(MEMBER_KEY)) WAKE_MEMBER_COUNT
                       FROM FACT_SESSION
                      WHERE START_DATE_KEY BETWEEN S_LAST_MONTH_FIRST_DAY_KEY AND
                            S_LAST_MONTH_LAST_DAY_KEY
                        AND MEMBER_KEY IN
                            (SELECT MEMBER_CRMBP
                               FROM FACT_ECMEMBER
                              WHERE MEMBER_TIME <= S_AGO_4_MONTH_LAST_DAY_KEY)
                        AND MEMBER_KEY NOT IN
                            (SELECT DISTINCT (MEMBER_KEY)
                               FROM FACT_SESSION
                              WHERE START_DATE_KEY BETWEEN
                                    S_AGO_3_MONTH_FIRST_DAY_KEY AND
                                    S_AGO_2_MONTH_LAST_DAY_KEY)) A4,
                    --A5
                    (SELECT S_MONTH_KEY MONTH_KEY,
                            COUNT(DISTINCT MEMBER_KEY) ORDER_ALL_MEMBER_COUNT
                       FROM FACTEC_ORDER
                      WHERE ADD_TIME BETWEEN S_LAST_MONTH_FIRST_DAY_KEY AND
                            S_LAST_MONTH_LAST_DAY_KEY
                        AND ORDER_STATE > 10
                        AND STORE_ID = 1
                        AND ORDER_FROM != 76) A5,
                    --A6
                    (SELECT S_MONTH_KEY MONTH_KEY,
                            COUNT(DISTINCT MEMBER_KEY) ORDER_NEW_MEMBER_COUNT
                       FROM FACTEC_ORDER
                      WHERE ADD_TIME BETWEEN S_LAST_MONTH_FIRST_DAY_KEY AND
                            S_LAST_MONTH_LAST_DAY_KEY
                        AND ORDER_STATE > 10
                        AND STORE_ID = 1
                        AND ORDER_FROM != 76
                        AND MEMBER_KEY IN
                            (SELECT MEMBER_CRMBP
                               FROM FACT_ECMEMBER
                              WHERE MEMBER_TIME BETWEEN
                                    S_LAST_MONTH_FIRST_DAY_KEY AND
                                    S_LAST_MONTH_LAST_DAY_KEY)
                        AND ORDER_STATE > 10) A6,
                    --A7 唤醒会员(订购)
                    (SELECT S_MONTH_KEY MONTH_KEY,
                            COUNT(DISTINCT MEMBER_KEY) ORDER_WAKE_MEMBER_COUNT
                       FROM FACTEC_ORDER
                      WHERE ADD_TIME BETWEEN S_LAST_MONTH_FIRST_DAY_KEY AND
                            S_LAST_MONTH_LAST_DAY_KEY
                        AND ORDER_STATE > 10
                        AND STORE_ID = 1
                        AND ORDER_FROM != 76
                        AND MEMBER_KEY NOT IN
                            (SELECT MEMBER_CRMBP
                               FROM FACT_ECMEMBER
                              WHERE MEMBER_TIME BETWEEN
                                    S_LAST_MONTH_FIRST_DAY_KEY AND
                                    S_LAST_MONTH_LAST_DAY_KEY)
                        AND MEMBER_KEY NOT IN
                            (SELECT DISTINCT MEMBER_KEY
                               FROM FACTEC_ORDER
                              WHERE ADD_TIME BETWEEN
                                    S_AGO_3_MONTH_FIRST_DAY_KEY AND
                                    S_AGO_2_MONTH_LAST_DAY_KEY
                                   --SUBSTR(ADD_TIME, 1, 6) IN (201803, 201804)
                                AND ORDER_STATE > 10)) A7,
                    --A8 留存会员(订购)
                    (SELECT S_MONTH_KEY MONTH_KEY,
                            COUNT(DISTINCT MEMBER_KEY) ORDER_KEEP_MEMBER_COUNT
                       FROM FACTEC_ORDER
                      WHERE ADD_TIME BETWEEN S_LAST_MONTH_FIRST_DAY_KEY AND
                            S_LAST_MONTH_LAST_DAY_KEY
                        AND ORDER_STATE > 10
                        AND STORE_ID = 1
                        AND ORDER_FROM != 76
                        AND MEMBER_KEY NOT IN
                            (SELECT MEMBER_CRMBP
                               FROM FACT_ECMEMBER
                              WHERE MEMBER_TIME BETWEEN
                                    S_LAST_MONTH_FIRST_DAY_KEY AND
                                    S_LAST_MONTH_LAST_DAY_KEY)
                        AND MEMBER_KEY IN
                            (SELECT DISTINCT MEMBER_KEY
                               FROM FACTEC_ORDER
                              WHERE ADD_TIME BETWEEN
                                    S_AGO_3_MONTH_FIRST_DAY_KEY AND
                                    S_AGO_2_MONTH_LAST_DAY_KEY
                                   --SUBSTR(ADD_TIME, 1, 6) IN (201803, 201804)
                                AND ORDER_STATE > 10)) A8
              WHERE M.MONTH_KEY = A1.MONTH_KEY(+)
                AND M.MONTH_KEY = A2.MONTH_KEY(+)
                AND M.MONTH_KEY = A3.MONTH_KEY(+)
                AND M.MONTH_KEY = A4.MONTH_KEY(+)
                AND M.MONTH_KEY = A5.MONTH_KEY(+)
                AND M.MONTH_KEY = A6.MONTH_KEY(+)
                AND M.MONTH_KEY = A7.MONTH_KEY(+)
                AND M.MONTH_KEY = A8.MONTH_KEY(+)) S
      ON (T.MONTH_KEY = S.MONTH_KEY)
      WHEN MATCHED THEN
        UPDATE
           SET T.ALL_MEMBER_COUNT        = S.ALL_MEMBER_COUNT,
               T.NEW_MEMBER_COUNT        = S.NEW_MEMBER_COUNT,
               T.LOST_MEMBER_COUNT       = S.LOST_MEMBER_COUNT,
               T.WAKE_MEMBER_COUNT       = S.WAKE_MEMBER_COUNT,
               T.ORDER_ALL_MEMBER_COUNT  = S.ORDER_ALL_MEMBER_COUNT,
               T.ORDER_NEW_MEMBER_COUNT  = S.ORDER_NEW_MEMBER_COUNT,
               T.ORDER_WAKE_MEMBER_COUNT = S.ORDER_WAKE_MEMBER_COUNT,
               T.ORDER_KEEP_MEMBER_COUNT = S.ORDER_KEEP_MEMBER_COUNT,
               T.W_UPDATE_DT             = S.W_UPDATE_DT
      WHEN NOT MATCHED THEN
        INSERT
          (T.MONTH_KEY,
           T.ALL_MEMBER_COUNT,
           T.NEW_MEMBER_COUNT,
           T.LOST_MEMBER_COUNT,
           T.WAKE_MEMBER_COUNT,
           T.ORDER_ALL_MEMBER_COUNT,
           T.ORDER_NEW_MEMBER_COUNT,
           T.ORDER_WAKE_MEMBER_COUNT,
           T.ORDER_KEEP_MEMBER_COUNT,
           T.W_INSERT_DT,
           T.W_UPDATE_DT)
        VALUES
          (S.MONTH_KEY,
           S.ALL_MEMBER_COUNT,
           S.NEW_MEMBER_COUNT,
           S.LOST_MEMBER_COUNT,
           S.WAKE_MEMBER_COUNT,
           S.ORDER_ALL_MEMBER_COUNT,
           S.ORDER_NEW_MEMBER_COUNT,
           S.ORDER_WAKE_MEMBER_COUNT,
           S.ORDER_KEEP_MEMBER_COUNT,
           S.W_INSERT_DT,
           S.W_UPDATE_DT);
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
    END;
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_DEL := DELETE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '输入参数IN_DATE_KEY:' || IN_DATE_KEY;
    S_ETL.ETL_DURATION   := TRUNC((S_ETL.END_TIME - S_ETL.START_TIME) *
                                  86400);
    SP_SBI_W_ETL_LOG(S_ETL);
  EXCEPTION
    WHEN OTHERS THEN
      S_ETL.END_TIME   := SYSDATE;
      S_ETL.ETL_STATUS := 'FAILURE';
      S_ETL.ERR_MSG    := SQLERRM;
      SP_SBI_W_ETL_LOG(S_ETL);
      RETURN;
  END OPER_ACTIVE_MEMBER_REPORT_P;

  PROCEDURE OPER_MEMBER_SOURCE_REPORT_P(IN_DATE_KEY IN NUMBER) IS
    S_ETL                      W_ETL_LOG%ROWTYPE;
    SP_NAME                    S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER                S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS                NUMBER;
    DELETE_ROWS                NUMBER;
    S_LAST_MONTH_LAST_DAY_KEY  NUMBER; /*上月最后一天*/
    S_LAST_MONTH_FIRST_DAY_KEY NUMBER; /*上月第一天*/
    /*
    功能说明：  
    作者时间：yangjin  2018-05-28
    */
  BEGIN
    SP_NAME          := 'YJ_REPORT.OPER_MEMBER_SOURCE_REPORT_P'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'OPER_MEMBER_SOURCE_REPORT'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
  
    S_LAST_MONTH_LAST_DAY_KEY  := TO_CHAR(LAST_DAY(ADD_MONTHS(TO_DATE(IN_DATE_KEY,
                                                                      'YYYYMMDD'),
                                                              -1)),
                                          'YYYYMMDD');
    S_LAST_MONTH_FIRST_DAY_KEY := TO_CHAR(TRUNC(ADD_MONTHS(TO_DATE(IN_DATE_KEY,
                                                                   'YYYYMMDD'),
                                                           -1),
                                                'MONTH'),
                                          'YYYYMMDD');
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.END_TIME := SYSDATE;
        S_ETL.ERR_MSG  := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
    
      MERGE INTO OPER_MEMBER_SOURCE_REPORT T
      USING (SELECT A2.REG_MONTH_KEY MONTH_KEY,
                    A2.SNAME,
                    COUNT(A2.MEMBER_KEY) REG_MEMBER_COUNT,
                    SUM(A2.IS_ORDER) ORDER_MEMBER_COUNT,
                    SUM(A2.ORDER_AMOUNT) ORDER_AMOUNT,
                    SYSDATE W_INSERT_DT,
                    SYSDATE W_UPDATE_DT
               FROM (SELECT SUBSTR(A1.REG_DATE, 1, 6) REG_MONTH_KEY,
                            A1.MEMBER_KEY,
                            CASE
                              WHEN A1.M_LABEL_DESC = '推广' THEN
                               '推广流量'
                              WHEN A1.M_LABEL_DESC = '扫码' THEN
                               '内部流量'
                              WHEN A1.M_LABEL_DESC = '自然' AND
                                   A1.REGISTER_RESOURCE = 'TV' THEN
                               '内部流量'
                              ELSE
                               '自然流量'
                            END SNAME,
                            CASE
                              WHEN A1.ORDER_AMOUNT > 0 THEN
                               1
                              ELSE
                               0
                            END IS_ORDER,
                            A1.ORDER_AMOUNT
                       FROM (SELECT A.MEMBER_KEY,
                                    NVL(B.M_LABEL_DESC, '自然') M_LABEL_DESC,
                                    NVL(C.REGISTER_RESOURCE, 'unknown') REGISTER_RESOURCE,
                                    NVL(D.MEMBER_TIME, '20170101') REG_DATE,
                                    NVL(E.ORDER_AMOUNT, 0) ORDER_AMOUNT
                               FROM (SELECT MEMBER_KEY
                                       FROM FACT_SESSION
                                      WHERE START_DATE_KEY BETWEEN
                                            S_LAST_MONTH_FIRST_DAY_KEY AND
                                            S_LAST_MONTH_LAST_DAY_KEY
                                        AND MEMBER_KEY <> 0
                                      GROUP BY MEMBER_KEY) A,
                                    (SELECT MEMBER_KEY,
                                            MAX(M_LABEL_DESC) M_LABEL_DESC
                                       FROM MEMBER_LABEL_LINK_V
                                      WHERE M_LABEL_ID IN (143, 144, 145)
                                      GROUP BY MEMBER_KEY) B,
                                    (SELECT MEMBER_BP, REGISTER_RESOURCE
                                       FROM DIM_MEMBER) C,
                                    (SELECT MEMBER_CRMBP,
                                            MAX(MEMBER_TIME) MEMBER_TIME
                                       FROM FACT_ECMEMBER
                                      GROUP BY MEMBER_CRMBP) D,
                                    (SELECT MEMBER_KEY,
                                            SUM(ORDER_AMOUNT) ORDER_AMOUNT
                                       FROM FACTEC_ORDER A
                                      WHERE ADD_TIME BETWEEN
                                            S_LAST_MONTH_FIRST_DAY_KEY AND
                                            S_LAST_MONTH_LAST_DAY_KEY
                                        AND ORDER_STATE >= 10
                                      GROUP BY A.MEMBER_KEY) E
                              WHERE A.MEMBER_KEY = B.MEMBER_KEY(+)
                                AND A.MEMBER_KEY = C.MEMBER_BP(+)
                                AND A.MEMBER_KEY = D.MEMBER_CRMBP(+)
                                AND A.MEMBER_KEY = E.MEMBER_KEY(+)) A1
                      WHERE A1.REG_DATE BETWEEN S_LAST_MONTH_FIRST_DAY_KEY AND
                            S_LAST_MONTH_LAST_DAY_KEY) A2
              GROUP BY A2.REG_MONTH_KEY, A2.SNAME) S
      ON (T.MONTH_KEY = S.MONTH_KEY AND T.SNAME = S.SNAME)
      WHEN MATCHED THEN
        UPDATE
           SET T.REG_MEMBER_COUNT   = S.REG_MEMBER_COUNT,
               T.ORDER_MEMBER_COUNT = S.ORDER_MEMBER_COUNT,
               T.ORDER_AMOUNT       = S.ORDER_AMOUNT,
               T.W_UPDATE_DT        = S.W_UPDATE_DT
      WHEN NOT MATCHED THEN
        INSERT
          (T.MONTH_KEY,
           T.SNAME,
           T.REG_MEMBER_COUNT,
           T.ORDER_MEMBER_COUNT,
           T.ORDER_AMOUNT,
           T.W_INSERT_DT,
           T.W_UPDATE_DT)
        VALUES
          (S.MONTH_KEY,
           S.SNAME,
           S.REG_MEMBER_COUNT,
           S.ORDER_MEMBER_COUNT,
           S.ORDER_AMOUNT,
           S.W_INSERT_DT,
           S.W_UPDATE_DT);
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
    END;
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_DEL := DELETE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '输入参数IN_DATE_KEY:' || IN_DATE_KEY;
    S_ETL.ETL_DURATION   := TRUNC((S_ETL.END_TIME - S_ETL.START_TIME) *
                                  86400);
    SP_SBI_W_ETL_LOG(S_ETL);
  EXCEPTION
    WHEN OTHERS THEN
      S_ETL.END_TIME   := SYSDATE;
      S_ETL.ETL_STATUS := 'FAILURE';
      S_ETL.ERR_MSG    := SQLERRM;
      SP_SBI_W_ETL_LOG(S_ETL);
      RETURN;
  END OPER_MEMBER_SOURCE_REPORT_P;

  PROCEDURE OPER_MEMBER_REPUR_RRT_P(IN_DATE_KEY IN NUMBER) IS
    S_ETL                  W_ETL_LOG%ROWTYPE;
    SP_NAME                S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER            S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS            NUMBER;
    DELETE_ROWS            NUMBER;
    S_LAST_MONTH_LAST_DAY  DATE; /*上月最后一天*/
    S_LAST_MONTH_FIRST_DAY DATE; /*上月第一天*/
    /*
    功能说明：  
    作者时间：yangjin  2018-05-28
    */
  BEGIN
    SP_NAME          := 'YJ_REPORT.OPER_MEMBER_REPUR_RRT_P'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'OPER_MEMBER_REPURCHASE_RPT'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
  
    S_LAST_MONTH_LAST_DAY  := LAST_DAY(ADD_MONTHS(TO_DATE(IN_DATE_KEY,
                                                          'YYYYMMDD'),
                                                  -1));
    S_LAST_MONTH_FIRST_DAY := TRUNC(ADD_MONTHS(TO_DATE(IN_DATE_KEY,
                                                       'YYYYMMDD'),
                                               -1),
                                    'MONTH');
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.END_TIME := SYSDATE;
        S_ETL.ERR_MSG  := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
    
      MERGE INTO OPER_MEMBER_REPURCHASE_RPT T
      USING (SELECT C.MONTH_KEY,
                    C.ORDER_COUNT,
                    COUNT(C.CUST_NO) MEMBER_COUNT,
                    SUM(C.ORDER_AMOUNT) ORDER_AMOUNT,
                    SYSDATE W_INSERT_DT,
                    SYSDATE W_UPDATE_DT
               FROM (SELECT B.MONTH_KEY,
                            B.CUST_NO,
                            COUNT(B.ORDER_ID) ORDER_COUNT,
                            SUM(B.ORDER_AMOUNT) ORDER_AMOUNT
                       FROM (SELECT TO_CHAR(A.ADD_TIME, 'YYYYMM') MONTH_KEY,
                                    A.CUST_NO,
                                    A.ORDER_ID,
                                    A.ORDER_AMOUNT
                               FROM FACT_EC_ORDER_2 A
                              WHERE TRUNC(A.ADD_TIME) BETWEEN
                                    S_LAST_MONTH_FIRST_DAY AND
                                    S_LAST_MONTH_LAST_DAY
                                AND A.ORDER_STATE >= 20) B
                      GROUP BY B.MONTH_KEY, B.CUST_NO) C
              GROUP BY C.MONTH_KEY, C.ORDER_COUNT
              ORDER BY C.MONTH_KEY, C.ORDER_COUNT) S
      ON (T.MONTH_KEY = S.MONTH_KEY AND T.ORDER_COUNT = S.ORDER_COUNT)
      WHEN MATCHED THEN
        UPDATE
           SET T.MEMBER_COUNT = S.MEMBER_COUNT,
               T.ORDER_AMOUNT = S.ORDER_AMOUNT,
               T.W_UPDATE_DT  = S.W_UPDATE_DT
      WHEN NOT MATCHED THEN
        INSERT
          (T.MONTH_KEY,
           T.ORDER_COUNT,
           T.MEMBER_COUNT,
           T.ORDER_AMOUNT,
           T.W_INSERT_DT,
           T.W_UPDATE_DT)
        VALUES
          (S.MONTH_KEY,
           S.ORDER_COUNT,
           S.MEMBER_COUNT,
           S.ORDER_AMOUNT,
           S.W_INSERT_DT,
           S.W_UPDATE_DT);
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
    END;
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_DEL := DELETE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '输入参数IN_DATE_KEY:' || IN_DATE_KEY;
    S_ETL.ETL_DURATION   := TRUNC((S_ETL.END_TIME - S_ETL.START_TIME) *
                                  86400);
    SP_SBI_W_ETL_LOG(S_ETL);
  EXCEPTION
    WHEN OTHERS THEN
      S_ETL.END_TIME   := SYSDATE;
      S_ETL.ETL_STATUS := 'FAILURE';
      S_ETL.ERR_MSG    := SQLERRM;
      SP_SBI_W_ETL_LOG(S_ETL);
      RETURN;
  END OPER_MEMBER_REPUR_RRT_P;

  PROCEDURE OPER_EC_PRODUCT_SUMMARY_PROC(IN_DATE_KEY IN NUMBER) IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
    DELETE_ROWS NUMBER;
    /*
    功能说明：  
    作者时间：yangjin  2018-07-06
    */
  BEGIN
    SP_NAME          := 'YJ_REPORT.OPER_EC_PRODUCT_SUMMARY_PROC'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'OPER_EC_PRODUCT_SUMMARY_REPORT'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.END_TIME := SYSDATE;
        S_ETL.ERR_MSG  := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
      EXECUTE IMMEDIATE 'TRUNCATE TABLE OPER_EC_PRODUCT_SUMMARY_TMP';
      /*插入中间表*/
      INSERT INTO OPER_EC_PRODUCT_SUMMARY_TMP
        (GOODS_ID,
         ITEM_CODE,
         ERP_CODE,
         GOODS_NAME,
         BRAND_NAME,
         SUPPLIER_ID,
         SUPPLIER_NAME,
         MD,
         GC_NAME,
         COST_PRICE,
         VALID_DATE,
         GOODS_PRICE,
         PROFIT_RATE,
         PROFIT_AMOUNT,
         GOODS_MARKETPRICE,
         REPORT_DATE,
         FIRSTONSELLTIME,
         IS_SHIPPING_SELF,
         GOODS_STORAGE,
         ORDER_QTY,
         ORDER_AMOUNT,
         LAST_3D_ORDER_QTY,
         LAST_7D_ORDER_QTY,
         LAST_10D_ORDER_QTY)
        WITH DIM AS
         (SELECT A.GOODS_ID,
                 A.ITEM_CODE /*商品编号（SPU）*/,
                 A.ERP_CODE /*商品编号（SKU）*/,
                 A.GOODS_NAME /*商品名称*/,
                 B.BRAND_NAME /*品牌*/,
                 A.SUPPLIER_ID /*供应商编号*/,
                 A.SUPPLIER_NAME /*供应商名称*/,
                 C.MD /*MD*/,
                 D.GC_NAME /*品类*/,
                 C1.COST_PRICE /*供货价*/,
                 TO_NUMBER(C1.VALID_DATE) VALID_DATE /*供货价有效期*/,
                 A.GOODS_PRICE /*快乐价*/,
                 DECODE(NVL(A.GOODS_PRICE, 0),
                        0,
                        0,
                        (NVL(A.GOODS_PRICE, 0) - NVL(C1.COST_PRICE, 0)) /
                        NVL(A.GOODS_PRICE, 0)) PROFIT_RATE /*毛利率*/,
                 NVL(A.GOODS_PRICE, 0) - NVL(C1.COST_PRICE, 0) PROFIT_AMOUNT /*毛利额*/,
                 A.GOODS_MARKETPRICE /*市场价*/,
                 TO_NUMBER(C1.REPORT_DATE) REPORT_DATE /*提报日期*/,
                 E.FIRSTONSELLTIME /*首次上架时间*/,
                 CASE
                   WHEN A.IS_SHIPPING_SELF = 0 THEN
                    '直配送'
                   WHEN A.IS_SHIPPING_SELF = 1 THEN
                    '入库'
                 END IS_SHIPPING_SELF /*配送方式*/,
                 A.GOODS_STORAGE /*库存数量*/
            FROM FACT_EC_GOODS A,
                 DIM_EC_BRAND B,
                 DIM_GOOD C,
                 DIM_GOOD_CLASS D,
                 FACT_EC_GOODS_COMMON E,
                 (SELECT C3.ITEM_CODE,
                         C3.COST_PRICE,
                         C3.REPORT_DATE,
                         C3.VALID_DATE,
                         C3.CREATE_DATE,
                         C3.SALE_PRICE
                    FROM (SELECT C2.ITEM_CODE,
                                 C2.COST_PRICE,
                                 C2.REPORT_DATE,
                                 C2.VALID_DATE,
                                 C2.CREATE_DATE,
                                 C2.SALE_PRICE,
                                 ROW_NUMBER() OVER(PARTITION BY C2.ITEM_CODE ORDER BY C2.REPORT_DATE DESC) RN
                            FROM DIM_GOOD_COST C2
                           WHERE C2.VALID_DATE =
                                 TRANSLATE(C2.VALID_DATE,
                                           '0' || TRANSLATE(C2.VALID_DATE,
                                                            '#0123456789',
                                                            '#'),
                                           '0')) C3
                   WHERE C3.RN = 1) C1,
                 (SELECT M2.ITEM_CODE, M2.MD
                    FROM (SELECT M1.ITEM_CODE,
                                 M1.MD,
                                 M1.INSERT_DATE,
                                 ROW_NUMBER() OVER(PARTITION BY M1.ITEM_CODE ORDER BY M1.MD DESC, M1.INSERT_DATE DESC) RN
                            FROM DIM_GOOD_MD M1) M2
                   WHERE M2.RN = 1) M
           WHERE A.BRAND_ID = B.BRAND_ID(+)
             AND A.GOODS_COMMONID = C.GOODS_COMMONID(+)
             AND C.MATL_GROUP = D.MATKL(+)
             AND A.GOODS_COMMONID = E.GOODS_COMMONID(+)
             AND A.ITEM_CODE = M.ITEM_CODE(+)
             AND A.ITEM_CODE = C1.ITEM_CODE(+)
             AND C.CURRENT_FLG = 'Y'),
        ORD AS /*订购*/
         (SELECT H.GOODS_ID,
                 SUM(H.ORDER_QTY) ORDER_QTY,
                 SUM(H.ORDER_AMOUNT) ORDER_AMOUNT,
                 SUM(H.LAST_3D_ORDER_QTY) LAST_3D_ORDER_QTY,
                 SUM(H.LAST_7D_ORDER_QTY) LAST_7D_ORDER_QTY,
                 SUM(H.LAST_10D_ORDER_QTY) LAST_10D_ORDER_QTY
            FROM (SELECT TO_CHAR(F.ADD_TIME, 'YYYYMMDD') ORDER_DATE,
                         G.GOODS_ID,
                         G.GOODS_NUM ORDER_QTY,
                         G.GOODS_NUM * G.GOODS_PAY_PRICE ORDER_AMOUNT,
                         /*近三天订购件数*/
                         CASE
                           WHEN TRUNC(F.ADD_TIME) >= TRUNC(SYSDATE) - 3 THEN
                            G.GOODS_NUM
                           ELSE
                            0
                         END LAST_3D_ORDER_QTY,
                         /*近七天订购件数*/
                         CASE
                           WHEN TRUNC(F.ADD_TIME) >= TRUNC(SYSDATE) - 7 THEN
                            G.GOODS_NUM
                           ELSE
                            0
                         END LAST_7D_ORDER_QTY,
                         /*近十天订购件数*/
                         CASE
                           WHEN TRUNC(F.ADD_TIME) >= TRUNC(SYSDATE) - 10 THEN
                            G.GOODS_NUM
                           ELSE
                            0
                         END LAST_10D_ORDER_QTY
                    FROM FACT_EC_ORDER_2 F, FACT_EC_ORDER_GOODS G
                   WHERE F.ORDER_ID = G.ORDER_ID
                     AND F.ORDER_STATE >= 20) H
           GROUP BY H.GOODS_ID)
        SELECT DIM.GOODS_ID,
               DIM.ITEM_CODE,
               DIM.ERP_CODE,
               DIM.GOODS_NAME,
               DIM.BRAND_NAME,
               DIM.SUPPLIER_ID,
               DIM.SUPPLIER_NAME,
               DIM.MD,
               DIM.GC_NAME,
               DIM.COST_PRICE,
               DIM.VALID_DATE,
               DIM.GOODS_PRICE,
               DIM.PROFIT_RATE,
               DIM.PROFIT_AMOUNT,
               DIM.GOODS_MARKETPRICE,
               DIM.REPORT_DATE,
               DIM.FIRSTONSELLTIME,
               DIM.IS_SHIPPING_SELF,
               DIM.GOODS_STORAGE,
               ORD.ORDER_QTY,
               ORD.ORDER_AMOUNT,
               ORD.LAST_3D_ORDER_QTY,
               ORD.LAST_7D_ORDER_QTY,
               ORD.LAST_10D_ORDER_QTY
          FROM DIM, ORD
         WHERE DIM.GOODS_ID = ORD.GOODS_ID(+);
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
      /*merge进报表*/
      MERGE INTO OPER_EC_PRODUCT_SUMMARY_REPORT T
      USING (SELECT A.GOODS_ID,
                    A.ITEM_CODE,
                    A.ERP_CODE,
                    A.GOODS_NAME,
                    A.BRAND_NAME,
                    A.SUPPLIER_ID,
                    A.SUPPLIER_NAME,
                    A.MD,
                    A.GC_NAME,
                    A.COST_PRICE,
                    A.VALID_DATE,
                    A.GOODS_PRICE,
                    A.PROFIT_RATE,
                    A.PROFIT_AMOUNT,
                    A.GOODS_MARKETPRICE,
                    A.REPORT_DATE,
                    A.FIRSTONSELLTIME,
                    A.IS_SHIPPING_SELF,
                    A.GOODS_STORAGE,
                    A.ORDER_QTY,
                    A.ORDER_AMOUNT,
                    A.LAST_3D_ORDER_QTY,
                    A.LAST_7D_ORDER_QTY,
                    A.LAST_10D_ORDER_QTY,
                    SYSDATE              W_INSERT_DT,
                    SYSDATE              W_UPDATE_DT
               FROM OPER_EC_PRODUCT_SUMMARY_TMP A) S
      ON (T.GOODS_ID = S.GOODS_ID)
      WHEN MATCHED THEN
        UPDATE
           SET T.ITEM_CODE          = S.ITEM_CODE,
               T.ERP_CODE           = S.ERP_CODE,
               T.GOODS_NAME         = S.GOODS_NAME,
               T.BRAND_NAME         = S.BRAND_NAME,
               T.SUPPLIER_ID        = S.SUPPLIER_ID,
               T.SUPPLIER_NAME      = S.SUPPLIER_NAME,
               T.MD                 = S.MD,
               T.GC_NAME            = S.GC_NAME,
               T.COST_PRICE         = S.COST_PRICE,
               T.VALID_DATE         = S.VALID_DATE,
               T.GOODS_PRICE        = S.GOODS_PRICE,
               T.PROFIT_RATE        = S.PROFIT_RATE,
               T.PROFIT_AMOUNT      = S.PROFIT_AMOUNT,
               T.GOODS_MARKETPRICE  = S.GOODS_MARKETPRICE,
               T.REPORT_DATE        = S.REPORT_DATE,
               T.FIRSTONSELLTIME    = S.FIRSTONSELLTIME,
               T.IS_SHIPPING_SELF   = S.IS_SHIPPING_SELF,
               T.GOODS_STORAGE      = S.GOODS_STORAGE,
               T.ORDER_QTY          = S.ORDER_QTY,
               T.ORDER_AMOUNT       = S.ORDER_AMOUNT,
               T.LAST_3D_ORDER_QTY  = S.LAST_3D_ORDER_QTY,
               T.LAST_7D_ORDER_QTY  = S.LAST_7D_ORDER_QTY,
               T.LAST_10D_ORDER_QTY = S.LAST_10D_ORDER_QTY,
               T.W_UPDATE_DT        = S.W_UPDATE_DT
      WHEN NOT MATCHED THEN
        INSERT
          (T.GOODS_ID,
           T.ITEM_CODE,
           T.ERP_CODE,
           T.GOODS_NAME,
           T.BRAND_NAME,
           T.SUPPLIER_ID,
           T.SUPPLIER_NAME,
           T.MD,
           T.GC_NAME,
           T.COST_PRICE,
           T.VALID_DATE,
           T.GOODS_PRICE,
           T.PROFIT_RATE,
           T.PROFIT_AMOUNT,
           T.GOODS_MARKETPRICE,
           T.REPORT_DATE,
           T.FIRSTONSELLTIME,
           T.IS_SHIPPING_SELF,
           T.GOODS_STORAGE,
           T.ORDER_QTY,
           T.ORDER_AMOUNT,
           T.LAST_3D_ORDER_QTY,
           T.LAST_7D_ORDER_QTY,
           T.LAST_10D_ORDER_QTY,
           T.W_INSERT_DT,
           T.W_UPDATE_DT)
        VALUES
          (S.GOODS_ID,
           S.ITEM_CODE,
           S.ERP_CODE,
           S.GOODS_NAME,
           S.BRAND_NAME,
           S.SUPPLIER_ID,
           S.SUPPLIER_NAME,
           S.MD,
           S.GC_NAME,
           S.COST_PRICE,
           S.VALID_DATE,
           S.GOODS_PRICE,
           S.PROFIT_RATE,
           S.PROFIT_AMOUNT,
           S.GOODS_MARKETPRICE,
           S.REPORT_DATE,
           S.FIRSTONSELLTIME,
           S.IS_SHIPPING_SELF,
           S.GOODS_STORAGE,
           S.ORDER_QTY,
           S.ORDER_AMOUNT,
           S.LAST_3D_ORDER_QTY,
           S.LAST_7D_ORDER_QTY,
           S.LAST_10D_ORDER_QTY,
           S.W_INSERT_DT,
           S.W_UPDATE_DT);
      UPDATE_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
    END;
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_UPD := UPDATE_ROWS;
    S_ETL.ETL_RECORD_DEL := DELETE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '输入参数IN_DATE_KEY:' || IN_DATE_KEY;
    S_ETL.ETL_DURATION   := TRUNC((S_ETL.END_TIME - S_ETL.START_TIME) *
                                  86400);
    SP_SBI_W_ETL_LOG(S_ETL);
  EXCEPTION
    WHEN OTHERS THEN
      S_ETL.END_TIME   := SYSDATE;
      S_ETL.ETL_STATUS := 'FAILURE';
      S_ETL.ERR_MSG    := SQLERRM;
      SP_SBI_W_ETL_LOG(S_ETL);
      RETURN;
  END OPER_EC_PRODUCT_SUMMARY_PROC;

  PROCEDURE OPER_MOBILEHOME_REPORT_PROC(IN_DATE_KEY IN NUMBER) IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
    DELETE_ROWS NUMBER;
    /*
    功能说明：  
    作者时间：yangjin  2018-07-24
    */
  BEGIN
    SP_NAME          := 'YJ_REPORT.OPER_MOBILEHOME_REPORT_PROC'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'OPER_MOBILEHOME_REPORT'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.END_TIME := SYSDATE;
        S_ETL.ERR_MSG  := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
      DELETE OPER_MOBILEHOME_REPORT A
       WHERE A.VISIT_DATE = TO_DATE(IN_DATE_KEY, 'YYYYMMDD');
      COMMIT;
      /*插入报表*/
      INSERT INTO OPER_MOBILEHOME_REPORT
        (VISIT_DATE,
         UV,
         ZC,
         ZD,
         YXRS,
         YXDS,
         YXJE,
         W_INSERT_DT,
         W_UPDATE_DT)
        SELECT TO_DATE(VISIT_DATE_KEY, 'YYYYMMDD') VISIT_DATE,
               UV,
               ZC,
               ZD,
               YXRS,
               YXDS,
               YXJE,
               SYSDATE W_INSERT_DT,
               SYSDATE W_UPDATE_DT
          FROM (SELECT COUNT(DISTINCT IP) UV,
                       COUNT(DISTINCT C.MEMBER_KEY) ZC,
                       VISIT_DATE_KEY
                  FROM (SELECT VID, IP, VISIT_DATE_KEY
                          FROM FACT_PAGE_VIEW
                         WHERE VISIT_DATE_KEY = IN_DATE_KEY
                           AND PAGE_NAME = 'MobileHome'
                           AND APPLICATION_KEY = 30
                         GROUP BY VID, IP, VISIT_DATE_KEY) A
                  LEFT JOIN
                
                 (SELECT VID, FIST_IP, START_DATE_KEY, MEMBER_KEY
                   FROM (SELECT VID, FIST_IP, START_DATE_KEY, MEMBER_KEY
                           FROM FACT_SESSION
                          WHERE START_DATE_KEY = IN_DATE_KEY
                            AND APPLICATION_KEY = 30) S
                   JOIN (SELECT MEMBER_CRMBP, MEMBER_TIME
                          FROM FACT_ECMEMBER
                         WHERE MEMBER_TIME = IN_DATE_KEY) SS
                     ON S.MEMBER_KEY = SS.MEMBER_CRMBP
                    AND S.START_DATE_KEY = SS.MEMBER_TIME
                  GROUP BY VID, FIST_IP, START_DATE_KEY, MEMBER_KEY) C
                    ON
                
                 (A.IP = C.FIST_IP AND A.VISIT_DATE_KEY = C.START_DATE_KEY)
                
                 GROUP BY VISIT_DATE_KEY) S
          LEFT JOIN (SELECT COUNT(DISTINCT VID) ZD, ADD_TIME
                       FROM FACTEC_ORDER
                      WHERE ADD_TIME = IN_DATE_KEY
                        AND ORDER_FROM = 83
                      GROUP BY ADD_TIME) SS
            ON S.VISIT_DATE_KEY = SS.ADD_TIME
        
          LEFT JOIN (SELECT COUNT(DISTINCT VID) YXRS,
                            COUNT(1) YXDS,
                            SUM(ORDER_AMOUNT) YXJE,
                            ADD_TIME
                       FROM FACTEC_ORDER
                      WHERE ADD_TIME = IN_DATE_KEY
                        AND ORDER_FROM = 83
                        AND ORDER_STATE > 10
                      GROUP BY ADD_TIME) SSS
            ON S.VISIT_DATE_KEY = SSS.ADD_TIME;
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
    END;
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_UPD := UPDATE_ROWS;
    S_ETL.ETL_RECORD_DEL := DELETE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '输入参数IN_DATE_KEY:' || IN_DATE_KEY;
    S_ETL.ETL_DURATION   := TRUNC((S_ETL.END_TIME - S_ETL.START_TIME) *
                                  86400);
    SP_SBI_W_ETL_LOG(S_ETL);
  EXCEPTION
    WHEN OTHERS THEN
      S_ETL.END_TIME   := SYSDATE;
      S_ETL.ETL_STATUS := 'FAILURE';
      S_ETL.ERR_MSG    := SQLERRM;
      SP_SBI_W_ETL_LOG(S_ETL);
      RETURN;
  END OPER_MOBILEHOME_REPORT_PROC;

END YJ_REPORT;
/

