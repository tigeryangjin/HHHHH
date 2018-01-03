CREATE OR REPLACE PACKAGE MEMBER_LABEL_PKG IS

  -- AUTHOR  : YANGJIN
  -- CREATED : 2017-08-03 
  -- PURPOSE : MEMBER SMS POOL PACKAGE

  FUNCTION MEMBER_REPURCHASE_CYCLE_DAYS(IN_MEMBER_KEY IN NUMBER)
    RETURN NUMBER;
  /*
  函数名：      MEMBER_REPURCHASE_CYCLE_DAYS
  目的：        返回会员的复购周期（天数）
  创建时间：    2017/08/17
  作者:         yangjin
  创建时间：    2017/08/24
  最后修改人：
  最后更改日期：
  */

  PROCEDURE ML_DATE_FIX(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  功能名:       ML_DATE_FIX
  目的:         所有会员标签指定日期的数据补全
  作者:         yangjin
  创建时间：    2017/12/04
  最后修改人：
  最后更改日期：
  */

  PROCEDURE CREATE_MEMBER_LABEL(IN_M_LABEL_NAME      IN VARCHAR2,
                                IN_M_LABEL_DESC      IN VARCHAR2,
                                IN_M_LABEL_TYPE_ID   IN NUMBER,
                                IN_M_LABEL_FATHER_ID IN NUMBER);
  /*
  功能名:       CREATE_MEMBER_LABEL
  目的:         新建标签插入MEMBER_LABEL_HEAD
  作者:         yangjin
  创建时间：    2017/08/17
  最后修改人：
  最后更改日期：
  */

  PROCEDURE ONLY_BROADCAST(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  功能名:       ONLY_BROADCAST
  目的:         只买播出商品(ONLY_BROADCAST)
                统计最近180天的订购，用户订单数>=4,并且订购的播出商品占比达到70%
  作者:         yangjin
  创建时间：    2017/08/10
  最后修改人：
  最后更改日期：
  */

  PROCEDURE ONLY_TV(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  功能名:       ONLY_TV
  目的:         只买TV商品(ONLY_TV)
                统计最近180天的订购，用户订单数>=4,并且订购的播出商品占比达到70%
  作者:         yangjin
  创建时间：    2017/08/10
  最后修改人：
  最后更改日期：
  */

  PROCEDURE ONLY_ONLINE_RETAIL(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  功能名:       ONLY_ONLINE_RETAIL
  目的:         只买电商商品(ONLY_ONLINE_RETAIL)
                统计最近180天的订购，用户订单数>=4,并且订购的播出商品占比达到70%
  作者:         yangjin
  创建时间：    2017/08/10
  最后修改人：
  最后更改日期：
  */

  PROCEDURE ONLY_SELF_SALES(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  功能名:       IS_SELF_SALES
  目的:         是否只买自营商品
              只买自营商品(SELF_SALES)
              只买非自营商品(NON_SELF_SALES)
                统计最近180天的订购，用户订单数>=4,并且订购的播出商品占比达到70%
  作者:         yangjin
  创建时间：    2017/08/10
  最后修改人：
  最后更改日期：
  */

  PROCEDURE MIXED_CUSTOMER(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  功能名:       MIXED_CUSTOMER
  目的:         混合型会员
                统计最近180天的订购，用户订单数>=4，不属于以上任何类型时
  作者:         yangjin
  创建时间：    2017/08/10
  最后修改人：
  最后更改日期：
  */

  PROCEDURE TOP_ITEM_LOYALTY(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  功能名:       ITEM_LOYALTY
  目的:         直播商品忠诚度(6个标签)
  作者:         yangjin
  创建时间：    2017/08/10
  最后修改人：
  最后更改日期：
  */

  PROCEDURE COMMON_PORT(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  功能名:       COMMON_PORT
  目的:         常用端口(5个标签)
                统计最近180天的FACT_SESSION
                APP(COMMON_PORT_APP)(10,20,)
                微信(COMMON_PORT_WX)(50)
                WAP(COMMON_PORT_WAP)(30)
                PC(COMMON_PORT_PC)(40)
                无规律(COMMON_PORT_VARIETY)
  作者:         yangjin
  创建时间：    2017/08/16
  最后修改人：
  最后更改日期：
  */

  PROCEDURE FIRST_ORDER_NOT(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  功能名:       FIRST_ORDER_NOT
  目的:         首单标签-未产生首单
  作者:         yangjin
  创建时间：    2017/08/17
  最后修改人：
  最后更改日期：
  */

  PROCEDURE FIRST_ORDER_GIFT(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  功能名:       FIRST_ORDER_NOT
  目的:         首单标签-首单为新人礼
  作者:         yangjin
  创建时间：    2017/08/17
  最后修改人：
  最后更改日期：
  */

  PROCEDURE FIRST_ORDER_ITEM(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  功能名:       FIRST_ORDER_ITEM
  目的:         首单标签-首单为TV播出商品(FIRST_ORDER_BROADCAST)
                         首单为TV非播出商品(FIRST_ORDER_NOT_BROADCAST)
                         首单为自营商品(FIRST_ORDER_SELF)
                         首单为BBC商品(FIRST_ORDER_BBC)
  作者:         yangjin
  创建时间：    2017/08/21
  最后修改人：
  最后更改日期：
  */

  PROCEDURE FIRST_ORDER_MAIN(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  功能名:       FIRST_ORDER_MAIN
  目的:         首单标签-主过程
  作者:         yangjin
  创建时间：    2017/08/22
  最后修改人：
  最后更改日期：
  */

  PROCEDURE MEMBER_LEVEL(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  功能名:       MEMBER_LEVEL
  目的:         会员等级
  作者:         yangjin
  创建时间：    2017/08/29
  最后修改人：
  最后更改日期：
  */

  PROCEDURE MEMBER_REPURCHASE(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  功能名:       MEMBER_REPURCHASE
  目的:         会员复购周期（天）
                REPURCHASE_CYCLE_LEVEL_1:-1
                REPURCHASE_CYCLE_LEVEL_2:0~30
                REPURCHASE_CYCLE_LEVEL_3:30~60
                REPURCHASE_CYCLE_LEVEL_4:60~90
                REPURCHASE_CYCLE_LEVEL_5:>90
  作者:         yangjin
  创建时间：    2017/08/29
  最后修改人：
  最后更改日期：
  */

  PROCEDURE MEMBER_PAYMENT_METHOD(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  功能名:       MEMBER_PAYMENT_METHOD
  目的:         会员支付方式
                常用COD(PAYMENT_COD)
                常用支付宝(PAYMENT_ALIPAY)
                常用微信支付(PAYMENT_WX)
                常用银行卡支付(PAYMENT_BANKCARD)
                在线支付(PAYMENT_ONLINE)
  作者:         yangjin
  创建时间：    2017/09/11
  最后修改人：
  最后更改日期：
  */

  PROCEDURE MEMBER_LIFE_PERIOD(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  功能名:       MEMBER_LIFE_PERIOD
  目的:         MEMBER_LIFE_PERIOD   用户生命周期
                NEW_CUSTOMER_PERIOD  新客（未产生订购（包括总订购））
                TRIAL_PERIOD         尝试期（产生订购但未产生有效订购）
                UNDERSTANDING_PERIOD 了解期（产生1~3比有效订购）
                BELIEVE_PERIOD       相信期（产生4到6比有效订购）
                GOOD_FRIEND_PERIOD   好朋友期（产生7比以上有效订购）
                INJURED_PERIOD       被伤害期（产生非个人原因拒退、客诉后未产生有效订购。）
  作者:         yangjin
  创建时间：    2017/09/26
  最后修改人：
  最后更改日期：
  */

  PROCEDURE MEMBER_INJURED_PERIOD(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  功能名:       MEMBER_INJURED_PERIOD
  目的:         INJURED_PERIOD       被伤害期（产生非个人原因拒退、客诉后未产生有效订购。）
  作者:         yangjin
  创建时间：    2017/09/27
  最后修改人：
  最后更改日期：
  */

  PROCEDURE WEBSITE_LOSS_SCORE(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  功能名:       WEBSITE_LOSS_SCORE
  目的:         整站流失评分
  作者:         yangjin
  创建时间：    2017/10/18
  最后修改人：
  最后更改日期：
  */

  PROCEDURE APP_LOSS_SCORE(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  功能名:       APP_LOSS_SCORE
  目的:         APP流失评分
  作者:         yangjin
  创建时间：    2017/10/19
  最后修改人：
  最后更改日期：
  */

  PROCEDURE WX_LOSS_SCORE(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  功能名:       WX_LOSS_SCORE
  目的:         微信流失评分
  作者:         yangjin
  创建时间：    2017/10/19
  最后修改人：
  最后更改日期：
  */

  PROCEDURE MERGE_PUSH_MSG_LOG;
  /*
  功能名:       MERGE_PUSH_MSG_LOG
  目的:         从push_msg_log_tmp把数据插入push_msg_log
  作者:         yangjin
  创建时间：    2017/11/21
  最后修改人：
  最后更改日期：
  */

  PROCEDURE MERGE_PUSH_TASK_RULE;
  /*
  功能名:       MERGE_PUSH_TASK_RULE
  目的:         从push_task_rule_tmp把数据插入push_task_rule
  作者:         yangjin
  创建时间：    2017/11/30
  最后修改人：
  最后更改日期：
  */

  PROCEDURE MESSAGE_PUSH_LABEL;
  /*
  功能名:       MESSAGE_PUSH_LABEL
  目的:         从push_msg_log取数打标签
  作者:         yangjin
  创建时间：    2017/11/29
  最后修改人：
  最后更改日期：
  */

END MEMBER_LABEL_PKG;
/
CREATE OR REPLACE PACKAGE BODY MEMBER_LABEL_PKG IS

  FUNCTION MEMBER_REPURCHASE_CYCLE_DAYS(IN_MEMBER_KEY IN NUMBER)
    RETURN NUMBER IS
    RESULT_DAYS NUMBER;
    /*返回会员的复购周期（天数）*/
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
                      FROM MEMBER_LIFE_PERIOD_TMP_B A /*此处使用会员生命周期的临时表，由MEMBER_LABEL_PKG.MEMBER_LIFE_PERIOD创建*/
                     WHERE A.ORDER_STATE = 1
                       AND A.MEMBER_KEY = IN_MEMBER_KEY
                          /*只取2016年之后的数据*/
                       AND A.POSTING_DATE_KEY >= 20160101) B) C
     WHERE C.LAST_POSTING_DATE IS NOT NULL;
    RETURN(RESULT_DAYS);
  END MEMBER_REPURCHASE_CYCLE_DAYS;

  PROCEDURE ML_DATE_FIX(IN_POSTING_DATE_KEY IN NUMBER) IS
    /*
    功能说明：所有会员标签指定日期的数据补全
    作者时间：yangjin  2017-12-04
    */
  BEGIN
    BEGIN
      -- CALL THE PROCEDURE
      MEMBER_LABEL_PKG.APP_LOSS_SCORE(IN_POSTING_DATE_KEY);
      MEMBER_LABEL_PKG.COMMON_PORT(IN_POSTING_DATE_KEY);
      MEMBER_LABEL_PKG.FIRST_ORDER_GIFT(IN_POSTING_DATE_KEY);
      MEMBER_LABEL_PKG.FIRST_ORDER_ITEM(IN_POSTING_DATE_KEY);
      MEMBER_LABEL_PKG.FIRST_ORDER_NOT(IN_POSTING_DATE_KEY);
      MEMBER_LABEL_PKG.MEMBER_INJURED_PERIOD(IN_POSTING_DATE_KEY);
      MEMBER_LABEL_PKG.MEMBER_LEVEL(IN_POSTING_DATE_KEY);
      MEMBER_LABEL_PKG.MEMBER_LIFE_PERIOD(IN_POSTING_DATE_KEY);
      MEMBER_LABEL_PKG.MEMBER_PAYMENT_METHOD(IN_POSTING_DATE_KEY);
      MEMBER_LABEL_PKG.MEMBER_REPURCHASE(IN_POSTING_DATE_KEY);
      MEMBER_LABEL_PKG.MIXED_CUSTOMER(IN_POSTING_DATE_KEY);
      MEMBER_LABEL_PKG.ONLY_BROADCAST(IN_POSTING_DATE_KEY);
      MEMBER_LABEL_PKG.ONLY_ONLINE_RETAIL(IN_POSTING_DATE_KEY);
      MEMBER_LABEL_PKG.ONLY_SELF_SALES(IN_POSTING_DATE_KEY);
      MEMBER_LABEL_PKG.ONLY_TV(IN_POSTING_DATE_KEY);
      MEMBER_LABEL_PKG.WEBSITE_LOSS_SCORE(IN_POSTING_DATE_KEY);
      MEMBER_LABEL_PKG.WX_LOSS_SCORE(IN_POSTING_DATE_KEY);
    END;
  END ML_DATE_FIX;

  PROCEDURE CREATE_MEMBER_LABEL(IN_M_LABEL_NAME      IN VARCHAR2,
                                IN_M_LABEL_DESC      IN VARCHAR2,
                                IN_M_LABEL_TYPE_ID   IN NUMBER,
                                IN_M_LABEL_FATHER_ID IN NUMBER) IS
    /*
    功能说明：新建标签插入MEMBER_LABEL_HEAD
    作者时间：yangjin  2017-08-17
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
    功能说明：只买播出商品(ONLY_BROADCAST)
              统计最近180天的订购，用户订单数>=4,并且订购的播出商品占比达到70%
    作者时间：yangjin  2017-08-10
    */
  BEGIN
  
    SP_NAME          := 'MEMBER_LABEL_PKG.ONLY_BROADCAST'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'MEMBER_LABEL_LINK'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    IN_POSTING_DATE  := TO_DATE(IN_POSTING_DATE_KEY, 'YYYYMMDD');
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.END_TIME := SYSDATE;
        S_ETL.ERR_MSG  := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
      /*插入临时表*/
      EXECUTE IMMEDIATE 'TRUNCATE TABLE ML_ONLY_BROADCAST_TMP';
      INSERT INTO ML_ONLY_BROADCAST_TMP
        SELECT D.MEMBER_KEY,
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
                                               'YYYYMMDD') /*180天数据统计*/
                                   AND EXISTS
                                 (SELECT 1
                                          FROM FACT_GOODS_SALES G
                                         WHERE G.POSTING_DATE_KEY =
                                               IN_POSTING_DATE_KEY
                                           AND G.MEMBER_KEY = A.MEMBER_KEY) /*只处理当天日期的member_key*/
                                   AND A.ORDER_STATE = 1
                                   AND A.TRAN_TYPE = 0) SALES,
                               (SELECT B.ITEM_CODE,
                                       B.TV_STARTDAY_KEY,
                                       1 IS_BCST /*是否播出*/
                                  FROM DIM_TV_GOOD B
                                 WHERE B.TV_STARTDAY_KEY >=
                                       TO_CHAR(TRUNC(IN_POSTING_DATE - 179),
                                               'YYYYMMDD') /*180天数据统计*/
                                ) TV_GOOD
                         WHERE SALES.POSTING_DATE_KEY =
                               TV_GOOD.TV_STARTDAY_KEY(+)
                           AND SALES.GOODS_COMMON_KEY = TV_GOOD.ITEM_CODE(+)) C
                 GROUP BY C.MEMBER_KEY) D,
               (SELECT F.M_LABEL_ID,
                       F.M_LABEL_NAME,
                       F.M_LABEL_TYPE_ID,
                       F.CREATE_USER_ID,
                       F.LAST_UPDATE_USER_ID
                  FROM MEMBER_LABEL_HEAD F
                 WHERE F.M_LABEL_NAME = 'ONLY_BROADCAST' /*只买播出商品*/
                ) E
         WHERE /*用户订购单数大于4单时启用*/
         D.ORDER_COUNT >= 4
        /*订购商品达到70%以上是播出商品时认为是只买播出商品用户*/
         AND D.BCST_ITEM_COUNT / D.ITEM_COUNT >= 0.7;
      COMMIT;
    
      /*插入只买播出商品标签的会员*/
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
      USING ML_ONLY_BROADCAST_TMP S
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
    
  END ONLY_BROADCAST;

  PROCEDURE ONLY_TV(IN_POSTING_DATE_KEY IN NUMBER) IS
    S_ETL           W_ETL_LOG%ROWTYPE;
    SP_NAME         S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER     S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS     NUMBER;
    IN_POSTING_DATE DATE;
    /*
    功能说明：只买TV商品(ONLY_TV)
              统计最近180天的订购，用户订单数>=4,并且订购的播出商品占比达到70%
    作者时间：yangjin  2017-08-10
    */
  BEGIN
  
    SP_NAME          := 'MEMBER_LABEL_PKG.ONLY_TV'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'MEMBER_LABEL_LINK'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    IN_POSTING_DATE  := TO_DATE(IN_POSTING_DATE_KEY, 'YYYYMMDD');
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.END_TIME := SYSDATE;
        S_ETL.ERR_MSG  := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
      /*插入临时表*/
      EXECUTE IMMEDIATE 'TRUNCATE TABLE ML_ONLY_TV_TMP';
      INSERT INTO ML_ONLY_TV_TMP
        SELECT D.MEMBER_KEY,
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
                                               'YYYYMMDD') /*180天数据统计*/
                                   AND EXISTS
                                 (SELECT 1
                                          FROM FACT_GOODS_SALES G
                                         WHERE G.POSTING_DATE_KEY =
                                               IN_POSTING_DATE_KEY
                                           AND G.MEMBER_KEY = A.MEMBER_KEY) /*只处理当天日期的member_key*/
                                   AND A.ORDER_STATE = 1
                                   AND A.TRAN_TYPE = 0) SALES,
                               (SELECT ITEM_CODE, 1 IS_TV /*TV商品*/
                                  FROM DIM_GOOD
                                 WHERE GROUP_ID = 1000) TV_GOOD
                         WHERE SALES.GOODS_COMMON_KEY = TV_GOOD.ITEM_CODE(+)) C
                 GROUP BY C.MEMBER_KEY) D,
               (SELECT F.M_LABEL_ID,
                       F.M_LABEL_NAME,
                       F.M_LABEL_TYPE_ID,
                       F.CREATE_USER_ID,
                       F.LAST_UPDATE_USER_ID
                  FROM MEMBER_LABEL_HEAD F
                 WHERE F.M_LABEL_NAME = 'ONLY_TV' /*只买TV商品*/
                ) E
         WHERE /*用户订购单数大于4单时启用*/
         D.ORDER_COUNT >= 4
        /*订购TV商品达到70%以上*/
         AND D.TV_ITEM_COUNT / D.ITEM_COUNT >= 0.7;
      COMMIT;
    
      /*插入只买TV商品标签的会员*/
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
      USING ML_ONLY_TV_TMP S
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
    
  END ONLY_TV;

  PROCEDURE ONLY_ONLINE_RETAIL(IN_POSTING_DATE_KEY IN NUMBER) IS
    S_ETL           W_ETL_LOG%ROWTYPE;
    SP_NAME         S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER     S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS     NUMBER;
    IN_POSTING_DATE DATE;
    /*
    功能说明：只买电商商品(ONLY_ONLINE_RETAIL)
              统计最近180天的订购，用户订单数>=4,并且订购的播出商品占比达到70%
    作者时间：yangjin  2017-08-10
    */
  BEGIN
  
    SP_NAME          := 'MEMBER_LABEL_PKG.ONLY_ONLINE_RETAIL'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'MEMBER_LABEL_LINK'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    IN_POSTING_DATE  := TO_DATE(IN_POSTING_DATE_KEY, 'YYYYMMDD');
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.END_TIME := SYSDATE;
        S_ETL.ERR_MSG  := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
      /*插入临时表*/
      EXECUTE IMMEDIATE 'TRUNCATE TABLE ML_ONLINE_RETAIL_TMP';
      INSERT INTO ML_ONLINE_RETAIL_TMP
        SELECT D.MEMBER_KEY,
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
                                               'YYYYMMDD') /*180天数据统计*/
                                   AND EXISTS
                                 (SELECT 1
                                          FROM FACT_GOODS_SALES G
                                         WHERE G.POSTING_DATE_KEY =
                                               IN_POSTING_DATE_KEY
                                           AND G.MEMBER_KEY = A.MEMBER_KEY) /*只处理当天日期的member_key*/
                                   AND A.ORDER_STATE = 1
                                   AND A.TRAN_TYPE = 0) SALES,
                               (SELECT ITEM_CODE, 1 IS_ONLINE /*电商商品*/
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
                 WHERE F.M_LABEL_NAME = 'ONLY_ONLINE_RETAIL' /*只买电商商品*/
                ) E
         WHERE /*用户订购单数大于4单时启用*/
         D.ORDER_COUNT >= 4
        /*电商商品达到70%以上*/
         AND D.ONLINE_ITEM_COUNT / D.ITEM_COUNT >= 0.7;
      COMMIT;
    
      /*插入只买电商商品标签的会员*/
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
      USING ML_ONLINE_RETAIL_TMP S
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
    
  END ONLY_ONLINE_RETAIL;

  PROCEDURE ONLY_SELF_SALES(IN_POSTING_DATE_KEY IN NUMBER) IS
    S_ETL           W_ETL_LOG%ROWTYPE;
    SP_NAME         S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER     S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS     NUMBER;
    IN_POSTING_DATE DATE;
    /*
    功能说明：是否只买自营商品
              只买自营商品(SELF_SALES)
              只买非自营商品(NON_SELF_SALES)
                统计最近180天的订购，用户订单数>=4,并且订购的播出商品占比达到70%
    作者时间：yangjin  2017-08-10
    */
  BEGIN
  
    SP_NAME          := 'MEMBER_LABEL_PKG.ONLY_SELF_SALES'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'MEMBER_LABEL_LINK'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    IN_POSTING_DATE  := TO_DATE(IN_POSTING_DATE_KEY, 'YYYYMMDD');
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.END_TIME := SYSDATE;
        S_ETL.ERR_MSG  := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
      /*插入临时表*/
      EXECUTE IMMEDIATE 'TRUNCATE TABLE ML_ONLY_SELF_SALES_TMP';
      INSERT INTO ML_ONLY_SELF_SALES_TMP
        SELECT D.MEMBER_KEY,
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
                                               'YYYYMMDD') /*180天数据统计*/
                                   AND EXISTS
                                 (SELECT 1
                                          FROM FACT_GOODS_SALES G
                                         WHERE G.POSTING_DATE_KEY =
                                               IN_POSTING_DATE_KEY
                                           AND G.MEMBER_KEY = A.MEMBER_KEY) /*只处理当天日期的member_key*/
                                   AND A.ORDER_STATE = 1
                                   AND A.TRAN_TYPE = 0) SALES,
                               (SELECT ITEM_CODE,
                                       CASE
                                         WHEN IS_SHIPPING_SELF = '自送' THEN
                                          'SELF_SALES'
                                         ELSE
                                          'NON_SELF_SALES'
                                       END IS_SELF_SALES
                                  FROM FACT_DAILY_GOODZAIJIA) GOOD
                         WHERE SALES.GOODS_COMMON_KEY = GOOD.ITEM_CODE) C
                 GROUP BY C.MEMBER_KEY) D
         WHERE D.ORDER_COUNT >= 4 /*订购单数大于4笔*/
              /*自营或非自营比率大于70%*/
           AND (D.SELF_SALES_ITEM_COUNT / D.ITEM_COUNT >= 0.7 OR
               D.NON_SELF_SALES_ITEM_COUNT / D.ITEM_COUNT >= 0.7);
      COMMIT;
    
      /*插入是否自营标签的会员*/
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
      USING ML_ONLY_SELF_SALES_TMP S
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
    
  END ONLY_SELF_SALES;

  PROCEDURE MIXED_CUSTOMER(IN_POSTING_DATE_KEY IN NUMBER) IS
    S_ETL           W_ETL_LOG%ROWTYPE;
    SP_NAME         S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER     S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS     NUMBER;
    IN_POSTING_DATE DATE;
    /*
    功能说明：混合型会员
                统计最近180天的订购，用户订单数>=4，不属于以上任何类型时
    作者时间：yangjin  2017-08-10
    */
  BEGIN
  
    SP_NAME          := 'MEMBER_LABEL_PKG.MIXED_CUSTOMER'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'MEMBER_LABEL_LINK'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    IN_POSTING_DATE  := TO_DATE(IN_POSTING_DATE_KEY, 'YYYYMMDD');
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.END_TIME := SYSDATE;
        S_ETL.ERR_MSG  := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
      /*插入临时表*/
      EXECUTE IMMEDIATE 'TRUNCATE TABLE ML_MIXED_CUSTOMER_TMP';
      INSERT INTO ML_MIXED_CUSTOMER_TMP
        SELECT C.MEMBER_KEY,
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
                                       'YYYYMMDD') /*180天数据统计*/
                           AND EXISTS
                         (SELECT 1
                                  FROM FACT_GOODS_SALES G
                                 WHERE G.POSTING_DATE_KEY =
                                       IN_POSTING_DATE_KEY
                                   AND G.MEMBER_KEY = A.MEMBER_KEY) /*只处理当天日期的member_key*/
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
                 WHERE F.M_LABEL_NAME = 'MIXED_CUSTOMER' /*混合类型*/
                ) E
         WHERE NOT EXISTS (SELECT 1
                  FROM MEMBER_LABEL_LINK D
                 WHERE D.M_LABEL_ID IN (3, 4, 5, 6, 7)
                   AND C.MEMBER_KEY = D.MEMBER_KEY); /*不属于其他任何类型*/
      COMMIT;
    
      /*插入混合类型标签的会员*/
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
      USING ML_MIXED_CUSTOMER_TMP S
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
    
  END MIXED_CUSTOMER;

  PROCEDURE TOP_ITEM_LOYALTY(IN_POSTING_DATE_KEY IN NUMBER) IS
  
    /*
    功能说明：直播商品忠诚度(6个标签)
    作者时间：yangjin  2017-08-10
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
    功能说明:    常用端口(5个标签)
                    APP(COMMON_PORT_APP)(10,20,)
                    微信(COMMON_PORT_WX)(50)
                    WAP(COMMON_PORT_WAP)(30)
                    PC(COMMON_PORT_PC)(40)
                    无规律(COMMON_PORT_VARIETY)
                    FACT_SESSION当天有记录的会员才会计算最近半年的常用端口标签
    作者时间：yangjin  2017-08-16
    */
  BEGIN
  
    SP_NAME          := 'MEMBER_LABEL_PKG.COMMON_PORT'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'MEMBER_LABEL_LINK'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    IN_POSTING_DATE  := TO_DATE(IN_POSTING_DATE_KEY, 'YYYYMMDD');
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.END_TIME := SYSDATE;
        S_ETL.ERR_MSG  := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
      /*插入临时表*/
      EXECUTE IMMEDIATE 'TRUNCATE TABLE ML_COMMON_PORT_TMP';
      INSERT INTO ML_COMMON_PORT_TMP
        SELECT F.MEMBER_KEY,
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
                               /*端口占比大于70%为常用端口，否则为无规律标签*/
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
                                                               'YYYYMMDD') /*统计180天数据*/
                                                   AND A.MEMBER_KEY <> 0
                                                      /*只对当天浏览的会员计算常用端口*/
                                                   AND EXISTS
                                                 (SELECT 1
                                                          FROM FACT_SESSION H
                                                         WHERE A.MEMBER_KEY =
                                                               H.MEMBER_KEY
                                                           AND H.START_DATE_KEY =
                                                               IN_POSTING_DATE_KEY)) B
                                         WHERE B.COMMON_PORT IS NOT NULL
                                         GROUP BY B.MEMBER_KEY, B.COMMON_PORT) C) D
                         WHERE D.TOTAL_FREQ >= 4) E
                 GROUP BY E.MEMBER_KEY) F,
               MEMBER_LABEL_HEAD G
         WHERE G.M_LABEL_FATHER_ID = 21
           AND F.COMMON_PORT = G.M_LABEL_NAME;
      COMMIT;
    
      /*插入常用端口标签*/
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
      USING ML_COMMON_PORT_TMP S
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
  END COMMON_PORT;

  PROCEDURE FIRST_ORDER_NOT(IN_POSTING_DATE_KEY IN NUMBER) IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    --IN_POSTING_DATE DATE;
    /*
    功能说明:    首单标签-无产生首单
    作者时间：yangjin  2017-08-17
    */
  BEGIN
  
    SP_NAME          := 'MEMBER_LABEL_PKG.FIRST_ORDER_NOT'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'MEMBER_LABEL_LINK'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    --IN_POSTING_DATE  := TO_DATE(IN_POSTING_DATE_KEY, 'YYYYMMDD');
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.END_TIME := SYSDATE;
        S_ETL.ERR_MSG  := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
      /*未产生首单*/
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
              /*避免重复插入未产生首单标签*/
           AND NOT EXISTS
         (SELECT 1
                  FROM MEMBER_LABEL_LINK F
                 WHERE D.MEMBER_KEY = F.MEMBER_KEY
                   AND F.M_LABEL_ID BETWEEN 42 AND 47);
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
  END FIRST_ORDER_NOT;

  PROCEDURE FIRST_ORDER_GIFT(IN_POSTING_DATE_KEY IN NUMBER) IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    --IN_POSTING_DATE DATE;
    /*
    功能说明:    首单标签-首单为新人礼
    作者时间：yangjin  2017-08-17
    */
  BEGIN
  
    SP_NAME          := 'MEMBER_LABEL_PKG.FIRST_ORDER_GIFT'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'MEMBER_LABEL_LINK'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    --IN_POSTING_DATE  := TO_DATE(IN_POSTING_DATE_KEY, 'YYYYMMDD');
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.END_TIME := SYSDATE;
        S_ETL.ERR_MSG  := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
      /*首单标签-首单为新人礼*/
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
              /*避免重复插入首单为新人礼标签*/
           AND NOT EXISTS
         (SELECT 1
                  FROM MEMBER_LABEL_LINK F
                 WHERE D.MEMBER_KEY = F.MEMBER_KEY
                   AND F.M_LABEL_ID BETWEEN 42 AND 47);
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
  END FIRST_ORDER_GIFT;

  PROCEDURE FIRST_ORDER_ITEM(IN_POSTING_DATE_KEY IN NUMBER) IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
    /*
    功能说明:    首单标签-首单为TV播出商品(FIRST_ORDER_BROADCAST)
                          首单为TV非播出商品(FIRST_ORDER_NOT_BROADCAST)
                          首单为自营商品(FIRST_ORDER_SELF)
                          首单为BBC商品(FIRST_ORDER_BBC)
    作者时间：yangjin  2017-08-21
    */
  BEGIN
  
    SP_NAME          := 'MEMBER_LABEL_PKG.FIRST_ORDER_ITEM'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'MEMBER_LABEL_LINK'; --此处需要手工录入该PROCEDURE操作的表格
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
        S_ETL.ERR_MSG  := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
    
      DECLARE
        TYPE TYPE_ARRAYS IS RECORD(
          MEMBER_KEY NUMBER(20));
      
        TYPE TYPE_ARRAY IS TABLE OF TYPE_ARRAYS INDEX BY BINARY_INTEGER; --类似二维数组 
      
        VAR_ARRAY TYPE_ARRAY;
      BEGIN
        /*当天注册的会员BP号,没有首单标签*/
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
        
          /*首单购买商品分类*/
          INSERT INTO MEMBER_LABEL_LINK
            (ROW_ID,
             MEMBER_KEY,
             M_LABEL_ID,
             M_LABEL_TYPE_ID,
             CREATE_DATE,
             CREATE_USER_ID,
             LAST_UPDATE_DATE,
             LAST_UPDATE_USER_ID)
          /*首单订购金额最大的商品*/
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
                   /*商品标签分类*/
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
                  /*不存在MEMBER_LABEL_LINK表的插入*/
               AND NOT EXISTS
             (SELECT 1
                      FROM MEMBER_LABEL_LINK MLL
                     WHERE MLL.M_LABEL_ID BETWEEN 42 AND 47
                       AND ORD.MEMBER_KEY = MLL.MEMBER_KEY);
          COMMIT;
          INSERT_ROWS := INSERT_ROWS + 1;
        END LOOP;
      
      END;
    
      /*当会员首次订购后，更新未产生首单标志*/
      DECLARE
        TYPE TYPE_ARRAYS IS RECORD(
          MEMBER_KEY NUMBER(20));
      
        TYPE TYPE_ARRAY IS TABLE OF TYPE_ARRAYS INDEX BY BINARY_INTEGER; --类似二维数组 
      
        VAR_ARRAY TYPE_ARRAY;
      BEGIN
        /*未产生首单的用户*/
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
          /*更新[未产生首单]标签*/
          UPDATE MEMBER_LABEL_LINK A
             SET (A.M_LABEL_ID,
                  --A.M_LABEL_TYPE_ID,
                  A.LAST_UPDATE_DATE,
                  A.LAST_UPDATE_USER_ID) =
                 (SELECT NVL(MLH.M_LABEL_ID, 42), /*如果M_LABEL_ID为空，则默认为42，未产生首单*/
                         --NVL(MLH.M_LABEL_TYPE_ID, 1),
                         SYSDATE,
                         'yangjin'
                    FROM /*首单订购金额最大的商品*/
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
                         /*商品标签分类*/
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
  END FIRST_ORDER_ITEM;

  PROCEDURE FIRST_ORDER_MAIN(IN_POSTING_DATE_KEY IN NUMBER) IS
  
    /*
    功能说明：直播商品忠诚度(6个标签)
    作者时间：yangjin  2017-08-10
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
    功能说明：会员等级(7个标签)
    作者时间：yangjin  2017-08-29
    */
  BEGIN
    SP_NAME          := 'MEMBER_LABEL_PKG.MEMBER_LEVEL'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'MEMBER_LABEL_LINK'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    --IN_POSTING_DATE  := TO_DATE(IN_POSTING_DATE_KEY, 'YYYYMMDD');
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.END_TIME := SYSDATE;
        S_ETL.ERR_MSG  := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
      /*插入临时表*/
      EXECUTE IMMEDIATE 'TRUNCATE TABLE ML_MEMBER_LEVEL_TMP';
      INSERT INTO ML_MEMBER_LEVEL_TMP
        SELECT A.MEMBER_BP,
               CASE
                 WHEN A.MEMBER_LEVEL = 'HAPP_T0' THEN
                  62
                 WHEN A.MEMBER_LEVEL = 'HAPP_T1' THEN
                  63
                 WHEN A.MEMBER_LEVEL = 'HAPP_T2' THEN
                  64
                 WHEN A.MEMBER_LEVEL = 'HAPP_T3' THEN
                  65
                 WHEN A.MEMBER_LEVEL = 'HAPP_T4' THEN
                  66
                 WHEN A.MEMBER_LEVEL = 'HAPP_T5' THEN
                  67
                 WHEN A.MEMBER_LEVEL = 'HAPP_T6' THEN
                  68
               END MEMBER_LEVEL_ID
          FROM (SELECT B.MEMBER_BP, MAX(B.MEMBER_LEVEL) MEMBER_LEVEL
                  FROM DIM_MEMBER B
                 WHERE B.CH_DATE_KEY = IN_POSTING_DATE_KEY
                   AND B.MEMBER_LEVEL IS NOT NULL
                 GROUP BY B.MEMBER_BP) A;
      COMMIT;
    
      /*插入MEMBER_LABEL_LINK*/
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
      USING ML_MEMBER_LEVEL_TMP S
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
  END MEMBER_LEVEL;

  PROCEDURE MEMBER_REPURCHASE(IN_POSTING_DATE_KEY IN NUMBER) IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
    /*
    功能说明：会员复购周期（天）
                REPURCHASE_CYCLE_LEVEL_1:-1
                REPURCHASE_CYCLE_LEVEL_2:0~30
                REPURCHASE_CYCLE_LEVEL_3:30~60
                REPURCHASE_CYCLE_LEVEL_4:60~90
                REPURCHASE_CYCLE_LEVEL_5:>90
    作者时间：yangjin  2017-08-29
    */
  BEGIN
    SP_NAME          := 'MEMBER_LABEL_PKG.MEMBER_REPURCHASE'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'MEMBER_LABEL_LINK'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    --IN_POSTING_DATE  := TO_DATE(IN_POSTING_DATE_KEY, 'YYYYMMDD');
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.END_TIME := SYSDATE;
        S_ETL.ERR_MSG  := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
      /*清空会员复购周期临时表*/
      EXECUTE IMMEDIATE 'TRUNCATE TABLE MEMBER_REPURCHASE_TMP';
    
      /*当天发生销售的会员计算复购周期写入MEMBER_REPURCHASE_TMP*/
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
  END MEMBER_REPURCHASE;

  PROCEDURE MEMBER_PAYMENT_METHOD(IN_POSTING_DATE_KEY IN NUMBER) IS
    S_ETL           W_ETL_LOG%ROWTYPE;
    SP_NAME         S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER     S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS     NUMBER;
    UPDATE_ROWS     NUMBER;
    IN_POSTING_DATE DATE;
    /*
    功能说明：会员支付方式
                常用COD(PAYMENT_COD)
                常用支付宝(PAYMENT_ALIPAY)
                常用微信支付(PAYMENT_WX)
                常用银行卡支付(PAYMENT_BANKCARD)
                在线支付(PAYMENT_ONLINE)
    作者时间：yangjin  2017-09-11
    */
  BEGIN
    SP_NAME          := 'MEMBER_LABEL_PKG.MEMBER_PAYMENT_METHOD'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'MEMBER_LABEL_LINK'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    IN_POSTING_DATE  := TO_DATE(IN_POSTING_DATE_KEY, 'YYYYMMDD');
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.END_TIME := SYSDATE;
        S_ETL.ERR_MSG  := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
      /*插入临时表*/
      EXECUTE IMMEDIATE 'TRUNCATE TABLE ML_PAYMENT_METHOD_TMP';
      INSERT INTO ML_PAYMENT_METHOD_TMP
        SELECT F.MEMBER_KEY,
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
                               /*最大金额的支付方式如果超过50%，则此支付方式为常用支付方式*/
                                 WHEN D.RANK1 = 1 AND D.TOTAL_ORDER_AMOUNT <=
                                      D.ORDER_AMOUNT * 2 THEN
                                  D.PAYMENT_METHOD
                               /*银行卡、支付宝、微信合计支付金额超过50%，则常用方式为网络支付*/
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
                                       RANK() OVER(PARTITION BY C.MEMBER_KEY ORDER BY C.ORDER_AMOUNT DESC) RANK1 /*订单金额倒序排名*/,
                                       SUM(C.ORDER_AMOUNT) OVER(PARTITION BY C.MEMBER_KEY) TOTAL_ORDER_AMOUNT /*会员合计订单金额*/
                                  FROM (SELECT B.MEMBER_KEY,
                                               B.PAYMENT_METHOD,
                                               SUM(B.ORDER_AMOUNT) ORDER_AMOUNT
                                          FROM (SELECT A.CUST_NO MEMBER_KEY,
                                                       A.ADD_TIME,
                                                       TO_CHAR(A.ORDER_SN) ORDER_NO,
                                                       CASE
                                                         WHEN UPPER(A.PAYMENTCHANNEL) =
                                                              '线下支付' OR
                                                              A.PAYMENTCHANNEL IS NULL THEN
                                                          'PAYMENT_COD' /*COD*/
                                                         WHEN UPPER(A.PAYMENTCHANNEL) IN
                                                              ('ALIPAY_M',
                                                               'ALIPAY_W',
                                                               'ALIPAY_WAP',
                                                               '支付宝') THEN
                                                          'PAYMENT_ALIPAY' /*支付宝*/
                                                         WHEN UPPER(A.PAYMENTCHANNEL) IN
                                                              ('WX',
                                                               'WXPAY_M',
                                                               'WX_I',
                                                               'WX_W',
                                                               'WX_WAP',
                                                               'ZXWX_I',
                                                               'ZXWX_W',
                                                               '微信',
                                                               '微信(APP)',
                                                               '微信(狗小二)',
                                                               '财付通') THEN
                                                          'PAYMENT_WX' /*微信*/
                                                         WHEN UPPER(A.PAYMENTCHANNEL) IN
                                                              ('CMB', 'CMBYWT_M') THEN
                                                          'PAYMENT_BANKCARD' /*银行卡*/
                                                       END PAYMENT_METHOD,
                                                       A.ORDER_AMOUNT
                                                  FROM FACT_EC_ORDER A
                                                 WHERE A.ORDER_STATE >= 20 /*已付款订单*/
                                                      /*日期条件-180天*/
                                                   AND A.ADD_TIME BETWEEN
                                                       TO_CHAR(TRUNC(IN_POSTING_DATE - 179),
                                                               'YYYYMMDD') AND
                                                       TO_CHAR(TRUNC(IN_POSTING_DATE),
                                                               'YYYYMMDD')
                                                      /*只计算当天有效订购的会员的常用支付方式*/
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
           AND F.FINAL_PAYMENT_LABEL = G.M_LABEL_NAME;
      COMMIT;
    
      /*插入会员常用支付方式标签*/
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
      USING ML_PAYMENT_METHOD_TMP S
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
    
      /*插入大额CODE支付小额在线支付标签*/
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
                               /*COD支付方式的金额大于合计支付金额的60%*/
                                 WHEN D.RANK1 = 1 AND
                                      D.PAYMENT_METHOD = 'PAYMENT_COD' AND
                                      D.ORDER_AMOUNT >=
                                      D.TOTAL_ORDER_AMOUNT * 0.6 THEN
                                  'PAYMENT_MOST_COD'
                               END PAYMENT_LABEL
                          FROM (SELECT C.MEMBER_KEY,
                                       C.PAYMENT_METHOD,
                                       C.ORDER_AMOUNT,
                                       RANK() OVER(PARTITION BY C.MEMBER_KEY ORDER BY C.ORDER_AMOUNT DESC) RANK1 /*订单金额倒序排名*/,
                                       SUM(C.ORDER_AMOUNT) OVER(PARTITION BY C.MEMBER_KEY) TOTAL_ORDER_AMOUNT /*会员合计订单金额*/
                                  FROM (SELECT B.MEMBER_KEY,
                                               B.PAYMENT_METHOD,
                                               SUM(B.ORDER_AMOUNT) ORDER_AMOUNT
                                          FROM (SELECT A.CUST_NO MEMBER_KEY,
                                                       A.ADD_TIME,
                                                       TO_CHAR(A.ORDER_SN) ORDER_NO,
                                                       CASE
                                                         WHEN UPPER(A.PAYMENTCHANNEL) =
                                                              '线下支付' OR
                                                              A.PAYMENTCHANNEL IS NULL THEN
                                                          'PAYMENT_COD' /*COD*/
                                                         ELSE
                                                          'PAYMENT_ONLINE' /*在线支付*/
                                                       END PAYMENT_METHOD,
                                                       A.ORDER_AMOUNT
                                                  FROM FACT_EC_ORDER A
                                                 WHERE A.ORDER_STATE >= 20 /*已付款订单*/
                                                      /*日期条件-180天*/
                                                   AND A.ADD_TIME BETWEEN
                                                       TO_CHAR(TRUNC(IN_POSTING_DATE - 179),
                                                               'YYYYMMDD') AND
                                                       TO_CHAR(TRUNC(IN_POSTING_DATE),
                                                               'YYYYMMDD')) B
                                         WHERE B.PAYMENT_METHOD IS NOT NULL
                                         GROUP BY B.MEMBER_KEY,
                                                  B.PAYMENT_METHOD) C) D) E
                 WHERE E.PAYMENT_LABEL IS NOT NULL
                      /*剔除掉订购金额=0的member*/
                   AND E.TOTAL_ORDER_AMOUNT > 0) F,
               MEMBER_LABEL_HEAD G
         WHERE G.M_LABEL_ID = 141
           AND F.PAYMENT_LABEL = G.M_LABEL_NAME
              /*会员如果已经打上了标签则不重复打*/
           AND NOT EXISTS (SELECT 1
                  FROM MEMBER_LABEL_LINK H
                 WHERE H.M_LABEL_ID = 141
                   AND F.MEMBER_KEY = H.MEMBER_KEY);
      INSERT_ROWS := INSERT_ROWS + SQL%ROWCOUNT;
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
  END MEMBER_PAYMENT_METHOD;

  PROCEDURE MEMBER_LIFE_PERIOD(IN_POSTING_DATE_KEY IN NUMBER) IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
    --IN_POSTING_DATE DATE;
    /*
    功能说明：MEMBER_LIFE_PERIOD   用户生命周期
                NEW_CUSTOMER_PERIOD  新客（未产生订购（包括总订购））
                TRIAL_PERIOD         尝试期（产生订购但未产生有效订购）
                UNDERSTANDING_PERIOD 了解期（产生1~3比有效订购）
                BELIEVE_PERIOD       相信期（产生4到6比有效订购）
                GOOD_FRIEND_PERIOD   好朋友期（产生7比以上有效订购）
                INJURED_PERIOD       被伤害期（产生非个人原因拒退、客诉后未产生有效订购。）
    作者时间：yangjin  2017-09-26
    */
  BEGIN
    SP_NAME          := 'MEMBER_LABEL_PKG.MEMBER_LIFE_PERIOD'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'MEMBER_LABEL_LINK'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    --IN_POSTING_DATE  := TO_DATE(IN_POSTING_DATE_KEY, 'YYYYMMDD');
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.END_TIME := SYSDATE;
        S_ETL.ERR_MSG  := '没有找到对应的过程加载类型数据';
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
                /*获取当天订购的会员BP号*/
                SELECT D.MEMBER_KEY MEMBER_BP
                  FROM FACT_ORDER D
                 WHERE D.ORDER_DATE_KEY = IN_POSTING_DATE_KEY
                UNION ALL
                /*获取当天注册的会员BP号*/
                SELECT J.MEMBER_BP
                  FROM DIM_MEMBER J
                 WHERE J.MEMBER_INSERT_DATE = TO_CHAR(IN_POSTING_DATE_KEY)) K;
      COMMIT;
    
      /*MEMBER_LIFE_PERIOD_TMP_B,此临时表数据从2016.1.1开始
      MEMBER_LABEL_PKG.MEMBER_REPURCHASE_CYCLE_DAYS使用此临时表*/
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
    
      /*插入生命周期标签，生命周期从2016.1.1开始统计*/
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
                               'NEW_CUSTOMER_PERIOD' /*新用户期*/
                              WHEN G.ORDER_STATE = 0 THEN
                               'TRIAL_PERIOD' /*尝试期*/
                              WHEN G.ORDER_STATE = 1 AND
                                   G.ORDER_COUNT BETWEEN 1 AND 3 THEN
                               'UNDERSTANDING_PERIOD' /*了解期*/
                              WHEN G.ORDER_STATE = 1 AND
                                   G.ORDER_COUNT BETWEEN 4 AND 6 THEN
                               'BELIEVE_PERIOD' /*信任期*/
                              WHEN G.ORDER_STATE = 1 AND G.ORDER_COUNT >= 7 THEN
                               'GOOD_FRIEND_PERIOD' /*好友期*/
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
  END MEMBER_LIFE_PERIOD;

  PROCEDURE MEMBER_INJURED_PERIOD(IN_POSTING_DATE_KEY IN NUMBER) IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    DELETE_ROWS NUMBER;
    --IN_POSTING_DATE DATE;
    /*
    功能说明：INJURED_PERIOD       被伤害期（产生非个人原因拒退、客诉后未产生有效订购。）
              业务当天会员有非个人原因拒退的订单，并且当天没有有效订购的则打上标签。
              如果已经打上标签的会员，在业务当天有有效订购，则取消标签
              退货原因:
              SELECT B.ONE_REASON, C.REASON_NM, B.TWO_REASON, D.REASON_NM
              FROM (SELECT DISTINCT A.ONE_REASON, A.TWO_REASON FROM FACT_ORDER_REVERSE A) B,
                   DIM_RE_RESEAON_1 C,
                   DIM_RE_RESEAON_2 D
             WHERE B.ONE_REASON = C.CODE
               AND B.TWO_REASON = D.CODE
             ORDER BY B.ONE_REASON, B.TWO_REASON;
    作者时间：yangjin  2017-09-27
    */
  BEGIN
    SP_NAME          := 'MEMBER_LABEL_PKG.MEMBER_INJURED_PERIOD'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'MEMBER_LABEL_LINK'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    --IN_POSTING_DATE  := TO_DATE(IN_POSTING_DATE_KEY, 'YYYYMMDD');
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.END_TIME := SYSDATE;
        S_ETL.ERR_MSG  := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
      /*打伤害期标签*/
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
                          FROM (SELECT RANK() OVER(PARTITION BY A.MEMBER_KEY ORDER BY A.ORDER_KEY DESC) RANK1, /*RANK1=1为最新订单，判断此订单是否拒退*/
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
                                              /*非个人原因*/
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
                   AND /*如果已经打上伤害期标签则不重复打*/
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
    
      /*取消伤害期标签*/
      DELETE MEMBER_LABEL_LINK C
       WHERE C.M_LABEL_ID = 167
         AND EXISTS
       (SELECT 1
                FROM (SELECT DISTINCT A.MEMBER_KEY
                        FROM FACT_ORDER A
                       WHERE A.POSTING_DATE_KEY = IN_POSTING_DATE_KEY
                            /*判断会员的最后一笔订购是否是有效订购*/
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
                            /*判断是否在MEMBER_LABEL_LINK有记录*/
                         AND EXISTS
                       (SELECT 1
                                FROM MEMBER_LABEL_LINK B
                               WHERE B.M_LABEL_ID = 167
                                 AND A.MEMBER_KEY = B.MEMBER_KEY)) D
               WHERE C.MEMBER_KEY = D.MEMBER_KEY);
      DELETE_ROWS := SQL%ROWCOUNT;
      COMMIT;
    END;
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_DEL := DELETE_ROWS;
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
  END MEMBER_INJURED_PERIOD;

  PROCEDURE WEBSITE_LOSS_SCORE(IN_POSTING_DATE_KEY IN NUMBER) IS
    S_ETL               W_ETL_LOG%ROWTYPE;
    SP_NAME             S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER         S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS         NUMBER;
    DELETE_ROWS         NUMBER;
    IN_POSTING_DATE     DATE;
    IN_30_DAYS_DATE_KEY NUMBER;
    IN_60_DAYS_DATE_KEY NUMBER;
    /*
    功能说明： EVERYDAY_SEE               每日必看（近30天活跃天数大于15天（注册日期大于30天））
               OCCASIONALLY_SEE           偶偶来来（近30天内活跃天数少于4天（注册日期大于30天））
               REGISTERED_LESS_ONE_MONTH  近一个月注册用户（注册日期小于等于30天）
               ACTIVE                     活跃（近30天有活跃记录的用户（注册日期大于30天））
               MAYBE_LOSS                 浅流失（30天到60天有行为记录用户（注册日期大于30天））
               DEEP_LOSS                  深度流失（60天以上有行为记录用户（注册日期大于30天））
    作者时间：yangjin  2017-10-18
    */
  BEGIN
    SP_NAME             := 'MEMBER_LABEL_PKG.WEBSITE_LOSS_SCORE'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME    := 'MEMBER_LABEL_LINK'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME     := SP_NAME;
    S_ETL.START_TIME    := SYSDATE;
    S_PARAMETER         := 0;
    IN_POSTING_DATE     := TO_DATE(IN_POSTING_DATE_KEY, 'YYYYMMDD');
    IN_30_DAYS_DATE_KEY := TO_CHAR(TRUNC(SYSDATE - 30), 'YYYYMMDD');
    IN_60_DAYS_DATE_KEY := TO_CHAR(TRUNC(SYSDATE - 30), 'YYYYMMDD');
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.END_TIME := SYSDATE;
        S_ETL.ERR_MSG  := '没有找到对应的过程加载类型数据';
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
             WHERE M_LABEL_ID BETWEEN 202 AND 207) T
      USING (SELECT G.MEMBER_KEY,
                    H.M_LABEL_ID,
                    H.M_LABEL_TYPE_ID,
                    SYSDATE CREATE_DATE,
                    'yangjin' CREATE_USER_ID,
                    SYSDATE LAST_UPDATE_DATE,
                    'yangjin' LAST_UPDATE_USER_ID
               FROM (SELECT F.MEMBER_KEY,
                            F.CREATE_DATE_KEY,
                            F.MAX_VISIT_DATE_KEY,
                            F.LESS_30_DAYS_ACTIVE,
                            F.MORE_30_DAYS_ACTIVE,
                            CASE
                              WHEN F.CREATE_DATE_KEY >= IN_30_DAYS_DATE_KEY THEN
                               'REGISTERED_LESS_ONE_MONTH'
                              WHEN F.CREATE_DATE_KEY < IN_30_DAYS_DATE_KEY AND
                                   F.LESS_30_DAYS_ACTIVE >= 15 THEN
                               'EVERYDAY_SEE'
                              WHEN F.CREATE_DATE_KEY < IN_30_DAYS_DATE_KEY AND
                                   F.LESS_30_DAYS_ACTIVE >= 4 THEN
                               'OCCASIONALLY_SEE'
                              WHEN F.CREATE_DATE_KEY < IN_30_DAYS_DATE_KEY AND
                                   F.LESS_30_DAYS_ACTIVE > 0 THEN
                               'ACTIVE'
                              WHEN F.CREATE_DATE_KEY < IN_30_DAYS_DATE_KEY AND
                                   F.MORE_30_DAYS_ACTIVE > 0 THEN
                               'MAYBE_LOSS'
                              ELSE
                               'DEEP_LOSS'
                            END MEMBER_LABEL_NAME
                       FROM (SELECT C.MEMBER_KEY,
                                    D.CREATE_DATE_KEY,
                                    C.MAX_VISIT_DATE_KEY,
                                    C.LESS_30_DAYS_ACTIVE,
                                    C.MORE_30_DAYS_ACTIVE
                               FROM (SELECT B.MEMBER_KEY,
                                            MAX(B.VISIT_DATE_KEY) MAX_VISIT_DATE_KEY,
                                            SUM(CASE
                                                  WHEN B.VISIT_DATE_KEY >=
                                                       IN_30_DAYS_DATE_KEY THEN
                                                   1
                                                  ELSE
                                                   0
                                                END) LESS_30_DAYS_ACTIVE, /*近30天*/
                                            SUM(CASE
                                                  WHEN B.VISIT_DATE_KEY <
                                                       IN_30_DAYS_DATE_KEY AND
                                                       B.VISIT_DATE_KEY >=
                                                       IN_60_DAYS_DATE_KEY THEN
                                                   1
                                                  ELSE
                                                   0
                                                END) MORE_30_DAYS_ACTIVE /*30天到60天*/
                                       FROM (SELECT DISTINCT A.VISIT_DATE_KEY,
                                                             A.MEMBER_KEY,
                                                             1 CNT
                                               FROM FACT_PAGE_VIEW A
                                              WHERE A.VISIT_DATE_KEY >=
                                                    TO_CHAR(TRUNC(IN_POSTING_DATE - 65),
                                                            'YYYYMMDD') /*统计最近65天的访问记录*/
                                                AND A.MEMBER_KEY <> 0) B
                                      GROUP BY B.MEMBER_KEY) C,
                                    (SELECT E.MEMBER_BP MEMBER_KEY,
                                            MAX(E.CREATE_DATE_KEY) CREATE_DATE_KEY
                                       FROM DIM_MEMBER E
                                      GROUP BY E.MEMBER_BP) D
                              WHERE C.MEMBER_KEY = D.MEMBER_KEY) F) G,
                    MEMBER_LABEL_HEAD H
              WHERE G.MEMBER_LABEL_NAME = H.M_LABEL_NAME) S
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
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_DEL := DELETE_ROWS;
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
  END WEBSITE_LOSS_SCORE;

  PROCEDURE APP_LOSS_SCORE(IN_POSTING_DATE_KEY IN NUMBER) IS
    S_ETL               W_ETL_LOG%ROWTYPE;
    SP_NAME             S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER         S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS         NUMBER;
    DELETE_ROWS         NUMBER;
    IN_POSTING_DATE     DATE;
    IN_30_DAYS_DATE_KEY NUMBER;
    IN_60_DAYS_DATE_KEY NUMBER;
    /*
    功能说明：  APP_LOSS_SCORE   APP流失评分
                APP_EVERYDAY_SEE               每日必看（近30天活跃天数大于15天（注册日期大于30天））
                APP_OCCASIONALLY_SEE           偶偶来来（近30天内活跃天数少于4天（注册日期大于30天））
                APP_REGISTERED_LESS_ONE_MONTH  近一个月注册用户（注册日期小于等于30天）
                APP_ACTIVE                     活跃（近30天有活跃记录的用户（注册日期大于30天））
                APP_MAYBE_LOSS                 浅流失（30天到60天有行为记录用户（注册日期大于30天））
                APP_DEEP_LOSS                  深度流失（60天以上有行为记录用户（注册日期大于30天））
    作者时间：yangjin  2017-10-19
    */
  BEGIN
    SP_NAME             := 'MEMBER_LABEL_PKG.APP_LOSS_SCORE'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME    := 'MEMBER_LABEL_LINK'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME     := SP_NAME;
    S_ETL.START_TIME    := SYSDATE;
    S_PARAMETER         := 0;
    IN_POSTING_DATE     := TO_DATE(IN_POSTING_DATE_KEY, 'YYYYMMDD');
    IN_30_DAYS_DATE_KEY := TO_CHAR(TRUNC(SYSDATE - 30), 'YYYYMMDD');
    IN_60_DAYS_DATE_KEY := TO_CHAR(TRUNC(SYSDATE - 30), 'YYYYMMDD');
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.END_TIME := SYSDATE;
        S_ETL.ERR_MSG  := '没有找到对应的过程加载类型数据';
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
             WHERE M_LABEL_ID BETWEEN 222 AND 227) T
      USING (SELECT G.MEMBER_KEY,
                    H.M_LABEL_ID,
                    H.M_LABEL_TYPE_ID,
                    SYSDATE CREATE_DATE,
                    'yangjin' CREATE_USER_ID,
                    SYSDATE LAST_UPDATE_DATE,
                    'yangjin' LAST_UPDATE_USER_ID
               FROM (SELECT F.MEMBER_KEY,
                            F.CREATE_DATE_KEY,
                            F.MAX_VISIT_DATE_KEY,
                            F.LESS_30_DAYS_ACTIVE,
                            F.MORE_30_DAYS_ACTIVE,
                            CASE
                              WHEN F.CREATE_DATE_KEY >= IN_30_DAYS_DATE_KEY THEN
                               'APP_REGISTERED_LESS_ONE_MONTH'
                              WHEN F.CREATE_DATE_KEY < IN_30_DAYS_DATE_KEY AND
                                   F.LESS_30_DAYS_ACTIVE >= 15 THEN
                               'APP_EVERYDAY_SEE'
                              WHEN F.CREATE_DATE_KEY < IN_30_DAYS_DATE_KEY AND
                                   F.LESS_30_DAYS_ACTIVE >= 4 THEN
                               'APP_OCCASIONALLY_SEE'
                              WHEN F.CREATE_DATE_KEY < IN_30_DAYS_DATE_KEY AND
                                   F.LESS_30_DAYS_ACTIVE > 0 THEN
                               'APP_ACTIVE'
                              WHEN F.CREATE_DATE_KEY < IN_30_DAYS_DATE_KEY AND
                                   F.MORE_30_DAYS_ACTIVE > 0 THEN
                               'APP_MAYBE_LOSS'
                              ELSE
                               'APP_DEEP_LOSS'
                            END MEMBER_LABEL_NAME
                       FROM (SELECT C.MEMBER_KEY,
                                    D.CREATE_DATE_KEY,
                                    C.MAX_VISIT_DATE_KEY,
                                    C.LESS_30_DAYS_ACTIVE,
                                    C.MORE_30_DAYS_ACTIVE
                               FROM (SELECT B.MEMBER_KEY,
                                            MAX(B.VISIT_DATE_KEY) MAX_VISIT_DATE_KEY,
                                            SUM(CASE
                                                  WHEN B.VISIT_DATE_KEY >=
                                                       IN_30_DAYS_DATE_KEY THEN
                                                   1
                                                  ELSE
                                                   0
                                                END) LESS_30_DAYS_ACTIVE, /*近30天*/
                                            SUM(CASE
                                                  WHEN B.VISIT_DATE_KEY <
                                                       IN_30_DAYS_DATE_KEY AND
                                                       B.VISIT_DATE_KEY >=
                                                       IN_60_DAYS_DATE_KEY THEN
                                                   1
                                                  ELSE
                                                   0
                                                END) MORE_30_DAYS_ACTIVE /*30天到60天*/
                                       FROM (SELECT DISTINCT A.VISIT_DATE_KEY,
                                                             A.MEMBER_KEY,
                                                             1 CNT
                                               FROM FACT_PAGE_VIEW A
                                              WHERE A.APPLICATION_KEY IN
                                                    (10, 20) /*APP*/
                                                AND A.VISIT_DATE_KEY >=
                                                    TO_CHAR(TRUNC(IN_POSTING_DATE - 65),
                                                            'YYYYMMDD') /*统计最近65天的访问记录*/
                                                AND A.MEMBER_KEY <> 0) B
                                      GROUP BY B.MEMBER_KEY) C,
                                    (SELECT E.MEMBER_BP MEMBER_KEY,
                                            MAX(E.CREATE_DATE_KEY) CREATE_DATE_KEY
                                       FROM DIM_MEMBER E
                                      GROUP BY E.MEMBER_BP) D
                              WHERE C.MEMBER_KEY = D.MEMBER_KEY) F) G,
                    MEMBER_LABEL_HEAD H
              WHERE G.MEMBER_LABEL_NAME = H.M_LABEL_NAME
                AND H.M_LABEL_ID BETWEEN 222 AND 227) S
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
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_DEL := DELETE_ROWS;
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
  END APP_LOSS_SCORE;

  PROCEDURE WX_LOSS_SCORE(IN_POSTING_DATE_KEY IN NUMBER) IS
    S_ETL               W_ETL_LOG%ROWTYPE;
    SP_NAME             S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER         S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS         NUMBER;
    DELETE_ROWS         NUMBER;
    IN_POSTING_DATE     DATE;
    IN_30_DAYS_DATE_KEY NUMBER;
    IN_60_DAYS_DATE_KEY NUMBER;
    /*
    功能说明：  WX_LOSS_SCORE   微信流失评分
                WX_EVERYDAY_SEE               每日必看（近30天活跃天数大于15天（注册日期大于30天））
                WX_OCCASIONALLY_SEE           偶偶来来（近30天内活跃天数少于4天（注册日期大于30天））
                WX_REGISTERED_LESS_ONE_MONTH  近一个月注册用户（注册日期小于等于30天）
                WX_ACTIVE                     活跃（近30天有活跃记录的用户（注册日期大于30天））
                WX_MAYBE_LOSS                 浅流失（30天到60天有行为记录用户（注册日期大于30天））
                WX_DEEP_LOSS                  深度流失（60天以上有行为记录用户（注册日期大于30天））
    作者时间：yangjin  2017-10-19
    */
  BEGIN
    SP_NAME             := 'MEMBER_LABEL_PKG.WX_LOSS_SCORE'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME    := 'MEMBER_LABEL_LINK'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME     := SP_NAME;
    S_ETL.START_TIME    := SYSDATE;
    S_PARAMETER         := 0;
    IN_POSTING_DATE     := TO_DATE(IN_POSTING_DATE_KEY, 'YYYYMMDD');
    IN_30_DAYS_DATE_KEY := TO_CHAR(TRUNC(SYSDATE - 30), 'YYYYMMDD');
    IN_60_DAYS_DATE_KEY := TO_CHAR(TRUNC(SYSDATE - 30), 'YYYYMMDD');
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.END_TIME := SYSDATE;
        S_ETL.ERR_MSG  := '没有找到对应的过程加载类型数据';
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
             WHERE M_LABEL_ID BETWEEN 229 AND 234) T
      USING (SELECT G.MEMBER_KEY,
                    H.M_LABEL_ID,
                    H.M_LABEL_TYPE_ID,
                    SYSDATE CREATE_DATE,
                    'yangjin' CREATE_USER_ID,
                    SYSDATE LAST_UPDATE_DATE,
                    'yangjin' LAST_UPDATE_USER_ID
               FROM (SELECT F.MEMBER_KEY,
                            F.CREATE_DATE_KEY,
                            F.MAX_VISIT_DATE_KEY,
                            F.LESS_30_DAYS_ACTIVE,
                            F.MORE_30_DAYS_ACTIVE,
                            CASE
                              WHEN F.CREATE_DATE_KEY >= IN_30_DAYS_DATE_KEY THEN
                               'WX_REGISTERED_LESS_ONE_MONTH'
                              WHEN F.CREATE_DATE_KEY < IN_30_DAYS_DATE_KEY AND
                                   F.LESS_30_DAYS_ACTIVE >= 15 THEN
                               'WX_EVERYDAY_SEE'
                              WHEN F.CREATE_DATE_KEY < IN_30_DAYS_DATE_KEY AND
                                   F.LESS_30_DAYS_ACTIVE >= 4 THEN
                               'WX_OCCASIONALLY_SEE'
                              WHEN F.CREATE_DATE_KEY < IN_30_DAYS_DATE_KEY AND
                                   F.LESS_30_DAYS_ACTIVE > 0 THEN
                               'WX_ACTIVE'
                              WHEN F.CREATE_DATE_KEY < IN_30_DAYS_DATE_KEY AND
                                   F.MORE_30_DAYS_ACTIVE > 0 THEN
                               'WX_MAYBE_LOSS'
                              ELSE
                               'WX_DEEP_LOSS'
                            END MEMBER_LABEL_NAME
                       FROM (SELECT C.MEMBER_KEY,
                                    D.CREATE_DATE_KEY,
                                    C.MAX_VISIT_DATE_KEY,
                                    C.LESS_30_DAYS_ACTIVE,
                                    C.MORE_30_DAYS_ACTIVE
                               FROM (SELECT B.MEMBER_KEY,
                                            MAX(B.VISIT_DATE_KEY) MAX_VISIT_DATE_KEY,
                                            SUM(CASE
                                                  WHEN B.VISIT_DATE_KEY >=
                                                       IN_30_DAYS_DATE_KEY THEN
                                                   1
                                                  ELSE
                                                   0
                                                END) LESS_30_DAYS_ACTIVE, /*近30天*/
                                            SUM(CASE
                                                  WHEN B.VISIT_DATE_KEY <
                                                       IN_30_DAYS_DATE_KEY AND
                                                       B.VISIT_DATE_KEY >=
                                                       IN_60_DAYS_DATE_KEY THEN
                                                   1
                                                  ELSE
                                                   0
                                                END) MORE_30_DAYS_ACTIVE /*30天到60天*/
                                       FROM (SELECT DISTINCT A.VISIT_DATE_KEY,
                                                             A.MEMBER_KEY,
                                                             1 CNT
                                               FROM FACT_PAGE_VIEW A
                                              WHERE A.APPLICATION_KEY = 50 /*微信*/
                                                AND A.VISIT_DATE_KEY >=
                                                    TO_CHAR(TRUNC(IN_POSTING_DATE - 65),
                                                            'YYYYMMDD') /*统计最近65天的访问记录*/
                                                AND A.MEMBER_KEY <> 0) B
                                      GROUP BY B.MEMBER_KEY) C,
                                    (SELECT E.MEMBER_BP MEMBER_KEY,
                                            MAX(E.CREATE_DATE_KEY) CREATE_DATE_KEY
                                       FROM DIM_MEMBER E
                                      GROUP BY E.MEMBER_BP) D
                              WHERE C.MEMBER_KEY = D.MEMBER_KEY) F) G,
                    MEMBER_LABEL_HEAD H
              WHERE G.MEMBER_LABEL_NAME = H.M_LABEL_NAME
                AND H.M_LABEL_ID BETWEEN 229 AND 234) S
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
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_DEL := DELETE_ROWS;
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
  END WX_LOSS_SCORE;

  PROCEDURE MERGE_PUSH_MSG_LOG IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    DELETE_ROWS NUMBER;
    /*
    功能说明：  从push_msg_log_tmp把数据插入push_msg_log
    作者时间：yangjin  2017-11-21
    */
  BEGIN
    SP_NAME          := 'MEMBER_LABEL_PKG.MERGE_PUSH_MSG_LOG'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'PUSH_MSG_LOG'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.END_TIME := SYSDATE;
        S_ETL.ERR_MSG  := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
      /*task_type=1 openid*/
      UPDATE PUSH_MSG_LOG_TMP A
         SET A.MEMBER_BP =
             (SELECT B.MEMBER_KEY
                FROM (SELECT C.MEMBER_KEY,
                             C.OPEN_ID,
                             ROW_NUMBER() OVER(PARTITION BY C.OPEN_ID ORDER BY C.CREATE_DATE_KEY DESC) RANK1
                        FROM DIM_MAPPING_MEM C) B
               WHERE A.SEND_MEMBER = B.OPEN_ID
                 AND B.RANK1 = 1)
       WHERE A.TASK_TYPE = 1
         AND A.MEMBER_BP IS NULL
         AND EXISTS (SELECT 1
                FROM (SELECT E.MEMBER_KEY,
                             E.OPEN_ID,
                             ROW_NUMBER() OVER(PARTITION BY E.OPEN_ID ORDER BY E.CREATE_DATE_KEY DESC) RANK1
                        FROM DIM_MAPPING_MEM E) D
               WHERE A.SEND_MEMBER = D.OPEN_ID
                 AND D.RANK1 = 1);
      COMMIT;
    
      /*task_type=3 member_bp*/
      UPDATE PUSH_MSG_LOG_TMP A
         SET A.MEMBER_BP = TO_NUMBER(TRIM(TRAILING CHR(9) FROM A.SEND_MEMBER))
       WHERE A.TASK_TYPE = 3
         AND A.MEMBER_BP IS NULL;
      COMMIT;
    
      /*push_msg_log_tmp-->push_msg_log*/
      MERGE /*+APPEND*/
      INTO PUSH_MSG_LOG T
      USING (SELECT A.ID,
                    A.TASK_ID,
                    A.TASK_TYPE,
                    A.SEND_MEMBER,
                    A.MEMBER_BP,
                    A.PUSH_STATE,
                    A.PUSH_MESSAGE,
                    A.RESULT_MESSAGE,
                    A.CREATE_TIME,
                    A.START_TIME,
                    A.END_TIME,
                    A.PUSH_DELAY,
                    A.PUSH_THREAD_ID,
                    A.REMARK,
                    SYSDATE          W_INSERT_DT,
                    SYSDATE          W_UPDATE_DT
               FROM PUSH_MSG_LOG_TMP A) S
      ON (T.ID = S.ID)
      WHEN MATCHED THEN
        UPDATE
           SET T.TASK_ID        = S.TASK_ID,
               T.TASK_TYPE      = S.TASK_TYPE,
               T.SEND_MEMBER    = S.SEND_MEMBER,
               T.MEMBER_BP      = S.MEMBER_BP,
               T.PUSH_STATE     = S.PUSH_STATE,
               T.PUSH_MESSAGE   = S.PUSH_MESSAGE,
               T.RESULT_MESSAGE = S.RESULT_MESSAGE,
               T.CREATE_TIME    = S.CREATE_TIME,
               T.START_TIME     = S.START_TIME,
               T.END_TIME       = S.END_TIME,
               T.PUSH_DELAY     = S.PUSH_DELAY,
               T.PUSH_THREAD_ID = S.PUSH_THREAD_ID,
               T.REMARK         = S.REMARK,
               T.W_UPDATE_DT    = S.W_UPDATE_DT
      WHEN NOT MATCHED THEN
        INSERT
          (T.ID,
           T.TASK_ID,
           T.TASK_TYPE,
           T.SEND_MEMBER,
           T.MEMBER_BP,
           T.PUSH_STATE,
           T.PUSH_MESSAGE,
           T.RESULT_MESSAGE,
           T.CREATE_TIME,
           T.START_TIME,
           T.END_TIME,
           T.PUSH_DELAY,
           T.PUSH_THREAD_ID,
           T.REMARK,
           T.W_INSERT_DT,
           T.W_UPDATE_DT)
        VALUES
          (S.ID,
           S.TASK_ID,
           S.TASK_TYPE,
           S.SEND_MEMBER,
           S.MEMBER_BP,
           S.PUSH_STATE,
           S.PUSH_MESSAGE,
           S.RESULT_MESSAGE,
           S.CREATE_TIME,
           S.START_TIME,
           S.END_TIME,
           S.PUSH_DELAY,
           S.PUSH_THREAD_ID,
           S.REMARK,
           S.W_INSERT_DT,
           S.W_UPDATE_DT);
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    END;
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_DEL := DELETE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '无输入参数';
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
  END MERGE_PUSH_MSG_LOG;

  PROCEDURE MERGE_PUSH_TASK_RULE IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    DELETE_ROWS NUMBER;
    /*
    功能说明：  从push_task_rule_tmp把数据插入push_task_rule
    作者时间：yangjin  2017-11-30
    */
  BEGIN
    SP_NAME          := 'MEMBER_LABEL_PKG.MERGE_PUSH_TASK_RULE'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'PUSH_TASK_RULE'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.END_TIME := SYSDATE;
        S_ETL.ERR_MSG  := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
      /*push_task_rule_tmp-->push_task_rule*/
      MERGE /*+APPEND*/
      INTO PUSH_TASK_RULE T
      USING (SELECT A.ID,
                    A.TASK_NAME,
                    A.TASK_TYPE,
                    A.ADD_TIME,
                    A.START_TIME,
                    A.MEMBER_GROUP_ID,
                    A.MSG_T_ID,
                    A.MSG_CONTENT,
                    A.TASK_STAUTS,
                    A.RUN_RECORDS,
                    A.RESULT_RECORDS,
                    A.FAIL_RECORDS,
                    A.REMARK,
                    SYSDATE           W_INSERT_DT,
                    SYSDATE           W_UPDATE_DT
               FROM PUSH_TASK_RULE_TMP A) S
      ON (T.ID = S.ID)
      WHEN MATCHED THEN
        UPDATE
           SET T.TASK_NAME       = S.TASK_NAME,
               T.TASK_TYPE       = S.TASK_TYPE,
               T.ADD_TIME        = S.ADD_TIME,
               T.START_TIME      = S.START_TIME,
               T.MEMBER_GROUP_ID = S.MEMBER_GROUP_ID,
               T.MSG_T_ID        = S.MSG_T_ID,
               T.MSG_CONTENT     = S.MSG_CONTENT,
               T.TASK_STAUTS     = S.TASK_STAUTS,
               T.RUN_RECORDS     = S.RUN_RECORDS,
               T.RESULT_RECORDS  = S.RESULT_RECORDS,
               T.FAIL_RECORDS    = S.FAIL_RECORDS,
               T.REMARK          = S.REMARK,
               T.W_UPDATE_DT     = S.W_UPDATE_DT
      WHEN NOT MATCHED THEN
        INSERT
          (T.ID,
           T.TASK_NAME,
           T.TASK_TYPE,
           T.ADD_TIME,
           T.START_TIME,
           T.MEMBER_GROUP_ID,
           T.MSG_T_ID,
           T.MSG_CONTENT,
           T.TASK_STAUTS,
           T.RUN_RECORDS,
           T.RESULT_RECORDS,
           T.FAIL_RECORDS,
           T.REMARK,
           T.W_INSERT_DT,
           T.W_UPDATE_DT)
        VALUES
          (S.ID,
           S.TASK_NAME,
           S.TASK_TYPE,
           S.ADD_TIME,
           S.START_TIME,
           S.MEMBER_GROUP_ID,
           S.MSG_T_ID,
           S.MSG_CONTENT,
           S.TASK_STAUTS,
           S.RUN_RECORDS,
           S.RESULT_RECORDS,
           S.FAIL_RECORDS,
           S.REMARK,
           S.W_INSERT_DT,
           S.W_UPDATE_DT);
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    END;
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_DEL := DELETE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '无输入参数';
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
  END MERGE_PUSH_TASK_RULE;

  PROCEDURE MESSAGE_PUSH_LABEL IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    DELETE_ROWS NUMBER;
    /*
    功能说明：  从push_msg_log_tmp把数据插入push_msg_log
    作者时间：yangjin  2017-11-21
    */
  BEGIN
    SP_NAME          := 'MEMBER_LABEL_PKG.MESSAGE_PUSH_LABEL'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'MEMBER_LABEL_LINK'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.END_TIME := SYSDATE;
        S_ETL.ERR_MSG  := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
      /*打上标签*/
      /*
      WX_IN_7DAYS  微信推送(7天内),399
      SMS_IN_7DAYS 短息推送(7天内),400
      APP_IN_7DAYS APP推送(7天内) ,401
      */
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
             WHERE M_LABEL_ID BETWEEN 399 AND 401) T
      USING (SELECT G.MEMBER_KEY,
                    H.M_LABEL_ID,
                    H.M_LABEL_TYPE_ID,
                    SYSDATE CREATE_DATE,
                    'yangjin' CREATE_USER_ID,
                    SYSDATE LAST_UPDATE_DATE,
                    'yangjin' LAST_UPDATE_USER_ID
               FROM (SELECT B.MEMBER_BP MEMBER_KEY,
                            CASE
                              WHEN B.TASK_TYPE = 1 THEN
                               'WX_IN_7DAYS' /*微信推送*/
                              WHEN B.TASK_TYPE = 2 THEN
                               'SMS_IN_7DAYS' /*短信推送*/
                              WHEN B.TASK_TYPE = 3 THEN
                               'APP_IN_7DAYS' /*APP推送*/
                            END MEMBER_LABEL_NAME
                       FROM (SELECT A.MEMBER_BP,
                                    A.TASK_TYPE,
                                    MAX(A.CREATE_TIME)
                               FROM PUSH_MSG_LOG A
                              WHERE A.CREATE_TIME >= SYSDATE - 7 /*7天内*/
                                AND A.PUSH_STATE = 10 /*推送成功才打上标签*/
                                AND A.MEMBER_BP IS NOT NULL /*BP号不为空*/
                              GROUP BY A.MEMBER_BP, A.TASK_TYPE) B) G,
                    MEMBER_LABEL_HEAD H
              WHERE G.MEMBER_LABEL_NAME = H.M_LABEL_NAME) S
      ON (T.MEMBER_KEY = S.MEMBER_KEY AND T.M_LABEL_ID = S.M_LABEL_ID)
      WHEN MATCHED THEN
        UPDATE
           SET T.LAST_UPDATE_DATE    = SYSDATE,
               T.LAST_UPDATE_USER_ID = 'yangjin'
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
    
      /*删除标签，当最后一次推送消息的时间大于7天时*/
      /*
      WX_IN_7DAYS  微信推送(7天内),399
      SMS_IN_7DAYS 短息推送(7天内),400
      APP_IN_7DAYS APP推送(7天内) ,401
      */
      DELETE MEMBER_LABEL_LINK A
       WHERE A.M_LABEL_ID BETWEEN 399 AND 401
         AND NOT EXISTS (SELECT 1
                FROM (SELECT C.MEMBER_BP MEMBER_KEY,
                             CASE
                               WHEN C.TASK_TYPE = 1 THEN
                                399
                               WHEN C.TASK_TYPE = 2 THEN
                                400
                               WHEN C.TASK_TYPE = 3 THEN
                                401
                             END M_LABEL_ID
                        FROM PUSH_MSG_LOG C
                       WHERE C.CREATE_TIME >= SYSDATE - 7) B
               WHERE A.MEMBER_KEY = B.MEMBER_KEY
                 AND A.M_LABEL_ID = B.M_LABEL_ID);
      DELETE_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
    END;
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_DEL := DELETE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '无输入参数';
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
  END MESSAGE_PUSH_LABEL;

END MEMBER_LABEL_PKG;
/
