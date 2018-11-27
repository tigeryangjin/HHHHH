--1.STATS_ONLINE_GOOD_MINUTE重复值处理
--1.1.
SELECT DISTINCT A.STATDATE
  FROM STATS_ONLINE_GOOD_MINUTE A
 GROUP BY A.STATDATE,
          A.STATHOUR,
          A.STATMINUTE,
          A.START_TIME,
          A.END_TIME,
          A.APPLICATION_KEY,
          A.APPLICATION_NAME,
          A.GOOD_CODE,
          A.GOOD_NAME
HAVING COUNT(1) > 1
 ORDER BY A.STATDATE;

--1.2.
DECLARE
  IN_DATE_INT NUMBER(8);
  IN_DATE     DATE;
  BEGIN_DATE  DATE := DATE '2018-01-01';
  END_DATE    DATE := DATE '2018-12-31';
BEGIN
  IN_DATE := BEGIN_DATE;
  WHILE IN_DATE <= END_DATE LOOP
    IN_DATE_INT := TO_CHAR(IN_DATE, 'YYYYMMDD');
    DELETE STATS_ONLINE_GOOD_MINUTE A
     WHERE EXISTS (SELECT 1
              FROM (SELECT D.ID
                      FROM (SELECT C.ID,
                                   C.STATDATE,
                                   C.STATHOUR,
                                   C.STATMINUTE,
                                   C.START_TIME,
                                   C.END_TIME,
                                   C.APPLICATION_KEY,
                                   C.APPLICATION_NAME,
                                   C.GOOD_CODE,
                                   C.GOOD_NAME,
                                   ROW_NUMBER() OVER(PARTITION BY C.STATDATE, C.STATHOUR, C.STATMINUTE, C.START_TIME, C.END_TIME, C.APPLICATION_KEY, C.APPLICATION_NAME, C.GOOD_CODE, C.GOOD_NAME ORDER BY C.ID DESC) RN
                              FROM STATS_ONLINE_GOOD_MINUTE C
                             WHERE C.STATDATE = IN_DATE_INT) D
                     WHERE D.RN >= 2) B
             WHERE A.ID = B.ID);
    COMMIT;
    IN_DATE := IN_DATE + 1;
  END LOOP;
END;
/

--1.3.
ALTER TABLE DW_USER.STATS_ONLINE_GOOD_MINUTE MOVE PARALLEL(DEGREE 4) NOLOGGING;
ALTER INDEX DW_USER.GOOD1ID_IDX REBUILD PARALLEL(DEGREE 4) NOLOGGING;
ALTER INDEX DW_USER.GOOD1APP_IDX REBUILD PARALLEL(DEGREE 4) NOLOGGING;
ALTER INDEX DW_USER.GOOD1START_IDX REBUILD PARALLEL(DEGREE 4) NOLOGGING;
ALTER INDEX DW_USER.GOOD1APP_IDX NOPARALLEL;
ALTER INDEX DW_USER.GOOD1ID_IDX NOPARALLEL;
ALTER INDEX DW_USER.GOOD1START_IDX NOPARALLEL;

--1.4.
BEGIN
  DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'DW_USER',
                                TABNAME => 'STATS_ONLINE_GOOD_MINUTE',
                                DEGREE  => 4,
                                CASCADE => TRUE);
END;
/

--2.STATS_ONLINE_GOOD2_MINUTE重复值处理
--2.1.
  SELECT DISTINCT A.STATDATE
    FROM STATS_ONLINE_GOOD2_MINUTE A
   GROUP BY A.STATDATE,
            A.STATHOUR,
            A.STATMINUTE,
            A.START_TIME,
            A.END_TIME,
            A.APPLICATION_KEY,
            A.APPLICATION_NAME,
            A.GOOD_CODE,
            A.GOOD_NAME,
            A.PAGE_NAME,
            A.PAGE_VALUE
  HAVING COUNT(1) > 1
   ORDER BY A.STATDATE;

--2.2.
SELECT *
  FROM (SELECT A.ID,
               A.STATDATE,
               A.STATHOUR,
               A.STATMINUTE,
               A.START_TIME,
               A.END_TIME,
               A.APPLICATION_KEY,
               A.APPLICATION_NAME,
               A.GOOD_CODE,
               A.GOOD_NAME,
               A.PAGE_NAME,
               A.PAGE_VALUE,
               A.PV,
               A.UV,
               ROW_NUMBER() OVER(PARTITION BY A.STATDATE, A.STATHOUR, A.STATMINUTE, A.START_TIME, A.END_TIME, A.APPLICATION_KEY, A.APPLICATION_NAME, A.GOOD_CODE, A.GOOD_NAME, A.PAGE_NAME, A.PAGE_VALUE ORDER BY A.ID DESC) RN
          FROM STATS_ONLINE_GOOD2_MINUTE A
         WHERE A.STATDATE = 20160719) B
 WHERE B.RN >= 2;

