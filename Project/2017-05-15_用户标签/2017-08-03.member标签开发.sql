/*Consumption characteristics indicators 
消费特征指标*/

--************************************************************************
--新建标签
--************************************************************************
begin
  -- Call the procedure
  member_label_pkg.create_member_label(in_m_label_name      => 'PAYMENT_MOST_COD',
                                       in_m_label_desc      => '大金额COD小金额在线支付',
                                       in_m_label_type_id   => 1,
                                       in_m_label_father_id => 121);
end;
/

--************************************************************************
--直播商品忠诚度(PRODUCT_LOYALTY)
--************************************************************************
/*
只买播出商品(ONLY_BROADCAST)
只买TV商品(ONLY_TV)
只买电商提报商品(ONLY_ONLINE_RETAIL)
只买自营商品(SELF_SALES)
只买非自营商品(NON_SELF_SALES)
混合型(MIXED_CUSTOMER)
*/
INSERT
  INTO MEMBER_LABEL_HEAD(M_LABEL_ID, M_LABEL_NAME, M_LABEL_DESC, M_LABEL_TYPE_ID, M_LABEL_FATHER_ID, CREATE_DATE, CREATE_USER_ID, LAST_UPDATE_DATE, LAST_UPDATE_USER_ID, CURRENT_FLAG)
  SELECT MEMBER_LABEL_HEAD_SEQ.NEXTVAL, /*M_LABEL_ID*/
         'MIXED_CUSTOMER', /*M_LABEL_NAME*/
         '混合型', /*M_LABEL_DESC*/
         null, /*M_LABEL_TYPE_ID*/
         2, /*M_LABEL_FATHER_ID*/
         sysdate, /*CREATE_DATE*/
         'yangjin', /*CREATE_USER_ID*/
         sysdate, /*LAST_UPDATE_DATE*/
         'yangjin', /*LAST_UPDATE_USER_ID*/
         1 /*CURRENT_FLAG*/
    FROM DUAL;

--只买播出商品(ONLY_BROADCAST)
INSERT INTO MEMBER_LABEL_LINK
  (MEMBER_KEY,
   M_LABEL_ID,
   M_LABEL_TYPE_ID,
   CREATE_DATE,
   CREATE_USER_ID,
   LAST_UPDATE_DATE,
   LAST_UPDATE_USER_ID)
  SELECT D.MEMBER_KEY,
         3 M_LABEL_ID,
         1 M_LABEL_TYPE_ID,
         SYSDATE CREATE_DATE,
         'yangjin' CREATE_USER_ID,
         SYSDATE LAST_UPDATE_DATE,
         'yangjin' LAST_UPDATE_USER_ID
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
                                 TO_CHAR(TRUNC(SYSDATE - 181), 'YYYYMMDD')
                             AND A.ORDER_STATE = 1
                             AND A.TRAN_TYPE = 0) SALES,
                         (SELECT B.ITEM_CODE, B.TV_STARTDAY_KEY, 1 IS_BCST /*是否播出*/
                            FROM DIM_TV_GOOD B
                           WHERE B.IS_LIVE = '直播'
                             AND B.TV_STARTDAY_KEY >=
                                 TO_CHAR(TRUNC(SYSDATE - 181), 'YYYYMMDD')) TV_GOOD
                   WHERE SALES.POSTING_DATE_KEY = TV_GOOD.TV_STARTDAY_KEY(+)
                     AND SALES.GOODS_COMMON_KEY = TV_GOOD.ITEM_CODE(+)) C
           GROUP BY C.MEMBER_KEY) D
   WHERE /*用户订购单数大于4单时启用*/
   D.ORDER_COUNT >= 4
  /*订购商品达到70%以上是播出商品时认为是只买播出商品用户*/
   AND D.BCST_ITEM_COUNT / D.ITEM_COUNT >= 0.7;

--************************************************************************
--常用端口(Common port)
--************************************************************************
/*
APP(COMMON_PORT_APP)(10,20,)
微信(COMMON_PORT_WX)(50)
WAP(COMMON_PORT_WAP)(30)
PC(COMMON_PORT_PC)(40)
无规律(COMMON_PORT_VARIETY)
*/
--fact_session.application_key
INSERT INTO MEMBER_LABEL_LINK
  (MEMBER_KEY,
   M_LABEL_ID,
   M_LABEL_TYPE_ID,
   CREATE_DATE,
   CREATE_USER_ID,
   LAST_UPDATE_DATE,
   LAST_UPDATE_USER_ID)
  SELECT F.MEMBER_KEY,
         G.M_LABEL_ID,
         G.M_LABEL_TYPE_ID,
         SYSDATE CREATE_DATE,
         'yangjin' CREATE_USER_ID,
         sysdate LAST_UPDATE_DATE,
         'yangjin' LAST_UPDATE_USER_ID
    FROM (SELECT E.MEMBER_KEY, SUBSTR(MAX(E.MAX_PER_PORT), 3) COMMON_PORT
            FROM (SELECT D.MEMBER_KEY,
                         D.COMMON_PORT,
                         D.FREQ,
                         D.TOTAL_FREQ,
                         D.FREQ / D.TOTAL_FREQ PORT_PER,
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
                                                 TO_CHAR(TRUNC(SYSDATE - 180),
                                                         'YYYYMMDD') AND
                                                 TO_CHAR(TRUNC(SYSDATE - 1),
                                                         'YYYYMMDD')
                                             AND A.MEMBER_KEY <> 0) B
                                   WHERE B.COMMON_PORT IS NOT NULL
                                   GROUP BY B.MEMBER_KEY, B.COMMON_PORT) C) D
                   WHERE D.TOTAL_FREQ >= 4) E
           GROUP BY E.MEMBER_KEY) F,
         MEMBER_LABEL_HEAD G
   WHERE G.M_LABEL_FATHER_ID = 21
     AND F.COMMON_PORT = G.M_LABEL_NAME;

