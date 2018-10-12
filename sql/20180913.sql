SELECT *
  FROM FACT_DAILY_GOODPAGE A
 WHERE A.VISIT_DATE_KEY = 20180912
   AND A.PAGE_NAME = 'KFZT'
   AND A.PAGE_VALUE = 'PriceDwonLive';

SELECT *
  FROM FACT_PAGE_VIEW A
 WHERE A.PAGE_NAME = 'KFZT'
   AND A.PAGE_VALUE = 'PriceDwonLive'
   AND A.VISIT_DATE_KEY = 20180912;

SELECT *
  FROM FACT_PAGE_VIEW A
 WHERE A.PAGE_NAME = 'Good'
   AND A.Hmci = 'PriceDwonLive'
   AND A.VISIT_DATE_KEY = 20180912
 ORDER BY A.ID;

SELECT *
  FROM ALL_SOURCE A
 WHERE UPPER(A.TEXT) LIKE '%INSERT%FACT_PAGEGOODS%';
PROCESSPAGEORDER

  SELECT *
    FROM (select m2.page_key,
                 m2.page_name,
                 m2.page_value,
                 m2.visit_date_key,
                 m2.application_nm,
                 m1.totalpv,
                 m1.totaluv,
                 m2.pagepv,
                 m2.pageuv,
                 m2.pageavgtime,
                 m2.ordercnt,
                 m2.orderuv,
                 m2.orderrate,
                 m2.goods_num,
                 m2.goods_amount
            from temp_page_total m1, fact_daily_goodpage_1 m2
           where m1.page_key = m2.page_key
             and m1.page_value = m2.page_value
             and m1.application_key = m2.application_key) M3
   WHERE M3.PAGE_NAME = 'KFZT';

SELECT * FROM temp_page_total M1 WHERE M1.PAGE_NAME = 'KFZT';
SELECT * FROM fact_daily_goodpage_1 M2 WHERE M2.PAGE_NAME = 'KFZT';

--temp_page_total
SELECT *
  FROM (select k1.page_key,
               k1.page_name,
               k1.page_value,
               k1.application_key,
               count(k1.vid) as totalpv,
               count(distinct k1.vid) as totaluv
          from fact_page_view k1
         where k1.visit_date_key = 20180911
         group by k1.page_key,
                  k1.page_name,
                  k1.page_value,
                  k1.application_key) K2
 WHERE K2.PAGE_NAME = 'KFZT'
   AND K2.PAGE_VALUE = 'PriceDwonLive';

--fact_daily_goodpage_1
select *
  from (select b1.page_key,
               b1.page_name,
               b1.page_value,
               b1.visit_date_key,
               b1.application_key,
               decode(b1.application_key,
                      10,
                      'IOS',
                      20,
                      'ANDROID',
                      30,
                      '3G',
                      40,
                      'PC',
                      50,
                      'WEIXIN') as application_nm,
               b1.pagepv,
               b1.pageuv,
               b1.page_staytime,
               nvl(b2.ordercnt, 0) as ordercnt,
               nvl(b2.orderuv, 0) as orderuv,
               nvl(trunc((b2.orderuv / pageuv), 2), 0) as orderrate,
               nvl(b2.goods_num, 0) as goods_num,
               nvl(b2.goods_amount, 0) as goods_amount
          from (select to_number(to_char(w1.visit_date, 'yyyymmdd')) as visit_date_key,
                       w1.application_key,
                       w1.page_key,
                       w1.page_name,
                       w1.page_value,
                       count(w1.vid) as pagepv,
                       count(distinct w1.vid) as pageuv,
                       trunc(avg(w1.page_staytime), 2) as page_staytime
                  from fact_pagegoods w1
                 where w1.page_key not in (-1, 0, 6376, 7081)
                 group by to_number(to_char(w1.visit_date, 'yyyymmdd')),
                          w1.application_key,
                          w1.page_key,
                          w1.page_name,
                          w1.page_value) b1,
               
               (select z2.add_time,
                       z2.application_key,
                       z2.page_key,
                       z2.page_name,
                       z2.page_value,
                       count(distinct z2.order_id) as ordercnt,
                       count(distinct z2.vvid) as orderuv,
                       -- trunc((count(distinct z2.vvid) / count(distinct vid)), 2) as orderrate,
                       nvl(sum(z2.goods_num), 0) as goods_num,
                       nvl(sum(z2.goods_num * z2.goods_pay_price), 0) as goods_amount
                  from fact_pagegoods_detail z2
                 group by z2.add_time,
                          z2.application_key,
                          z2.page_key,
                          z2.page_name,
                          z2.page_value) b2
         where b1.visit_date_key = b2.add_time(+)
           and b1.application_key = b2.application_key(+)
           and b1.page_key = b2.page_key(+)
           and b1.page_name = b2.page_name(+)
           and b1.page_value = b2.page_value(+)) z
 where z.page_name = 'KFZT'
   and z.page_value = 'PriceDwonLive';

