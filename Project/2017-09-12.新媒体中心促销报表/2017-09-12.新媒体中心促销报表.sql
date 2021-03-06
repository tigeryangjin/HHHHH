
/*
ec_order
ec_order_goods
ec_order_common
ec_p_xianshi
ec_p_xianshi_goods
ec_p_mansong
ec_p_mansong_goods
ec_voucher
ec_voucher_batch
ec_voucher_price

-----------------
ec_order.add_time
ec_order_goods.order_id
ec_order_common.order_id
ec_p_xianshi.xianshi_time
ec_p_xianshi_goods.xianshi_goods_id
ec_p_mansong.start_time
ec_p_mansong_goods.lastupdate_time
ec_voucher.voucher_active_date
ec_voucher_batch.voucher_active_date
ec_voucher_price.voucher_price_id
ec_p_memberlevel_discount*
ec_p_memberlevel_discount_goods*

满送促销：订单级
限时促销：商品级
goods_price-goods_pay_price=商品促销金额
商品促销金额-apportion_price=公司让利
支付满减 是一个独立促销,是固定的，运营不可设置
满立减是运营控制的
等级减促销是公司让利。
order_goods.pml_discount会员等级减金额



*/

--从mysql取数先放入临时表，然后再由临时表去更新正式表
/*create table ec_order_2_tmp as
select * from fact_ec_order_2;

create table ec_order_goods_tmp as
SELECT * FROM fact_ec_order_goods;

create table ec_order_common_tmp as
SELECT * FROM fact_ec_order_common;

create table ec_p_xianshi_tmp as
SELECT * FROM fact_ec_p_xianshi;

create table ec_p_xianshi_goods_tmp as
SELECT * FROM fact_ec_p_xianshi_goods;

create table ec_p_mansong_tmp as
SELECT * FROM fact_ec_p_mansong;

create table ec_p_mansong_goods_tmp as
SELECT * FROM fact_ec_p_mansong_goods;

create table ec_voucher_tmp as
SELECT * FROM fact_ec_voucher;

create table ec_voucher_batch_tmp as
SELECT * FROM fact_ec_voucher_batch;

create table ec_voucher_price_tmp as
SELECT * FROM fact_ec_voucher_price;*/

--
SELECT * FROM ec_order_2_tmp;
SELECT * FROM ec_order_goods_tmp;
SELECT * FROM ec_order_common_tmp;
SELECT * FROM ec_p_xianshi_tmp;
SELECT * FROM ec_p_xianshi_goods_tmp;
SELECT * FROM ec_p_mansong_tmp;
SELECT * FROM ec_p_mansong_goods_tmp;
SELECT * FROM ec_voucher_tmp;
SELECT * FROM ec_voucher_batch_tmp;
SELECT * FROM ec_voucher_price_tmp;

--
SELECT * FROM fact_ec_order_2;
SELECT * FROM fact_ec_order_goods;
SELECT * FROM fact_ec_order_common;
SELECT * FROM fact_ec_p_xianshi;
SELECT * FROM fact_ec_p_xianshi_goods;
SELECT * FROM fact_ec_p_mansong;
SELECT * FROM fact_ec_p_mansong_goods;
SELECT * FROM fact_ec_voucher;
SELECT * FROM fact_ec_voucher_batch;
SELECT * FROM fact_ec_voucher_price;

SELECT COUNT(1) FROM fact_ec_order_2;
SELECT COUNT(1) FROM fact_ec_order_goods;
SELECT COUNT(1) FROM fact_ec_order_common;
SELECT COUNT(1) FROM fact_ec_p_xianshi;
SELECT COUNT(1) FROM fact_ec_p_xianshi_goods;
SELECT COUNT(1) FROM fact_ec_p_mansong;
SELECT COUNT(1) FROM fact_ec_p_mansong_goods;
SELECT COUNT(1) FROM fact_ec_voucher;
SELECT COUNT(1) FROM fact_ec_voucher_batch;
SELECT COUNT(1) FROM fact_ec_voucher_price;

