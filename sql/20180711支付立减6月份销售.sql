--1.
SELECT * FROM YANGJIN.ITEM_CODE_TMP FOR UPDATE;

--2.
SELECT D.ERP_CODE ITEM_CODE,
       SUM(D.ORDER_QTY) TOTAL_ORDER_QTY,
       SUM(CASE
             WHEN D.VALID = 1 THEN
              D.ORDER_QTY
             ELSE
              0
           END) ORDER_QTY
  FROM (SELECT B.ERP_CODE,
               CASE
                 WHEN A.ORDER_STATE >= 20 THEN
                  1
                 ELSE
                  0
               END VALID,
               B.GOODS_NUM ORDER_QTY
          FROM FACT_EC_ORDER_2 A, FACT_EC_ORDER_GOODS B
         WHERE A.ORDER_ID = B.ORDER_ID
           AND TRUNC(A.ADD_TIME) BETWEEN DATE '2018-06-01' AND DATE
         '2018-06-30'
           AND A.ORDER_FROM <> '76'
           AND NVL(A.CRM_ORDER_NO, 0) > 0
           AND EXISTS (SELECT 1
                  FROM YANGJIN.ITEM_CODE_TMP C
                 WHERE B.ERP_CODE = C.ITEM_CODE)) D
 GROUP BY D.ERP_CODE
 ORDER BY 3 DESC;
