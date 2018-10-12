--券面额   领取数 使用数  订单金额 
--1.生日券
SELECT E.VOUCHER_PRICE 券面额,
       COUNT(1) 领取数,
       SUM(CASE
             WHEN E.VOUCHER_STATE = 2 THEN
              1
             ELSE
              0
           END) 使用数,
       SUM(E.ORDER_AMOUNT) 订单金额
  FROM (SELECT A.VOUCHER_T_ID,
               A.VOUCHER_CODE,
               A.VOUCHER_PRICE,
               A.VOUCHER_STATE,
               D.ORDER_AMOUNT
          FROM FACT_EC_VOUCHER A,
               (SELECT B.ORDER_ID,
                       C.VOUCHER_REF,
                       C.VOUCHER_CODE,
                       B.ORDER_AMOUNT
                  FROM FACT_EC_ORDER_2 B, FACT_EC_ORDER_COMMON C
                 WHERE B.ORDER_ID = C.ORDER_ID
                   AND B.ADD_TIME >= DATE '2018-06-01'
                   AND B.ORDER_STATE >= 30
                   AND B.REFUND_STATE = 0
                   AND B.STORE_ID = 1) D
         WHERE A.VOUCHER_T_ID = D.VOUCHER_REF(+)
           AND A.VOUCHER_CODE = D.VOUCHER_CODE(+)
           AND A.VOUCHER_T_ID between 2463 and 2472
           AND A.VOUCHER_START_DATE >= DATE '2018-06-01') E
 GROUP BY E.VOUCHER_PRICE
 ORDER BY E.VOUCHER_PRICE;

--2.新人券
SELECT E.VOUCHER_PRICE 券面额,
       COUNT(1) 领取数,
       SUM(CASE
             WHEN E.VOUCHER_STATE = 2 THEN
              1
             ELSE
              0
           END) 使用数,
       SUM(E.ORDER_AMOUNT) 订单金额
  FROM (SELECT A.VOUCHER_T_ID,
               A.VOUCHER_CODE,
               A.VOUCHER_PRICE,
               A.VOUCHER_STATE,
               D.ORDER_AMOUNT
          FROM FACT_EC_VOUCHER A,
               (SELECT B.ORDER_ID,
                       C.VOUCHER_REF,
                       C.VOUCHER_CODE,
                       B.ORDER_AMOUNT
                  FROM FACT_EC_ORDER_2 B, FACT_EC_ORDER_COMMON C
                 WHERE B.ORDER_ID = C.ORDER_ID
                   AND B.ADD_TIME >= DATE '2018-06-01'
                   AND B.ORDER_STATE >= 30
                   AND B.REFUND_STATE = 0
                   AND B.STORE_ID = 1) D
         WHERE A.VOUCHER_T_ID = D.VOUCHER_REF(+)
           AND A.VOUCHER_CODE = D.VOUCHER_CODE(+)
           AND A.VOUCHER_T_ID IN
               (4037, 4038, 4683, 4684, 4685, 4686, 4687, 4688, 5653, 5654)
           AND A.VOUCHER_START_DATE >= DATE '2018-06-01') E
 GROUP BY E.VOUCHER_PRICE
 ORDER BY E.VOUCHER_PRICE;

SELECT DISTINCT A.VOUCHER_T_ID, A.VOUCHER_TITLE
  FROM FACT_EC_VOUCHER A
 WHERE A.VOUCHER_TITLE LIKE '%新人%'
   AND A.VOUCHER_START_DATE >= DATE '2018-06-01';
SELECT * FROM FACT_EC_ORDER_2 A WHERE A.ORDER_ID = 2242586;
SELECT * FROM FACT_EC_ORDER_COMMON A WHERE A.ORDER_ID = 2242586;
SELECT * FROM FACT_EC_VOUCHER_BATCH A WHERE A.VOUCHER_ID = '99182372';

SELECT * FROM ALL_ALL_TABLES A WHERE A.table_name LIKE '%VOUCHER%';
SELECT * FROM DIM_VOUCHER A WHERE A.VOUCHER_T_TITLE LIKE '%新人%';
