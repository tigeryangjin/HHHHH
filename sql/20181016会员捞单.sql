/*
捞取3个月内未订购过但两年内订购过的用户(按订购次数筛选）
*/
--订购
SELECT F.MEMBER_BP, F.ORDER_CNT
  FROM (SELECT TO_NUMBER(A.CUST_NO) MEMBER_BP,
               COUNT(DISTINCT A.ORDER_ID) ORDER_CNT
          FROM FACT_EC_ORDER_2 A
         WHERE A.ADD_TIME BETWEEN DATE '2016-10-01' AND DATE
         '2018-10-16'
           AND A.ORDER_STATE >= 20
           AND A.CUST_NO <> 0
           AND NOT EXISTS
         (SELECT 1
                  FROM (SELECT DISTINCT C.CUST_NO
                          FROM FACT_EC_ORDER_2 C
                         WHERE C.ADD_TIME BETWEEN DATE '2018-07-16' AND DATE
                         '2018-10-16'
                           AND C.ORDER_STATE >= 20
                           AND C.CUST_NO <> 0) B
                 WHERE A.CUST_NO = B.CUST_NO)
         GROUP BY A.CUST_NO) F
--WHERE F.ORDER_CNT >= 2
 ORDER BY F.ORDER_CNT DESC, F.MEMBER_BP;

--TMP
SELECT *
  FROM FACT_EC_ORDER_2 A
 WHERE A.CUST_NO = 1600204436
   AND A.ORDER_STATE >= 20
 ORDER BY A.ORDER_ID;
