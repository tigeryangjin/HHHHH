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
               ROW_NUMBER() OVER(ORDER BY C.SALES_AMT DESC) SALES_AMT_TOP_N, /*�������۽������*/
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
                  FROM (SELECT A.PERIOD, /*����*/
                               A.MATDLT, /*��������*/
                               A.MATZLT, /*��������*/
                               A.MATXLT, /*С������*/
                               A.ACQ_ITEM_CODE, /*��Ʒ����*/
                               A.ACQ_NAME, /*��Ʒ����*/
                               A.ACQ_URL, /*��ƷURL��ַ*/
                               A.ACQ_PIC, /*��ƷͼƬ��ַ*/
                               A.ACQ_SHOP_NAME, /*��������*/
                               A.ACQ_PRICE, /*��Ʒ�ۼ�*/
                               A.CURRENT_ACQ_SALES, /*��������*/
                               A.CURRENT_SALES_AMT /*���۽��*/
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
 WHERE D.SALES_AMT_TOP_N <= 2000 /*����ǰ2000*/
 AND 1=2
 ORDER BY D.SALES_AMT_TOP_N;
