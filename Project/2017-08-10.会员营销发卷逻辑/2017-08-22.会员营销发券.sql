--PROCESSED:1 成功 2失败 3接口错误 9 不用发券

SELECT A.PROCESSED,COUNT(A.MEMBER_KEY) FROM OPER_MBR_REG_WITHOUT_ORDER A WHERE A.RECORD_DATE_KEY=TO_CHAR(TRUNC(SYSDATE-1),'YYYYMMDD') GROUP BY A.PROCESSED;
SELECT A.PROCESSED,COUNT(A.MEMBER_KEY) FROM OPER_MBR_ORDER_RETAIN_PUSH A WHERE A.RECORD_DATE_KEY=TO_CHAR(TRUNC(SYSDATE-1),'YYYYMMDD') GROUP BY A.PROCESSED;
SELECT A.PROCESSED,COUNT(A.MEMBER_KEY) FROM OPER_MBR_THIRD_ORDER_CAL_MONTH A WHERE A.MONTH_KEY=TO_CHAR(TRUNC(SYSDATE-1,'MONTH')-1,'YYYYMM') GROUP BY A.PROCESSED;
SELECT A.PROCESSED,COUNT(A.MEMBER_KEY) FROM OPER_MBR_TWELVE_ORDER_YEAR A WHERE A.MONTH_KEY=TO_CHAR(TRUNC(SYSDATE-1,'MONTH')-1,'YYYYMM') GROUP BY A.PROCESSED;

select * from oper_mbr_reg_without_order a order by a.insert_dt desc;
select * from oper_mbr_order_retain_push a order by a.insert_dt desc;
select * from oper_mbr_third_order_cal_month a order by a.insert_dt desc;
select * from oper_mbr_twelve_order_year a order by a.insert_dt desc;

update oper_mbr_reg_without_order a set a.processed=0;

select a.record_date_key-a.register_date_key,a.* from oper_mbr_reg_without_order a where a.record_date_key=20170822;

--这三张表需要合并(OPER_MBR_ORDER_RETAIN_PUSH)
INSERT INTO OPER_MBR_ORDER_RETAIN_PUSH
  (MEMBER_KEY,
   RECORD_DATE_KEY,
   ORDER_DATE_KEY,
   ACTUAL_ORDER_AMOUNT,
   ORDER_FREQUENCY,
   AMOUNT_LEVEL,
   DAY_WITHOUT_ORDER,
   INSERT_DT,
   UPDATE_DT)
  SELECT D.MEMBER_KEY,
         D.RECORD_DATE_KEY,
         D.ORDER_DATE_KEY,
         D.ACTUAL_ORDER_AMOUNT,
         D.ORDER_FREQUENCY,
         D.AMOUNT_LEVEL,
         D.DAY_WITHOUT_ORDER,
         D.INSERT_DT,
         D.UPDATE_DT
    FROM (SELECT A.MEMBER_KEY,
                 A.RECORD_DATE_KEY,
                 A.ORDER_TIME ORDER_DATE_KEY,
                 A.ACTUAL_ORDER_AMOUNT,
                 1 ORDER_FREQUENCY,
                 A.AMOUNT_LEVEL,
                 TO_DATE(A.RECORD_DATE_KEY, 'YYYYMMDD') -
                 TO_DATE(A.ORDER_TIME, 'YYYYMMDD') DAY_WITHOUT_ORDER,
                 A.INSERT_DT,
                 A.UPDATE_DT
            FROM OPER_MBR_FITST_ORDER_15DAYS A
          UNION ALL
          SELECT B.MEMBER_KEY,
                 B.RECORD_DATE_KEY,
                 B.ORDER_TIME ORDER_DATE_KEY,
                 B.ACTUAL_ORDER_AMOUNT,
                 2 ORDER_FREQUENCY,
                 B.AMOUNT_LEVEL,
                 TO_DATE(B.RECORD_DATE_KEY, 'YYYYMMDD') -
                 TO_DATE(B.ORDER_TIME, 'YYYYMMDD') DAY_WITHOUT_ORDER,
                 B.INSERT_DT,
                 B.UPDATE_DT
            FROM OPER_MBR_SECOND_ORDER_20DAYS B
          UNION ALL
          SELECT C.MEMBER_KEY,
                 C.RECORD_DATE_KEY,
                 C.ORDER_TIME ORDER_DATE_KEY,
                 C.ACTUAL_ORDER_AMOUNT,
                 3 ORDER_FREQUENCY,
                 C.AMOUNT_LEVEL,
                 TO_DATE(C.RECORD_DATE_KEY, 'YYYYMMDD') -
                 TO_DATE(C.ORDER_TIME, 'YYYYMMDD') DAY_WITHOUT_ORDER,
                 C.INSERT_DT,
                 C.UPDATE_DT
            FROM OPER_MBR_THIRD_ORDER_30DAYS C) D
   WHERE NOT EXISTS (SELECT 1
            FROM OPER_MBR_ORDER_PUSH E
           WHERE D.ORDER_FREQUENCY = E.ORDER_FREQUENCY
             AND D.MEMBER_KEY = E.MEMBER_KEY
             AND D.AMOUNT_LEVEL = E.AMOUNT_LEVEL);

select * from oper_mbr_reg_without_order;
select * from oper_mbr_fitst_order_15days;
select * from oper_mbr_second_order_20days;
select * from oper_mbr_third_order_30days;
select * from oper_mbr_third_order_cal_month;
select * from oper_mbr_twelve_order_year;

select count(1)
  from oper_mbr_reg_without_order a
 where a.record_date_key = 20170821;
select count(1)
  from oper_mbr_fitst_order_15days a
 where a.record_date_key = 20170821;
select count(1)
  from oper_mbr_second_order_20days a
 where a.record_date_key = 20170821;
select count(1)
  from oper_mbr_third_order_30days a
 where a.record_date_key = 20170821;
select count(1)
  from oper_mbr_third_order_cal_month a
 where a.month_key = 201707;
select count(1)
  from oper_mbr_twelve_order_year a
 where a.year_key = 2017
   and a.month_key = 201708;
