SELECT C.OS, C.VER_NAME, COUNT(C.VID)
  FROM (SELECT B.START_DATE_KEY,
               B.CHANNEL_KEY,
               B.VER_NAME,
               B.VID,
               B.OS,
               RANK() OVER(PARTITION BY B.VID ORDER BY B.START_DATE_KEY DESC) RANK1
          FROM (SELECT A.START_DATE_KEY,
                       A.VID,
                       A.CHANNEL_KEY,
                       A.VER_NAME,
                       CASE
                         WHEN UPPER(A.VID) LIKE 'IPHONE%' THEN
                          'IOS'
                         ELSE
                          'ANDROID'
                       END OS
                  FROM FACT_SESSION A
                 WHERE A.START_DATE_KEY >= 20170101
                   AND A.VER_NAME NOT IN ('unknown', 'undefined')
                   AND A.CHANNEL_KEY = 3) B) C
 GROUP BY C.OS, C.VER_NAME;
