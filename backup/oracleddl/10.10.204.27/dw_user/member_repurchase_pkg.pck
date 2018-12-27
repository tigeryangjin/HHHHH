???CREATE OR REPLACE PACKAGE DW_USER.MEMBER_REPURCHASE_PKG IS

  -- AUTHOR  : YANGJIN
  -- CREATED : 2017-08-03 
  -- PURPOSE : MEMBER SMS POOL PACKAGE

  PROCEDURE MEMBER_REPURCHASE_TRACT_PROC(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  功能名:       MEMBER_REPURCHASE_TRACT_PROC
  目的:         更新会员购买复购商品记录跟踪表
  作者:         yangjin
  创建时间：    2018/01/15
  最后修改人：
  最后更改日期：
  */

  PROCEDURE MEMBER_REPURCHASE_PUSH_PROC(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  功能名:       MEMBER_REPURCHASE_PUSH_PROC
  目的:         根据会员复购记录表记录插入MEMBER_REPURCHASE_PUSH表
  作者:         yangjin
  创建时间：    2018/01/15
  最后修改人：
  最后更改日期：
  */

END MEMBER_REPURCHASE_PKG;
/

CREATE OR REPLACE PACKAGE BODY DW_USER.MEMBER_REPURCHASE_PKG IS

  PROCEDURE MEMBER_REPURCHASE_TRACT_PROC(IN_POSTING_DATE_KEY IN NUMBER) IS
    S_ETL           W_ETL_LOG%ROWTYPE;
    SP_NAME         S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER     S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS     NUMBER;
    UPDATE_ROWS     NUMBER;
    IN_POSTING_DATE DATE;
    /*
    目的:         更新会员购买复购商品记录跟踪表
    作者:         yangjin
    创建时间：    2018/01/15
      */
  BEGIN
    SP_NAME          := 'MEMBER_REPURCHASE_PKG.MEMBER_REPURCHASE_TRACT_PROC'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'OPER_REPURCHASE_MEMBER_TRACK'; --此处需要手工录入该PROCEDURE操作的表格
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
      /*更新最新订购日期LATEST_ORDER_DATE、复购时长（天）REPURCHASE_DAYS*/
      MERGE /*+APPEND*/
      INTO OPER_REPURCHASE_MEMBER_TRACK T
      USING (SELECT G.ITEM_CODE,
                    G.MEMBER_BP,
                    G.LATEST_ORDER_DATE,
                    G.REPURCHASE_DAYS,
                    SYSDATE             W_INSERT_DT,
                    SYSDATE             W_UPDATE_DT
               FROM (SELECT E.ITEM_CODE,
                            E.MEMBER_BP,
                            E.LATEST_ORDER_DATE,
                            E.REPURCHASE_DAYS
                       FROM (SELECT C.ITEM_CODE,
                                    C.MEMBER_BP,
                                    C.LATEST_ORDER_DATE,
                                    D.REPURCHASE_DAYS
                               FROM (SELECT B.ITEM_CODE,
                                            A.MEMBER_KEY MEMBER_BP,
                                            MAX(TO_DATE(A.POSTING_DATE_KEY,
                                                        'YYYYMMDD')) LATEST_ORDER_DATE
                                       FROM FACT_GOODS_SALES     A,
                                            OPER_REPURCHASE_ITEM B
                                      WHERE A.ORDER_STATE = 1
                                        AND A.TRAN_TYPE = 0
                                        AND A.GOODS_COMMON_KEY = B.ITEM_CODE
                                        AND A.POSTING_DATE_KEY >=
                                            TO_CHAR(IN_POSTING_DATE - 7,
                                                    'YYYYMMDD') /*统计最近7天的订购记录*/
                                      GROUP BY A.MEMBER_KEY, B.ITEM_CODE) C,
                                    OPER_REPURCHASE_ITEM D
                              WHERE C.ITEM_CODE = D.ITEM_CODE) E) G) S
      ON (T.ITEM_CODE = S.ITEM_CODE AND T.MEMBER_BP = S.MEMBER_BP)
      WHEN MATCHED THEN
        UPDATE
           SET T.LATEST_ORDER_DATE = S.LATEST_ORDER_DATE,
               T.REPURCHASE_DAYS   = S.REPURCHASE_DAYS,
               T.W_UPDATE_DT       = S.W_UPDATE_DT
      WHEN NOT MATCHED THEN
        INSERT
          (T.ROW_ID,
           T.ITEM_CODE,
           T.MEMBER_BP,
           T.LATEST_ORDER_DATE,
           T.REPURCHASE_DAYS,
           T.ON_SHELF,
           T.STOCK_QTY,
           T.W_INSERT_DT,
           T.W_UPDATE_DT)
        VALUES
          (OPER_REPUR_MEMBER_TRACK_SEQ.NEXTVAL,
           S.ITEM_CODE,
           S.MEMBER_BP,
           S.LATEST_ORDER_DATE,
           S.REPURCHASE_DAYS,
           NULL,
           NULL,
           S.W_INSERT_DT,
           S.W_UPDATE_DT);
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
      /*更新商品上架标志和库存数量*/
      UPDATE OPER_REPURCHASE_MEMBER_TRACK A
         SET (A.ON_SHELF, A.STOCK_QTY, A.W_UPDATE_DT) =
             (SELECT NVL(B.GOODS_STATE, 0) GOODS_STATE,
                     NVL(B.GOODS_STORAGE, 0) GOODS_STORAGE,
                     SYSDATE W_UPDATE_DT
                FROM FACT_EC_GOODS_COMMON B
               WHERE A.ITEM_CODE = B.ITEM_CODE
                 AND (A.ON_SHELF <> B.GOODS_STATE OR
                     A.STOCK_QTY <> B.GOODS_STORAGE))
       WHERE EXISTS (SELECT 1
                FROM FACT_EC_GOODS_COMMON C
               WHERE A.ITEM_CODE = C.ITEM_CODE
                 AND (A.ON_SHELF <> C.GOODS_STATE OR
                     A.STOCK_QTY <> C.GOODS_STORAGE));
      UPDATE_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
    END;
  
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_UPD := UPDATE_ROWS;
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
  END MEMBER_REPURCHASE_TRACT_PROC;

  PROCEDURE MEMBER_REPURCHASE_PUSH_PROC(IN_POSTING_DATE_KEY IN NUMBER) IS
    S_ETL           W_ETL_LOG%ROWTYPE;
    SP_NAME         S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER     S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS     NUMBER;
    UPDATE_ROWS     NUMBER;
    IN_POSTING_DATE DATE;
    /*
    目的:         更新会员购买复购商品记录跟踪表
    作者:         yangjin
    创建时间：    2018/01/15
      */
  BEGIN
    SP_NAME          := 'MEMBER_REPURCHASE_PKG.MEMBER_REPURCHASE_PURSH_PROC'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'OPER_REPURCHASE_MEMBER_TRACK'; --此处需要手工录入该PROCEDURE操作的表格
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
      /*插入当天数据前先删除数据*/
      DELETE OPER_REPURCHASE_PUSH A
       WHERE A.PUSH_DATE_KEY = IN_POSTING_DATE_KEY;
      COMMIT;
    
      INSERT INTO OPER_REPURCHASE_PUSH
        (ROW_ID,
         MEMBER_BP,
         ITEM_CODE,
         PUSH_DATE_KEY,
         ON_SHELF,
         STOCK_QTY,
         W_INSERT_DT,
         W_UPDATE_DT)
        SELECT OPER_REPURCHASE_PUSH_SEQ.NEXTVAL ROW_ID,
               B.MEMBER_BP,
               B.ITEM_CODE,
               B.PUSH_DATE_KEY,
               B.ON_SHELF,
               B.STOCK_QTY,
               SYSDATE                          W_INSERT_DT,
               SYSDATE                          W_UPDATE_DT
          FROM (SELECT A.MEMBER_BP,
                       A.ITEM_CODE,
                       TO_CHAR(A.LATEST_ORDER_DATE + A.REPURCHASE_DAYS,
                               'YYYYMMDD') PUSH_DATE_KEY,
                       A.ON_SHELF,
                       A.STOCK_QTY,
                       (SELECT COUNT(C.MEMBER_BP)
                          FROM OPER_REPURCHASE_MEMBER_TRACK C
                         WHERE A.ITEM_CODE = C.ITEM_CODE) PUSH_MEMBER_COUNT
                  FROM OPER_REPURCHASE_MEMBER_TRACK A
                 WHERE A.LATEST_ORDER_DATE + A.REPURCHASE_DAYS =
                       IN_POSTING_DATE
                   AND A.ON_SHELF = 1) B
         WHERE B.PUSH_MEMBER_COUNT * 0.03 <= B.STOCK_QTY /*推送人数*比例<=库存数量*/
           AND B.STOCK_QTY > 0 /*库存数量大于0*/
        ;
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
    END;
  
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_UPD := UPDATE_ROWS;
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
  END MEMBER_REPURCHASE_PUSH_PROC;

END MEMBER_REPURCHASE_PKG;
/

