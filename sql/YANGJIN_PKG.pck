CREATE OR REPLACE PACKAGE YANGJIN_PKG IS

  -- AUTHOR  : YANGJIN
  -- CREATED : 2017-05-31 10:41:42
  -- PURPOSE : YANGJIN PACKAGE

  FUNCTION IP_INT_TO_STR(IN_IP_INT IN NUMBER) RETURN VARCHAR2;
  /*ip int 转换*/

  FUNCTION GET_IP_CITY(IN_IP_INT IN NUMBER) RETURN VARCHAR2;
  /*返回ip归属城市*/

  PROCEDURE PROCESSMAKETHMSC_IA(STARTPOINT IN NUMBER);
  /*
  功能名:       PROCESSMAKETHMSC_IA
  目的:         在原FACT_HMSC_MARKET表的基础上，细化到商品和地区
  作者:         yangjin
  创建时间：    2017/05/31
  最后修改人：
  最后更改日期：
  */

  PROCEDURE OPER_PRODUCT_DAILY_RPT(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  功能名:       OPER_PRODUCT_DAILY_RPT
  目的:         新媒体中心数据日报
  作者:         yangjin
  创建时间：    2017/06/13
  最后修改人：
  最后更改日期：
  */

  PROCEDURE OPER_PRODUCT_PVUV_DAILY_RPT(IN_VISIT_DATE_KEY IN NUMBER);
  /*
  功能名:       OPER_PRODUCT_PVUV_DAILY_RPT
  目的:         
  作者:         yangjin
  创建时间：    2017/06/29
  最后修改人：
  最后更改日期：
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
    功能说明：在原FACT_HMSC_MARKET表的基础上，细化到商品和地区
    
    作者时间：yangjin  2016-05-24
    */
  BEGIN
    SP_NAME          := 'YANGJIN_PKG.PROCESSMAKETHMSC_IA'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'FACT_HMSC_ITEM_AREA_MARKET'; --此处需要手工录入该PROCEDURE操作的表格
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
  
    BEGIN
      /*清空中间表*/
      DELETE FROM FACT_PV_IA_HMSC;
      DELETE FROM FACT_ORDER_IA_HMSC;
      COMMIT;
    
      /*删除指定日期的数据*/
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
                                  '新用户'
                                 ELSE
                                  '老用户'
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
                          '新用户'
                         ELSE
                          '老用户'
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
    
  END PROCESSMAKETHMSC_IA;

  PROCEDURE OPER_PRODUCT_DAILY_RPT(IN_POSTING_DATE_KEY IN NUMBER) IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    /*
    功能说明：新媒体中心数据日报
    作者时间：yangjin  2016-06-13
    */
  BEGIN
    SP_NAME          := 'YANGJIN_PKG.OPER_PRODUCT_DAILY_RPT'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'OPER_PRODUCT_DAILY_REPORT'; --此处需要手工录入该PROCEDURE操作的表格
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
  
    BEGIN
      /*删除指定日期的数据*/
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
               FO.POSTING_DATE_KEY /*过账日期key*/,
               DS.SALES_SOURCE_NAME /*销售一级组织名称*/,
               DS.SALES_SOURCE_SECOND_NAME /*销售二级组织名称*/,
               DG.OWN_ACCOUNT /*是否自营*/,
               DG.BRAND_NAME /*品牌*/,
               FO.TRAN_TYPE /*交易类型*/,
               FO.TRAN_TYPE_NAME /*交易类型说明*/,
               FO.ITEM_OR_GIFT /*主赠品*/,
               DG.MATDLT /*物料大类*/,
               DG.MATZLT /*物料中类*/,
               DG.MATXLT /*物料小类*/,
               FO.MD_PERSON /*MD工号*/,
               DG.ITEM_CODE /*商品短编码*/,
               FO.GOODS_KEY /*商品长编码*/,
               DG.GOODS_NAME /*商品名称*/,
               FO.TOTAL_ORDER_AMOUNT /*总订购金额*/,
               FO.NET_ORDER_AMOUNT /*净订购金额*/,
               FO.EFFECTIVE_ORDER_AMOUNT /*有效订购金额*/,
               FO.CANCEL_ORDER_AMOUNT /*取消订购金额*/,
               FO.REVERSE_ORDER_AMOUNT /*退货订购金额*/,
               FO.REJECT_ORDER_AMOUNT /*拒收订购金额*/,
               FO.CANCEL_REVERSE_AMOUNT /*退货取消订购金额*/,
               FO.CANCEL_REJECT_AMOUNT /*拒收取消订购金额*/,
               FO.TOTAL_SALES_AMOUNT /*总售价金额*/,
               FO.NET_SALES_AMOUNT /*净售价金额*/,
               FO.EFFECTIVE_SALES_AMOUNT /*有效售价金额*/,
               FO.TOTAL_ORDER_MEMBER_COUNT /*总订购人数*/,
               FO.NET_ORDER_MEMBER_COUNT /*净订购人数*/,
               FO.EFFECTIVE_ORDER_MEMBER_COUNT /*有效订购人数*/,
               FO.CANCEL_ORDER_MEMBER_COUNT /*取消订购人数*/,
               FO.REVERSE_MEMBER_COUNT /*退货订购人数*/,
               FO.REJECT_MEMBER_COUNT /*拒收订购人数*/,
               FO.CANCEL_REVERSE_MEMBER_COUNT /*退货取消订购人数*/,
               FO.CANCEL_REJECT_MEMBER_COUNT /*拒收取消订购人数*/,
               FO.TOTAL_ORDER_COUNT /*总订购单数*/,
               FO.NET_ORDER_COUNT /*净订购单数*/,
               FO.EFFECTIVE_ORDER_COUNT /*有效订购单数*/,
               FO.CANCEL_ORDER_COUNT /*取消订购单数*/,
               FO.REVERSE_COUNT /*退货订购单数*/,
               FO.REJECT_COUNT /*拒收订购单数*/,
               FO.CANCEL_REVERSE_COUNT /*退货取消订购件数*/,
               FO.CANCEL_REJECT_COUNT /*拒收取消订购件数*/,
               FO.GROSS_PROFIT_AMOUNT /*还原后总毛利额*/,
               FO.NET_PROFIT_AMOUNT /*还原后净毛利额*/,
               FO.EFFECTIVE_PROFIT_AMOUNT /*还原后有效毛利额*/,
               FO.GROSS_PROFIT_RATE /*还原后总毛利率*/,
               FO.NET_PROFIT_RATE /*还原后净毛利率*/,
               FO.EFFECTIVE_PROFIT_RATE /*还原后有效毛利率*/,
               FO.TOTAL_ORDER_QTY /*总订购数量*/,
               FO.NET_ORDER_QTY /*净订购数量*/,
               FO.EFFECTIVE_ORDER_QTY /*有效订购数量*/,
               FO.CANCEL_ORDER_QTY /*取消订购数量*/,
               FO.REVERSE_QTY /*退货订购数量*/,
               FO.REJECT_QTY /*拒收订购数量*/,
               FO.CANCEL_REVERSE_QTY /*退货取消订购数量*/,
               FO.CANCEL_REJECT_QTY /*拒收取消订购数量*/,
               FO.NET_ORDER_CUST_PRICE /*净订购客单价*/,
               FO.EFFECTIVE_ORDER_CUST_PRICE /*有效订购客单价*/,
               FO.NET_ORDER_UNIT_PRICE /*净订购件单价*/,
               FO.EFFECTIVE_ORDER_UNIT_PRICE /*有效订购件单价*/,
               FO.TOTAL_PURCHASE_AMOUNT /*总订购成本*/,
               FO.NET_PURCHASE_AMOUNT /*净订购成本*/,
               FO.EFFECTIVE_PURCHASE_AMOUNT /*有效订购成本*/,
               FO.PROFIT_AMOUNT /*折扣金额*/,
               FO.COUPONS_AMOUNT /*优惠券金额*/,
               FO.FREIGHT_AMOUNT /*运费*/,
               FO.PRODUCT_AVG_PRICE /*商品平均售价*/,
               FO.REJECT_AMOUNT /*拒退金额*/,
               FO.LIVE_OR_REPLAY /*直播重播*/
          FROM (SELECT OD2.GOODS_KEY /**/,
                       OD2.GOODS_COMMON_KEY /**/,
                       OD2.SALES_SOURCE_SECOND_KEY /*销售二级组织key*/,
                       OD2.ITEM_OR_GIFT /*主赠品*/,
                       OD2.TRAN_TYPE /*交易类型*/,
                       DECODE(OD2.TRAN_TYPE,
                              'TAN',
                              '主品',
                              'REN',
                              '主品退货') TRAN_TYPE_NAME /*交易类型说明*/,
                       OD2.MD_PERSON /*MD工号*/,
                       OD2.POSTING_DATE_KEY /*过账日期key*/,
                       OD2.LIVE_OR_REPLAY /*是否播出*/,
                       OD2.TOTAL_ORDER_AMOUNT /*总订购金额*/,
                       OD2.NET_ORDER_AMOUNT /*净订购金额*/,
                       OD2.EFFECTIVE_ORDER_AMOUNT /*有效订购金额*/,
                       OD2.CANCEL_ORDER_AMOUNT /*取消订购金额*/,
                       OD2.REVERSE_ORDER_AMOUNT /*退货订购金额*/,
                       OD2.REJECT_ORDER_AMOUNT /*拒收订购金额*/,
                       OD2.CANCEL_REVERSE_AMOUNT /*退货取消订购金额*/,
                       OD2.CANCEL_REJECT_AMOUNT /*拒收取消订购金额*/,
                       OD2.TOTAL_SALES_AMOUNT /*总售价金额*/,
                       OD2.NET_SALES_AMOUNT /*净售价金额*/,
                       OD2.EFFECTIVE_SALES_AMOUNT /*有效售价金额*/,
                       OD2.TOTAL_ORDER_MEMBER_COUNT /*总订购人数*/,
                       OD2.NET_ORDER_MEMBER_COUNT /*净订购人数*/,
                       OD2.EFFECTIVE_ORDER_MEMBER_COUNT /*有效订购人数*/,
                       OD2.CANCEL_ORDER_MEMBER_COUNT /*取消订购人数*/,
                       OD2.REVERSE_MEMBER_COUNT /*退货订购人数*/,
                       OD2.REJECT_MEMBER_COUNT /*拒收订购人数*/,
                       OD2.CANCEL_REVERSE_MEMBER_COUNT /*退货取消订购人数*/,
                       OD2.CANCEL_REJECT_MEMBER_COUNT /*拒收取消订购人数*/,
                       OD2.TOTAL_ORDER_COUNT /*总订购单数*/,
                       OD2.NET_ORDER_COUNT /*净订购单数*/,
                       OD2.EFFECTIVE_ORDER_COUNT /*有效订购单数*/,
                       OD2.CANCEL_ORDER_COUNT /*取消订购单数*/,
                       OD2.REVERSE_COUNT /*退货订购单数*/,
                       OD2.REJECT_COUNT /*拒收订购单数*/,
                       OD2.CANCEL_REVERSE_COUNT /*退货取消订购件数*/,
                       OD2.CANCEL_REJECT_COUNT /*拒收取消订购件数*/,
                       OD2.TOTAL_ORDER_AMOUNT + OD2.PROFIT_AMOUNT -
                       OD2.TOTAL_PURCHASE_AMOUNT GROSS_PROFIT_AMOUNT /*还原后总毛利额*/,
                       OD2.NET_ORDER_AMOUNT + OD2.PROFIT_AMOUNT -
                       OD2.NET_PURCHASE_AMOUNT NET_PROFIT_AMOUNT /*还原后净毛利额*/,
                       OD2.EFFECTIVE_ORDER_AMOUNT + OD2.PROFIT_AMOUNT -
                       OD2.EFFECTIVE_PURCHASE_AMOUNT EFFECTIVE_PROFIT_AMOUNT /*还原后有效毛利额*/,
                       DECODE(OD2.TOTAL_ORDER_AMOUNT,
                              0,
                              0,
                              (OD2.TOTAL_ORDER_AMOUNT + OD2.PROFIT_AMOUNT -
                              OD2.TOTAL_PURCHASE_AMOUNT) /
                              OD2.TOTAL_ORDER_AMOUNT) GROSS_PROFIT_RATE /*还原后总毛利率*/,
                       DECODE(OD2.NET_ORDER_AMOUNT,
                              0,
                              0,
                              (OD2.NET_ORDER_AMOUNT + OD2.PROFIT_AMOUNT -
                              OD2.NET_PURCHASE_AMOUNT) / OD2.NET_ORDER_AMOUNT) NET_PROFIT_RATE /*还原后净毛利率*/,
                       DECODE(OD2.EFFECTIVE_ORDER_AMOUNT,
                              0,
                              0,
                              (OD2.EFFECTIVE_ORDER_AMOUNT + OD2.PROFIT_AMOUNT -
                              OD2.EFFECTIVE_PURCHASE_AMOUNT) /
                              OD2.EFFECTIVE_ORDER_AMOUNT) EFFECTIVE_PROFIT_RATE /*还原后有效毛利率*/,
                       OD2.TOTAL_ORDER_QTY /*总订购数量*/,
                       OD2.NET_ORDER_QTY /*净订购数量*/,
                       OD2.EFFECTIVE_ORDER_QTY /*有效订购数量*/,
                       OD2.CANCEL_ORDER_QTY /*取消订购数量*/,
                       OD2.REVERSE_QTY /*退货订购数量*/,
                       OD2.REJECT_QTY /*拒收订购数量*/,
                       OD2.CANCEL_REVERSE_QTY /*退货取消订购数量*/,
                       OD2.CANCEL_REJECT_QTY /*拒收取消订购数量*/,
                       OD2.NET_ORDER_CUST_PRICE /*净订购客单价*/,
                       OD2.EFFECTIVE_ORDER_CUST_PRICE /*有效订购客单价*/,
                       OD2.NET_ORDER_UNIT_PRICE /*净订购件单价*/,
                       OD2.EFFECTIVE_ORDER_UNIT_PRICE /*有效订购件单价*/,
                       OD2.TOTAL_PURCHASE_AMOUNT /*总订购成本*/,
                       OD2.NET_PURCHASE_AMOUNT /*净订购成本*/,
                       OD2.EFFECTIVE_PURCHASE_AMOUNT /*有效订购成本*/,
                       OD2.PROFIT_AMOUNT /*折扣金额*/,
                       OD2.COUPONS_AMOUNT /*优惠券金额*/,
                       OD2.FREIGHT_AMOUNT /*运费*/,
                       OD2.PRODUCT_AVG_PRICE /*商品平均售价*/,
                       OD2.REJECT_AMOUNT /*拒退金额*/
                  FROM (SELECT OD1.GOODS_KEY /**/,
                               OD1.GOODS_COMMON_KEY /**/,
                               OD1.SALES_SOURCE_SECOND_KEY /*销售二级组织key*/,
                               DECODE(OD1.TRAN_TYPE, 0, '主品', 1, '赠品') ITEM_OR_GIFT /*主赠品*/,
                               DECODE(OD1.CANCEL_STATE, 0, 'TAN', 1, 'REN') TRAN_TYPE /*交易类型*/,
                               OD1.MD_PERSON /*MD工号*/,
                               OD1.POSTING_DATE_KEY /*过账日期key*/,
                               DECODE(OD1.LIVE_OR_REPLAY,
                                      '10',
                                      '直播',
                                      '01',
                                      '重播',
                                      '未分配') LIVE_OR_REPLAY /*是否播出*/,
                               SUM(DECODE(OD1.CANCEL_STATE,
                                          0,
                                          OD1.TOTAL_ORDER_AMOUNT,
                                          1,
                                          0)) TOTAL_ORDER_AMOUNT /*总订购金额*/,
                               SUM(DECODE(OD1.CANCEL_STATE,
                                          0,
                                          OD1.NET_ORDER_AMOUNT,
                                          1,
                                          -ABS(OD1.NET_ORDER_AMOUNT))) NET_ORDER_AMOUNT /*净订购金额*/,
                               SUM(DECODE(OD1.CANCEL_STATE,
                                          0,
                                          OD1.EFFECTIVE_ORDER_AMOUNT,
                                          1,
                                          -ABS(OD1.EFFECTIVE_ORDER_AMOUNT))) EFFECTIVE_ORDER_AMOUNT /*有效订购金额*/,
                               SUM(DECODE(OD1.CANCEL_STATE,
                                          0,
                                          0,
                                          1,
                                          OD1.TOTAL_ORDER_AMOUNT)) CANCEL_ORDER_AMOUNT /*取消订购金额*/,
                               0 REVERSE_ORDER_AMOUNT /*退货订购金额*/,
                               0 REJECT_ORDER_AMOUNT /*拒收订购金额*/,
                               0 CANCEL_REVERSE_AMOUNT /*退货取消订购金额*/,
                               0 CANCEL_REJECT_AMOUNT /*拒收取消订购金额*/,
                               SUM(DECODE(OD1.CANCEL_STATE,
                                          0,
                                          OD1.TOTAL_SALES_AMOUNT,
                                          1,
                                          0)) TOTAL_SALES_AMOUNT /*总售价金额*/,
                               SUM(DECODE(OD1.CANCEL_STATE,
                                          0,
                                          OD1.NET_SALES_AMOUNT,
                                          1,
                                          -ABS(OD1.NET_SALES_AMOUNT))) NET_SALES_AMOUNT /*净售价金额*/,
                               SUM(DECODE(OD1.CANCEL_STATE,
                                          0,
                                          OD1.EFFECTIVE_SALES_AMOUNT,
                                          1,
                                          -ABS(OD1.EFFECTIVE_SALES_AMOUNT))) EFFECTIVE_SALES_AMOUNT /*有效售价金额*/,
                               DECODE(OD1.CANCEL_STATE,
                                      0,
                                      COUNT(DISTINCT OD1.MEMBER_KEY),
                                      1,
                                      0) TOTAL_ORDER_MEMBER_COUNT /*总订购人数*/,
                               DECODE(OD1.CANCEL_STATE,
                                      0,
                                      COUNT(DISTINCT OD1.MEMBER_KEY),
                                      1,
                                      -COUNT(DISTINCT OD1.MEMBER_KEY)) NET_ORDER_MEMBER_COUNT /*净订购人数*/,
                               DECODE(OD1.CANCEL_STATE,
                                      0,
                                      COUNT(DISTINCT OD1.MEMBER_KEY),
                                      1,
                                      -COUNT(DISTINCT OD1.MEMBER_KEY)) EFFECTIVE_ORDER_MEMBER_COUNT /*有效订购人数*/,
                               DECODE(OD1.CANCEL_STATE,
                                      0,
                                      0,
                                      1,
                                      COUNT(DISTINCT OD1.MEMBER_KEY)) CANCEL_ORDER_MEMBER_COUNT /*取消订购人数*/,
                               0 REVERSE_MEMBER_COUNT /*退货订购人数*/,
                               0 REJECT_MEMBER_COUNT /*拒收订购人数*/,
                               0 CANCEL_REVERSE_MEMBER_COUNT /*退货取消订购人数*/,
                               0 CANCEL_REJECT_MEMBER_COUNT /*拒收取消订购人数*/,
                               DECODE(OD1.CANCEL_STATE,
                                      0,
                                      COUNT(DISTINCT OD1.ORDER_H_KEY),
                                      1,
                                      0) TOTAL_ORDER_COUNT /*总订购单数*/,
                               DECODE(OD1.CANCEL_STATE,
                                      0,
                                      COUNT(DISTINCT OD1.ORDER_H_KEY),
                                      1,
                                      -COUNT(DISTINCT OD1.ORDER_H_KEY)) NET_ORDER_COUNT /*净订购单数*/,
                               DECODE(OD1.CANCEL_STATE,
                                      0,
                                      COUNT(DISTINCT OD1.ORDER_H_KEY),
                                      1,
                                      -COUNT(DISTINCT OD1.ORDER_H_KEY)) EFFECTIVE_ORDER_COUNT /*有效订购单数*/,
                               DECODE(OD1.CANCEL_STATE,
                                      0,
                                      0,
                                      1,
                                      COUNT(DISTINCT OD1.ORDER_H_KEY)) CANCEL_ORDER_COUNT /*取消订购单数*/,
                               0 REVERSE_COUNT /*退货订购单数*/,
                               0 REJECT_COUNT /*拒收订购单数*/,
                               0 CANCEL_REVERSE_COUNT /*退货取消订购件数*/,
                               0 CANCEL_REJECT_COUNT /*拒收取消订购件数*/,
                               SUM(DECODE(OD1.CANCEL_STATE,
                                          0,
                                          OD1.TOTAL_ORDER_QTY,
                                          1,
                                          0)) TOTAL_ORDER_QTY /*总订购数量*/,
                               SUM(DECODE(OD1.CANCEL_STATE,
                                          0,
                                          OD1.NET_ORDER_QTY,
                                          1,
                                          -ABS(OD1.NET_ORDER_QTY))) NET_ORDER_QTY /*净订购数量*/,
                               SUM(DECODE(OD1.CANCEL_STATE,
                                          0,
                                          OD1.EFFECTIVE_ORDER_QTY,
                                          1,
                                          -ABS(OD1.EFFECTIVE_ORDER_QTY))) EFFECTIVE_ORDER_QTY /*有效订购数量*/,
                               DECODE(OD1.CANCEL_STATE,
                                      0,
                                      0,
                                      1,
                                      COUNT(DISTINCT OD1.TOTAL_ORDER_QTY)) CANCEL_ORDER_QTY /*取消订购数量*/,
                               0 REVERSE_QTY /*退货订购数量*/,
                               0 REJECT_QTY /*拒收订购数量*/,
                               0 CANCEL_REVERSE_QTY /*退货取消订购数量*/,
                               0 CANCEL_REJECT_QTY /*拒收取消订购数量*/,
                               SUM(OD1.NET_ORDER_AMOUNT) /
                               COUNT(DISTINCT OD1.MEMBER_KEY) NET_ORDER_CUST_PRICE /*净订购客单价*/,
                               SUM(OD1.EFFECTIVE_ORDER_AMOUNT) /
                               COUNT(DISTINCT OD1.MEMBER_KEY) EFFECTIVE_ORDER_CUST_PRICE /*有效订购客单价*/,
                               SUM(OD1.NET_ORDER_AMOUNT) /
                               SUM(OD1.NET_ORDER_QTY) NET_ORDER_UNIT_PRICE /*净订购件单价*/,
                               SUM(OD1.EFFECTIVE_ORDER_AMOUNT) /
                               SUM(OD1.EFFECTIVE_ORDER_QTY) EFFECTIVE_ORDER_UNIT_PRICE /*有效订购件单价*/,
                               SUM(DECODE(OD1.CANCEL_STATE,
                                          0,
                                          OD1.TOTAL_PURCHASE_AMOUNT,
                                          1,
                                          0)) TOTAL_PURCHASE_AMOUNT /*总订购成本*/,
                               SUM(DECODE(OD1.CANCEL_STATE,
                                          0,
                                          OD1.NET_PURCHASE_AMOUNT,
                                          1,
                                          -ABS(OD1.NET_PURCHASE_AMOUNT))) NET_PURCHASE_AMOUNT /*净订购成本*/,
                               SUM(DECODE(OD1.CANCEL_STATE,
                                          0,
                                          OD1.EFFECTIVE_PURCHASE_AMOUNT,
                                          1,
                                          -ABS(OD1.NET_PURCHASE_AMOUNT))) EFFECTIVE_PURCHASE_AMOUNT /*有效订购成本*/,
                               SUM(DECODE(OD1.CANCEL_STATE,
                                          0,
                                          OD1.PROFIT_AMOUNT,
                                          1,
                                          -ABS(OD1.PROFIT_AMOUNT))) PROFIT_AMOUNT /*折扣金额*/,
                               SUM(OD1.COUPONS_AMOUNT) COUPONS_AMOUNT /*优惠券金额*/,
                               SUM(OD1.FREIGHT_AMOUNT) FREIGHT_AMOUNT /*运费*/,
                               SUM(OD1.TOTAL_SALES_AMOUNT) /
                               SUM(OD1.TOTAL_ORDER_QTY) PRODUCT_AVG_PRICE /*商品平均售价*/,
                               0 REJECT_AMOUNT /*拒退金额*/
                          FROM (SELECT OD.ORDER_KEY /*订单权责制*/,
                                       OD.ORDER_H_KEY /*订单发生制*/,
                                       OD.ORDER_DESC /*订购状态*/,
                                       OD.GOODS_KEY /*商品*/,
                                       OD.GOODS_COMMON_KEY /*商品短编码*/,
                                       OD.SALES_SOURCE_SECOND_KEY /*销售二级组织key*/,
                                       OD.TRAN_TYPE /*是否赠品标志*/,
                                       OD.TRAN_DESC /*交易类型*/,
                                       OD.MD_PERSON /*MD工号*/,
                                       OD.POSTING_DATE_KEY /*过账日期key*/,
                                       TO_CHAR(OD.LIVE_STATE) ||
                                       TO_CHAR(OD.REPLAY_STATE) LIVE_OR_REPLAY /*直播重播*/,
                                       OD.ORDER_STATE /*订单状态*/,
                                       OD.CANCEL_STATE /*取消状态*/,
                                       OD.MEMBER_KEY /*会员key*/,
                                       OD.NUMS TOTAL_ORDER_QTY /*总订购数量*/,
                                       OD.NUMS NET_ORDER_QTY /*净订购数量*/,
                                       OD.NUMS EFFECTIVE_ORDER_QTY /*有效订购数量*/,
                                       OD.ORDER_AMOUNT TOTAL_ORDER_AMOUNT /*总订单金额*/,
                                       OD.ORDER_AMOUNT NET_ORDER_AMOUNT /*净订购金额*/,
                                       OD.ORDER_AMOUNT EFFECTIVE_ORDER_AMOUNT /*有效订购金额*/,
                                       OD.SALES_AMOUNT TOTAL_SALES_AMOUNT /*总售价金额*/,
                                       OD.SALES_AMOUNT NET_SALES_AMOUNT /*净订购金额*/,
                                       OD.SALES_AMOUNT EFFECTIVE_SALES_AMOUNT /*有效订购金额*/,
                                       OD.UNIT_PRICE /*单个商品售价*/,
                                       OD.COST_PRICE /*商品单件成本*/,
                                       OD.FREIGHT_AMOUNT /*运费*/,
                                       OD.COUPONS_PRICE COUPONS_AMOUNT /*优惠券金额*/,
                                       OD.PURCHASE_AMOUNT TOTAL_PURCHASE_AMOUNT /*总订购成本*/,
                                       OD.PURCHASE_AMOUNT NET_PURCHASE_AMOUNT /*净订购成本*/,
                                       OD.PURCHASE_AMOUNT EFFECTIVE_PURCHASE_AMOUNT /*有效订购成本*/,
                                       OD.PROFIT_AMOUNT /*折扣金额*/
                                  FROM (
                                        /*取消的订单，按过账日期POSTING_DATE_KEY记正向订单。
                                        2017-06-14 yangjin*/
                                        SELECT ODU1.ORDER_KEY /*订单权责制*/,
                                                ODU1.ORDER_H_KEY /*订单发生制*/,
                                                ODU1.ORDER_DESC /*订购状态*/,
                                                ODU1.GOODS_KEY /*商品*/,
                                                ODU1.GOODS_COMMON_KEY /*商品短编码*/,
                                                ODU1.SALES_SOURCE_SECOND_KEY /*销售二级组织key*/,
                                                ODU1.TRAN_TYPE /*是否赠品标志*/,
                                                ODU1.TRAN_DESC /*交易类型*/,
                                                ODU1.MD_PERSON /*MD工号*/,
                                                ODU1.POSTING_DATE_KEY /*过账日期key*/,
                                                ODU1.LIVE_STATE /*是否直播*/,
                                                ODU1.REPLAY_STATE /*是否重播*/,
                                                ODU1.ORDER_STATE /*订单状态*/,
                                                CASE
                                                  WHEN ODU1.CANCEL_STATE = 1 AND
                                                       ODU1.POSTING_DATE_KEY <=
                                                       ODU1.UPDATE_TIME THEN
                                                   0
                                                  ELSE
                                                   ODU1.CANCEL_STATE
                                                END CANCEL_STATE /*取消状态*/,
                                                ODU1.MEMBER_KEY /*会员key*/,
                                                ODU1.NUMS,
                                                ODU1.ORDER_AMOUNT,
                                                ODU1.SALES_AMOUNT,
                                                ODU1.UNIT_PRICE /*单个商品售价*/,
                                                ODU1.COST_PRICE /*商品单件成本*/,
                                                ODU1.FREIGHT_AMOUNT /*运费*/,
                                                ODU1.COUPONS_PRICE /*优惠券金额*/,
                                                ODU1.PURCHASE_AMOUNT,
                                                ODU1.PROFIT_AMOUNT /*折扣金额*/
                                          FROM FACT_GOODS_SALES ODU1
                                        UNION ALL
                                        /*取消的订单，按更新日期UPDATE_TIME记逆向订单（虚拟记录）。
                                        2017-06-14 yangjin*/
                                        SELECT ODU2.ORDER_KEY /*订单权责制*/,
                                                ODU2.ORDER_H_KEY /*订单发生制*/,
                                                ODU2.ORDER_DESC /*订购状态*/,
                                                ODU2.GOODS_KEY /*商品*/,
                                                ODU2.GOODS_COMMON_KEY /*商品短编码*/,
                                                ODU2.SALES_SOURCE_SECOND_KEY /*销售二级组织key*/,
                                                ODU2.TRAN_TYPE /*是否赠品标志*/,
                                                ODU2.TRAN_DESC /*交易类型*/,
                                                ODU2.MD_PERSON /*MD工号*/,
                                                ODU2.UPDATE_TIME POSTING_DATE_KEY /*过账日期key*/,
                                                ODU2.LIVE_STATE /*是否直播*/,
                                                ODU2.REPLAY_STATE /*是否重播*/,
                                                ODU2.ORDER_STATE /*订单状态*/,
                                                ODU2.CANCEL_STATE /*取消状态*/,
                                                ODU2.MEMBER_KEY /*会员key*/,
                                                ODU2.NUMS,
                                                ODU2.ORDER_AMOUNT,
                                                ODU2.SALES_AMOUNT,
                                                ODU2.UNIT_PRICE /*单个商品售价*/,
                                                ODU2.COST_PRICE /*商品单件成本*/,
                                                ODU2.FREIGHT_AMOUNT /*运费*/,
                                                ODU2.COUPONS_PRICE /*优惠券金额*/,
                                                ODU2.PURCHASE_AMOUNT,
                                                ODU2.PROFIT_AMOUNT /*折扣金额*/
                                          FROM FACT_GOODS_SALES ODU2
                                         WHERE ODU2.CANCEL_STATE = 1
                                           AND ODU2.CANCEL_BEFORE_STATE = 1 /*发货前取消的订单才虚拟出记录*/
                                           AND ODU2.POSTING_DATE_KEY <=
                                               ODU2.UPDATE_TIME
                                        
                                        ) OD
                                 WHERE OD.POSTING_DATE_KEY =
                                       IN_POSTING_DATE_KEY
                                   AND OD.TRAN_TYPE = 0 /*只显示主品*/
                                ) OD1
                         GROUP BY OD1.GOODS_KEY,
                                  OD1.GOODS_COMMON_KEY,
                                  OD1.SALES_SOURCE_SECOND_KEY,
                                  DECODE(OD1.TRAN_TYPE, 0, '主品', 1, '赠品'),
                                  DECODE(OD1.CANCEL_STATE, 0, 'TAN', 1, 'REN'),
                                  OD1.MD_PERSON,
                                  OD1.POSTING_DATE_KEY,
                                  DECODE(OD1.LIVE_OR_REPLAY,
                                         '10',
                                         '直播',
                                         '01',
                                         '重播',
                                         '未分配'),
                                  OD1.CANCEL_STATE) OD2
                UNION ALL
                --*************************************************************************************
                --REVERSE
                --*************************************************************************************
                SELECT RD2.GOODS_KEY,
                       RD2.GOODS_COMMON_KEY,
                       RD2.SALES_SOURCE_SECOND_KEY /*销售二级组织key*/,
                       '主品' ITEM_OR_GIFT /*主赠品*/,
                       RD2.TRAN_TYPE /*交易类型*/,
                       DECODE(RD2.TRAN_TYPE,
                              'TAN',
                              '主品',
                              'REN',
                              '主品退货') TRAN_TYPE_NAME /*交易类型说明*/,
                       RD2.MD_PERSON /*MD员工号*/,
                       RD2.POSTING_DATE_KEY /*过账日期*/,
                       RD2.LIVE_OR_REPLAY /*直重播*/,
                       RD2.TOTAL_ORDER_AMOUNT /*总订购金额*/,
                       RD2.NET_ORDER_AMOUNT /*净订购金额*/,
                       -RD2.REVERSE_ORDER_AMOUNT - RD2.REJECT_ORDER_AMOUNT +
                       RD2.CANCEL_REVERSE_AMOUNT + RD2.CANCEL_REJECT_AMOUNT EFFECTIVE_ORDER_AMOUNT /*有效订购金额= -退货订购金额-拒收订购金额+退货取消订购金额+拒收取消订购金额*/,
                       RD2.CANCEL_ORDER_AMOUNT /*取消订购金额*/,
                       RD2.REVERSE_ORDER_AMOUNT /*退货订购金额*/,
                       RD2.REJECT_ORDER_AMOUNT /*拒收订购金额*/,
                       RD2.CANCEL_REVERSE_AMOUNT /*退货取消订购金额*/,
                       RD2.CANCEL_REJECT_AMOUNT /*拒收取消订购金额*/,
                       RD2.TOTAL_SALES_AMOUNT /*总售价金额*/,
                       RD2.NET_SALES_AMOUNT /*净售价金额*/,
                       -RD2.REVERSE_SALES_AMOUNT - RD2.REJECT_SALES_AMOUNT +
                       RD2.CANCEL_REVERSE_SALES_AMOUNT +
                       RD2.CANCEL_REJECT_SALES_AMOUNT EFFECTIVE_SALES_AMOUNT /*有效售价金额= -退货售价金额-拒收售价金额+退货取消售价金额+拒收取消售价金额*/,
                       RD2.TOTAL_ORDER_MEMBER_COUNT /*总订购人数*/,
                       RD2.NET_ORDER_MEMBER_COUNT /*净订购人数*/,
                       -RD2.REVERSE_MEMBER_COUNT - RD2.REJECT_MEMBER_COUNT +
                       RD2.CANCEL_REVERSE_MEMBER_COUNT +
                       RD2.CANCEL_REJECT_MEMBER_COUNT EFFECTIVE_ORDER_MEMBER_COUNT /*有效订购人数=-退货订购人数-拒收订购人数+退货取消订购人数+拒收取消订购人数*/,
                       RD2.CANCEL_ORDER_MEMBER_COUNT /*取消订购人数*/,
                       RD2.REVERSE_MEMBER_COUNT /*退货订购人数*/,
                       RD2.REJECT_MEMBER_COUNT /*拒收订购人数*/,
                       RD2.CANCEL_REVERSE_MEMBER_COUNT /*退货取消订购人数*/,
                       RD2.CANCEL_REJECT_MEMBER_COUNT /*拒收取消订购人数*/,
                       RD2.TOTAL_ORDER_COUNT /*总订购单数*/,
                       RD2.NET_ORDER_COUNT /*净订购单数*/,
                       -RD2.REVERSE_COUNT - RD2.REJECT_COUNT +
                       RD2.CANCEL_REVERSE_COUNT + RD2.CANCEL_REJECT_COUNT EFFECTIVE_ORDER_COUNT /*有效订购单数*/,
                       RD2.CANCEL_ORDER_COUNT /*取消订购单数*/,
                       RD2.REVERSE_COUNT /*退货订购单数*/,
                       RD2.REJECT_COUNT /*拒收订购单数*/,
                       RD2.CANCEL_REVERSE_COUNT /*退货取消订购单数*/,
                       RD2.CANCEL_REJECT_COUNT /*拒收取消订购单数*/,
                       RD2.GROSS_PROFIT_AMOUNT /*还原后总毛利额*/,
                       RD2.NET_PROFIT_AMOUNT /*还原后净毛利额*/,
                       (-RD2.REVERSE_SALES_AMOUNT - RD2.REJECT_SALES_AMOUNT +
                       RD2.CANCEL_REVERSE_SALES_AMOUNT +
                       RD2.CANCEL_REJECT_SALES_AMOUNT) -
                       (-RD2.REVERSE_PURCHASE_AMOUNT -
                       RD2.REJECT_PURCHASE_AMOUNT +
                       RD2.CANCEL_REVERSE_PURCHASE_AMOUNT +
                       RD2.CANCEL_REJECT_PURCHASE_AMOUNT) EFFECTIVE_PROFIT_AMOUNT /*还原后有效毛利额*/,
                       RD2.GROSS_PROFIT_RATE /*还原后总毛利率*/,
                       RD2.NET_PROFIT_RATE /*还原后净毛利率*/,
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
                              RD2.CANCEL_REJECT_AMOUNT)) EFFECTIVE_PROFIT_RATE /*还原后有效毛利率*/,
                       RD2.TOTAL_ORDER_QTY /*总订购数量*/,
                       RD2.NET_ORDER_QTY /*净订购数量*/,
                       -RD2.REVERSE_QTY - RD2.REJECT_QTY +
                       RD2.CANCEL_REVERSE_QTY + RD2.CANCEL_REJECT_QTY EFFECTIVE_ORDER_QTY /*有效订购数量= -退货订购数量-拒收订购数量+退货取消订购数量+拒收取消订购数量*/,
                       RD2.CANCEL_ORDER_QTY /*取消订购数量*/,
                       RD2.REVERSE_QTY /*退货订购数量*/,
                       RD2.REJECT_QTY /*拒收订购数量*/,
                       RD2.CANCEL_REVERSE_QTY /*退货取消订购数量*/,
                       RD2.CANCEL_REJECT_QTY /*拒收取消订购数量*/,
                       RD2.NET_ORDER_CUST_PRICE /*净订购客单价*/,
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
                              RD2.CANCEL_REJECT_MEMBER_COUNT)) EFFECTIVE_ORDER_CUST_PRICE /*有效订购客单价*/,
                       RD2.NET_ORDER_UNIT_PRICE /*净订购件单价*/,
                       DECODE(-RD2.REVERSE_QTY - RD2.REJECT_QTY +
                              RD2.CANCEL_REVERSE_QTY + RD2.CANCEL_REJECT_QTY,
                              0,
                              0,
                              (-RD2.REVERSE_ORDER_AMOUNT -
                              RD2.REJECT_ORDER_AMOUNT +
                              RD2.CANCEL_REVERSE_AMOUNT +
                              RD2.CANCEL_REJECT_AMOUNT) /
                              (-RD2.REVERSE_QTY - RD2.REJECT_QTY +
                              RD2.CANCEL_REVERSE_QTY + RD2.CANCEL_REJECT_QTY)) EFFECTIVE_ORDER_UNIT_PRICE /*有效订购件单价*/,
                       0 TOTAL_PURCHASE_AMOUNT /*总订购成本*/,
                       0 NET_PURCHASE_AMOUNT /*净订购成本*/,
                       -RD2.REVERSE_PURCHASE_AMOUNT -
                       RD2.REJECT_PURCHASE_AMOUNT +
                       RD2.CANCEL_REVERSE_PURCHASE_AMOUNT +
                       RD2.CANCEL_REJECT_PURCHASE_AMOUNT EFFECTIVE_PURCHASE_AMOUNT /*有效订购成本=-退货订购成本-拒收订购成本+退货取消订购成本+拒收取消订购成本*/,
                       RD2.PROFIT_AMOUNT PROFIT_AMOUNT /*折扣金额*/,
                       RD2.COUPONS_AMOUNT COUPONS_AMOUNT /*优惠券金额*/,
                       RD2.FREIGHT_AMOUNT FREIGHT_AMOUNT /*运费*/,
                       0 PRODUCT_AVG_PRICE /*商品平均售价*/,
                       - (-RD2.REVERSE_ORDER_AMOUNT - RD2.REJECT_ORDER_AMOUNT +
                         RD2.CANCEL_REVERSE_AMOUNT +
                         RD2.CANCEL_REJECT_AMOUNT) REJECT_AMOUNT /*拒退金额*/
                  FROM (SELECT RD1.GOODS_KEY,
                               RD1.GOODS_COMMON_KEY,
                               RD1.SALES_SOURCE_SECOND_KEY /*销售二级组织key*/,
                               RD1.TRAN_DESC TRAN_TYPE /*交易类型*/,
                               RD1.MD_PERSON /*MD员工号*/,
                               RD1.POSTING_DATE_KEY /*过账日期*/,
                               DECODE(RD1.LIVE_OR_REPLAY,
                                      '10',
                                      '直播',
                                      '01',
                                      '重播',
                                      '未分配') LIVE_OR_REPLAY,
                               0 TOTAL_ORDER_AMOUNT /*总订购金额*/,
                               0 NET_ORDER_AMOUNT /*净订购金额*/,
                               0 CANCEL_ORDER_AMOUNT /*取消订购金额*/,
                               SUM(DECODE(RD1.CANCEL_STATE,
                                          0,
                                          DECODE(RD1.CANCEL_REASON,
                                                 10,
                                                 RD1.ORDER_AMOUNT,
                                                 30,
                                                 RD1.ORDER_AMOUNT,
                                                 20,
                                                 0),
                                          0)) REVERSE_ORDER_AMOUNT /*退货订购金额*/,
                               SUM(DECODE(RD1.CANCEL_STATE,
                                          0,
                                          DECODE(RD1.CANCEL_REASON,
                                                 20,
                                                 RD1.ORDER_AMOUNT,
                                                 0),
                                          0)) REJECT_ORDER_AMOUNT /*拒收订购金额*/,
                               SUM(DECODE(RD1.CANCEL_STATE,
                                          1,
                                          DECODE(RD1.CANCEL_REASON,
                                                 10,
                                                 RD1.ORDER_AMOUNT,
                                                 30,
                                                 RD1.ORDER_AMOUNT,
                                                 20,
                                                 0),
                                          0)) CANCEL_REVERSE_AMOUNT /*退货取消订购金额*/,
                               SUM(DECODE(RD1.CANCEL_STATE,
                                          1,
                                          DECODE(RD1.CANCEL_REASON,
                                                 20,
                                                 RD1.ORDER_AMOUNT,
                                                 0),
                                          0)) CANCEL_REJECT_AMOUNT /*拒收取消订购金额*/,
                               0 TOTAL_SALES_AMOUNT /*总售价金额*/,
                               0 NET_SALES_AMOUNT /*净售价金额*/,
                               SUM(DECODE(RD1.CANCEL_STATE,
                                          0,
                                          DECODE(RD1.CANCEL_REASON,
                                                 10,
                                                 RD1.SALES_AMOUNT,
                                                 30,
                                                 RD1.SALES_AMOUNT,
                                                 20,
                                                 0),
                                          0)) REVERSE_SALES_AMOUNT /*退货售价金额*/,
                               SUM(DECODE(RD1.CANCEL_STATE,
                                          0,
                                          DECODE(RD1.CANCEL_REASON,
                                                 20,
                                                 RD1.SALES_AMOUNT,
                                                 0),
                                          0)) REJECT_SALES_AMOUNT /*拒收售价金额*/,
                               SUM(DECODE(RD1.CANCEL_STATE,
                                          1,
                                          DECODE(RD1.CANCEL_REASON,
                                                 10,
                                                 RD1.SALES_AMOUNT,
                                                 30,
                                                 RD1.SALES_AMOUNT,
                                                 20,
                                                 0),
                                          0)) CANCEL_REVERSE_SALES_AMOUNT /*退货取消售价金额*/,
                               SUM(DECODE(RD1.CANCEL_STATE,
                                          1,
                                          DECODE(RD1.CANCEL_REASON,
                                                 20,
                                                 RD1.SALES_AMOUNT,
                                                 0),
                                          0)) CANCEL_REJECT_SALES_AMOUNT /*拒收取消售价金额*/,
                               0 TOTAL_ORDER_MEMBER_COUNT /*总订购人数*/,
                               0 NET_ORDER_MEMBER_COUNT /*净订购人数*/,
                               0 CANCEL_ORDER_MEMBER_COUNT /*取消订购人数*/,
                               COUNT(DISTINCT DECODE(RD1.CANCEL_STATE,
                                            0,
                                            DECODE(RD1.CANCEL_REASON,
                                                   10,
                                                   RD1.MEMBER_KEY,
                                                   30,
                                                   RD1.MEMBER_KEY,
                                                   NULL),
                                            0)) REVERSE_MEMBER_COUNT /*退货订购人数*/,
                               COUNT(DISTINCT DECODE(RD1.CANCEL_STATE,
                                            0,
                                            DECODE(RD1.CANCEL_REASON,
                                                   20,
                                                   RD1.MEMBER_KEY,
                                                   NULL),
                                            0)) REJECT_MEMBER_COUNT /*拒收订购人数*/,
                               COUNT(DISTINCT DECODE(RD1.CANCEL_STATE,
                                            1,
                                            DECODE(RD1.CANCEL_REASON,
                                                   10,
                                                   RD1.MEMBER_KEY,
                                                   30,
                                                   RD1.MEMBER_KEY,
                                                   NULL),
                                            0)) CANCEL_REVERSE_MEMBER_COUNT /*退货取消订购人数*/,
                               COUNT(DISTINCT DECODE(RD1.CANCEL_STATE,
                                            1,
                                            DECODE(RD1.CANCEL_REASON,
                                                   20,
                                                   RD1.MEMBER_KEY,
                                                   NULL),
                                            0)) CANCEL_REJECT_MEMBER_COUNT /*拒收取消订购人数*/,
                               0 TOTAL_ORDER_COUNT /*总订购单数*/,
                               0 NET_ORDER_COUNT /*净订购单数*/,
                               0 CANCEL_ORDER_COUNT /*取消订购单数*/,
                               COUNT(DISTINCT DECODE(RD1.CANCEL_STATE,
                                            0,
                                            DECODE(RD1.CANCEL_REASON,
                                                   10,
                                                   RD1.ORDER_H_KEY,
                                                   30,
                                                   RD1.ORDER_H_KEY,
                                                   NULL),
                                            0)) REVERSE_COUNT /*退货订购单数*/,
                               COUNT(DISTINCT DECODE(RD1.CANCEL_STATE,
                                            0,
                                            DECODE(RD1.CANCEL_REASON,
                                                   20,
                                                   RD1.ORDER_H_KEY,
                                                   NULL),
                                            0)) REJECT_COUNT /*拒收订购单数*/,
                               COUNT(DISTINCT DECODE(RD1.CANCEL_STATE,
                                            1,
                                            DECODE(RD1.CANCEL_REASON,
                                                   10,
                                                   RD1.ORDER_H_KEY,
                                                   30,
                                                   RD1.ORDER_H_KEY,
                                                   NULL),
                                            0)) CANCEL_REVERSE_COUNT /*退货取消订购单数*/,
                               COUNT(DISTINCT DECODE(RD1.CANCEL_STATE,
                                            1,
                                            DECODE(RD1.CANCEL_REASON,
                                                   20,
                                                   RD1.ORDER_H_KEY,
                                                   NULL),
                                            0)) CANCEL_REJECT_COUNT /*拒收取消订购单数*/,
                               0 GROSS_PROFIT_AMOUNT /*还原后总毛利额*/,
                               0 NET_PROFIT_AMOUNT /*还原后净毛利额*/,
                               0 GROSS_PROFIT_RATE /*还原后总毛利率*/,
                               0 NET_PROFIT_RATE /*还原后净毛利率*/,
                               0 TOTAL_ORDER_QTY /*总订购数量*/,
                               0 NET_ORDER_QTY /*净订购数量*/,
                               0 CANCEL_ORDER_QTY /*取消订购数量*/,
                               SUM(DECODE(RD1.CANCEL_STATE,
                                          0,
                                          DECODE(RD1.CANCEL_REASON,
                                                 10,
                                                 RD1.NUMS,
                                                 30,
                                                 RD1.NUMS,
                                                 20,
                                                 0),
                                          0)) REVERSE_QTY /*退货订购数量*/,
                               SUM(DECODE(RD1.CANCEL_STATE,
                                          0,
                                          DECODE(RD1.CANCEL_REASON,
                                                 20,
                                                 RD1.NUMS,
                                                 0),
                                          0)) REJECT_QTY /*拒收订购数量*/,
                               SUM(DECODE(RD1.CANCEL_STATE,
                                          1,
                                          DECODE(RD1.CANCEL_REASON,
                                                 10,
                                                 RD1.NUMS,
                                                 30,
                                                 RD1.NUMS,
                                                 20,
                                                 0),
                                          0)) CANCEL_REVERSE_QTY /*退货取消订购数量*/,
                               SUM(DECODE(RD1.CANCEL_STATE,
                                          1,
                                          DECODE(RD1.CANCEL_REASON,
                                                 20,
                                                 RD1.NUMS,
                                                 0),
                                          0)) CANCEL_REJECT_QTY /*拒收取消订购数量*/,
                               0 NET_ORDER_CUST_PRICE /*净订购客单价*/,
                               0 NET_ORDER_UNIT_PRICE /*净订购件单价*/,
                               SUM(DECODE(RD1.CANCEL_STATE,
                                          0,
                                          DECODE(RD1.CANCEL_REASON,
                                                 10,
                                                 RD1.PURCHASE_AMOUNT,
                                                 30,
                                                 RD1.PURCHASE_AMOUNT,
                                                 20,
                                                 0),
                                          0)) REVERSE_PURCHASE_AMOUNT /*退货订购成本*/,
                               SUM(DECODE(RD1.CANCEL_STATE,
                                          0,
                                          DECODE(RD1.CANCEL_REASON,
                                                 20,
                                                 RD1.PURCHASE_AMOUNT,
                                                 0),
                                          0)) REJECT_PURCHASE_AMOUNT /*拒收订购成本*/,
                               SUM(DECODE(RD1.CANCEL_STATE,
                                          1,
                                          DECODE(RD1.CANCEL_REASON,
                                                 10,
                                                 RD1.PURCHASE_AMOUNT,
                                                 30,
                                                 RD1.PURCHASE_AMOUNT,
                                                 20,
                                                 0),
                                          0)) CANCEL_REVERSE_PURCHASE_AMOUNT /*退货取消订购成本*/,
                               SUM(DECODE(RD1.CANCEL_STATE,
                                          1,
                                          DECODE(RD1.CANCEL_REASON,
                                                 20,
                                                 RD1.PURCHASE_AMOUNT,
                                                 0),
                                          0)) CANCEL_REJECT_PURCHASE_AMOUNT /*拒收取消订购成本*/,
                               SUM(RD1.PROFIT_AMOUNT) PROFIT_AMOUNT /*折扣金额*/,
                               SUM(RD1.COUPONS_AMOUNT) COUPONS_AMOUNT /*优惠券金额*/,
                               SUM(RD1.FREIGHT_AMOUNT) FREIGHT_AMOUNT /*运费*/
                          FROM (SELECT RD.ORDER_KEY /*订单权责制*/,
                                       RD.ORDER_H_KEY /*订单发生制*/,
                                       RD.CANCEL_REASON /*退货类型*/,
                                       RD.CANCEL_STATE /*退货状态*/,
                                       RD.GOODS_KEY /*商品*/,
                                       RD.GOODS_COMMON_KEY /*商品短编码*/,
                                       RD.SALES_SOURCE_SECOND_KEY /*销售二级组织key*/,
                                       RD.TRAN_TYPE /*是否赠品标志*/,
                                       RD.TRAN_DESC /*交易类型*/,
                                       RD.MD_PERSON /*MD工号*/,
                                       RD.POSTING_DATE_KEY /*过账日期key*/,
                                       TO_CHAR(RD.LIVE_STATE) ||
                                       TO_CHAR(RD.REPLAY_STATE) LIVE_OR_REPLAY /*直播重播*/,
                                       RD.MEMBER_KEY /*会员key*/,
                                       RD.ORDER_AMOUNT /*退货订购金额*/,
                                       RD.NUMS /*总订购数量*/,
                                       RD.SALES_AMOUNT /*总售价金额*/,
                                       RD.UNIT_PRICE /*单个商品售价*/,
                                       RD.COST_PRICE /*商品单件成本*/,
                                       RD.FREIGHT_AMOUNT /*运费*/,
                                       RD.COUPONS_AMOUNT /*优惠券金额*/,
                                       RD.PURCHASE_AMOUNT /*总订购成本*/,
                                       RD.PROFIT_AMOUNT /*折扣金额*/
                                  FROM (
                                        
                                        /*取消的订单，按过账日期POSTING_DATE_KEY记正向订单。
                                        2017-06-15 yangjin*/
                                        SELECT RDU1.ORDER_KEY /*订单权责制*/,
                                                RDU1.ORDER_H_KEY /*订单发生制*/,
                                                RDU1.CANCEL_REASON /*退货类型*/,
                                                CASE
                                                  WHEN RDU1.CANCEL_STATE = 1 AND
                                                       RDU1.POSTING_DATE_KEY <=
                                                       RDU1.UPDATE_TIME THEN
                                                   0
                                                  ELSE
                                                   RDU1.CANCEL_STATE
                                                END CANCEL_STATE /*退货状态*/,
                                                RDU1.GOODS_KEY /*商品*/,
                                                RDU1.GOODS_COMMON_KEY /*商品短编码*/,
                                                RDU1.SALES_SOURCE_SECOND_KEY /*销售二级组织key*/,
                                                RDU1.TRAN_TYPE /*是否赠品标志*/,
                                                RDU1.TRAN_DESC /*交易类型*/,
                                                RDU1.MD_PERSON /*MD工号*/,
                                                RDU1.POSTING_DATE_KEY /*过账日期key*/,
                                                RDU1.LIVE_STATE /*是否直播*/,
                                                RDU1.REPLAY_STATE /*是否重播*/,
                                                RDU1.MEMBER_KEY /*会员key*/,
                                                RDU1.ORDER_AMOUNT /*退货订购金额*/,
                                                RDU1.NUMS /*总订购数量*/,
                                                RDU1.SALES_AMOUNT /*总售价金额*/,
                                                RDU1.UNIT_PRICE /*单个商品售价*/,
                                                RDU1.COST_PRICE /*商品单件成本*/,
                                                RDU1.FREIGHT_AMOUNT /*运费*/,
                                                RDU1.COUPONS_PRICE COUPONS_AMOUNT /*优惠券金额*/,
                                                RDU1.PURCHASE_AMOUNT /*总订购成本*/,
                                                RDU1.PROFIT_AMOUNT /*折扣金额*/
                                          FROM FACT_GOODS_SALES_REVERSE RDU1
                                         WHERE RDU1.CANCEL_REASON IN
                                               (10, 20, 30)
                                           AND RDU1.TRAN_DESC = 'REN'
                                        UNION ALL
                                        /*取消的订单，按过账日期POSTING_DATE_KEY记逆向订单。
                                        2017-06-15 yangjin*/
                                        SELECT RDU2.ORDER_KEY /*订单权责制*/,
                                                RDU2.ORDER_H_KEY /*订单发生制*/,
                                                RDU2.CANCEL_REASON /*退货类型*/,
                                                RDU2.CANCEL_STATE /*退货状态*/,
                                                RDU2.GOODS_KEY /*商品*/,
                                                RDU2.GOODS_COMMON_KEY /*商品短编码*/,
                                                RDU2.SALES_SOURCE_SECOND_KEY /*销售二级组织key*/,
                                                RDU2.TRAN_TYPE /*是否赠品标志*/,
                                                RDU2.TRAN_DESC /*交易类型*/,
                                                RDU2.MD_PERSON /*MD工号*/,
                                                RDU2.UPDATE_TIME             POSTING_DATE_KEY /*过账日期key*/,
                                                RDU2.LIVE_STATE /*是否直播*/,
                                                RDU2.REPLAY_STATE /*是否重播*/,
                                                RDU2.MEMBER_KEY /*会员key*/,
                                                RDU2.ORDER_AMOUNT /*退货订购金额*/,
                                                RDU2.NUMS /*总订购数量*/,
                                                RDU2.SALES_AMOUNT /*总售价金额*/,
                                                RDU2.UNIT_PRICE /*单个商品售价*/,
                                                RDU2.COST_PRICE /*商品单件成本*/,
                                                RDU2.FREIGHT_AMOUNT /*运费*/,
                                                RDU2.COUPONS_PRICE           COUPONS_AMOUNT /*优惠券金额*/,
                                                RDU2.PURCHASE_AMOUNT /*总订购成本*/,
                                                RDU2.PROFIT_AMOUNT /*折扣金额*/
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
                                         '直播',
                                         '01',
                                         '重播',
                                         '未分配')) RD2) FO,
               (SELECT MAX(DG.BRAND_NAME) BRAND_NAME /*品牌*/,
                       MAX(DG.MATDLT) MATDLT /*物料大类*/,
                       MAX(DG.MATZLT) MATZLT /*物料中类*/,
                       MAX(DG.MATXLT) MATXLT /*物料小类*/,
                       DG.ITEM_CODE /*商品*/,
                       MIN(DG.GOODS_NAME) GOODS_NAME /*商品名称*/,
                       MAX(DECODE(DG.GROUP_ID, 2000, '自营', '非自营')) OWN_ACCOUNT /*是否自营*/
                  FROM DIM_GOOD DG
                 GROUP BY DG.ITEM_CODE) DG,
               (SELECT * FROM DIM_SALES_SOURCE) DS
         WHERE FO.GOODS_COMMON_KEY = DG.ITEM_CODE
           AND FO.SALES_SOURCE_SECOND_KEY = DS.SALES_SOURCE_SECOND_KEY;
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    END;
  
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
    
  END OPER_PRODUCT_DAILY_RPT;

  PROCEDURE OPER_PRODUCT_PVUV_DAILY_RPT(IN_VISIT_DATE_KEY IN NUMBER) IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    /*
    功能说明：
    作者时间：yangjin  2016-06-29
    */
  BEGIN
    SP_NAME          := 'YANGJIN_PKG.OPER_PRODUCT_PVUV_DAILY_RPT'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'OPER_PRODUCT_PVUV_DAILY_REPORT'; --此处需要手工录入该PROCEDURE操作的表格
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
  
    BEGIN
      /*删除指定日期的数据*/
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
    
  END OPER_PRODUCT_PVUV_DAILY_RPT;

END YANGJIN_PKG;
/