--常用端口重构
MERGE /*+APPEND*/
INTO (SELECT MEMBER_KEY,
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
                              /*端口占比大于70%为常用端口*/
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
                                                      TO_CHAR(TRUNC(&IN_POSTING_DATE - 179),
                                                              'YYYYMMDD') AND
                                                      TO_CHAR(TRUNC(&IN_POSTING_DATE),
                                                              'YYYYMMDD') /*统计180天数据*/
                                                  AND A.MEMBER_KEY <> 0
                                                     /*只对当天浏览的会员计算常用端口*/
                                                  AND EXISTS
                                                (SELECT 1
                                                         FROM FACT_SESSION H
                                                        WHERE A.MEMBER_KEY =
                                                              H.MEMBER_KEY
                                                          AND H.START_DATE_KEY =
                                                              &IN_POSTING_DATE_KEY)) B
                                        WHERE B.COMMON_PORT IS NOT NULL
                                        GROUP BY B.MEMBER_KEY, B.COMMON_PORT) C) D
                        WHERE D.TOTAL_FREQ >= 4) E
                GROUP BY E.MEMBER_KEY) F,
              MEMBER_LABEL_HEAD G
        WHERE G.M_LABEL_FATHER_ID = 21
          AND F.COMMON_PORT = G.M_LABEL_NAME) S
ON (T.MEMBER_KEY = S.MEMBER_KEY)
WHEN MATCHED THEN
  UPDATE SET T.M_LABEL_ID = S.M_LABEL_ID, T.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN
  INSERT
    (T.MEMBER_KEY,
     T.M_LABEL_ID,
     T.M_LABEL_TYPE_ID,
     T.CREATE_DATE,
     T.CREATE_USER_ID,
     T.LAST_UPDATE_DATE,
     T.LAST_UPDATE_USER_ID)
  VALUES
    (S.MEMBER_KEY, S.M_LABEL_ID, 1, SYSDATE, 'yangjin', SYSDATE, 'yangjin');

SELECT * FROM MEMBER_LABEL_HEAD A ORDER BY A.M_LABEL_ID;

--************************************************************************
--首单状态(first order)
--************************************************************************     
/*
未产生首单(first_order_not)
首单为新人礼(first_order_gift)(订单金额少于30元都算新人礼)
首单为TV播出商品(first_order_broadcast)
首单为TV非播出商品(first_order_not_broadcast)
首单为自营商品(first_order_self)
首单为BBC商品(first_order_BBC)
首单标签应该每日刷新，当一个用户注册之后，就应该打上首单标签。当一个用户第一次订购之后，首单标签就不会再变动了。
自营商品只在电商销售
先满足新人礼，然后才是其他标签。
*/

--重新刷新历史数据
DECLARE
  IN_DATE_INT NUMBER(8);
  IN_DATE     DATE;
  BEGIN_DATE  DATE := DATE '2017-01-01';
  END_DATE    DATE := DATE '2017-08-21';
BEGIN
  IN_DATE := BEGIN_DATE;
  WHILE IN_DATE <= END_DATE LOOP
    IN_DATE_INT := TO_CHAR(IN_DATE, 'YYYYMMDD');
    MEMBER_LABEL_PKG.FIRST_ORDER_MAIN(IN_DATE_INT);
    IN_DATE := IN_DATE + 1;
  END LOOP;
END;
/

INSERT
  INTO MEMBER_LABEL_LINK(MEMBER_KEY, M_LABEL_ID, M_LABEL_TYPE_ID, CREATE_DATE, CREATE_USER_ID, LAST_UPDATE_DATE, LAST_UPDATE_USER_ID)
  SELECT D.MEMBER_KEY,
         E.M_LABEL_ID,
         E.M_LABEL_TYPE_ID,
         SYSDATE CREATE_DATE,
         'yangjin' CREATE_USER_ID,
         SYSDATE LAST_UPDATE_DATE,
         'yangjin' LAST_UPDATE_USER_ID
    FROM (SELECT A.MEMBER_KEY
            FROM FACT_VISITOR_REGISTER A
           WHERE A.MEMBER_KEY <> 0
             AND A.CREATE_DATE_KEY = &IN_POSTING_DATE_KEY
             AND NOT EXISTS (SELECT 1
                    FROM (SELECT C.MEMBER_KEY
                            FROM FACT_GOODS_SALES C
                           WHERE C.ORDER_STATE = 1) B
                   WHERE A.MEMBER_KEY = B.MEMBER_KEY)) D,
         MEMBER_LABEL_HEAD E
   WHERE E.M_LABEL_NAME = 'FIRST_ORDER_NOT';

