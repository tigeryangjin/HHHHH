--1.
WITH DIM AS
 (SELECT A.GOODS_ID,
         A.ITEM_CODE /*商品编号（SPU）*/,
         A.ERP_CODE /*商品编号（SKU）*/,
         A.GOODS_NAME /*商品名称*/,
         B.BRAND_NAME /*品牌*/,
         A.SUPPLIER_ID /*供应商编号*/,
         A.SUPPLIER_NAME /*供应商名称*/,
         C.MD /*MD*/,
         D.GC_NAME /*品类*/,
         C1.COST_PRICE /*供货价*/,
         TO_NUMBER(C1.VALID_DATE) VALID_DATE /*供货价有效期*/,
         A.GOODS_PRICE /*快乐价*/,
         DECODE(NVL(A.GOODS_PRICE, 0),
                0,
                0,
                (NVL(A.GOODS_PRICE, 0) - NVL(C1.COST_PRICE, 0)) /
                NVL(A.GOODS_PRICE, 0)) PROFIT_RATE /*毛利率*/,
         NVL(A.GOODS_PRICE, 0) - NVL(C1.COST_PRICE, 0) PROFIT_AMOUNT /*毛利额*/,
         A.GOODS_MARKETPRICE /*市场价*/,
         TO_NUMBER(C1.REPORT_DATE) REPORT_DATE /*提报日期*/,
         E.FIRSTONSELLTIME /*首次上架时间*/,
         CASE
           WHEN A.IS_SHIPPING_SELF = 0 THEN
            '直配送'
           WHEN A.IS_SHIPPING_SELF = 1 THEN
            '入库'
         END IS_SHIPPING_SELF /*配送方式*/,
         A.GOODS_STORAGE /*库存数量*/
    FROM FACT_EC_GOODS A,
         DIM_EC_BRAND B,
         DIM_GOOD C,
         DIM_GOOD_CLASS D,
         FACT_EC_GOODS_COMMON E,
         DIM_GOOD_COST C1,
         (SELECT M1.ITEM_CODE, M1.MD
            FROM DIM_GOOD_MD M1
           WHERE NOT EXISTS (SELECT 1
                    FROM (SELECT M3.ITEM_CODE, COUNT(1)
                            FROM (SELECT DISTINCT M4.ITEM_CODE, M4.MD
                                    FROM DIM_GOOD_MD M4) M3
                           GROUP BY M3.ITEM_CODE
                          HAVING COUNT(1) > 1) M2
                   WHERE M1.ITEM_CODE = M2.ITEM_CODE)) M
   WHERE A.BRAND_ID = B.BRAND_ID(+)
     AND A.GOODS_COMMONID = C.GOODS_COMMONID(+)
     AND C.MATL_GROUP = D.MATKL(+)
     AND A.GOODS_COMMONID = E.GOODS_COMMONID(+)
     AND A.ITEM_CODE = M.ITEM_CODE(+)
     AND A.ITEM_CODE = C1.ITEM_CODE(+)
     AND C.CURRENT_FLG = 'Y'),
ORD AS /*订购*/
 (SELECT H.GOODS_ID,
         SUM(H.ORDER_QTY) ORDER_QTY,
         SUM(H.ORDER_AMOUNT) ORDER_AMOUNT,
         SUM(H.LAST_3D_ORDER_QTY) LAST_3D_ORDER_QTY,
         SUM(H.LAST_7D_ORDER_QTY) LAST_7D_ORDER_QTY,
         SUM(H.LAST_10D_ORDER_QTY) LAST_10D_ORDER_QTY
    FROM (SELECT TO_CHAR(F.ADD_TIME, 'YYYYMMDD') ORDER_DATE,
                 G.GOODS_ID,
                 G.GOODS_NUM ORDER_QTY,
                 G.GOODS_NUM * G.GOODS_PAY_PRICE ORDER_AMOUNT,
                 /*近三天订购件数*/
                 CASE
                   WHEN TRUNC(F.ADD_TIME) >= TRUNC(SYSDATE) - 3 THEN
                    G.GOODS_NUM
                   ELSE
                    0
                 END LAST_3D_ORDER_QTY,
                 /*近七天订购件数*/
                 CASE
                   WHEN TRUNC(F.ADD_TIME) >= TRUNC(SYSDATE) - 7 THEN
                    G.GOODS_NUM
                   ELSE
                    0
                 END LAST_7D_ORDER_QTY,
                 /*近十天订购件数*/
                 CASE
                   WHEN TRUNC(F.ADD_TIME) >= TRUNC(SYSDATE) - 10 THEN
                    G.GOODS_NUM
                   ELSE
                    0
                 END LAST_10D_ORDER_QTY
            FROM FACT_EC_ORDER_2 F, FACT_EC_ORDER_GOODS G
           WHERE F.ORDER_ID = G.ORDER_ID
             AND F.ORDER_STATE >= 20) H
   GROUP BY H.GOODS_ID)