SELECT COUNT(1) FROM ec_order_2_tmp;
SELECT COUNT(1) FROM ec_order_goods_tmp;
SELECT COUNT(1) FROM ec_order_common_tmp;
SELECT COUNT(1) FROM ec_p_xianshi_tmp;
SELECT COUNT(1) FROM ec_p_xianshi_goods_tmp;
SELECT COUNT(1) FROM ec_p_mansong_tmp;
SELECT COUNT(1) FROM ec_p_mansong_goods_tmp;
SELECT COUNT(1) FROM ec_voucher_tmp;
SELECT COUNT(1) FROM ec_voucher_batch_tmp;
SELECT COUNT(1) FROM ec_voucher_price_tmp;

select round(order_id, -5), count(1)
  from fact_ec_order_2
 group by round(order_id, -5)
 order by 1;

--report
--商品级促销
CREATE TABLE OPER_NM_PROMOTION_ITEM_REPORT AS
  SELECT TRUNC(OH.ADD_TIME) ADD_TIME,
         X.XIANSHI_NAME PROMOTION_NAME, --促销名称
         CASE
           WHEN X.XIANSHI_TYPE = 1 THEN
            '限时直降'
           WHEN X.XIANSHI_TYPE = 2 THEN
            '限时抢'
           WHEN X.XIANSHI_TYPE = 3 THEN
            'TV直减'
         END PROMOTION_TYPE, --促销类型
         CASE
           WHEN X.CRM_POLICY_ID = '0' THEN
            '新媒体'
           WHEN X.CRM_POLICY_ID <> '0' THEN
            '同步促销'
         END PROMOTION_SOURCE, --促销来源
         X.CRM_POLICY_ID PROMOTION_NO, --促销编号
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
         END PATHWAY, --通路
         OG.ERP_CODE ITEM_CODE, --商品编码
         OG.GOODS_NAME ITEM_NAME, --商品名称
         OG.GOODS_NUM SALES_QTY, --有效订购件数
         OG.GOODS_NUM * OG.GOODS_PAY_PRICE SALES_AMOUNT, --商品有效金额 
         (OG.GOODS_PRICE - OG.GOODS_PAY_PRICE - OG.APPORTION_PRICE) *
         OG.GOODS_NUM COMPANY_APPORTION_AMOUNT, --公司让利
         OG.APPORTION_PRICE * OG.GOODS_NUM SUPP_APPORTION_AMOUNT, --供应商让利
         OG.SUPPLIER_ID, --供应商编码
         (OG.GOODS_PRICE - OG.GOODS_PAY_PRICE) * OG.GOODS_NUM TOTAL_APPORTION_AMOUNT,
         TO_CHAR(OH.ORDER_SN) ORDER_SN --订单编码
    FROM FACT_EC_ORDER_2 OH,
         /*FACT_EC_ORDER_COMMON    OC,*/
         FACT_EC_ORDER_GOODS     OG,
         FACT_EC_P_XIANSHI       X,
         FACT_EC_P_XIANSHI_GOODS XG
   WHERE /*OH.ORDER_ID = OC.ORDER_ID
         AND*/
   OH.ORDER_ID = OG.ORDER_ID
   AND OG.XIANSHI_GOODS_ID = XG.XIANSHI_GOODS_ID
   AND X.XIANSHI_ID = XG.XIANSHI_ID
  /*有效订购条件*/
   AND OH.ORDER_STATE >= 30
   AND OH.REFUND_STATE = 0
  /*AND TRUNC(OH.ADD_TIME) = DATE '2017-09-17'*/
  ;

--商品级促销-等级减
SELECT TRUNC(OH.ADD_TIME) ADD_TIME, /*订购日期*/
       OG.PML_TITLE PROMOTION_NAME, /*促销名称*/
       '等级减' PROMOTION_TYPE, /*促销类型*/
       '新媒体' PROMOTION_SOURCE, /*促销来源*/
       OG.PML_ID PROMOTION_NO, /*促销编号*/
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
       OG.PML_DISCOUNT * OG.GOODS_NUM COMPANY_APPORTION_AMOUNT, /*公司让利*/
       NVL(OG.APPORTION_PRICE, 0) * OG.GOODS_NUM SUPP_APPORTION_AMOUNT, /*供应商让利*/
       OG.SUPPLIER_ID, /*供应商编码*/
       OG.PML_DISCOUNT * OG.GOODS_NUM TOTAL_APPORTION_AMOUNT, /*促销总成本*/
       TO_CHAR(OH.ORDER_SN) ORDER_SN /*订单编码*/
  FROM FACT_EC_ORDER_2         OH,
       FACT_EC_ORDER_GOODS     OG
 WHERE OH.ORDER_ID = OG.ORDER_ID
      /*有效订购条件*/
   AND OH.ORDER_STATE >= 30
   AND OH.REFUND_STATE = 0
	 AND OG.PML_DISCOUNT<>0
   AND TRUNC(OH.ADD_TIME) = &IN_POSTING_DATE;