--首单订购金额最大的商品
SELECT A.MEMBER_KEY, A.ORDER_KEY, A.GOODS_COMMON_KEY, A.ORDER_AMOUNT
  FROM FACT_GOODS_SALES A
 WHERE A.ORDER_STATE = 1
   AND A.GOODS_COMMON_KEY IS NOT NULL
   AND EXISTS (SELECT 1
          FROM (SELECT C.MEMBER_KEY, MIN(C.ORDER_KEY) ORDER_KEY
                  FROM FACT_GOODS_SALES C
                 WHERE C.ORDER_STATE = 1
                   AND C.GOODS_COMMON_KEY IS NOT NULL
                 GROUP BY C.MEMBER_KEY) B
         WHERE A.MEMBER_KEY = B.MEMBER_KEY
           AND A.ORDER_KEY = B.ORDER_KEY)
   AND EXISTS (SELECT 1
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
   AND A.MEMBER_KEY = 1103386002;

--DIM_GOOD商品分类(TV播出商品,TV非播出商品,自营商品,BBC商品)
/*
首单为TV播出商品(FIRST_ORDER_BROADCAST)
首单为TV非播出商品(FIRST_ORDER_NOT_BROADCAST)
首单为自营商品(FIRST_ORDER_SELF)
首单为BBC商品(FIRST_ORDER_BBC)
*/
SELECT A.ITEM_CODE,
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
          'OTHER'
       END ITEM_LABEL
  FROM DIM_GOOD A
 WHERE A.CURRENT_FLG = 'Y';

--************************************************************************
--会员等级（member_level）
--************************************************************************   
merge into (select *
              from member_label_link
             where m_label_id in (62, 63, 64, 65, 66, 67, 68)) t
using (select member_bp,
              case
                when member_level = 'HAPP_T0' then
                 62
                when member_level = 'HAPP_T1' then
                 63
                when member_level = 'HAPP_T2' then
                 64
                when member_level = 'HAPP_T3' then
                 65
                when member_level = 'HAPP_T4' then
                 66
                when member_level = 'HAPP_T5' then
                 67
                when member_level = 'HAPP_T6' then
                 68
              end member_level_id
         from dim_member
        where ch_date_key = 20170828
          AND MEMBER_LEVEL IS NOT NULL) s
on (t.member_key = s.member_bp)
when matched then
  update set t.m_label_id = s.member_level_id, t.last_update_date = sysdate
when not matched then
  insert
    (t.member_key,
     t.m_label_id,
     t.m_label_type_id,
     t.create_date,
     t.create_user_id,
     t.last_update_date,
     t.last_update_user_id)
  values
    (s.member_bp,
     s.member_level_id,
     1,
     sysdate,
     'yangjin',
     sysdate,
     'yangjin');

--重新刷新历史数据
--jobid:1543
DECLARE
  IN_DATE_INT NUMBER(8);
  IN_DATE     DATE;
  BEGIN_DATE  DATE := DATE '2014-10-24';
  END_DATE    DATE := DATE '2017-08-28';
BEGIN
  IN_DATE := BEGIN_DATE;
  WHILE IN_DATE <= END_DATE LOOP
    IN_DATE_INT := TO_CHAR(IN_DATE, 'YYYYMMDD');
    MEMBER_LABEL_PKG.MEMBER_LEVEL(IN_DATE_INT);
    IN_DATE := IN_DATE + 1;
  END LOOP;
END;
/

  SELECT COUNT(1)
    FROM MEMBER_LABEL_LINK_V A
   WHERE A.m_label_id BETWEEN 62 AND 68;

SELECT * FROM DIM_MEMBER A WHERE A.CH_DATE_KEY = 20170829;
SELECT A.CH_DATE_KEY, COUNT(A.MEMBER_BP)
  FROM DIM_MEMBER A
 WHERE A.MEMBER_LEVEL IS NOT NULL
 GROUP BY A.CH_DATE_KEY
 ORDER BY 1;
SELECT *
  FROM W_ETL_LOG A
 WHERE A.PROC_NAME = 'MEMBER_LABEL_PKG.MEMBER_LEVEL'
 ORDER BY A.START_TIME DESC;
SELECT 'CALL MEMBER_LABEL_PKG.MEMBER_LEVEL(' || B.CH_DATE_KEY || ');'
  FROM (SELECT DISTINCT A.CH_DATE_KEY
          FROM DIM_MEMBER A
         WHERE A.MEMBER_LEVEL IS NOT NULL
         ORDER BY 1) B;

--************************************************************************
--复购周期（REPURCHASE_CYCLE）
--REPURCHASE_CYCLE_LEVEL_1:-1
--REPURCHASE_CYCLE_LEVEL_2:0~30
--REPURCHASE_CYCLE_LEVEL_3:30~60
--REPURCHASE_CYCLE_LEVEL_4:60~90
--REPURCHASE_CYCLE_LEVEL_5:>90
--************************************************************************
MERGE /*+APPEND*/
INTO (SELECT MEMBER_KEY,
             M_LABEL_ID,
             M_LABEL_TYPE_ID,
             CREATE_DATE,
             CREATE_USER_ID,
             LAST_UPDATE_DATE,
             LAST_UPDATE_USER_ID
        FROM MEMBER_LABEL_LINK
       WHERE M_LABEL_ID IN (102, 103, 104, 105, 106)) T
USING (SELECT A.MEMBER_BP,
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
                 FROM FACT_GOODS_SALES B
                WHERE B.POSTING_DATE_KEY = 20170831
                  AND A.MEMBER_BP = B.MEMBER_KEY)) S
ON (T.MEMBER_KEY = S.MEMBER_BP)
WHEN MATCHED THEN
  UPDATE
     SET T.M_LABEL_ID       = S.REPURCHASE_CYCLE_LEVEL,
         T.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN
  INSERT
    (T.MEMBER_KEY,
     T.M_LABEL_ID,
     T.M_LABEL_TYPE_ID,
     T.CREATE_DATE,
     T.CREATE_USER_ID,
     T.LAST_UPDATE_DATE,
     T.LAST_UPDATE_USER_ID)
  VALUES
    (S.MEMBER_BP,
     S.REPURCHASE_CYCLE_LEVEL,
     1,
     SYSDATE,
     'yangjin',
     SYSDATE,
     'yangjin');

