CREATE OR REPLACE PACKAGE MEMBER_LABEL_PKG IS

  -- AUTHOR  : YANGJIN
  -- CREATED : 2017-08-03 
  -- PURPOSE : MEMBER SMS POOL PACKAGE

  FUNCTION MEMBER_REPURCHASE_CYCLE_DAYS(IN_MEMBER_KEY IN NUMBER)
    RETURN NUMBER;
  /*
  ��������      MEMBER_REPURCHASE_CYCLE_DAYS
  Ŀ�ģ�        ���ػ�Ա�ĸ������ڣ�������
  ����ʱ�䣺    2017/08/17
  ����:         yangjin
  ����ʱ�䣺    2017/08/24
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE CREATE_MEMBER_LABEL(IN_M_LABEL_NAME      IN VARCHAR2,
                                IN_M_LABEL_DESC      IN VARCHAR2,
                                IN_M_LABEL_TYPE_ID   IN NUMBER,
                                IN_M_LABEL_FATHER_ID IN NUMBER);
  /*
  ������:       CREATE_MEMBER_LABEL
  Ŀ��:         �½���ǩ����MEMBER_LABEL_HEAD
  ����:         yangjin
  ����ʱ�䣺    2017/08/17
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE ONLY_BROADCAST(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  ������:       ONLY_BROADCAST
  Ŀ��:         ֻ�򲥳���Ʒ(ONLY_BROADCAST)
                ͳ�����180��Ķ������û�������>=4,���Ҷ����Ĳ�����Ʒռ�ȴﵽ70%
  ����:         yangjin
  ����ʱ�䣺    2017/08/10
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE ONLY_TV(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  ������:       ONLY_TV
  Ŀ��:         ֻ��TV��Ʒ(ONLY_TV)
                ͳ�����180��Ķ������û�������>=4,���Ҷ����Ĳ�����Ʒռ�ȴﵽ70%
  ����:         yangjin
  ����ʱ�䣺    2017/08/10
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE ONLY_ONLINE_RETAIL(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  ������:       ONLY_ONLINE_RETAIL
  Ŀ��:         ֻ�������Ʒ(ONLY_ONLINE_RETAIL)
                ͳ�����180��Ķ������û�������>=4,���Ҷ����Ĳ�����Ʒռ�ȴﵽ70%
  ����:         yangjin
  ����ʱ�䣺    2017/08/10
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE ONLY_SELF_SALES(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  ������:       IS_SELF_SALES
  Ŀ��:         �Ƿ�ֻ����Ӫ��Ʒ
              ֻ����Ӫ��Ʒ(SELF_SALES)
              ֻ�����Ӫ��Ʒ(NON_SELF_SALES)
                ͳ�����180��Ķ������û�������>=4,���Ҷ����Ĳ�����Ʒռ�ȴﵽ70%
  ����:         yangjin
  ����ʱ�䣺    2017/08/10
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE MIXED_CUSTOMER(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  ������:       MIXED_CUSTOMER
  Ŀ��:         ����ͻ�Ա
                ͳ�����180��Ķ������û�������>=4�������������κ�����ʱ
  ����:         yangjin
  ����ʱ�䣺    2017/08/10
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE TOP_ITEM_LOYALTY(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  ������:       ITEM_LOYALTY
  Ŀ��:         ֱ����Ʒ�ҳ϶�(6����ǩ)
  ����:         yangjin
  ����ʱ�䣺    2017/08/10
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE COMMON_PORT(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  ������:       COMMON_PORT
  Ŀ��:         ���ö˿�(5����ǩ)
                ͳ�����180���FACT_SESSION
                APP(COMMON_PORT_APP)(10,20,)
                ΢��(COMMON_PORT_WX)(50)
                WAP(COMMON_PORT_WAP)(30)
                PC(COMMON_PORT_PC)(40)
                �޹���(COMMON_PORT_VARIETY)
  ����:         yangjin
  ����ʱ�䣺    2017/08/16
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE FIRST_ORDER_NOT(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  ������:       FIRST_ORDER_NOT
  Ŀ��:         �׵���ǩ-δ�����׵�
  ����:         yangjin
  ����ʱ�䣺    2017/08/17
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE FIRST_ORDER_GIFT(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  ������:       FIRST_ORDER_NOT
  Ŀ��:         �׵���ǩ-�׵�Ϊ������
  ����:         yangjin
  ����ʱ�䣺    2017/08/17
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE FIRST_ORDER_ITEM(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  ������:       FIRST_ORDER_ITEM
  Ŀ��:         �׵���ǩ-�׵�ΪTV������Ʒ(FIRST_ORDER_BROADCAST)
                         �׵�ΪTV�ǲ�����Ʒ(FIRST_ORDER_NOT_BROADCAST)
                         �׵�Ϊ��Ӫ��Ʒ(FIRST_ORDER_SELF)
                         �׵�ΪBBC��Ʒ(FIRST_ORDER_BBC)
  ����:         yangjin
  ����ʱ�䣺    2017/08/21
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE FIRST_ORDER_MAIN(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  ������:       FIRST_ORDER_MAIN
  Ŀ��:         �׵���ǩ-������
  ����:         yangjin
  ����ʱ�䣺    2017/08/22
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE MEMBER_LEVEL(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  ������:       MEMBER_LEVEL
  Ŀ��:         ��Ա�ȼ�
  ����:         yangjin
  ����ʱ�䣺    2017/08/29
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE MEMBER_REPURCHASE(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  ������:       MEMBER_REPURCHASE
  Ŀ��:         ��Ա�������ڣ��죩
                REPURCHASE_CYCLE_LEVEL_1:-1
                REPURCHASE_CYCLE_LEVEL_2:0~30
                REPURCHASE_CYCLE_LEVEL_3:30~60
                REPURCHASE_CYCLE_LEVEL_4:60~90
                REPURCHASE_CYCLE_LEVEL_5:>90
  ����:         yangjin
  ����ʱ�䣺    2017/08/29
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE MEMBER_PAYMENT_METHOD(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  ������:       MEMBER_PAYMENT_METHOD
  Ŀ��:         ��Ա֧����ʽ
                ����COD(PAYMENT_COD)
                ����֧����(PAYMENT_ALIPAY)
                ����΢��֧��(PAYMENT_WX)
                �������п�֧��(PAYMENT_BANKCARD)
                ����֧��(PAYMENT_ONLINE)
  ����:         yangjin
  ����ʱ�䣺    2017/09/11
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE MEMBER_LIFE_PERIOD(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  ������:       MEMBER_LIFE_PERIOD
  Ŀ��:         MEMBER_LIFE_PERIOD   �û���������
                NEW_CUSTOMER_PERIOD  �¿ͣ�δ���������������ܶ�������
                TRIAL_PERIOD         �����ڣ�����������δ������Ч������
                UNDERSTANDING_PERIOD �˽��ڣ�����1~3����Ч������
                BELIEVE_PERIOD       �����ڣ�����4��6����Ч������
                GOOD_FRIEND_PERIOD   �������ڣ�����7��������Ч������
                INJURED_PERIOD       ���˺��ڣ������Ǹ���ԭ����ˡ����ߺ�δ������Ч��������
  ����:         yangjin
  ����ʱ�䣺    2017/09/26
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE MEMBER_INJURED_PERIOD(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  ������:       MEMBER_INJURED_PERIOD
  Ŀ��:         INJURED_PERIOD       ���˺��ڣ������Ǹ���ԭ����ˡ����ߺ�δ������Ч��������
  ����:         yangjin
  ����ʱ�䣺    2017/09/27
  ����޸��ˣ�
  ���������ڣ�
  */