--商品级促销-等级减-历史数据补全
INSERT INTO OPER_NM_PROMOTION_ITEM_REPORT
  (ADD_TIME,
   PROMOTION_NAME,
   PROMOTION_TYPE,
   PROMOTION_SOURCE,
   PROMOTION_NO,
   PATHWAY,
   ITEM_CODE,
   ITEM_NAME,
   SALES_QTY,
   SALES_AMOUNT,
   COMPANY_APPORTION_AMOUNT,
   SUPP_APPORTION_AMOUNT,
   SUPPLIER_ID,
   TOTAL_APPORTION_AMOUNT,
   ORDER_SN)
  SELECT TRUNC(OH.ADD_TIME) ADD_TIME, /*订购日期*/
         OG.PML_TITLE PROMOTION_NAME, /*促销名称*/
         '等级减' PROMOTION_TYPE, /*促销类型*/
         '新媒体' PROMOTION_SOURCE, /*促销来源*/
         OG.PML_ID PROMOTION_NO, /*促销编号*/
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
         OG.PML_DISCOUNT * OG.GOODS_NUM COMPANY_APPORTION_AMOUNT, /*公司让利*/
         NVL(OG.APPORTION_PRICE, 0) * OG.GOODS_NUM SUPP_APPORTION_AMOUNT, /*供应商让利*/
         OG.SUPPLIER_ID, /*供应商编码*/
         OG.PML_DISCOUNT * OG.GOODS_NUM TOTAL_APPORTION_AMOUNT, /*促销总成本*/
         TO_CHAR(OH.ORDER_SN) ORDER_SN /*订单编码*/
    FROM FACT_EC_ORDER_2 OH, FACT_EC_ORDER_GOODS OG
   WHERE OH.ORDER_ID = OG.ORDER_ID
        /*有效订购条件*/
     AND OH.ORDER_STATE >= 30
     AND OH.REFUND_STATE = 0
     AND OG.PML_DISCOUNT <> 0
   ORDER BY TRUNC(OH.ADD_TIME), OG.ERP_CODE;

--商品级促销-TV直播立减促销-历史输入补入
INSERT INTO OPER_NM_PROMOTION_ITEM_REPORT
  (ADD_TIME,
   PROMOTION_NAME,
   PROMOTION_TYPE,
   PROMOTION_SOURCE,
   PROMOTION_NO,
   PATHWAY,
   ITEM_CODE,
   ITEM_NAME,
   SALES_QTY,
   SALES_AMOUNT,
   COMPANY_APPORTION_AMOUNT,
   SUPP_APPORTION_AMOUNT,
   SUPPLIER_ID,
   TOTAL_APPORTION_AMOUNT,
   ORDER_SN)
  SELECT TRUNC(OH.ADD_TIME) ADD_TIME, /*订购日期*/
         '网站特享在线订购直播商品立减' PROMOTION_NAME, /*促销名称*/
         'TV直播立减' PROMOTION_TYPE, /*促销类型*/
         '新媒体' PROMOTION_SOURCE, /*促销来源*/
         '' PROMOTION_NO, /*促销编号*/
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
         OG.TV_DISCOUNT_AMOUNT * OG.GOODS_NUM COMPANY_APPORTION_AMOUNT, /*公司让利*/
         NVL(OG.APPORTION_PRICE, 0) * OG.GOODS_NUM SUPP_APPORTION_AMOUNT, /*供应商让利*/
         OG.SUPPLIER_ID, /*供应商编码*/
         OG.TV_DISCOUNT_AMOUNT * OG.GOODS_NUM TOTAL_APPORTION_AMOUNT, /*促销总成本*/
         TO_CHAR(OH.ORDER_SN) ORDER_SN /*订单编码*/
    FROM FACT_EC_ORDER_2 OH, FACT_EC_ORDER_GOODS OG
   WHERE OH.ORDER_ID = OG.ORDER_ID
        /*有效订购条件*/
     AND OH.ORDER_STATE >= 30
     AND OH.REFUND_STATE = 0
     AND OG.TV_DISCOUNT_AMOUNT <> 0
     AND TRUNC(OH.ADD_TIME) BETWEEN DATE '2017-01-01' AND DATE
   '2017-11-06';
