CREATE OR REPLACE PACKAGE OPER_MEMBER_MARKETING_PKG AS

  PROCEDURE PROC_MBR_REG_WITHOUT_ORDER(POSTDAY IN NUMBER);
  /*
  功能名:       PROC_MBR_REG_WITHOUT_ORDER
  目的:         新会员转换-二次刺激-15,30天未订购
  作者:         yangjin
  创建时间：    2017/05/04
  最后修改人：
  最后更改日期：
  */

  PROCEDURE PROC_MBR_FIRST_ORDER_25DAYS(POSTDAY IN NUMBER);
  /*
  功能名:       PROC_MBR_FIRST_ORDER_25DAYS
  目的:         会员留存-有效订购1次-25天内未重复订购
  作者:         yangjin
  创建时间：    2017/05/04
  最后修改人：
  最后更改日期：
  */

  PROCEDURE PROC_MBR_SECOND_ORDER_30DAYS(POSTDAY IN NUMBER);
  /*
  功能名:       PROC_MBR_SECOND_ORDER_30DAYS
  目的:         会员留存-有效订购2次-30天内未重复订购
  作者:         yangjin
  创建时间：    2017/05/05
  最后修改人：
  最后更改日期：
  */

  PROCEDURE PROC_MBR_THIRD_ORDER_35DAYS(POSTDAY IN NUMBER);
  /*
  功能名:       PROC_MBR_THIRD_ORDER_35DAYS
  目的:         会员留存-有效订购3次-35天内未重复订购
  作者:         yangjin
  创建时间：    2017/05/05
  最后修改人：
  最后更改日期：
  */

  PROCEDURE PROC_MBR_THIRD_ORDER_MONTH(IN_MONTH_KEY IN NUMBER);
  /*
  功能名:       PROC_MBR_THIRD_ORDER_CAL_MONTH
  目的:         会员激励-有效订购3次-自然月（199、299、399）
  作者:         yangjin
  创建时间：    2017/05/08
  最后修改人：
  最后更改日期：
  */

  PROCEDURE PROC_MBR_TWELVE_ORDER_YEAR(IN_YEAR_KEY IN NUMBER);
  /*
  功能名:       PROC_MBR_TWELVE_ORDER_YEAR
  目的:         会员激励-有效订购12次-自然年（199、299、399）
  作者:         yangjin
  创建时间：    2017/05/09
  最后修改人：
  最后更改日期：
  */

