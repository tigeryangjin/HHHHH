/*
ec会员0-5单订购跟踪
BP号、订购日期、订单编码、优惠方式、渠道、第几单
KLGWX:A20021
KLGAndroid:A20017
KLGiPhone:A20017
KLGPortal:A20020
KLGMPortal:A20022
*/
--BASE基表
CREATE TABLE OPER_EC_MEMBER_TRACK_BASE AS
SELECT C.MEMBER_BP,
       C.ADD_TIME,
       C.ORDER_ID,
       C.APP_NAME,
       C.ORDER_STATE,
       NVL(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(C.PROMOTION_DESC,
                                                        ',{2,4}',
                                                        ','),
                                         '^,',
                                         ''),
                          ',$',
                          ''),
           '无优惠') PROMOTION_DESC
  FROM (SELECT B.MEMBER_BP,
               B.ADD_TIME,
               B.ORDER_ID,
               B.APP_NAME,
               B.ORDER_STATE,
               B.XIANSHI || ',' || B.PML || ',' || B.TV || ',' || B.MANSONG || ',' ||
               B.PAYMENT PROMOTION_DESC
          FROM (SELECT A.MEMBER_BP,
                       A.ADD_TIME,
                       A.ORDER_ID,
                       A.APP_NAME,
                       A.ORDER_STATE,
                       MAX(A.XIANSHI) XIANSHI,
                       MAX(A.PML) PML,
                       MAX(A.TV) TV,
                       MAX(A.MANSONG) MANSONG,
                       MAX(A.PAYMENT) PAYMENT
                  FROM (SELECT OH.CUST_NO MEMBER_BP, /*BP号*/
                               OH.ADD_TIME, /*订单日期*/
                               OH.ORDER_ID, /*订单编号*/
                               OH.APP_NAME, /*渠道*/
                               OH.ORDER_STATE, /*订单状态*/
                               CASE
                                 WHEN OG.GOODS_TYPE = 3 THEN
                                  '限时商品促销'
                               END XIANSHI,
                               CASE
                                 WHEN OG.PML_DISCOUNT <> 0 THEN
                                  '等级减'
                               END PML,
                               CASE
                                 WHEN OG.TV_DISCOUNT_AMOUNT <> 0 THEN
                                  'TV直播立减'
                               END TV,
                               CASE
                                 WHEN OH.DISCOUNT_MANSONG_AMOUNT <> 0 THEN
                                  '满立减'
                               END MANSONG,
                               CASE
                                 WHEN OH.DISCOUNT_PAYMENTWAY_AMOUNT <> 0 OR
                                      OH.DISCOUNT_PAYMENTCHANEL_AMOUNT <> 0 THEN
                                  '支付立减'
                               END PAYMENT /*优惠方式*/
                          FROM FACT_EC_ORDER_2 OH, FACT_EC_ORDER_GOODS OG
                         WHERE OH.ORDER_ID = OG.ORDER_ID
                           AND OH.ADD_TIME >=DATE'2017-01-01') A
                 GROUP BY A.MEMBER_BP,
                          A.ADD_TIME,
                          A.ORDER_ID,
                          A.APP_NAME,
                          A.ORDER_STATE) B) C;

MERGE /*+APPEND*/
INTO EC_NEW_MEMBER_TRACK_BASE T
USING (SELECT C.MEMBER_BP,
              C.ADD_TIME,
              C.ORDER_ID,
              C.APP_NAME,
              C.ORDER_STATE,
              NVL(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(C.PROMOTION_DESC,
                                                               ',{2,4}',
                                                               ','),
                                                '^,',
                                                ''),
                                 ',$',
                                 ''),
                  '无优惠') PROMOTION_DESC
         FROM (SELECT B.MEMBER_BP,
                      B.ADD_TIME,
                      B.ORDER_ID,
                      B.APP_NAME,
                      B.ORDER_STATE,
                      B.XIANSHI || ',' || B.PML || ',' || B.TV || ',' ||
                      B.MANSONG || ',' || B.PAYMENT PROMOTION_DESC
                 FROM (SELECT A.MEMBER_BP,
                              A.ADD_TIME,
                              A.ORDER_ID,
                              A.APP_NAME,
                              A.ORDER_STATE,
                              MAX(A.XIANSHI) XIANSHI,
                              MAX(A.PML) PML,
                              MAX(A.TV) TV,
                              MAX(A.MANSONG) MANSONG,
                              MAX(A.PAYMENT) PAYMENT
                         FROM (SELECT OH.CUST_NO MEMBER_BP, /*BP号*/
                                      OH.ADD_TIME, /*订单日期*/
                                      OH.ORDER_ID, /*订单编号*/
                                      OH.APP_NAME, /*渠道*/
                                      OH.ORDER_STATE, /*订单状态*/
                                      CASE
                                        WHEN OG.GOODS_TYPE = 3 THEN
                                         '限时商品促销'
                                      END XIANSHI,
                                      CASE
                                        WHEN OG.PML_DISCOUNT <> 0 THEN
                                         '等级减'
                                      END PML,
                                      CASE
                                        WHEN OG.TV_DISCOUNT_AMOUNT <> 0 THEN
                                         'TV直播立减'
                                      END TV,
                                      CASE
                                        WHEN OH.DISCOUNT_MANSONG_AMOUNT <> 0 THEN
                                         '满立减'
                                      END MANSONG,
                                      CASE
                                        WHEN OH.DISCOUNT_PAYMENTWAY_AMOUNT <> 0 OR
                                             OH.DISCOUNT_PAYMENTCHANEL_AMOUNT <> 0 THEN
                                         '支付立减'
                                      END PAYMENT /*优惠方式*/
                                 FROM FACT_EC_ORDER_2     OH,
                                      FACT_EC_ORDER_GOODS OG
                                WHERE OH.ORDER_ID = OG.ORDER_ID
                                  AND OH.ADD_TIME BETWEEN I_DATE - 30 AND
                                      I_DATE) A
                        GROUP BY A.MEMBER_BP,
                                 A.ADD_TIME,
                                 A.ORDER_ID,
                                 A.APP_NAME,
                                 A.ORDER_STATE) B) C) S