COMMIT;


--订单级促销
/*MANSONG_NAME*/
CREATE TABLE OPER_NM_PROMOTION_ORDER_REPORT AS
  SELECT TRUNC(OH.ADD_TIME) ADD_TIME,
         TO_CHAR(OH.ORDER_SN) ORDER_SN,
         M.MANSONG_NAME PROMOTION_NAME,
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
         END PATHWAY, --通路
         '满立减' PROMONTION_TYPE,
         OG.GOODS_NUM * OG.GOODS_PAY_PRICE SALES_AMOUNT, --商品有效金额 
         OH.DISCOUNT_MANSONG_AMOUNT
    FROM FACT_EC_ORDER_2         OH,
         FACT_EC_ORDER_GOODS     OG,
         FACT_EC_P_MANSONG       M,
         FACT_EC_P_MANSONG_GOODS MG
   WHERE OH.ORDER_ID = OG.ORDER_ID
     AND OH.DISCOUNT_MANSONG_ID = M.MANSONG_ID
     AND M.MANSONG_ID = MG.MANSONG_ID
        /*有效订购条件*/
     AND OH.ORDER_STATE >= 30
     AND OH.REFUND_STATE = 0
     AND OH.DISCOUNT_MANSONG_AMOUNT <> 0
     AND TRUNC(OH.ADD_TIME) = DATE '2017-09-18'
  UNION ALL
  /*DISCOUNT_PAYMENTWAY_DESC*/
  SELECT TRUNC(OH.ADD_TIME) ADD_TIME,
         TO_CHAR(OH.ORDER_SN) ORDER_SN,
         OH.DISCOUNT_PAYMENTWAY_DESC,
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
         END PATHWAY, --通路
         '支付立减' PROMONTION_TYPE,
         OG.GOODS_NUM * OG.GOODS_PAY_PRICE SALES_AMOUNT, --商品有效金额 
         OH.DISCOUNT_PAYMENTWAY_AMOUNT
    FROM FACT_EC_ORDER_2 OH, FACT_EC_ORDER_GOODS OG /*,
             FACT_EC_P_MANSONG       M,
             FACT_EC_P_MANSONG_GOODS MG*/
   WHERE OH.ORDER_ID = OG.ORDER_ID
        /*AND OH.DISCOUNT_MANSONG_ID = M.MANSONG_ID
        AND M.MANSONG_ID = MG.MANSONG_ID*/
        /*有效订购条件*/
     AND OH.ORDER_STATE >= 30
     AND OH.REFUND_STATE = 0
     AND OH.DISCOUNT_PAYMENTWAY_AMOUNT <> 0
     AND TRUNC(OH.ADD_TIME) = DATE '2017-09-18'
  UNION ALL
  /*DISCOUNT_PAYMENTCHANEL_DESC*/
  SELECT TRUNC(OH.ADD_TIME) ADD_TIME,
         TO_CHAR(OH.ORDER_SN) ORDER_SN,
         OH.DISCOUNT_PAYMENTCHANEL_DESC,
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
         END PATHWAY, --通路
         '支付立减' PROMONTION_TYPE,
         OG.GOODS_NUM * OG.GOODS_PAY_PRICE SALES_AMOUNT, --商品有效金额 
         OH.DISCOUNT_PAYMENTCHANEL_AMOUNT
    FROM FACT_EC_ORDER_2 OH, FACT_EC_ORDER_GOODS OG /*,
             FACT_EC_P_MANSONG       M,
             FACT_EC_P_MANSONG_GOODS MG*/
   WHERE OH.ORDER_ID = OG.ORDER_ID
        /*AND OH.DISCOUNT_MANSONG_ID = M.MANSONG_ID
        AND M.MANSONG_ID = MG.MANSONG_ID*/
        /*有效订购条件*/
     AND OH.ORDER_STATE >= 30
     AND OH.REFUND_STATE = 0
     AND OH.DISCOUNT_PAYMENTCHANEL_AMOUNT <> 0
     AND TRUNC(OH.ADD_TIME) = DATE '2017-09-18';