END MEMBER_LABEL_PKG;
/
CREATE OR REPLACE PACKAGE BODY MEMBER_LABEL_PKG IS

  FUNCTION MEMBER_REPURCHASE_CYCLE_DAYS(IN_MEMBER_KEY IN NUMBER)
    RETURN NUMBER IS
    RESULT_DAYS NUMBER;
    /*���ػ�Ա�ĸ������ڣ�������*/
  BEGIN
    SELECT ROUND(NVL(SUM(C.POSTING_DATE - C.LAST_POSTING_DATE) /
                     COUNT(C.ORDER_KEY),
                     -1))
      INTO RESULT_DAYS
      FROM (SELECT B.MEMBER_KEY,
                   B.ORDER_KEY,
                   B.POSTING_DATE,
                   LAG(B.POSTING_DATE) OVER(PARTITION BY B.MEMBER_KEY ORDER BY B.POSTING_DATE) LAST_POSTING_DATE
              FROM (SELECT A.MEMBER_KEY,
                           TO_DATE(A.POSTING_DATE_KEY, 'yyyymmdd') POSTING_DATE,
                           A.ORDER_KEY
                      FROM MEMBER_LIFE_PERIOD_TMP_B A /*�˴�ʹ�û�Ա�������ڵ���ʱ������MEMBER_LABEL_PKG.MEMBER_LIFE_PERIOD����*/
                     WHERE A.ORDER_STATE = 1
                       AND A.MEMBER_KEY = IN_MEMBER_KEY
                          /*ֻȡ2016��֮�������*/
                       AND A.POSTING_DATE_KEY >= 20160101) B) C
     WHERE C.LAST_POSTING_DATE IS NOT NULL;
    RETURN(RESULT_DAYS);
  END MEMBER_REPURCHASE_CYCLE_DAYS;

  PROCEDURE CREATE_MEMBER_LABEL(IN_M_LABEL_NAME      IN VARCHAR2,
                                IN_M_LABEL_DESC      IN VARCHAR2,
                                IN_M_LABEL_TYPE_ID   IN NUMBER,
                                IN_M_LABEL_FATHER_ID IN NUMBER) IS
    /*
    ����˵�����½���ǩ����MEMBER_LABEL_HEAD
    ����ʱ�䣺yangjin  2017-08-17
    */
  BEGIN
    INSERT INTO MEMBER_LABEL_HEAD
      (M_LABEL_ID,
       M_LABEL_NAME,
       M_LABEL_DESC,
       M_LABEL_TYPE_ID,
       M_LABEL_FATHER_ID,
       CREATE_DATE,
       CREATE_USER_ID,
       LAST_UPDATE_DATE,
       LAST_UPDATE_USER_ID,
       CURRENT_FLAG)
      SELECT MEMBER_LABEL_HEAD_SEQ.NEXTVAL, /*M_LABEL_ID*/
             IN_M_LABEL_NAME, /*M_LABEL_NAME*/
             IN_M_LABEL_DESC, /*M_LABEL_DESC*/
             IN_M_LABEL_TYPE_ID, /*M_LABEL_TYPE_ID*/
             IN_M_LABEL_FATHER_ID, /*M_LABEL_FATHER_ID*/
             sysdate, /*CREATE_DATE*/
             'yangjin', /*CREATE_USER_ID*/
             sysdate, /*LAST_UPDATE_DATE*/
             'yangjin', /*LAST_UPDATE_USER_ID*/
             1 /*CURRENT_FLAG*/
        FROM DUAL;
    COMMIT;
  END CREATE_MEMBER_LABEL;

  PROCEDURE ONLY_BROADCAST(IN_POSTING_DATE_KEY IN NUMBER) IS
    S_ETL           W_ETL_LOG%ROWTYPE;
    SP_NAME         S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER     S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS     NUMBER;
    IN_POSTING_DATE DATE;
    /*
    ����˵����ֻ�򲥳���Ʒ(ONLY_BROADCAST)
              ͳ�����180��Ķ������û�������>=4,���Ҷ����Ĳ�����Ʒռ�ȴﵽ70%
    ����ʱ�䣺yangjin  2017-08-10
    */
  BEGIN
  
    SP_NAME          := 'MEMBER_LABEL_PKG.ONLY_BROADCAST'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME := 'MEMBER_LABEL_LINK'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı���
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    IN_POSTING_DATE  := TO_DATE(IN_POSTING_DATE_KEY, 'YYYYMMDD');
  
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
    
      /*����ֻ�򲥳���Ʒ��ǩ�Ļ�Ա*/
      MERGE /*+APPEND*/
      INTO (SELECT ROW_ID,
                   MEMBER_KEY,
                   M_LABEL_ID,
                   M_LABEL_TYPE_ID,
                   CREATE_DATE,
                   CREATE_USER_ID,
                   LAST_UPDATE_DATE,
                   LAST_UPDATE_USER_ID
              FROM MEMBER_LABEL_LINK
             WHERE M_LABEL_ID = 3) T
      USING (SELECT D.MEMBER_KEY,
                    E.M_LABEL_ID          M_LABEL_ID,
                    E.M_LABEL_TYPE_ID     M_LABEL_TYPE_ID,
                    SYSDATE               CREATE_DATE,
                    E.CREATE_USER_ID      CREATE_USER_ID,
                    SYSDATE               LAST_UPDATE_DATE,
                    E.LAST_UPDATE_USER_ID LAST_UPDATE_USER_ID
               FROM (SELECT C.MEMBER_KEY,
                            COUNT(C.ITEM_CODE) ITEM_COUNT,
                            COUNT(CASE
                                    WHEN C.IS_BCST = 1 THEN
                                     1
                                    ELSE
                                     NULL
                                  END) BCST_ITEM_COUNT,
                            COUNT(DISTINCT C.ORDER_KEY) ORDER_COUNT
                       FROM (SELECT SALES.POSTING_DATE_KEY,
                                    SALES.ORDER_KEY,
                                    SALES.MEMBER_KEY,
                                    SALES.GOODS_COMMON_KEY ITEM_CODE,
                                    NVL(TV_GOOD.IS_BCST, 0) IS_BCST
                               FROM (SELECT DISTINCT A.POSTING_DATE_KEY,
                                                     A.ORDER_KEY,
                                                     A.MEMBER_KEY,
                                                     A.GOODS_COMMON_KEY
                                       FROM FACT_GOODS_SALES A
                                      WHERE A.POSTING_DATE_KEY >=
                                            TO_CHAR(TRUNC(IN_POSTING_DATE - 179),
                                                    'YYYYMMDD') /*180������ͳ��*/
                                        AND EXISTS
                                      (SELECT 1
                                               FROM FACT_GOODS_SALES G
                                              WHERE G.POSTING_DATE_KEY =
                                                    IN_POSTING_DATE_KEY
                                                AND G.MEMBER_KEY = A.MEMBER_KEY) /*ֻ�����������ڵ�member_key*/
                                        AND A.ORDER_STATE = 1
                                        AND A.TRAN_TYPE = 0) SALES,
                                    (SELECT B.ITEM_CODE,
                                            B.TV_STARTDAY_KEY,
                                            1 IS_BCST /*�Ƿ񲥳�*/
                                       FROM DIM_TV_GOOD B
                                      WHERE B.TV_STARTDAY_KEY >=
                                            TO_CHAR(TRUNC(IN_POSTING_DATE - 179),
                                                    'YYYYMMDD') /*180������ͳ��*/
                                     ) TV_GOOD
                              WHERE SALES.POSTING_DATE_KEY =
                                    TV_GOOD.TV_STARTDAY_KEY(+)
                                AND SALES.GOODS_COMMON_KEY =
                                    TV_GOOD.ITEM_CODE(+)) C
                      GROUP BY C.MEMBER_KEY) D,
                    (SELECT F.M_LABEL_ID,
                            F.M_LABEL_NAME,
                            F.M_LABEL_TYPE_ID,
                            F.CREATE_USER_ID,
                            F.LAST_UPDATE_USER_ID
                       FROM MEMBER_LABEL_HEAD F
                      WHERE F.M_LABEL_NAME = 'ONLY_BROADCAST' /*ֻ�򲥳���Ʒ*/
                     ) E
              WHERE /*�û�������������4��ʱ����*/
              D.ORDER_COUNT >= 4
             /*������Ʒ�ﵽ70%�����ǲ�����Ʒʱ��Ϊ��ֻ�򲥳���Ʒ�û�*/
          AND D.BCST_ITEM_COUNT / D.ITEM_COUNT >= 0.7) S
      ON (T.MEMBER_KEY = S.MEMBER_KEY)
      WHEN MATCHED THEN
        UPDATE
           SET T.M_LABEL_ID = S.M_LABEL_ID, T.LAST_UPDATE_DATE = SYSDATE
      WHEN NOT MATCHED THEN
        INSERT
          (T.ROW_ID,
           T.MEMBER_KEY,
           T.M_LABEL_ID,
           T.M_LABEL_TYPE_ID,
           T.CREATE_DATE,
           T.CREATE_USER_ID,
           T.LAST_UPDATE_DATE,
           T.LAST_UPDATE_USER_ID)
        VALUES
          (MEMBER_LABEL_LINK_SEQ.NEXTVAL,
           S.MEMBER_KEY,
           S.M_LABEL_ID,
           1,
           SYSDATE,
           'yangjin',
           SYSDATE,
           'yangjin');
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    END;
  
    /*��־��¼ģ��*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '�������:IN_POSTING_DATE_KEY:' ||
                            TO_CHAR(IN_POSTING_DATE_KEY);
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
    
  END ONLY_BROADCAST;

  PROCEDURE ONLY_TV(IN_POSTING_DATE_KEY IN NUMBER) IS
    S_ETL           W_ETL_LOG%ROWTYPE;
    SP_NAME         S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER     S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS     NUMBER;
    IN_POSTING_DATE DATE;
    /*
    ����˵����ֻ��TV��Ʒ(ONLY_TV)
              ͳ�����180��Ķ������û�������>=4,���Ҷ����Ĳ�����Ʒռ�ȴﵽ70%
    ����ʱ�䣺yangjin  2017-08-10
    */
  BEGIN
  
    SP_NAME          := 'MEMBER_LABEL_PKG.ONLY_TV'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME := 'MEMBER_LABEL_LINK'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı���
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    IN_POSTING_DATE  := TO_DATE(IN_POSTING_DATE_KEY, 'YYYYMMDD');
  
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
    
      /*����ֻ��TV��Ʒ��ǩ�Ļ�Ա*/
      MERGE /*+APPEND*/
      INTO (SELECT ROW_ID,
                   MEMBER_KEY,
                   M_LABEL_ID,
                   M_LABEL_TYPE_ID,
                   CREATE_DATE,
                   CREATE_USER_ID,
                   LAST_UPDATE_DATE,
                   LAST_UPDATE_USER_ID
              FROM MEMBER_LABEL_LINK
             WHERE M_LABEL_ID = 4) T
      USING (SELECT D.MEMBER_KEY,
                    E.M_LABEL_ID          M_LABEL_ID,
                    E.M_LABEL_TYPE_ID     M_LABEL_TYPE_ID,
                    SYSDATE               CREATE_DATE,
                    E.CREATE_USER_ID      CREATE_USER_ID,
                    SYSDATE               LAST_UPDATE_DATE,
                    E.LAST_UPDATE_USER_ID LAST_UPDATE_USER_ID
               FROM (SELECT C.MEMBER_KEY,
                            COUNT(C.ITEM_CODE) ITEM_COUNT,
                            COUNT(CASE
                                    WHEN C.IS_TV = 1 THEN
                                     1
                                    ELSE
                                     NULL
                                  END) TV_ITEM_COUNT,
                            COUNT(DISTINCT C.ORDER_KEY) ORDER_COUNT
                       FROM (SELECT SALES.ORDER_KEY,
                                    SALES.MEMBER_KEY,
                                    SALES.GOODS_COMMON_KEY ITEM_CODE,
                                    NVL(TV_GOOD.IS_TV, 0) IS_TV
                               FROM (SELECT DISTINCT A.ORDER_KEY,
                                                     A.MEMBER_KEY,
                                                     A.GOODS_COMMON_KEY
                                       FROM FACT_GOODS_SALES A
                                      WHERE A.POSTING_DATE_KEY >=
                                            TO_CHAR(TRUNC(IN_POSTING_DATE - 179),
                                                    'YYYYMMDD') /*180������ͳ��*/
                                        AND EXISTS
                                      (SELECT 1
                                               FROM FACT_GOODS_SALES G
                                              WHERE G.POSTING_DATE_KEY =
                                                    IN_POSTING_DATE_KEY
                                                AND G.MEMBER_KEY = A.MEMBER_KEY) /*ֻ�����������ڵ�member_key*/
                                        AND A.ORDER_STATE = 1
                                        AND A.TRAN_TYPE = 0) SALES,
                                    (SELECT ITEM_CODE, 1 IS_TV /*TV��Ʒ*/
                                       FROM DIM_GOOD
                                      WHERE GROUP_ID = 1000) TV_GOOD
                              WHERE SALES.GOODS_COMMON_KEY =
                                    TV_GOOD.ITEM_CODE(+)) C
                      GROUP BY C.MEMBER_KEY) D,
                    (SELECT F.M_LABEL_ID,
                            F.M_LABEL_NAME,
                            F.M_LABEL_TYPE_ID,
                            F.CREATE_USER_ID,
                            F.LAST_UPDATE_USER_ID
                       FROM MEMBER_LABEL_HEAD F
                      WHERE F.M_LABEL_NAME = 'ONLY_TV' /*ֻ��TV��Ʒ*/
                     ) E
              WHERE /*�û�������������4��ʱ����*/
              D.ORDER_COUNT >= 4
             /*����TV��Ʒ�ﵽ70%����*/
          AND D.TV_ITEM_COUNT / D.ITEM_COUNT >= 0.7) S
      ON (T.MEMBER_KEY = S.MEMBER_KEY)
      WHEN MATCHED THEN
        UPDATE
           SET T.M_LABEL_ID = S.M_LABEL_ID, T.LAST_UPDATE_DATE = SYSDATE
      WHEN NOT MATCHED THEN
        INSERT
          (T.ROW_ID,
           T.MEMBER_KEY,
           T.M_LABEL_ID,
           T.M_LABEL_TYPE_ID,
           T.CREATE_DATE,
           T.CREATE_USER_ID,
           T.LAST_UPDATE_DATE,
           T.LAST_UPDATE_USER_ID)
        VALUES
          (MEMBER_LABEL_LINK_SEQ.NEXTVAL,
           S.MEMBER_KEY,
           S.M_LABEL_ID,
           1,
           SYSDATE,
           'yangjin',
           SYSDATE,
           'yangjin');
    
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    END;
  
    /*��־��¼ģ��*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '�������:IN_POSTING_DATE_KEY:' ||
                            TO_CHAR(IN_POSTING_DATE_KEY);
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
    
  END ONLY_TV;

  PROCEDURE ONLY_ONLINE_RETAIL(IN_POSTING_DATE_KEY IN NUMBER) IS
    S_ETL           W_ETL_LOG%ROWTYPE;
    SP_NAME         S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER     S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS     NUMBER;
    IN_POSTING_DATE DATE;
    /*
    ����˵����ֻ�������Ʒ(ONLY_ONLINE_RETAIL)
              ͳ�����180��Ķ������û�������>=4,���Ҷ����Ĳ�����Ʒռ�ȴﵽ70%
    ����ʱ�䣺yangjin  2017-08-10
    */
  BEGIN
  
    SP_NAME          := 'MEMBER_LABEL_PKG.ONLY_ONLINE_RETAIL'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME := 'MEMBER_LABEL_LINK'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı���
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    IN_POSTING_DATE  := TO_DATE(IN_POSTING_DATE_KEY, 'YYYYMMDD');
  
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
    
      /*����ֻ�������Ʒ��ǩ�Ļ�Ա*/
      MERGE /*+APPEND*/
      INTO (SELECT ROW_ID,
                   MEMBER_KEY,
                   M_LABEL_ID,
                   M_LABEL_TYPE_ID,
                   CREATE_DATE,
                   CREATE_USER_ID,
                   LAST_UPDATE_DATE,
                   LAST_UPDATE_USER_ID
              FROM MEMBER_LABEL_LINK
             WHERE M_LABEL_ID = 5) T
      USING (SELECT D.MEMBER_KEY,
                    E.M_LABEL_ID          M_LABEL_ID,
                    E.M_LABEL_TYPE_ID     M_LABEL_TYPE_ID,
                    SYSDATE               CREATE_DATE,
                    E.CREATE_USER_ID      CREATE_USER_ID,
                    SYSDATE               LAST_UPDATE_DATE,
                    E.LAST_UPDATE_USER_ID LAST_UPDATE_USER_ID
               FROM (SELECT C.MEMBER_KEY,
                            COUNT(C.ITEM_CODE) ITEM_COUNT,
                            COUNT(CASE
                                    WHEN C.IS_ONLINE = 1 THEN
                                     1
                                    ELSE
                                     NULL
                                  END) ONLINE_ITEM_COUNT,
                            COUNT(DISTINCT C.ORDER_KEY) ORDER_COUNT
                       FROM (SELECT SALES.ORDER_KEY,
                                    SALES.MEMBER_KEY,
                                    SALES.GOODS_COMMON_KEY ITEM_CODE,
                                    NVL(ONLINE_GOOD.IS_ONLINE, 0) IS_ONLINE
                               FROM (SELECT DISTINCT A.ORDER_KEY,
                                                     A.MEMBER_KEY,
                                                     A.GOODS_COMMON_KEY
                                       FROM FACT_GOODS_SALES A
                                      WHERE A.POSTING_DATE_KEY >=
                                            TO_CHAR(TRUNC(IN_POSTING_DATE - 179),
                                                    'YYYYMMDD') /*180������ͳ��*/
                                        AND A.ORDER_STATE = 1
                                        AND A.TRAN_TYPE = 0) SALES,
                                    (SELECT ITEM_CODE, 1 IS_ONLINE /*������Ʒ*/
                                       FROM DIM_GOOD
                                      WHERE GROUP_ID = 2000) ONLINE_GOOD
                              WHERE SALES.GOODS_COMMON_KEY =
                                    ONLINE_GOOD.ITEM_CODE(+)) C
                      GROUP BY C.MEMBER_KEY) D,
                    (SELECT F.M_LABEL_ID,
                            F.M_LABEL_NAME,
                            F.M_LABEL_TYPE_ID,
                            F.CREATE_USER_ID,
                            F.LAST_UPDATE_USER_ID
                       FROM MEMBER_LABEL_HEAD F
                      WHERE F.M_LABEL_NAME = 'ONLY_ONLINE_RETAIL' /*ֻ�������Ʒ*/
                     ) E
              WHERE /*�û�������������4��ʱ����*/
              D.ORDER_COUNT >= 4
             /*������Ʒ�ﵽ70%����*/
          AND D.ONLINE_ITEM_COUNT / D.ITEM_COUNT >= 0.7) S
      ON (T.MEMBER_KEY = S.MEMBER_KEY)
      WHEN MATCHED THEN
        UPDATE
           SET T.M_LABEL_ID = S.M_LABEL_ID, T.LAST_UPDATE_DATE = SYSDATE
      WHEN NOT MATCHED THEN
        INSERT
          (T.ROW_ID,
           T.MEMBER_KEY,
           T.M_LABEL_ID,
           T.M_LABEL_TYPE_ID,
           T.CREATE_DATE,
           T.CREATE_USER_ID,
           T.LAST_UPDATE_DATE,
           T.LAST_UPDATE_USER_ID)
        VALUES
          (MEMBER_LABEL_LINK_SEQ.NEXTVAL,
           S.MEMBER_KEY,
           S.M_LABEL_ID,
           1,
           SYSDATE,
           'yangjin',
           SYSDATE,
           'yangjin');
    
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    END;
  
    /*��־��¼ģ��*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '�������:IN_POSTING_DATE_KEY:' ||
                            TO_CHAR(IN_POSTING_DATE_KEY);
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
    
  END ONLY_ONLINE_RETAIL;

  PROCEDURE ONLY_SELF_SALES(IN_POSTING_DATE_KEY IN NUMBER) IS
    S_ETL           W_ETL_LOG%ROWTYPE;
    SP_NAME         S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER     S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS     NUMBER;
    IN_POSTING_DATE DATE;
    /*
    ����˵�����Ƿ�ֻ����Ӫ��Ʒ
              ֻ����Ӫ��Ʒ(SELF_SALES)
              ֻ�����Ӫ��Ʒ(NON_SELF_SALES)
                ͳ�����180��Ķ������û�������>=4,���Ҷ����Ĳ�����Ʒռ�ȴﵽ70%
    ����ʱ�䣺yangjin  2017-08-10
    */
  BEGIN
  
    SP_NAME          := 'MEMBER_LABEL_PKG.ONLY_SELF_SALES'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME := 'MEMBER_LABEL_LINK'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı���
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    IN_POSTING_DATE  := TO_DATE(IN_POSTING_DATE_KEY, 'YYYYMMDD');
  
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
    
      /*�����Ƿ���Ӫ��ǩ�Ļ�Ա*/
      MERGE /*+APPEND*/
      INTO (SELECT ROW_ID,
                   MEMBER_KEY,
                   M_LABEL_ID,
                   M_LABEL_TYPE_ID,
                   CREATE_DATE,
                   CREATE_USER_ID,
                   LAST_UPDATE_DATE,
                   LAST_UPDATE_USER_ID
              FROM MEMBER_LABEL_LINK
             WHERE M_LABEL_ID IN (6, 7)) T
      USING (SELECT D.MEMBER_KEY,
                    CASE
                      WHEN D.SELF_SALES_ITEM_COUNT / D.ITEM_COUNT >= 0.7 THEN
                       6
                      ELSE
                       7
                    END M_LABEL_ID,
                    1 M_LABEL_TYPE_ID,
                    SYSDATE CREATE_DATE,
                    'yangjin' CREATE_USER_ID,
                    SYSDATE LAST_UPDATE_DATE,
                    'yangjin' LAST_UPDATE_USER_ID
               FROM (SELECT C.MEMBER_KEY,
                            COUNT(C.ITEM_CODE) ITEM_COUNT,
                            COUNT(CASE
                                    WHEN C.IS_SELF_SALES = 'SELF_SALES' THEN
                                     1
                                    ELSE
                                     NULL
                                  END) SELF_SALES_ITEM_COUNT,
                            COUNT(CASE
                                    WHEN C.IS_SELF_SALES = 'NON_SELF_SALES' THEN
                                     1
                                    ELSE
                                     NULL
                                  END) NON_SELF_SALES_ITEM_COUNT,
                            COUNT(DISTINCT C.ORDER_KEY) ORDER_COUNT
                       FROM (SELECT SALES.ORDER_KEY,
                                    SALES.MEMBER_KEY,
                                    SALES.GOODS_COMMON_KEY ITEM_CODE,
                                    GOOD.IS_SELF_SALES
                               FROM (SELECT DISTINCT A.ORDER_KEY,
                                                     A.MEMBER_KEY,
                                                     A.GOODS_COMMON_KEY
                                       FROM FACT_GOODS_SALES A
                                      WHERE A.POSTING_DATE_KEY >=
                                            TO_CHAR(TRUNC(IN_POSTING_DATE - 179),
                                                    'YYYYMMDD') /*180������ͳ��*/
                                        AND A.ORDER_STATE = 1
                                        AND A.TRAN_TYPE = 0) SALES,
                                    (SELECT ITEM_CODE,
                                            CASE
                                              WHEN IS_SHIPPING_SELF = '����' THEN
                                               'SELF_SALES'
                                              ELSE
                                               'NON_SELF_SALES'
                                            END IS_SELF_SALES
                                       FROM FACT_DAILY_GOODZAIJIA) GOOD
                              WHERE SALES.GOODS_COMMON_KEY = GOOD.ITEM_CODE) C
                      GROUP BY C.MEMBER_KEY) D
              WHERE D.ORDER_COUNT >= 4 /*������������4��*/
                   /*��Ӫ�����Ӫ���ʴ���70%*/
                AND (D.SELF_SALES_ITEM_COUNT / D.ITEM_COUNT >= 0.7 OR
                    D.NON_SELF_SALES_ITEM_COUNT / D.ITEM_COUNT >= 0.7)) S
      ON (T.MEMBER_KEY = S.MEMBER_KEY)
      WHEN MATCHED THEN
        UPDATE
           SET T.M_LABEL_ID = S.M_LABEL_ID, T.LAST_UPDATE_DATE = SYSDATE
      WHEN NOT MATCHED THEN
        INSERT
          (T.ROW_ID,
           T.MEMBER_KEY,
           T.M_LABEL_ID,
           T.M_LABEL_TYPE_ID,
           T.CREATE_DATE,
           T.CREATE_USER_ID,
           T.LAST_UPDATE_DATE,
           T.LAST_UPDATE_USER_ID)
        VALUES
          (MEMBER_LABEL_LINK_SEQ.NEXTVAL,
           S.MEMBER_KEY,
           S.M_LABEL_ID,
           1,
           SYSDATE,
           'yangjin',
           SYSDATE,
           'yangjin');
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    END;
  
    /*��־��¼ģ��*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '�������:IN_POSTING_DATE_KEY:' ||
                            TO_CHAR(IN_POSTING_DATE_KEY);
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
    
  END ONLY_SELF_SALES;

  PROCEDURE MIXED_CUSTOMER(IN_POSTING_DATE_KEY IN NUMBER) IS
    S_ETL           W_ETL_LOG%ROWTYPE;
    SP_NAME         S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER     S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS     NUMBER;
    IN_POSTING_DATE DATE;
    /*
    ����˵��������ͻ�Ա
                ͳ�����180��Ķ������û�������>=4�������������κ�����ʱ
    ����ʱ�䣺yangjin  2017-08-10
    */
  BEGIN
  
    SP_NAME          := 'MEMBER_LABEL_PKG.MIXED_CUSTOMER'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME := 'MEMBER_LABEL_LINK'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı���
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    IN_POSTING_DATE  := TO_DATE(IN_POSTING_DATE_KEY, 'YYYYMMDD');
  
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
    
      /*���������ͱ�ǩ�Ļ�Ա*/
      MERGE /*+APPEND*/
      INTO (SELECT ROW_ID,
                   MEMBER_KEY,
                   M_LABEL_ID,
                   M_LABEL_TYPE_ID,
                   CREATE_DATE,
                   CREATE_USER_ID,
                   LAST_UPDATE_DATE,
                   LAST_UPDATE_USER_ID
              FROM MEMBER_LABEL_LINK
             WHERE M_LABEL_ID = 8) T
      USING (SELECT C.MEMBER_KEY,
                    E.M_LABEL_ID          M_LABEL_ID,
                    E.M_LABEL_TYPE_ID     M_LABEL_TYPE_ID,
                    SYSDATE               CREATE_DATE,
                    E.CREATE_USER_ID      CREATE_USER_ID,
                    SYSDATE               LAST_UPDATE_DATE,
                    E.LAST_UPDATE_USER_ID LAST_UPDATE_USER_ID
               FROM (SELECT B.MEMBER_KEY, COUNT(B.ORDER_KEY) ORDER_COUNT
                       FROM (SELECT DISTINCT A.ORDER_KEY,
                                             A.MEMBER_KEY,
                                             A.GOODS_COMMON_KEY
                               FROM FACT_GOODS_SALES A
                              WHERE A.POSTING_DATE_KEY >=
                                    TO_CHAR(TRUNC(IN_POSTING_DATE - 179),
                                            'YYYYMMDD') /*180������ͳ��*/
                                AND A.ORDER_STATE = 1
                                AND A.TRAN_TYPE = 0) B
                      GROUP BY B.MEMBER_KEY
                     HAVING COUNT(B.ORDER_KEY) >= 4) C,
                    (SELECT F.M_LABEL_ID,
                            F.M_LABEL_NAME,
                            F.M_LABEL_TYPE_ID,
                            F.CREATE_USER_ID,
                            F.LAST_UPDATE_USER_ID
                       FROM MEMBER_LABEL_HEAD F
                      WHERE F.M_LABEL_NAME = 'MIXED_CUSTOMER' /*�������*/
                     ) E
              WHERE NOT EXISTS (SELECT 1
                       FROM MEMBER_LABEL_LINK D
                      WHERE D.M_LABEL_ID IN (3, 4, 5, 6, 7)
                        AND C.MEMBER_KEY = D.MEMBER_KEY) /*�����������κ�����*/
             ) S
      ON (T.MEMBER_KEY = S.MEMBER_KEY)
      WHEN MATCHED THEN
        UPDATE
           SET T.M_LABEL_ID = S.M_LABEL_ID, T.LAST_UPDATE_DATE = SYSDATE
      WHEN NOT MATCHED THEN
        INSERT
          (T.ROW_ID,
           T.MEMBER_KEY,
           T.M_LABEL_ID,
           T.M_LABEL_TYPE_ID,
           T.CREATE_DATE,
           T.CREATE_USER_ID,
           T.LAST_UPDATE_DATE,
           T.LAST_UPDATE_USER_ID)
        VALUES
          (MEMBER_LABEL_LINK_SEQ.NEXTVAL,
           S.MEMBER_KEY,
           S.M_LABEL_ID,
           1,
           SYSDATE,
           'yangjin',
           SYSDATE,
           'yangjin');
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    END;
  
    /*��־��¼ģ��*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '�������:IN_POSTING_DATE_KEY:' ||
                            TO_CHAR(IN_POSTING_DATE_KEY);
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
    
  END MIXED_CUSTOMER;

  PROCEDURE TOP_ITEM_LOYALTY(IN_POSTING_DATE_KEY IN NUMBER) IS
  
    /*
    ����˵����ֱ����Ʒ�ҳ϶�(6����ǩ)
    ����ʱ�䣺yangjin  2017-08-10
    */
  BEGIN
  
    BEGIN
      MEMBER_LABEL_PKG.ONLY_BROADCAST(IN_POSTING_DATE_KEY);
      MEMBER_LABEL_PKG.ONLY_TV(IN_POSTING_DATE_KEY);
      MEMBER_LABEL_PKG.ONLY_ONLINE_RETAIL(IN_POSTING_DATE_KEY);
      MEMBER_LABEL_PKG.ONLY_SELF_SALES(IN_POSTING_DATE_KEY);
      MEMBER_LABEL_PKG.MIXED_CUSTOMER(IN_POSTING_DATE_KEY);
    END;
  
  END TOP_ITEM_LOYALTY;

  PROCEDURE COMMON_PORT(IN_POSTING_DATE_KEY IN NUMBER) IS
    S_ETL           W_ETL_LOG%ROWTYPE;
    SP_NAME         S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER     S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS     NUMBER;
    IN_POSTING_DATE DATE;
    /*
    ����˵��:    ���ö˿�(5����ǩ)
                    APP(COMMON_PORT_APP)(10,20,)
                    ΢��(COMMON_PORT_WX)(50)
                    WAP(COMMON_PORT_WAP)(30)
                    PC(COMMON_PORT_PC)(40)
                    �޹���(COMMON_PORT_VARIETY)
                    FACT_SESSION�����м�¼�Ļ�Ա�Ż�����������ĳ��ö˿ڱ�ǩ
    ����ʱ�䣺yangjin  2017-08-16
    */
  BEGIN
  
    SP_NAME          := 'MEMBER_LABEL_PKG.COMMON_PORT'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME := 'MEMBER_LABEL_LINK'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı���
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    IN_POSTING_DATE  := TO_DATE(IN_POSTING_DATE_KEY, 'YYYYMMDD');
  
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
      /*���볣�ö˿ڱ�ǩ*/
      MERGE /*+APPEND*/
      INTO (SELECT ROW_ID,
                   MEMBER_KEY,
                   M_LABEL_ID,
                   M_LABEL_TYPE_ID,
                   CREATE_DATE,
                   CREATE_USER_ID,
                   LAST_UPDATE_DATE,
                   LAST_UPDATE_USER_ID
              FROM MEMBER_LABEL_LINK
             WHERE M_LABEL_ID BETWEEN 22 AND 26) T
      USING (SELECT F.MEMBER_KEY,
                    G.M_LABEL_ID,
                    G.M_LABEL_TYPE_ID,
                    SYSDATE CREATE_DATE,
                    'yangjin' CREATE_USER_ID,
                    sysdate LAST_UPDATE_DATE,
                    'yangjin' LAST_UPDATE_USER_ID
               FROM (SELECT E.MEMBER_KEY,
                            SUBSTR(MAX(E.MAX_PER_PORT), 3) COMMON_PORT
                       FROM (SELECT D.MEMBER_KEY,
                                    D.COMMON_PORT,
                                    D.FREQ,
                                    D.TOTAL_FREQ,
                                    D.FREQ / D.TOTAL_FREQ PORT_PER,
                                    /*�˿�ռ�ȴ���70%Ϊ���ö˿ڣ�����Ϊ�޹��ɱ�ǩ*/
                                    CASE
                                      WHEN D.FREQ / D.TOTAL_FREQ >= 0.7 THEN
                                       '2_' || D.COMMON_PORT
                                      ELSE
                                       '1_COMMON_PORT_VARIETY'
                                    END MAX_PER_PORT
                               FROM (SELECT C.MEMBER_KEY,
                                            C.COMMON_PORT,
                                            C.FREQ,
                                            SUM(C.FREQ) OVER(PARTITION BY C.MEMBER_KEY) TOTAL_FREQ
                                       FROM (SELECT B.MEMBER_KEY,
                                                    B.COMMON_PORT,
                                                    COUNT(1) FREQ
                                               FROM (SELECT A.MEMBER_KEY,
                                                            DECODE(A.APPLICATION_KEY,
                                                                   10,
                                                                   'COMMON_PORT_APP',
                                                                   20,
                                                                   'COMMON_PORT_APP',
                                                                   30,
                                                                   'COMMON_PORT_WAP',
                                                                   40,
                                                                   'COMMON_PORT_PC',
                                                                   50,
                                                                   'COMMON_PORT_WX') COMMON_PORT
                                                       FROM FACT_SESSION A
                                                      WHERE A.START_DATE_KEY BETWEEN
                                                            TO_CHAR(TRUNC(IN_POSTING_DATE - 179),
                                                                    'YYYYMMDD') AND
                                                            TO_CHAR(TRUNC(IN_POSTING_DATE),
                                                                    'YYYYMMDD') /*ͳ��180������*/
                                                        AND A.MEMBER_KEY <> 0
                                                           /*ֻ�Ե�������Ļ�Ա���㳣�ö˿�*/
                                                        AND EXISTS
                                                      (SELECT 1
                                                               FROM FACT_SESSION H
                                                              WHERE A.MEMBER_KEY =
                                                                    H.MEMBER_KEY
                                                                AND H.START_DATE_KEY =
                                                                    IN_POSTING_DATE_KEY)) B
                                              WHERE B.COMMON_PORT IS NOT NULL
                                              GROUP BY B.MEMBER_KEY,
                                                       B.COMMON_PORT) C) D
                              WHERE D.TOTAL_FREQ >= 4) E
                      GROUP BY E.MEMBER_KEY) F,
                    MEMBER_LABEL_HEAD G
              WHERE G.M_LABEL_FATHER_ID = 21
                AND F.COMMON_PORT = G.M_LABEL_NAME) S
      ON (T.MEMBER_KEY = S.MEMBER_KEY)
      WHEN MATCHED THEN
        UPDATE
           SET T.M_LABEL_ID = S.M_LABEL_ID, T.LAST_UPDATE_DATE = SYSDATE
      WHEN NOT MATCHED THEN
        INSERT
          (T.ROW_ID,
           T.MEMBER_KEY,
           T.M_LABEL_ID,
           T.M_LABEL_TYPE_ID,
           T.CREATE_DATE,
           T.CREATE_USER_ID,
           T.LAST_UPDATE_DATE,
           T.LAST_UPDATE_USER_ID)
        VALUES
          (MEMBER_LABEL_LINK_SEQ.NEXTVAL,
           S.MEMBER_KEY,
           S.M_LABEL_ID,
           1,
           SYSDATE,
           'yangjin',
           SYSDATE,
           'yangjin');
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    END;
  
    /*��־��¼ģ��*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '�������:IN_POSTING_DATE_KEY:' ||
                            TO_CHAR(IN_POSTING_DATE_KEY);
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
  END COMMON_PORT;

  PROCEDURE FIRST_ORDER_NOT(IN_POSTING_DATE_KEY IN NUMBER) IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    --IN_POSTING_DATE DATE;
    /*
    ����˵��:    �׵���ǩ-�޲����׵�
    ����ʱ�䣺yangjin  2017-08-17
    */
  BEGIN
  
    SP_NAME          := 'MEMBER_LABEL_PKG.FIRST_ORDER_NOT'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME := 'MEMBER_LABEL_LINK'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı���
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    --IN_POSTING_DATE  := TO_DATE(IN_POSTING_DATE_KEY, 'YYYYMMDD');
  
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
      /*δ�����׵�*/
      INSERT INTO MEMBER_LABEL_LINK
        (ROW_ID,
         MEMBER_KEY,
         M_LABEL_ID,
         M_LABEL_TYPE_ID,
         CREATE_DATE,
         CREATE_USER_ID,
         LAST_UPDATE_DATE,
         LAST_UPDATE_USER_ID)
        SELECT MEMBER_LABEL_LINK_SEQ.NEXTVAL,
               D.MEMBER_KEY,
               E.M_LABEL_ID,
               E.M_LABEL_TYPE_ID,
               SYSDATE CREATE_DATE,
               'yangjin' CREATE_USER_ID,
               SYSDATE LAST_UPDATE_DATE,
               'yangjin' LAST_UPDATE_USER_ID
          FROM (SELECT A.MEMBER_KEY
                  FROM FACT_VISITOR_REGISTER A
                 WHERE A.MEMBER_KEY <> 0
                   AND A.CREATE_DATE_KEY = IN_POSTING_DATE_KEY
                   AND NOT EXISTS
                 (SELECT 1
                          FROM (SELECT C.MEMBER_KEY
                                  FROM FACT_GOODS_SALES C
                                 WHERE C.ORDER_STATE = 1
                                   AND C.POSTING_DATE_KEY <=
                                       IN_POSTING_DATE_KEY) B
                         WHERE A.MEMBER_KEY = B.MEMBER_KEY)
                 GROUP BY A.MEMBER_KEY) D,
               MEMBER_LABEL_HEAD E
         WHERE E.M_LABEL_NAME = 'FIRST_ORDER_NOT'
              /*�����ظ�����δ�����׵���ǩ*/
           AND NOT EXISTS
         (SELECT 1
                  FROM MEMBER_LABEL_LINK F
                 WHERE D.MEMBER_KEY = F.MEMBER_KEY
                   AND F.M_LABEL_ID BETWEEN 42 AND 47);
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    END;
  
    /*��־��¼ģ��*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '�������:IN_POSTING_DATE_KEY:' ||
                            TO_CHAR(IN_POSTING_DATE_KEY);
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
  END FIRST_ORDER_NOT;

  PROCEDURE FIRST_ORDER_GIFT(IN_POSTING_DATE_KEY IN NUMBER) IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    --IN_POSTING_DATE DATE;
    /*
    ����˵��:    �׵���ǩ-�׵�Ϊ������
    ����ʱ�䣺yangjin  2017-08-17
    */
  BEGIN
  
    SP_NAME          := 'MEMBER_LABEL_PKG.FIRST_ORDER_GIFT'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME := 'MEMBER_LABEL_LINK'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı���
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    --IN_POSTING_DATE  := TO_DATE(IN_POSTING_DATE_KEY, 'YYYYMMDD');
  
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
      /*�׵���ǩ-�׵�Ϊ������*/
      INSERT INTO MEMBER_LABEL_LINK
        (ROW_ID,
         MEMBER_KEY,
         M_LABEL_ID,
         M_LABEL_TYPE_ID,
         CREATE_DATE,
         CREATE_USER_ID,
         LAST_UPDATE_DATE,
         LAST_UPDATE_USER_ID)
        SELECT MEMBER_LABEL_LINK_SEQ.NEXTVAL,
               D.MEMBER_KEY,
               E.M_LABEL_ID,
               E.M_LABEL_TYPE_ID,
               SYSDATE CREATE_DATE,
               'yangjin' CREATE_USER_ID,
               SYSDATE LAST_UPDATE_DATE,
               'yangjin' LAST_UPDATE_USER_ID
          FROM (SELECT A.MEMBER_KEY
                  FROM FACT_VISITOR_REGISTER A
                 WHERE A.MEMBER_KEY <> 0
                   AND A.CREATE_DATE_KEY = IN_POSTING_DATE_KEY
                   AND EXISTS (SELECT 1
                          FROM (SELECT C.MEMBER_KEY,
                                       SUM(C.AMOUNT_PAID) AMOUNT_PAID
                                  FROM FACT_GOODS_SALES C
                                 WHERE C.ORDER_STATE = 1
                                 GROUP BY C.MEMBER_KEY) B
                         WHERE A.MEMBER_KEY = B.MEMBER_KEY
                           AND B.AMOUNT_PAID < 30)
                 GROUP BY A.MEMBER_KEY) D,
               MEMBER_LABEL_HEAD E
         WHERE E.M_LABEL_NAME = 'FIRST_ORDER_GIFT'
              /*�����ظ������׵�Ϊ�������ǩ*/
           AND NOT EXISTS
         (SELECT 1
                  FROM MEMBER_LABEL_LINK F
                 WHERE D.MEMBER_KEY = F.MEMBER_KEY
                   AND F.M_LABEL_ID BETWEEN 42 AND 47);
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    END;
  
    /*��־��¼ģ��*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '�������:IN_POSTING_DATE_KEY:' ||
                            TO_CHAR(IN_POSTING_DATE_KEY);
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
  END FIRST_ORDER_GIFT;

  PROCEDURE FIRST_ORDER_ITEM(IN_POSTING_DATE_KEY IN NUMBER) IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
    /*
    ����˵��:    �׵���ǩ-�׵�ΪTV������Ʒ(FIRST_ORDER_BROADCAST)
                          �׵�ΪTV�ǲ�����Ʒ(FIRST_ORDER_NOT_BROADCAST)
                          �׵�Ϊ��Ӫ��Ʒ(FIRST_ORDER_SELF)
                          �׵�ΪBBC��Ʒ(FIRST_ORDER_BBC)
    ����ʱ�䣺yangjin  2017-08-21
    */
  BEGIN
  
    SP_NAME          := 'MEMBER_LABEL_PKG.FIRST_ORDER_ITEM'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME := 'MEMBER_LABEL_LINK'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı���
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    INSERT_ROWS      := 0;
    --IN_POSTING_DATE  := TO_DATE(IN_POSTING_DATE_KEY, 'YYYYMMDD');
  
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
    
      DECLARE
        TYPE TYPE_ARRAYS IS RECORD(
          MEMBER_KEY NUMBER(20));
      
        TYPE TYPE_ARRAY IS TABLE OF TYPE_ARRAYS INDEX BY BINARY_INTEGER; --���ƶ�ά���� 
      
        VAR_ARRAY TYPE_ARRAY;
      BEGIN
        /*����ע��Ļ�ԱBP��,û���׵���ǩ*/
        SELECT P.*
          BULK COLLECT
          INTO VAR_ARRAY
          FROM (SELECT A.MEMBER_KEY
                  FROM FACT_VISITOR_REGISTER A
                 WHERE A.MEMBER_KEY <> 0
                   AND A.CREATE_DATE_KEY = IN_POSTING_DATE_KEY
                 GROUP BY A.MEMBER_KEY) P
         WHERE NOT EXISTS (SELECT 1
                  FROM MEMBER_LABEL_LINK B
                 WHERE B.M_LABEL_ID BETWEEN 42 AND 47
                   AND P.MEMBER_KEY = B.MEMBER_KEY);
      
        FOR I IN 1 .. VAR_ARRAY.COUNT LOOP
        
          /*�׵�������Ʒ����*/
          INSERT INTO MEMBER_LABEL_LINK
            (ROW_ID,
             MEMBER_KEY,
             M_LABEL_ID,
             M_LABEL_TYPE_ID,
             CREATE_DATE,
             CREATE_USER_ID,
             LAST_UPDATE_DATE,
             LAST_UPDATE_USER_ID)
          /*�׵��������������Ʒ*/
            SELECT MEMBER_LABEL_LINK_SEQ.NEXTVAL,
                   ORD.MEMBER_KEY,
                   MLH.M_LABEL_ID,
                   MLH.M_LABEL_TYPE_ID,
                   SYSDATE CREATE_DATE,
                   'yangjin' CREATE_USER_ID,
                   SYSDATE LAST_UPDATE_DATE,
                   'yangjin' LAST_UPDATE_USER_ID
              FROM (SELECT A.MEMBER_KEY,
                           A.ORDER_KEY,
                           MIN(A.GOODS_COMMON_KEY) GOODS_COMMON_KEY,
                           A.ORDER_AMOUNT
                      FROM FACT_GOODS_SALES A
                     WHERE A.ORDER_STATE = 1
                       AND A.GOODS_COMMON_KEY IS NOT NULL
                       AND EXISTS (SELECT 1
                              FROM (SELECT C.MEMBER_KEY,
                                           MIN(C.ORDER_KEY) ORDER_KEY
                                      FROM FACT_GOODS_SALES C
                                     WHERE C.ORDER_STATE = 1
                                       AND C.GOODS_COMMON_KEY IS NOT NULL
                                     GROUP BY C.MEMBER_KEY) B
                             WHERE A.MEMBER_KEY = B.MEMBER_KEY
                               AND A.ORDER_KEY = B.ORDER_KEY)
                       AND EXISTS
                     (SELECT 1
                              FROM (SELECT C.MEMBER_KEY,
                                           C.ORDER_KEY,
                                           MAX(C.ORDER_AMOUNT) ORDER_AMOUNT
                                      FROM FACT_GOODS_SALES C
                                     WHERE C.ORDER_STATE = 1
                                       AND C.GOODS_COMMON_KEY IS NOT NULL
                                     GROUP BY C.MEMBER_KEY, C.ORDER_KEY) D
                             WHERE A.MEMBER_KEY = D.MEMBER_KEY
                               AND A.ORDER_KEY = D.ORDER_KEY
                               AND A.ORDER_AMOUNT = D.ORDER_AMOUNT)
                       AND A.MEMBER_KEY = VAR_ARRAY(I).MEMBER_KEY
                     GROUP BY A.MEMBER_KEY, A.ORDER_KEY, A.ORDER_AMOUNT) ORD,
                   /*��Ʒ��ǩ����*/
                   (SELECT A.ITEM_CODE,
                           CASE
                             WHEN A.GROUP_ID = 1000 AND EXISTS
                              (SELECT 1 FROM DIM_TV_GOOD B WHERE A.ITEM_CODE = B.ITEM_CODE) THEN
                              'FIRST_ORDER_BROADCAST'
                             WHEN A.GROUP_ID = 1000 THEN
                              'FIRST_ORDER_NOT_BROADCAST'
                             WHEN A.GROUP_ID = 2000 AND EXISTS (SELECT 1
                                     FROM DIM_EC_GOOD C
                                    WHERE A.ITEM_CODE = C.ITEM_CODE
                                      AND C.STORE_ID = 1) THEN
                              'FIRST_ORDER_SELF'
                             WHEN A.GROUP_ID = 2000 AND EXISTS (SELECT 1
                                     FROM DIM_EC_GOOD C
                                    WHERE A.ITEM_CODE = C.ITEM_CODE
                                      AND C.STORE_ID <> 1) THEN
                              'FIRST_ORDER_BBC'
                             WHEN A.GROUP_ID = 2100 THEN
                              'FIRST_ORDER_JD'
                             ELSE
                              'FIRST_ORDER_OTHER'
                           END ITEM_LABEL
                      FROM DIM_GOOD A
                     WHERE A.CURRENT_FLG = 'Y') ITEM,
                   (SELECT * FROM MEMBER_LABEL_HEAD) MLH
             WHERE ORD.GOODS_COMMON_KEY = ITEM.ITEM_CODE
               AND ITEM.ITEM_LABEL = MLH.M_LABEL_NAME
                  /*������MEMBER_LABEL_LINK���Ĳ���*/
               AND NOT EXISTS
             (SELECT 1
                      FROM MEMBER_LABEL_LINK MLL
                     WHERE MLL.M_LABEL_ID BETWEEN 42 AND 47
                       AND ORD.MEMBER_KEY = MLL.MEMBER_KEY);
          COMMIT;
          INSERT_ROWS := INSERT_ROWS + 1;
        END LOOP;
      
      END;
    
      /*����Ա�״ζ����󣬸���δ�����׵���־*/
      DECLARE
        TYPE TYPE_ARRAYS IS RECORD(
          MEMBER_KEY NUMBER(20));
      
        TYPE TYPE_ARRAY IS TABLE OF TYPE_ARRAYS INDEX BY BINARY_INTEGER; --���ƶ�ά���� 
      
        VAR_ARRAY TYPE_ARRAY;
      BEGIN
        /*δ�����׵����û�*/
        SELECT P.*
          BULK COLLECT
          INTO VAR_ARRAY
          FROM (SELECT A.MEMBER_KEY
                  FROM MEMBER_LABEL_LINK A
                 WHERE A.M_LABEL_ID = 42
                 GROUP BY A.MEMBER_KEY) P
         WHERE EXISTS (SELECT 1
                  FROM FACT_GOODS_SALES B
                 WHERE B.ORDER_STATE = 1
                   AND B.POSTING_DATE_KEY <= IN_POSTING_DATE_KEY
                   AND P.MEMBER_KEY = B.MEMBER_KEY);
        FOR I IN 1 .. VAR_ARRAY.COUNT LOOP
          /*����[δ�����׵�]��ǩ*/
          UPDATE MEMBER_LABEL_LINK A
             SET (A.M_LABEL_ID,
                  --A.M_LABEL_TYPE_ID,
                  A.LAST_UPDATE_DATE,
                  A.LAST_UPDATE_USER_ID) =
                 (SELECT NVL(MLH.M_LABEL_ID, 42), /*���M_LABEL_IDΪ�գ���Ĭ��Ϊ42��δ�����׵�*/
                         --NVL(MLH.M_LABEL_TYPE_ID, 1),
                         SYSDATE,
                         'yangjin'
                    FROM /*�׵��������������Ʒ*/
                         (SELECT A.MEMBER_KEY,
                                 A.ORDER_KEY,
                                 MIN(A.GOODS_COMMON_KEY) GOODS_COMMON_KEY,
                                 A.ORDER_AMOUNT
                            FROM FACT_GOODS_SALES A
                           WHERE A.ORDER_STATE = 1
                             AND A.GOODS_COMMON_KEY IS NOT NULL
                             AND EXISTS
                           (SELECT 1
                                    FROM (SELECT C.MEMBER_KEY,
                                                 MIN(C.ORDER_KEY) ORDER_KEY
                                            FROM FACT_GOODS_SALES C
                                           WHERE C.ORDER_STATE = 1
                                             AND C.GOODS_COMMON_KEY IS NOT NULL
                                           GROUP BY C.MEMBER_KEY) B
                                   WHERE A.MEMBER_KEY = B.MEMBER_KEY
                                     AND A.ORDER_KEY = B.ORDER_KEY)
                             AND EXISTS
                           (SELECT 1
                                    FROM (SELECT C.MEMBER_KEY,
                                                 C.ORDER_KEY,
                                                 MAX(C.ORDER_AMOUNT) ORDER_AMOUNT
                                            FROM FACT_GOODS_SALES C
                                           WHERE C.ORDER_STATE = 1
                                             AND C.GOODS_COMMON_KEY IS NOT NULL
                                           GROUP BY C.MEMBER_KEY, C.ORDER_KEY) D
                                   WHERE A.MEMBER_KEY = D.MEMBER_KEY
                                     AND A.ORDER_KEY = D.ORDER_KEY
                                     AND A.ORDER_AMOUNT = D.ORDER_AMOUNT)
                             AND A.MEMBER_KEY = VAR_ARRAY(I).MEMBER_KEY
                           GROUP BY A.MEMBER_KEY, A.ORDER_KEY, A.ORDER_AMOUNT) ORD,
                         /*��Ʒ��ǩ����*/
                         (SELECT A.ITEM_CODE,
                                 CASE
                                   WHEN A.GROUP_ID = 1000 AND EXISTS
                                    (SELECT 1 FROM DIM_TV_GOOD B WHERE A.ITEM_CODE = B.ITEM_CODE) THEN
                                    'FIRST_ORDER_BROADCAST'
                                   WHEN A.GROUP_ID = 1000 THEN
                                    'FIRST_ORDER_NOT_BROADCAST'
                                   WHEN A.GROUP_ID = 2000 AND EXISTS (SELECT 1
                                           FROM DIM_EC_GOOD C
                                          WHERE A.ITEM_CODE = C.ITEM_CODE
                                            AND C.STORE_ID = 1) THEN
                                    'FIRST_ORDER_SELF'
                                   WHEN A.GROUP_ID = 2000 AND EXISTS (SELECT 1
                                           FROM DIM_EC_GOOD C
                                          WHERE A.ITEM_CODE = C.ITEM_CODE
                                            AND C.STORE_ID <> 1) THEN
                                    'FIRST_ORDER_BBC'
                                   ELSE
                                    'FIRST_ORDER_OTHER'
                                 END ITEM_LABEL
                            FROM DIM_GOOD A
                           WHERE A.CURRENT_FLG = 'Y') ITEM,
                         (SELECT * FROM MEMBER_LABEL_HEAD) MLH
                   WHERE ORD.GOODS_COMMON_KEY = ITEM.ITEM_CODE
                     AND ITEM.ITEM_LABEL = MLH.M_LABEL_NAME)
           WHERE A.M_LABEL_ID = 42
             AND A.MEMBER_KEY = VAR_ARRAY(I).MEMBER_KEY;
          COMMIT;
        END LOOP;
        UPDATE_ROWS := VAR_ARRAY.COUNT;
      END;
    END;
  
    /*��־��¼ģ��*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_UPD := UPDATE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '�������:IN_POSTING_DATE_KEY:' ||
                            TO_CHAR(IN_POSTING_DATE_KEY);
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
  END FIRST_ORDER_ITEM;

  PROCEDURE FIRST_ORDER_MAIN(IN_POSTING_DATE_KEY IN NUMBER) IS
  
    /*
    ����˵����ֱ����Ʒ�ҳ϶�(6����ǩ)
    ����ʱ�䣺yangjin  2017-08-10
    */
  BEGIN
  
    BEGIN
      MEMBER_LABEL_PKG.FIRST_ORDER_NOT(IN_POSTING_DATE_KEY);
      MEMBER_LABEL_PKG.FIRST_ORDER_GIFT(IN_POSTING_DATE_KEY);
      MEMBER_LABEL_PKG.FIRST_ORDER_ITEM(IN_POSTING_DATE_KEY);
    END;
  
  END FIRST_ORDER_MAIN;

  PROCEDURE MEMBER_LEVEL(IN_POSTING_DATE_KEY IN NUMBER) IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    /*
    ����˵������Ա�ȼ�(7����ǩ)
    ����ʱ�䣺yangjin  2017-08-29
    */
  BEGIN
    SP_NAME          := 'MEMBER_LABEL_PKG.MEMBER_LEVEL'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME := 'MEMBER_LABEL_LINK'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı���
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    --IN_POSTING_DATE  := TO_DATE(IN_POSTING_DATE_KEY, 'YYYYMMDD');
  
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
      INTO (SELECT ROW_ID,
                   MEMBER_KEY,
                   M_LABEL_ID,
                   M_LABEL_TYPE_ID,
                   CREATE_DATE,
                   CREATE_USER_ID,
                   LAST_UPDATE_DATE,
                   LAST_UPDATE_USER_ID
              FROM MEMBER_LABEL_LINK
             WHERE M_LABEL_ID IN (62, 63, 64, 65, 66, 67, 68)) T
      USING (SELECT MEMBER_BP,
                    CASE
                      WHEN MEMBER_LEVEL = 'HAPP_T0' THEN
                       62
                      WHEN MEMBER_LEVEL = 'HAPP_T1' THEN
                       63
                      WHEN MEMBER_LEVEL = 'HAPP_T2' THEN
                       64
                      WHEN MEMBER_LEVEL = 'HAPP_T3' THEN
                       65
                      WHEN MEMBER_LEVEL = 'HAPP_T4' THEN
                       66
                      WHEN MEMBER_LEVEL = 'HAPP_T5' THEN
                       67
                      WHEN MEMBER_LEVEL = 'HAPP_T6' THEN
                       68
                    END MEMBER_LEVEL_ID
               FROM DIM_MEMBER
              WHERE CH_DATE_KEY = IN_POSTING_DATE_KEY
                AND MEMBER_LEVEL IS NOT NULL) S
      ON (T.MEMBER_KEY = S.MEMBER_BP)
      WHEN MATCHED THEN
        UPDATE
           SET T.M_LABEL_ID       = S.MEMBER_LEVEL_ID,
               T.LAST_UPDATE_DATE = SYSDATE
      WHEN NOT MATCHED THEN
        INSERT
          (T.ROW_ID,
           T.MEMBER_KEY,
           T.M_LABEL_ID,
           T.M_LABEL_TYPE_ID,
           T.CREATE_DATE,
           T.CREATE_USER_ID,
           T.LAST_UPDATE_DATE,
           T.LAST_UPDATE_USER_ID)
        VALUES
          (MEMBER_LABEL_LINK_SEQ.NEXTVAL,
           S.MEMBER_BP,
           S.MEMBER_LEVEL_ID,
           1,
           SYSDATE,
           'yangjin',
           SYSDATE,
           'yangjin');
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    END;
    /*��־��¼ģ��*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '�������:IN_POSTING_DATE_KEY:' ||
                            TO_CHAR(IN_POSTING_DATE_KEY);
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
  END MEMBER_LEVEL;

  PROCEDURE MEMBER_REPURCHASE(IN_POSTING_DATE_KEY IN NUMBER) IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
    /*
    ����˵������Ա�������ڣ��죩
                REPURCHASE_CYCLE_LEVEL_1:-1
                REPURCHASE_CYCLE_LEVEL_2:0~30
                REPURCHASE_CYCLE_LEVEL_3:30~60
                REPURCHASE_CYCLE_LEVEL_4:60~90
                REPURCHASE_CYCLE_LEVEL_5:>90
    ����ʱ�䣺yangjin  2017-08-29
    */
  BEGIN
    SP_NAME          := 'MEMBER_LABEL_PKG.MEMBER_REPURCHASE'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME := 'MEMBER_LABEL_LINK'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı���
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    --IN_POSTING_DATE  := TO_DATE(IN_POSTING_DATE_KEY, 'YYYYMMDD');
  
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
      /*��ջ�Ա����������ʱ��*/
      EXECUTE IMMEDIATE 'TRUNCATE TABLE MEMBER_REPURCHASE_TMP';
    
      /*���췢�����۵Ļ�Ա���㸴������д��MEMBER_REPURCHASE_TMP*/
      INSERT INTO MEMBER_REPURCHASE_TMP
        SELECT A.MEMBER_BP,
               MEMBER_LABEL_PKG.MEMBER_REPURCHASE_CYCLE_DAYS(A.MEMBER_BP),
               CASE
                 WHEN MEMBER_LABEL_PKG.MEMBER_REPURCHASE_CYCLE_DAYS(A.MEMBER_BP) = -1 THEN
                  102
                 WHEN MEMBER_LABEL_PKG.MEMBER_REPURCHASE_CYCLE_DAYS(A.MEMBER_BP) >= 0 AND
                      MEMBER_LABEL_PKG.MEMBER_REPURCHASE_CYCLE_DAYS(A.MEMBER_BP) < 30 THEN
                  103
                 WHEN MEMBER_LABEL_PKG.MEMBER_REPURCHASE_CYCLE_DAYS(A.MEMBER_BP) >= 30 AND
                      MEMBER_LABEL_PKG.MEMBER_REPURCHASE_CYCLE_DAYS(A.MEMBER_BP) < 60 THEN
                  104
                 WHEN MEMBER_LABEL_PKG.MEMBER_REPURCHASE_CYCLE_DAYS(A.MEMBER_BP) >= 60 AND
                      MEMBER_LABEL_PKG.MEMBER_REPURCHASE_CYCLE_DAYS(A.MEMBER_BP) < 90 THEN
                  105
                 WHEN MEMBER_LABEL_PKG.MEMBER_REPURCHASE_CYCLE_DAYS(A.MEMBER_BP) >= 90 THEN
                  106
               END REPURCHASE_CYCLE_LEVEL
          FROM DIM_MEMBER A
         WHERE EXISTS (SELECT 1
                  FROM FACT_ORDER B
                 WHERE B.POSTING_DATE_KEY = IN_POSTING_DATE_KEY
                   AND A.MEMBER_BP = B.MEMBER_KEY);
    
      MERGE /*+APPEND*/
      INTO (SELECT ROW_ID,
                   MEMBER_KEY,
                   M_LABEL_ID,
                   M_LABEL_TYPE_ID,
                   CREATE_DATE,
                   CREATE_USER_ID,
                   LAST_UPDATE_DATE,
                   LAST_UPDATE_USER_ID
              FROM MEMBER_LABEL_LINK
             WHERE M_LABEL_ID IN (102, 103, 104, 105, 106)) T
      USING (SELECT A.MEMBER_BP, A.REPURCHASE_DAYS, A.REPURCHASE_CYCLE_LEVEL
               FROM MEMBER_REPURCHASE_TMP A) S
      ON (T.MEMBER_KEY = S.MEMBER_BP)
      WHEN MATCHED THEN
        UPDATE
           SET T.M_LABEL_ID       = S.REPURCHASE_CYCLE_LEVEL,
               T.LAST_UPDATE_DATE = SYSDATE
      WHEN NOT MATCHED THEN
        INSERT
          (T.ROW_ID,
           T.MEMBER_KEY,
           T.M_LABEL_ID,
           T.M_LABEL_TYPE_ID,
           T.CREATE_DATE,
           T.CREATE_USER_ID,
           T.LAST_UPDATE_DATE,
           T.LAST_UPDATE_USER_ID)
        VALUES
          (MEMBER_LABEL_LINK_SEQ.NEXTVAL,
           S.MEMBER_BP,
           S.REPURCHASE_CYCLE_LEVEL,
           1,
           SYSDATE,
           'yangjin',
           SYSDATE,
           'yangjin');
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    END;
    /*��־��¼ģ��*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_UPD := UPDATE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '�������:IN_POSTING_DATE_KEY:' ||
                            TO_CHAR(IN_POSTING_DATE_KEY);
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
  END MEMBER_REPURCHASE;

  PROCEDURE MEMBER_PAYMENT_METHOD(IN_POSTING_DATE_KEY IN NUMBER) IS
    S_ETL           W_ETL_LOG%ROWTYPE;
    SP_NAME         S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER     S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS     NUMBER;
    UPDATE_ROWS     NUMBER;
    IN_POSTING_DATE DATE;
    /*
    ����˵������Ա֧����ʽ
                ����COD(PAYMENT_COD)
                ����֧����(PAYMENT_ALIPAY)
                ����΢��֧��(PAYMENT_WX)
                �������п�֧��(PAYMENT_BANKCARD)
                ����֧��(PAYMENT_ONLINE)
    ����ʱ�䣺yangjin  2017-09-11
    */
  BEGIN
    SP_NAME          := 'MEMBER_LABEL_PKG.MEMBER_PAYMENT_METHOD'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME := 'MEMBER_LABEL_LINK'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı���
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    IN_POSTING_DATE  := TO_DATE(IN_POSTING_DATE_KEY, 'YYYYMMDD');
  
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
      /*�����Ա����֧����ʽ��ǩ*/
      MERGE /*+APPEND*/
      INTO (SELECT ROW_ID,
                   MEMBER_KEY,
                   M_LABEL_ID,
                   M_LABEL_TYPE_ID,
                   CREATE_DATE,
                   CREATE_USER_ID,
                   LAST_UPDATE_DATE,
                   LAST_UPDATE_USER_ID
              FROM MEMBER_LABEL_LINK
             WHERE M_LABEL_ID BETWEEN 122 AND 125) T
      USING (SELECT F.MEMBER_KEY,
                    G.M_LABEL_ID,
                    G.M_LABEL_TYPE_ID,
                    SYSDATE CREATE_DATE,
                    'yangjin' CREATE_USER_ID,
                    SYSDATE LAST_UPDATE_DATE,
                    'yangjin' LAST_UPDATE_USER_ID
               FROM (SELECT DISTINCT E.MEMBER_KEY,
                                     FIRST_VALUE(E.PAYMENT_LABEL) OVER(PARTITION BY E.MEMBER_KEY ORDER BY E.RANK1) FINAL_PAYMENT_LABEL
                       FROM (SELECT D.MEMBER_KEY,
                                    D.PAYMENT_METHOD,
                                    D.ORDER_AMOUNT,
                                    D.RANK1,
                                    D.TOTAL_ORDER_AMOUNT,
                                    CASE
                                    /*������֧����ʽ�������50%�����֧����ʽΪ����֧����ʽ*/
                                      WHEN D.RANK1 = 1 AND D.TOTAL_ORDER_AMOUNT <=
                                           D.ORDER_AMOUNT * 2 THEN
                                       D.PAYMENT_METHOD
                                    /*���п���֧������΢�źϼ�֧������50%�����÷�ʽΪ����֧��*/
                                      WHEN D.PAYMENT_METHOD IN
                                           ('PAYMENT_BANKCARD',
                                            'PAYMENT_ALIPAY',
                                            'PAYMENT_WX') AND
                                           (SUM(D.ORDER_AMOUNT)
                                            OVER(PARTITION BY D.MEMBER_KEY)) >
                                           D.TOTAL_ORDER_AMOUNT * 0.5 THEN
                                       'PAYMENT_ONLINE'
                                    END PAYMENT_LABEL
                               FROM (SELECT C.MEMBER_KEY,
                                            C.PAYMENT_METHOD,
                                            C.ORDER_AMOUNT,
                                            RANK() OVER(PARTITION BY C.MEMBER_KEY ORDER BY C.ORDER_AMOUNT DESC) RANK1 /*������������*/,
                                            SUM(C.ORDER_AMOUNT) OVER(PARTITION BY C.MEMBER_KEY) TOTAL_ORDER_AMOUNT /*��Ա�ϼƶ������*/
                                       FROM (SELECT B.MEMBER_KEY,
                                                    B.PAYMENT_METHOD,
                                                    SUM(B.ORDER_AMOUNT) ORDER_AMOUNT
                                               FROM (SELECT A.CUST_NO MEMBER_KEY,
                                                            A.ADD_TIME,
                                                            TO_CHAR(A.ORDER_SN) ORDER_NO,
                                                            CASE
                                                              WHEN UPPER(A.PAYMENTCHANNEL) =
                                                                   '����֧��' OR
                                                                   A.PAYMENTCHANNEL IS NULL THEN
                                                               'PAYMENT_COD' /*COD*/
                                                              WHEN UPPER(A.PAYMENTCHANNEL) IN
                                                                   ('ALIPAY_M',
                                                                    'ALIPAY_W',
                                                                    'ALIPAY_WAP',
                                                                    '֧����') THEN
                                                               'PAYMENT_ALIPAY' /*֧����*/
                                                              WHEN UPPER(A.PAYMENTCHANNEL) IN
                                                                   ('WX',
                                                                    'WXPAY_M',
                                                                    'WX_I',
                                                                    'WX_W',
                                                                    'WX_WAP',
                                                                    'ZXWX_I',
                                                                    'ZXWX_W',
                                                                    '΢��',
                                                                    '΢��(APP)',
                                                                    '΢��(��С��)',
                                                                    '�Ƹ�ͨ') THEN
                                                               'PAYMENT_WX' /*΢��*/
                                                              WHEN UPPER(A.PAYMENTCHANNEL) IN
                                                                   ('CMB',
                                                                    'CMBYWT_M') THEN
                                                               'PAYMENT_BANKCARD' /*���п�*/
                                                            END PAYMENT_METHOD,
                                                            A.ORDER_AMOUNT
                                                       FROM FACT_EC_ORDER A
                                                      WHERE A.ORDER_STATE >= 20 /*�Ѹ����*/
                                                           /*��������-180��*/
                                                        AND A.ADD_TIME BETWEEN
                                                            TO_CHAR(TRUNC(IN_POSTING_DATE - 179),
                                                                    'YYYYMMDD') AND
                                                            TO_CHAR(TRUNC(IN_POSTING_DATE),
                                                                    'YYYYMMDD')
                                                           /*ֻ���㵱����Ч�����Ļ�Ա�ĳ���֧����ʽ*/
                                                        AND EXISTS
                                                      (SELECT 1
                                                               FROM FACT_EC_ORDER H
                                                              WHERE H.ADD_TIME =
                                                                    IN_POSTING_DATE_KEY
                                                                AND H.ORDER_STATE >= 20
                                                                AND A.CUST_NO =
                                                                    H.CUST_NO)) B
                                              WHERE B.PAYMENT_METHOD IS NOT NULL
                                              GROUP BY B.MEMBER_KEY,
                                                       B.PAYMENT_METHOD) C) D) E
                      WHERE E.PAYMENT_LABEL IS NOT NULL) F,
                    MEMBER_LABEL_HEAD G
              WHERE G.M_LABEL_ID BETWEEN 122 AND 125
                AND F.FINAL_PAYMENT_LABEL = G.M_LABEL_NAME) S
      ON (T.MEMBER_KEY = S.MEMBER_KEY)
      WHEN MATCHED THEN
        UPDATE
           SET T.M_LABEL_ID = S.M_LABEL_ID, T.LAST_UPDATE_DATE = SYSDATE
      WHEN NOT MATCHED THEN
        INSERT
          (T.ROW_ID,
           T.MEMBER_KEY,
           T.M_LABEL_ID,
           T.M_LABEL_TYPE_ID,
           T.CREATE_DATE,
           T.CREATE_USER_ID,
           T.LAST_UPDATE_DATE,
           T.LAST_UPDATE_USER_ID)
        VALUES
          (MEMBER_LABEL_LINK_SEQ.NEXTVAL,
           S.MEMBER_KEY,
           S.M_LABEL_ID,
           1,
           SYSDATE,
           'yangjin',
           SYSDATE,
           'yangjin');
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
      /*������CODE֧��С������֧����ǩ*/
      INSERT INTO MEMBER_LABEL_LINK
        (ROW_ID,
         MEMBER_KEY,
         M_LABEL_ID,
         M_LABEL_TYPE_ID,
         CREATE_DATE,
         CREATE_USER_ID,
         LAST_UPDATE_DATE,
         LAST_UPDATE_USER_ID)
        SELECT MEMBER_LABEL_LINK_SEQ.NEXTVAL,
               F.MEMBER_KEY,
               G.M_LABEL_ID,
               G.M_LABEL_TYPE_ID,
               SYSDATE CREATE_DATE,
               'yangjin' CREATE_USER_ID,
               SYSDATE LAST_UPDATE_DATE,
               'yangjin' LAST_UPDATE_USER_ID
          FROM (SELECT E.MEMBER_KEY, E.PAYMENT_LABEL
                  FROM (SELECT D.MEMBER_KEY,
                               D.PAYMENT_METHOD,
                               D.ORDER_AMOUNT,
                               D.RANK1,
                               D.TOTAL_ORDER_AMOUNT,
                               CASE
                               /*COD֧����ʽ�Ľ����ںϼ�֧������60%*/
                                 WHEN D.RANK1 = 1 AND
                                      D.PAYMENT_METHOD = 'PAYMENT_COD' AND
                                      D.ORDER_AMOUNT >=
                                      D.TOTAL_ORDER_AMOUNT * 0.6 THEN
                                  'PAYMENT_MOST_COD'
                               END PAYMENT_LABEL
                          FROM (SELECT C.MEMBER_KEY,
                                       C.PAYMENT_METHOD,
                                       C.ORDER_AMOUNT,
                                       RANK() OVER(PARTITION BY C.MEMBER_KEY ORDER BY C.ORDER_AMOUNT DESC) RANK1 /*������������*/,
                                       SUM(C.ORDER_AMOUNT) OVER(PARTITION BY C.MEMBER_KEY) TOTAL_ORDER_AMOUNT /*��Ա�ϼƶ������*/
                                  FROM (SELECT B.MEMBER_KEY,
                                               B.PAYMENT_METHOD,
                                               SUM(B.ORDER_AMOUNT) ORDER_AMOUNT
                                          FROM (SELECT A.CUST_NO MEMBER_KEY,
                                                       A.ADD_TIME,
                                                       TO_CHAR(A.ORDER_SN) ORDER_NO,
                                                       CASE
                                                         WHEN UPPER(A.PAYMENTCHANNEL) =
                                                              '����֧��' OR
                                                              A.PAYMENTCHANNEL IS NULL THEN
                                                          'PAYMENT_COD' /*COD*/
                                                         ELSE
                                                          'PAYMENT_ONLINE' /*����֧��*/
                                                       END PAYMENT_METHOD,
                                                       A.ORDER_AMOUNT
                                                  FROM FACT_EC_ORDER A
                                                 WHERE A.ORDER_STATE >= 20 /*�Ѹ����*/
                                                      /*��������-180��*/
                                                   AND A.ADD_TIME BETWEEN
                                                       TO_CHAR(TRUNC(IN_POSTING_DATE - 179),
                                                               'YYYYMMDD') AND
                                                       TO_CHAR(TRUNC(IN_POSTING_DATE),
                                                               'YYYYMMDD')) B
                                         WHERE B.PAYMENT_METHOD IS NOT NULL
                                         GROUP BY B.MEMBER_KEY,
                                                  B.PAYMENT_METHOD) C) D) E
                 WHERE E.PAYMENT_LABEL IS NOT NULL
                      /*�޳����������=0��member*/
                   AND E.TOTAL_ORDER_AMOUNT > 0) F,
               MEMBER_LABEL_HEAD G
         WHERE G.M_LABEL_ID = 141
           AND F.PAYMENT_LABEL = G.M_LABEL_NAME
              /*��Ա����Ѿ������˱�ǩ���ظ���*/
           AND NOT EXISTS (SELECT 1
                  FROM MEMBER_LABEL_LINK H
                 WHERE H.M_LABEL_ID = 141
                   AND F.MEMBER_KEY = H.MEMBER_KEY);
      INSERT_ROWS := INSERT_ROWS + SQL%ROWCOUNT;
      COMMIT;
    END;
    /*��־��¼ģ��*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_UPD := UPDATE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '�������:IN_POSTING_DATE_KEY:' ||
                            TO_CHAR(IN_POSTING_DATE_KEY);
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
  END MEMBER_PAYMENT_METHOD;

  PROCEDURE MEMBER_LIFE_PERIOD(IN_POSTING_DATE_KEY IN NUMBER) IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
    --IN_POSTING_DATE DATE;
    /*
    ����˵����MEMBER_LIFE_PERIOD   �û���������
                NEW_CUSTOMER_PERIOD  �¿ͣ�δ���������������ܶ�������
                TRIAL_PERIOD         �����ڣ�����������δ������Ч������
                UNDERSTANDING_PERIOD �˽��ڣ�����1~3����Ч������
                BELIEVE_PERIOD       �����ڣ�����4��6����Ч������
                GOOD_FRIEND_PERIOD   �������ڣ�����7��������Ч������
                INJURED_PERIOD       ���˺��ڣ������Ǹ���ԭ����ˡ����ߺ�δ������Ч��������
    ����ʱ�䣺yangjin  2017-09-26
    */
  BEGIN
    SP_NAME          := 'MEMBER_LABEL_PKG.MEMBER_LIFE_PERIOD'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME := 'MEMBER_LABEL_LINK'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı���
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    --IN_POSTING_DATE  := TO_DATE(IN_POSTING_DATE_KEY, 'YYYYMMDD');
  
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
      /*MEMBER_LIFE_PERIOD_TMP_A*/
      EXECUTE IMMEDIATE 'TRUNCATE TABLE MEMBER_LIFE_PERIOD_TMP_A';
      INSERT INTO MEMBER_LIFE_PERIOD_TMP_A
        SELECT DISTINCT K.MEMBER_BP
          FROM (
                /*��ȡ���충���Ļ�ԱBP��*/
                SELECT D.MEMBER_KEY MEMBER_BP
                  FROM FACT_ORDER D
                 WHERE D.ORDER_DATE_KEY = IN_POSTING_DATE_KEY
                UNION ALL
                /*��ȡ����ע��Ļ�ԱBP��*/
                SELECT J.MEMBER_BP
                  FROM DIM_MEMBER J
                 WHERE J.MEMBER_INSERT_DATE = TO_CHAR(IN_POSTING_DATE_KEY)) K;
      COMMIT;
    
      /*MEMBER_LIFE_PERIOD_TMP_B,
      MEMBER_LABEL_PKG.MEMBER_REPURCHASE_CYCLE_DAYSʹ�ô���ʱ��*/
      INSERT INTO MEMBER_LIFE_PERIOD_TMP_B
        SELECT A.POSTING_DATE_KEY, A.MEMBER_KEY, A.ORDER_KEY, A.ORDER_STATE
          FROM FACT_ORDER A
         WHERE A.POSTING_DATE_KEY = IN_POSTING_DATE_KEY
           AND NOT EXISTS
         (SELECT 1
                  FROM MEMBER_LIFE_PERIOD_TMP_B B
                 WHERE A.POSTING_DATE_KEY = B.POSTING_DATE_KEY
                   AND A.MEMBER_KEY = B.MEMBER_KEY
                   AND A.ORDER_KEY = B.ORDER_KEY);
      COMMIT;
    
      MERGE /*+APPEND*/
      INTO (SELECT ROW_ID,
                   MEMBER_KEY,
                   M_LABEL_ID,
                   M_LABEL_TYPE_ID,
                   CREATE_DATE,
                   CREATE_USER_ID,
                   LAST_UPDATE_DATE,
                   LAST_UPDATE_USER_ID
              FROM MEMBER_LABEL_LINK
             WHERE M_LABEL_ID BETWEEN 162 AND 166) T
      USING (SELECT H.MEMBER_KEY, I.M_LABEL_ID
               FROM (SELECT G.MEMBER_BP MEMBER_KEY,
                            CASE
                              WHEN G.ORDER_STATE IS NULL THEN
                               'NEW_CUSTOMER_PERIOD' /*���û���*/
                              WHEN G.ORDER_STATE = 0 THEN
                               'TRIAL_PERIOD' /*������*/
                              WHEN G.ORDER_STATE = 1 AND
                                   G.ORDER_COUNT BETWEEN 1 AND 3 THEN
                               'UNDERSTANDING_PERIOD' /*�˽���*/
                              WHEN G.ORDER_STATE = 1 AND
                                   G.ORDER_COUNT BETWEEN 4 AND 6 THEN
                               'BELIEVE_PERIOD' /*������*/
                              WHEN G.ORDER_STATE = 1 AND G.ORDER_COUNT >= 7 THEN
                               'GOOD_FRIEND_PERIOD' /*������*/
                            END MEMBER_LIFE_PERIOD
                       FROM (SELECT DISTINCT F.MEMBER_BP,
                                             FIRST_VALUE(F.ORDER_STATE) OVER(PARTITION BY F.MEMBER_BP ORDER BY F.ORDER_STATE DESC) ORDER_STATE,
                                             FIRST_VALUE(F.ORDER_COUNT) OVER(PARTITION BY F.MEMBER_BP ORDER BY F.ORDER_STATE DESC) ORDER_COUNT
                               FROM (SELECT E.MEMBER_BP,
                                            E.ORDER_STATE,
                                            COUNT(E.ORDER_KEY) ORDER_COUNT
                                       FROM (SELECT A.MEMBER_BP,
                                                    B.ORDER_KEY,
                                                    B.ORDER_STATE
                                               FROM MEMBER_LIFE_PERIOD_TMP_A A,
                                                    MEMBER_LIFE_PERIOD_TMP_B B
                                              WHERE A.MEMBER_BP =
                                                    B.MEMBER_KEY(+)) E
                                      GROUP BY E.MEMBER_BP, E.ORDER_STATE) F) G) H,
                    MEMBER_LABEL_HEAD I
              WHERE I.M_LABEL_ID BETWEEN 162 AND 166
                AND H.MEMBER_LIFE_PERIOD = I.M_LABEL_NAME) S
      ON (T.MEMBER_KEY = S.MEMBER_KEY)
      WHEN MATCHED THEN
        UPDATE
           SET T.M_LABEL_ID = S.M_LABEL_ID, T.LAST_UPDATE_DATE = SYSDATE
      WHEN NOT MATCHED THEN
        INSERT
          (T.ROW_ID,
           T.MEMBER_KEY,
           T.M_LABEL_ID,
           T.M_LABEL_TYPE_ID,
           T.CREATE_DATE,
           T.CREATE_USER_ID,
           T.LAST_UPDATE_DATE,
           T.LAST_UPDATE_USER_ID)
        VALUES
          (MEMBER_LABEL_LINK_SEQ.NEXTVAL,
           S.MEMBER_KEY,
           S.M_LABEL_ID,
           1,
           SYSDATE,
           'yangjin',
           SYSDATE,
           'yangjin');
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
    END;
    /*��־��¼ģ��*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_UPD := UPDATE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '�������:IN_POSTING_DATE_KEY:' ||
                            TO_CHAR(IN_POSTING_DATE_KEY);
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
  END MEMBER_LIFE_PERIOD;

  PROCEDURE MEMBER_INJURED_PERIOD(IN_POSTING_DATE_KEY IN NUMBER) IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    DELETE_ROWS NUMBER;
    --IN_POSTING_DATE DATE;
    /*
    ����˵����INJURED_PERIOD       ���˺��ڣ������Ǹ���ԭ����ˡ����ߺ�δ������Ч��������
              ҵ�����Ա�зǸ���ԭ����˵Ķ��������ҵ���û����Ч����������ϱ�ǩ��
              ����Ѿ����ϱ�ǩ�Ļ�Ա����ҵ��������Ч��������ȡ����ǩ
              �˻�ԭ��:
              SELECT B.ONE_REASON, C.REASON_NM, B.TWO_REASON, D.REASON_NM
              FROM (SELECT DISTINCT A.ONE_REASON, A.TWO_REASON FROM FACT_ORDER_REVERSE A) B,
                   DIM_RE_RESEAON_1 C,
                   DIM_RE_RESEAON_2 D
             WHERE B.ONE_REASON = C.CODE
               AND B.TWO_REASON = D.CODE
             ORDER BY B.ONE_REASON, B.TWO_REASON;
    ����ʱ�䣺yangjin  2017-09-27
    */
  BEGIN
    SP_NAME          := 'MEMBER_LABEL_PKG.MEMBER_INJURED_PERIOD'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME := 'MEMBER_LABEL_LINK'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı���
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    --IN_POSTING_DATE  := TO_DATE(IN_POSTING_DATE_KEY, 'YYYYMMDD');
  
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
      /*���˺��ڱ�ǩ*/
      INSERT INTO MEMBER_LABEL_LINK
        (ROW_ID,
         MEMBER_KEY,
         M_LABEL_ID,
         M_LABEL_TYPE_ID,
         CREATE_DATE,
         CREATE_USER_ID,
         LAST_UPDATE_DATE,
         LAST_UPDATE_USER_ID)
        SELECT MEMBER_LABEL_LINK_SEQ.NEXTVAL,
               E.MEMBER_KEY,
               F.M_LABEL_ID,
               F.M_LABEL_TYPE_ID,
               SYSDATE CREATE_DATE,
               'yangjin' CREATE_USER_ID,
               SYSDATE LAST_UPDATE_DATE,
               'yangjin' LAST_UPDATE_USER_ID
          FROM (SELECT D.MEMBER_KEY
                  FROM (SELECT C.MEMBER_KEY,
                               CASE
                                 WHEN C.RANK1 = 1 AND C.O_CANCEL_STATE = 1 THEN
                                  1
                                 ELSE
                                  0
                               END IS_INJURED_PERIOD
                          FROM (SELECT RANK() OVER(PARTITION BY A.MEMBER_KEY ORDER BY A.ORDER_KEY DESC) RANK1, /*RANK1=1Ϊ���¶������жϴ˶����Ƿ����*/
                                       A.ORDER_OBJ_ID O_ORDER_OBJ_ID,
                                       A.ORDER_KEY O_ORDER_KEY,
                                       B.ORDER_OBJ_ID R_ORDER_OBJ_ID,
                                       B.ORDER_KEY R_ORDER_KEY,
                                       A.CANCEL_STATE O_CANCEL_STATE,
                                       B.CANCEL_STATE R_CANCEL_STATE,
                                       A.MEMBER_KEY,
                                       A.POSTING_DATE_KEY O_POSTING_DATE_KEY,
                                       B.POSTING_DATE_KEY R_POSTING_DATE_KEY
                                  FROM (SELECT *
                                          FROM FACT_ORDER
                                         WHERE POSTING_DATE_KEY =
                                               IN_POSTING_DATE_KEY) A,
                                       (SELECT *
                                          FROM FACT_ORDER_REVERSE
                                         WHERE POSTING_DATE_KEY =
                                               IN_POSTING_DATE_KEY
                                              /*�Ǹ���ԭ��*/
                                           AND ONE_REASON IN
                                               ('Y001',
                                                'Y007',
                                                'Y009',
                                                'Y010',
                                                'Y011',
                                                'Y012',
                                                'Y014',
                                                'Y015',
                                                'Y016',
                                                'Y017',
                                                'Y018',
                                                'Y019',
                                                'Y020',
                                                'Y021',
                                                'Y022',
                                                'Y023',
                                                'Y026',
                                                'Y027',
                                                'Y028',
                                                'Y029',
                                                'Y030',
                                                'Y031',
                                                'Y032',
                                                'Y037',
                                                'Y038',
                                                'Y043',
                                                'Y044',
                                                'Y045',
                                                'Y046',
                                                'Y047',
                                                'Y049',
                                                'Y050',
                                                'Y051',
                                                'Y052',
                                                'Y053',
                                                'Y054',
                                                'Y055',
                                                'Y056',
                                                'Y058',
                                                'Y059',
                                                'Y060',
                                                'Y062',
                                                'Y063',
                                                'Y064',
                                                'Y067',
                                                'Y068',
                                                'Y069',
                                                'Y070',
                                                'Y071',
                                                'Y072',
                                                'Y073')) B
                                 WHERE A.ORDER_KEY = B.ORDER_KEY(+)
                                /*AND A.MEMBER_KEY IN (1614619639, 1616669434)*/
                                ) C) D
                 WHERE D.IS_INJURED_PERIOD = 1
                   AND /*����Ѿ������˺��ڱ�ǩ���ظ���*/
                       NOT EXISTS (SELECT 1
                          FROM MEMBER_LABEL_LINK G
                         WHERE D.MEMBER_KEY = G.MEMBER_KEY
                           AND G.M_LABEL_ID = 167)) E,
               (SELECT M_LABEL_ID,
                       M_LABEL_NAME,
                       M_LABEL_DESC,
                       M_LABEL_TYPE_ID,
                       M_LABEL_FATHER_ID,
                       CREATE_DATE,
                       CREATE_USER_ID,
                       LAST_UPDATE_DATE,
                       LAST_UPDATE_USER_ID,
                       CURRENT_FLAG
                  FROM MEMBER_LABEL_HEAD
                 WHERE M_LABEL_NAME = 'INJURED_PERIOD') F;
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
      /*ȡ���˺��ڱ�ǩ*/
      DELETE MEMBER_LABEL_LINK C
       WHERE C.M_LABEL_ID = 167
         AND EXISTS
       (SELECT 1
                FROM (SELECT DISTINCT A.MEMBER_KEY
                        FROM FACT_ORDER A
                       WHERE A.POSTING_DATE_KEY = IN_POSTING_DATE_KEY
                            /*�жϻ�Ա�����һ�ʶ����Ƿ�����Ч����*/
                         AND A.ORDER_STATE = 1
                         AND EXISTS (SELECT 1
                                FROM (SELECT F.MEMBER_KEY,
                                             MAX(F.ORDER_KEY) ORDER_KEY
                                        FROM FACT_ORDER F
                                       WHERE F.POSTING_DATE_KEY =
                                             IN_POSTING_DATE_KEY
                                       GROUP BY F.MEMBER_KEY) E
                               WHERE A.MEMBER_KEY = E.MEMBER_KEY
                                 AND A.ORDER_KEY = E.ORDER_KEY)
                            /*�ж��Ƿ���MEMBER_LABEL_LINK�м�¼*/
                         AND EXISTS
                       (SELECT 1
                                FROM MEMBER_LABEL_LINK B
                               WHERE B.M_LABEL_ID = 167
                                 AND A.MEMBER_KEY = B.MEMBER_KEY)) D
               WHERE C.MEMBER_KEY = D.MEMBER_KEY);
      DELETE_ROWS := SQL%ROWCOUNT;
      COMMIT;
    END;
    /*��־��¼ģ��*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_DEL := DELETE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '�������:IN_POSTING_DATE_KEY:' ||
                            TO_CHAR(IN_POSTING_DATE_KEY);
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
  END MEMBER_INJURED_PERIOD;

END MEMBER_LABEL_PKG;
/