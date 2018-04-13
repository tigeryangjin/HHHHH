/*
新老客、扫码用户、VISIT_DATE、通路业务分类、日活、订购人数、订购金额、订购件数、订购单数
通路:3G、微信、APP、PC
*/
--1.dau
select d6.date_key,
       d6.is_new_user,
       d6.is_scan,
       d6.channel_name,
       count(distinct d6.vid) dau
  from (select d3.date_key,
               d3.vid,
               d3.member_key,
               d3.channel_name,
               case
                 when d4.first_order_date_key >= d3.date_key then
                  'new_user'
                 when d4.first_order_date_key between 0 and d3.date_key then
                  'old_user'
                 when nvl(d4.first_order_date_key, 0) = 0 then
                  'new_user'
               end is_new_user,
               case
                 when d5.vid is null then
                  'non_scan'
                 else
                  'scan'
               end is_scan
          from (select d1.visit_date_key date_key,
                       d1.vid,
                       d1.member_key,
                       case
                         when d1.application_key = 30 then
                          '3G'
                         when d1.application_key = 50 then
                          '微信'
                         when d1.application_key in (10, 20) then
                          'APP'
                         when d1.application_key = 40 then
                          'PC'
                       end channel_name,
                       d1.application_key
                  from fact_page_view d1
                 where d1.visit_date_key = 20170319) d3,
               dim_member d4,
               (select d2.scan_date_key, d2.vid
                  from dim_vid_scan d2
                 where d2.scan_date_key = 20170319) d5
         where d3.member_key = d4.member_bp(+)
           and d3.date_key = d5.scan_date_key(+)
           and d3.vid = d5.vid(+)
           and d3.channel_name is not null) d6
 group by d6.date_key, d6.is_new_user, d6.is_scan, d6.channel_name;

--ord
select a4.date_key,
       a4.is_new_user,
       a4.is_scan,
       a4.channel_name,
       count(distinct a4.member_key) order_member_count,
       sum(a4.order_amount) order_amount,
       sum(a4.goods_num) order_qty,
       count(a4.order_id) order_count
  from (select a2.add_time date_key,
               case
                 when a2.order_from = '76' then
                  'scan'
                 else
                  'non_scan'
               end is_scan,
               case
                 when a2.app_name = 'KLGMPortal' then
                  '3G'
                 when a2.app_name = 'KLGWX' then
                  '微信'
                 when a2.app_name in ('KLGAndroid', 'KLGiPhone') then
                  'APP'
                 when a2.app_name = 'KLGPortal' then
                  'PC'
               end channel_name,
               case
                 when nvl(a3.first_order_date_key, 0) = 0 then
                  'new_user'
                 when a3.first_order_date_key < a2.add_time then
                  'old_user'
                 when a3.first_order_date_key >= a2.add_time then
                  'new_user'
               end is_new_user,
               a2.order_id,
               a2.vid,
               a2.member_key,
               a2.goods_num,
               a2.order_amount
          from (select a1.order_id,
                       a1.add_time,
                       a1.vid,
                       a1.order_from,
                       a1.app_name,
                       a1.member_key,
                       a1.order_amount,
                       a1.goods_num
                  from factec_order a1
                 where a1.add_time = 20170319
                   and a1.order_state >= 20) a2,
               dim_member a3
         where a2.member_key = a3.member_bp(+)) a4
 group by a4.date_key, a4.is_new_user, a4.is_scan, a4.channel_name;

--3.dim
select m1.date_key, m2.is_new_user, m3.is_scan, m4.channel_name
  from (select to_char(sysdate, 'yyyymmdd') date_key from dual) m1,
       (select 'new_user' is_new_user
          from dual
        union
        select 'old_user' is_new_user
          from dual) m2,
       (select 'scan' is_scan
          from dual
        union
        select 'non_scan' is_scan
          from dual) m3,
       (select '3G' channel_name
          from dual
        union
        select '微信' channel_name
          from dual
        union
        select 'APP' channel_name
          from dual
        union
        select 'PC' channel_name
          from dual) m4;

