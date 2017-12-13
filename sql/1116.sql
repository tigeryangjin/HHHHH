SELECT C.MEMBER_BP,
       C.ADD_TIME,
       C.ORDER_ID,
       C.SALES_SOURCE_SECOND_DESC,
       C.ORDER_STATE,
       NVL(C.PROMOTION_DESC, '无优惠') PROMOTION_DESC,
       SYSDATE W_INSERT_DT,
       SYSDATE W_UPDATE_DT
  FROM (SELECT A.MEMBER_BP,
               A.ADD_TIME,
               A.ORDER_ID,
               A.SALES_SOURCE_SECOND_DESC,
               A.ORDER_STATE,
               LISTAGG(A.PROMOTION_DESC, ',') WITHIN GROUP(ORDER BY A.PROMOTION_DESC) PROMOTION_DESC
          FROM (SELECT DISTINCT OH.CUST_NO MEMBER_BP, /*BP号*/
                                OH.ADD_TIME, /*订单日期*/
                                OH.ORDER_ID, /*订单编号*/
                                CASE
                                  WHEN OH.APP_NAME IN
                                       ('KLGAndroid', 'KLGiPhone') THEN
                                   'A20017'
                                  WHEN OH.APP_NAME = 'KLGPortal' THEN
                                   'A20020'
                                  WHEN OH.APP_NAME = 'KLGWX' THEN
                                   'A20021'
                                  WHEN OH.APP_NAME = 'KLGMPortal' THEN
                                   'A20022'
                                END SALES_SOURCE_SECOND_DESC, /*渠道*/
                                OH.ORDER_STATE, /*订单状态*/
                                CASE
                                  WHEN OG.GOODS_TYPE = 3 THEN
                                   '限时商品促销'
                                
                                  WHEN OG.PML_DISCOUNT <> 0 THEN
                                   '等级减'
                                
                                  WHEN OG.TV_DISCOUNT_AMOUNT <> 0 THEN
                                   'TV直播立减'
                                
                                  WHEN OH.DISCOUNT_MANSONG_AMOUNT <> 0 THEN
                                   '满立减'
                                
                                  WHEN OH.DISCOUNT_PAYMENTWAY_AMOUNT <> 0 OR
                                       OH.DISCOUNT_PAYMENTCHANEL_AMOUNT <> 0 THEN
                                   '支付立减'
                                END PROMOTION_DESC /*优惠方式*/
                  FROM FACT_EC_ORDER_2 OH, FACT_EC_ORDER_GOODS OG
                 WHERE OH.ORDER_ID = OG.ORDER_ID
                      /*同步最近一个月数据*/
                   AND OH.ADD_TIME BETWEEN &I_DATE - 30 AND &I_DATE) A
         GROUP BY A.MEMBER_BP,
                  A.ADD_TIME,
                  A.ORDER_ID,
                  A.SALES_SOURCE_SECOND_DESC,
                  A.ORDER_STATE) C
