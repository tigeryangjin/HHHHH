--6.
select (select count(distinct(MEMBER_KEY))
          from factec_order
         where add_time between 20171101 and 20171131
           and order_state > 10
           and MEMBER_KEY in (select distinct (MEMBER_KEY)
                                from factec_order
                               where add_time between 20171001 and 20171031
                                 and order_state > 10)) /
       (select count(distinct(MEMBER_KEY))
          from factec_order
         where add_time between 20171001 and 20171031
           and order_state > 10)
  from dual;

--5.
select count(distinct(MEMBER_KEY))
  from factec_order
 where add_time between 20171101 and 20171131
   and order_state > 10
   and MEMBER_KEY in (select distinct (MEMBER_KEY)
                        from factec_order
                       where add_time between 20171001 and 20171031
                         and order_state > 10);

select sysdate, add_months(sysdate, 1) from dual;

SELECT SUBSTR(A.ADD_TIME, 1, 6) MONTH_KEY,
       COUNT(DISTINCT(A.MEMBER_KEY)) REPURCHASE_MEMBER_COUNT,
       SYSDATE W_INSERT_DT,
       SYSDATE W_UPDATE_DT
  FROM FACTEC_ORDER A
 WHERE A.ADD_TIME BETWEEN V_CUR_MONTH_FIRST_DAY_KEY AND IN_DATE_KEY
   AND A.ORDER_STATE > 10
   AND A.MEMBER_KEY IN (SELECT DISTINCT (B.MEMBER_KEY)
                          FROM FACTEC_ORDER B
                         WHERE B.ADD_TIME BETWEEN V_LAST_MONTH_FIRST_DAY_KEY AND
                               V_LAST_MONTH_LAST_DAY_KEY
                           AND B.ORDER_STATE > 10)
 GROUP BY SUBSTR(A.ADD_TIME, 1, 6);

SELECT D.MONTH_KEY,
       D.REPURCHASE_MEMBER_COUNT,
       E.LAS_MONTH_MEMBER_COUNT,
       SYSDATE                   W_INSERT_DT,
       SYSDATE                   W_UPDATE_DT
  FROM (SELECT SUBSTR(A.ADD_TIME, 1, 6) MONTH_KEY,
               COUNT(DISTINCT(A.MEMBER_KEY)) REPURCHASE_MEMBER_COUNT
          FROM FACTEC_ORDER A
         WHERE A.ADD_TIME BETWEEN &V_CUR_MONTH_FIRST_DAY_KEY AND
               &IN_DATE_KEY
           AND A.ORDER_STATE > 10
           AND A.MEMBER_KEY IN
               (SELECT DISTINCT (B.MEMBER_KEY)
                  FROM FACTEC_ORDER B
                 WHERE B.ADD_TIME BETWEEN &V_LAST_MONTH_FIRST_DAY_KEY AND
                       &V_LAST_MONTH_LAST_DAY_KEY
                   AND B.ORDER_STATE > 10)
         GROUP BY SUBSTR(A.ADD_TIME, 1, 6)) D,
       (SELECT TO_CHAR(ADD_MONTHS(TO_DATE(SUBSTR(C.ADD_TIME, 1, 6), 'YYYYMM'),
                                  1),
                       'YYYYMM') MONTH_KEY,
               COUNT(DISTINCT(C.MEMBER_KEY)) LAS_MONTH_MEMBER_COUNT
          FROM FACTEC_ORDER C
         WHERE C.ADD_TIME BETWEEN &V_LAST_MONTH_FIRST_DAY_KEY AND
               &V_LAST_MONTH_LAST_DAY_KEY
           AND C.ORDER_STATE > 10
         GROUP BY TO_CHAR(ADD_MONTHS(TO_DATE(SUBSTR(C.ADD_TIME, 1, 6),
                                             'YYYYMM'),
                                     1),
                          'YYYYMM')) E
 WHERE D.MONTH_KEY = E.MONTH_KEY;

SELECT TO_CHAR(ADD_MONTHS(TO_DATE('201801', 'YYYYMM'), 1), 'YYYYMM')
  FROM DUAL;

TO_CHAR(ADD_MONTHS(TO_DATE(SUBSTR(C.ADD_TIME, 1, 6), 'YYYYMM'), 1),
        'YYYYMM')
