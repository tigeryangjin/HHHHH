/*
11/1-12/17期间内注册的会员（之前未注册）首单订购的商品   的件数   和 转化率
渠道    商品编号    商品名称    订购人数    总件数   订购转化率
*/
--1.
--TRUNCATE TABLE YANGJIN.MEMBER_TMP;
INSERT INTO YANGJIN.MEMBER_TMP
  SELECT A.MEMBER_CRMBP
    FROM FACT_ECMEMBER A
   WHERE A.MEMBER_TIME BETWEEN 20181101 AND 20181217
   GROUP BY A.MEMBER_CRMBP;

--2.订购   
--2.1.全部
SELECT Z.APP_NAME,
       Z.ITEM_CODE,
       Z.GOODS_NAME,
       COUNT(DISTINCT Z.MEMBER_BP) MEMBER_COUNT,
       SUM(Z.ORDER_QTY) ORDER_QTY,
       SUM(Z.ORDER_AMOUNT) ORDER_AMOUNT
  FROM (SELECT A.APP_NAME,
               B.ERP_CODE ITEM_CODE,
               B.GOODS_NAME,
               TO_NUMBER(A.CUST_NO) MEMBER_BP,
               B.GOODS_NUM ORDER_QTY,
               B.GOODS_PRICE * B.GOODS_NUM ORDER_AMOUNT
          FROM FACT_EC_ORDER_2 A, FACT_EC_ORDER_GOODS B
         WHERE A.ORDER_ID = B.ORDER_ID
           AND A.ADD_TIME BETWEEN DATE '2018-11-01' AND DATE
         '2018-12-18'
           AND A.ORDER_STATE >= 20
           AND B.GOODS_PRICE > 0
           AND A.ORDER_FROM <> '76' /*剔除扫码购*/
           AND EXISTS (SELECT 1
                  FROM YANGJIN.MEMBER_TMP C
                 WHERE A.CUST_NO = C.MEMBER_KEY)) Z
 GROUP BY Z.APP_NAME, Z.ITEM_CODE, Z.GOODS_NAME
 ORDER BY Z.APP_NAME, Z.ITEM_CODE, Z.GOODS_NAME;

--2.2.首单
SELECT Z.APP_NAME,
       Z.ITEM_CODE,
       Z.GOODS_NAME,
       COUNT(DISTINCT Z.MEMBER_BP) MEMBER_COUNT,
       SUM(Z.ORDER_QTY) ORDER_QTY,
       SUM(Z.ORDER_AMOUNT) ORDER_AMOUNT
  FROM (SELECT A.APP_NAME,
               B.ERP_CODE ITEM_CODE,
               B.GOODS_NAME,
               TO_NUMBER(A.CUST_NO) MEMBER_BP,
               B.GOODS_NUM ORDER_QTY,
               B.GOODS_PRICE * B.GOODS_NUM ORDER_AMOUNT,
               ROW_NUMBER() OVER(PARTITION BY A.CUST_NO ORDER BY A.ORDER_ID) RN
          FROM FACT_EC_ORDER_2 A, FACT_EC_ORDER_GOODS B
         WHERE A.ORDER_ID = B.ORDER_ID
           AND A.ADD_TIME BETWEEN DATE '2018-11-01' AND DATE
         '2018-12-18'
           AND A.ORDER_STATE >= 20
           AND B.GOODS_PRICE > 0
           AND A.ORDER_FROM <> '76' /*剔除扫码购*/
           AND EXISTS (SELECT 1
                  FROM YANGJIN.MEMBER_TMP C
                 WHERE A.CUST_NO = C.MEMBER_KEY)) Z
 WHERE Z.RN = 1 /*首单*/
 GROUP BY Z.APP_NAME, Z.ITEM_CODE, Z.GOODS_NAME
 ORDER BY Z.APP_NAME, Z.ITEM_CODE, Z.GOODS_NAME;

