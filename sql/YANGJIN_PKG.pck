CREATE OR REPLACE PACKAGE YANGJIN_PKG IS

  -- AUTHOR  : YANGJIN
  -- CREATED : 2017-05-31 10:41:42
  -- PURPOSE : YANGJIN PACKAGE

  FUNCTION IP_INT_TO_STR(IN_IP_INT IN NUMBER) RETURN VARCHAR2;
  /*ip int ת��*/

  FUNCTION GET_IP_CITY(IN_IP_INT IN NUMBER) RETURN VARCHAR2;
  /*����ip��������*/

  PROCEDURE PROCESSMAKETHMSC_IA(STARTPOINT IN NUMBER);
  /*
  ������:       PROCESSMAKETHMSC_IA
  Ŀ��:         ��ԭFACT_HMSC_MARKET��Ļ����ϣ�ϸ������Ʒ�͵���
  ����:         yangjin
  ����ʱ�䣺    2017/05/31
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE OPER_PRODUCT_DAILY_RPT(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  ������:       OPER_PRODUCT_DAILY_RPT
  Ŀ��:         ��ý�����������ձ�
  ����:         yangjin
  ����ʱ�䣺    2017/06/13
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE OPER_PRODUCT_PVUV_DAILY_RPT(IN_VISIT_DATE_KEY IN NUMBER);
  /*
  ������:       OPER_PRODUCT_PVUV_DAILY_RPT
  Ŀ��:         
  ����:         yangjin
  ����ʱ�䣺    2017/06/29
  ����޸��ˣ�
  ���������ڣ�
  */

