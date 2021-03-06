SELECT A.MEMBER_KEY,
       NVL(B.M_LABEL_DESC, '��Ȼ') M_LABEL_DESC,
       NVL(C.REGISTER_RESOURCE, 'unknown') REGISTER_RESOURCE,
       NVL(D.MEMBER_TIME, '20170101') REG_DATE,
       NVL(E.ORDER_AMOUNT, 0) ORDER_AMOUNT
  FROM (SELECT MEMBER_KEY
          FROM FACT_SESSION
         WHERE START_DATE_KEY BETWEEN &S_LAST_MONTH_FIRST_DAY_KEY AND
               &S_LAST_MONTH_LAST_DAY_KEY
           AND MEMBER_KEY <> 0
         GROUP BY MEMBER_KEY) A,
       (SELECT MEMBER_KEY, MAX(M_LABEL_DESC) M_LABEL_DESC
          FROM MEMBER_LABEL_LINK_V
         WHERE M_LABEL_ID IN (143, 144, 145)
         GROUP BY MEMBER_KEY) B,
       (SELECT MEMBER_BP, REGISTER_RESOURCE FROM DIM_MEMBER) C,
       (SELECT MEMBER_CRMBP, MAX(MEMBER_TIME) MEMBER_TIME
          FROM FACT_ECMEMBER
         GROUP BY MEMBER_CRMBP) D,
       (SELECT MEMBER_KEY, SUM(ORDER_AMOUNT) ORDER_AMOUNT
          FROM FACTEC_ORDER A
         WHERE ADD_TIME BETWEEN &S_LAST_MONTH_FIRST_DAY_KEY AND
               &S_LAST_MONTH_LAST_DAY_KEY
           AND ORDER_STATE >= 10
         GROUP BY A.MEMBER_KEY) E
 WHERE A.MEMBER_KEY = B.MEMBER_KEY(+)
   AND A.MEMBER_KEY = C.MEMBER_BP(+)
   AND A.MEMBER_KEY = D.MEMBER_CRMBP(+)
   AND A.MEMBER_KEY = E.MEMBER_KEY(+);

SELECT COUNT(DISTINCT MEMBER_KEY)
  FROM FACT_SESSION
 WHERE START_DATE_KEY BETWEEN 20181101 AND 20181130
   AND MEMBER_KEY <> 0;

SELECT COUNT(1)
  FROM (SELECT MEMBER_CRMBP, MAX(MEMBER_TIME) MEMBER_TIME
          FROM FACT_ECMEMBER
         GROUP BY MEMBER_CRMBP) A
 WHERE A.MEMBER_TIME BETWEEN 20181101 AND 20181130;

SELECT COUNT(1)
  FROM (SELECT MEMBER_CRMBP, MAX(MEMBER_TIME) MEMBER_TIME
          FROM FACT_ECMEMBER
         GROUP BY MEMBER_CRMBP) A
 WHERE A.MEMBER_TIME BETWEEN 20181101 AND 20181130
   AND EXISTS (SELECT 1
          FROM FACT_SESSION B
         WHERE A.MEMBER_CRMBP = B.MEMBER_KEY
           AND B.START_DATE_KEY BETWEEN 20181101 AND 20181130
           AND B.MEMBER_KEY <> 0);


SELECT *
  FROM ALL_SOURCE A
 WHERE UPPER(A.TEXT) LIKE '%INSERT%FACT_ECMEMBER%';
 
SELECT A.START_DATE_KEY, COUNT(DISTINCT A.MEMBER_KEY)
  FROM FACT_SESSION A
 WHERE A.START_DATE_KEY >= 20181015
 GROUP BY A.START_DATE_KEY
 ORDER BY A.START_DATE_KEY;
