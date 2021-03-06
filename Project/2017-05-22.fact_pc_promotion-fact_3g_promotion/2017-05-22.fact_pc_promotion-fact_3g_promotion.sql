--1.UPDATE fact_pc_promotion
UPDATE FACT_PC_PROMOTION A
   SET (A.FIRST_DATE, A.FIRST_LEVEL2) =
       (SELECT C.MAXDATE, C.LEVEL2
          FROM FACT_PC_PROMOTION C
         WHERE EXISTS (SELECT 1
                  FROM (SELECT B.VID, MIN(B.MAXDATE) FIRST_DATE
                          FROM FACT_PC_PROMOTION B
                         GROUP BY B.VID) D
                 WHERE C.VID = D.VID
                   AND C.MAXDATE = D.FIRST_DATE)
           AND A.VID = C.VID)
 WHERE EXISTS (SELECT 1
          FROM FACT_PC_PROMOTION E
         WHERE EXISTS (SELECT 1
                  FROM (SELECT G.VID, MIN(G.MAXDATE) FIRST_DATE
                          FROM FACT_PC_PROMOTION G
                         GROUP BY G.VID) F
                 WHERE E.VID = F.VID
                   AND E.MAXDATE = F.FIRST_DATE)
           AND A.VID = E.VID)
   AND A.FIRST_DATE IS NULL;

--2.UPDATE fact_3g_promotion
UPDATE FACT_3G_PROMOTION A
   SET (A.FIRST_DATE, A.FIRST_LEVEL2) =
       (SELECT C.MAXDATE, C.LEVEL2
          FROM FACT_3G_PROMOTION C
         WHERE EXISTS (SELECT 1
                  FROM (SELECT B.VID, MIN(B.MAXDATE) FIRST_DATE
                          FROM FACT_3G_PROMOTION B
                         GROUP BY B.VID) D
                 WHERE C.VID = D.VID
                   AND C.MAXDATE = D.FIRST_DATE)
           AND A.VID = C.VID)
 WHERE EXISTS (SELECT 1
          FROM FACT_3G_PROMOTION E
         WHERE EXISTS (SELECT 1
                  FROM (SELECT G.VID, MIN(G.MAXDATE) FIRST_DATE
                          FROM FACT_3G_PROMOTION G
                         GROUP BY G.VID) F
                 WHERE E.VID = F.VID
                   AND E.MAXDATE = F.FIRST_DATE)
           AND A.VID = E.VID)
   AND A.FIRST_DATE IS NULL;

--3.FACT_DAILY_3GPROMOTION,FACT_DAILY_PCPROMOTION history data fix
UPDATE FACT_DAILY_3GPROMOTION A
   SET (A.FIRST_DATE, A.FIRST_LEVEL2) =
       (SELECT MIN(B.FIRST_DATE), MIN(B.FIRST_LEVEL2)
          FROM FACT_3G_PROMOTION B
         WHERE A.VID = B.VID)
 WHERE EXISTS (SELECT 1
          FROM (SELECT D.VID, MIN(D.FIRST_DATE), MIN(D.FIRST_LEVEL2)
                  FROM FACT_3G_PROMOTION D
                 GROUP BY D.VID) C
         WHERE A.VID = C.VID)
   AND A.FIRST_DATE IS NULL;
COMMIT;

UPDATE FACT_DAILY_PCPROMOTION A
   SET (A.FIRST_DATE, A.FIRST_LEVEL2) =
       (SELECT MIN(B.FIRST_DATE), MIN(B.FIRST_LEVEL2)
          FROM FACT_PC_PROMOTION B
         WHERE A.VID = B.VID)
 WHERE EXISTS (SELECT 1
          FROM (SELECT D.VID, MIN(D.FIRST_DATE), MIN(D.FIRST_LEVEL2)
                  FROM FACT_PC_PROMOTION D
                 GROUP BY D.VID) C
         WHERE A.VID = C.VID)
   AND A.FIRST_DATE IS NULL;
COMMIT;

--FACT_DAILY_3GPROMOTION
DROP TABLE JIN_3G_PROMOTION_VID_TMP;
CREATE TABLE JIN_3G_PROMOTION_VID_TMP AS
  SELECT B.VID, B.ACTIVE_DATE, B.LEVEL2
    FROM (SELECT T.VID,
                 T.ACTIVE_DATE,
                 T.LEVEL2,
                 RANK() OVER(PARTITION BY T.VID ORDER BY T.ACTIVE_DATE) RANK1
            FROM FACT_VISITOR_ACTIVE T
           WHERE T.APPLICATION_KEY = 30
             AND T.LEVEL1 IN ('SEM', 'DSP', 'CPS')
             AND EXISTS (SELECT 1
                    FROM FACT_DAILY_3GPROMOTION A
                   WHERE A.VID = T.VID
                     AND A.FIRST_DATE IS NULL)) B
   WHERE B.RANK1 = 1;

UPDATE FACT_DAILY_3GPROMOTION C
   SET (C.FIRST_DATE, C.FIRST_LEVEL2) =
       (SELECT D.ACTIVE_DATE, D.LEVEL2
          FROM JIN_3G_PROMOTION_VID_TMP D
         WHERE C.VID = D.VID)
 WHERE EXISTS (SELECT 1 FROM JIN_3G_PROMOTION_VID_TMP E WHERE C.VID = E.VID)
   AND C.FIRST_DATE IS NULL;