--重新刷新历史数据
--job:1763
DECLARE
  IN_DATE_INT NUMBER(8);
  IN_DATE     DATE;
  BEGIN_DATE  DATE := DATE '2017-09-01';
  END_DATE    DATE := DATE '2017-09-05';
BEGIN
  IN_DATE := BEGIN_DATE;
  WHILE IN_DATE <= END_DATE LOOP
    IN_DATE_INT := TO_CHAR(IN_DATE, 'YYYYMMDD');
    MEMBER_LABEL_PKG.MEMBER_REPURCHASE(IN_DATE_INT);
    IN_DATE := IN_DATE + 1;
  END LOOP;
END;
/

  SELECT A.CREATE_DATE, COUNT(1)
    FROM MEMBER_LABEL_LINK A
   WHERE A.M_LABEL_ID IN (102, 103, 104, 105, 106)
   GROUP BY A.CREATE_DATE
   ORDER BY 1;

SELECT M_LABEL_ID, COUNT(1)
  FROM MEMBER_LABEL_LINK
 WHERE M_LABEL_ID IN (102, 103, 104, 105, 106)
 GROUP BY M_LABEL_ID;

SELECT COUNT(DISTINCT B.MEMBER_KEY)
  FROM FACT_GOODS_SALES B
 WHERE B.POSTING_DATE_KEY = 20170831;

SELECT A.MEMBER_BP,
       MEMBER_LABEL_PKG.MEMBER_REPURCHASE_CYCLE_DAYS(A.MEMBER_BP) REPURCHASE_CYCLE_DAYS
  FROM DIM_MEMBER A
 WHERE MEMBER_LABEL_PKG.MEMBER_REPURCHASE_CYCLE_DAYS(A.MEMBER_BP) < -1;

SELECT A.MEMBER_BP,
       MEMBER_LABEL_PKG.MEMBER_REPURCHASE_CYCLE_DAYS(A.MEMBER_BP) REPURCHASE_CYCLE_DAYS
  FROM DIM_MEMBER A
 WHERE A.MEMBER_BP = 1206699065;

SELECT A.MEMBER_KEY,
       TO_DATE(A.POSTING_DATE_KEY, 'yyyymmdd') POSTING_DATE,
       A.ORDER_KEY
  FROM FACT_ORDER A
 WHERE A.ORDER_STATE = 1
   AND A.MEMBER_KEY = 1206699065
   AND A.POSTING_DATE_KEY >= 20160101
 ORDER BY A.ORDER_KEY;

SELECT A.MEMBER_KEY, COUNT(1)
  FROM FACT_ORDER A
 WHERE A.ORDER_STATE = 1
   AND A.POSTING_DATE_KEY >= 20160101
 GROUP BY A.MEMBER_KEY
 ORDER BY COUNT(1) DESC;