END YANGJIN_PKG;
/
CREATE OR REPLACE PACKAGE BODY YANGJIN_PKG IS

  FUNCTION IP_INT_TO_STR(IN_IP_INT IN NUMBER) RETURN VARCHAR2 IS
    RESULT_IP_STR VARCHAR2(20);
  BEGIN
    IF IN_IP_INT BETWEEN 0 AND 4294967295 THEN
      RESULT_IP_STR := TO_CHAR(FLOOR(IN_IP_INT / (256 * 256 * 256))) || '.' ||
                       TO_CHAR(FLOOR((IN_IP_INT -
                                     FLOOR(IN_IP_INT / (256 * 256 * 256)) * 256 * 256 * 256) /
                                     (256 * 256))) || '.' ||
                       TO_CHAR(FLOOR((IN_IP_INT -
                                     FLOOR(IN_IP_INT / (256 * 256 * 256)) * 256 * 256 * 256 -
                                     FLOOR((IN_IP_INT -
                                            FLOOR(IN_IP_INT /
                                                   (256 * 256 * 256)) * 256 * 256 * 256) /
                                            (256 * 256)) * 256 * 256) / 256)) || '.' ||
                       TO_CHAR(IN_IP_INT -
                               FLOOR(IN_IP_INT / (256 * 256 * 256)) * 256 * 256 * 256 -
                               FLOOR((IN_IP_INT -
                                     FLOOR(IN_IP_INT / (256 * 256 * 256)) * 256 * 256 * 256) /
                                     (256 * 256)) * 256 * 256 -
                               FLOOR((IN_IP_INT -
                                     FLOOR(IN_IP_INT / (256 * 256 * 256)) * 256 * 256 * 256 -
                                     FLOOR((IN_IP_INT -
                                            FLOOR(IN_IP_INT /
                                                   (256 * 256 * 256)) * 256 * 256 * 256) /
                                            (256 * 256)) * 256 * 256) / 256) * 256);
    ELSE
      RESULT_IP_STR := NULL;
    END IF;
    RETURN(RESULT_IP_STR);
  END IP_INT_TO_STR;

  FUNCTION GET_IP_CITY(IN_IP_INT IN NUMBER) RETURN VARCHAR2 IS
    RESULT_IP_CITY VARCHAR2(50);
  BEGIN
    SELECT /*+ INDEX(A,IP_START_IDX) */
     A.IP_CITY
      INTO RESULT_IP_CITY
      FROM DIM_IP_GEO A
     WHERE A.IP_START <= IN_IP_INT
       AND A.IP_END >= IN_IP_INT
       AND A.IP_CITY IS NOT NULL;
    RETURN(RESULT_IP_CITY);
  END GET_IP_CITY;

  PROCEDURE PROCESSMAKETHMSC_IA(STARTPOINT IN NUMBER) IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    --STARTPOINT  NUMBER;
    -- ENDPOINT    FACT_PAGE_VIEW.ID%TYPE;
    /*
    ����˵������ԭFACT_HMSC_MARKET��Ļ����ϣ�ϸ������Ʒ�͵���
    
    ����ʱ�䣺yangjin  2016-05-24
    */
  BEGIN
    SP_NAME          := 'YANGJIN_PKG.PROCESSMAKETHMSC_IA'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME := 'FACT_HMSC_ITEM_AREA_MARKET'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı��
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0' THEN
        S_ETL.ERR_MSG := 'û���ҵ���Ӧ�Ĺ��̼�����������';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
      /*����м��*/
      DELETE FROM FACT_PV_IA_HMSC;
      DELETE FROM FACT_ORDER_IA_HMSC;
      COMMIT;
    
      /*ɾ��ָ�����ڵ�����*/
      DELETE FACT_HMSC_ITEM_AREA_MARKET T
       WHERE T.VISIT_DATE_KEY = STARTPOINT;
      COMMIT;
    
      INSERT INTO FACT_PV_IA_HMSC
        (VISIT_DATE_KEY,
         APPLICATION_KEY,
         HMMD,
         HMPL,
         XLFLAG,
         GOODS_COMMONID,
         PV_IP_CITY,
         MCNT,
         VCNT,
         SCNT)
        SELECT /*+PARALLEL(16)*/
         F.VISIT_DATE_KEY,
         F.APPLICATION_KEY,
         F.HMMD,
         F.HMPL,
         F.XLFLAG,
         F.GOODS_COMMONID,
         YANGJIN_PKG.GET_IP_CITY(F.IP_INT) PV_IP_CITY,
         SUM(F.MCNT) MCNT,
         SUM(F.VCNT) VCNT,
         SUM(F.SCNT) SCNT
          FROM (SELECT E.VISIT_DATE_KEY,
                       E.APPLICATION_KEY,
                       E.HMMD,
                       E.HMPL,
                       E.XLFLAG,
                       E.GOODS_COMMONID,
                       E.IP_INT,
                       COUNT(DISTINCT E.MEMBER_KEY) MCNT,
                       COUNT(DISTINCT E.DEVICE_KEY) VCNT,
                       COUNT(DISTINCT E.SESSION_KEY) SCNT
                  FROM (SELECT A.VISIT_DATE_KEY,
                               DECODE(A.APPLICATION_KEY,
                                      10,
                                      'IOS',
                                      20,
                                      'ANDROID') AS APPLICATION_KEY,
                               (SELECT B.HMMD
                                  FROM DIM_HMSC B
                                 WHERE B.HMSC = A.HMSC) AS HMMD,
                               (SELECT C.HMPL
                                  FROM DIM_HMSC C
                                 WHERE C.HMSC = A.HMSC) AS HMPL,
                               CASE
                                 WHEN EXISTS
                                  (SELECT *
                                         FROM FACT_VISITOR_REGISTER D
                                        WHERE D.CREATE_DATE_KEY BETWEEN
                                              TO_NUMBER(TO_CHAR(ADD_MONTHS(TO_DATE(TO_CHAR(STARTPOINT),
                                                                                   'yyyymmdd'),
                                                                           -1),
                                                                'yyyymmdd')) AND
                                              STARTPOINT
                                          AND D.VISTOR_KEY = A.DEVICE_KEY) THEN
                                  '���û�'
                                 ELSE
                                  '���û�'
                               END AS XLFLAG,
                               A.PAGE_VALUE GOODS_COMMONID,
                               A.IP_INT,
                               A.MEMBER_KEY,
                               A.DEVICE_KEY,
                               A.SESSION_KEY
                          FROM FACT_PAGE_VIEW A
                         WHERE UPPER(A.PAGE_NAME) = 'GOOD'
                           AND REGEXP_LIKE(A.PAGE_VALUE, '^[[:digit:]]+$')
                           AND A.VISIT_DATE_KEY = STARTPOINT) E
                 GROUP BY E.VISIT_DATE_KEY,
                          E.APPLICATION_KEY,
                          E.HMMD,
                          E.HMPL,
                          E.XLFLAG,
                          E.GOODS_COMMONID,
                          E.IP_INT) F
         GROUP BY F.VISIT_DATE_KEY,
                  F.APPLICATION_KEY,
                  F.HMMD,
                  F.HMPL,
                  F.XLFLAG,
                  F.GOODS_COMMONID,
                  YANGJIN_PKG.GET_IP_CITY(F.IP_INT);
      COMMIT;
    
      INSERT INTO FACT_ORDER_IA_HMSC
        (ORDER_CREATE_KEY,
         APPLICATION_KEY,
         HMMD,
         HMPL,
         XLFLAG,
         GOODS_COMMONID,
         ORDER_IP_CITY,
         ORDERRS,
         ORDERCS,
         ORDERAMOUNT,
         ORDERCGRS,
         ORDERCGCS,
         ORDERCGAMOUNT)
      
        SELECT F.ORDER_CREATE_KEY,
               F.APPLICATION_KEY,
               F.HMMD,
               F.HMPL,
               F.XLFLAG,
               F.GOODS_COMMONID,
               F.ORDER_IP_CITY,
               COUNT(DISTINCT F.CUST_NO) ORDERRS,
               COUNT(DISTINCT F.ORDER_SN) ORDERCS,
               SUM(F.ORDER_AMOUNT) AS ORDERAMOUNT,
               COUNT(DISTINCT F.CUST_CG_NO) ORDERCGRS,
               COUNT(DISTINCT F.ORDER_CG_SN) ORDERCGCS,
               SUM(F.ORDER_CG_AMOUNT) AS ORDERCGAMOUNT
          FROM (SELECT A.ADD_TIME ORDER_CREATE_KEY,
                       DECODE(C.APPLICATION_KEY, 10, 'IOS', 20, 'ANDROID') AS APPLICATION_KEY,
                       (SELECT D.HMMD FROM DIM_HMSC D WHERE D.HMSC = C.HMSC) AS HMMD,
                       (SELECT D.HMPL FROM DIM_HMSC D WHERE D.HMSC = C.HMSC) AS HMPL,
                       CASE
                         WHEN EXISTS (SELECT *
                                 FROM FACT_VISITOR_REGISTER E
                                WHERE E.CREATE_DATE_KEY BETWEEN
                                      TO_NUMBER(TO_CHAR(ADD_MONTHS(TO_DATE(TO_CHAR(STARTPOINT),
                                                                           'yyyymmdd'),
                                                                   -1),
                                                        'yyyymmdd')) AND
                                      STARTPOINT
                                  AND E.VID = C.VID) THEN
                          '���û�'
                         ELSE
                          '���û�'
                       END AS XLFLAG,
                       A.CUST_NO,
                       A.ORDER_SN,
                       A.ORDER_AMOUNT,
                       CASE
                         WHEN (A.PAYMENT_CODE = 'offline' OR
                              A.ORDER_STATE IN (20, 30, 40, 50)) THEN
                          A.CUST_NO
                       END CUST_CG_NO,
                       CASE
                         WHEN (A.PAYMENT_CODE = 'offline' OR
                              A.ORDER_STATE IN (20, 30, 40, 50)) THEN
                          A.ORDER_SN
                       END ORDER_CG_SN,
                       CASE
                         WHEN (A.PAYMENT_CODE = 'offline' OR
                              A.ORDER_STATE IN (20, 30, 40, 50)) THEN
                          A.ORDER_AMOUNT
                         ELSE
                          0
                       END ORDER_CG_AMOUNT,
                       B.GOODS_COMMONID,
                       YANGJIN_PKG.GET_IP_CITY(GET_IP_NUMBER(A.ORDER_IP)) ORDER_IP_CITY
                  FROM FACT_EC_ORDER         A,
                       FACT_EC_ORDERGOODS    B,
                       FACT_VISITOR_REGISTER C
                 WHERE A.ORDER_ID = B.ORDER_ID
                   AND A.VID = C.VID
                   AND A.ADD_TIME = STARTPOINT
                   AND A.APP_NAME IN ('KLGAndroid', 'KLGiPhone')) F
         GROUP BY F.ORDER_CREATE_KEY,
                  F.APPLICATION_KEY,
                  F.HMMD,
                  F.HMPL,
                  F.XLFLAG,
                  F.GOODS_COMMONID,
                  F.ORDER_IP_CITY;
      COMMIT;
    
      INSERT INTO FACT_HMSC_ITEM_AREA_MARKET
        (VISIT_DATE_KEY,
         APPLICATION_KEY,
         HMMD,
         HMPL,
         XLFLAG,
         ITEM_CODE,
         GOODS_NAME,
         IP_CITY,
         MCNT,
         VCNT,
         SCNT,
         ORDERRS,
         ORDERCS,
         ORDERAMOUNT,
         ORDERCGRS,
         ORDERCGCS,
         ORDERCGAMOUNT,
         INSERT_DT,
         UPDATE_DT)
        SELECT D.VISIT_DATE_KEY,
               D.APPLICATION_KEY,
               D.HMMD,
               D.HMPL,
               D.XLFLAG,
               E.ITEM_CODE,
               E.GOODS_NAME,
               D.IP_CITY,
               D.MCNT,
               D.VCNT,
               D.SCNT,
               D.ORDERRS,
               D.ORDERCS,
               D.ORDERAMOUNT,
               D.ORDERCGRS,
               D.ORDERCGCS,
               D.ORDERCGAMOUNT,
               SYSDATE,
               SYSDATE
          FROM (SELECT A.VISIT_DATE_KEY,
                       A.APPLICATION_KEY,
                       A.HMMD,
                       A.HMPL,
                       A.XLFLAG,
                       A.PV_IP_CITY IP_CITY,
                       A.GOODS_COMMONID,
                       NVL(A.MCNT, 0) AS MCNT,
                       NVL(A.VCNT, 0) AS VCNT,
                       NVL(A.SCNT, 0) AS SCNT,
                       NVL(C.ORDERRS, 0) AS ORDERRS,
                       NVL(C.ORDERCS, 0) AS ORDERCS,
                       NVL(C.ORDERAMOUNT, 0) AS ORDERAMOUNT,
                       NVL(C.ORDERCGRS, 0) AS ORDERCGRS,
                       NVL(C.ORDERCGCS, 0) AS ORDERCGCS,
                       NVL(C.ORDERCGAMOUNT, 0) AS ORDERCGAMOUNT
                  FROM (SELECT * FROM FACT_PV_IA_HMSC WHERE HMMD IS NOT NULL) A,
                       (SELECT *
                          FROM FACT_ORDER_IA_HMSC
                         WHERE HMMD IS NOT NULL) C
                 WHERE A.VISIT_DATE_KEY = C.ORDER_CREATE_KEY(+)
                   AND A.APPLICATION_KEY = C.APPLICATION_KEY(+)
                   AND A.HMMD = C.HMMD(+)
                   AND A.HMPL = C.HMPL(+)
                   AND A.XLFLAG = C.XLFLAG(+)
                   AND A.PV_IP_CITY = C.ORDER_IP_CITY(+)
                   AND A.GOODS_COMMONID = C.GOODS_COMMONID(+)
                UNION
                SELECT C.ORDER_CREATE_KEY,
                       C.APPLICATION_KEY,
                       C.HMMD,
                       C.HMPL,
                       C.XLFLAG,
                       C.ORDER_IP_CITY,
                       C.GOODS_COMMONID,
                       NVL(A.MCNT, 0) AS MCNT,
                       NVL(A.VCNT, 0) AS VCNT,
                       NVL(A.SCNT, 0) AS SCNT,
                       NVL(C.ORDERRS, 0) AS ORDERRS,
                       NVL(C.ORDERCS, 0) AS ORDERCS,
                       NVL(C.ORDERAMOUNT, 0) AS ORDERAMOUNT,
                       NVL(C.ORDERCGRS, 0) AS ORDERCGRS,
                       NVL(C.ORDERCGCS, 0) AS ORDERCGCS,
                       NVL(C.ORDERCGAMOUNT, 0) AS ORDERCGAMOUNT
                  FROM (SELECT * FROM FACT_PV_IA_HMSC WHERE HMMD IS NOT NULL) A,
                       (SELECT *
                          FROM FACT_ORDER_IA_HMSC
                         WHERE HMMD IS NOT NULL) C
                 WHERE A.VISIT_DATE_KEY(+) = C.ORDER_CREATE_KEY
                   AND A.APPLICATION_KEY(+) = C.APPLICATION_KEY
                   AND A.HMMD(+) = C.HMMD
                   AND A.HMPL(+) = C.HMPL
                   AND A.XLFLAG(+) = C.XLFLAG
                   AND A.PV_IP_CITY(+) = C.ORDER_IP_CITY
                   AND A.GOODS_COMMONID(+) = C.GOODS_COMMONID) D,
               DIM_EC_GOOD E
         WHERE D.GOODS_COMMONID = E.GOODS_COMMONID;
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    END;
  
    /*��־��¼ģ��*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
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
    
  END PROCESSMAKETHMSC_IA;

  PROCEDURE OPER_PRODUCT_DAILY_RPT(IN_POSTING_DATE_KEY IN NUMBER) IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    /*
    ����˵������ý�����������ձ�
    ����ʱ�䣺yangjin  2016-06-13
    */
  BEGIN
    SP_NAME          := 'YANGJIN_PKG.OPER_PRODUCT_DAILY_RPT'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME := 'OPER_PRODUCT_DAILY_REPORT'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı��
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0' THEN
        S_ETL.ERR_MSG := 'û���ҵ���Ӧ�Ĺ��̼�����������';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
      /*ɾ��ָ�����ڵ�����*/
      DELETE OPER_PRODUCT_DAILY_REPORT T
       WHERE T.POSTING_DATE_KEY = IN_POSTING_DATE_KEY;
      COMMIT;
    
      INSERT INTO OPER_PRODUCT_DAILY_REPORT
        (ROW_ID,
         POSTING_DATE_KEY,
         SALES_SOURCE_NAME,
         SALES_SOURCE_SECOND_NAME,
         OWN_ACCOUNT,
         BRAND_NAME,
         TRAN_TYPE,
         TRAN_TYPE_NAME,
         ITEM_OR_GIFT,
         MATDLT,
         MATZLT,
         MATXLT,
         MD_PERSON,
         ITEM_CODE,
         GOODS_KEY,
         GOODS_NAME,
         TOTAL_ORDER_AMOUNT,
         NET_ORDER_AMOUNT,
         EFFECTIVE_ORDER_AMOUNT,
         CANCEL_ORDER_AMOUNT,
         REVERSE_ORDER_AMOUNT,
         REJECT_ORDER_AMOUNT,
         CANCEL_REVERSE_AMOUNT,
         CANCEL_REJECT_AMOUNT,
         TOTAL_SALES_AMOUNT,
         NET_SALES_AMOUNT,
         EFFECTIVE_SALES_AMOUNT,
         TOTAL_ORDER_MEMBER_COUNT,
         NET_ORDER_MEMBER_COUNT,
         EFFECTIVE_ORDER_MEMBER_COUNT,
         CANCEL_ORDER_MEMBER_COUNT,
         REVERSE_MEMBER_COUNT,
         REJECT_MEMBER_COUNT,
         CANCEL_REVERSE_MEMBER_COUNT,
         CANCEL_REJECT_MEMBER_COUNT,
         TOTAL_ORDER_COUNT,
         NET_ORDER_COUNT,
         EFFECTIVE_ORDER_COUNT,
         CANCEL_ORDER_COUNT,
         REVERSE_COUNT,
         REJECT_COUNT,
         CANCEL_REVERSE_COUNT,
         CANCEL_REJECT_COUNT,
         GROSS_PROFIT_AMOUNT,
         NET_PROFIT_AMOUNT,
         EFFECTIVE_PROFIT_AMOUNT,
         GROSS_PROFIT_RATE,
         NET_PROFIT_RATE,
         EFFECTIVE_PROFIT_RATE,
         TOTAL_ORDER_QTY,
         NET_ORDER_QTY,
         EFFECTIVE_ORDER_QTY,
         CANCEL_ORDER_QTY,
         REVERSE_QTY,
         REJECT_QTY,
         CANCEL_REVERSE_QTY,
         CANCEL_REJECT_QTY,
         NET_ORDER_CUST_PRICE,
         EFFECTIVE_ORDER_CUST_PRICE,
         NET_ORDER_UNIT_PRICE,
         EFFECTIVE_ORDER_UNIT_PRICE,
         TOTAL_PURCHASE_AMOUNT,
         NET_PURCHASE_AMOUNT,
         EFFECTIVE_PURCHASE_AMOUNT,
         PROFIT_AMOUNT,
         COUPONS_AMOUNT,
         FREIGHT_AMOUNT,
         PRODUCT_AVG_PRICE,
         REJECT_AMOUNT,
         LIVE_OR_REPLAY)
        SELECT OPER_PRODUCT_DAILY_REPORT_SEQ.NEXTVAL,
               FO.POSTING_DATE_KEY /*��������key*/,
               DS.SALES_SOURCE_NAME /*����һ����֯����*/,
               DS.SALES_SOURCE_SECOND_NAME /*���۶�����֯����*/,
               DG.OWN_ACCOUNT /*�Ƿ���Ӫ*/,
               DG.BRAND_NAME /*Ʒ��*/,
               FO.TRAN_TYPE /*��������*/,
               FO.TRAN_TYPE_NAME /*��������˵��*/,
               FO.ITEM_OR_GIFT /*����Ʒ*/,
               DG.MATDLT /*���ϴ���*/,
               DG.MATZLT /*��������*/,
               DG.MATXLT /*����С��*/,
               FO.MD_PERSON /*MD����*/,
               DG.ITEM_CODE /*��Ʒ�̱���*/,
               FO.GOODS_KEY /*��Ʒ������*/,
               DG.GOODS_NAME /*��Ʒ����*/,
               FO.TOTAL_ORDER_AMOUNT /*�ܶ������*/,
               FO.NET_ORDER_AMOUNT /*���������*/,
               FO.EFFECTIVE_ORDER_AMOUNT /*��Ч�������*/,
               FO.CANCEL_ORDER_AMOUNT /*ȡ���������*/,
               FO.REVERSE_ORDER_AMOUNT /*�˻��������*/,
               FO.REJECT_ORDER_AMOUNT /*���ն������*/,
               FO.CANCEL_REVERSE_AMOUNT /*�˻�ȡ���������*/,
               FO.CANCEL_REJECT_AMOUNT /*����ȡ���������*/,
               FO.TOTAL_SALES_AMOUNT /*���ۼ۽��*/,
               FO.NET_SALES_AMOUNT /*���ۼ۽��*/,
               FO.EFFECTIVE_SALES_AMOUNT /*��Ч�ۼ۽��*/,
               FO.TOTAL_ORDER_MEMBER_COUNT /*�ܶ�������*/,
               FO.NET_ORDER_MEMBER_COUNT /*����������*/,
               FO.EFFECTIVE_ORDER_MEMBER_COUNT /*��Ч��������*/,
               FO.CANCEL_ORDER_MEMBER_COUNT /*ȡ����������*/,
               FO.REVERSE_MEMBER_COUNT /*�˻���������*/,
               FO.REJECT_MEMBER_COUNT /*���ն�������*/,
               FO.CANCEL_REVERSE_MEMBER_COUNT /*�˻�ȡ����������*/,
               FO.CANCEL_REJECT_MEMBER_COUNT /*����ȡ����������*/,
               FO.TOTAL_ORDER_COUNT /*�ܶ�������*/,
               FO.NET_ORDER_COUNT /*����������*/,
               FO.EFFECTIVE_ORDER_COUNT /*��Ч��������*/,
               FO.CANCEL_ORDER_COUNT /*ȡ����������*/,
               FO.REVERSE_COUNT /*�˻���������*/,
               FO.REJECT_COUNT /*���ն�������*/,
               FO.CANCEL_REVERSE_COUNT /*�˻�ȡ����������*/,
               FO.CANCEL_REJECT_COUNT /*����ȡ����������*/,
               FO.GROSS_PROFIT_AMOUNT /*��ԭ����ë����*/,
               FO.NET_PROFIT_AMOUNT /*��ԭ��ë����*/,
               FO.EFFECTIVE_PROFIT_AMOUNT /*��ԭ����Чë����*/,
               FO.GROSS_PROFIT_RATE /*��ԭ����ë����*/,
               FO.NET_PROFIT_RATE /*��ԭ��ë����*/,
               FO.EFFECTIVE_PROFIT_RATE /*��ԭ����Чë����*/,
               FO.TOTAL_ORDER_QTY /*�ܶ�������*/,
               FO.NET_ORDER_QTY /*����������*/,
               FO.EFFECTIVE_ORDER_QTY /*��Ч��������*/,
               FO.CANCEL_ORDER_QTY /*ȡ����������*/,
               FO.REVERSE_QTY /*�˻���������*/,
               FO.REJECT_QTY /*���ն�������*/,
               FO.CANCEL_REVERSE_QTY /*�˻�ȡ����������*/,
               FO.CANCEL_REJECT_QTY /*����ȡ����������*/,
               FO.NET_ORDER_CUST_PRICE /*�������͵���*/,
               FO.EFFECTIVE_ORDER_CUST_PRICE /*��Ч�����͵���*/,
               FO.NET_ORDER_UNIT_PRICE /*������������*/,
               FO.EFFECTIVE_ORDER_UNIT_PRICE /*��Ч����������*/,
               FO.TOTAL_PURCHASE_AMOUNT /*�ܶ����ɱ�*/,
               FO.NET_PURCHASE_AMOUNT /*�������ɱ�*/,
               FO.EFFECTIVE_PURCHASE_AMOUNT /*��Ч�����ɱ�*/,
               FO.PROFIT_AMOUNT /*�ۿ۽��*/,
               FO.COUPONS_AMOUNT /*�Ż�ȯ���*/,
               FO.FREIGHT_AMOUNT /*�˷�*/,
               FO.PRODUCT_AVG_PRICE /*��Ʒƽ���ۼ�*/,
               FO.REJECT_AMOUNT /*���˽��*/,
               FO.LIVE_OR_REPLAY /*ֱ���ز�*/
          FROM (SELECT OD2.GOODS_KEY /**/,
                       OD2.GOODS_COMMON_KEY /**/,
                       OD2.SALES_SOURCE_SECOND_KEY /*���۶�����֯key*/,
                       OD2.ITEM_OR_GIFT /*����Ʒ*/,
                       OD2.TRAN_TYPE /*��������*/,
                       DECODE(OD2.TRAN_TYPE,
                              'TAN',
                              '��Ʒ',
                              'REN',
                              '��Ʒ�˻�') TRAN_TYPE_NAME /*��������˵��*/,
                       OD2.MD_PERSON /*MD����*/,
                       OD2.POSTING_DATE_KEY /*��������key*/,
                       OD2.LIVE_OR_REPLAY /*�Ƿ񲥳�*/,
                       OD2.TOTAL_ORDER_AMOUNT /*�ܶ������*/,
                       OD2.NET_ORDER_AMOUNT /*���������*/,
                       OD2.EFFECTIVE_ORDER_AMOUNT /*��Ч�������*/,
                       OD2.CANCEL_ORDER_AMOUNT /*ȡ���������*/,
                       OD2.REVERSE_ORDER_AMOUNT /*�˻��������*/,
                       OD2.REJECT_ORDER_AMOUNT /*���ն������*/,
                       OD2.CANCEL_REVERSE_AMOUNT /*�˻�ȡ���������*/,
                       OD2.CANCEL_REJECT_AMOUNT /*����ȡ���������*/,
                       OD2.TOTAL_SALES_AMOUNT /*���ۼ۽��*/,
                       OD2.NET_SALES_AMOUNT /*���ۼ۽��*/,
                       OD2.EFFECTIVE_SALES_AMOUNT /*��Ч�ۼ۽��*/,
                       OD2.TOTAL_ORDER_MEMBER_COUNT /*�ܶ�������*/,
                       OD2.NET_ORDER_MEMBER_COUNT /*����������*/,
                       OD2.EFFECTIVE_ORDER_MEMBER_COUNT /*��Ч��������*/,
                       OD2.CANCEL_ORDER_MEMBER_COUNT /*ȡ����������*/,
                       OD2.REVERSE_MEMBER_COUNT /*�˻���������*/,
                       OD2.REJECT_MEMBER_COUNT /*���ն�������*/,
                       OD2.CANCEL_REVERSE_MEMBER_COUNT /*�˻�ȡ����������*/,
                       OD2.CANCEL_REJECT_MEMBER_COUNT /*����ȡ����������*/,
                       OD2.TOTAL_ORDER_COUNT /*�ܶ�������*/,
                       OD2.NET_ORDER_COUNT /*����������*/,
                       OD2.EFFECTIVE_ORDER_COUNT /*��Ч��������*/,
                       OD2.CANCEL_ORDER_COUNT /*ȡ����������*/,
                       OD2.REVERSE_COUNT /*�˻���������*/,
                       OD2.REJECT_COUNT /*���ն�������*/,
                       OD2.CANCEL_REVERSE_COUNT /*�˻�ȡ����������*/,
                       OD2.CANCEL_REJECT_COUNT /*����ȡ����������*/,
                       OD2.TOTAL_ORDER_AMOUNT + OD2.PROFIT_AMOUNT -
                       OD2.TOTAL_PURCHASE_AMOUNT GROSS_PROFIT_AMOUNT /*��ԭ����ë����*/,
                       OD2.NET_ORDER_AMOUNT + OD2.PROFIT_AMOUNT -
                       OD2.NET_PURCHASE_AMOUNT NET_PROFIT_AMOUNT /*��ԭ��ë����*/,
                       OD2.EFFECTIVE_ORDER_AMOUNT + OD2.PROFIT_AMOUNT -
                       OD2.EFFECTIVE_PURCHASE_AMOUNT EFFECTIVE_PROFIT_AMOUNT /*��ԭ����Чë����*/,
                       DECODE(OD2.TOTAL_ORDER_AMOUNT,
                              0,
                              0,
                              (OD2.TOTAL_ORDER_AMOUNT + OD2.PROFIT_AMOUNT -
                              OD2.TOTAL_PURCHASE_AMOUNT) /
                              OD2.TOTAL_ORDER_AMOUNT) GROSS_PROFIT_RATE /*��ԭ����ë����*/,
                       DECODE(OD2.NET_ORDER_AMOUNT,
                              0,
                              0,
                              (OD2.NET_ORDER_AMOUNT + OD2.PROFIT_AMOUNT -
                              OD2.NET_PURCHASE_AMOUNT) / OD2.NET_ORDER_AMOUNT) NET_PROFIT_RATE /*��ԭ��ë����*/,
                       DECODE(OD2.EFFECTIVE_ORDER_AMOUNT,
                              0,
                              0,
                              (OD2.EFFECTIVE_ORDER_AMOUNT + OD2.PROFIT_AMOUNT -
                              OD2.EFFECTIVE_PURCHASE_AMOUNT) /
                              OD2.EFFECTIVE_ORDER_AMOUNT) EFFECTIVE_PROFIT_RATE /*��ԭ����Чë����*/,
                       OD2.TOTAL_ORDER_QTY /*�ܶ�������*/,
                       OD2.NET_ORDER_QTY /*����������*/,
                       OD2.EFFECTIVE_ORDER_QTY /*��Ч��������*/,
                       OD2.CANCEL_ORDER_QTY /*ȡ����������*/,
                       OD2.REVERSE_QTY /*�˻���������*/,
                       OD2.REJECT_QTY /*���ն�������*/,
                       OD2.CANCEL_REVERSE_QTY /*�˻�ȡ����������*/,
                       OD2.CANCEL_REJECT_QTY /*����ȡ����������*/,
                       OD2.NET_ORDER_CUST_PRICE /*�������͵���*/,
                       OD2.EFFECTIVE_ORDER_CUST_PRICE /*��Ч�����͵���*/,
                       OD2.NET_ORDER_UNIT_PRICE /*������������*/,
                       OD2.EFFECTIVE_ORDER_UNIT_PRICE /*��Ч����������*/,
                       OD2.TOTAL_PURCHASE_AMOUNT /*�ܶ����ɱ�*/,
                       OD2.NET_PURCHASE_AMOUNT /*�������ɱ�*/,
                       OD2.EFFECTIVE_PURCHASE_AMOUNT /*��Ч�����ɱ�*/,
                       OD2.PROFIT_AMOUNT /*�ۿ۽��*/,
                       OD2.COUPONS_AMOUNT /*�Ż�ȯ���*/,
                       OD2.FREIGHT_AMOUNT /*�˷�*/,
                       OD2.PRODUCT_AVG_PRICE /*��Ʒƽ���ۼ�*/,
                       OD2.REJECT_AMOUNT /*���˽��*/
                  FROM (SELECT OD1.GOODS_KEY /**/,
                               OD1.GOODS_COMMON_KEY /**/,
                               OD1.SALES_SOURCE_SECOND_KEY /*���۶�����֯key*/,
                               DECODE(OD1.TRAN_TYPE, 0, '��Ʒ', 1, '��Ʒ') ITEM_OR_GIFT /*����Ʒ*/,
                               DECODE(OD1.CANCEL_STATE, 0, 'TAN', 1, 'REN') TRAN_TYPE /*��������*/,
                               OD1.MD_PERSON /*MD����*/,
                               OD1.POSTING_DATE_KEY /*��������key*/,
                               DECODE(OD1.LIVE_OR_REPLAY,
                                      '10',
                                      'ֱ��',
                                      '01',
                                      '�ز�',
                                      'δ����') LIVE_OR_REPLAY /*�Ƿ񲥳�*/,
                               SUM(DECODE(OD1.CANCEL_STATE,
                                          0,
                                          OD1.TOTAL_ORDER_AMOUNT,
                                          1,
                                          0)) TOTAL_ORDER_AMOUNT /*�ܶ������*/,
                               SUM(DECODE(OD1.CANCEL_STATE,
                                          0,
                                          OD1.NET_ORDER_AMOUNT,
                                          1,
                                          -ABS(OD1.NET_ORDER_AMOUNT))) NET_ORDER_AMOUNT /*���������*/,
                               SUM(DECODE(OD1.CANCEL_STATE,
                                          0,
                                          OD1.EFFECTIVE_ORDER_AMOUNT,
                                          1,
                                          -ABS(OD1.EFFECTIVE_ORDER_AMOUNT))) EFFECTIVE_ORDER_AMOUNT /*��Ч�������*/,
                               SUM(DECODE(OD1.CANCEL_STATE,
                                          0,
                                          0,
                                          1,
                                          OD1.TOTAL_ORDER_AMOUNT)) CANCEL_ORDER_AMOUNT /*ȡ���������*/,
                               0 REVERSE_ORDER_AMOUNT /*�˻��������*/,
                               0 REJECT_ORDER_AMOUNT /*���ն������*/,
                               0 CANCEL_REVERSE_AMOUNT /*�˻�ȡ���������*/,
                               0 CANCEL_REJECT_AMOUNT /*����ȡ���������*/,
                               SUM(DECODE(OD1.CANCEL_STATE,
                                          0,
                                          OD1.TOTAL_SALES_AMOUNT,
                                          1,
                                          0)) TOTAL_SALES_AMOUNT /*���ۼ۽��*/,
                               SUM(DECODE(OD1.CANCEL_STATE,
                                          0,
                                          OD1.NET_SALES_AMOUNT,
                                          1,
                                          -ABS(OD1.NET_SALES_AMOUNT))) NET_SALES_AMOUNT /*���ۼ۽��*/,
                               SUM(DECODE(OD1.CANCEL_STATE,
                                          0,
                                          OD1.EFFECTIVE_SALES_AMOUNT,
                                          1,
                                          -ABS(OD1.EFFECTIVE_SALES_AMOUNT))) EFFECTIVE_SALES_AMOUNT /*��Ч�ۼ۽��*/,
                               DECODE(OD1.CANCEL_STATE,
                                      0,
                                      COUNT(DISTINCT OD1.MEMBER_KEY),
                                      1,
                                      0) TOTAL_ORDER_MEMBER_COUNT /*�ܶ�������*/,
                               DECODE(OD1.CANCEL_STATE,
                                      0,
                                      COUNT(DISTINCT OD1.MEMBER_KEY),
                                      1,
                                      -COUNT(DISTINCT OD1.MEMBER_KEY)) NET_ORDER_MEMBER_COUNT /*����������*/,
                               DECODE(OD1.CANCEL_STATE,
                                      0,
                                      COUNT(DISTINCT OD1.MEMBER_KEY),
                                      1,
                                      -COUNT(DISTINCT OD1.MEMBER_KEY)) EFFECTIVE_ORDER_MEMBER_COUNT /*��Ч��������*/,
                               DECODE(OD1.CANCEL_STATE,
                                      0,
                                      0,
                                      1,
                                      COUNT(DISTINCT OD1.MEMBER_KEY)) CANCEL_ORDER_MEMBER_COUNT /*ȡ����������*/,
                               0 REVERSE_MEMBER_COUNT /*�˻���������*/,
                               0 REJECT_MEMBER_COUNT /*���ն�������*/,
                               0 CANCEL_REVERSE_MEMBER_COUNT /*�˻�ȡ����������*/,
                               0 CANCEL_REJECT_MEMBER_COUNT /*����ȡ����������*/,
                               DECODE(OD1.CANCEL_STATE,
                                      0,
                                      COUNT(DISTINCT OD1.ORDER_H_KEY),
                                      1,
                                      0) TOTAL_ORDER_COUNT /*�ܶ�������*/,
                               DECODE(OD1.CANCEL_STATE,
                                      0,
                                      COUNT(DISTINCT OD1.ORDER_H_KEY),
                                      1,
                                      -COUNT(DISTINCT OD1.ORDER_H_KEY)) NET_ORDER_COUNT /*����������*/,
                               DECODE(OD1.CANCEL_STATE,
                                      0,
                                      COUNT(DISTINCT OD1.ORDER_H_KEY),
                                      1,
                                      -COUNT(DISTINCT OD1.ORDER_H_KEY)) EFFECTIVE_ORDER_COUNT /*��Ч��������*/,
                               DECODE(OD1.CANCEL_STATE,
                                      0,
                                      0,
                                      1,
                                      COUNT(DISTINCT OD1.ORDER_H_KEY)) CANCEL_ORDER_COUNT /*ȡ����������*/,
                               0 REVERSE_COUNT /*�˻���������*/,
                               0 REJECT_COUNT /*���ն�������*/,
                               0 CANCEL_REVERSE_COUNT /*�˻�ȡ����������*/,
                               0 CANCEL_REJECT_COUNT /*����ȡ����������*/,
                               SUM(DECODE(OD1.CANCEL_STATE,
                                          0,
                                          OD1.TOTAL_ORDER_QTY,
                                          1,
                                          0)) TOTAL_ORDER_QTY /*�ܶ�������*/,
                               SUM(DECODE(OD1.CANCEL_STATE,
                                          0,
                                          OD1.NET_ORDER_QTY,
                                          1,
                                          -ABS(OD1.NET_ORDER_QTY))) NET_ORDER_QTY /*����������*/,
                               SUM(DECODE(OD1.CANCEL_STATE,
                                          0,
                                          OD1.EFFECTIVE_ORDER_QTY,
                                          1,
                                          -ABS(OD1.EFFECTIVE_ORDER_QTY))) EFFECTIVE_ORDER_QTY /*��Ч��������*/,
                               DECODE(OD1.CANCEL_STATE,
                                      0,
                                      0,
                                      1,
                                      COUNT(DISTINCT OD1.TOTAL_ORDER_QTY)) CANCEL_ORDER_QTY /*ȡ����������*/,
                               0 REVERSE_QTY /*�˻���������*/,
                               0 REJECT_QTY /*���ն�������*/,
                               0 CANCEL_REVERSE_QTY /*�˻�ȡ����������*/,
                               0 CANCEL_REJECT_QTY /*����ȡ����������*/,
                               SUM(OD1.NET_ORDER_AMOUNT) /
                               COUNT(DISTINCT OD1.MEMBER_KEY) NET_ORDER_CUST_PRICE /*�������͵���*/,
                               SUM(OD1.EFFECTIVE_ORDER_AMOUNT) /
                               COUNT(DISTINCT OD1.MEMBER_KEY) EFFECTIVE_ORDER_CUST_PRICE /*��Ч�����͵���*/,
                               SUM(OD1.NET_ORDER_AMOUNT) /
                               SUM(OD1.NET_ORDER_QTY) NET_ORDER_UNIT_PRICE /*������������*/,
                               SUM(OD1.EFFECTIVE_ORDER_AMOUNT) /
                               SUM(OD1.EFFECTIVE_ORDER_QTY) EFFECTIVE_ORDER_UNIT_PRICE /*��Ч����������*/,
                               SUM(DECODE(OD1.CANCEL_STATE,
                                          0,
                                          OD1.TOTAL_PURCHASE_AMOUNT,
                                          1,
                                          0)) TOTAL_PURCHASE_AMOUNT /*�ܶ����ɱ�*/,
                               SUM(DECODE(OD1.CANCEL_STATE,
                                          0,
                                          OD1.NET_PURCHASE_AMOUNT,
                                          1,
                                          -ABS(OD1.NET_PURCHASE_AMOUNT))) NET_PURCHASE_AMOUNT /*�������ɱ�*/,
                               SUM(DECODE(OD1.CANCEL_STATE,
                                          0,
                                          OD1.EFFECTIVE_PURCHASE_AMOUNT,
                                          1,
                                          -ABS(OD1.NET_PURCHASE_AMOUNT))) EFFECTIVE_PURCHASE_AMOUNT /*��Ч�����ɱ�*/,
                               SUM(DECODE(OD1.CANCEL_STATE,
                                          0,
                                          OD1.PROFIT_AMOUNT,
                                          1,
                                          -ABS(OD1.PROFIT_AMOUNT))) PROFIT_AMOUNT /*�ۿ۽��*/,
                               SUM(OD1.COUPONS_AMOUNT) COUPONS_AMOUNT /*�Ż�ȯ���*/,
                               SUM(OD1.FREIGHT_AMOUNT) FREIGHT_AMOUNT /*�˷�*/,
                               SUM(OD1.TOTAL_SALES_AMOUNT) /
                               SUM(OD1.TOTAL_ORDER_QTY) PRODUCT_AVG_PRICE /*��Ʒƽ���ۼ�*/,
                               0 REJECT_AMOUNT /*���˽��*/
                          FROM (SELECT OD.ORDER_KEY /*����Ȩ����*/,
                                       OD.ORDER_H_KEY /*����������*/,
                                       OD.ORDER_DESC /*����״̬*/,
                                       OD.GOODS_KEY /*��Ʒ*/,
                                       OD.GOODS_COMMON_KEY /*��Ʒ�̱���*/,
                                       OD.SALES_SOURCE_SECOND_KEY /*���۶�����֯key*/,
                                       OD.TRAN_TYPE /*�Ƿ���Ʒ��־*/,
                                       OD.TRAN_DESC /*��������*/,
                                       OD.MD_PERSON /*MD����*/,
                                       OD.POSTING_DATE_KEY /*��������key*/,
                                       TO_CHAR(OD.LIVE_STATE) ||
                                       TO_CHAR(OD.REPLAY_STATE) LIVE_OR_REPLAY /*ֱ���ز�*/,
                                       OD.ORDER_STATE /*����״̬*/,
                                       OD.CANCEL_STATE /*ȡ��״̬*/,
                                       OD.MEMBER_KEY /*��Աkey*/,
                                       OD.NUMS TOTAL_ORDER_QTY /*�ܶ�������*/,
                                       OD.NUMS NET_ORDER_QTY /*����������*/,
                                       OD.NUMS EFFECTIVE_ORDER_QTY /*��Ч��������*/,
                                       OD.ORDER_AMOUNT TOTAL_ORDER_AMOUNT /*�ܶ������*/,
                                       OD.ORDER_AMOUNT NET_ORDER_AMOUNT /*���������*/,
                                       OD.ORDER_AMOUNT EFFECTIVE_ORDER_AMOUNT /*��Ч�������*/,
                                       OD.SALES_AMOUNT TOTAL_SALES_AMOUNT /*���ۼ۽��*/,
                                       OD.SALES_AMOUNT NET_SALES_AMOUNT /*���������*/,
                                       OD.SALES_AMOUNT EFFECTIVE_SALES_AMOUNT /*��Ч�������*/,
                                       OD.UNIT_PRICE /*������Ʒ�ۼ�*/,
                                       OD.COST_PRICE /*��Ʒ�����ɱ�*/,
                                       OD.FREIGHT_AMOUNT /*�˷�*/,
                                       OD.COUPONS_PRICE COUPONS_AMOUNT /*�Ż�ȯ���*/,
                                       OD.PURCHASE_AMOUNT TOTAL_PURCHASE_AMOUNT /*�ܶ����ɱ�*/,
                                       OD.PURCHASE_AMOUNT NET_PURCHASE_AMOUNT /*�������ɱ�*/,
                                       OD.PURCHASE_AMOUNT EFFECTIVE_PURCHASE_AMOUNT /*��Ч�����ɱ�*/,
                                       OD.PROFIT_AMOUNT /*�ۿ۽��*/
                                  FROM (
                                        /*ȡ���Ķ���������������POSTING_DATE_KEY�����򶩵���
                                        2017-06-14 yangjin*/
                                        SELECT ODU1.ORDER_KEY /*����Ȩ����*/,
                                                ODU1.ORDER_H_KEY /*����������*/,
                                                ODU1.ORDER_DESC /*����״̬*/,
                                                ODU1.GOODS_KEY /*��Ʒ*/,
                                                ODU1.GOODS_COMMON_KEY /*��Ʒ�̱���*/,
                                                ODU1.SALES_SOURCE_SECOND_KEY /*���۶�����֯key*/,
                                                ODU1.TRAN_TYPE /*�Ƿ���Ʒ��־*/,
                                                ODU1.TRAN_DESC /*��������*/,
                                                ODU1.MD_PERSON /*MD����*/,
                                                ODU1.POSTING_DATE_KEY /*��������key*/,
                                                ODU1.LIVE_STATE /*�Ƿ�ֱ��*/,
                                                ODU1.REPLAY_STATE /*�Ƿ��ز�*/,
                                                ODU1.ORDER_STATE /*����״̬*/,
                                                CASE
                                                  WHEN ODU1.CANCEL_STATE = 1 AND
                                                       ODU1.POSTING_DATE_KEY <=
                                                       ODU1.UPDATE_TIME THEN
                                                   0
                                                  ELSE
                                                   ODU1.CANCEL_STATE
                                                END CANCEL_STATE /*ȡ��״̬*/,
                                                ODU1.MEMBER_KEY /*��Աkey*/,
                                                ODU1.NUMS,
                                                ODU1.ORDER_AMOUNT,
                                                ODU1.SALES_AMOUNT,
                                                ODU1.UNIT_PRICE /*������Ʒ�ۼ�*/,
                                                ODU1.COST_PRICE /*��Ʒ�����ɱ�*/,
                                                ODU1.FREIGHT_AMOUNT /*�˷�*/,
                                                ODU1.COUPONS_PRICE /*�Ż�ȯ���*/,
                                                ODU1.PURCHASE_AMOUNT,
                                                ODU1.PROFIT_AMOUNT /*�ۿ۽��*/
                                          FROM FACT_GOODS_SALES ODU1
                                        UNION ALL
                                        /*ȡ���Ķ���������������UPDATE_TIME�����򶩵��������¼����
                                        2017-06-14 yangjin*/
                                        SELECT ODU2.ORDER_KEY /*����Ȩ����*/,
                                                ODU2.ORDER_H_KEY /*����������*/,
                                                ODU2.ORDER_DESC /*����״̬*/,
                                                ODU2.GOODS_KEY /*��Ʒ*/,
                                                ODU2.GOODS_COMMON_KEY /*��Ʒ�̱���*/,
                                                ODU2.SALES_SOURCE_SECOND_KEY /*���۶�����֯key*/,
                                                ODU2.TRAN_TYPE /*�Ƿ���Ʒ��־*/,
                                                ODU2.TRAN_DESC /*��������*/,
                                                ODU2.MD_PERSON /*MD����*/,
                                                ODU2.UPDATE_TIME POSTING_DATE_KEY /*��������key*/,
                                                ODU2.LIVE_STATE /*�Ƿ�ֱ��*/,
                                                ODU2.REPLAY_STATE /*�Ƿ��ز�*/,
                                                ODU2.ORDER_STATE /*����״̬*/,
                                                ODU2.CANCEL_STATE /*ȡ��״̬*/,
                                                ODU2.MEMBER_KEY /*��Աkey*/,
                                                ODU2.NUMS,
                                                ODU2.ORDER_AMOUNT,
                                                ODU2.SALES_AMOUNT,
                                                ODU2.UNIT_PRICE /*������Ʒ�ۼ�*/,
                                                ODU2.COST_PRICE /*��Ʒ�����ɱ�*/,
                                                ODU2.FREIGHT_AMOUNT /*�˷�*/,
                                                ODU2.COUPONS_PRICE /*�Ż�ȯ���*/,
                                                ODU2.PURCHASE_AMOUNT,
                                                ODU2.PROFIT_AMOUNT /*�ۿ۽��*/
                                          FROM FACT_GOODS_SALES ODU2
                                         WHERE ODU2.CANCEL_STATE = 1
                                           AND ODU2.CANCEL_BEFORE_STATE = 1 /*����ǰȡ���Ķ������������¼*/
                                           AND ODU2.POSTING_DATE_KEY <=
                                               ODU2.UPDATE_TIME
                                        
                                        ) OD
                                 WHERE OD.POSTING_DATE_KEY =
                                       IN_POSTING_DATE_KEY
                                   AND OD.TRAN_TYPE = 0 /*ֻ��ʾ��Ʒ*/
                                ) OD1
                         GROUP BY OD1.GOODS_KEY,
                                  OD1.GOODS_COMMON_KEY,
                                  OD1.SALES_SOURCE_SECOND_KEY,
                                  DECODE(OD1.TRAN_TYPE, 0, '��Ʒ', 1, '��Ʒ'),
                                  DECODE(OD1.CANCEL_STATE, 0, 'TAN', 1, 'REN'),
                                  OD1.MD_PERSON,
                                  OD1.POSTING_DATE_KEY,
                                  DECODE(OD1.LIVE_OR_REPLAY,
                                         '10',
                                         'ֱ��',
                                         '01',
                                         '�ز�',
                                         'δ����'),
                                  OD1.CANCEL_STATE) OD2
                UNION ALL
                --*************************************************************************************
                --REVERSE
                --*************************************************************************************
                SELECT RD2.GOODS_KEY,
                       RD2.GOODS_COMMON_KEY,
                       RD2.SALES_SOURCE_SECOND_KEY /*���۶�����֯key*/,
                       '��Ʒ' ITEM_OR_GIFT /*����Ʒ*/,
                       RD2.TRAN_TYPE /*��������*/,
                       DECODE(RD2.TRAN_TYPE,
                              'TAN',
                              '��Ʒ',
                              'REN',
                              '��Ʒ�˻�') TRAN_TYPE_NAME /*��������˵��*/,
                       RD2.MD_PERSON /*MDԱ����*/,
                       RD2.POSTING_DATE_KEY /*��������*/,
                       RD2.LIVE_OR_REPLAY /*ֱ�ز�*/,
                       RD2.TOTAL_ORDER_AMOUNT /*�ܶ������*/,
                       RD2.NET_ORDER_AMOUNT /*���������*/,
                       -RD2.REVERSE_ORDER_AMOUNT - RD2.REJECT_ORDER_AMOUNT +
                       RD2.CANCEL_REVERSE_AMOUNT + RD2.CANCEL_REJECT_AMOUNT EFFECTIVE_ORDER_AMOUNT /*��Ч�������= -�˻��������-���ն������+�˻�ȡ���������+����ȡ���������*/,
                       RD2.CANCEL_ORDER_AMOUNT /*ȡ���������*/,
                       RD2.REVERSE_ORDER_AMOUNT /*�˻��������*/,
                       RD2.REJECT_ORDER_AMOUNT /*���ն������*/,
                       RD2.CANCEL_REVERSE_AMOUNT /*�˻�ȡ���������*/,
                       RD2.CANCEL_REJECT_AMOUNT /*����ȡ���������*/,
                       RD2.TOTAL_SALES_AMOUNT /*���ۼ۽��*/,
                       RD2.NET_SALES_AMOUNT /*���ۼ۽��*/,
                       -RD2.REVERSE_SALES_AMOUNT - RD2.REJECT_SALES_AMOUNT +
                       RD2.CANCEL_REVERSE_SALES_AMOUNT +
                       RD2.CANCEL_REJECT_SALES_AMOUNT EFFECTIVE_SALES_AMOUNT /*��Ч�ۼ۽��= -�˻��ۼ۽��-�����ۼ۽��+�˻�ȡ���ۼ۽��+����ȡ���ۼ۽��*/,
                       RD2.TOTAL_ORDER_MEMBER_COUNT /*�ܶ�������*/,
                       RD2.NET_ORDER_MEMBER_COUNT /*����������*/,
                       -RD2.REVERSE_MEMBER_COUNT - RD2.REJECT_MEMBER_COUNT +
                       RD2.CANCEL_REVERSE_MEMBER_COUNT +
                       RD2.CANCEL_REJECT_MEMBER_COUNT EFFECTIVE_ORDER_MEMBER_COUNT /*��Ч��������=-�˻���������-���ն�������+�˻�ȡ����������+����ȡ����������*/,
                       RD2.CANCEL_ORDER_MEMBER_COUNT /*ȡ����������*/,
                       RD2.REVERSE_MEMBER_COUNT /*�˻���������*/,
                       RD2.REJECT_MEMBER_COUNT /*���ն�������*/,
                       RD2.CANCEL_REVERSE_MEMBER_COUNT /*�˻�ȡ����������*/,
                       RD2.CANCEL_REJECT_MEMBER_COUNT /*����ȡ����������*/,
                       RD2.TOTAL_ORDER_COUNT /*�ܶ�������*/,
                       RD2.NET_ORDER_COUNT /*����������*/,
                       -RD2.REVERSE_COUNT - RD2.REJECT_COUNT +
                       RD2.CANCEL_REVERSE_COUNT + RD2.CANCEL_REJECT_COUNT EFFECTIVE_ORDER_COUNT /*��Ч��������*/,
                       RD2.CANCEL_ORDER_COUNT /*ȡ����������*/,
                       RD2.REVERSE_COUNT /*�˻���������*/,
                       RD2.REJECT_COUNT /*���ն�������*/,
                       RD2.CANCEL_REVERSE_COUNT /*�˻�ȡ����������*/,
                       RD2.CANCEL_REJECT_COUNT /*����ȡ����������*/,
                       RD2.GROSS_PROFIT_AMOUNT /*��ԭ����ë����*/,
                       RD2.NET_PROFIT_AMOUNT /*��ԭ��ë����*/,
                       (-RD2.REVERSE_SALES_AMOUNT - RD2.REJECT_SALES_AMOUNT +
                       RD2.CANCEL_REVERSE_SALES_AMOUNT +
                       RD2.CANCEL_REJECT_SALES_AMOUNT) -
                       (-RD2.REVERSE_PURCHASE_AMOUNT -
                       RD2.REJECT_PURCHASE_AMOUNT +
                       RD2.CANCEL_REVERSE_PURCHASE_AMOUNT +
                       RD2.CANCEL_REJECT_PURCHASE_AMOUNT) EFFECTIVE_PROFIT_AMOUNT /*��ԭ����Чë����*/,
                       RD2.GROSS_PROFIT_RATE /*��ԭ����ë����*/,
                       RD2.NET_PROFIT_RATE /*��ԭ��ë����*/,
                       DECODE(-RD2.REVERSE_ORDER_AMOUNT -
                              RD2.REJECT_ORDER_AMOUNT +
                              RD2.CANCEL_REVERSE_AMOUNT +
                              RD2.CANCEL_REJECT_AMOUNT,
                              0,
                              0,
                              ((-RD2.REVERSE_SALES_AMOUNT -
                              RD2.REJECT_SALES_AMOUNT +
                              RD2.CANCEL_REVERSE_SALES_AMOUNT +
                              RD2.CANCEL_REJECT_SALES_AMOUNT) -
                              (-RD2.REVERSE_PURCHASE_AMOUNT -
                              RD2.REJECT_PURCHASE_AMOUNT +
                              RD2.CANCEL_REVERSE_PURCHASE_AMOUNT +
                              RD2.CANCEL_REJECT_PURCHASE_AMOUNT)) /
                              (-RD2.REVERSE_ORDER_AMOUNT -
                              RD2.REJECT_ORDER_AMOUNT +
                              RD2.CANCEL_REVERSE_AMOUNT +
                              RD2.CANCEL_REJECT_AMOUNT)) EFFECTIVE_PROFIT_RATE /*��ԭ����Чë����*/,
                       RD2.TOTAL_ORDER_QTY /*�ܶ�������*/,
                       RD2.NET_ORDER_QTY /*����������*/,
                       -RD2.REVERSE_QTY - RD2.REJECT_QTY +
                       RD2.CANCEL_REVERSE_QTY + RD2.CANCEL_REJECT_QTY EFFECTIVE_ORDER_QTY /*��Ч��������= -�˻���������-���ն�������+�˻�ȡ����������+����ȡ����������*/,
                       RD2.CANCEL_ORDER_QTY /*ȡ����������*/,
                       RD2.REVERSE_QTY /*�˻���������*/,
                       RD2.REJECT_QTY /*���ն�������*/,
                       RD2.CANCEL_REVERSE_QTY /*�˻�ȡ����������*/,
                       RD2.CANCEL_REJECT_QTY /*����ȡ����������*/,
                       RD2.NET_ORDER_CUST_PRICE /*�������͵���*/,
                       DECODE(-RD2.REVERSE_MEMBER_COUNT -
                              RD2.REJECT_MEMBER_COUNT +
                              RD2.CANCEL_REVERSE_MEMBER_COUNT +
                              RD2.CANCEL_REJECT_MEMBER_COUNT,
                              0,
                              0,
                              (-RD2.REVERSE_ORDER_AMOUNT -
                              RD2.REJECT_ORDER_AMOUNT +
                              RD2.CANCEL_REVERSE_AMOUNT +
                              RD2.CANCEL_REJECT_AMOUNT) /
                              (-RD2.REVERSE_MEMBER_COUNT -
                              RD2.REJECT_MEMBER_COUNT +
                              RD2.CANCEL_REVERSE_MEMBER_COUNT +
                              RD2.CANCEL_REJECT_MEMBER_COUNT)) EFFECTIVE_ORDER_CUST_PRICE /*��Ч�����͵���*/,
                       RD2.NET_ORDER_UNIT_PRICE /*������������*/,
                       DECODE(-RD2.REVERSE_QTY - RD2.REJECT_QTY +
                              RD2.CANCEL_REVERSE_QTY + RD2.CANCEL_REJECT_QTY,
                              0,
                              0,
                              (-RD2.REVERSE_ORDER_AMOUNT -
                              RD2.REJECT_ORDER_AMOUNT +
                              RD2.CANCEL_REVERSE_AMOUNT +
                              RD2.CANCEL_REJECT_AMOUNT) /
                              (-RD2.REVERSE_QTY - RD2.REJECT_QTY +
                              RD2.CANCEL_REVERSE_QTY + RD2.CANCEL_REJECT_QTY)) EFFECTIVE_ORDER_UNIT_PRICE /*��Ч����������*/,
                       0 TOTAL_PURCHASE_AMOUNT /*�ܶ����ɱ�*/,
                       0 NET_PURCHASE_AMOUNT /*�������ɱ�*/,
                       -RD2.REVERSE_PURCHASE_AMOUNT -
                       RD2.REJECT_PURCHASE_AMOUNT +
                       RD2.CANCEL_REVERSE_PURCHASE_AMOUNT +
                       RD2.CANCEL_REJECT_PURCHASE_AMOUNT EFFECTIVE_PURCHASE_AMOUNT /*��Ч�����ɱ�=-�˻������ɱ�-���ն����ɱ�+�˻�ȡ�������ɱ�+����ȡ�������ɱ�*/,
                       RD2.PROFIT_AMOUNT PROFIT_AMOUNT /*�ۿ۽��*/,
                       RD2.COUPONS_AMOUNT COUPONS_AMOUNT /*�Ż�ȯ���*/,
                       RD2.FREIGHT_AMOUNT FREIGHT_AMOUNT /*�˷�*/,
                       0 PRODUCT_AVG_PRICE /*��Ʒƽ���ۼ�*/,
                       - (-RD2.REVERSE_ORDER_AMOUNT - RD2.REJECT_ORDER_AMOUNT +
                         RD2.CANCEL_REVERSE_AMOUNT +
                         RD2.CANCEL_REJECT_AMOUNT) REJECT_AMOUNT /*���˽��*/
                  FROM (SELECT RD1.GOODS_KEY,
                               RD1.GOODS_COMMON_KEY,
                               RD1.SALES_SOURCE_SECOND_KEY /*���۶�����֯key*/,
                               RD1.TRAN_DESC TRAN_TYPE /*��������*/,
                               RD1.MD_PERSON /*MDԱ����*/,
                               RD1.POSTING_DATE_KEY /*��������*/,
                               DECODE(RD1.LIVE_OR_REPLAY,
                                      '10',
                                      'ֱ��',
                                      '01',
                                      '�ز�',
                                      'δ����') LIVE_OR_REPLAY,
                               0 TOTAL_ORDER_AMOUNT /*�ܶ������*/,
                               0 NET_ORDER_AMOUNT /*���������*/,
                               0 CANCEL_ORDER_AMOUNT /*ȡ���������*/,
                               SUM(DECODE(RD1.CANCEL_STATE,
                                          0,
                                          DECODE(RD1.CANCEL_REASON,
                                                 10,
                                                 RD1.ORDER_AMOUNT,
                                                 30,
                                                 RD1.ORDER_AMOUNT,
                                                 20,
                                                 0),
                                          0)) REVERSE_ORDER_AMOUNT /*�˻��������*/,
                               SUM(DECODE(RD1.CANCEL_STATE,
                                          0,
                                          DECODE(RD1.CANCEL_REASON,
                                                 20,
                                                 RD1.ORDER_AMOUNT,
                                                 0),
                                          0)) REJECT_ORDER_AMOUNT /*���ն������*/,
                               SUM(DECODE(RD1.CANCEL_STATE,
                                          1,
                                          DECODE(RD1.CANCEL_REASON,
                                                 10,
                                                 RD1.ORDER_AMOUNT,
                                                 30,
                                                 RD1.ORDER_AMOUNT,
                                                 20,
                                                 0),
                                          0)) CANCEL_REVERSE_AMOUNT /*�˻�ȡ���������*/,
                               SUM(DECODE(RD1.CANCEL_STATE,
                                          1,
                                          DECODE(RD1.CANCEL_REASON,
                                                 20,
                                                 RD1.ORDER_AMOUNT,
                                                 0),
                                          0)) CANCEL_REJECT_AMOUNT /*����ȡ���������*/,
                               0 TOTAL_SALES_AMOUNT /*���ۼ۽��*/,
                               0 NET_SALES_AMOUNT /*���ۼ۽��*/,
                               SUM(DECODE(RD1.CANCEL_STATE,
                                          0,
                                          DECODE(RD1.CANCEL_REASON,
                                                 10,
                                                 RD1.SALES_AMOUNT,
                                                 30,
                                                 RD1.SALES_AMOUNT,
                                                 20,
                                                 0),
                                          0)) REVERSE_SALES_AMOUNT /*�˻��ۼ۽��*/,
                               SUM(DECODE(RD1.CANCEL_STATE,
                                          0,
                                          DECODE(RD1.CANCEL_REASON,
                                                 20,
                                                 RD1.SALES_AMOUNT,
                                                 0),
                                          0)) REJECT_SALES_AMOUNT /*�����ۼ۽��*/,
                               SUM(DECODE(RD1.CANCEL_STATE,
                                          1,
                                          DECODE(RD1.CANCEL_REASON,
                                                 10,
                                                 RD1.SALES_AMOUNT,
                                                 30,
                                                 RD1.SALES_AMOUNT,
                                                 20,
                                                 0),
                                          0)) CANCEL_REVERSE_SALES_AMOUNT /*�˻�ȡ���ۼ۽��*/,
                               SUM(DECODE(RD1.CANCEL_STATE,
                                          1,
                                          DECODE(RD1.CANCEL_REASON,
                                                 20,
                                                 RD1.SALES_AMOUNT,
                                                 0),
                                          0)) CANCEL_REJECT_SALES_AMOUNT /*����ȡ���ۼ۽��*/,
                               0 TOTAL_ORDER_MEMBER_COUNT /*�ܶ�������*/,
                               0 NET_ORDER_MEMBER_COUNT /*����������*/,
                               0 CANCEL_ORDER_MEMBER_COUNT /*ȡ����������*/,
                               COUNT(DISTINCT DECODE(RD1.CANCEL_STATE,
                                            0,
                                            DECODE(RD1.CANCEL_REASON,
                                                   10,
                                                   RD1.MEMBER_KEY,
                                                   30,
                                                   RD1.MEMBER_KEY,
                                                   NULL),
                                            0)) REVERSE_MEMBER_COUNT /*�˻���������*/,
                               COUNT(DISTINCT DECODE(RD1.CANCEL_STATE,
                                            0,
                                            DECODE(RD1.CANCEL_REASON,
                                                   20,
                                                   RD1.MEMBER_KEY,
                                                   NULL),
                                            0)) REJECT_MEMBER_COUNT /*���ն�������*/,
                               COUNT(DISTINCT DECODE(RD1.CANCEL_STATE,
                                            1,
                                            DECODE(RD1.CANCEL_REASON,
                                                   10,
                                                   RD1.MEMBER_KEY,
                                                   30,
                                                   RD1.MEMBER_KEY,
                                                   NULL),
                                            0)) CANCEL_REVERSE_MEMBER_COUNT /*�˻�ȡ����������*/,
                               COUNT(DISTINCT DECODE(RD1.CANCEL_STATE,
                                            1,
                                            DECODE(RD1.CANCEL_REASON,
                                                   20,
                                                   RD1.MEMBER_KEY,
                                                   NULL),
                                            0)) CANCEL_REJECT_MEMBER_COUNT /*����ȡ����������*/,
                               0 TOTAL_ORDER_COUNT /*�ܶ�������*/,
                               0 NET_ORDER_COUNT /*����������*/,
                               0 CANCEL_ORDER_COUNT /*ȡ����������*/,
                               COUNT(DISTINCT DECODE(RD1.CANCEL_STATE,
                                            0,
                                            DECODE(RD1.CANCEL_REASON,
                                                   10,
                                                   RD1.ORDER_H_KEY,
                                                   30,
                                                   RD1.ORDER_H_KEY,
                                                   NULL),
                                            0)) REVERSE_COUNT /*�˻���������*/,
                               COUNT(DISTINCT DECODE(RD1.CANCEL_STATE,
                                            0,
                                            DECODE(RD1.CANCEL_REASON,
                                                   20,
                                                   RD1.ORDER_H_KEY,
                                                   NULL),
                                            0)) REJECT_COUNT /*���ն�������*/,
                               COUNT(DISTINCT DECODE(RD1.CANCEL_STATE,
                                            1,
                                            DECODE(RD1.CANCEL_REASON,
                                                   10,
                                                   RD1.ORDER_H_KEY,
                                                   30,
                                                   RD1.ORDER_H_KEY,
                                                   NULL),
                                            0)) CANCEL_REVERSE_COUNT /*�˻�ȡ����������*/,
                               COUNT(DISTINCT DECODE(RD1.CANCEL_STATE,
                                            1,
                                            DECODE(RD1.CANCEL_REASON,
                                                   20,
                                                   RD1.ORDER_H_KEY,
                                                   NULL),
                                            0)) CANCEL_REJECT_COUNT /*����ȡ����������*/,
                               0 GROSS_PROFIT_AMOUNT /*��ԭ����ë����*/,
                               0 NET_PROFIT_AMOUNT /*��ԭ��ë����*/,
                               0 GROSS_PROFIT_RATE /*��ԭ����ë����*/,
                               0 NET_PROFIT_RATE /*��ԭ��ë����*/,
                               0 TOTAL_ORDER_QTY /*�ܶ�������*/,
                               0 NET_ORDER_QTY /*����������*/,
                               0 CANCEL_ORDER_QTY /*ȡ����������*/,
                               SUM(DECODE(RD1.CANCEL_STATE,
                                          0,
                                          DECODE(RD1.CANCEL_REASON,
                                                 10,
                                                 RD1.NUMS,
                                                 30,
                                                 RD1.NUMS,
                                                 20,
                                                 0),
                                          0)) REVERSE_QTY /*�˻���������*/,
                               SUM(DECODE(RD1.CANCEL_STATE,
                                          0,
                                          DECODE(RD1.CANCEL_REASON,
                                                 20,
                                                 RD1.NUMS,
                                                 0),
                                          0)) REJECT_QTY /*���ն�������*/,
                               SUM(DECODE(RD1.CANCEL_STATE,
                                          1,
                                          DECODE(RD1.CANCEL_REASON,
                                                 10,
                                                 RD1.NUMS,
                                                 30,
                                                 RD1.NUMS,
                                                 20,
                                                 0),
                                          0)) CANCEL_REVERSE_QTY /*�˻�ȡ����������*/,
                               SUM(DECODE(RD1.CANCEL_STATE,
                                          1,
                                          DECODE(RD1.CANCEL_REASON,
                                                 20,
                                                 RD1.NUMS,
                                                 0),
                                          0)) CANCEL_REJECT_QTY /*����ȡ����������*/,
                               0 NET_ORDER_CUST_PRICE /*�������͵���*/,
                               0 NET_ORDER_UNIT_PRICE /*������������*/,
                               SUM(DECODE(RD1.CANCEL_STATE,
                                          0,
                                          DECODE(RD1.CANCEL_REASON,
                                                 10,
                                                 RD1.PURCHASE_AMOUNT,
                                                 30,
                                                 RD1.PURCHASE_AMOUNT,
                                                 20,
                                                 0),
                                          0)) REVERSE_PURCHASE_AMOUNT /*�˻������ɱ�*/,
                               SUM(DECODE(RD1.CANCEL_STATE,
                                          0,
                                          DECODE(RD1.CANCEL_REASON,
                                                 20,
                                                 RD1.PURCHASE_AMOUNT,
                                                 0),
                                          0)) REJECT_PURCHASE_AMOUNT /*���ն����ɱ�*/,
                               SUM(DECODE(RD1.CANCEL_STATE,
                                          1,
                                          DECODE(RD1.CANCEL_REASON,
                                                 10,
                                                 RD1.PURCHASE_AMOUNT,
                                                 30,
                                                 RD1.PURCHASE_AMOUNT,
                                                 20,
                                                 0),
                                          0)) CANCEL_REVERSE_PURCHASE_AMOUNT /*�˻�ȡ�������ɱ�*/,
                               SUM(DECODE(RD1.CANCEL_STATE,
                                          1,
                                          DECODE(RD1.CANCEL_REASON,
                                                 20,
                                                 RD1.PURCHASE_AMOUNT,
                                                 0),
                                          0)) CANCEL_REJECT_PURCHASE_AMOUNT /*����ȡ�������ɱ�*/,
                               SUM(RD1.PROFIT_AMOUNT) PROFIT_AMOUNT /*�ۿ۽��*/,
                               SUM(RD1.COUPONS_AMOUNT) COUPONS_AMOUNT /*�Ż�ȯ���*/,
                               SUM(RD1.FREIGHT_AMOUNT) FREIGHT_AMOUNT /*�˷�*/
                          FROM (SELECT RD.ORDER_KEY /*����Ȩ����*/,
                                       RD.ORDER_H_KEY /*����������*/,
                                       RD.CANCEL_REASON /*�˻�����*/,
                                       RD.CANCEL_STATE /*�˻�״̬*/,
                                       RD.GOODS_KEY /*��Ʒ*/,
                                       RD.GOODS_COMMON_KEY /*��Ʒ�̱���*/,
                                       RD.SALES_SOURCE_SECOND_KEY /*���۶�����֯key*/,
                                       RD.TRAN_TYPE /*�Ƿ���Ʒ��־*/,
                                       RD.TRAN_DESC /*��������*/,
                                       RD.MD_PERSON /*MD����*/,
                                       RD.POSTING_DATE_KEY /*��������key*/,
                                       TO_CHAR(RD.LIVE_STATE) ||
                                       TO_CHAR(RD.REPLAY_STATE) LIVE_OR_REPLAY /*ֱ���ز�*/,
                                       RD.MEMBER_KEY /*��Աkey*/,
                                       RD.ORDER_AMOUNT /*�˻��������*/,
                                       RD.NUMS /*�ܶ�������*/,
                                       RD.SALES_AMOUNT /*���ۼ۽��*/,
                                       RD.UNIT_PRICE /*������Ʒ�ۼ�*/,
                                       RD.COST_PRICE /*��Ʒ�����ɱ�*/,
                                       RD.FREIGHT_AMOUNT /*�˷�*/,
                                       RD.COUPONS_AMOUNT /*�Ż�ȯ���*/,
                                       RD.PURCHASE_AMOUNT /*�ܶ����ɱ�*/,
                                       RD.PROFIT_AMOUNT /*�ۿ۽��*/
                                  FROM (
                                        
                                        /*ȡ���Ķ���������������POSTING_DATE_KEY�����򶩵���
                                        2017-06-15 yangjin*/
                                        SELECT RDU1.ORDER_KEY /*����Ȩ����*/,
                                                RDU1.ORDER_H_KEY /*����������*/,
                                                RDU1.CANCEL_REASON /*�˻�����*/,
                                                CASE
                                                  WHEN RDU1.CANCEL_STATE = 1 AND
                                                       RDU1.POSTING_DATE_KEY <=
                                                       RDU1.UPDATE_TIME THEN
                                                   0
                                                  ELSE
                                                   RDU1.CANCEL_STATE
                                                END CANCEL_STATE /*�˻�״̬*/,
                                                RDU1.GOODS_KEY /*��Ʒ*/,
                                                RDU1.GOODS_COMMON_KEY /*��Ʒ�̱���*/,
                                                RDU1.SALES_SOURCE_SECOND_KEY /*���۶�����֯key*/,
                                                RDU1.TRAN_TYPE /*�Ƿ���Ʒ��־*/,
                                                RDU1.TRAN_DESC /*��������*/,
                                                RDU1.MD_PERSON /*MD����*/,
                                                RDU1.POSTING_DATE_KEY /*��������key*/,
                                                RDU1.LIVE_STATE /*�Ƿ�ֱ��*/,
                                                RDU1.REPLAY_STATE /*�Ƿ��ز�*/,
                                                RDU1.MEMBER_KEY /*��Աkey*/,
                                                RDU1.ORDER_AMOUNT /*�˻��������*/,
                                                RDU1.NUMS /*�ܶ�������*/,
                                                RDU1.SALES_AMOUNT /*���ۼ۽��*/,
                                                RDU1.UNIT_PRICE /*������Ʒ�ۼ�*/,
                                                RDU1.COST_PRICE /*��Ʒ�����ɱ�*/,
                                                RDU1.FREIGHT_AMOUNT /*�˷�*/,
                                                RDU1.COUPONS_PRICE COUPONS_AMOUNT /*�Ż�ȯ���*/,
                                                RDU1.PURCHASE_AMOUNT /*�ܶ����ɱ�*/,
                                                RDU1.PROFIT_AMOUNT /*�ۿ۽��*/
                                          FROM FACT_GOODS_SALES_REVERSE RDU1
                                         WHERE RDU1.CANCEL_REASON IN
                                               (10, 20, 30)
                                           AND RDU1.TRAN_DESC = 'REN'
                                        UNION ALL
                                        /*ȡ���Ķ���������������POSTING_DATE_KEY�����򶩵���
                                        2017-06-15 yangjin*/
                                        SELECT RDU2.ORDER_KEY /*����Ȩ����*/,
                                                RDU2.ORDER_H_KEY /*����������*/,
                                                RDU2.CANCEL_REASON /*�˻�����*/,
                                                RDU2.CANCEL_STATE /*�˻�״̬*/,
                                                RDU2.GOODS_KEY /*��Ʒ*/,
                                                RDU2.GOODS_COMMON_KEY /*��Ʒ�̱���*/,
                                                RDU2.SALES_SOURCE_SECOND_KEY /*���۶�����֯key*/,
                                                RDU2.TRAN_TYPE /*�Ƿ���Ʒ��־*/,
                                                RDU2.TRAN_DESC /*��������*/,
                                                RDU2.MD_PERSON /*MD����*/,
                                                RDU2.UPDATE_TIME             POSTING_DATE_KEY /*��������key*/,
                                                RDU2.LIVE_STATE /*�Ƿ�ֱ��*/,
                                                RDU2.REPLAY_STATE /*�Ƿ��ز�*/,
                                                RDU2.MEMBER_KEY /*��Աkey*/,
                                                RDU2.ORDER_AMOUNT /*�˻��������*/,
                                                RDU2.NUMS /*�ܶ�������*/,
                                                RDU2.SALES_AMOUNT /*���ۼ۽��*/,
                                                RDU2.UNIT_PRICE /*������Ʒ�ۼ�*/,
                                                RDU2.COST_PRICE /*��Ʒ�����ɱ�*/,
                                                RDU2.FREIGHT_AMOUNT /*�˷�*/,
                                                RDU2.COUPONS_PRICE           COUPONS_AMOUNT /*�Ż�ȯ���*/,
                                                RDU2.PURCHASE_AMOUNT /*�ܶ����ɱ�*/,
                                                RDU2.PROFIT_AMOUNT /*�ۿ۽��*/
                                          FROM FACT_GOODS_SALES_REVERSE RDU2
                                         WHERE RDU2.CANCEL_REASON IN
                                               (10, 20, 30)
                                           AND RDU2.TRAN_DESC = 'REN'
                                           AND RDU2.CANCEL_STATE = 1
                                           AND RDU2.POSTING_DATE_KEY <=
                                               RDU2.UPDATE_TIME
                                        
                                        ) RD
                                 WHERE RD.POSTING_DATE_KEY =
                                       IN_POSTING_DATE_KEY
                                   AND RD.CANCEL_REASON IN (10, 20, 30)
                                   AND RD.TRAN_DESC = 'REN') RD1
                         GROUP BY RD1.GOODS_KEY,
                                  RD1.GOODS_COMMON_KEY,
                                  RD1.SALES_SOURCE_SECOND_KEY,
                                  RD1.TRAN_DESC,
                                  RD1.MD_PERSON,
                                  RD1.POSTING_DATE_KEY,
                                  DECODE(RD1.LIVE_OR_REPLAY,
                                         '10',
                                         'ֱ��',
                                         '01',
                                         '�ز�',
                                         'δ����')) RD2) FO,
               (SELECT MAX(DG.BRAND_NAME) BRAND_NAME /*Ʒ��*/,
                       MAX(DG.MATDLT) MATDLT /*���ϴ���*/,
                       MAX(DG.MATZLT) MATZLT /*��������*/,
                       MAX(DG.MATXLT) MATXLT /*����С��*/,
                       DG.ITEM_CODE /*��Ʒ*/,
                       MIN(DG.GOODS_NAME) GOODS_NAME /*��Ʒ����*/,
                       MAX(DECODE(DG.GROUP_ID, 2000, '��Ӫ', '����Ӫ')) OWN_ACCOUNT /*�Ƿ���Ӫ*/
                  FROM DIM_GOOD DG
                 GROUP BY DG.ITEM_CODE) DG,
               (SELECT * FROM DIM_SALES_SOURCE) DS
         WHERE FO.GOODS_COMMON_KEY = DG.ITEM_CODE
           AND FO.SALES_SOURCE_SECOND_KEY = DS.SALES_SOURCE_SECOND_KEY;
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    END;
  
    /*��־��¼ģ��*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
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
    
  END OPER_PRODUCT_DAILY_RPT;

  PROCEDURE OPER_PRODUCT_PVUV_DAILY_RPT(IN_VISIT_DATE_KEY IN NUMBER) IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    /*
    ����˵����
    ����ʱ�䣺yangjin  2016-06-29
    */
  BEGIN
    SP_NAME          := 'YANGJIN_PKG.OPER_PRODUCT_PVUV_DAILY_RPT'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME := 'OPER_PRODUCT_PVUV_DAILY_REPORT'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı��
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0' THEN
        S_ETL.ERR_MSG := 'û���ҵ���Ӧ�Ĺ��̼�����������';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
      /*ɾ��ָ�����ڵ�����*/
      DELETE OPER_PRODUCT_PVUV_DAILY_REPORT T
       WHERE T.VISIT_DATE_KEY = IN_VISIT_DATE_KEY;
      COMMIT;
    
      INSERT INTO OPER_PRODUCT_PVUV_DAILY_REPORT
        (VISIT_DATE_KEY,
         PAGE_VALUE,
         ITEM_CODE,
         GOODS_NAME,
         MATDLT,
         GROUP_NAME,
         PV,
         UV,
         AVGNUM,
         GOODPV,
         GOODUV,
         GOODAVG,
         GOODS_COMMONID,
         GOODNUM,
         CUSTNUM,
         GOODMOUNT)
        SELECT V1.VISIT_DATE_KEY,
               V1.PAGE_VALUE,
               V1.ITEM_CODE,
               V1.GOODS_NAME,
               V1.MATDLT,
               V1.GROUP_NAME,
               V1.PV,
               V1.UV,
               V1.AVGNUM,
               V2.GOODPV,
               V2.GOODUV,
               V2.GOODAVG,
               V3.GOODS_COMMONID,
               V3.GOODNUM,
               V3.CUSTNUM,
               V3.GOODMOUNT
          FROM (SELECT X1.PAGE_VALUE,
                       X1.VISIT_DATE_KEY,
                       (SELECT Y1.ITEM_CODE
                          FROM DIM_GOOD Y1
                         WHERE Y1.ITEM_CODE = GET_ITEMCODE(X1.PAGE_VALUE)
                           AND ROWNUM = 1) AS ITEM_CODE,
                       (SELECT Y1.GOODS_NAME
                          FROM DIM_GOOD Y1
                         WHERE Y1.ITEM_CODE = GET_ITEMCODE(X1.PAGE_VALUE)
                           AND ROWNUM = 1) AS GOODS_NAME,
                       (SELECT Y1.MATDLT
                          FROM DIM_GOOD Y1
                         WHERE Y1.ITEM_CODE = GET_ITEMCODE(X1.PAGE_VALUE)
                           AND ROWNUM = 1) AS MATDLT,
                       (SELECT Y1.GROUP_NAME
                          FROM DIM_GOOD Y1
                         WHERE Y1.ITEM_CODE = GET_ITEMCODE(X1.PAGE_VALUE)
                           AND ROWNUM = 1) AS GROUP_NAME,
                       COUNT(X1.VID) AS PV,
                       COUNT(DISTINCT X1.VID) AS UV,
                       TRUNC(AVG(X1.PAGE_STAYTIME), 2) AS AVGNUM
                  FROM FACT_PAGE_VIEW X1
                 WHERE VISIT_DATE_KEY = IN_VISIT_DATE_KEY
                   AND PAGE_KEY IN (40899, 40903)
                 GROUP BY X1.PAGE_VALUE, X1.VISIT_DATE_KEY) V1
          LEFT JOIN (SELECT X2.PAGE_VALUE,
                            COUNT(X2.VID) AS GOODPV,
                            COUNT(DISTINCT X2.VID) AS GOODUV,
                            TRUNC(AVG(X2.PAGE_STAYTIME), 2) AS GOODAVG
                       FROM FACT_PAGE_VIEW X2
                      WHERE X2.VISIT_DATE_KEY = IN_VISIT_DATE_KEY
                        AND X2.PAGE_KEY IN (1924, 2841)
                      GROUP BY X2.PAGE_VALUE) V2
            ON V1.PAGE_VALUE = V2.PAGE_VALUE
          LEFT JOIN (SELECT X3.GOODS_COMMONID,
                            SUM(X3.GOODS_NUM) AS GOODNUM,
                            COUNT(DISTINCT X3.CUST_NO) AS CUSTNUM,
                            SUM(X3.GOODS_PAY_PRICE * X3.GOODS_NUM) AS GOODMOUNT
                       FROM ORDER_GOOD X3
                      WHERE X3.ADD_TIME = IN_VISIT_DATE_KEY
                        AND X3.ISCG = 1
                      GROUP BY X3.GOODS_COMMONID) V3
            ON V2.PAGE_VALUE = V3.GOODS_COMMONID;
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    END;
  
    /*��־��¼ģ��*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
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
    
  END OPER_PRODUCT_PVUV_DAILY_RPT;

END YANGJIN_PKG;
/
