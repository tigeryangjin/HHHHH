SELECT * FROM OPER_NM_PROMOTION_ORDER_REPORT;
SELECT * FROM OPER_NM_PROMOTION_ITEM_REPORT;
SELECT * FROM OPER_NM_VOUCHER_REPORT;

SELECT *
  FROM FACT_EC_ORDER_GOODS A,FACT_EC_ORDER_2 B
 WHERE A.ORDER_ID=B.ORDER_ID
 AND A.PML_DISCOUNT <> 0
 ORDER BY B.ADD_TIME DESC;
SELECT * FROM FACT_EC_ORDER_2;
SELECT A.ORDER_ID,
       A.GOODS_COMMONID,
       A.GOODS_PRICE,
       A.GOODS_PAY_PRICE,
       A.GOODS_PRICE - A.GOODS_PAY_PRICE,
       A.PML_DISCOUNT
  FROM FACT_EC_ORDER_GOODS A
 WHERE A.PML_DISCOUNT <> 0;
