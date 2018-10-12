--1.source
select VISIT_DATE_KEY ����,
       UV             ��������,
       ZC             ע������,
       ZD             �ܶ�������,
       YXRS           ��Ч��������,
       YXDS           ��Ч��������,
       YXJE           ��Ч�������
  from (select count(distinct IP) UV,
               count(distinct c.MEMBER_KEY) ZC,
               VISIT_DATE_KEY
          from (select VID, IP, VISIT_DATE_KEY
                  from fact_page_view
                 where visit_date_key between
                       to_char(sysdate - 15, 'yyyymmdd') and
                       to_char(sysdate - 1, 'yyyymmdd')
                   and page_name = 'MobileHome'
                   and APPLICATION_KEY = 30
                 group by VID, IP, VISIT_DATE_KEY) a
          left join
        
         (select VID, FIST_IP, START_DATE_KEY, MEMBER_KEY
           from (select VID, FIST_IP, START_DATE_KEY, MEMBER_KEY
                   from fact_session
                  where START_DATE_KEY between
                        to_char(sysdate - 15, 'yyyymmdd') and
                        to_char(sysdate - 1, 'yyyymmdd')
                    and APPLICATION_KEY = 30) s
           join (select MEMBER_CRMBP, MEMBER_TIME
                  from fact_ecmember
                 where MEMBER_TIME between to_char(sysdate - 15, 'yyyymmdd') and
                       to_char(sysdate - 1, 'yyyymmdd')) ss
             on s.MEMBER_KEY = ss.MEMBER_CRMBP
            and s.START_DATE_KEY = ss.MEMBER_TIME
          group by VID, FIST_IP, START_DATE_KEY, MEMBER_KEY) c
            on
        
         (a.ip = c.FIST_IP and a.VISIT_DATE_KEY = c.START_DATE_KEY)
        
         group by VISIT_DATE_KEY) s
  left join (select count(distinct vid) zd, add_time
               from factec_order
              where add_time between to_char(sysdate - 15, 'yyyymmdd') and
                    to_char(sysdate - 1, 'yyyymmdd')
                and order_from = 83
              group by add_time) ss
    on s.VISIT_DATE_KEY = ss.add_time

  left join (select count(distinct vid) yxrs,
                    count(1) yxds,
                    sum(order_amount) yxje,
                    add_time
               from factec_order
              where add_time between to_char(sysdate - 15, 'yyyymmdd') and
                    to_char(sysdate - 1, 'yyyymmdd')
                and order_from = 83
                and order_state > 10
              group by add_time) sss
    on s.VISIT_DATE_KEY = sss.add_time;

--2.
CREATE TABLE OPER_MOBILEHOME_REPORT AS
  SELECT VISIT_DATE_KEY, UV, ZC, ZD, YXRS, YXDS, YXJE
    FROM (SELECT COUNT(DISTINCT IP) UV,
                 COUNT(DISTINCT C.MEMBER_KEY) ZC,
                 VISIT_DATE_KEY
            FROM (SELECT VID, IP, VISIT_DATE_KEY
                    FROM FACT_PAGE_VIEW
                   WHERE VISIT_DATE_KEY = 20180723
                     AND PAGE_NAME = 'MobileHome'
                     AND APPLICATION_KEY = 30
                   GROUP BY VID, IP, VISIT_DATE_KEY) A
            LEFT JOIN
          
           (SELECT VID, FIST_IP, START_DATE_KEY, MEMBER_KEY
             FROM (SELECT VID, FIST_IP, START_DATE_KEY, MEMBER_KEY
                     FROM FACT_SESSION
                    WHERE START_DATE_KEY = 20180723
                      AND APPLICATION_KEY = 30) S
             JOIN (SELECT MEMBER_CRMBP, MEMBER_TIME
                    FROM FACT_ECMEMBER
                   WHERE MEMBER_TIME = 20180723) SS
               ON S.MEMBER_KEY = SS.MEMBER_CRMBP
              AND S.START_DATE_KEY = SS.MEMBER_TIME
            GROUP BY VID, FIST_IP, START_DATE_KEY, MEMBER_KEY) C
              ON
          
           (A.IP = C.FIST_IP AND A.VISIT_DATE_KEY = C.START_DATE_KEY)
          
           GROUP BY VISIT_DATE_KEY) S
    LEFT JOIN (SELECT COUNT(DISTINCT VID) ZD, ADD_TIME
                 FROM FACTEC_ORDER
                WHERE ADD_TIME = 20180723
                  AND ORDER_FROM = 83
                GROUP BY ADD_TIME) SS
      ON S.VISIT_DATE_KEY = SS.ADD_TIME
  
    LEFT JOIN (SELECT COUNT(DISTINCT VID) YXRS,
                      COUNT(1) YXDS,
                      SUM(ORDER_AMOUNT) YXJE,
                      ADD_TIME
                 FROM FACTEC_ORDER
                WHERE ADD_TIME = 20180723
                  AND ORDER_FROM = 83
                  AND ORDER_STATE > 10
                GROUP BY ADD_TIME) SSS
      ON S.VISIT_DATE_KEY = SSS.ADD_TIME;

