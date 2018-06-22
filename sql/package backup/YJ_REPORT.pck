CREATE OR REPLACE PACKAGE YJ_REPORT IS

  -- AUTHOR  : YANGJIN
  -- CREATED : 2017-09-21 14:40:49
  -- PURPOSE : ��Ʒ��ǩPACKAGE

  PROCEDURE OPER_ACTIVE_MEMBER_REPORT_P(IN_DATE_KEY IN NUMBER);
  /*
  ������:       OPER_ACTIVE_MEMBER_REPORT_P
  Ŀ��:         ��ý�������±�-��Ծ��Ա
  ����:         yangjin
  ����ʱ�䣺    2018/05/29
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE OPER_MEMBER_SOURCE_REPORT_P(IN_DATE_KEY IN NUMBER);
  /*
  ������:       OPER_MEMBER_SOURCE_REPORT_P
  Ŀ��:         ��ý�������±�-������Դ
  ����:         yangjin
  ����ʱ�䣺    2018/05/29
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE OPER_MEMBER_REPUR_RRT_P(IN_DATE_KEY IN NUMBER);
  /*
  ������:       OPER_MEMBER_REPUR_RRT_P
  Ŀ��:         ��ý�������±�-��Ա����Ƶ��
  ����:         yangjin
  ����ʱ�䣺    2018/05/29
  ����޸��ˣ�
  ���������ڣ�
  */

END YJ_REPORT;
/
CREATE OR REPLACE PACKAGE BODY YJ_REPORT IS

  PROCEDURE OPER_ACTIVE_MEMBER_REPORT_P(IN_DATE_KEY IN NUMBER) IS
    S_ETL                       W_ETL_LOG%ROWTYPE;
    SP_NAME                     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER                 S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS                 NUMBER;
    DELETE_ROWS                 NUMBER;
    S_MONTH_KEY                 NUMBER; /*�����·�KEY*/
    S_AGO_2_MONTH_FIRST_DAY_KEY NUMBER; /*������µĵ�һ��*/
    S_AGO_2_MONTH_LAST_DAY_KEY  NUMBER; /*������µ����һ��*/
    S_AGO_3_MONTH_FIRST_DAY_KEY NUMBER; /*�������µĵ�һ��*/
    S_AGO_3_MONTH_LAST_DAY_KEY  NUMBER; /*�������µ����һ��*/
    S_AGO_4_MONTH_LAST_DAY_KEY  NUMBER; /*���ĸ��µ����һ��*/
    S_LAST_MONTH_LAST_DAY_KEY   NUMBER; /*�������һ��*/
    S_LAST_MONTH_FIRST_DAY_KEY  NUMBER; /*���µ�һ��*/
    /*
    ����˵����  
    ����ʱ�䣺yangjin  2018-05-28
    */
  BEGIN
    SP_NAME                     := 'YJ_REPORT.OPER_ACTIVE_MEMBER_REPORT'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME            := 'OPER_ACTIVE_MEMBER_REPORT'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı��
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
        S_ETL.ERR_MSG  := 'û���ҵ���Ӧ�Ĺ��̼�����������';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
    
      MERGE /*+APPEND*/
      INTO OPER_ACTIVE_MEMBER_REPORT T
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
                       FROM FACT_SESSION
                      WHERE START_DATE_KEY BETWEEN
                            S_AGO_2_MONTH_FIRST_DAY_KEY AND
                            S_LAST_MONTH_LAST_DAY_KEY) A1,
                    --A2
                    (SELECT S_MONTH_KEY MONTH_KEY, COUNT(1) NEW_MEMBER_COUNT
                       FROM FACT_ECMEMBER
                      WHERE MEMBER_TIME BETWEEN S_LAST_MONTH_FIRST_DAY_KEY AND
                            S_LAST_MONTH_LAST_DAY_KEY) A2,
                    --A3
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
                    --A4
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
                    --A7
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
                    --A8
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
    /*��־��¼ģ��*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_DEL := DELETE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '�������IN_DATE_KEY:' || IN_DATE_KEY;
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
    S_LAST_MONTH_LAST_DAY_KEY  NUMBER; /*�������һ��*/
    S_LAST_MONTH_FIRST_DAY_KEY NUMBER; /*���µ�һ��*/
    /*
    ����˵����  
    ����ʱ�䣺yangjin  2018-05-28
    */
  BEGIN
    SP_NAME          := 'YJ_REPORT.OPER_MEMBER_SOURCE_REPORT_P'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME := 'OPER_MEMBER_SOURCE_REPORT'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı��
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
        S_ETL.ERR_MSG  := 'û���ҵ���Ӧ�Ĺ��̼�����������';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
    
      MERGE /*+APPEND*/
      INTO OPER_MEMBER_SOURCE_REPORT T
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
                              WHEN A1.M_LABEL_DESC = '�ƹ�' THEN
                               '�ƹ�����'
                              WHEN A1.M_LABEL_DESC = 'ɨ��' THEN
                               '�ڲ�����'
                              WHEN A1.M_LABEL_DESC = '��Ȼ' AND
                                   A1.REGISTER_RESOURCE = 'TV' THEN
                               '�ڲ�����'
                              ELSE
                               '��Ȼ����'
                            END SNAME,
                            CASE
                              WHEN A1.ORDER_AMOUNT > 0 THEN
                               1
                              ELSE
                               0
                            END IS_ORDER,
                            A1.ORDER_AMOUNT
                       FROM (SELECT A.MEMBER_KEY,
                                    NVL(B.M_LABEL_DESC, '��Ȼ') M_LABEL_DESC,
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
    /*��־��¼ģ��*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_DEL := DELETE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '�������IN_DATE_KEY:' || IN_DATE_KEY;
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
    S_LAST_MONTH_LAST_DAY  DATE; /*�������һ��*/
    S_LAST_MONTH_FIRST_DAY DATE; /*���µ�һ��*/
    /*
    ����˵����  
    ����ʱ�䣺yangjin  2018-05-28
    */
  BEGIN
    SP_NAME          := 'YJ_REPORT.OPER_MEMBER_REPUR_RRT_P'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME := 'OPER_MEMBER_REPURCHASE_RPT'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı��
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
        S_ETL.ERR_MSG  := 'û���ҵ���Ӧ�Ĺ��̼�����������';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
    
      MERGE /*+APPEND*/
      INTO OPER_MEMBER_REPURCHASE_RPT T
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
    /*��־��¼ģ��*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_DEL := DELETE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '�������IN_DATE_KEY:' || IN_DATE_KEY;
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

END YJ_REPORT;
/