--3.添加商品属性
--3.1.全部
SELECT Z1.APP_NAME,
       Z2.ITEM_CODE,
       Z2.GOODS_NAME,
       CASE
         WHEN Z2.GROUP_ID = 1000 THEN
          'TV'
         WHEN Z2.GROUP_ID = 2000 THEN
          '自营'
         ELSE
          '非自营'
       END GROUP_TYPE,
       Z1.MEMBER_COUNT,
       Z1.ORDER_QTY,
       Z1.ORDER_AMOUNT
  FROM (SELECT Z.APP_NAME,
               Z.GOODS_COMMONID,
               COUNT(DISTINCT Z.MEMBER_BP) MEMBER_COUNT,
               SUM(Z.ORDER_QTY) ORDER_QTY,
               SUM(Z.ORDER_AMOUNT) ORDER_AMOUNT
          FROM (SELECT A.APP_NAME,
                       B.GOODS_COMMONID,
                       TO_NUMBER(A.CUST_NO) MEMBER_BP,
                       B.GOODS_NUM ORDER_QTY,
                       B.GOODS_PRICE * B.GOODS_NUM ORDER_AMOUNT
                  FROM FACT_EC_ORDER_2 A, FACT_EC_ORDER_GOODS B
                 WHERE A.ORDER_ID = B.ORDER_ID
                   AND A.ADD_TIME BETWEEN DATE '2018-11-01' AND DATE
                 '2018-12-18'
                   AND A.ORDER_STATE >= 20
                   AND B.GOODS_PRICE > 0
                   AND A.ORDER_FROM <> '76' /*剔除扫码购*/
                   AND EXISTS (SELECT 1
                          FROM YANGJIN.MEMBER_TMP C
                         WHERE A.CUST_NO = C.MEMBER_KEY)) Z
         GROUP BY Z.APP_NAME, Z.GOODS_COMMONID) Z1,
       DIM_GOOD Z2
 WHERE Z1.GOODS_COMMONID = Z2.GOODS_COMMONID
 ORDER BY 1, 2, 4;

--3.2.首单
SELECT Z1.APP_NAME,
       Z2.ITEM_CODE,
       Z2.GOODS_NAME,
       CASE
         WHEN Z2.GROUP_ID = 1000 THEN
          'TV'
         WHEN Z2.GROUP_ID = 2000 THEN
          '自营'
         ELSE
          '非自营'
       END GROUP_TYPE,
       Z1.MEMBER_COUNT,
       Z1.ORDER_QTY,
       Z1.ORDER_AMOUNT
  FROM (SELECT Z.APP_NAME,
               Z.GOODS_COMMONID,
               COUNT(DISTINCT Z.MEMBER_BP) MEMBER_COUNT,
               SUM(Z.ORDER_QTY) ORDER_QTY,
               SUM(Z.ORDER_AMOUNT) ORDER_AMOUNT
          FROM (SELECT A.APP_NAME,
                       B.GOODS_COMMONID,
                       TO_NUMBER(A.CUST_NO) MEMBER_BP,
                       B.GOODS_NUM ORDER_QTY,
                       B.GOODS_PRICE * B.GOODS_NUM ORDER_AMOUNT,
                       ROW_NUMBER() OVER(PARTITION BY A.CUST_NO ORDER BY A.ORDER_ID) RN
                  FROM FACT_EC_ORDER_2 A, FACT_EC_ORDER_GOODS B
                 WHERE A.ORDER_ID = B.ORDER_ID
                   AND A.ADD_TIME BETWEEN DATE '2018-11-01' AND DATE
                 '2018-12-18'
                   AND A.ORDER_STATE >= 20
                   AND B.GOODS_PRICE > 0
                   AND A.ORDER_FROM <> '76' /*剔除扫码购*/
                   AND EXISTS (SELECT 1
                          FROM YANGJIN.MEMBER_TMP C
                         WHERE A.CUST_NO = C.MEMBER_KEY)) Z
         WHERE Z.RN = 1 /*首单*/
         GROUP BY Z.APP_NAME, Z.GOODS_COMMONID) Z1,
       DIM_GOOD Z2
 WHERE Z1.GOODS_COMMONID = Z2.GOODS_COMMONID
 ORDER BY 1, 2, 4;

--浏览
SELECT DISTINCT A.PAGE_NAME
  FROM FACT_PAGE_VIEW A
 WHERE A.VISIT_DATE_KEY BETWEEN 20181101 AND 20181217
   AND A.PAGE_VALUE =
       TRANSLATE(A.PAGE_VALUE,
                 '0' || TRANSLATE(A.PAGE_VALUE, '#0123456789', '#'),
                 '0')
   AND A.PAGE_VALUE <> '0';

--tmp
SELECT * FROM FACT_ECMEMBER A WHERE A.MEMBER_CRMBP = 1627615671;
SELECT * FROM OPER_PRODUCT_DAILY_REPORT;
