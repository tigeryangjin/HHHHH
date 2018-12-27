???CREATE OR REPLACE FORCE VIEW DW_USER.OPER_MEMBER_REPURCHASE_RPT_V AS
SELECT B.MONTH_KEY,
         B.ORDER_COUNT_LEVEL,
         SUM(B.MEMBER_COUNT) MEMBER_COUNT,
         ROUND(SUM(B.ORDER_AMOUNT) / SUM(B.MEMBER_COUNT), 2) PER_CUST_AMOUNT
    FROM (SELECT A.MONTH_KEY,
                 CASE
                   WHEN A.ORDER_COUNT = 1 THEN
                    '1'
                   WHEN A.ORDER_COUNT = 2 THEN
                    '2'
                   WHEN A.ORDER_COUNT = 3 THEN
                    '3'
                   WHEN A.ORDER_COUNT = 4 THEN
                    '4'
                   WHEN A.ORDER_COUNT BETWEEN 5 AND 9 THEN
                    '5-9'
                   WHEN A.ORDER_COUNT >= 10 THEN
                    'MORE_10'
                 END ORDER_COUNT_LEVEL,
                 A.MEMBER_COUNT,
                 A.ORDER_AMOUNT,
                 A.W_INSERT_DT,
                 A.W_UPDATE_DT
            FROM OPER_MEMBER_REPURCHASE_RPT A) B
   GROUP BY B.MONTH_KEY, B.ORDER_COUNT_LEVEL
   ORDER BY B.MONTH_KEY, B.ORDER_COUNT_LEVEL;