--************************************************************************
--支付方式（PAYMENT_METHOD）
--常用COD(PAYMENT_COD)
--常用支付宝(PAYMENT_ALIPAY)
--常用微信支付(PAYMENT_WX)
--常用银行卡支付(PAYMENT_BANKCARD)
--在线支付(PAYMENT_ONLINE)
--无规律(PAYMENT_)
--大金额COD小金额在线支付()
--************************************************************************
INSERT INTO MEMBER_LABEL_LINK
  (MEMBER_KEY,
   M_LABEL_ID,
   M_LABEL_TYPE_ID,
   CREATE_DATE,
   CREATE_USER_ID,
   LAST_UPDATE_DATE,
   LAST_UPDATE_USER_ID)
  SELECT DISTINCT E.MEMBER_KEY,
                  FIRST_VALUE(E.PAYMENT_LABEL) OVER(PARTITION BY E.MEMBER_KEY ORDER BY E.RANK1) FINAL_PAYMENT_LABEL,
                  1 M_LABEL_TYPE_ID,
                  SYSDATE CREATE_DATE,
                  'yangjin' LAST_UPDATE_DATE,
                  SYSDATE LAST_UPDATE_DATE,
                  'yangjin'
    FROM (SELECT D.MEMBER_KEY,
                 D.PAYMENT_METHOD,
                 D.ORDER_AMOUNT,
                 D.RANK1,
                 D.TOTAL_ORDER_AMOUNT,
                 CASE
                   WHEN D.RANK1 = 1 AND
                        D.TOTAL_ORDER_AMOUNT <= D.ORDER_AMOUNT * 2 THEN
                    D.PAYMENT_METHOD
                   WHEN D.PAYMENT_METHOD IN
                        ('PAYMENT_BANKCARD', 'PAYMENT_ALIPAY', 'PAYMENT_WX') AND
                        (SUM(D.ORDER_AMOUNT) OVER(PARTITION BY D.MEMBER_KEY)) >
                        D.TOTAL_ORDER_AMOUNT * 0.5 THEN
                    'PAYMENT_ONLINE'
                 END PAYMENT_LABEL
            FROM (SELECT C.MEMBER_KEY,
                         C.PAYMENT_METHOD,
                         C.ORDER_AMOUNT,
                         RANK() OVER(PARTITION BY C.MEMBER_KEY ORDER BY C.ORDER_AMOUNT DESC) RANK1,
                         SUM(C.ORDER_AMOUNT) OVER(PARTITION BY C.MEMBER_KEY) TOTAL_ORDER_AMOUNT
                    FROM (SELECT B.MEMBER_KEY,
                                 B.PAYMENT_METHOD,
                                 SUM(B.ORDER_AMOUNT) ORDER_AMOUNT
                            FROM (SELECT A.CUST_NO MEMBER_KEY,
                                         A.ADD_TIME,
                                         TO_CHAR(A.ORDER_SN) ORDER_NO,
                                         CASE
                                           WHEN UPPER(A.PAYMENTCHANNEL) = '线下支付' OR
                                                A.PAYMENTCHANNEL IS NULL THEN
                                            'PAYMENT_COD'
                                           WHEN UPPER(A.PAYMENTCHANNEL) IN
                                                ('ALIPAY_M',
                                                 'ALIPAY_W',
                                                 'ALIPAY_WAP',
                                                 '支付宝') THEN
                                            'PAYMENT_ALIPAY'
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
                                            'PAYMENT_WX'
                                           WHEN UPPER(A.PAYMENTCHANNEL) IN
                                                ('CMB', 'CMBYWT_M') THEN
                                            'PAYMENT_BANKCARD'
                                         END PAYMENT_METHOD,
                                         A.ORDER_AMOUNT
                                    FROM FACT_EC_ORDER A
                                   WHERE A.ORDER_STATE >= 20
                                        /*日期条件-180天*/
                                     AND A.ADD_TIME BETWEEN
                                         TO_CHAR(TRUNC(&IN_POSTING_DATE - 179),
                                                 'YYYYMMDD') AND
                                         TO_CHAR(TRUNC(&IN_POSTING_DATE),
                                                 'YYYYMMDD')) B
                           WHERE B.PAYMENT_METHOD IS NOT NULL
                          /*AND B.MEMBER_KEY IN (605012428,
                          609077796,
                          610101190,
                          702166098,
                          703183040,
                          801434175,
                          809741462,
                          908123536,
                          909098339,
                          911154849,
                          1012122476,
                          1012127052,
                          1109856615,
                          1112063129,
                          1112119002,
                          1204488658,
                          1205613145,
                          1208840328,
                          1305769347,
                          1309127925,
                          1411368315,
                          1500035714,
                          1500899369,
                          1500997331,
                          1501008302,
                          1501080464,
                          1501321220,
                          1501384727,
                          1501401545,
                          1501695595,
                          1501848884,
                          1600204436,
                          1603674724,
                          1609204301,
                          1610754952,
                          1612996783)*/
                           GROUP BY B.MEMBER_KEY, B.PAYMENT_METHOD) C) D) E
   WHERE E.PAYMENT_LABEL IS NOT NULL;

--支付方式重构
MERGE /*+APPEND*/
INTO (SELECT MEMBER_KEY,
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
                              /*最大金额的支付方式如果超过50%，则此支付方式为常用支付方式*/
                                WHEN D.RANK1 = 1 AND
                                     D.TOTAL_ORDER_AMOUNT <= D.ORDER_AMOUNT * 2 THEN
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
                                                      TO_CHAR(TRUNC(&IN_POSTING_DATE - 179),
                                                              'YYYYMMDD') AND
                                                      TO_CHAR(TRUNC(&IN_POSTING_DATE),
                                                              'YYYYMMDD')
                                                     /*只计算当天有效订购的会员的常用支付方式*/
                                                  AND EXISTS
                                                (SELECT 1
                                                         FROM FACT_EC_ORDER H
                                                        WHERE H.ADD_TIME =
                                                              &IN_POSTING_DATE_KEY
                                                          AND H.ORDER_STATE >= 20
                                                          AND A.CUST_NO =
                                                              H.CUST_NO)) B
                                        WHERE B.PAYMENT_METHOD IS NOT NULL
                                        GROUP BY B.MEMBER_KEY, B.PAYMENT_METHOD) C) D) E
                WHERE E.PAYMENT_LABEL IS NOT NULL) F,
              MEMBER_LABEL_HEAD G
        WHERE G.M_LABEL_ID BETWEEN 122 AND 125
          AND F.FINAL_PAYMENT_LABEL = G.M_LABEL_NAME) S
ON (T.MEMBER_KEY = S.MEMBER_KEY)
WHEN MATCHED THEN
  UPDATE SET T.M_LABEL_ID = S.M_LABEL_ID, T.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN
  INSERT
    (T.MEMBER_KEY,
     T.M_LABEL_ID,
     T.M_LABEL_TYPE_ID,
     T.CREATE_DATE,
     T.CREATE_USER_ID,
     T.LAST_UPDATE_DATE,
     T.LAST_UPDATE_USER_ID)
  VALUES
    (S.MEMBER_KEY, S.M_LABEL_ID, 1, SYSDATE, 'yangjin', SYSDATE, 'yangjin');

--支付方式重构2
INSERT INTO MEMBER_LABEL_LINK
  (MEMBER_KEY,
   M_LABEL_ID,
   M_LABEL_TYPE_ID,
   CREATE_DATE,
   CREATE_USER_ID,
   LAST_UPDATE_DATE,
   LAST_UPDATE_USER_ID)
  SELECT F.MEMBER_KEY,
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
                                D.ORDER_AMOUNT >= D.TOTAL_ORDER_AMOUNT * 0.6 THEN
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
                                   GROUP BY B.MEMBER_KEY, B.PAYMENT_METHOD) C) D) E
           WHERE E.PAYMENT_LABEL IS NOT NULL
                /*剔除掉订购金额=0的member*/
             AND E.TOTAL_ORDER_AMOUNT > 0) F,
         MEMBER_LABEL_HEAD G
   WHERE G.M_LABEL_ID = 141
     AND F.PAYMENT_LABEL = G.M_LABEL_NAME;

