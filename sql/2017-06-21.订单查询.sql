--
SELECT COUNT(B.MEMBER_KEY)
  FROM (SELECT A.MEMBER_KEY,
               COUNT(A.ORDER_OBJ_ID) ORDER_COUNT,
               SUM(A.ORDER_AMOUNT) ORDER_AMOUNT
          FROM (SELECT T.POSTING_DATE_KEY,
                       T.ORDER_OBJ_ID,
                       T.MEMBER_KEY,
                       T.ORDER_AMOUNT
                  FROM FACT_ORDER T
                 WHERE T.POSTING_DATE_KEY BETWEEN 20170501 AND 20170518 /*过账日期*/
                   AND T.SALES_SOURCE_KEY = 20 /*新媒体通路*/
                   AND T.ORDER_STATE = 1) A
         GROUP BY A.MEMBER_KEY) B
 WHERE B.ORDER_COUNT >= 3 /*订购次数*/
   or B.ORDER_AMOUNT >= 1618 /*订购金额*/
;


--
SELECT * FROM FACT_SHOPPINGCAR T
WHERE T.MEMBER_KEY IN ();
