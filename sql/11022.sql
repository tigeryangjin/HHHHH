CREATE TABLE DATA_ACQUISITION_WEEK_TOPN AS
SELECT D.PERIOD,
       D.MATDLT,
       D.MATZLT,
       D.MATXLT,
       D.SALES_AMT_TOP_N,
       D.ACQ_ITEM_CODE,
       D.ACQ_NAME,
       D.ACQ_URL,
       D.ACQ_PIC,
       D.ACQ_SHOP_NAME,
       D.ACQ_PRICE,
       D.SALES_QTY,
       D.SALES_AMT
  FROM (SELECT C.PERIOD,
               C.MATDLT,
               C.MATZLT,
               C.MATXLT,
               ROW_NUMBER() OVER(ORDER BY C.SALES_AMT DESC) SALES_AMT_TOP_N, /*根据销售金额排名*/
               C.ACQ_ITEM_CODE,
               C.ACQ_NAME,
               C.ACQ_URL,
               C.ACQ_PIC,
               C.ACQ_SHOP_NAME,
               C.ACQ_PRICE,
               C.SALES_QTY,
               C.SALES_AMT
          FROM (SELECT B.PERIOD,
                       B.MATDLT,
                       B.MATZLT,
                       B.MATXLT,
                       B.ACQ_ITEM_CODE,
                       B.ACQ_NAME,
                       B.ACQ_URL,
                       B.ACQ_PIC,
                       B.ACQ_SHOP_NAME,
                       B.ACQ_PRICE,
                       SUM(B.CURRENT_ACQ_SALES) SALES_QTY,
                       SUM(B.CURRENT_ACQ_SALES) SALES_AMT
                  FROM (SELECT A.PERIOD, /*日期*/
                               A.MATDLT, /*大类名称*/
                               A.MATZLT, /*中类名称*/
                               A.MATXLT, /*小类名称*/
                               A.ACQ_ITEM_CODE, /*商品编码*/
                               A.ACQ_NAME, /*商品名称*/
                               A.ACQ_URL, /*商品URL地址*/
                               A.ACQ_PIC, /*商品图片地址*/
                               A.ACQ_SHOP_NAME, /*商铺名称*/
                               A.ACQ_PRICE, /*商品售价*/
                               A.CURRENT_ACQ_SALES, /*销售数量*/
                               A.CURRENT_SALES_AMT /*销售金额*/
                          FROM DATA_ACQUISITION_ITEM_CURRENT A
                         WHERE A.PERIOD = &I_DATE_KEY) B
                 GROUP BY B.PERIOD,
                          B.MATDLT,
                          B.MATZLT,
                          B.MATXLT,
                          B.ACQ_ITEM_CODE,
                          B.ACQ_NAME,
                          B.ACQ_URL,
                          B.ACQ_PIC,
                          B.ACQ_SHOP_NAME,
                          B.ACQ_PRICE) C) D
 WHERE D.SALES_AMT_TOP_N <= 2000 /*排名前2000*/
 AND 1=2
 ORDER BY D.SALES_AMT_TOP_N;