ON (T.ORDER_ID = S.ORDER_ID)
WHEN MATCHED THEN
  UPDATE
     SET T.MEMBER_BP      = S.MEMBER_BP T.ADD_TIME = S.ADD_TIME,
         T.APP_NAME       = S.APP_NAME,
         T.ORDER_STATE    = S.ORDER_STATE,
         T.PROMOTION_DESC = S.PROMOTION_DESC
WHEN NOT MATCHED THEN
  INSERT
    (T.MEMBER_BP,
     T.ADD_TIME,
     T.ORDER_ID,
     T.APP_NAME,
     T.ORDER_STATE,
     T.PROMOTION_DESC)
  VALUES
    (S.MEMBER_BP,
     S.ADD_TIME,
     S.ORDER_ID,
     S.APP_NAME,
     S.ORDER_STATE,
     S.PROMOTION_DESC);


--计算第几单
CREATE TABLE OPER_EC_MEMBER_TRACK_RANK AS
SELECT B.MEMBER_BP,
       B.ADD_TIME,
       B.ORDER_ID,
       B.APP_NAME,
       B.PROMOTION_DESC,
       B.RANK1
  FROM (SELECT A.MEMBER_BP,
               A.ADD_TIME,
               A.ORDER_ID,
               A.APP_NAME,
               A.PROMOTION_DESC,
               RANK() OVER(PARTITION BY A.MEMBER_BP ORDER BY A.ADD_TIME, A.ORDER_ID) RANK1
          FROM EC_NEW_MEMBER_TRACK_BASE A
         WHERE A.ORDER_STATE >= 30) B
 WHERE B.RANK1 <= 5;

TRUNCATE TABLE EC_NEW_MEMBER_TRACK_RANK;
INSERT INTO EC_NEW_MEMBER_TRACK_RANK A
  (A.MEMBER_BP,
   A.ADD_TIME,
   A.ORDER_ID,
   A.APP_NAME,
   A.PROMOTION_DESC,
   A.RANK1)
  SELECT B.MEMBER_BP,
         B.ADD_TIME,
         B.ORDER_ID,
         B.APP_NAME,
         B.PROMOTION_DESC,
         B.RANK1
    FROM (SELECT A.MEMBER_BP,
                 A.ADD_TIME,
                 A.ORDER_ID,
                 A.APP_NAME,
                 A.PROMOTION_DESC,
                 RANK() OVER(PARTITION BY A.MEMBER_BP ORDER BY A.ADD_TIME, A.ORDER_ID) RANK1
            FROM EC_NEW_MEMBER_TRACK_BASE A
           WHERE A.ORDER_STATE >= 30) B
   WHERE B.RANK1 <= 5;
COMMIT;



--TMP
SELECT * FROM FACT_ECMEMBER;
SELECT * FROM FACT_EC_ORDER;
SELECT * FROM FACT_EC_ORDER_2;
SELECT * FROM FACT_EC_ORDER_GOODS;
SELECT * FROM EC_NEW_MEMBER_ORDER_TRACK_BASE A WHERE A.ORDER_ID=  1596211;
SELECT DISTINCT A.APP_NAME FROM FACT_EC_ORDER A;
SELECT * FROM ALL_ALL_TABLES A WHERE UPPER(A.table_name) LIKE '%MEMBER%';
SELECT * FROM ALL_SOURCE A WHERE UPPER(A.TEXT) LIKE '%FACT_EC_ORDER%';
SELECT * FROM FACT_EC_ORDER_2 A WHERE A.REFUND_STATE <> 0;
SELECT DISTINCT A.REFUND_STATE FROM FACT_EC_ORDER_2 A;
SELECT * FROM S_PARAMETERS2 FOR UPDATE;
