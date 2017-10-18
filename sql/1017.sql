INSERT INTO FACT_PV_IA_HMSC
  (VISIT_DATE_KEY,
   APPLICATION_KEY,
   HMMD,
   HMPL,
   XLFLAG,
   GOODS_COMMONID,
   PV_IP_CITY,
   MCNT,
   VCNT,
   SCNT)
  SELECT /*+PARALLEL(16)*/
   F.VISIT_DATE_KEY,
   F.APPLICATION_KEY,
   F.HMMD,
   F.HMPL,
   F.XLFLAG,
   F.GOODS_COMMONID,
   YANGJIN_PKG.GET_IP_CITY(F.IP_INT) PV_IP_CITY,
   SUM(F.MCNT) MCNT,
   SUM(F.VCNT) VCNT,
   SUM(F.SCNT) SCNT
    FROM (SELECT E.VISIT_DATE_KEY,
                 E.APPLICATION_KEY,
                 E.HMMD,
                 E.HMPL,
                 E.XLFLAG,
                 E.GOODS_COMMONID,
                 E.IP_INT,
                 COUNT(DISTINCT E.MEMBER_KEY) MCNT,
                 COUNT(DISTINCT E.DEVICE_KEY) VCNT,
                 COUNT(DISTINCT E.SESSION_KEY) SCNT
            FROM (SELECT A.VISIT_DATE_KEY,
                         DECODE(A.APPLICATION_KEY, 10, 'IOS', 20, 'ANDROID') AS APPLICATION_KEY,
                         (SELECT B.HMMD FROM DIM_HMSC B WHERE B.HMSC = A.HMSC) AS HMMD,
                         (SELECT C.HMPL FROM DIM_HMSC C WHERE C.HMSC = A.HMSC) AS HMPL,
                         CASE
                           WHEN EXISTS
                            (SELECT *
                                   FROM FACT_VISITOR_REGISTER D
                                  WHERE D.CREATE_DATE_KEY BETWEEN
                                        TO_NUMBER(TO_CHAR(ADD_MONTHS(TO_DATE(TO_CHAR(&STARTPOINT),
                                                                             'yyyymmdd'),
                                                                     -1),
                                                          'yyyymmdd')) AND
                                        &STARTPOINT
                                    AND D.VISTOR_KEY = A.DEVICE_KEY) THEN
                            '新用户'
                           ELSE
                            '老用户'
                         END AS XLFLAG,
                         A.PAGE_VALUE GOODS_COMMONID,
                         A.IP_INT,
                         A.MEMBER_KEY,
                         A.DEVICE_KEY,
                         A.SESSION_KEY
                    FROM FACT_PAGE_VIEW A
                   WHERE UPPER(A.PAGE_NAME) = 'GOOD'
                     AND REGEXP_LIKE(A.PAGE_VALUE, '^[[:digit:]]+$')
                     AND A.VISIT_DATE_KEY = &STARTPOINT) E
           GROUP BY E.VISIT_DATE_KEY,
                    E.APPLICATION_KEY,
                    E.HMMD,
                    E.HMPL,
                    E.XLFLAG,
                    E.GOODS_COMMONID,
                    E.IP_INT) F
   GROUP BY F.VISIT_DATE_KEY,
            F.APPLICATION_KEY,
            F.HMMD,
            F.HMPL,
            F.XLFLAG,
            F.GOODS_COMMONID,
            YANGJIN_PKG.GET_IP_CITY(F.IP_INT);

SELECT A.VISIT_DATE_KEY,
       DECODE(A.APPLICATION_KEY, 10, 'IOS', 20, 'ANDROID') AS APPLICATION_KEY,
       (SELECT B.HMMD FROM DIM_HMSC B WHERE B.HMSC = A.HMSC) AS HMMD,
       (SELECT C.HMPL FROM DIM_HMSC C WHERE C.HMSC = A.HMSC) AS HMPL,
       CASE
         WHEN EXISTS (SELECT *
                 FROM FACT_VISITOR_REGISTER D
                WHERE D.CREATE_DATE_KEY BETWEEN
                      TO_NUMBER(TO_CHAR(ADD_MONTHS(TO_DATE(TO_CHAR(&STARTPOINT),
                                                           'yyyymmdd'),
                                                   -1),
                                        'yyyymmdd')) AND &STARTPOINT
                  AND D.VISTOR_KEY = A.DEVICE_KEY) THEN
          '新用户'
         ELSE
          '老用户'
       END AS XLFLAG,
       A.PAGE_VALUE GOODS_COMMONID,
       A.IP_INT,
       A.MEMBER_KEY,
       A.DEVICE_KEY,
       A.SESSION_KEY
  FROM FACT_PAGE_VIEW A
 WHERE UPPER(A.PAGE_NAME) = 'GOOD'
   AND REGEXP_LIKE(A.PAGE_VALUE, '^[[:digit:]]+$')
   AND A.VISIT_DATE_KEY = &STARTPOINT;