--fact_pagegoods
SELECT *
  FROM fact_pagegoods w1
 WHERE TRUNC(W1.VISIT_DATE) = DATE '2018-09-12'
   AND W1.PAGE_NAME = 'KFZT'
   AND W1.PAGE_VALUE = 'PriceDwonLive';

--fact_pagegoods_detail
SELECT *
  FROM fact_pagegoods_detail A
 WHERE TRUNC(A.VISIT_DATE) = DATE '2018-09-12'
   AND A.PAGE_NAME = 'KFZT'
   AND A.PAGE_VALUE = 'PriceDwonLive';

--insert fact_pagegoods
select *
  from (select a1.id,
               a1.ip_geo_key,
               a1.hmci as page_value,
               --  to_number(var_array(i).page_value),
               (select nvl(a2.page_name, 'nopage')
                  from dim_page_gn a2
                 where a2.page_key = a1.ip_geo_key) as page_name,
               a1.application_key,
               to_number(case
                           when regexp_like(a1.page_value, '.([a-z]+|[A-Z])') then
                            '0'
                           when regexp_like(a1.page_value, '[[:punct:]]+') then
                            '0'
                         -- when regexp_like(a1.page_value, '[\u4e00-\u9fa5]+') then
                         --  '0'
                           when a1.page_value is null then
                            '0'
                           when a1.page_value like '%null%' then
                            '0'
                           else
                            regexp_replace(a1.page_value, '\s', '')
                         end) as goodcode,
               
               -- to_number(a1.page_value),
               a1.session_key,
               a1.vid,
               a1.visit_date,
               a1.page_staytime
          from fact_page_view a1
         where a1.visit_date_key = 20180912
           and a1.page_key in (1924, 2841, 24146, 11586, 355, 38629)
           and a1.page_value != 'undefined'
           and length(a1.page_value) <= 6) z
 where z.page_name = 'KFZT'
   and z.page_value = 'PriceDwonLive';

select *
  from w_etl_log a
 where a.proc_name in ('processpage_detail', 'processpagezt')
 order by a.start_time desc;

select *
  from v$sql a
 where lower(a.SQL_FULLTEXT) like '%insert into fact_pagegoods %';

select *
  from v$sqltext a
 where lower(a.SQL_TEXT) like '%insert into fact_pagegoods %';

select * from v$sql a where a.SQL_ID in ('87kzy3a7p117b', '65wa3hr0bb3jp');

select *
  from v$sqlarea a
 where a.SQL_ID in ('87kzy3a7p117b', '65wa3hr0bb3jp');

SELECT * FROM DIM_PAGE A WHERE A.PAGE_NAME = 'PriceDwonLive';

SELECT * FROM ALL_SOURCE A WHERE UPPER(A.TEXT) LIKE '%FACT_PAGEGOODS%';

SELECT *
  FROM fact_pagegoods w1
 WHERE TRUNC(W1.VISIT_DATE) = DATE '2018-09-12'
   AND W1.PAGE_NAME = 'KFZT'
   AND W1.PAGE_VALUE = 'PriceDwonLive';

SELECT *
  FROM FACT_PAGE_VIEW A
 WHERE A.SESSION_KEY = 114159011
/*AND A.PAGE_KEY IN (8925,
8926,
41928,
41930,
40410,
40411,
36768,
36948,
36949,
36854,
45042)*/
 ORDER BY A.ID;

select /*+ index(b SPID_IDX) */
 *
--nvl(max(b.id), 0)
--into count_key
  from fact_page_view_daily b
 where b.session_key = 114159011
   and b.page_key in (8925,
                      8926,
                      41928,
                      41930,
                      40410,
                      40411,
                      36768,
                      36948,
                      36949,
                      36854,
                      45042)
   and b.id < 1282329259;

call processpage_detail(20180911);
call processpagezt(20180911);

SELECT A.SESSION_KEY,
       A.ID,
       A.PAGE_KEY,
       A.PAGE_NAME,
       A.PAGE_VALUE,
       A.LAST_PAGE_KEY,
       A.IP_GEO_KEY
  FROM FACT_PAGE_VIEW A
 WHERE A.SESSION_KEY = 114159011
 ORDER BY A.ID;
SELECT *
  FROM FACT_PAGEGOODS A
 WHERE A.SESSION_KEY = 114159011
 ORDER BY A.ID;

select (130+190)/2,(145+220)/2 from dual;