SELECT DIM.ITEM_CODE,
       DIM.ERP_CODE,
       DIM.GOODS_NAME,
       DIM.BRAND_NAME,
       DIM.SUPPLIER_ID,
       DIM.SUPPLIER_NAME,
       DIM.MD,
       DIM.GC_NAME,
       DIM.COST_PRICE,
       DIM.VALID_DATE,
       DIM.GOODS_PRICE,
       DIM.PROFIT_RATE,
       DIM.PROFIT_AMOUNT,
       DIM.GOODS_MARKETPRICE,
       DIM.REPORT_DATE,
       DIM.FIRSTONSELLTIME,
       DIM.IS_SHIPPING_SELF,
       DIM.GOODS_STORAGE,
       ORD.ORDER_QTY,
       ORD.ORDER_AMOUNT,
       ORD.LAST_3D_ORDER_QTY,
       ORD.LAST_7D_ORDER_QTY,
       ORD.LAST_10D_ORDER_QTY
  FROM DIM, ORD
 WHERE DIM.GOODS_ID = ORD.GOODS_ID(+);

--2.
SELECT A.GOODS_ID,
       A.ITEM_CODE /*商品编号（SPU）*/,
       A.ERP_CODE /*商品编号（SKU）*/,
       A.GOODS_NAME /*商品名称*/,
       B.BRAND_NAME /*品牌*/,
       A.SUPPLIER_ID /*供应商编号*/,
       A.SUPPLIER_NAME /*供应商名称*/,
       C.MD /*MD*/,
       D.GC_NAME /*品类*/,
       C1.COST_PRICE /*供货价*/,
       C1.VALID_DATE VALID_DATE /*供货价有效期*/,
       A.GOODS_PRICE /*快乐价*/,
       DECODE(NVL(A.GOODS_PRICE, 0),
              0,
              0,
              (NVL(A.GOODS_PRICE, 0) - NVL(C1.COST_PRICE, 0)) /
              NVL(A.GOODS_PRICE, 0)) PROFIT_RATE /*毛利率*/,
       NVL(A.GOODS_PRICE, 0) - NVL(C1.COST_PRICE, 0) PROFIT_AMOUNT /*毛利额*/,
       A.GOODS_MARKETPRICE /*市场价*/,
       TO_NUMBER(C1.REPORT_DATE) REPORT_DATE /*提报日期*/,
       E.FIRSTONSELLTIME /*首次上架时间*/,
       CASE
         WHEN A.IS_SHIPPING_SELF = 0 THEN
          '直配送'
         WHEN A.IS_SHIPPING_SELF = 1 THEN
          '入库'
       END IS_SHIPPING_SELF /*配送方式*/,
       A.GOODS_STORAGE /*库存数量*/
  FROM FACT_EC_GOODS A,
       DIM_EC_BRAND B,
       DIM_GOOD C,
       DIM_GOOD_CLASS D,
       FACT_EC_GOODS_COMMON E,
       DIM_GOOD_COST C1,
       (SELECT M1.ITEM_CODE, M1.MD
          FROM DIM_GOOD_MD M1
         WHERE NOT EXISTS (SELECT 1
                  FROM (SELECT M3.ITEM_CODE, COUNT(1)
                          FROM (SELECT DISTINCT M4.ITEM_CODE, M4.MD
                                  FROM DIM_GOOD_MD M4) M3
                         GROUP BY M3.ITEM_CODE
                        HAVING COUNT(1) > 1) M2
                 WHERE M1.ITEM_CODE = M2.ITEM_CODE)) M
 WHERE A.BRAND_ID = B.BRAND_ID(+)
   AND A.GOODS_COMMONID = C.GOODS_COMMONID(+)
   AND C.MATL_GROUP = D.MATKL(+)
   AND A.GOODS_COMMONID = E.GOODS_COMMONID(+)
   AND A.ITEM_CODE = M.ITEM_CODE(+)
   AND A.ITEM_CODE = C1.ITEM_CODE(+)
   AND C.CURRENT_FLG = 'Y';

--3.
SELECT H.GOODS_ID,
       SUM(H.ORDER_QTY) ORDER_QTY,
       SUM(H.ORDER_AMOUNT) ORDER_AMOUNT,
       SUM(H.LAST_3D_ORDER_QTY) LAST_3D_ORDER_QTY,
       SUM(H.LAST_7D_ORDER_QTY) LAST_7D_ORDER_QTY,
       SUM(H.LAST_10D_ORDER_QTY) LAST_10D_ORDER_QTY
  FROM (SELECT TO_CHAR(F.ADD_TIME, 'YYYYMMDD') ORDER_DATE,
               G.GOODS_ID,
               G.GOODS_NUM ORDER_QTY,
               G.GOODS_NUM * G.GOODS_PAY_PRICE ORDER_AMOUNT,
               /*近三天订购件数*/
               CASE
                 WHEN TRUNC(F.ADD_TIME) >= TRUNC(SYSDATE) - 3 THEN
                  G.GOODS_NUM
                 ELSE
                  0
               END LAST_3D_ORDER_QTY,
               /*近七天订购件数*/
               CASE
                 WHEN TRUNC(F.ADD_TIME) >= TRUNC(SYSDATE) - 7 THEN
                  G.GOODS_NUM
                 ELSE
                  0
               END LAST_7D_ORDER_QTY,
               /*近十天订购件数*/
               CASE
                 WHEN TRUNC(F.ADD_TIME) >= TRUNC(SYSDATE) - 10 THEN
                  G.GOODS_NUM
                 ELSE
                  0
               END LAST_10D_ORDER_QTY
          FROM FACT_EC_ORDER_2 F, FACT_EC_ORDER_GOODS G
         WHERE F.ORDER_ID = G.ORDER_ID
           AND F.ORDER_STATE >= 20) H
 GROUP BY H.GOODS_ID
