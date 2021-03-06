SELECT TRUNC(OH.ADD_TIME) ADD_TIME, /*订购日期*/
       NVL(X.XIANSHI_NAME, '限时促销') PROMOTION_NAME, /*促销名称*/
       CASE
         WHEN X.XIANSHI_TYPE = 1 THEN
          '限时直降'
         WHEN X.XIANSHI_TYPE = 2 THEN
          '限时抢'
         WHEN X.XIANSHI_TYPE = 3 THEN
          'TV直减'
         ELSE
          '限时促销'
       END PROMOTION_TYPE, /*促销类型*/
       CASE
         WHEN X.CRM_POLICY_ID = '0' THEN
          '新媒体'
         WHEN X.CRM_POLICY_ID <> '0' THEN
          '同步促销'
         ELSE
          '新媒体'
       END PROMOTION_SOURCE, /*促销来源*/
       NVL(X.CRM_POLICY_ID, 0) PROMOTION_NO, /*促销编号*/
       CASE
         WHEN OH.APP_NAME = 'KLGiPhone' THEN
          'APP'
         WHEN OH.APP_NAME = 'KLGAndroid' THEN
          'APP'
         WHEN OH.APP_NAME = 'KLGPortal' THEN
          'WEB'
         WHEN OH.APP_NAME = 'KLGMPortal' THEN
          'WEB'
         WHEN OH.APP_NAME = 'KLGWX' THEN
          '微信'
         WHEN OH.APP_NAME = 'undefined' THEN
          '未知'
       END PATHWAY, /*通路*/
       OG.ERP_CODE ITEM_CODE, /*商品编码*/
       OG.GOODS_NAME ITEM_NAME, /*商品名称*/
       OG.GOODS_NUM SALES_QTY, /*有效订购件数*/
       OG.GOODS_NUM * OG.GOODS_PAY_PRICE SALES_AMOUNT, /*商品有效金额*/
       (NVL(OG.GOODS_PRICE, 0) - NVL(OG.GOODS_PAY_PRICE, 0) -
       NVL(OG.TV_DISCOUNT_AMOUNT, 0) - NVL(OG.APPORTION_PRICE, 0)) *
       OG.GOODS_NUM COMPANY_APPORTION_AMOUNT, /*公司让利*/
       OG.APPORTION_PRICE * OG.GOODS_NUM SUPP_APPORTION_AMOUNT, /*供应商让利*/
       OG.SUPPLIER_ID, /*供应商编码*/
       (NVL(OG.GOODS_PRICE, 0) - NVL(OG.GOODS_PAY_PRICE, 0) -
       NVL(OG.TV_DISCOUNT_AMOUNT, 0)) * OG.GOODS_NUM TOTAL_APPORTION_AMOUNT, /*促销总成本*/
       TO_CHAR(OH.ORDER_SN) ORDER_SN /*订单编码*/
  FROM FACT_EC_ORDER_2         OH,
       FACT_EC_ORDER_GOODS     OG,
       FACT_EC_P_XIANSHI       X,
       FACT_EC_P_XIANSHI_GOODS XG
 WHERE OH.ORDER_ID = OG.ORDER_ID
   AND OG.XIANSHI_GOODS_ID = XG.XIANSHI_GOODS_ID(+)
   AND XG.XIANSHI_ID = X.XIANSHI_ID(+)
      /*有效订购条件*/
   AND OH.ORDER_STATE >= 30
   AND OH.REFUND_STATE = 0
   AND OG.GOODS_TYPE = 3
   AND TRUNC(OH.ADD_TIME) BETWEEN DATE '2017-10-01' AND DATE
 '2017-10-31';

SELECT *
  FROM FACT_EC_ORDER_2         OH,
       FACT_EC_ORDER_GOODS     OG,
       FACT_EC_P_XIANSHI       X,
       FACT_EC_P_XIANSHI_GOODS XG
 WHERE OH.ORDER_ID = OG.ORDER_ID
   AND OG.XIANSHI_GOODS_ID = XG.XIANSHI_GOODS_ID(+)
   AND XG.XIANSHI_ID = X.XIANSHI_ID(+)
      /*有效订购条件*/
   AND OH.ORDER_STATE >= 30
   AND OH.REFUND_STATE = 0
   AND OG.GOODS_TYPE = 3
   AND TRUNC(OH.ADD_TIME) BETWEEN DATE '2017-10-01' AND DATE
 '2017-10-31';
