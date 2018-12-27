???CREATE OR REPLACE PACKAGE DW_USER.OPER_MEMBER_MARKETING_PKG AS

  PROCEDURE PROC_MBR_REG_WITHOUT_ORDER(POSTDAY IN NUMBER);
  /*
  功能名:       PROC_MBR_REG_WITHOUT_ORDER
  目的:         新会员转换-二次刺激-15,30天未订购
  作者:         yangjin
  创建时间：    2017/05/04
  最后修改人：
  最后更改日期：
  */

  PROCEDURE PROC_MBR_FIRST_ORDER_15DAYS(POSTDAY IN NUMBER);
  /*
  功能名:       PROC_MBR_FIRST_ORDER_25DAYS
  目的:         会员留存-有效订购1次-15天内未重复订购
  作者:         yangjin
  创建时间：    2017/08/10
  最后修改人：
  最后更改日期：
  */

  PROCEDURE PROC_MBR_SECOND_ORDER_20DAYS(POSTDAY IN NUMBER);
  /*
  功能名:       PROC_MBR_SECOND_ORDER_20DAYS
  目的:         会员留存-有效订购2次-20天内未重复订购
  作者:         yangjin
  创建时间：    2017/08/10
  最后修改人：
  最后更改日期：
  */

  PROCEDURE PROC_MBR_THIRD_ORDER_30DAYS(POSTDAY IN NUMBER);
  /*
  功能名:       PROC_MBR_THIRD_ORDER_35DAYS
  目的:         会员留存-有效订购3次-30天内未重复订购
  作者:         yangjin
  创建时间：    2017/08/10
  最后修改人：
  最后更改日期：
  */

  PROCEDURE PROC_MBR_ORDER_RETAIN_PUSH(POSTDAY IN NUMBER);
  /*
  功能名:       PROC_MBR_ORDER_PUSH
  目的:         oper_mbr_fitst_order_15days,
                oper_mbr_second_order_20days,
                oper_mbr_third_order_30days;
                这三张表统一插入oper_mbr_order_push表
  作者:         yangjin
  创建时间：    2017/08/22
  最后修改人：
  最后更改日期：
  */

  PROCEDURE PROC_MBR_THIRD_ORDER_MONTH(IN_MONTH_KEY IN NUMBER);
  /*
  功能名:       PROC_MBR_THIRD_ORDER_MONTH
  目的:         会员激励-有效订购3次-自然月（199、299、399）
  作者:         yangjin
  创建时间：    2017/05/08
  最后修改人：
  最后更改日期：
  */

  PROCEDURE PROC_MBR_TWELVE_ORDER_YEAR(POSDAY IN NUMBER);
  /*
  功能名:       PROC_MBR_TWELVE_ORDER_YEAR
  目的:         会员激励-有效订购12次-自然年（199、299、399）
                每月15日执行一次。
  作者:         yangjin
  创建时间：    2017/05/09
  最后修改人：
  最后更改日期：
  */

END OPER_MEMBER_MARKETING_PKG;
/

