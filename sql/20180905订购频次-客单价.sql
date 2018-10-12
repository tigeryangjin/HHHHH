--1.订购频次分布人数
SELECT D.MONTH_KEY,
       CASE
         WHEN D.ORDER_COUNT = 1 THEN
          '1次'
         WHEN D.ORDER_COUNT = 2 THEN
          '2次'
         WHEN D.ORDER_COUNT = 3 THEN
          '3次'
         WHEN D.ORDER_COUNT = 4 THEN
          '4次'
         WHEN D.ORDER_COUNT BETWEEN 5 AND 9 THEN
          '5-9次'
         WHEN D.ORDER_COUNT >= 10 THEN
          '10次以上'
       END DESC1,
       SUM(D.MEMBER_COUNT) MEMBER_COUNT,
       AVG(D.ORDER_PER_AMOUNT) ORDER_PER_AMOUNT
  FROM (SELECT C.MONTH_KEY,
               C.ORDER_COUNT,
               COUNT(C.MEMBER_KEY) MEMBER_COUNT,
               AVG(C.ORDER_PER_AMOUNT) ORDER_PER_AMOUNT
          FROM (SELECT B.MONTH_KEY,
                       B.MEMBER_KEY,
                       COUNT(B.ORDER_ID) ORDER_COUNT,
                       SUM(B.ORDER_AMOUNT) ORDER_AMOUNT,
                       SUM(B.ORDER_AMOUNT) / COUNT(B.ORDER_ID) ORDER_PER_AMOUNT
                  FROM (SELECT TO_CHAR(A.ADD_TIME, 'YYYYMM') MONTH_KEY,
                               TO_NUMBER(A.CUST_NO) MEMBER_KEY,
                               A.ORDER_ID,
                               A.ORDER_AMOUNT
                          FROM FACT_EC_ORDER_2 A
                         WHERE TO_CHAR(A.ADD_TIME, 'YYYYMMDD') BETWEEN
                               20170801 AND 20170831
                           AND A.ORDER_STATE >= 20) B
                 GROUP BY B.MONTH_KEY, B.MEMBER_KEY) C
         GROUP BY C.MONTH_KEY, C.ORDER_COUNT) D
 GROUP BY D.MONTH_KEY,
          CASE
            WHEN D.ORDER_COUNT = 1 THEN
             '1次'
            WHEN D.ORDER_COUNT = 2 THEN
             '2次'
            WHEN D.ORDER_COUNT = 3 THEN
             '3次'
            WHEN D.ORDER_COUNT = 4 THEN
             '4次'
            WHEN D.ORDER_COUNT BETWEEN 5 AND 9 THEN
             '5-9次'
            WHEN D.ORDER_COUNT >= 10 THEN
             '10次以上'
          END;

--2.订购频次-客单价