--3.
INSERT INTO OPER_MOBILEHOME_REPORT
  (VISIT_DATE_KEY, UV, ZC, ZD, YXRS, YXDS, YXJE, W_INSERT_DT, W_UPDATE_DT)
  SELECT VISIT_DATE_KEY,
         UV,
         ZC,
         ZD,
         YXRS,
         YXDS,
         YXJE,
         SYSDATE        W_INSERT_DT,
         SYSDATE        W_UPDATE_DT
    FROM (SELECT COUNT(DISTINCT IP) UV,
                 COUNT(DISTINCT C.MEMBER_KEY) ZC,
                 VISIT_DATE_KEY
            FROM (SELECT VID, IP, VISIT_DATE_KEY
                    FROM FACT_PAGE_VIEW
                   WHERE VISIT_DATE_KEY = 20180723
                     AND PAGE_NAME = 'MobileHome'
                     AND APPLICATION_KEY = 30
                   GROUP BY VID, IP, VISIT_DATE_KEY) A
            LEFT JOIN
          
           (SELECT VID, FIST_IP, START_DATE_KEY, MEMBER_KEY
             FROM (SELECT VID, FIST_IP, START_DATE_KEY, MEMBER_KEY
                     FROM FACT_SESSION
                    WHERE START_DATE_KEY = 20180723
                      AND APPLICATION_KEY = 30) S
             JOIN (SELECT MEMBER_CRMBP, MEMBER_TIME
                    FROM FACT_ECMEMBER
                   WHERE MEMBER_TIME = 20180723) SS
               ON S.MEMBER_KEY = SS.MEMBER_CRMBP
              AND S.START_DATE_KEY = SS.MEMBER_TIME
            GROUP BY VID, FIST_IP, START_DATE_KEY, MEMBER_KEY) C
              ON
          
           (A.IP = C.FIST_IP AND A.VISIT_DATE_KEY = C.START_DATE_KEY)
          
           GROUP BY VISIT_DATE_KEY) S
    LEFT JOIN (SELECT COUNT(DISTINCT VID) ZD, ADD_TIME
                 FROM FACTEC_ORDER
                WHERE ADD_TIME = 20180723
                  AND ORDER_FROM = 83
                GROUP BY ADD_TIME) SS
      ON S.VISIT_DATE_KEY = SS.ADD_TIME
  
    LEFT JOIN (SELECT COUNT(DISTINCT VID) YXRS,
                      COUNT(1) YXDS,
                      SUM(ORDER_AMOUNT) YXJE,
                      ADD_TIME
                 FROM FACTEC_ORDER
                WHERE ADD_TIME = 20180723
                  AND ORDER_FROM = 83
                  AND ORDER_STATE > 10
                GROUP BY ADD_TIME) SSS
      ON S.VISIT_DATE_KEY = SSS.ADD_TIME;

--4.
SELECT * FROM S_PARAMETERS2 FOR UPDATE;

--5.
DECLARE
  IN_DATE_INT NUMBER(8);
  IN_DATE     DATE;
  BEGIN_DATE  DATE := DATE '2018-07-01';
  END_DATE    DATE := DATE '2018-07-23';
BEGIN
  IN_DATE := BEGIN_DATE;
  WHILE IN_DATE <= END_DATE LOOP
    IN_DATE_INT := TO_CHAR(IN_DATE, 'YYYYMMDD');
    YJ_REPORT.OPER_MOBILEHOME_REPORT_PROC(IN_DATE_INT);
    IN_DATE := IN_DATE + 1;
  END LOOP;
END;
/

--7.
  SELECT *
    FROM W_ETL_LOG A
   WHERE A.PROC_NAME = 'YJ_REPORT.OPER_MOBILEHOME_REPORT_PROC'
   ORDER BY A.START_TIME DESC;

--8.
DROP TABLE OPER_MOBILEHOME_REPORT_BAK;
CREATE TABLE OPER_MOBILEHOME_REPORT_BAK AS
  SELECT * FROM OPER_MOBILEHOME_REPORT;

TRUNCATE TABLE OPER_MOBILEHOME_REPORT;

INSERT INTO OPER_MOBILEHOME_REPORT
  (VISIT_DATE, UV, ZC, ZD, YXRS, YXDS, YXJE, W_INSERT_DT, W_UPDATE_DT)
  SELECT TO_DATE(A.VISIT_DATE_KEY, 'YYYYMMDD') VISIT_DATE,
         A.UV,
         A.ZC,
         A.ZD,
         A.YXRS,
         A.YXDS,
         A.YXJE,
         A.W_INSERT_DT,
         A.W_UPDATE_DT
    FROM OPER_MOBILEHOME_REPORT_BAK A;