SELECT * FROM MEMBER_LABEL_HEAD A ORDER BY A.M_LABEL_ID;

--*************************************************************************************************************
/*
MEMBER_LIFE_PERIOD   用户生命周期
NEW_CUSTOMER_PERIOD  新客（未产生订购（包括总订购））
TRIAL_PERIOD         尝试期（产生订购但未产生有效订购）
UNDERSTANDING_PERIOD 了解期（产生1~3比有效订购）
BELIEVE_PERIOD       相信期（产生4到6比有效订购）
GOOD_FRIEND_PERIOD   好朋友期（产生7比以上有效订购）
INJURED_PERIOD       被伤害期（产生非个人原因拒退、客诉后未产生有效订购。）
*/
--*************************************************************************************************************
--用户生命周期
MERGE /*+APPEND*/
INTO (SELECT MEMBER_KEY,
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
                         'NEW_CUSTOMER_PERIOD'
                        WHEN G.ORDER_STATE = 0 THEN
                         'TRIAL_PERIOD'
                        WHEN G.ORDER_STATE = 1 AND G.ORDER_COUNT BETWEEN 1 AND 3 THEN
                         'UNDERSTANDING_PERIOD'
                        WHEN G.ORDER_STATE = 1 AND G.ORDER_COUNT BETWEEN 4 AND 6 THEN
                         'BELIEVE_PERIOD'
                        WHEN G.ORDER_STATE = 1 AND G.ORDER_COUNT >= 7 THEN
                         'GOOD_FRIEND_PERIOD'
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
                                         FROM (SELECT D.MEMBER_BP
                                                 FROM DIM_MEMBER D
                                                WHERE D.MEMBER_INSERT_DATE =
                                                      20170501) A,
                                              (SELECT C.MEMBER_KEY,
                                                      C.ORDER_KEY,
                                                      C.ORDER_STATE
                                                 FROM FACT_ORDER C
                                                WHERE C.POSTING_DATE_KEY >=
                                                      20160101) B
                                        WHERE A.MEMBER_BP = B.MEMBER_KEY(+)) E
                                GROUP BY E.MEMBER_BP, E.ORDER_STATE) F) G) H,
              MEMBER_LABEL_HEAD I
        WHERE I.M_LABEL_ID BETWEEN 162 AND 166
          AND H.MEMBER_LIFE_PERIOD = I.M_LABEL_NAME) S
ON (T.MEMBER_KEY = S.MEMBER_KEY)
WHEN MATCHED THEN
  UPDATE SET T.M_LABEL_ID = S.M_LABEL_ID, T.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN
  INSERT
    (T.MEMBER_KEY,
     T.M_LABEL_ID,
     T.M_LABEL_TYPE_ID,
     T.CREATE_DATE,
     T.CREATE_USER_ID,
     T.LAST_UPDATE_DATE,
     T.LAST_UPDATE_USER_ID)
  VALUES
    (S.MEMBER_KEY, S.M_LABEL_ID, 1, SYSDATE, 'yangjin', SYSDATE, 'yangjin');

--被伤害期(产生非个人原因拒退、客诉后未产生有效订购)
/*
非个人原因拒退之后打上被伤害期标签，如果会员随后产生了有效订购，那么去掉被伤害期标签
*/
--打伤害期标签
INSERT INTO MEMBER_LABEL_LINK
  (MEMBER_KEY,
   M_LABEL_ID,
   M_LABEL_TYPE_ID,
   CREATE_DATE,
   CREATE_USER_ID,
   LAST_UPDATE_DATE,
   LAST_UPDATE_USER_ID)
  SELECT E.MEMBER_KEY,
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
                                   WHERE POSTING_DATE_KEY = 20170926) A,
                                 (SELECT *
                                    FROM FACT_ORDER_REVERSE
                                   WHERE POSTING_DATE_KEY = 20170926) B
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

