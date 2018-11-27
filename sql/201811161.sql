
--OS
SELECT A.AGENT,
       COUNT(1) CNT,
       CASE
         WHEN REGEXP_SUBSTR(A.AGENT, 'Android') = 'Android' THEN
          'Google'
         WHEN REGEXP_SUBSTR(A.AGENT, 'AppleWebKit') = 'AppleWebKit' THEN
          'Apple'
         WHEN REGEXP_SUBSTR(A.AGENT, 'Windows') = 'Windows' THEN
          'Windows'
         WHEN REGEXP_SUBSTR(A.AGENT, 'MicroMessenger') = 'MicroMessenger' THEN
          'Tencent'
         WHEN REGEXP_SUBSTR(A.AGENT, 'Google') = 'Google' THEN
          'Google'
         WHEN REGEXP_SUBSTR(A.AGENT, 'Macintosh') = 'Macintosh' THEN
          'Apple'
         ELSE
          'Other'
       END COL1
  FROM FACT_PAGE_VIEW A
 WHERE A.VISIT_DATE_KEY = 20181116
   AND A.AGENT IS NOT NULL
 GROUP BY A.AGENT
 ORDER BY COUNT(1) DESC;

--Android version
SELECT C.ANDROID, C.VER, SUM(C.CNT) CNT
  FROM (SELECT CASE
                 WHEN REGEXP_SUBSTR(B.AGENT, 'Android') = 'Android' THEN
                  'Android'
                 ELSE
                  'Non Android'
               END ANDROID,
               CASE
                 WHEN SUBSTR(REGEXP_SUBSTR(B.AGENT, 'Android [0-9.]*'), 1, 7) =
                      'Android' THEN
                  SUBSTR(REGEXP_SUBSTR(B.AGENT, 'Android [0-9.]*'), 9)
                 WHEN SUBSTR(REGEXP_SUBSTR(B.AGENT, 'Android/[0-9.]*'), 1, 7) =
                      'Android' THEN
                  SUBSTR(REGEXP_SUBSTR(B.AGENT, 'Android/[0-9.]*'), 9)
               END VER,
               B.CNT
          FROM (SELECT A.AGENT, COUNT(1) CNT
                  FROM FACT_PAGE_VIEW A
                 WHERE A.VISIT_DATE_KEY = 20181116
                   AND A.AGENT IS NOT NULL
                 GROUP BY A.AGENT) B) C
 WHERE C.ANDROID = 'Android'
 GROUP BY C.ANDROID, C.VER;

SELECT B.ANDROID || B.VER ANDVER, SUM(B.CNT) CNT
  FROM (SELECT A.AGENT,
               COUNT(1) CNT,
               CASE
                 WHEN REGEXP_SUBSTR(A.AGENT, 'Android') = 'Android' THEN
                  'Android'
                 ELSE
                  'Non Android'
               END ANDROID,
               CASE
                 WHEN SUBSTR(REGEXP_SUBSTR(A.AGENT, 'Android [0-9.]*'), 1, 7) =
                      'Android' THEN
                  SUBSTR(REGEXP_SUBSTR(A.AGENT, 'Android [0-9.]*'), 9)
                 WHEN SUBSTR(REGEXP_SUBSTR(A.AGENT, 'Android/[0-9.]*'), 1, 7) =
                      'Android' THEN
                  SUBSTR(REGEXP_SUBSTR(A.AGENT, 'Android/[0-9.]*'), 9)
               END VER
          FROM FACT_PAGE_VIEW A
         WHERE A.VISIT_DATE_KEY = 20181116
           AND A.AGENT IS NOT NULL
         GROUP BY A.AGENT
         ORDER BY COUNT(1) DESC) B
 WHERE B.ANDROID = 'Android'
 GROUP BY B.ANDROID, B.VER
 ORDER BY B.ANDROID || B.VER DESC;

SELECT REGEXP_SUBSTR('HUAWEI Y325-T00_TD/V1 Linux/3.4.5 Android/2.3.6 Release/03.26.2013 Browser/AppleWebKit533.1 Mobile Safari/533.1;',
                     'Android/[0-9.]*'),
       REGEXP_REPLACE('HUAWEI Y325-T00_TD/V1 Linux/3.4.5 Android/2.3.6 Release/03.26.2013 Browser/AppleWebKit533.1 Mobile Safari/533.1;',
                      'Android/[0-9.]*')
  FROM DUAL;

SELECT REGEXP_SUBSTR('aa<div>test1</div>bb<div>test2</div>cc','<div>.*</div>') FROM DUAL;

SELECT * FROM DBA_OBJECTS A WHERE A.OBJECT_NAME='DBMS_SUPPORT_INTERNAL';

SELECT 288/8/2.5/2 FROM DUAL;
