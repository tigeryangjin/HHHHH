???create or replace procedure bihappigo.sp_sbi_w_day_d(v_start_day IN NUMBER, --YYYYMMDD
                                           v_end_day   IN NUMBER, --YYYYMMDD
                                           av_r_status OUT NUMBER, --返回代码
                                           ls_error    OUT VARCHAR2 --错误描述符
                                           ) is

  /*******************************************************************************
  功能描述：
      生成w_day_d表的时间
  输入：
      in_begin_date varchar2 开始时间 ,in_end_date varchar2 结束时间
  输出：
     0：正常，
     其他：异常
  Author:
     hbli
  Date: 20090520
  *****************************************************************************/

  --LD_START_DATE DATE;
  -- LD_END_DATE   DATE;

  V_START_TIME TIMESTAMP;
  V_END_TIME   TIMESTAMP;
  L_LOG_REC    W_ETL_LOG%ROWTYPE;

begin

  --<LOG1 BEGIN>
  L_LOG_REC.PROC_NAME  := 'SP_SBI_W_DAY_D';
  L_LOG_REC.TABLE_NAME := 'W_DAY_D';
  L_LOG_REC.TABLE_TYPE := 'D';

  SELECT MAX(T.PROC_ID)
    INTO L_LOG_REC.PROC_ID
    FROM W_ETL_LOG T
   WHERE T.PROC_NAME IS NULL;

  SELECT CURRENT_TIMESTAMP INTO V_START_TIME FROM DUAL;
  --<LOG1 END>

  DELETE DIM_DATE;
  COMMIT;

  --初始化时间维表数据
  ----------------------------
  INSERT INTO DIM_DATE
    (ENT_PERIOD_AGO_WID --NUMBER(15)
    ,
     DATE_KEY --NUMBER(10) NOT NULL,
    ,
     CALENDAR_DATE --DATE,
    ,
     CAL_HALF --NUMBER(2)
    ,
     CAL_MONTH --NUMBER(2)
    ,
     CAL_QTR --NUMBER(1)
    ,
     CAL_TRIMESTER --NUMBER(10)
    ,
     CAL_WEEK --NUMBER(2)
    ,
     CAL_YEAR --NUMBER(4)
    ,
     DATASOURCE_NUM_ID --NUMBER(10) NOT NULL,
    ,
     DATE_ID_KEY --NUMBER(10)
    ,
     DAY_AGO_DT --DATE,
    ,
     DAY_AGO_KEY --NUMBER(10)
    ,
     DAY_AGO_WID --NUMBER(10)
    ,
     DAY_DT --DATE,
    ,
     DAY_NAME --VARCHAR2(30 CHAR)
    ,
     DAY_OF_MONTH --NUMBER(2)
    ,
     DAY_OF_WEEK --NUMBER(1)
    ,
     DAY_OF_YEAR --NUMBER(3)
    ,
     ENT_DAY_OF_PERIOD --NUMBER(2)
    ,
     ENT_DAY_OF_WEEK --NUMBER(2)
    ,
     ENT_DAY_OF_YEAR --NUMBER(3)
    ,
     ENT_HALF --NUMBER(2)
    ,
     ENT_PERIOD --NUMBER(4)
    ,
     ENT_QTR --NUMBER(2)
    ,
     ENT_TRIMESTER --NUMBER(10)
    ,
     ENT_WEEK --NUMBER(2)
    ,
     ENT_YEAR --NUMBER(4)
    ,
     ENT_FST_DAY_KEY --NUMBER(10)
    ,
     HALF_AGO_DT --DATE,
    ,
     HALF_AGO_KEY --NUMBER(10)
    ,
     HALF_AGO_WID --NUMBER(10)
    ,
     JULIAN_DAY_NUM --NUMBER(10)
    ,
     JULIAN_MONTH_NUM --NUMBER(10)
    ,
     JULIAN_QTR_NUM --NUMBER(10)
    ,
     JULIAN_TER_NUM --NUMBER(10)
    ,
     JULIAN_WEEK_NUM --NUMBER(10)
    ,
     JULIAN_YEAR_NUM --NUMBER(10)
    ,
     MONTH_AGO_DT --DATE,
    ,
     MONTH_AGO_KEY --NUMBER(10)
    ,
     MONTH_AGO_WID --NUMBER(10)
    ,
     MONTH_NAME --VARCHAR2(30 CHAR)
    ,
     PERIOD_KEY --NUMBER(10)
    ,
     PER_NAME_ENT_HALF --VARCHAR2(50 CHAR)
    ,
     PER_NAME_ENT_PERIOD --VARCHAR2(50 CHAR)
    ,
     PER_NAME_ENT_QTR --VARCHAR2(50 CHAR)
    ,
     PER_NAME_ENT_TER --VARCHAR2(50 CHAR)
    ,
     PER_NAME_ENT_WEEK --VARCHAR2(50 CHAR)
    ,
     PER_NAME_ENT_YEAR --VARCHAR2(50 CHAR)
    ,
     PER_NAME_HALF --VARCHAR2(50 CHAR)
    ,
     PER_NAME_MONTH --VARCHAR2(50 CHAR)
    ,
     PER_NAME_QTR --VARCHAR2(50 CHAR)
    ,
     PER_NAME_TER --VARCHAR2(50 CHAR)
    ,
     PER_NAME_WEEK --VARCHAR2(50 CHAR)
    ,
     PER_NAME_OFFSET_WK --VARCHAR2(50 CHAR)
    ,
     PER_NAME_YEAR --VARCHAR2(50 CHAR)
    ,
     QUARTER_AGO_DT --DATE,
    ,
     QUARTER_AGO_KEY --NUMBER(10)
    ,
     QUARTER_AGO_WID --NUMBER(10)
    ,
     TRIMESTER_AGO_DT --DATE,
    ,
     TRIMESTER_AGO_KEY --NUMBER(10)
    ,
     TRIMESTER_AGO_WID --NUMBER(10)
    ,
     WEEK_AGO_DT --DATE,
    ,
     WEEK_AGO_KEY --NUMBER(10)
    ,
     WEEK_AGO_WID --NUMBER(10)
    ,
     YEAR_AGO_DT --DATE,
    ,
     YEAR_AGO_KEY --NUMBER(10)
    ,
     YEAR_AGO_WID --NUMBER(10)
    ,
     M_END_CAL_DT_WID --NUMBER(10)
    ,
     M_STRT_CAL_DT_WID --NUMBER(10)
    ,
     CAL_WEEK_END_DT_WID --NUMBER(10)
    ,
     CAL_WEEK_START_DT_WID --NUMBER(10)
    ,
     CAL_QTR_END_DT_WID --NUMBER(10)
    ,
     CAL_QTR_START_DT_WID --NUMBER(10)
    ,
     CAL_YEAR_END_DT_WID --NUMBER(10)
    ,
     CAL_YEAR_START_DT_WID --NUMBER(10)
    ,
     FST_DAY_CAL_WK_FLG --CHAR(1 CHAR)
    ,
     LAST_DAY_CAL_WK_FLG --CHAR(1 CHAR)
    ,
     FST_DAY_CAL_MNTH_FLG --CHAR(1 CHAR)
    ,
     LAST_DAY_CAL_MNTH_FLG --CHAR(1 CHAR)
    ,
     FST_DAY_CAL_QTR_FLG --CHAR(1 CHAR)
    ,
     LAST_DAY_CAL_QTR_FLG --CHAR(1 CHAR)
    ,
     FST_DAY_CAL_YEAR_FLG --CHAR(1 CHAR)
    ,
     LAST_DAY_CAL_YEAR_FLG --CHAR(1 CHAR)
    ,
     ENT_WEEK_START_DT --DATE,
    ,
     ENT_WEEK_END_DT --DATE,
    ,
     ENT_PERIOD_START_DT --DATE,
    ,
     ENT_PERIOD_END_DT --DATE,
    ,
     ENT_QTR_START_DT --DATE,
    ,
     ENT_QTR_END_DT --DATE,
    ,
     ENT_YEAR_START_DT --DATE,
    ,
     ENT_YEAR_END_DT --DATE,
    ,
     ENT_WEEK_START_DT_WID --NUMBER(10)
    ,
     ENT_WEEK_END_DT_WID --NUMBER(10)
    ,
     ENT_PERIOD_START_DT_WID --NUMBER(10)
    ,
     ENT_PERIOD_END_DT_WID --NUMBER(10)
    ,
     ENT_QTR_START_DT_WID --NUMBER(10)
    ,
     ENT_QTR_END_DT_WID --NUMBER(10)
    ,
     ENT_YEAR_START_DT_WID --NUMBER(10)
    ,
     ENT_YEAR_END_DT_WID --NUMBER(10)
    ,
     ENT_DIM_QTR_NUM --NUMBER(10)
    ,
     ENT_DIM_PERIOD_NUM --NUMBER(5)
    ,
     ENT_PERIOD_WEEK_NUM --NUMBER(1)
    ,
     ENT_DIM_WEEK_NUM --NUMBER(10)
    ,
     ENT_DIM_YEAR_NUM --NUMBER(10)
    ,
     W_CURRENT_CAL_DAY_CODE --VARCHAR2(50 CHAR)
    ,
     W_CURRENT_CAL_WEEK_CODE --VARCHAR2(50 CHAR)
    ,
     W_CURRENT_CAL_MONTH_CODE --VARCHAR2(50 CHAR)
    ,
     W_CURRENT_CAL_QTR_CODE --VARCHAR2(50 CHAR)
    ,
     W_CURRENT_CAL_YEAR_CODE --VARCHAR2(50 CHAR)
    ,
     W_CURRENT_ENT_WEEK_CODE --VARCHAR2(50 CHAR)
    ,
     W_CURRENT_ENT_PERIOD_CODE --VARCHAR2(50 CHAR)
    ,
     W_CURRENT_ENT_QTR_CODE --VARCHAR2(50 CHAR)
    ,
     W_CURRENT_ENT_YEAR_CODE --VARCHAR2(50 CHAR)
    ,
     FST_DAY_ENT_WEEK_FLG --CHAR(1 CHAR)
    ,
     LAST_DAY_ENT_WEEK_FLG --CHAR(1 CHAR)
    ,
     FST_DAY_ENT_PERIOD_FLG --CHAR(1 CHAR)
    ,
     LAST_DAY_ENT_PERIOD_FLG --CHAR(1 CHAR)
    ,
     FST_DAY_ENT_QTR_FLG --CHAR(1 CHAR)
    ,
     LAST_DAY_ENT_QTR_FLG --CHAR(1 CHAR)
    ,
     FST_DAY_ENT_YEAR_FLG --CHAR(1 CHAR)
    ,
     LAST_DAY_ENT_YEAR_FLG --CHAR(1 CHAR)
    ,
     W_INSERT_DT --DATE,
    ,
     INTEGRATION_ID --VARCHAR2(30 CHAR)
    ,
     W_UPDATE_DT --DATE,
    ,
     TENANT_ID --VARCHAR2(80 CHAR)
    ,
     X_CUSTOM --VARCHAR2(10 CHAR)
    ,
     ENT_PRIOR_YEAR_WID --NUMBER(15)
    ,
     ENT_PRIOR_WEEK_WID --NUMBER(15)
    ,
     ENT_PRIOR_PERIOD_WID --NUMBER(15)
    ,
     ENT_PRIOR_QTR_WID --NUMBER(15)
    ,
     ENT_QTR_AGO_WID --NUMBER(15)
    ,
     ENT_WEEK_AGO_WID --NUMBER(15)
    ,
     CUSTOM_1 --VARCHAR2(100) add by Qiuzhilong 2014/1/4 上一周   eg. 2014 Week01
    ,
     CUSTOM_2 --VARCHAR2(100) add by Qiuzhilong 2014/1/4 去年同周 eg. 2013 Week02
    ,
     CUSTOM_3 --VARCHAR2(100) add by Qiuzhilong 2014/1/5 上月     eg. 2013 M12
    ,
     CUSTOM_4 --VARCHAR2(100) add by Qiuzhilong 2014/1/5 去年同月 eg. 2013 M01
     )
  --------------------------------------
    WITH dt_lst AS
     (SELECT (trunc(SYSDATE) + 0.99999 - 4000 + ROWNUM) AS period_date,
             TO_NUMBER(TO_CHAR(trunc(SYSDATE) + 0.99999 - 4000 + ROWNUM,
                               'YYYYMMDD')) AS period_key
        FROM dual
      CONNECT BY (trunc(SYSDATE) + 0.99999 - 4000 + ROWNUM) <
                 trunc(SYSDATE) + 0.99999 + 4000)
    SELECT '' AS ENT_PERIOD_AGO_WID,
           TO_CHAR(period_date, 'YYYYMMDD') AS DATE_KEY --19880419
          ,
           period_date AS CALENDAR_DATE --1988/4/19
          ,
           (CASE
             WHEN TO_NUMBER(SUBSTR(TO_CHAR(period_date, 'YYYYMMDD'), 5, 2)) <= 6 THEN
              1
             ELSE
              2
           END) AS CAL_HALF --1
          ,
           TO_NUMBER(SUBSTR(TO_CHAR(period_date, 'YYYYMMDD'), 5, 2)) AS CAL_MONTH --4
          ,
           (CASE
             WHEN TO_NUMBER(SUBSTR(TO_CHAR(period_date, 'YYYYMMDD'), 5, 2)) <= 3 THEN
              1 --
             WHEN TO_NUMBER(SUBSTR(TO_CHAR(period_date, 'YYYYMMDD'), 5, 2)) > 3 --
                  AND
                  TO_NUMBER(SUBSTR(TO_CHAR(period_date, 'YYYYMMDD'), 5, 2)) <= 6 THEN
              2 --
             WHEN TO_NUMBER(SUBSTR(TO_CHAR(period_date, 'YYYYMMDD'), 5, 2)) > 6 --
                  AND
                  TO_NUMBER(SUBSTR(TO_CHAR(period_date, 'YYYYMMDD'), 5, 2)) <= 9 THEN
              3 --
             ELSE
              4
           END) AS CAL_QTR --2
          ,
           (CASE
             WHEN TO_NUMBER(SUBSTR(TO_CHAR(period_date, 'YYYYMMDD'), 5, 2)) <= 4 THEN
              1 --
             WHEN TO_NUMBER(SUBSTR(TO_CHAR(period_date, 'YYYYMMDD'), 5, 2)) > 4 --
                  AND
                  TO_NUMBER(SUBSTR(TO_CHAR(period_date, 'YYYYMMDD'), 5, 2)) <= 8 THEN
              2 --
             ELSE
              3
           END) AS CAL_TRIMESTER --1
          ,
           TO_CHAR(period_date, 'ww') + 1 AS CAL_WEEK --17
          ,
           SUBSTR(TO_CHAR(period_date, 'YYYYMMDD'), 1, 4) AS CAL_YEAR --1988
          ,
           9 AS DATASOURCE_NUM_ID --9
          ,
           TO_CHAR(period_date, 'J') AS DATE_KEY --2447271
          ,
           period_date - 1 AS DAY_AGO_DT --1988/4/18
          ,
           TO_CHAR(period_date - 1, 'J') AS DAY_AGO_KEY --2447270
          ,
           TO_CHAR(period_date, 'YYYYMMDD') - 1 AS DAY_AGO_WID --19880418
          ,
           period_date AS DAY_DT --1988/4/19
          ,
           DECODE(TO_CHAR(period_date, 'D'),
                  1,
                  'Sunday',
                  2,
                  'Monday',
                  3 --
                 ,
                  'Tuesday',
                  4,
                  'Wednesday',
                  5,
                  'Thursday',
                  6,
                  'Friday' --
                 ,
                  7,
                  'Saturday') AS DAY_NAME --Tuesday
          ,
           TO_NUMBER(SUBSTR(TO_CHAR(period_date, 'YYYYMMDD'), 5, 2)) AS DAY_OF_MONTH --19
          ,
           TO_CHAR(period_date, 'D') AS DAY_OF_WEEK --3
          ,
           TO_CHAR((period_date), 'DDD') AS DAY_OF_YEAR --110
          ,
           '' AS ENT_DAY_OF_PERIOD --
          ,
           '' AS ENT_DAY_OF_WEEK --
          ,
           '' AS ENT_DAY_OF_YEAR --
          ,
           '' AS ENT_HALF --
          ,
           '' AS ENT_PERIOD --
          ,
           '' AS ENT_QTR --
          ,
           '' AS ENT_TRIMESTER --
          ,
           '' AS ENT_WEEK --
          ,
           '' AS ENT_YEAR --
          ,
           '' AS ENT_FST_DAY_KEY --
          ,
           ADD_MONTHS((period_date), -6) AS HALF_AGO_DT --1987/10/19
          ,
           TO_CHAR(ADD_MONTHS((period_date), -6), 'J') AS HALF_AGO_KEY --2447088
          ,
           TO_CHAR(ADD_MONTHS((period_date), -6), 'YYYYMMDD') AS HALF_AGO_WID --19871019
          ,
           TO_CHAR((period_date), 'J') AS JULIAN_DAY_NUM --2447271
          ,
           '' AS JULIAN_MONTH_NUM --80416
          ,
           '' AS JULIAN_QTR_NUM --26806
          ,
           '' AS JULIAN_TER_NUM --20104
          ,
           '' AS JULIAN_WEEK_NUM --349610
          ,
           '' AS JULIAN_YEAR_NUM --6701
          ,
           ADD_MONTHS((period_date), -1) AS MONTH_AGO_DT --1988/3/19
          ,
           TO_CHAR(ADD_MONTHS((period_date), -1), 'J') AS MONTH_AGO_KEY --2447240
          ,
           TO_CHAR(ADD_MONTHS((period_date), -6), 'YYYYMMDD') AS MONTH_AGO_WID --19880319
          ,
           DECODE(TO_NUMBER(SUBSTR(TO_CHAR(period_date, 'YYYYMMDD'), 5, 2)),
                  1,
                  'January',
                  2 --
                 ,
                  'February',
                  3,
                  'March',
                  4,
                  'April',
                  5,
                  'May',
                  6 --
                 ,
                  'June',
                  7,
                  'July',
                  8,
                  'August',
                  9,
                  'September' --
                 ,
                  10,
                  'October',
                  11,
                  'November',
                  12,
                  'December') AS MONTH_NAME --April
          ,
           TO_CHAR((period_date), 'YYYYMMDD') AS PERIOD_KEY --19880419
          ,
           '' AS PER_NAME_ENT_HALF --
          ,
           '' AS PER_NAME_ENT_PERIOD --
          ,
           '' AS PER_NAME_ENT_QTR --
          ,
           '' AS PER_NAME_ENT_TER --
          ,
           CASE
             WHEN period_date >=
                  trunc(add_months(period_date, 12), 'yyyy') -
                  TO_CHAR(trunc(add_months(period_date, 12), 'yyyy'), 'd') then
              SUBSTR(TO_CHAR(add_months(period_date, 12), 'YYYYMMDD'), 1, 4) ||
              ' Week01'
             ELSE
              SUBSTR(TO_CHAR(period_date, 'YYYYMMDD'), 1, 4) || ' Week' ||
              LPAD(TO_CHAR((trunc((to_number(TO_CHAR(period_date, 'ddd')) +
                                  TO_CHAR(trunc(period_date, 'yyyy'), 'd') - 1) / 7) + 1)),
                   2,
                   '0')
           END AS PER_NAME_ENT_WEEK --1988 Week01
          ,
           SUBSTR(TO_CHAR(period_date, 'YYYYMMDD'), 1, 4) AS PER_NAME_ENT_YEAR --1988
          ,
           (CASE
             WHEN TO_NUMBER(SUBSTR(TO_CHAR(period_date, 'YYYYMMDD'), 5, 2)) <= 6 THEN
              SUBSTR(TO_CHAR(period_date, 'YYYYMMDD'), 1, 4) || 'Half1'
             ELSE
              SUBSTR(TO_CHAR(period_date, 'YYYYMMDD'), 1, 4) || 'Half2'
           END) AS PER_NAME_HALF --1988 Half1
          ,
           SUBSTR(TO_CHAR(period_date, 'YYYYMMDD'), 1, 4) || ' M' ||
           SUBSTR(TO_CHAR(period_date, 'YYYYMMDD'), 5, 2) AS PER_NAME_MONTH --2013 M01
          ,
           (CASE
             WHEN TO_NUMBER(SUBSTR(TO_CHAR(period_date, 'YYYYMMDD'), 5, 2)) <= 3 THEN
              SUBSTR(TO_CHAR(period_date, 'YYYYMMDD'), 1, 4) || ' Qtr ' || 1 --
             WHEN TO_NUMBER(SUBSTR(TO_CHAR(period_date, 'YYYYMMDD'), 5, 2)) > 3 --
                  AND
                  TO_NUMBER(SUBSTR(TO_CHAR(period_date, 'YYYYMMDD'), 5, 2)) <= 6 THEN
              SUBSTR(TO_CHAR(period_date, 'YYYYMMDD'), 1, 4) || ' Qtr ' || 2 --
             WHEN TO_NUMBER(SUBSTR(TO_CHAR(period_date, 'YYYYMMDD'), 5, 2)) > 6 --
                  AND
                  TO_NUMBER(SUBSTR(TO_CHAR(period_date, 'YYYYMMDD'), 5, 2)) <= 9 THEN
              SUBSTR(TO_CHAR(period_date, 'YYYYMMDD'), 1, 4) || ' Qtr ' || 3 --
             ELSE
              SUBSTR(TO_CHAR(period_date, 'YYYYMMDD'), 1, 4) || ' Qtr ' || 4
           END) AS PER_NAME_QTR -- 1988 Q 2
          ,
           '' AS PER_NAME_TER -- 1988T1
          ,
           CASE
             WHEN period_date >=
                  trunc(add_months(period_date, 12), 'yyyy') -
                  TO_CHAR(trunc(add_months(period_date, 12), 'yyyy'), 'd') then
              SUBSTR(TO_CHAR(add_months(period_date, 12), 'YYYYMMDD'), 1, 4) ||
              ' Week01'
             ELSE
              SUBSTR(TO_CHAR(period_date, 'YYYYMMDD'), 1, 4) || ' Week' ||
              LPAD(TO_CHAR((trunc((to_number(TO_CHAR(period_date, 'ddd')) +
                                  TO_CHAR(trunc(period_date, 'yyyy'), 'd') - 1) / 7) + 1)),
                   2,
                   '0')
           END AS PER_NAME_WEEK -- 1988 Week17
          ,
           SUBSTR(TO_CHAR(period_date, 'YYYYMMDD'), 1, 4) || ' Week' || --
           TO_CHAR(TO_DATE(TO_CHAR(period_date, 'YYYYMMDD'), 'YYYYMMDD'),
                   'ww') AS PER_NAME_OFFSET_WK -- 1988 Week16
          ,
           SUBSTR(TO_CHAR(period_date, 'YYYYMMDD'), 1, 4) AS PER_NAME_YEAR -- 1988
          ,
           ADD_MONTHS(period_date, -3) AS QUARTER_AGO_DT -- 1988/1/19
          ,
           TO_CHAR(ADD_MONTHS((period_date), -3), 'J') AS QUARTER_AGO_KEY -- 2447180
          ,
           TO_CHAR(ADD_MONTHS((period_date), -3), 'YYYYMMDD') AS QUARTER_AGO_WID -- 19880119
          ,
           ADD_MONTHS((period_date), -4) AS TRIMESTER_AGO_DT -- 1987/12/19
          ,
           TO_CHAR(ADD_MONTHS(period_date, -4), 'J') AS TRIMESTER_AGO_KEY -- 2447149
          ,
           TO_CHAR(ADD_MONTHS(period_date, -4), 'YYYYMMDD') AS TRIMESTER_AGO_WID -- 19871219
          ,
           period_date - 7 AS WEEK_AGO_DT -- 1988/4/12
          ,
           TO_CHAR((period_date) - 7, 'J') AS WEEK_AGO_KEY -- 2447264
          ,
           TO_CHAR((period_date) - 7, 'YYYYMMDD') AS WEEK_AGO_WID -- 19880412
          ,
           ADD_MONTHS((period_date), -12) AS YEAR_AGO_DT -- 1987/4/19
          ,
           TO_CHAR(ADD_MONTHS((period_date), -12), 'J') AS YEAR_AGO_KEY -- 2446905
          ,
           TO_CHAR(ADD_MONTHS((period_date), -12), 'YYYYMMDD') AS YEAR_AGO_WID -- 19870419
          ,
           TO_CHAR(LAST_DAY((period_date)), 'YYYYMMDD') AS M_END_CAL_DT_WID -- 19880430
          ,
           TO_CHAR(TRUNC((period_date), 'MM'), 'YYYYMMDD') AS M_STRT_CAL_DT_WID -- 19880401
          ,
           '' AS CAL_WEEK_END_DT_WID -- 19880423
          ,
           '' AS CAL_WEEK_START_DT_WID -- 19880417
          ,
           (TO_CHAR(TRUNC(TRUNC(period_date, 'Q') + 100, 'Q') - 1,
                    'YYYYMMDD')) AS CAL_QTR_END_DT_WID -- 19880630
          ,
           TO_CHAR(TRUNC(period_date, 'Q'), 'YYYYMMDD') AS CAL_QTR_START_DT_WID -- 19880401
          ,
           SUBSTR(TO_CHAR(period_date, 'YYYYMMDD'), 1, 4) || '1231' AS CAL_YEAR_END_DT_WID -- 19881231
          ,
           SUBSTR(TO_CHAR(period_date, 'YYYYMMDD'), 1, 4) || '0101' AS CAL_YEAR_START_DT_WID -- 19880101
          ,
           DECODE(TO_CHAR(period_date, 'D'), 7, 'Y', 'N') AS FST_DAY_CAL_WK_FLG -- N
          ,
           DECODE(TO_CHAR(period_date, 'D'), 6, 'Y', 'N') AS LAST_DAY_CAL_WK_FLG -- N
          ,
           DECODE(SUBSTR(TO_CHAR(period_date, 'YYYYMMDD'), 5, 2),
                  '01',
                  'Y',
                  'N') AS FST_DAY_CAL_MNTH_FLG -- N
          ,
           DECODE(TO_CHAR(period_date, 'YYYYMMDD'),
                  TO_CHAR(LAST_DAY(period_date), 'YYYYMMDD'),
                  'Y',
                  'N') AS LAST_DAY_CAL_MNTH_FLG -- N
          ,
           DECODE(TO_CHAR(period_date, 'YYYYMMDD'),
                  TO_CHAR(TRUNC(period_date, 'Q'), 'YYYYMMDD'),
                  'Y',
                  'N') AS FST_DAY_CAL_QTR_FLG -- N
          ,
           DECODE(TO_CHAR(period_date, 'YYYYMMDD'),
                  (TO_CHAR(TRUNC(TRUNC(period_date, 'Q') + 100, 'Q') - 1,
                           'YYYYMMDD')),
                  'Y',
                  'N') AS LAST_DAY_CAL_QTR_FLG -- N
          ,
           DECODE(SUBSTR(TO_CHAR(period_date, 'YYYYMMDD'), 5, 4),
                  '0101',
                  'Y',
                  'N') AS FST_DAY_CAL_YEAR_FLG -- N
          ,
           DECODE(SUBSTR(TO_CHAR(period_date, 'YYYYMMDD'), 5, 4),
                  '1231',
                  'Y',
                  'N') AS LAST_DAY_CAL_YEAR_FLG -- N
          ,
           '' AS ENT_WEEK_START_DT --
          ,
           '' AS ENT_WEEK_END_DT --
          ,
           '' AS ENT_PERIOD_START_DT --
          ,
           TO_DATE(CASE
                     WHEN MOD(TO_NUMBER(TO_CHAR(period_date, 'YYYY')), 4) = 0 AND
                          TO_NUMBER(TO_CHAR(period_date, 'MM')) = 2 THEN
                      TO_CHAR(period_date, 'YYYYMM') || '29'
                     WHEN MOD(TO_NUMBER(TO_CHAR(period_date, 'YYYY')), 4) <> 0 AND
                          TO_NUMBER(TO_CHAR(period_date, 'MM')) = 2 THEN
                      TO_CHAR(period_date, 'YYYYMM') || '28'
                     WHEN TO_NUMBER(TO_CHAR(period_date, 'MM')) IN
                          (1, 3, 5, 7, 8, 10, 12) THEN
                      TO_CHAR(period_date, 'YYYYMM') || '31'
                     WHEN TO_NUMBER(TO_CHAR(period_date, 'MM')) IN (4, 6, 9, 11) THEN
                      TO_CHAR(period_date, 'YYYYMM') || '30'
                     ELSE
                      '00000000'
                   END,
                   'YYYYMMDD') + 0.99999 AS ENT_PERIOD_END_DT --
          ,
           '' AS ENT_QTR_START_DT --
          ,
           '' AS ENT_QTR_END_DT --
          ,
           '' AS ENT_YEAR_START_DT --
          ,
           '' AS ENT_YEAR_END_DT --
          ,
           '' AS ENT_WEEK_START_DT_WID --
          ,
           '' AS ENT_WEEK_END_DT_WID --
          ,
           '' AS ENT_PERIOD_START_DT_WID --
          ,
           case
             when MOD(TO_NUMBER(TO_CHAR(period_date, 'YYYY')), 4) = 0 and
                  TO_NUMBER(TO_CHAR(period_date, 'MM')) = 2 then
              TO_CHAR(period_date, 'YYYYMM') || '29'
             when MOD(TO_NUMBER(TO_CHAR(period_date, 'YYYY')), 4) <> 0 and
                  TO_NUMBER(TO_CHAR(period_date, 'MM')) = 2 then
              TO_CHAR(period_date, 'YYYYMM') || '28'
             when TO_NUMBER(TO_CHAR(period_date, 'MM')) in
                  (1, 3, 5, 7, 8, 10, 12) then
              TO_CHAR(period_date, 'YYYYMM') || '31'
             when TO_NUMBER(TO_CHAR(period_date, 'MM')) in (4, 6, 9, 11) then
              TO_CHAR(period_date, 'YYYYMM') || '30'
             else
              'XXX'
           end AS ENT_PERIOD_END_DT_WID --
          ,
           '' AS ENT_QTR_START_DT_WID --
          ,
           '' AS ENT_QTR_END_DT_WID --
          ,
           '' AS ENT_YEAR_START_DT_WID --
          ,
           '' AS ENT_YEAR_END_DT_WID --
          ,
           '' AS ENT_DIM_QTR_NUM --
          ,
           '' AS ENT_DIM_PERIOD_NUM --
          ,
           '' AS ENT_PERIOD_WEEK_NUM --
          ,
           '' AS ENT_DIM_WEEK_NUM --
          ,
           '' AS ENT_DIM_YEAR_NUM --
          ,
           '' AS W_CURRENT_CAL_DAY_CODE -- ?
          ,
           '' AS W_CURRENT_CAL_WEEK_CODE -- ?
          ,
           '' AS W_CURRENT_CAL_MONTH_CODE -- ?
          ,
           '' AS W_CURRENT_CAL_QTR_CODE -- ?
          ,
           '' AS W_CURRENT_CAL_YEAR_CODE -- ?
          ,
           '' AS W_CURRENT_ENT_WEEK_CODE -- ?
          ,
           '' AS W_CURRENT_ENT_PERIOD_CODE -- ?
          ,
           '' AS W_CURRENT_ENT_QTR_CODE -- ?
          ,
           '' AS W_CURRENT_ENT_YEAR_CODE -- ?
          ,
           '' AS FST_DAY_ENT_WEEK_FLG --
          ,
           '' AS LAST_DAY_ENT_WEEK_FLG --
          ,
           '' AS FST_DAY_ENT_PERIOD_FLG --
          ,
           '' AS LAST_DAY_ENT_PERIOD_FLG --
          ,
           '' AS FST_DAY_ENT_QTR_FLG --
          ,
           '' AS LAST_DAY_ENT_QTR_FLG --
          ,
           '' AS FST_DAY_ENT_YEAR_FLG --
          ,
           '' AS LAST_DAY_ENT_YEAR_FLG --
          , /*period_date  */
           SYSDATE AS W_INSERT_DT -- 2011/6/30 2:41
          ,
           TO_CHAR(period_date, 'YYYYMMDD') AS INTEGRATION_ID -- 19880419
          , /*period_date*/
           SYSDATE AS W_UPDATE_DT -- 2011/6/30 2:43
          ,
           9 AS TENANT_ID -- 9
          ,
           '' AS X_CUSTOM --
          ,
           '' AS ENT_PRIOR_YEAR_WID --
          ,
           '' AS ENT_PRIOR_WEEK_WID --
          ,
           '' AS ENT_PRIOR_PERIOD_WID --
          ,
           '' AS ENT_PRIOR_QTR_WID --
          ,
           '' AS ENT_QTR_AGO_WID --
          ,
           '' AS ENT_WEEK_AGO_WID --
          ,
           case
             when period_date >=
                  trunc(add_months(period_date, 12), 'yyyy') -
                  TO_CHAR(trunc(add_months(period_date, 12), 'yyyy'), 'd') then
              SUBSTR(TO_CHAR(add_months(period_date, 12), 'YYYYMMDD'), 1, 4) ||
              ' Week01'
             ELSE
              SUBSTR(TO_CHAR(period_date - 7, 'YYYYMMDD'), 1, 4) || ' Week' ||
              LPAD(TO_CHAR((trunc((to_number(TO_CHAR(period_date - 7, 'ddd')) +
                                  TO_CHAR(trunc(period_date - 7, 'yyyy'),
                                           'd') - 1) / 7) + 1)),
                   2,
                   '0')
           end AS CUSTOM_1 --add by Qiuzhilong 2014/1/4 上一周   eg. 2014 Week01
          ,
           case
             when period_date >=
                  trunc(add_months(period_date, 12), 'yyyy') -
                  TO_CHAR(trunc(add_months(period_date, 12), 'yyyy'), 'd') then
              SUBSTR(TO_CHAR(add_months(period_date, 12), 'YYYYMMDD'), 1, 4) ||
              ' Week01'
             else
              SUBSTR(TO_CHAR(ADD_MONTHS((period_date), -12), 'YYYYMMDD'),
                     1,
                     4) || ' Week' || LPAD(TO_CHAR((trunc((to_number(TO_CHAR(ADD_MONTHS((period_date),
                                                                                        -12),
                                                                             'ddd')) +
                                                          TO_CHAR(trunc(ADD_MONTHS((period_date),
                                                                                    -12),
                                                                         'yyyy'),
                                                                   'd') - 1) / 7) + 1)),
                                           2,
                                           '0')
           end AS CUSTOM_2 --add by Qiuzhilong 2014/1/4 去年同周 eg. 2013 Week02
          ,
           TO_CHAR(ADD_MONTHS((period_date), -1), 'YYYY') || ' M' ||
           TO_CHAR(ADD_MONTHS((period_date), -1), 'MM') AS CUSTOM_3 --add by Qiuzhilong 2014/1/5 上月 eg. 2013 M12
          ,
           TO_CHAR(ADD_MONTHS((period_date), -12), 'YYYY') || ' M' ||
           TO_CHAR(ADD_MONTHS((period_date), -12), 'MM') AS CUSTOM_4 --add by Qiuzhilong 2014/1/5 去年同月 eg. 2013 M01
      FROM dt_lst t
     WHERE t.PERIOD_KEY BETWEEN v_start_day AND
           nvl(v_end_day,
               to_number(to_char(TRUNC(SYSDATE) + 0.99999 + 6, 'yyyymmdd')));
  L_LOG_REC.ETL_RECORD_INS := SQL%ROWCOUNT;
  COMMIT;

  SELECT CURRENT_TIMESTAMP INTO V_END_TIME FROM DUAL;

  SELECT (TRUNC(TO_NUMBER(TO_CHAR(V_END_TIME, 'YYYYMMDDHH24MISSXFF')), 2) -
         TRUNC(TO_NUMBER(TO_CHAR(V_START_TIME, 'YYYYMMDDHH24MISSXFF')), 2))
    INTO L_LOG_REC.ETL_DURATION
    FROM DUAL;

  L_LOG_REC.START_TIME := V_START_TIME;
  L_LOG_REC.END_TIME   := V_END_TIME;

  INSERT INTO W_ETL_LOG VALUES L_LOG_REC;
  COMMIT;
  --<LOG2 END>

  av_r_status := 0;
  ls_error    := 'OK';

Exception
  When Others Then
    dbms_output.put_line(sqlerrm || '--------------' || sqlcode);
    ROLLBACK;
end sp_sbi_w_day_d;
/

