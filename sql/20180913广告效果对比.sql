--小程序日活
--1.
SELECT SUBSTR(A.VISIT_DATE_KEY, 1, 6) MONTH_KEY,
       ROUND(AVG(A.LITEUVCNT - A.LITENEWVTCOUNT)) OLD_UV,
       ROUND(AVG(A.LITENEWVTCOUNT)) NEW_UV
  FROM FACT_DAILY_WX A
 WHERE A.VISIT_DATE_KEY BETWEEN 20180701 AND 20180831
 GROUP BY SUBSTR(A.VISIT_DATE_KEY, 1, 6);

--2.
SELECT SUBSTR(A.VISIT_DATE_KEY, 1, 6) MONTH_KEY,
       ROUND(AVG(A.LITEUVCNT - A.LITENEWVTCOUNT)) OLD_UV,
       ROUND(AVG(A.LITENEWVTCOUNT)) NEW_UV
  FROM FACT_DAILY_WX A
 WHERE A.VISIT_DATE_KEY BETWEEN 20180817 AND 20180819
 GROUP BY SUBSTR(A.VISIT_DATE_KEY, 1, 6);

--小程序业绩
SELECT D.MONTH_KEY, D.IS_NEW, SUM(D.ORDER_AMOUNT) ORDER_AMOUNT
  FROM (SELECT A.ORDER_ID,
               TO_NUMBER(A.CUST_NO) MEMBER_KEY,
               TO_CHAR(A.ADD_TIME, 'YYYYMM') MONTH_KEY,
               A.ORDER_AMOUNT,
               CASE
                 WHEN A.ORDER_ID = B.FIRST_ORDER_ID THEN
                  'NEW'
                 ELSE
                  'OLD'
               END IS_NEW
          FROM FACT_EC_ORDER_2 A,
               (SELECT C.CUST_NO, MIN(C.ORDER_ID) FIRST_ORDER_ID
                  FROM FACT_EC_ORDER_2 C
                 GROUP BY C.CUST_NO) B
         WHERE A.CUST_NO = B.CUST_NO
           AND TRUNC(A.ADD_TIME) BETWEEN DATE '2018-08-17' AND DATE
         '2018-08-19'
           AND A.ORDER_STATE >= 20
           AND A.APP_NAME = 'KLGWX'
           AND A.VID LIKE 'wxlite%') D
 GROUP BY D.MONTH_KEY, D.IS_NEW;

--tmp
select e.add_time,
       
       count(distinct(case
                        when e.order_from != 76 and e.vid like 'wxoe%' then
                         e.member_key
                      end)) as noscan_orderrs, --wscorderrs
       
       count(distinct(case
                        when (e.vid like 'wxlite%' or e.vid like 'wxlitebargain%') then
                         e.member_key
                      end)) as liteorderrs,
       
       count(distinct(case
                        when e.order_from = 76 then
                         e.member_key
                      end)) as sm_orderrs,
       sum(case
             when e.order_from = 76 then
              e.order_amount
           end) as smyj

  from factec_order e
 where e.add_time = to_number(to_char(sysdate - 1, 'yyyymmdd'))
   and e.app_name = 'KLGWX'
   and (e.payment_code = 'offline' or e.order_state in (20, 30, 40, 50))
 group by e.add_time;

SELECT *
  FROM FACT_DAILY_WX_NEW A
 WHERE A.VISIT_DATE_KEY BETWEEN 20180701 AND 20180831;

SELECT * FROM ALL_SOURCE A WHERE UPPER(A.TEXT) LIKE '%FACT_DAILY_WX_NEW%';
SELECT * FROM ALL_COL_COMMENTS A WHERE A.COMMENTS LIKE '%小程序%';

SELECT * FROM FACT_DAILY_WX_NEW;

SELECT DISTINCT A.APP_NAME FROM FACT_EC_ORDER_2 A;
SELECT *
  FROM FACT_PAGE_VIEW A
 WHERE A.VISIT_DATE_KEY = 20180913
   AND A.page_key in (8925,
                      8926,
                      41928,
                      41930,
                      40410,
                      40411,
                      36768,
                      36948,
                      36949,
                      36854,
                      45042);
