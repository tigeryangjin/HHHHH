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

  PROCEDURE OPER_EC_PRODUCT_SUMMARY_PROC(IN_DATE_KEY IN NUMBER);
  /*
  ������:       OPER_EC_PRODUCT_SUMMARY_PROC
  Ŀ��:         �ڼ���Ʒ���ܱ���
  ����:         yangjin
  ����ʱ�䣺    2018/07/06
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE OPER_MOBILEHOME_REPORT_PROC(IN_DATE_KEY IN NUMBER);
  /*
  ������:       OPER_MOBILEHOME_REPORT_PROC
  Ŀ��:         �ڼ���Ʒ���ܱ���
  ����:         yangjin
  ����ʱ�䣺    2018/07/06
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
                       FROM FACT_PAGE_VIEW
                      WHERE VISIT_DATE BETWEEN
                            TO_DATE(S_AGO_2_MONTH_FIRST_DAY_KEY, 'YYYYMMDD') AND
                            TO_DATE(S_LAST_MONTH_LAST_DAY_KEY, 'YYYYMMDD')) A1,
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

  PROCEDURE OPER_EC_PRODUCT_SUMMARY_PROC(IN_DATE_KEY IN NUMBER) IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
    DELETE_ROWS NUMBER;
    /*
    ����˵����  
    ����ʱ�䣺yangjin  2018-07-06
    */
  BEGIN
    SP_NAME          := 'YJ_REPORT.OPER_EC_PRODUCT_SUMMARY_PROC'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME := 'OPER_EC_PRODUCT_SUMMARY_REPORT'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı��
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
  
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
      EXECUTE IMMEDIATE 'TRUNCATE TABLE OPER_EC_PRODUCT_SUMMARY_TMP';
      /*�����м��*/
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
                 A.ITEM_CODE /*��Ʒ��ţ�SPU��*/,
                 A.ERP_CODE /*��Ʒ��ţ�SKU��*/,
                 A.GOODS_NAME /*��Ʒ����*/,
                 B.BRAND_NAME /*Ʒ��*/,
                 A.SUPPLIER_ID /*��Ӧ�̱��*/,
                 A.SUPPLIER_NAME /*��Ӧ������*/,
                 C.MD /*MD*/,
                 D.GC_NAME /*Ʒ��*/,
                 C1.COST_PRICE /*������*/,
                 TO_NUMBER(C1.VALID_DATE) VALID_DATE /*��������Ч��*/,
                 A.GOODS_PRICE /*���ּ�*/,
                 DECODE(NVL(A.GOODS_PRICE, 0),
                        0,
                        0,
                        (NVL(A.GOODS_PRICE, 0) - NVL(C1.COST_PRICE, 0)) /
                        NVL(A.GOODS_PRICE, 0)) PROFIT_RATE /*ë����*/,
                 NVL(A.GOODS_PRICE, 0) - NVL(C1.COST_PRICE, 0) PROFIT_AMOUNT /*ë����*/,
                 A.GOODS_MARKETPRICE /*�г���*/,
                 TO_NUMBER(C1.REPORT_DATE) REPORT_DATE /*�ᱨ����*/,
                 E.FIRSTONSELLTIME /*�״��ϼ�ʱ��*/,
                 CASE
                   WHEN A.IS_SHIPPING_SELF = 0 THEN
                    'ֱ����'
                   WHEN A.IS_SHIPPING_SELF = 1 THEN
                    '���'
                 END IS_SHIPPING_SELF /*���ͷ�ʽ*/,
                 A.GOODS_STORAGE /*�������*/
            FROM FACT_EC_GOODS A,
                 DIM_EC_BRAND B,
                 DIM_GOOD C,
                 DIM_GOOD_CLASS D,
                 FACT_EC_GOODS_COMMON E,
                 DIM_GOOD_COST C1,
                 (SELECT M1.ITEM_CODE, M1.MD
                    FROM DIM_GOOD_MD M1
                   WHERE NOT EXISTS
                   (SELECT 1
                            FROM (SELECT M3.ITEM_CODE, COUNT(1)
                                    FROM (SELECT DISTINCT M4.ITEM_CODE, M4.MD
                                            FROM DIM_GOOD_MD M4) M3
                                   GROUP BY M3.ITEM_CODE
                                  HAVING COUNT(1) > 1) M2
                           WHERE M1.ITEM_CODE = M2.ITEM_CODE)) M
           WHERE A.BRAND_ID = B.BRAND_ID(+)
             AND A.GOODS_COMMONID = C.GOODS_COMMONID(+)
             AND C.MATL_GROUP = D.MATKL(+)
             AND A.GOODS_COMMONID = E.GOODS_COMMONID(+)
             AND A.ITEM_CODE = M.ITEM_CODE(+)
             AND A.ITEM_CODE = C1.ITEM_CODE(+)
             AND C1.VALID_DATE =
                 TRANSLATE(C1.VALID_DATE,
                           '0' ||
                           TRANSLATE(C1.VALID_DATE, '#0123456789', '#'),
                           '0')
             AND C.CURRENT_FLG = 'Y'),
        ORD AS /*����*/
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
                         /*�����충������*/
                         CASE
                           WHEN TRUNC(F.ADD_TIME) >= TRUNC(SYSDATE) - 3 THEN
                            G.GOODS_NUM
                           ELSE
                            0
                         END LAST_3D_ORDER_QTY,
                         /*�����충������*/
                         CASE
                           WHEN TRUNC(F.ADD_TIME) >= TRUNC(SYSDATE) - 7 THEN
                            G.GOODS_NUM
                           ELSE
                            0
                         END LAST_7D_ORDER_QTY,
                         /*��ʮ�충������*/
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
    
      /*merge������*/
      MERGE /*+APPEND*/
      INTO OPER_EC_PRODUCT_SUMMARY_REPORT T
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
    /*��־��¼ģ��*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_UPD := UPDATE_ROWS;
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
  END OPER_EC_PRODUCT_SUMMARY_PROC;

  PROCEDURE OPER_MOBILEHOME_REPORT_PROC(IN_DATE_KEY IN NUMBER) IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
    DELETE_ROWS NUMBER;
    /*
    ����˵����  
    ����ʱ�䣺yangjin  2018-07-24
    */
  BEGIN
    SP_NAME          := 'YJ_REPORT.OPER_MOBILEHOME_REPORT_PROC'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME := 'OPER_MOBILEHOME_REPORT'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı��
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
  
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
      DELETE OPER_MOBILEHOME_REPORT A
       WHERE A.VISIT_DATE = TO_DATE(IN_DATE_KEY, 'YYYYMMDD');
      COMMIT;
      /*���뱨��*/
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
    /*��־��¼ģ��*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_UPD := UPDATE_ROWS;
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
  END OPER_MOBILEHOME_REPORT_PROC;

END YJ_REPORT;
/
