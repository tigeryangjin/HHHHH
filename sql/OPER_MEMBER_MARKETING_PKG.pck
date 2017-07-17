CREATE OR REPLACE PACKAGE OPER_MEMBER_MARKETING_PKG AS

  PROCEDURE PROC_MBR_REG_WITHOUT_ORDER(POSTDAY IN NUMBER);
  /*
  ������:       PROC_MBR_REG_WITHOUT_ORDER
  Ŀ��:         �»�Աת��-���δ̼�-15,30��δ����
  ����:         yangjin
  ����ʱ�䣺    2017/05/04
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE PROC_MBR_FIRST_ORDER_25DAYS(POSTDAY IN NUMBER);
  /*
  ������:       PROC_MBR_FIRST_ORDER_25DAYS
  Ŀ��:         ��Ա����-��Ч����1��-25����δ�ظ�����
  ����:         yangjin
  ����ʱ�䣺    2017/05/04
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE PROC_MBR_SECOND_ORDER_30DAYS(POSTDAY IN NUMBER);
  /*
  ������:       PROC_MBR_SECOND_ORDER_30DAYS
  Ŀ��:         ��Ա����-��Ч����2��-30����δ�ظ�����
  ����:         yangjin
  ����ʱ�䣺    2017/05/05
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE PROC_MBR_THIRD_ORDER_35DAYS(POSTDAY IN NUMBER);
  /*
  ������:       PROC_MBR_THIRD_ORDER_35DAYS
  Ŀ��:         ��Ա����-��Ч����3��-35����δ�ظ�����
  ����:         yangjin
  ����ʱ�䣺    2017/05/05
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE PROC_MBR_THIRD_ORDER_MONTH(IN_MONTH_KEY IN NUMBER);
  /*
  ������:       PROC_MBR_THIRD_ORDER_CAL_MONTH
  Ŀ��:         ��Ա����-��Ч����3��-��Ȼ�£�199��299��399��
  ����:         yangjin
  ����ʱ�䣺    2017/05/08
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE PROC_MBR_TWELVE_ORDER_YEAR(IN_YEAR_KEY IN NUMBER);
  /*
  ������:       PROC_MBR_TWELVE_ORDER_YEAR
  Ŀ��:         ��Ա����-��Ч����12��-��Ȼ�꣨199��299��399��
  ����:         yangjin
  ����ʱ�䣺    2017/05/09
  ����޸��ˣ�
  ���������ڣ�
  */

