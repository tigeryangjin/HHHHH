/*
今年8.17-19   新会员/老会员分开两个维度，捞取日活，转化率，订购人数，客单价，件单价，单件数；
2017年8.18-20 新会员/老会员，捞取日活，转化率，订购人数，客单价，件单价，单件数。
新会员：这三天注册的
老会员：之前注册的
*/
SELECT I.OLD_OR_NEW,
       COUNT(DISTINCT I.CUST_NO) 订购人数,
       SUM(I.ORDER_AMOUNT) / COUNT(DISTINCT I.CUST_NO) 客单价,
       SUM(I.ORDER_AMOUNT) / SUM(I.ORDER_QTY) 件单价,
       SUM(I.ORDER_QTY) / COUNT(I.ORDER_ID) 单件数
  FROM (SELECT B.CUST_NO,
               CASE
                 WHEN D.FIRST_ORDER_DATE = TO_CHAR(B.ADD_TIME, 'YYYYMMDD') THEN
                  'new'
                 ELSE
                  'old'
               END OLD_OR_NEW,
               B.ORDER_ID,
               C.GOODS_COMMONID,
               C.GOODS_NUM ORDER_QTY,
               C.GOODS_PAY_PRICE * GOODS_NUM ORDER_AMOUNT
          FROM FACT_EC_ORDER_2 B,
               FACT_EC_ORDER_GOODS C,
               (SELECT A.CUST_NO,
                       MIN(TO_CHAR(A.ADD_TIME, 'YYYYMMDD')) FIRST_ORDER_DATE
                  FROM FACT_EC_ORDER_2 A
                 GROUP BY A.CUST_NO) D
         WHERE B.ORDER_ID = C.ORDER_ID
           AND B.CUST_NO = D.CUST_NO(+)
           AND TRUNC(B.ADD_TIME) BETWEEN DATE '2017-08-18' AND DATE
         '2017-08-20'
           AND B.ORDER_STATE >= 20) I
 GROUP BY I.OLD_OR_NEW;

--UV
SELECT H.OLD_OR_NEW, COUNT(DISTINCT H.MEMBER_KEY) UV
  FROM (SELECT E.MEMBER_KEY,
               CASE
                 WHEN E.VISIT_DATE_KEY > F.FIRST_ORDER_DATE THEN
                  'old'
                 ELSE
                  'new'
               END OLD_OR_NEW
          FROM FACT_PAGE_VIEW E,
               (SELECT G.CUST_NO,
                       MIN(TO_CHAR(G.ADD_TIME, 'YYYYMMDD')) FIRST_ORDER_DATE
                  FROM FACT_EC_ORDER_2 G
                 GROUP BY G.CUST_NO) F
         WHERE E.MEMBER_KEY = F.CUST_NO(+)
           AND E.VISIT_DATE_KEY BETWEEN 20180817 AND 20180819
           AND E.MEMBER_KEY <> 0) H
 GROUP BY H.OLD_OR_NEW;