/*取消伤害期标签*/
DELETE MEMBER_LABEL_LINK C
 WHERE EXISTS
 (SELECT 1
          FROM (SELECT A.MEMBER_KEY
                  FROM FACT_ORDER A
                 WHERE A.POSTING_DATE_KEY = IN_POSTING_DATE_KEY
                      /*判断会员的最后一笔订购是否是有效订购*/
                   AND A.ORDER_STATE = 1
                   AND EXISTS
                 (SELECT 1
                          FROM (SELECT F.MEMBER_KEY, MAX(F.ORDER_KEY) ORDER_KEY
                                  FROM FACT_ORDER F
                                 WHERE F.POSTING_DATE_KEY = IN_POSTING_DATE_KEY
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

SELECT *
  FROM FACT_ORDER A
 WHERE A.MEMBER_KEY = 1616669434
   AND A.POSTING_DATE_KEY = 20170926;
SELECT *
  FROM FACT_ORDER_REVERSE A
 WHERE A.MEMBER_KEY = 1616669434
   AND A.POSTING_DATE_KEY = 20170926;
SELECT *
  FROM FACT_ORDER A, FACT_ORDER_REVERSE B
 WHERE A.ORDER_KEY = B.ORDER_KEY
   AND A.ORDER_KEY = 5204097541;
SELECT * FROM FACT_ORDER A WHERE A.ORDER_KEY = 5204097541;
SELECT * FROM dim_re_reseaon_1;
SELECT * FROM dim_re_reseaon_2;
SELECT *
  FROM FACT_ORDER A
 WHERE A.POSTING_DATE_KEY = 20170926
   AND A.ORDER_STATE = 1
   AND EXISTS (SELECT 1
          FROM FACT_ORDER_REVERSE B
         WHERE A.MEMBER_KEY = B.MEMBER_KEY
           AND B.CANCEL_STATE = 0
           AND B.POSTING_DATE_KEY = 20170926);
SELECT *
  FROM FACT_ORDER_REVERSE A
 WHERE A.CANCEL_STATE = 0
   AND A.POSTING_DATE_KEY = 20170926
   AND NOT EXISTS (SELECT 1
          FROM FACT_ORDER B
         WHERE B.POSTING_DATE_KEY = 20170926
           AND B.CANCEL_STATE = 0
           AND A.MEMBER_KEY = B.MEMBER_KEY);
--退换货原因
SELECT B.ONE_REASON, C.REASON_NM, B.TWO_REASON, D.REASON_NM
  FROM (SELECT DISTINCT A.ONE_REASON, A.TWO_REASON FROM FACT_ORDER_REVERSE A) B,
       DIM_RE_RESEAON_1 C,
       DIM_RE_RESEAON_2 D
 WHERE B.ONE_REASON = C.CODE
   AND B.TWO_REASON = D.CODE
 ORDER BY B.ONE_REASON, B.TWO_REASON;

--*************************************************************************************************************
/*
WEBSITE_LOSS_SCORE   整站流失评分
EVERYDAY_SEE               每日必看（近30天活跃天数大于15天（注册日期大于30天））
OCCASIONALLY_SEE           偶偶来来（近30天内活跃天数少于4天（注册日期大于30天））
REGISTERED_LESS_ONE_MONTH  近一个月注册用户（注册日期小于等于30天）
ACTIVE                     活跃（近30天有活跃记录的用户（注册日期大于30天））
MAYBE_LOSS                 浅流失（30天到60天有行为记录用户（注册日期大于30天））
DEEP_LOSS                  深度流失（60天以上有行为记录用户（注册日期大于30天））
*/
--*************************************************************************************************************
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
USING (SELECT MEMBER_LABEL_LINK_SEQ.NEXTVAL ROW_ID,
              G.MEMBER_KEY,
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
                        WHEN F.CREATE_DATE_KEY >=
                             TO_CHAR(TRUNC(SYSDATE - 30), 'YYYYMMDD') THEN
                         'REGISTERED_LESS_ONE_MONTH'
                        WHEN F.CREATE_DATE_KEY <
                             TO_CHAR(TRUNC(SYSDATE - 30), 'YYYYMMDD') AND
                             F.LESS_30_DAYS_ACTIVE >= 15 THEN
                         'EVERYDAY_SEE'
                        WHEN F.CREATE_DATE_KEY <
                             TO_CHAR(TRUNC(SYSDATE - 30), 'YYYYMMDD') AND
                             F.LESS_30_DAYS_ACTIVE >= 4 THEN
                         'OCCASIONALLY_SEE'
                        WHEN F.CREATE_DATE_KEY <
                             TO_CHAR(TRUNC(SYSDATE - 30), 'YYYYMMDD') AND
                             F.LESS_30_DAYS_ACTIVE > 0 THEN
                         'ACTIVE'
                        WHEN F.CREATE_DATE_KEY <
                             TO_CHAR(TRUNC(SYSDATE - 30), 'YYYYMMDD') AND
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
                                                 TO_CHAR(TRUNC(SYSDATE - 30),
                                                         'YYYYMMDD') THEN
                                             1
                                            ELSE
                                             0
                                          END) LESS_30_DAYS_ACTIVE,
                                      SUM(CASE
                                            WHEN B.VISIT_DATE_KEY <
                                                 TO_CHAR(TRUNC(SYSDATE - 30),
                                                         'YYYYMMDD') AND
                                                 B.VISIT_DATE_KEY >=
                                                 TO_CHAR(TRUNC(SYSDATE - 60),
                                                         'YYYYMMDD') THEN
                                             1
                                            ELSE
                                             0
                                          END) MORE_30_DAYS_ACTIVE
                                 FROM (SELECT DISTINCT A.VISIT_DATE_KEY,
                                                       A.MEMBER_KEY,
                                                       1 CNT
                                         FROM FACT_PAGE_VIEW A
                                        WHERE A.VISIT_DATE_KEY >=
                                              TO_CHAR(TRUNC(SYSDATE - 65),
                                                      'YYYYMMDD')
                                          AND A.MEMBER_KEY <> 0) B
                                GROUP BY B.MEMBER_KEY) C,
                              (SELECT E.MEMBER_BP MEMBER_KEY, E.CREATE_DATE_KEY
                                 FROM DIM_MEMBER E) D
                        WHERE C.MEMBER_KEY = D.MEMBER_KEY) F) G,
              MEMBER_LABEL_HEAD H
        WHERE G.MEMBER_LABEL_NAME = H.M_LABEL_NAME) S
ON (T.MEMBER_KEY = S.MEMBER_KEY)
WHEN MATCHED THEN
  UPDATE SET T.M_LABEL_ID = S.M_LABEL_ID, T.LAST_UPDATE_DATE = SYSDATE
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