--2.3.
DELETE STATS_ONLINE_GOOD2_MINUTE A
 WHERE EXISTS (SELECT 1
          FROM (SELECT D.ID
                  FROM (SELECT C.ID,
                               C.STATDATE,
                               C.STATHOUR,
                               C.STATMINUTE,
                               C.START_TIME,
                               C.END_TIME,
                               C.APPLICATION_KEY,
                               C.APPLICATION_NAME,
                               C.GOOD_CODE,
                               C.GOOD_NAME,
                               C.PAGE_NAME,
                               C.PAGE_VALUE,
                               C.PV,
                               C.UV,
                               ROW_NUMBER() OVER(PARTITION BY C.STATDATE, C.STATHOUR, C.STATMINUTE, C.START_TIME, C.END_TIME, C.APPLICATION_KEY, C.APPLICATION_NAME, C.GOOD_CODE, C.GOOD_NAME, C.PAGE_NAME, C.PAGE_VALUE ORDER BY C.ID DESC) RN
                          FROM STATS_ONLINE_GOOD2_MINUTE C
                         WHERE C.STATDATE = 20160719) D
                 WHERE D.RN >= 2) B
         WHERE A.ID = B.ID);

--2.4.
DECLARE
  IN_DATE_INT NUMBER(8);
  IN_DATE     DATE;
  BEGIN_DATE  DATE := DATE '2016-07-19';
  END_DATE    DATE := DATE '2016-07-31';
BEGIN
  IN_DATE := BEGIN_DATE;
  WHILE IN_DATE <= END_DATE LOOP
    IN_DATE_INT := TO_CHAR(IN_DATE, 'YYYYMMDD');
    DELETE STATS_ONLINE_GOOD2_MINUTE A
     WHERE EXISTS (SELECT 1
              FROM (SELECT D.ID
                      FROM (SELECT C.ID,
                                   C.STATDATE,
                                   C.STATHOUR,
                                   C.STATMINUTE,
                                   C.START_TIME,
                                   C.END_TIME,
                                   C.APPLICATION_KEY,
                                   C.APPLICATION_NAME,
                                   C.GOOD_CODE,
                                   C.GOOD_NAME,
                                   C.PAGE_NAME,
                                   C.PAGE_VALUE,
                                   C.PV,
                                   C.UV,
                                   ROW_NUMBER() OVER(PARTITION BY C.STATDATE, C.STATHOUR, C.STATMINUTE, C.START_TIME, C.END_TIME, C.APPLICATION_KEY, C.APPLICATION_NAME, C.GOOD_CODE, C.GOOD_NAME, C.PAGE_NAME, C.PAGE_VALUE ORDER BY C.ID DESC) RN
                              FROM STATS_ONLINE_GOOD2_MINUTE C
                             WHERE C.STATDATE = IN_DATE_INT) D
                     WHERE D.RN >= 2) B
             WHERE A.ID = B.ID);
    COMMIT;
    IN_DATE := IN_DATE + 1;
  END LOOP;
END;
/

--2.5
ALTER TABLE DW_USER.STATS_ONLINE_GOOD2_MINUTE MOVE PARALLEL(DEGREE 4) NOLOGGING;
ALTER INDEX DW_USER.GOOD2ID_IDX REBUILD PARALLEL(DEGREE 4) NOLOGGING;
ALTER INDEX DW_USER.GOOD2APP_IDX REBUILD PARALLEL(DEGREE 4) NOLOGGING;
ALTER INDEX DW_USER.GOOD2START_IDX REBUILD PARALLEL(DEGREE 4) NOLOGGING;
ALTER INDEX DW_USER.GOOD2APP_IDX NOPARALLEL;
ALTER INDEX DW_USER.GOOD2ID_IDX NOPARALLEL;
ALTER INDEX DW_USER.GOOD2START_IDX NOPARALLEL;

--2.6
BEGIN
  DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'DW_USER',
                                TABNAME => 'STATS_ONLINE_GOOD2_MINUTE',
                                DEGREE  => 4,
                                CASCADE => TRUE);
END;
/

--tmp
  SELECT *
    FROM STATS_ONLINE_GOOD2_MINUTE A
   WHERE A.STATDATE = 20160719
     AND A.STATHOUR = 4
     AND A.STATMINUTE = 40
     AND A.APPLICATION_KEY = 10
     AND A.PAGE_NAME = 'Category';