CREATE OR REPLACE PACKAGE BODY DW_USER.OPER_MEMBER_MARKETING_PKG AS
  PROCEDURE PROC_MBR_REG_WITHOUT_ORDER(POSTDAY IN NUMBER) IS
    /*新会员转换-二次刺激-7,15天未订购*/
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
  
  BEGIN
    SP_NAME          := 'OPER_MEMBER_MARKETING_PKG.PROC_MBR_REG_WITHOUT_ORDER'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'OPER_MBR_REG_WITHOUT_ORDER'; --此处需要手工录入该PROCEDURE操作的表格
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
  
    /*7天未订购会员*/
    INSERT INTO OPER_MBR_REG_WITHOUT_ORDER
      (MEMBER_KEY,
       REGISTER_DATE_KEY,
       THIRTY_WITHOUT_ORDER_FLAG,
       RECORD_DATE_KEY,
       REGISTER_DEVICE_KEY,
       INSERT_DT,
       UPDATE_DT)
      SELECT DISTINCT M.MEMBER_CRMBP AS MEMBER_KEY,
                      TO_NUMBER(TO_CHAR(TO_DATE(POSTDAY, 'yyyy-mm-dd') - 7,
                                        'yyyymmdd')) AS REGISTER_DATE_KEY,
                      0, /*7天未订购，标志为0*/
                      POSTDAY AS RECORD_DATE_KEY,
                      S.DEVICE_KEY AS REGISTER_DEVICE_KEY,
                      SYSDATE,
                      SYSDATE
        FROM FACT_ECMEMBER@DW_DATALINK M
        LEFT JOIN (SELECT MEMBER_KEY, DEVICE_KEY
                     FROM FACT_MEMBER_REGISTER@DW_DATALINK
                    GROUP BY MEMBER_KEY, DEVICE_KEY) S
          ON S.MEMBER_KEY = M.MEMBER_CRMBP
       WHERE M.MEMBER_TIME =
             TO_NUMBER(TO_CHAR(TO_DATE(POSTDAY, 'yyyy-mm-dd') - 7,
                               'yyyymmdd'))
         AND NOT EXISTS
       (SELECT 1
                FROM (SELECT DISTINCT (MEMBER_KEY) MEMBER_KEY
                        FROM FACT_ORDER@DW_DATALINK A
                       WHERE ORDER_STATE = 1
                         AND SALES_SOURCE_SECOND_KEY IN
                             (20022, 20021, 20020, 20018, 20017)
                         AND POSTING_DATE_KEY BETWEEN
                             TO_NUMBER(TO_CHAR(TO_DATE(POSTDAY, 'yyyy-mm-dd') - 7,
                                               'yyyymmdd')) AND POSTDAY) B
               WHERE M.MEMBER_CRMBP = B.MEMBER_KEY)
            /*不重复插入*/
         AND NOT EXISTS (SELECT 1
                FROM OPER_MBR_REG_WITHOUT_ORDER C
               WHERE M.MEMBER_CRMBP = C.MEMBER_KEY
                 AND C.RECORD_DATE_KEY = POSTDAY);
    INSERT_ROWS := SQL%ROWCOUNT;
  
    /*15天未订购会员*/
    INSERT INTO OPER_MBR_REG_WITHOUT_ORDER
      (MEMBER_KEY,
       REGISTER_DATE_KEY,
       THIRTY_WITHOUT_ORDER_FLAG,
       RECORD_DATE_KEY,
       REGISTER_DEVICE_KEY,
       INSERT_DT,
       UPDATE_DT)
      SELECT DISTINCT M.MEMBER_CRMBP AS MEMBER_KEY,
                      TO_NUMBER(TO_CHAR(TO_DATE(POSTDAY, 'yyyy-mm-dd') - 15,
                                        'yyyymmdd')) AS REGISTER_DATE_KEY,
                      1, /*15天未订购，标志为1*/
                      POSTDAY AS RECORD_DATE_KEY,
                      S.DEVICE_KEY AS REGISTER_DEVICE_KEY,
                      SYSDATE,
                      SYSDATE
        FROM FACT_ECMEMBER@DW_DATALINK M
        LEFT JOIN (SELECT MEMBER_KEY, DEVICE_KEY
                     FROM FACT_MEMBER_REGISTER@DW_DATALINK
                    GROUP BY MEMBER_KEY, DEVICE_KEY) S
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
               WHERE M.MEMBER_CRMBP = B.MEMBER_KEY)
            /*不重复插入*/
         AND NOT EXISTS (SELECT 1
                FROM OPER_MBR_REG_WITHOUT_ORDER C
               WHERE M.MEMBER_CRMBP = C.MEMBER_KEY
                 AND C.RECORD_DATE_KEY = POSTDAY);
  
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ERR_MSG        := '输入参数:POSTDAY:' || TO_CHAR(POSTDAY);
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
  END PROC_MBR_REG_WITHOUT_ORDER;

  PROCEDURE PROC_MBR_FIRST_ORDER_15DAYS(POSTDAY IN NUMBER) IS
    /*会员留存-有效订购1次-15天内未重复订购*/
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
  
  BEGIN
    SP_NAME          := 'OPER_MEMBER_MARKETING_PKG.PROC_MBR_FIRST_ORDER_15DAYS'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'OPER_MBR_FIRST_ORDER_15DAYS'; --此处需要手工录入该PROCEDURE操作的表格
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
  
    DELETE FROM OPER_MBR_FITST_ORDER_15DAYS T
     WHERE T.RECORD_DATE_KEY = POSTDAY;
  
    /*有效订购1次，15天内无重复订购*/
    INSERT INTO OPER_MBR_FITST_ORDER_15DAYS
      (MEMBER_KEY,
       RECORD_DATE_KEY,
       ORDER_TIME,
       ACTUAL_ORDER_AMOUNT,
       AMOUNT_LEVEL,
       INSERT_DT,
       UPDATE_DT)
      SELECT B.MEMBER_KEY,
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
                 AND A.POSTING_DATE_KEY <=
                     TO_NUMBER(TO_CHAR(TO_DATE(POSTDAY, 'YYYYMMDD') - 15,
                                       'YYYYMMDD'))
               GROUP BY A.MEMBER_KEY
              /*有效订购1次*/
              HAVING COUNT(A.ORDER_KEY) = 1) B
       WHERE B.POSTING_DATE_KEY =
             TO_NUMBER(TO_CHAR(TO_DATE(POSTDAY, 'YYYYMMDD') - 15,
                               'YYYYMMDD'));
    INSERT_ROWS := SQL%ROWCOUNT;
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ERR_MSG        := '输入参数:POSTDAY:' || TO_CHAR(POSTDAY);
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
  END PROC_MBR_FIRST_ORDER_15DAYS;

  PROCEDURE PROC_MBR_SECOND_ORDER_20DAYS(POSTDAY IN NUMBER) IS
    /*会员留存-有效订购2次-20天内未重复订购*/
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
  
  BEGIN
    SP_NAME          := 'OPER_MEMBER_MARKETING_PKG.PROC_MBR_SECOND_ORDER_20DAYS'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'OPER_MBR_SECOND_ORDER_20DAYS'; --此处需要手工录入该PROCEDURE操作的表格
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
  
    DELETE OPER_MBR_SECOND_ORDER_20DAYS A
     WHERE A.RECORD_DATE_KEY = POSTDAY;
    COMMIT;
  
    /*有效订购2次，20天内无重复订购*/
    INSERT INTO OPER_MBR_SECOND_ORDER_20DAYS
      (MEMBER_KEY,
       RECORD_DATE_KEY,
       ORDER_TIME,
       ACTUAL_ORDER_AMOUNT,
       AMOUNT_LEVEL,
       INSERT_DT,
       UPDATE_DT)
      SELECT B.MEMBER_KEY,
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
                 AND A.POSTING_DATE_KEY <=
                     TO_NUMBER(TO_CHAR(TO_DATE(POSTDAY, 'YYYYMMDD') - 20,
                                       'YYYYMMDD'))
               GROUP BY A.MEMBER_KEY
              /*有效订购2次*/
              HAVING COUNT(A.ORDER_KEY) = 2) B
       WHERE B.POSTING_DATE_KEY =
             TO_NUMBER(TO_CHAR(TO_DATE(POSTDAY, 'YYYYMMDD') - 20,
                               'YYYYMMDD'));
    INSERT_ROWS := SQL%ROWCOUNT;
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ERR_MSG        := '输入参数:POSTDAY:' || TO_CHAR(POSTDAY);
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
  END PROC_MBR_SECOND_ORDER_20DAYS;

  PROCEDURE PROC_MBR_THIRD_ORDER_30DAYS(POSTDAY IN NUMBER) IS
    /*会员留存-有效订购3次-30天内未重复订购*/
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
  
  BEGIN
    SP_NAME          := 'OPER_MEMBER_MARKETING_PKG.PROC_MBR_THIRD_ORDER_30DAYS'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'OPER_MBR_THIRD_ORDER_30DAYS'; --此处需要手工录入该PROCEDURE操作的表格
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
  
    DELETE OPER_MBR_THIRD_ORDER_30DAYS A WHERE A.RECORD_DATE_KEY = POSTDAY;
    COMMIT;
  
    /*有效订购3次，30天内无重复订购*/
    INSERT INTO OPER_MBR_THIRD_ORDER_30DAYS
      (MEMBER_KEY,
       RECORD_DATE_KEY,
       ORDER_TIME,
       ACTUAL_ORDER_AMOUNT,
       AMOUNT_LEVEL,
       INSERT_DT,
       UPDATE_DT)
      SELECT B.MEMBER_KEY,
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
             SYSDATE INSERT_DT,
             SYSDATE UPDATE_DT
        FROM (SELECT A.MEMBER_KEY,
                     MAX(A.POSTING_DATE_KEY) POSTING_DATE_KEY,
                     SUM(A.AMOUNT_PAID) AMOUNT_PAID
                FROM FACT_ORDER@DW_DATALINK A
               WHERE A.ORDER_STATE = 1
                 AND A.SALES_SOURCE_SECOND_KEY IN
                     (20022, 20021, 20020, 20018, 20017)
                 AND A.POSTING_DATE_KEY <=
                     TO_NUMBER(TO_CHAR(TO_DATE(POSTDAY, 'YYYYMMDD') - 30,
                                       'YYYYMMDD'))
               GROUP BY A.MEMBER_KEY
              /*有效订购3次*/
              HAVING COUNT(A.ORDER_KEY) = 3) B
       WHERE B.POSTING_DATE_KEY =
             TO_NUMBER(TO_CHAR(TO_DATE(POSTDAY, 'YYYYMMDD') - 30,
                               'YYYYMMDD'));
    INSERT_ROWS := SQL%ROWCOUNT;
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ERR_MSG        := '输入参数:POSTDAY:' || TO_CHAR(POSTDAY);
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
  END PROC_MBR_THIRD_ORDER_30DAYS;

  PROCEDURE PROC_MBR_ORDER_RETAIN_PUSH(POSTDAY IN NUMBER) IS
    /*oper_mbr_fitst_order_15days,
    oper_mbr_second_order_20days,
    oper_mbr_third_order_30days;
    这三张表统一插入oper_mbr_order_push表*/
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
  
  BEGIN
    SP_NAME          := 'OPER_MEMBER_MARKETING_PKG.PROC_MBR_ORDER_PUSH'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'OPER_MBR_ORDER_PUSH'; --此处需要手工录入该PROCEDURE操作的表格
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
  
    /*oper_mbr_fitst_order_15days,
    oper_mbr_second_order_20days,
    oper_mbr_third_order_30days;
    这三张表统一插入oper_mbr_order_push表*/
    INSERT INTO OPER_MBR_ORDER_RETAIN_PUSH
      (MEMBER_KEY,
       RECORD_DATE_KEY,
       ORDER_DATE_KEY,
       ACTUAL_ORDER_AMOUNT,
       ORDER_FREQUENCY,
       AMOUNT_LEVEL,
       DAY_WITHOUT_ORDER,
       INSERT_DT,
       UPDATE_DT)
      SELECT D.MEMBER_KEY,
             D.RECORD_DATE_KEY,
             D.ORDER_DATE_KEY,
             D.ACTUAL_ORDER_AMOUNT,
             D.ORDER_FREQUENCY,
             D.AMOUNT_LEVEL,
             D.DAY_WITHOUT_ORDER,
             D.INSERT_DT,
             D.UPDATE_DT
        FROM (SELECT A.MEMBER_KEY,
                     A.RECORD_DATE_KEY,
                     A.ORDER_TIME ORDER_DATE_KEY,
                     A.ACTUAL_ORDER_AMOUNT,
                     1 ORDER_FREQUENCY,
                     A.AMOUNT_LEVEL,
                     TO_DATE(A.RECORD_DATE_KEY, 'YYYYMMDD') -
                     TO_DATE(A.ORDER_TIME, 'YYYYMMDD') DAY_WITHOUT_ORDER,
                     A.INSERT_DT,
                     A.UPDATE_DT
                FROM OPER_MBR_FITST_ORDER_15DAYS A
              UNION ALL
              SELECT B.MEMBER_KEY,
                     B.RECORD_DATE_KEY,
                     B.ORDER_TIME ORDER_DATE_KEY,
                     B.ACTUAL_ORDER_AMOUNT,
                     2 ORDER_FREQUENCY,
                     B.AMOUNT_LEVEL,
                     TO_DATE(B.RECORD_DATE_KEY, 'YYYYMMDD') -
                     TO_DATE(B.ORDER_TIME, 'YYYYMMDD') DAY_WITHOUT_ORDER,
                     B.INSERT_DT,
                     B.UPDATE_DT
                FROM OPER_MBR_SECOND_ORDER_20DAYS B
              UNION ALL
              SELECT C.MEMBER_KEY,
                     C.RECORD_DATE_KEY,
                     C.ORDER_TIME ORDER_DATE_KEY,
                     C.ACTUAL_ORDER_AMOUNT,
                     3 ORDER_FREQUENCY,
                     C.AMOUNT_LEVEL,
                     TO_DATE(C.RECORD_DATE_KEY, 'YYYYMMDD') -
                     TO_DATE(C.ORDER_TIME, 'YYYYMMDD') DAY_WITHOUT_ORDER,
                     C.INSERT_DT,
                     C.UPDATE_DT
                FROM OPER_MBR_THIRD_ORDER_30DAYS C) D
       WHERE D.RECORD_DATE_KEY = POSTDAY
         AND NOT EXISTS
       (SELECT 1
                FROM OPER_MBR_ORDER_RETAIN_PUSH E
               WHERE D.RECORD_DATE_KEY = E.RECORD_DATE_KEY
                 AND D.ORDER_FREQUENCY = E.ORDER_FREQUENCY
                 AND D.MEMBER_KEY = E.MEMBER_KEY
                 AND D.AMOUNT_LEVEL = E.AMOUNT_LEVEL);
    INSERT_ROWS := SQL%ROWCOUNT;
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ERR_MSG        := '输入参数:POSTDAY:' || TO_CHAR(POSTDAY);
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
  END PROC_MBR_ORDER_RETAIN_PUSH;

  PROCEDURE PROC_MBR_THIRD_ORDER_MONTH(IN_MONTH_KEY IN NUMBER) IS
    /*
    会员激励
    自然月，3次每次满199元,毛利额>=100，level=1
    自然月，3次每次满299元,100<=毛利额<200，level=1
    自然月，3次每次满299元,毛利额>=200，level=2
    自然月，3次每次满399元,200<=毛利额<300，level=2
    自然月，3次每次满399元,毛利额>=300，level=3
    */
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
  BEGIN
    SP_NAME          := 'OPER_MEMBER_MARKETING_PKG.PROC_MBR_THIRD_ORDER_CAL_MONTH'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'OPER_MBR_THIRD_ORDER_CAL_MONTH'; --此处需要手工录入该PROCEDURE操作的表格
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
  
    /*删除数据*/
    DELETE OPER_MBR_THIRD_ORDER_CAL_MONTH T
     WHERE T.MONTH_KEY = IN_MONTH_KEY;
    COMMIT;
  
    /*
    会员激励
    自然月，3次每次满199元,毛利额>=100，level=1
    自然月，3次每次满299元,100<=毛利额<200，level=1
    自然月，3次每次满299元,毛利额>=200，level=2
    自然月，3次每次满399元,200<=毛利额<300，level=2
    自然月，3次每次满399元,毛利额>=300，level=3
    */
    INSERT INTO OPER_MBR_THIRD_ORDER_CAL_MONTH
      (MEMBER_KEY,
       MONTH_KEY,
       ORDER_COUNT,
       ACTUAL_ORDER_AMOUNT,
       PROFIT_AMOUNT,
       AMOUNT_LEVEL,
       INSERT_DT,
       UPDATE_DT)
      SELECT B.MEMBER_KEY,
             B.MONTH_KEY,
             MIN(B.ORDER_COUNT) ORDER_COUNT,
             MIN(B.TOTAL_AMOUNT_PAID) TOTAL_AMOUNT_PAID,
             MIN(B.PROFIT_AMOUNT) PROFIT_AMOUNT,
             MAX(B.AMOUNT_LEVEL) AMOUNT_LEVEL,
             SYSDATE W_INSERT_DT,
             SYSDATE W_UPDATE_DT
        FROM (
               --1.单笔金额>=199,毛利金额>=100,level1
               SELECT A.MEMBER_KEY,
                       SUBSTR(A.POSTING_DATE_KEY, 1, 6) MONTH_KEY,
                       COUNT(A.ORDER_KEY) ORDER_COUNT,
                       SUM(A.AMOUNT_PAID) TOTAL_AMOUNT_PAID, /*合计金额*/
                       MIN(A.AMOUNT_PAID) MIN_AMOUNT_PAID, /*单笔最小金额*/
                       SUM(A.PROFIT_AMOUNT) PROFIT_AMOUNT,
                       '1' AMOUNT_LEVEL
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
             AND A.AMOUNT_PAID >= 199 /*单笔金额>=199*/
                GROUP BY A.MEMBER_KEY, SUBSTR(A.POSTING_DATE_KEY, 1, 6)
               /*有效订购满3次,毛利总金额>=100*/
               HAVING COUNT(A.ORDER_KEY) >= 3 AND SUM(A.PROFIT_AMOUNT) >= 100
               UNION ALL
               --2.单笔金额>=299,毛利金额>=100,level1
               SELECT A.MEMBER_KEY,
                       SUBSTR(A.POSTING_DATE_KEY, 1, 6) MONTH_KEY,
                       COUNT(A.ORDER_KEY) ORDER_COUNT,
                       SUM(A.AMOUNT_PAID) TOTAL_AMOUNT_PAID, /*合计金额*/
                       MIN(A.AMOUNT_PAID) MIN_AMOUNT_PAID, /*单笔最小金额*/
                       SUM(A.PROFIT_AMOUNT) PROFIT_AMOUNT,
                       '1' AMOUNT_LEVEL
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
             AND A.AMOUNT_PAID >= 299 /*单笔金额>=199*/
                GROUP BY A.MEMBER_KEY, SUBSTR(A.POSTING_DATE_KEY, 1, 6)
               /*有效订购满3次,毛利总金额>=100*/
               HAVING COUNT(A.ORDER_KEY) >= 3 AND SUM(A.PROFIT_AMOUNT) >= 100
               UNION ALL
               --3.单笔金额>=299,毛利金额>=200,level2
               SELECT A.MEMBER_KEY,
                       SUBSTR(A.POSTING_DATE_KEY, 1, 6) MONTH_KEY,
                       COUNT(A.ORDER_KEY) ORDER_COUNT,
                       SUM(A.AMOUNT_PAID) TOTAL_AMOUNT_PAID, /*合计金额*/
                       MIN(A.AMOUNT_PAID) MIN_AMOUNT_PAID, /*单笔最小金额*/
                       SUM(A.PROFIT_AMOUNT) PROFIT_AMOUNT,
                       '2' AMOUNT_LEVEL
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
             AND A.AMOUNT_PAID >= 299 /*单笔金额>=299*/
                GROUP BY A.MEMBER_KEY, SUBSTR(A.POSTING_DATE_KEY, 1, 6)
               /*有效订购满3次,毛利总金额>=100*/
               HAVING COUNT(A.ORDER_KEY) >= 3 AND SUM(A.PROFIT_AMOUNT) >= 200
               UNION ALL
               --4.单笔金额>=399,毛利金额>=200,level2
               SELECT A.MEMBER_KEY,
                       SUBSTR(A.POSTING_DATE_KEY, 1, 6) MONTH_KEY,
                       COUNT(A.ORDER_KEY) ORDER_COUNT,
                       SUM(A.AMOUNT_PAID) TOTAL_AMOUNT_PAID, /*合计金额*/
                       MIN(A.AMOUNT_PAID) MIN_AMOUNT_PAID, /*单笔最小金额*/
                       SUM(A.PROFIT_AMOUNT) PROFIT_AMOUNT,
                       '2' AMOUNT_LEVEL
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
             AND A.AMOUNT_PAID >= 399 /*单笔金额>=399*/
                GROUP BY A.MEMBER_KEY, SUBSTR(A.POSTING_DATE_KEY, 1, 6)
               /*有效订购满3次,毛利总金额>=100*/
               HAVING COUNT(A.ORDER_KEY) >= 3 AND SUM(A.PROFIT_AMOUNT) >= 200
               UNION ALL
               --5.单笔金额>=399,毛利金额>=300,level3
               SELECT A.MEMBER_KEY,
                       SUBSTR(A.POSTING_DATE_KEY, 1, 6) MONTH_KEY,
                       COUNT(A.ORDER_KEY) ORDER_COUNT,
                       SUM(A.AMOUNT_PAID) TOTAL_AMOUNT_PAID, /*合计金额*/
                       MIN(A.AMOUNT_PAID) MIN_AMOUNT_PAID, /*单笔最小金额*/
                       SUM(A.PROFIT_AMOUNT) PROFIT_AMOUNT,
                       '3' AMOUNT_LEVEL
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
             AND A.AMOUNT_PAID >= 399 /*单笔金额>=399*/
                GROUP BY A.MEMBER_KEY, SUBSTR(A.POSTING_DATE_KEY, 1, 6)
               /*有效订购满3次,毛利总金额>=100*/
               HAVING COUNT(A.ORDER_KEY) >= 3 AND SUM(A.PROFIT_AMOUNT) >= 300) B
      /*WHERE B.MEMBER_KEY = 607037597*/
       GROUP BY B.MEMBER_KEY, B.MONTH_KEY;
    INSERT_ROWS := SQL%ROWCOUNT;
  
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ERR_MSG        := '输入参数:IN_MONTH_KEY:' || TO_CHAR(IN_MONTH_KEY);
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

  PROCEDURE PROC_MBR_TWELVE_ORDER_YEAR(POSDAY IN NUMBER) IS
    /*
    每月15日执行一次。
    自然年订购12次，
    
    */
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
  BEGIN
    SP_NAME          := 'OPER_MEMBER_MARKETING_PKG.PROC_MBR_TWELVE_ORDER_YEAR'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'OPER_MBR_TWELVE_ORDER_YEAR'; --此处需要手工录入该PROCEDURE操作的表格
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
  
    DELETE OPER_MBR_TWELVE_ORDER_YEAR A
     WHERE A.YEAR_KEY = TO_CHAR(TO_DATE(POSDAY, 'YYYYMMDD'), 'YYYY')
       AND A.MONTH_KEY = TO_CHAR(TO_DATE(POSDAY, 'YYYYMMDD'), 'YYYYMM');
    COMMIT;
  
    /*
    12次每次满199，毛利额>=600， level=1
    12次每次满299，600<=毛利额<800，level=1
    12次每次满299，毛利额>=800， level=2
    12次每次满399，800<=毛利额<1500，level=2
    12次每次满399，毛利额>=1500， level=3
    */
    INSERT INTO OPER_MBR_TWELVE_ORDER_YEAR
      (MEMBER_KEY,
       YEAR_KEY,
       MONTH_KEY,
       ORDER_COUNT,
       ACTUAL_ORDER_AMOUNT,
       PROFIT_AMOUNT,
       AMOUNT_LEVEL,
       INSERT_DT,
       UPDATE_DT)
      SELECT B.MEMBER_KEY,
             B.YEAR_KEY,
             TO_CHAR(TO_DATE(POSDAY, 'YYYYMMDD'), 'YYYYMM') MONTH_KEY,
             MIN(B.ORDER_COUNT) ORDER_COUNT,
             MIN(B.TOTAL_AMOUNT_PAID) TOTAL_AMOUNT_PAID,
             MIN(B.PROFIT_AMOUNT) PROFIT_AMOUNT,
             MAX(B.AMOUNT_LEVEL) AMOUNT_LEVEL,
             SYSDATE W_INSERT_DT,
             SYSDATE W_UPDATE_DT
        FROM (
               
               --1.单笔满199，毛利额>=600,level1
               SELECT A.MEMBER_KEY,
                       SUBSTR(A.POSTING_DATE_KEY, 1, 4) YEAR_KEY,
                       COUNT(A.ORDER_KEY) ORDER_COUNT,
                       SUM(A.AMOUNT_PAID) TOTAL_AMOUNT_PAID,
                       SUM(A.PROFIT_AMOUNT) PROFIT_AMOUNT,
                       1 AMOUNT_LEVEL
                 FROM FACT_ORDER@DW_DATALINK A
                WHERE
               /*POSTING_DATE_KEY BETWEEN 自然年第一天 AND 上个月最后一天*/
                A.POSTING_DATE_KEY BETWEEN
                TO_NUMBER(TO_CHAR(TRUNC(TO_DATE(POSDAY, 'YYYYMMDD'), 'YEAR'),
                                  'YYYYMMDD')) AND
                TO_NUMBER(TO_CHAR(TRUNC(TO_DATE(POSDAY, 'YYYYMMDD'), 'MONTH') - 1,
                                  'YYYYMMDD'))
             AND A.ORDER_STATE = 1
             AND A.AMOUNT_PAID >= 199 /*单笔满199*/
             AND A.SALES_SOURCE_SECOND_KEY IN
                (20022, 20021, 20020, 20018, 20017)
                GROUP BY A.MEMBER_KEY, SUBSTR(A.POSTING_DATE_KEY, 1, 4)
               /*有效订购大于12次,金额>=199,毛利总金额>=100*/
               HAVING COUNT(A.ORDER_KEY) >= 12 AND SUM(A.PROFIT_AMOUNT) >= 600
               --2.单笔满299,毛利额>=600,level1
               UNION ALL
               SELECT A.MEMBER_KEY,
                       SUBSTR(A.POSTING_DATE_KEY, 1, 4) YEAR_KEY,
                       COUNT(A.ORDER_KEY) ORDER_COUNT,
                       SUM(A.AMOUNT_PAID) TOTAL_AMOUNT_PAID,
                       SUM(A.PROFIT_AMOUNT) PROFIT_AMOUNT,
                       1 AMOUNT_LEVEL
                 FROM FACT_ORDER@DW_DATALINK A
                WHERE
               /*POSTING_DATE_KEY BETWEEN 自然年第一天 AND 上个月最后一天*/
                A.POSTING_DATE_KEY BETWEEN
                TO_NUMBER(TO_CHAR(TRUNC(TO_DATE(POSDAY, 'YYYYMMDD'), 'YEAR'),
                                  'YYYYMMDD')) AND
                TO_NUMBER(TO_CHAR(TRUNC(TO_DATE(POSDAY, 'YYYYMMDD'), 'MONTH') - 1,
                                  'YYYYMMDD'))
             AND A.ORDER_STATE = 1
             AND A.AMOUNT_PAID >= 299 /*单笔满299*/
             AND A.SALES_SOURCE_SECOND_KEY IN
                (20022, 20021, 20020, 20018, 20017)
                GROUP BY A.MEMBER_KEY, SUBSTR(A.POSTING_DATE_KEY, 1, 4)
               /*有效订购大于12次,金额>=199,毛利总金额>=100*/
               HAVING COUNT(A.ORDER_KEY) >= 12 AND SUM(A.PROFIT_AMOUNT) >= 600
               --3.单笔满299,毛利额>=800,level2
               UNION ALL
               SELECT A.MEMBER_KEY,
                       SUBSTR(A.POSTING_DATE_KEY, 1, 4) YEAR_KEY,
                       COUNT(A.ORDER_KEY) ORDER_COUNT,
                       SUM(A.AMOUNT_PAID) TOTAL_AMOUNT_PAID,
                       SUM(A.PROFIT_AMOUNT) PROFIT_AMOUNT,
                       2 AMOUNT_LEVEL
                 FROM FACT_ORDER@DW_DATALINK A
                WHERE
               /*POSTING_DATE_KEY BETWEEN 自然年第一天 AND 上个月最后一天*/
                A.POSTING_DATE_KEY BETWEEN
                TO_NUMBER(TO_CHAR(TRUNC(TO_DATE(POSDAY, 'YYYYMMDD'), 'YEAR'),
                                  'YYYYMMDD')) AND
                TO_NUMBER(TO_CHAR(TRUNC(TO_DATE(POSDAY, 'YYYYMMDD'), 'MONTH') - 1,
                                  'YYYYMMDD'))
             AND A.ORDER_STATE = 1
             AND A.AMOUNT_PAID >= 299 /*单笔满299*/
             AND A.SALES_SOURCE_SECOND_KEY IN
                (20022, 20021, 20020, 20018, 20017)
                GROUP BY A.MEMBER_KEY, SUBSTR(A.POSTING_DATE_KEY, 1, 4)
               /*有效订购大于12次,金额>=199,毛利总金额>=100*/
               HAVING COUNT(A.ORDER_KEY) >= 12 AND SUM(A.PROFIT_AMOUNT) >= 800
               --4.单笔满399,毛利额>=800,level2
               UNION ALL
               SELECT A.MEMBER_KEY,
                       SUBSTR(A.POSTING_DATE_KEY, 1, 4) YEAR_KEY,
                       COUNT(A.ORDER_KEY) ORDER_COUNT,
                       SUM(A.AMOUNT_PAID) TOTAL_AMOUNT_PAID,
                       SUM(A.PROFIT_AMOUNT) PROFIT_AMOUNT,
                       2 AMOUNT_LEVEL
                 FROM FACT_ORDER@DW_DATALINK A
                WHERE
               /*POSTING_DATE_KEY BETWEEN 自然年第一天 AND 上个月最后一天*/
                A.POSTING_DATE_KEY BETWEEN
                TO_NUMBER(TO_CHAR(TRUNC(TO_DATE(POSDAY, 'YYYYMMDD'), 'YEAR'),
                                  'YYYYMMDD')) AND
                TO_NUMBER(TO_CHAR(TRUNC(TO_DATE(POSDAY, 'YYYYMMDD'), 'MONTH') - 1,
                                  'YYYYMMDD'))
             AND A.ORDER_STATE = 1
             AND A.AMOUNT_PAID >= 399 /*单笔满399*/
             AND A.SALES_SOURCE_SECOND_KEY IN
                (20022, 20021, 20020, 20018, 20017)
                GROUP BY A.MEMBER_KEY, SUBSTR(A.POSTING_DATE_KEY, 1, 4)
               /*有效订购大于12次,金额>=199,毛利总金额>=100*/
               HAVING COUNT(A.ORDER_KEY) >= 12 AND SUM(A.PROFIT_AMOUNT) >= 600
               --5.单笔满399,毛利额>=1500,level3
               UNION ALL
               SELECT A.MEMBER_KEY,
                       SUBSTR(A.POSTING_DATE_KEY, 1, 4) YEAR_KEY,
                       COUNT(A.ORDER_KEY) ORDER_COUNT,
                       SUM(A.AMOUNT_PAID) TOTAL_AMOUNT_PAID,
                       SUM(A.PROFIT_AMOUNT) PROFIT_AMOUNT,
                       3 AMOUNT_LEVEL
                 FROM FACT_ORDER@DW_DATALINK A
                WHERE
               /*POSTING_DATE_KEY BETWEEN 自然年第一天 AND 上个月最后一天*/
                A.POSTING_DATE_KEY BETWEEN
                TO_NUMBER(TO_CHAR(TRUNC(TO_DATE(POSDAY, 'YYYYMMDD'), 'YEAR'),
                                  'YYYYMMDD')) AND
                TO_NUMBER(TO_CHAR(TRUNC(TO_DATE(POSDAY, 'YYYYMMDD'), 'MONTH') - 1,
                                  'YYYYMMDD'))
             AND A.ORDER_STATE = 1
             AND A.AMOUNT_PAID >= 399 /*单笔满399*/
             AND A.SALES_SOURCE_SECOND_KEY IN
                (20022, 20021, 20020, 20018, 20017)
                GROUP BY A.MEMBER_KEY, SUBSTR(A.POSTING_DATE_KEY, 1, 4)
               /*有效订购大于12次,金额>=199,毛利总金额>=100*/
               HAVING COUNT(A.ORDER_KEY) >= 12 AND SUM(A.PROFIT_AMOUNT) >= 1500) B
       WHERE NOT EXISTS (SELECT 1
                FROM OPER_MBR_TWELVE_ORDER_YEAR C
               WHERE B.MEMBER_KEY = C.MEMBER_KEY
                 AND B.YEAR_KEY = C.YEAR_KEY) /*已插入的member_key不再插入*/
       GROUP BY B.MEMBER_KEY, B.YEAR_KEY;
  
    INSERT_ROWS := SQL%ROWCOUNT;
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ERR_MSG        := '输入参数:POSDAY:' || TO_CHAR(POSDAY);
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

