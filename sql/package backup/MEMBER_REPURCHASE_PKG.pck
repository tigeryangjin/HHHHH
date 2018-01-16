CREATE OR REPLACE PACKAGE MEMBER_REPURCHASE_PKG IS

  -- AUTHOR  : YANGJIN
  -- CREATED : 2017-08-03 
  -- PURPOSE : MEMBER SMS POOL PACKAGE

  PROCEDURE MEMBER_REPURCHASE_TRACT_PROC(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  功能名:       MEMBER_REPURCHASE_TRACT_PROC
  目的:         
  作者:         yangjin
  创建时间：    2017/12/04
  最后修改人：
  最后更改日期：
  */

  PROCEDURE OPER_MEMBER_MBLEVEL_DCGOOD(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  功能名:       OPER_MEMBER_MBLEVEL_DCGOOD
  目的:         1、针对每日新增绑定的会员等级折扣商品，自动匹配出近1月内加车和浏览的纪录，针对此部分会员发送短信；
                2、7日内进行用户剔重，不做重复发送。
                3、短信于隔日9点发送。    DIM_MBLEVEL_DCGOOD
  作者:         yangjin
  创建时间：    2017/07/28
  最后修改人：
  最后更改日期：
  */

  PROCEDURE MEMBER_SMS_POOL_OMMD(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  功能名:       OMMD_INSERT_SMS_POOL
  目的:         OPER_MEMBER_MBLEVEL_DCGOOD-->OPER_MEMBER_SMS_POOL
  作者:         yangjin
  创建时间：    2017/08/03
  最后修改人：
  最后更改日期：
  */

END MEMBER_REPURCHASE_PKG;
/
CREATE OR REPLACE PACKAGE BODY MEMBER_REPURCHASE_PKG IS

  PROCEDURE MEMBER_REPURCHASE_TRACT_PROC(IN_POSTING_DATE_KEY IN NUMBER) IS
    /*
    功能说明：
    作者时间：yangjin  2017-12-04
    */
  BEGIN
    BEGIN
      -- CALL THE PROCEDURE
      MEMBER_SMS_PKG.OPER_MEMBER_MBLEVEL_DCGOOD(IN_POSTING_DATE_KEY);
      MEMBER_SMS_PKG.MEMBER_SMS_POOL_OMMD(IN_POSTING_DATE_KEY);
    END;
  
  END MEMBER_REPURCHASE_TRACT_PROC;

  PROCEDURE OPER_MEMBER_MBLEVEL_DCGOOD(IN_POSTING_DATE_KEY IN NUMBER) IS
    S_ETL           W_ETL_LOG%ROWTYPE;
    SP_NAME         S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER     S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS     NUMBER;
    IN_POSTING_DATE DATE;
    /*
    功能说明：1、针对每日新增绑定的会员等级折扣商品，自动匹配出近1月内加车和浏览的纪录，针对此部分会员发送短信；
              2、7日内进行用户剔重，不做重复发送。
              3、短信于隔日9点发送。    DIM_MBLEVEL_DCGOOD
    作者时间：yangjin  2017-07-28
    */
  BEGIN
  
    SP_NAME          := 'MEMBER_SMS_PKG.OPER_MEMBER_MBLEVEL_DCGOOD'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'OPER_MEMBER_MBLEVEL_DCGOOD'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    IN_POSTING_DATE  := TO_DATE(IN_POSTING_DATE_KEY, 'YYYYMMDD');
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.ERR_MSG := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
      DELETE OPER_MEMBER_MBLEVEL_DCGOOD A
       WHERE A.POST_DATE = IN_POSTING_DATE;
      COMMIT;
    
      INSERT INTO OPER_MEMBER_MBLEVEL_DCGOOD E
        (ROW_WID, POST_DATE, MEMBER_KEY, W_INSERT_DT, W_UPDATE_DT)
        SELECT OPER_MEMBER_MBLEVEL_DCGOOD_SEQ.NEXTVAL,
               H.POST_DATE,
               H.MEMBER_KEY,
               SYSDATE,
               SYSDATE
          FROM (SELECT DISTINCT IN_POSTING_DATE POST_DATE, D.MEMBER_KEY
                  FROM ( /*浏览*/
                        SELECT DISTINCT A.MEMBER_KEY
                          FROM FACT_PAGE_VIEW A
                         WHERE A.VISIT_DATE_KEY BETWEEN
                               TO_CHAR(IN_POSTING_DATE - 30, 'YYYYMMDD') AND
                               TO_CHAR(IN_POSTING_DATE, 'YYYYMMDD') /*最近一个月*/
                           AND A.PAGE_NAME IN ('good', 'Good')
                           AND A.PAGE_VALUE IN
                               (SELECT TO_CHAR(C.GOODS_COMMONID)
                                  FROM DIM_MBLEVEL_DCGOOD C
                                 WHERE TRUNC(C.START_TIME) = IN_POSTING_DATE)
                        UNION ALL
                        /*加车*/
                        SELECT DISTINCT B.MEMBER_KEY
                          FROM FACT_SHOPPINGCAR B
                         WHERE B.CREATE_DATE BETWEEN IN_POSTING_DATE - 30 AND
                               IN_POSTING_DATE /*最近一个月*/
                           AND B.SCGID IN
                               (SELECT C.GOODS_COMMONID
                                  FROM DIM_MBLEVEL_DCGOOD C
                                 WHERE TRUNC(C.START_TIME) = IN_POSTING_DATE)) D
                 WHERE NOT EXISTS /*最近7天没有发送过短信的member_key*/
                 (SELECT 1
                          FROM (SELECT *
                                  FROM OPER_MEMBER_MBLEVEL_DCGOOD F
                                 WHERE F.POST_DATE >= IN_POSTING_DATE - 7) G
                         WHERE D.MEMBER_KEY = G.MEMBER_KEY)) H;
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    END;
  
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '输入参数:IN_POSTING_DATE_KEY:' ||
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
    
  END OPER_MEMBER_MBLEVEL_DCGOOD;

  PROCEDURE MEMBER_SMS_POOL_OMMD(IN_POSTING_DATE_KEY IN NUMBER) IS
    S_ETL           W_ETL_LOG%ROWTYPE;
    SP_NAME         S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER     S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS     NUMBER;
    IN_POSTING_DATE DATE;
    AVG_RECORD      NUMBER; /*平均记录数*/
    LAST_RECORD     NUMBER; /*最近记录数*/
    /*
    功能说明：从OPER_MEMBER_MBLEVEL_DCGOOD表往OPER_MEMBER_SMS_POOL（会员短信池）插入需要发送短信的会员bp号
    作者时间：yangjin  2017-08-03
    */
  BEGIN
  
    SP_NAME          := 'MEMBER_SMS_PKG.MEMBER_SMS_POOL_OMMD'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'OPER_MEMBER_SMS_POOL'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    IN_POSTING_DATE  := TO_DATE(IN_POSTING_DATE_KEY, 'YYYYMMDD');
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.ERR_MSG := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
      /*过去7天平均记录数*/
      SELECT DECODE(COUNT(DISTINCT A.POST_DATE),
                    0,
                    0,
                    COUNT(A.ROW_WID) / COUNT(DISTINCT A.POST_DATE))
        INTO AVG_RECORD
        FROM OPER_MEMBER_MBLEVEL_DCGOOD A
       WHERE A.POST_DATE BETWEEN IN_POSTING_DATE - 8 AND
             IN_POSTING_DATE - 1;
    
      /*最近记录数*/
      SELECT COUNT(A.ROW_WID)
        INTO LAST_RECORD
        FROM OPER_MEMBER_MBLEVEL_DCGOOD A
       WHERE A.POST_DATE = IN_POSTING_DATE;
    
      /*判断最近记录数如果<=7天平均值 或者7天平均值=0*/
      IF LAST_RECORD <= AVG_RECORD * 1.5 OR AVG_RECORD = 0
      THEN
        /*如果最近记录数小于平均记录数1.5倍，则插入*/
        INSERT INTO OPER_MEMBER_SMS_POOL
          (ROW_WID /*唯一代理键*/,
           POSTING_DATE_KEY,
           PROJECT_NAME /*项目名称*/,
           PROJECT_DESC /*项目说明*/,
           MEMBER_KEY,
           W_INSERT_DT /*记录插入时间*/,
           W_UPDATE_DT /*记录修改时间*/,
           IS_SEND)
          SELECT OPER_MEMBER_SMS_POOL_SEQ.NEXTVAL,
                 TO_NUMBER(TO_CHAR(A.POST_DATE, 'YYYYMMDD')) POSTING_DATE_KEY,
                 'MBLEVEL_DCGOOD' PROJECT_NAME,
                 '' PROJECT_DESC,
                 A.MEMBER_KEY,
                 SYSDATE W_INSERT_DT,
                 SYSDATE W_UPDATE_DT,
                 0 IS_SEND
            FROM OPER_MEMBER_MBLEVEL_DCGOOD A
           WHERE A.POST_DATE = IN_POSTING_DATE
                /*剔除已经插入OPER_MEMBER_SMS_POOL表的记录*/
             AND NOT EXISTS
           (SELECT 1
                    FROM OPER_MEMBER_SMS_POOL B
                   WHERE B.POSTING_DATE_KEY = IN_POSTING_DATE_KEY
                     AND A.MEMBER_KEY = B.MEMBER_KEY);
        INSERT_ROWS   := SQL%ROWCOUNT;
        S_ETL.ERR_MSG := TO_CHAR(IN_POSTING_DATE, 'YYYY-MM-DD') || '记录数:' ||
                         TO_CHAR(LAST_RECORD) || '，最近7天平均记录数:' ||
                         TO_CHAR(AVG_RECORD) || '，本次插入记录数:' ||
                         TO_CHAR(INSERT_ROWS);
        COMMIT;
      ELSE
        /*如果最近记录数大于平均记录数1.5倍，则不插入*/
        S_ETL.ERR_MSG := TO_CHAR(IN_POSTING_DATE, 'YYYY-MM-DD') ||
                         '插入的记录数大于过去7天的平均值，不插入会员短信池！' ||
                         TO_CHAR(IN_POSTING_DATE) || '记录数:' ||
                         TO_CHAR(LAST_RECORD) || '，最近7天平均记录数:' ||
                         TO_CHAR(AVG_RECORD);
      END IF;
    END;
  
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '输入参数:IN_POSTING_DATE_KEY:' ||
                            TO_CHAR(IN_POSTING_DATE_KEY) || S_ETL.ERR_MSG;
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
    
  END MEMBER_SMS_POOL_OMMD;

END MEMBER_REPURCHASE_PKG;
/
