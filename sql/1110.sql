SELECT * FROM DATA_ACQUISITION_WEEK_TOPN;
SELECT * FROM DATA_ACQUISITION_WEEK_NEW;
SELECT * FROM DATA_ACQUISITION_MONTH_TOPN;
SELECT * FROM DATA_ACQUISITION_MONTH_NEW;

SELECT * FROM DATA_ACQUISITION_WEEK_TOPN A WHERE A.PERIOD = 20170904;
SELECT * FROM DATA_ACQUISITION_WEEK_NEW A WHERE A.PERIOD = 20170904;
SELECT * FROM DATA_ACQUISITION_MONTH_TOPN;
SELECT * FROM DATA_ACQUISITION_MONTH_NEW;

SELECT DISTINCT A.PERIOD FROM DATA_ACQUISITION_WEEK_TOPN A;
SELECT DISTINCT A.PERIOD FROM DATA_ACQUISITION_WEEK_NEW A;
SELECT DISTINCT A.YEAR_MONTH FROM DATA_ACQUISITION_MONTH_TOPN A;
SELECT DISTINCT A.YEAR_MONTH FROM DATA_ACQUISITION_MONTH_NEW A;

SELECT A.PERIOD,COUNT(1) FROM DATA_ACQUISITION_WEEK_NEW A GROUP BY A.PERIOD;

SELECT /*+PARALLEL(32)*/ DISTINCT A.PERIOD FROM DATA_ACQUISITION_ITEM A;

SELECT * FROM W_ETL_LOG A WHERE A.PROC_NAME='YANGJIN_PKG.DATA_ACQUISITION_MONTH_TOPN' ORDER BY A.START_TIME DESC;

SELECT D.YEAR_MONTH,
       D.MATDLT,
       D.MATZLT,
       D.MATXLT,
       D.SALES_QTY_TOP_N,
       D.ACQ_ITEM_CODE,
       D.ACQ_NAME,
       D.ACQ_URL,
       D.ACQ_PIC,
       D.ACQ_SHOP_NAME,
       D.ACQ_PRICE,
       D.SALES_QTY,
       D.SALES_AMT
  FROM (SELECT C.YEAR_MONTH,
               C.MATDLT,
               C.MATZLT,
               C.MATXLT,
               ROW_NUMBER() OVER(ORDER BY C.SALES_QTY DESC) SALES_QTY_TOP_N, /*����������������*/
               C.ACQ_ITEM_CODE,
               C.ACQ_NAME,
               C.ACQ_URL,
               C.ACQ_PIC,
               C.ACQ_SHOP_NAME,
               C.ACQ_PRICE,
               C.SALES_QTY,
               C.SALES_AMT
          FROM (SELECT SUBSTR(B.PERIOD, 1, 6) YEAR_MONTH,
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
                         WHERE A.PERIOD BETWEEN &V_MONTH_FIRST_DATE_KEY AND
                               &V_MONTH_LAST_DATE_KEY
                              /*�޳����������������۽��<=0*/
                           AND A.CURRENT_ACQ_SALES > 0
                           AND A.CURRENT_SALES_AMT > 0) B
                 GROUP BY SUBSTR(B.PERIOD, 1, 6),
                          B.MATDLT,
                          B.MATZLT,
                          B.MATXLT,
                          B.ACQ_ITEM_CODE,
                          B.ACQ_NAME,
                          B.ACQ_URL,
                          B.ACQ_PIC,
                          B.ACQ_SHOP_NAME,
                          B.ACQ_PRICE) C) D
 WHERE D.SALES_QTY_TOP_N <= 2000 /*����ǰ2000*/
 ORDER BY D.SALES_QTY_TOP_N;