--优惠券
CREATE TABLE OPER_NM_VOUCHER_REPORT AS
  SELECT V.VOUCHER_T_ID,
         V.COUPON_TV_ID,
         V.VOUCHER_TITLE,
         V.VOUCHER_TYPE,
         V.VOUCHER_PRICE,
         V.VOUCHER_START_DATE,
         V.VOUCHER_END_DATE,
         NVL(V.SEND_VOUCHER_COUNT, 0) SEND_VOUCHER_COUNT,
         NVL(O.USED_VOUCHER_COUNT, 0) USED_VOUCHER_COUNT,
         ROUND(NVL(O.USED_VOUCHER_COUNT, 0) / NVL(V.SEND_VOUCHER_COUNT, 0),
               4) USED_VOUCHER_RATE,
         NVL(O.VOUCHER_COST, 0) VOUCHER_COST,
         NVL(O.ORDER_AMOUNT, 0) ORDER_AMOUNT
    FROM (SELECT A.VOUCHER_T_ID,
                 A.COUPON_TV_ID,
                 A.VOUCHER_TITLE,
                 CASE
                   WHEN A.COUPON_TV_ID IS NULL THEN
                    '新媒体券'
                   ELSE
                    'TV券'
                 END VOUCHER_TYPE,
                 A.VOUCHER_PRICE,
                 TRUNC(A.VOUCHER_START_DATE) VOUCHER_START_DATE,
                 TRUNC(A.VOUCHER_END_DATE) VOUCHER_END_DATE,
                 COUNT(A.VOUCHER_CODE) SEND_VOUCHER_COUNT
            FROM FACT_EC_VOUCHER A
           GROUP BY A.VOUCHER_T_ID,
                    A.COUPON_TV_ID,
                    A.VOUCHER_TITLE,
                    A.VOUCHER_PRICE,
                    TRUNC(A.VOUCHER_START_DATE),
                    TRUNC(A.VOUCHER_END_DATE)) V,
         (SELECT A.VOUCHER_REF VOUCHER_T_ID,
                 TRUNC(A.VOUCHER_START_DATE) VOUCHER_START_DATE,
                 TRUNC(A.VOUCHER_END_DATE) VOUCHER_END_DATE,
                 COUNT(A.VOUCHER_CODE) USED_VOUCHER_COUNT,
                 SUM(A.VOUCHER_PRICE) VOUCHER_COST,
                 SUM(B.ORDER_AMOUNT) ORDER_AMOUNT
            FROM FACT_EC_ORDER_COMMON A, FACT_EC_ORDER_2 B
           WHERE A.ORDER_ID = B.ORDER_ID
             AND B.ORDER_STATE >= 30
             AND B.REFUND_STATE = 0
             AND A.VOUCHER_REF IS NOT NULL
           GROUP BY A.VOUCHER_REF,
                    TRUNC(A.VOUCHER_START_DATE),
                    TRUNC(A.VOUCHER_END_DATE)) O
   WHERE V.VOUCHER_T_ID = O.VOUCHER_T_ID(+)
     AND V.VOUCHER_START_DATE = O.VOUCHER_START_DATE(+)
     AND V.VOUCHER_END_DATE = O.VOUCHER_END_DATE(+)
   ORDER BY V.VOUCHER_T_ID, V.VOUCHER_START_DATE, V.VOUCHER_END_DATE;

SELECT *
  FROM FACT_EC_ORDER_COMMON A
 WHERE A.VOUCHER_CODE = 'XTV2006838202';
SELECT * FROM FACT_EC_ORDER_2 A WHERE A.ORDER_ID = 443;
SELECT * FROM FACT_EC_VOUCHER A WHERE A.VOUCHER_CODE = 'XTV2006838202';

TRUNCATE TABLE OPER_NM_PROMOTION_ITEM_REPORT;
TRUNCATE TABLE OPER_NM_PROMOTION_ORDER_REPORT;
TRUNCATE TABLE OPER_NM_VOUCHER_REPORT;