END OPER_MEMBER_MARKETING_PKG;
/
CREATE OR REPLACE PACKAGE BODY OPER_MEMBER_MARKETING_PKG AS
  PROCEDURE PROC_MBR_REG_WITHOUT_ORDER(POSTDAY IN NUMBER) IS
    /*�»�Աת��-���δ̼�-15,30��δ����*/
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
  
  BEGIN
    SP_NAME          := 'PROC_MBR_REG_WITHOUT_ORDER'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME := 'OPER_MBR_REG_WITHOUT_ORDER'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı��
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
  
    DELETE FROM OPER_MBR_REG_WITHOUT_ORDER T
     WHERE T.RECORD_DATE_KEY = POSTDAY;
  
    /*15��δ������Ա*/
    INSERT INTO OPER_MBR_REG_WITHOUT_ORDER
      (MEMBER_KEY,
       REGISTER_DATE_KEY,
       THIRTY_WITHOUT_ORDER_FLAG,
       RECORD_DATE_KEY,
       REGISTER_DEVICE_KEY,
       INSERT_DT,
       UPDATE_DT)
      (SELECT M.MEMBER_CRMBP AS MEMBER_KEY,
              TO_NUMBER(TO_CHAR(TO_DATE(POSTDAY, 'yyyy-mm-dd') - 15,
                                'yyyymmdd')) AS REGISTER_DATE_KEY,
              0, /*15��δ��������־Ϊ0*/
              POSTDAY AS RECORD_DATE_KEY,
              S.DEVICE_KEY AS REGISTER_DEVICE_KEY,
              SYSDATE,
              SYSDATE
         FROM FACT_ECMEMBER@DW_DATALINK M
         LEFT JOIN FACT_MEMBER_REGISTER@DW_DATALINK S
           ON S.MEMBER_KEY = M.MEMBER_CRMBP
        WHERE M.MEMBER_TIME =
              TO_NUMBER(TO_CHAR(TO_DATE(POSTDAY, 'yyyy-mm-dd') - 15,
                                'yyyymmdd'))
          AND NOT EXISTS
        (SELECT 1
                 FROM (SELECT DISTINCT (MEMBER_KEY) MEMBER_KEY
                         FROM FACT_ORDER@DW_DATALINK A
                        WHERE ORDER_STATE = 1
                          AND SALES_SOURCE_SECOND_KEY IN
                              (20022, 20021, 20020, 20018, 20017)
                          AND POSTING_DATE_KEY BETWEEN
                              TO_NUMBER(TO_CHAR(TO_DATE(POSTDAY, 'yyyy-mm-dd') - 15,
                                                'yyyymmdd')) AND POSTDAY) B
                WHERE M.MEMBER_CRMBP = B.MEMBER_KEY));
    INSERT_ROWS := SQL%ROWCOUNT;
  
    /*30��δ������Ա*/
    INSERT INTO OPER_MBR_REG_WITHOUT_ORDER
      (MEMBER_KEY,
       REGISTER_DATE_KEY,
       THIRTY_WITHOUT_ORDER_FLAG,
       RECORD_DATE_KEY,
       REGISTER_DEVICE_KEY,
       INSERT_DT,
       UPDATE_DT)
      (SELECT M.MEMBER_CRMBP AS MEMBER_KEY,
              TO_NUMBER(TO_CHAR(TO_DATE(POSTDAY, 'yyyy-mm-dd') - 30,
                                'yyyymmdd')) AS REGISTER_DATE_KEY,
              1, /*30��δ��������־Ϊ1*/
              POSTDAY AS RECORD_DATE_KEY,
              S.DEVICE_KEY AS REGISTER_DEVICE_KEY,
              SYSDATE,
              SYSDATE
         FROM FACT_ECMEMBER@DW_DATALINK M
         LEFT JOIN FACT_MEMBER_REGISTER@DW_DATALINK S
           ON S.MEMBER_KEY = M.MEMBER_CRMBP
        WHERE M.MEMBER_TIME =
              TO_NUMBER(TO_CHAR(TO_DATE(POSTDAY, 'yyyy-mm-dd') - 30,
                                'yyyymmdd'))
          AND NOT EXISTS
        (SELECT 1
                 FROM (SELECT DISTINCT (MEMBER_KEY) MEMBER_KEY
                         FROM FACT_ORDER@DW_DATALINK A
                        WHERE ORDER_STATE = 1
                          AND SALES_SOURCE_SECOND_KEY IN
                              (20022, 20021, 20020, 20018, 20017)
                          AND POSTING_DATE_KEY BETWEEN
                              TO_NUMBER(TO_CHAR(TO_DATE(POSTDAY, 'yyyy-mm-dd') - 30,
                                                'yyyymmdd')) AND POSTDAY) B
                WHERE M.MEMBER_CRMBP = B.MEMBER_KEY));
    INSERT_ROWS := INSERT_ROWS + SQL%ROWCOUNT;
  
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
  END;

  PROCEDURE PROC_MBR_FIRST_ORDER_25DAYS(POSTDAY IN NUMBER) IS
    /*��Ա����-��Ч����1��-25����δ�ظ�����*/
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
  
  BEGIN
    SP_NAME          := 'PROC_MBR_FIRST_ORDER_25DAYS'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME := 'OPER_MBR_FIRST_ORDER_25DAYS'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı��
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
  
    DELETE FROM OPER_MBR_FITST_ORDER_25DAYS T
     WHERE T.RECORD_DATE_KEY = POSTDAY;
  
    /*��Ч����1�Σ�25�������ظ�����*/
    INSERT INTO OPER_MBR_FITST_ORDER_25DAYS
      (MEMBER_KEY,
       RECORD_DATE_KEY,
       ORDER_TIME,
       ACTUAL_ORDER_AMOUNT,
       AMOUNT_LEVEL,
       INSERT_DT,
       UPDATE_DT)
      (SELECT B.MEMBER_KEY,
              POSTDAY RECORD_DATE_KEY,
              B.POSTING_DATE_KEY ORDER_TIME,
              B.AMOUNT_PAID ACTUAL_ORDER_AMOUNT,
              CASE
                WHEN B.AMOUNT_PAID < 100 THEN
                 1
                WHEN B.AMOUNT_PAID >= 100 AND B.AMOUNT_PAID < 300 THEN
                 2
                WHEN B.AMOUNT_PAID >= 300 THEN
                 3
              END AMOUNT_LEVEL,
              SYSDATE,
              SYSDATE
         FROM (SELECT A.MEMBER_KEY,
                      MAX(A.POSTING_DATE_KEY) POSTING_DATE_KEY,
                      SUM(A.AMOUNT_PAID) AMOUNT_PAID
                 FROM FACT_ORDER@DW_DATALINK A
                WHERE A.ORDER_STATE = 1
                  AND A.SALES_SOURCE_SECOND_KEY IN
                      (20022, 20021, 20020, 20018, 20017)
                GROUP BY A.MEMBER_KEY
               /*��Ч����1��*/
               HAVING COUNT(A.ORDER_KEY) = 1) B
        WHERE B.POSTING_DATE_KEY =
              TO_NUMBER(TO_CHAR(TO_DATE(POSTDAY, 'YYYYMMDD') - 25,
                                'YYYYMMDD')));
    INSERT_ROWS := SQL%ROWCOUNT;
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
  END;

  PROCEDURE PROC_MBR_SECOND_ORDER_30DAYS(POSTDAY IN NUMBER) IS
    /*��Ա����-��Ч����2��-30����δ�ظ�����*/
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
  
  BEGIN
    SP_NAME          := 'PROC_MBR_SECOND_ORDER_30DAYS'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME := 'OPER_MBR_SECOND_ORDER_30DAYS'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı��
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
  
    /*��Ч����2�Σ�30�������ظ�����*/
    INSERT INTO OPER_MBR_SECOND_ORDER_30DAYS
      (MEMBER_KEY,
       RECORD_DATE_KEY,
       ORDER_TIME,
       ACTUAL_ORDER_AMOUNT,
       AMOUNT_LEVEL,
       INSERT_DT,
       UPDATE_DT)
      (SELECT B.MEMBER_KEY,
              POSTDAY RECORD_DATE_KEY,
              B.POSTING_DATE_KEY ORDER_TIME,
              B.AMOUNT_PAID ACTUAL_ORDER_AMOUNT,
              CASE
                WHEN B.AMOUNT_PAID >= 100 AND B.AMOUNT_PAID < 189 THEN
                 1
                WHEN B.AMOUNT_PAID >= 189 AND B.AMOUNT_PAID < 500 THEN
                 2
                WHEN B.AMOUNT_PAID >= 500 THEN
                 3
                ELSE
                 -1
              END AMOUNT_LEVEL,
              SYSDATE,
              SYSDATE
         FROM (SELECT A.MEMBER_KEY,
                      MAX(A.POSTING_DATE_KEY) POSTING_DATE_KEY,
                      SUM(A.AMOUNT_PAID) AMOUNT_PAID
                 FROM FACT_ORDER@DW_DATALINK A
                WHERE A.ORDER_STATE = 1
                  AND A.SALES_SOURCE_SECOND_KEY IN
                      (20022, 20021, 20020, 20018, 20017)
                GROUP BY A.MEMBER_KEY
               /*��Ч����2��*/
               HAVING COUNT(A.ORDER_KEY) = 2) B
        WHERE B.POSTING_DATE_KEY =
              TO_NUMBER(TO_CHAR(TO_DATE(POSTDAY, 'YYYYMMDD') - 30,
                                'YYYYMMDD')));
    INSERT_ROWS := SQL%ROWCOUNT;
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
  END;

  PROCEDURE PROC_MBR_THIRD_ORDER_35DAYS(POSTDAY IN NUMBER) IS
    /*��Ա����-��Ч����3��-35����δ�ظ�����*/
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
  
  BEGIN
    SP_NAME          := 'PROC_MBR_THIRD_ORDER_35DAYS'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME := 'OPER_MBR_THIRD_ORDER_35DAYS'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı��
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
  
    /*��Ч����3�Σ�35�������ظ�����*/
    INSERT INTO OPER_MBR_THIRD_ORDER_35DAYS
      (MEMBER_KEY,
       RECORD_DATE_KEY,
       ORDER_TIME,
       ACTUAL_ORDER_AMOUNT,
       AMOUNT_LEVEL,
       INSERT_DT,
       UPDATE_DT)
      (SELECT B.MEMBER_KEY,
              POSTDAY RECORD_DATE_KEY,
              B.POSTING_DATE_KEY ORDER_TIME,
              B.AMOUNT_PAID ACTUAL_ORDER_AMOUNT,
              CASE
                WHEN B.AMOUNT_PAID >= 100 AND B.AMOUNT_PAID < 189 THEN
                 1
                WHEN B.AMOUNT_PAID >= 189 AND B.AMOUNT_PAID < 800 THEN
                 2
                WHEN B.AMOUNT_PAID >= 800 THEN
                 3
                ELSE
                 -1
              END AMOUNT_LEVEL,
              SYSDATE,
              SYSDATE
         FROM (SELECT A.MEMBER_KEY,
                      MAX(A.POSTING_DATE_KEY) POSTING_DATE_KEY,
                      SUM(A.AMOUNT_PAID) AMOUNT_PAID
                 FROM FACT_ORDER@DW_DATALINK A
                WHERE A.ORDER_STATE = 1
                  AND A.SALES_SOURCE_SECOND_KEY IN
                      (20022, 20021, 20020, 20018, 20017)
                GROUP BY A.MEMBER_KEY
               /*��Ч����3��*/
               HAVING COUNT(A.ORDER_KEY) = 3) B
        WHERE B.POSTING_DATE_KEY =
              TO_NUMBER(TO_CHAR(TO_DATE(POSTDAY, 'YYYYMMDD') - 35,
                                'YYYYMMDD')));
    INSERT_ROWS := SQL%ROWCOUNT;
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
  END;

  PROCEDURE PROC_MBR_THIRD_ORDER_MONTH(IN_MONTH_KEY IN NUMBER) IS
    /*
    ��Ա����-��Ȼ��
    3��ÿ����199Ԫ,ë����>100
    3��ÿ����299Ԫ,ë����>200
    3��ÿ����399Ԫ,ë����>300
    */
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
  BEGIN
    SP_NAME          := 'PROC_MBR_THIRD_ORDER_CAL_MONTH'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME := 'OPER_MBR_THIRD_ORDER_CAL_MONTH'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı��
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
  
    DELETE OPER_MBR_THIRD_ORDER_CAL_MONTH T
     WHERE T.MONTH_KEY = IN_MONTH_KEY;
  
    /*��Ȼ���ж������Σ����Ҷ�������ë����ﵽ��ȯ����*/
    INSERT INTO OPER_MBR_THIRD_ORDER_CAL_MONTH
      (MEMBER_KEY,
       MONTH_KEY,
       ORDER_COUNT,
       ACTUAL_ORDER_AMOUNT,
       PROFIT_AMOUNT,
       AMOUNT_LEVEL,
       INSERT_DT,
       UPDATE_DT)
      (SELECT C.MEMBER_KEY,
              C.MONTH_KEY,
              C.ORDER_COUNT,
              C.ACTUAL_ORDER_AMOUNT,
              C.PROFIT_AMOUNT,
              C.AMOUNT_LEVEL,
              C.INSERT_DT,
              C.UPDATE_DT
         FROM (SELECT B.MEMBER_KEY,
                      B.MONTH_KEY,
                      B.ORDER_COUNT,
                      B.AMOUNT_PAID ACTUAL_ORDER_AMOUNT,
                      B.PROFIT_AMOUNT,
                      CASE
                        WHEN B.AMOUNT_PAID >= 199 * 3 AND
                             B.AMOUNT_PAID < 299 * 3 AND
                             B.PROFIT_AMOUNT > 100 THEN
                         1
                        WHEN B.AMOUNT_PAID >= 299 * 3 AND
                             B.AMOUNT_PAID < 399 * 3 AND
                             B.PROFIT_AMOUNT > 200 THEN
                         2
                        WHEN B.AMOUNT_PAID >= 399 * 3 AND
                             B.PROFIT_AMOUNT > 300 THEN
                         3
                        ELSE
                         -1
                      END AMOUNT_LEVEL,
                      SYSDATE INSERT_DT,
                      SYSDATE UPDATE_DT
                 FROM (SELECT A.MEMBER_KEY,
                               SUBSTR(A.POSTING_DATE_KEY, 1, 6) MONTH_KEY,
                               COUNT(A.ORDER_KEY) ORDER_COUNT,
                               SUM(A.AMOUNT_PAID) AMOUNT_PAID,
                               SUM(A.PROFIT_AMOUNT) PROFIT_AMOUNT
                          FROM FACT_ORDER@DW_DATALINK A
                         WHERE
                        /*POSTING_DATE_KEY BETWEEN �·ݵ�һ����·����һ��*/
                         A.POSTING_DATE_KEY BETWEEN
                         TO_NUMBER(TO_CHAR(TO_DATE(TO_CHAR(IN_MONTH_KEY) || '01',
                                                   'YYYYMMDD'),
                                           'YYYYMMDD')) AND
                         TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE(TO_CHAR(IN_MONTH_KEY) || '01',
                                                            'YYYYMMDD')),
                                           'YYYYMMDD'))
                      AND A.ORDER_STATE = 1
                      AND A.SALES_SOURCE_SECOND_KEY IN
                         (20022, 20021, 20020, 20018, 20017)
                         GROUP BY A.MEMBER_KEY,
                                  SUBSTR(A.POSTING_DATE_KEY, 1, 6)
                        /*��Ч����3��,���>=199,ë���ܽ��>=100*/
                        HAVING COUNT(A.ORDER_KEY) = 3 AND SUM(A.AMOUNT_PAID) >= 199 * 3 AND SUM(A.PROFIT_AMOUNT) >= 100) B) C
        WHERE
       /*�ﵽ��ȯ����Ĳ�д���*/
        C.AMOUNT_LEVEL <> -1);
    INSERT_ROWS := SQL%ROWCOUNT;
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
  END;
  PROCEDURE PROC_MBR_TWELVE_ORDER_YEAR(IN_YEAR_KEY IN NUMBER) IS
    /*
    ��Ȼ�궩��12�Σ�
    12��ÿ����199��ë����>600
    12��ÿ����299��ë����>800
    12��ÿ����399��ë����>1500
    */
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
  BEGIN
    SP_NAME          := 'PROC_MBR_TWELVE_ORDER_YEAR'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME := 'OPER_MBR_TWELVE_ORDER_YEAR'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı��
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
    INSERT INTO OPER_MBR_TWELVE_ORDER_YEAR
      (MEMBER_KEY,
       YEAR_KEY,
       ORDER_COUNT,
       ACTUAL_ORDER_AMOUNT,
       PROFIT_AMOUNT,
       AMOUNT_LEVEL,
       INSERT_DT,
       UPDATE_DT)
      (SELECT C.MEMBER_KEY,
              C.YEAR_KEY,
              C.ORDER_COUNT,
              C.ACTUAL_ORDER_AMOUNT,
              C.PROFIT_AMOUNT,
              C.AMOUNT_LEVEL,
              C.INSERT_DT,
              C.UPDATE_DT
         FROM (SELECT B.MEMBER_KEY,
                      B.YEAR_KEY,
                      B.ORDER_COUNT,
                      B.AMOUNT_PAID ACTUAL_ORDER_AMOUNT,
                      B.PROFIT_AMOUNT,
                      CASE
                        WHEN B.AMOUNT_PAID >= 199 * 12 AND
                             B.AMOUNT_PAID < 299 * 12 AND
                             B.PROFIT_AMOUNT > 600 THEN
                         1
                        WHEN B.AMOUNT_PAID >= 299 * 12 AND
                             B.AMOUNT_PAID < 399 * 12 AND
                             B.PROFIT_AMOUNT > 800 THEN
                         2
                        WHEN B.AMOUNT_PAID >= 399 * 3 AND
                             B.PROFIT_AMOUNT > 1500 THEN
                         3
                        ELSE
                         -1
                      END AMOUNT_LEVEL,
                      SYSDATE INSERT_DT,
                      SYSDATE UPDATE_DT
                 FROM (SELECT A.MEMBER_KEY,
                               SUBSTR(A.POSTING_DATE_KEY, 1, 4) YEAR_KEY,
                               COUNT(A.ORDER_KEY) ORDER_COUNT,
                               SUM(A.AMOUNT_PAID) AMOUNT_PAID,
                               SUM(A.PROFIT_AMOUNT) PROFIT_AMOUNT
                          FROM FACT_ORDER@DW_DATALINK A
                         WHERE
                        /*POSTING_DATE_KEY BETWEEN ��Ȼ���һ�� AND ��Ȼ�����һ��*/
                         A.POSTING_DATE_KEY BETWEEN
                         TO_NUMBER(TO_CHAR(IN_YEAR_KEY) || '0101') AND
                         TO_NUMBER(TO_CHAR(ADD_MONTHS(TRUNC(TO_DATE(TO_CHAR(IN_YEAR_KEY) ||
                                                                    '0101',
                                                                    'YYYYMMDD'),
                                                            'yyyy'),
                                                      12) - 1,
                                           'YYYYMMDD'))
                      AND A.ORDER_STATE = 1
                      AND A.SALES_SOURCE_SECOND_KEY IN
                         (20022, 20021, 20020, 20018, 20017)
                         GROUP BY A.MEMBER_KEY,
                                  SUBSTR(A.POSTING_DATE_KEY, 1, 4)
                        /*��Ч����12��,���>=199,ë���ܽ��>=100*/
                        HAVING COUNT(A.ORDER_KEY) = 12 AND SUM(A.AMOUNT_PAID) >= 199 * 12 AND SUM(A.PROFIT_AMOUNT) >= 600) B) C
        WHERE
       /*�ﵽ��ȯ����Ĳ�д���*/
        C.AMOUNT_LEVEL <> -1);
    INSERT_ROWS := SQL%ROWCOUNT;
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
  END;
END;
/