--FACT_DAILY_PCPROMOTION
DROP TABLE JIN_PC_PROMOTION_VID_TMP;
CREATE TABLE JIN_PC_PROMOTION_VID_TMP AS
  SELECT B.VID, B.ACTIVE_DATE, B.LEVEL2
    FROM (SELECT T.VID,
                 T.ACTIVE_DATE,
                 T.LEVEL2,
                 RANK() OVER(PARTITION BY T.VID ORDER BY T.ACTIVE_DATE) RANK1
            FROM FACT_VISITOR_ACTIVE T
           WHERE T.APPLICATION_KEY = 40
             AND T.LEVEL1 IN ('SEM', 'DSP', 'CPS')
             AND EXISTS (SELECT 1
                    FROM FACT_DAILY_PCPROMOTION A
                   WHERE A.VID = T.VID
                     AND A.FIRST_DATE IS NULL)) B
   WHERE B.RANK1 = 1;

UPDATE FACT_DAILY_PCPROMOTION C
   SET (C.FIRST_DATE, C.FIRST_LEVEL2) =
       (SELECT D.ACTIVE_DATE, D.LEVEL2
          FROM JIN_PC_PROMOTION_VID_TMP D
         WHERE C.VID = D.VID)
 WHERE EXISTS (SELECT 1
          FROM JIN_PC_PROMOTION_VID_TMP E
         WHERE C.VID = E.VID)
   AND C.FIRST_DATE IS NULL;

--4.TMP
SELECT B.VID, B.ACTIVE_DATE, B.LEVEL2
  FROM (SELECT T.VID,
               T.ACTIVE_DATE,
               T.LEVEL2,
               RANK() OVER(PARTITION BY T.VID ORDER BY T.ACTIVE_DATE) RANK1
          FROM FACT_VISITOR_ACTIVE T
         WHERE T.APPLICATION_KEY = 30
           AND T.LEVEL1 IN ('SEM', 'DSP', 'CPS')
           AND EXISTS (SELECT 1
                  FROM FACT_DAILY_3GPROMOTION A
                 WHERE A.VID = T.VID
                   AND A.FIRST_DATE IS NULL)) B
 WHERE B.RANK1 = 1;

SELECT *
  FROM FACT_VISITOR_ACTIVE T
 WHERE T.VID = 'webmportal51a04d148fc5da144cc764bde0677d8e'
 ORDER BY T.ACTIVE_DATE;
SELECT *
  FROM FACT_3G_PROMOTION T
 WHERE T.VID = 'webmportal51a04d148fc5da144cc764bde0677d8e';
SELECT *
  FROM FACT_DAILY_3GPROMOTION T
 WHERE T.VID = 'webmportal51a04d148fc5da144cc764bde0677d8e';
SELECT * FROM FACT_3G_PROMOTION;
SELECT COUNT(1) FROM fact_daily_pcpromotion T WHERE T.FIRST_DATE IS NULL;
SELECT COUNT(1) FROM FACT_DAILY_3GPROMOTION T WHERE T.FIRST_DATE IS NULL;
SELECT *
  FROM FACT_3G_PROMOTION T
 WHERE T.VID = 'webmportal51a04d148fc5da144cc764bde0677d8e';
SELECT *
  FROM ALL_SOURCE T
 WHERE UPPER(T.TEXT) LIKE '%FACT_DAILY_3GPROMOTION%';
SELECT T.VID, COUNT(1)
  FROM FACT_PC_PROMOTION T
 GROUP BY T.VID
HAVING COUNT(1) > 1;
SELECT *
  FROM FACT_PC_PROMOTION T
 WHERE T.VID = 'webportalf36a3eef33825b00c84613bd2bf0624e'
 ORDER BY T.MAXDATE;

SELECT *
  FROM W_ETL_LOG T
 WHERE T.PROC_NAME = 'process3gpromotion'
 ORDER BY T.START_TIME DESC;
SELECT *
  FROM W_ETL_LOG T
 WHERE T.PROC_NAME = 'processpcpromotion'
 ORDER BY T.START_TIME DESC;

SELECT C.VID, C.MAXDATE, C.LEVEL2
  FROM FACT_PC_PROMOTION C
 WHERE EXISTS (SELECT 1
          FROM (SELECT B.VID, MIN(B.MAXDATE) FIRST_DATE
                  FROM FACT_PC_PROMOTION B
                 GROUP BY B.VID) D
         WHERE C.VID = D.VID
           AND C.MAXDATE = D.FIRST_DATE);
SELECT B.VID, MIN(B.MAXDATE) FIRST_DATE
  FROM FACT_PC_PROMOTION B
 GROUP BY B.VID;
SELECT * FROM fact_pc_promotion T WHERE T.FIRST_DATE IS NULL;
SELECT * FROM fact_3g_promotion T WHERE T.FIRST_DATE IS NULL;
SELECT COUNT(1) FROM fact_pc_promotion;
SELECT COUNT(1) FROM fact_3g_promotion;
select * from FACT_VISITOR_ACTIVE t;

SELECT * FROM fact_3g_promotion;
SELECT * FROM ALL_SOURCE T WHERE UPPER(T.TEXT) LIKE '%FACT_PC_PROMOTION%';
SELECT * FROM ALL_SOURCE T WHERE UPPER(T.TEXT) LIKE '%FACT_3G_PROMOTION%';
SELECT * V$SQL T WHERE UPPER(T."SQL_FULLTEXT")