--*************************************************************************************************************
/*
APP_LOSS_SCORE   APP流失评分
APP_EVERYDAY_SEE               每日必看（近30天活跃天数大于15天（注册日期大于30天））
APP_OCCASIONALLY_SEE           偶偶来来（近30天内活跃天数少于4天（注册日期大于30天））
APP_REGISTERED_LESS_ONE_MONTH  近一个月注册用户（注册日期小于等于30天）
APP_ACTIVE                     活跃（近30天有活跃记录的用户（注册日期大于30天））
APP_MAYBE_LOSS                 浅流失（30天到60天有行为记录用户（注册日期大于30天））
APP_DEEP_LOSS                  深度流失（60天以上有行为记录用户（注册日期大于30天））
*/
--*************************************************************************************************************

--*************************************************************************************************************
/*
WX_LOSS_SCORE   微信流失评分
WX_EVERYDAY_SEE               每日必看（近30天活跃天数大于15天（注册日期大于30天））
WX_OCCASIONALLY_SEE           偶偶来来（近30天内活跃天数少于4天（注册日期大于30天））
WX_REGISTERED_LESS_ONE_MONTH  近一个月注册用户（注册日期小于等于30天）
WX_ACTIVE                     活跃（近30天有活跃记录的用户（注册日期大于30天））
WX_MAYBE_LOSS                 浅流失（30天到60天有行为记录用户（注册日期大于30天））
WX_DEEP_LOSS                  深度流失（60天以上有行为记录用户（注册日期大于30天））
*/
--*************************************************************************************************************

--*************************************************************************************************************
/*

MESSAGE_PUSH_LABEL消息已推送标签(7天内),398
WX_IN_7DAYS  微信推送(7天内),399
SMS_IN_7DAYS 短息推送(7天内),400
APP_IN_7DAYS APP推送(7天内),401
*/
--*************************************************************************************************************
--APP_7DAYS APP推送(7天内),401
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
       WHERE M_LABEL_ID = 401) T
USING (SELECT MEMBER_LABEL_LINK_SEQ.NEXTVAL ROW_ID,
              G.MEMBER_KEY,
              H.M_LABEL_ID,
              H.M_LABEL_TYPE_ID,
              SYSDATE CREATE_DATE,
              'yangjin' CREATE_USER_ID,
              SYSDATE LAST_UPDATE_DATE,
              'yangjin' LAST_UPDATE_USER_ID
         FROM (SELECT B.SEND_MEMBER MEMBER_KEY,
                      CASE
                        WHEN B.TASK_TYPE = 3 THEN
                         'APP_IN_7DAYS'
                      END MEMBER_LABEL_NAME
                 FROM (SELECT A.SEND_MEMBER, A.TASK_TYPE, MAX(A.CREATE_TIME)
                         FROM PUSH_MSG_LOG A
                        WHERE A.CREATE_TIME >= SYSDATE - 7
                          AND A.TASK_TYPE = 3
                        GROUP BY A.SEND_MEMBER, A.TASK_TYPE) B) G,
              MEMBER_LABEL_HEAD H
        WHERE G.MEMBER_LABEL_NAME = H.M_LABEL_NAME) S
ON (T.MEMBER_KEY = S.MEMBER_KEY)
WHEN MATCHED THEN
  UPDATE SET T.M_LABEL_ID = S.M_LABEL_ID, T.LAST_UPDATE_DATE = SYSDATE
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

--消息推送执行监控
SELECT *
  FROM (SELECT A.START_TIME,
               A.END_TIME,
               A.ETL_DURATION,
               A.PROC_NAME,
               A.ETL_RECORD_INS,
               A.ETL_RECORD_UPD,
               A.ETL_RECORD_DEL,
               A.ETL_STATUS
          FROM W_ETL_LOG A
         WHERE A.PROC_NAME IN
               ('MEMBER_LABEL_PKG.MERGE_PUSH_MSG_LOG',
                'MEMBER_LABEL_PKG.MESSAGE_PUSH_LABEL')
        UNION ALL
        SELECT B.START_TIME,
               B.END_TIME,
               B.ETL_DURATION,
               B.PROC_NAME,
               B.ETL_RECORD_INS,
               B.ETL_RECORD_UPD,
               B.ETL_RECORD_DEL,
               B.ETL_STATUS
          FROM W_ETL_LOG@ML18 B
         WHERE B.PROC_NAME =
               'MEMBER_FILTER_PKG.SYNC_MEMBER_LABEL_LINK_MSGPUSH') C
 ORDER BY C.START_TIME DESC;


--tmp
SELECT * FROM MEMBER_LABEL_HEAD ORDER BY M_LABEL_ID;
SELECT * FROM MEMBER_LABEL_TYPE;
SELECT * FROM MEMBER_LABEL_LINK;
SELECT * FROM MEMBER_LABEL_LINK_V;
SELECT * FROM MEMBER_LABEL_LOG;

SELECT SYSDATE - 7 FROM DUAL;

SELECT * FROM S_PARAMETERS2 FOR UPDATE;

SELECT * FROM S_PARAMETERS2 FOR UPDATE;
SELECT A.START_TIME,
       A.END_TIME,
       A.ETL_DURATION,
       A.ETL_RECORD_INS,
       A.ETL_STATUS,
       A.ERR_MSG,
       A.PROC_NAME
  FROM W_ETL_LOG A
 WHERE A.PROC_NAME = 'MEMBER_LABEL_PKG.MESSAGE_PUSH_LABEL'
 ORDER BY A.START_TIME DESC;

SELECT A.m_label_id, A.m_label_name, A.m_label_desc, COUNT(1)
  FROM MEMBER_LABEL_LINK_V A
 GROUP BY A.m_label_id, A.m_label_name, A.m_label_desc
 ORDER BY A.m_label_id;

SELECT * FROM MEMBER_LABEL_HEAD FOR UPDATE;
