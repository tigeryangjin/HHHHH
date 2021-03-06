/*
11月订购过的用户BP号和订购次数
*/
--订购
SELECT F.MEMBER_BP, F.ORDER_CNT
  FROM (SELECT TO_NUMBER(A.CUST_NO) MEMBER_BP,
               COUNT(DISTINCT A.ORDER_ID) ORDER_CNT
          FROM FACT_EC_ORDER_2 A, FACT_EC_ORDER_GOODS B
         WHERE A.ORDER_ID = B.ORDER_ID
           AND A.ADD_TIME BETWEEN DATE '2018-11-01' AND DATE
         '2018-11-30'
           AND A.ORDER_STATE >= 20
           AND A.CUST_NO <> 0
         GROUP BY A.CUST_NO) F
--WHERE F.ORDER_CNT >= 2
 ORDER BY F.ORDER_CNT DESC;