END OPER_MEMBER_MARKETING_PKG;
/
CREATE OR REPLACE PACKAGE BODY OPER_MEMBER_MARKETING_PKG AS
  PROCEDURE PROC_MBR_REG_WITHOUT_ORDER(POSTDAY IN NUMBER) IS
    /*新会员转换-二次刺激-15,30天未订购*/
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
  
  BEGIN
    SP_NAME          := 'PROC_MBR_REG_WITHOUT_ORDER'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'OPER_MBR_REG_WITHOUT_ORDER'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0' THEN
        S_ETL.ERR_MSG := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    DELETE FROM OPER_MBR_REG_WITHOUT_ORDER T
     WHERE T.RECORD_DATE_KEY = POSTDAY;
  
    /*15天未订购会员*/
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
              0, /*15天未订购，标志为0*/
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
  
    /*30天未订购会员*/
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
              1, /*30天未订购，标志为1*/
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
  
    /*日志记录模块*/
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
    /*会员留存-有效订购1次-25天内未重复订购*/
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
  
  BEGIN
    SP_NAME          := 'PROC_MBR_FIRST_ORDER_25DAYS'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'OPER_MBR_FIRST_ORDER_25DAYS'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0' THEN
        S_ETL.ERR_MSG := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    DELETE FROM OPER_MBR_FITST_ORDER_25DAYS T
     WHERE T.RECORD_DATE_KEY = POSTDAY;
  
    /*有效订购1次，25天内无重复订购*/
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
               /*有效订购1次*/
               HAVING COUNT(A.ORDER_KEY) = 1) B
        WHERE B.POSTING_DATE_KEY =
              TO_NUMBER(TO_CHAR(TO_DATE(POSTDAY, 'YYYYMMDD') - 25,
                                'YYYYMMDD')));
    INSERT_ROWS := SQL%ROWCOUNT;
    /*日志记录模块*/
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
    /*会员留存-有效订购2次-30天内未重复订购*/
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
  
  BEGIN
    SP_NAME          := 'PROC_MBR_SECOND_ORDER_30DAYS'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'OPER_MBR_SECOND_ORDER_30DAYS'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0' THEN
        S_ETL.ERR_MSG := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    /*有效订购2次，30天内无重复订购*/
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
               /*有效订购2次*/
               HAVING COUNT(A.ORDER_KEY) = 2) B
        WHERE B.POSTING_DATE_KEY =
              TO_NUMBER(TO_CHAR(TO_DATE(POSTDAY, 'YYYYMMDD') - 30,
                                'YYYYMMDD')));
    INSERT_ROWS := SQL%ROWCOUNT;
    /*日志记录模块*/
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
    /*会员留存-有效订购3次-35天内未重复订购*/
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
  
  BEGIN
    SP_NAME          := 'PROC_MBR_THIRD_ORDER_35DAYS'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'OPER_MBR_THIRD_ORDER_35DAYS'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0' THEN
        S_ETL.ERR_MSG := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    /*有效订购3次，35天内无重复订购*/
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
               /*有效订购3次*/
               HAVING COUNT(A.ORDER_KEY) = 3) B
        WHERE B.POSTING_DATE_KEY =
              TO_NUMBER(TO_CHAR(TO_DATE(POSTDAY, 'YYYYMMDD') - 35,
                                'YYYYMMDD')));
    INSERT_ROWS := SQL%ROWCOUNT;
    /*日志记录模块*/
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
    会员激励-自然月
    3次每次满199元,毛利额>100
    3次每次满299元,毛利额>200
    3次每次满399元,毛利额>300
    */
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
  BEGIN
    SP_NAME          := 'PROC_MBR_THIRD_ORDER_CAL_MONTH'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'OPER_MBR_THIRD_ORDER_CAL_MONTH'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0' THEN
        S_ETL.ERR_MSG := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    DELETE OPER_MBR_THIRD_ORDER_CAL_MONTH T
     WHERE T.MONTH_KEY = IN_MONTH_KEY;
  
    /*自然月中订购三次，并且订购金额和毛利额达到送券规则*/
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
                        /*POSTING_DATE_KEY BETWEEN 月份第一天和月份最后一天*/
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
                        /*有效订购3次,金额>=199,毛利总金额>=100*/
                        HAVING COUNT(A.ORDER_KEY) = 3 AND SUM(A.AMOUNT_PAID) >= 199 * 3 AND SUM(A.PROFIT_AMOUNT) >= 100) B) C
        WHERE
       /*达到发券规则的才写入表*/
        C.AMOUNT_LEVEL <> -1);
    INSERT_ROWS := SQL%ROWCOUNT;
    /*日志记录模块*/
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
    自然年订购12次，
    12次每次满199，毛利额>600
    12次每次满299，毛利额>800
    12次每次满399，毛利额>1500
    */
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
  BEGIN
    SP_NAME          := 'PROC_MBR_TWELVE_ORDER_YEAR'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'OPER_MBR_TWELVE_ORDER_YEAR'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0' THEN
        S_ETL.ERR_MSG := '没有找到对应的过程加载类型数据';
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
                        /*POSTING_DATE_KEY BETWEEN 自然年第一天 AND 自然年最后一天*/
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
                        /*有效订购12次,金额>=199,毛利总金额>=100*/
                        HAVING COUNT(A.ORDER_KEY) = 12 AND SUM(A.AMOUNT_PAID) >= 199 * 12 AND SUM(A.PROFIT_AMOUNT) >= 600) B) C
        WHERE
       /*达到发券规则的才写入表*/
        C.AMOUNT_LEVEL <> -1);
    INSERT_ROWS := SQL%ROWCOUNT;
    /*日志记录模块*/
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