--4.union
insert into OPER_DAU_ORDER_REPORT
  (date_key,
   is_new_user,
   is_scan,
   channel_name,
   dau,
   order_member_count,
   order_amount,
   order_qty,
   order_count)
  select dim.date_key,
         dim.is_new_user,
         dim.is_scan,
         dim.channel_name,
         nvl(dau.dau, 0) dau,
         nvl(ord.order_member_count, 0) order_member_count,
         nvl(ord.order_amount, 0) order_amount,
         nvl(ord.order_qty, 0) order_qty,
         nvl(ord.order_count, 0) order_count
    from (select m1.date_key, m2.is_new_user, m3.is_scan, m4.channel_name
            from (select to_char(sysdate - 1, 'yyyymmdd') date_key from dual) m1,
                 (select 'new_user' is_new_user
                    from dual
                  union
                  select 'old_user' is_new_user
                    from dual) m2,
                 (select 'scan' is_scan
                    from dual
                  union
                  select 'non_scan' is_scan
                    from dual) m3,
                 (select '3G' channel_name
                    from dual
                  union
                  select '微信' channel_name
                    from dual
                  union
                  select 'APP' channel_name
                    from dual
                  union
                  select 'PC' channel_name
                    from dual) m4) dim,
         (select d6.date_key,
                 d6.is_new_user,
                 d6.is_scan,
                 d6.channel_name,
                 count(distinct d6.vid) dau
            from (select d3.date_key,
                         d3.vid,
                         d3.member_key,
                         d3.channel_name,
                         case
                           when d4.first_order_date_key >= d3.date_key then
                            'new_user'
                           when d4.first_order_date_key between 0 and
                                d3.date_key then
                            'old_user'
                           when nvl(d4.first_order_date_key, 0) = 0 then
                            'new_user'
                         end is_new_user,
                         case
                           when d5.vid is null then
                            'non_scan'
                           else
                            'scan'
                         end is_scan
                    from (select d1.visit_date_key date_key,
                                 d1.vid,
                                 d1.member_key,
                                 case
                                   when d1.application_key = 30 then
                                    '3G'
                                   when d1.application_key = 50 then
                                    '微信'
                                   when d1.application_key in (10, 20) then
                                    'APP'
                                   when d1.application_key = 40 then
                                    'PC'
                                 end channel_name,
                                 d1.application_key
                            from fact_page_view d1
                           where d1.visit_date_key = 20180319) d3,
                         dim_member d4,
                         (select d2.scan_date_key, d2.vid
                            from dim_vid_scan d2
                           where d2.scan_date_key = 20180319) d5
                   where d3.member_key = d4.member_bp(+)
                     and d3.date_key = d5.scan_date_key(+)
                     and d3.vid = d5.vid(+)
                     and d3.channel_name is not null) d6
           group by d6.date_key, d6.is_new_user, d6.is_scan, d6.channel_name) dau,
         (select a4.date_key,
                 a4.is_new_user,
                 a4.is_scan,
                 a4.channel_name,
                 count(distinct a4.member_key) order_member_count,
                 sum(a4.order_amount) order_amount,
                 sum(a4.goods_num) order_qty,
                 count(a4.order_id) order_count
            from (select a2.add_time date_key,
                         case
                           when a2.order_from = '76' then
                            'scan'
                           else
                            'non_scan'
                         end is_scan,
                         case
                           when a2.app_name = 'KLGMPortal' then
                            '3G'
                           when a2.app_name = 'KLGWX' then
                            '微信'
                           when a2.app_name in ('KLGAndroid', 'KLGiPhone') then
                            'APP'
                           when a2.app_name = 'KLGPortal' then
                            'PC'
                         end channel_name,
                         case
                           when nvl(a3.first_order_date_key, 0) = 0 then
                            'new_user'
                           when a3.first_order_date_key < a2.add_time then
                            'old_user'
                           when a3.first_order_date_key >= a2.add_time then
                            'new_user'
                         end is_new_user,
                         a2.order_id,
                         a2.vid,
                         a2.member_key,
                         a2.goods_num,
                         a2.order_amount
                    from (select a1.order_id,
                                 a1.add_time,
                                 a1.vid,
                                 a1.order_from,
                                 a1.app_name,
                                 a1.member_key,
                                 a1.order_amount,
                                 a1.goods_num
                            from factec_order a1
                           where a1.add_time = 20180319
                             and a1.order_state >= 20) a2,
                         dim_member a3
                   where a2.member_key = a3.member_bp(+)) a4
           group by a4.date_key, a4.is_new_user, a4.is_scan, a4.channel_name) ord
   where dim.date_key = dau.date_key(+)
     and dim.date_key = ord.date_key(+)
     and dim.is_new_user = dau.is_new_user(+)
     and dim.is_new_user = ord.is_new_user(+)
     and dim.is_scan = dau.is_scan(+)
     and dim.is_scan = ord.is_scan(+)
     and dim.channel_name = dau.channel_name(+)
     and dim.channel_name = ord.channel_name(+)
   order by dim.date_key, dim.is_new_user, dim.is_scan, dim.channel_name;

--5.DATA FIX
DECLARE
  IN_DATE_INT NUMBER(8);
  IN_DATE     DATE;
  BEGIN_DATE  DATE := DATE '2017-07-07';
  END_DATE    DATE := DATE '2018-03-19';
BEGIN
  IN_DATE := BEGIN_DATE;
  WHILE IN_DATE <= END_DATE LOOP
    IN_DATE_INT := TO_CHAR(IN_DATE, 'YYYYMMDD');
    YANGJIN_PKG.OPER_DAU_ORDER_REPORT_PROC(IN_DATE_INT); 
    IN_DATE := IN_DATE + 1;
  END LOOP;
END;
/

--tmp
SELECT * FROM S_PARAMETERS2 FOR UPDATE;
SELECT *
  FROM W_ETL_LOG A
 WHERE A.PROC_NAME = 'YANGJIN_PKG.OPER_DAU_ORDER_REPORT_PROC'
 ORDER BY A.START_TIME DESC;
 
SELECT * FROM W_ETL_LOG A WHERE UPPER(A.TABLE_NAME)='FACTEC_ORDER' ORDER BY A.START_TIME DESC;
SELECT * FROM OPER_DAU_ORDER_REPORT;
