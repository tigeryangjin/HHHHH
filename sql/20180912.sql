--1.
SELECT 'juhuasuan0901apppc' KFZT,
       TO_CHAR(A.VISIT_DATE, 'YYYY-MM-DD HH24:MI') H,
       COUNT(1) PV,
       COUNT(DISTINCT A.VID) UV
  FROM FACT_PAGE_VIEW A
 WHERE A.PAGE_NAME = 'KFZT'
   AND A.PAGE_VALUE = 'juhuasuan0901apppc'
   AND A.VISIT_DATE_KEY = 20180921
   AND TO_CHAR(A.VISIT_DATE, 'HH24MI') BETWEEN 1000 AND 1115
 GROUP BY TO_CHAR(A.VISIT_DATE, 'YYYY-MM-DD HH24:MI')
 ORDER BY TO_CHAR(A.VISIT_DATE, 'YYYY-MM-DD HH24:MI');

--2.
SELECT 'PriceDwonLive' KFZT,
       TO_CHAR(A.VISIT_DATE, 'YYYY-MM-DD HH24:MI') H,
       COUNT(1) PV,
       COUNT(DISTINCT A.VID) UV
  FROM FACT_PAGE_VIEW A
 WHERE A.PAGE_NAME = 'KFZT'
   AND A.PAGE_VALUE = 'PriceDwonLive'
   AND A.VISIT_DATE_KEY = 20180919
   AND TO_CHAR(A.VISIT_DATE, 'HH24MI') BETWEEN 1000 AND 1015
 GROUP BY TO_CHAR(A.VISIT_DATE, 'YYYY-MM-DD HH24:MI')
 ORDER BY TO_CHAR(A.VISIT_DATE, 'YYYY-MM-DD HH24:MI');
----------------------------------------------------------------------------------------------------------
--3.
SELECT 'juhuasuan0901apppc' KFZT,
       TO_CHAR(A.VISIT_DATE, 'YYYY-MM-DD HH24:MI') H,
       COUNT(1) PV,
       COUNT(DISTINCT A.VID) UV
  FROM FACT_PAGE_VIEW A
 WHERE A.PAGE_NAME = 'KFZT'
   AND A.PAGE_VALUE = 'juhuasuan0901apppc'
   AND A.VISIT_DATE_KEY = 20180917
   AND TO_CHAR(A.VISIT_DATE, 'HH24MI') BETWEEN 1910 AND 2025
 GROUP BY TO_CHAR(A.VISIT_DATE, 'YYYY-MM-DD HH24:MI')
 ORDER BY TO_CHAR(A.VISIT_DATE, 'YYYY-MM-DD HH24:MI');

--4.
SELECT 'PriceDwonLive' KFZT,
       TO_CHAR(A.VISIT_DATE, 'YYYY-MM-DD HH24:MI') H,
       COUNT(1) PV,
       COUNT(DISTINCT A.VID) UV
  FROM FACT_PAGE_VIEW A
 WHERE A.PAGE_NAME = 'KFZT'
   AND A.PAGE_VALUE = 'PriceDwonLive'
   AND A.VISIT_DATE_KEY = 20180917
   AND TO_CHAR(A.VISIT_DATE, 'HH24MI') BETWEEN 1910 AND 1925
 GROUP BY TO_CHAR(A.VISIT_DATE, 'YYYY-MM-DD HH24:MI')
 ORDER BY TO_CHAR(A.VISIT_DATE, 'YYYY-MM-DD HH24:MI');
-----------------------------------------------------------------------------------------------------------
--5.
SELECT 'juhuasuan0901apppc' KFZT,
       TO_CHAR(A.VISIT_DATE, 'YYYY-MM-DD HH24:MI') H,
       COUNT(1) PV,
       COUNT(DISTINCT A.VID) UV
  FROM FACT_PAGE_VIEW A
 WHERE A.PAGE_NAME = 'KFZT'
   AND A.PAGE_VALUE = 'juhuasuan0901apppc'
   AND ((A.VISIT_DATE_KEY = 20180917 AND
       TO_CHAR(A.VISIT_DATE, 'HH24MI') BETWEEN 1415 AND 1430) OR
       (A.VISIT_DATE_KEY = 20180918 AND
       TO_CHAR(A.VISIT_DATE, 'HH24MI') BETWEEN 1000 AND 1015))
 GROUP BY TO_CHAR(A.VISIT_DATE, 'YYYY-MM-DD HH24:MI')
 ORDER BY TO_CHAR(A.VISIT_DATE, 'YYYY-MM-DD HH24:MI');
--6.
SELECT 'PriceDwonLive' KFZT,
       TO_CHAR(A.VISIT_DATE, 'YYYY-MM-DD HH24:MI') H,
       COUNT(1) PV,
       COUNT(DISTINCT A.VID) UV
  FROM FACT_PAGE_VIEW A
 WHERE A.PAGE_NAME = 'KFZT'
   AND A.PAGE_VALUE = 'PriceDwonLive'
   AND ((A.VISIT_DATE_KEY = 20180917 AND
       TO_CHAR(A.VISIT_DATE, 'HH24MI') BETWEEN 1415 AND 1430) OR
       (A.VISIT_DATE_KEY = 20180918 AND
       TO_CHAR(A.VISIT_DATE, 'HH24MI') BETWEEN 1000 AND 1015))
 GROUP BY TO_CHAR(A.VISIT_DATE, 'YYYY-MM-DD HH24:MI')
 ORDER BY TO_CHAR(A.VISIT_DATE, 'YYYY-MM-DD HH24:MI');

--tmp 
SELECT TO_CHAR(A.VISIT_DATE, 'YYYY-MM-DD HH24') H,
       COUNT(1) PV,
       COUNT(DISTINCT A.VID) UV
  FROM FACT_PAGE_VIEW A
 WHERE A.PAGE_NAME = 'KFZT'
   AND A.PAGE_VALUE = 'juhuasuan0901apppc'
   AND A.VISIT_DATE_KEY >= 20180910
   AND TO_CHAR(A.VISIT_DATE, 'HH24MI') BETWEEN 1000 AND 1115
 GROUP BY TO_CHAR(A.VISIT_DATE, 'YYYY-MM-DD HH24')
 ORDER BY TO_CHAR(A.VISIT_DATE, 'YYYY-MM-DD HH24');

SELECT TO_CHAR(A.VISIT_DATE, 'YYYY-MM-DD HH24:MI') H,
       COUNT(1) PV,
       COUNT(DISTINCT A.VID) UV
  FROM FACT_PAGE_VIEW A
 WHERE A.PAGE_NAME = 'KFZT'
   AND A.PAGE_VALUE = 'juhuasuan0901apppc'
   AND A.VISIT_DATE_KEY >= 20180910
   AND TO_CHAR(A.VISIT_DATE, 'HH24MI') BETWEEN 1000 AND 1115
 GROUP BY TO_CHAR(A.VISIT_DATE, 'YYYY-MM-DD HH24:MI')
 ORDER BY TO_CHAR(A.VISIT_DATE, 'YYYY-MM-DD HH24:MI');

SELECT TO_CHAR(A.VISIT_DATE, 'YYYYMMDD-HH24') H, COUNT(1) PV
  FROM FACT_PAGE_VIEW A
 WHERE A.PAGE_NAME = 'KFZT'
   AND A.PAGE_VALUE = 'juhuasuan0901apppc'
   AND A.VISIT_DATE_KEY = 20180912
 GROUP BY TO_CHAR(A.VISIT_DATE, 'YYYYMMDD-HH24')
 ORDER BY TO_CHAR(A.VISIT_DATE, 'YYYYMMDD-HH24');

--36854,36948,36949
SELECT A.VISIT_DATE_KEY, COUNT(1) PV
  FROM FACT_PAGE_VIEW A
 WHERE A.PAGE_NAME = 'KFZT'
   AND A.PAGE_VALUE = 'PriceDwonLive'
   AND A.VISIT_DATE_KEY >= 20180905
 GROUP BY A.VISIT_DATE_KEY
 ORDER BY A.VISIT_DATE_KEY;

SELECT *
  FROM FACT_PAGE_VIEW A
 WHERE A.PAGE_NAME = 'KFZT'
   AND A.PAGE_VALUE = 'juhuasuan0901apppc'
   AND A.VISIT_DATE_KEY >= 20180910
 ORDER BY A.ID DESC;

SELECT *
  FROM FACT_PAGE_VIEW A
 WHERE A.PAGE_NAME = 'Good'
   AND A.Hmci = 'juhuasuan0901apppc'
   AND A.VISIT_DATE_KEY >= 20180910
 ORDER BY A.ID DESC;

SELECT *
  FROM FACT_PAGE_VIEW A
 WHERE A.PAGE_NAME = 'Good'
   AND A.Hmci = 'PriceDwonLive'
   AND A.VISIT_DATE_KEY >= 20180910
 ORDER BY A.ID DESC;

SELECT DISTINCT A.PAGE_NAME, A.PAGE_VALUE
  FROM fact_daily_goodpage A
 WHERE A.PAGE_NAME = 'KFZT'
   AND A.VISIT_DATE_KEY >= 20180910;

SELECT DISTINCT A.PAGE_NAME
  FROM fact_daily_goodpage A
 WHERE A.VISIT_DATE_KEY = 20180911;

SELECT * FROM ALL_SOURCE A WHERE UPPER(A.TEXT) LIKE '%FACT_PAGEGOODS%';

SELECT *
  FROM W_ETL_LOG A
 WHERE A.PROC_NAME = 'processpagedaily'
 ORDER BY A.START_TIME DESC;

select *
  from FACT_DAILY_GOODORDER t
 WHERE T.VISIT_DATE_KEY >= 20180910
   AND T.PAGE_NAME = 'KFZT'
   AND T.PAGE_VALUE = 'PriceDwonLive';

select *
  from fact_daily_goodpage t
 WHERE T.VISIT_DATE_KEY >= 20180910
   AND T.PAGE_NAME = 'KFZT'
   AND T.PAGE_VALUE = 'PriceDwonLive';

select *
  from (select m2.page_key,
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
           and m1.application_key = m2.application_key) m3
 where m3.page_name = 'KFZT';

select to_number(to_char(w1.visit_date, 'yyyymmdd')) as visit_date_key,
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
          w1.page_value;

select * from FACT_DAILY_GOODPAGE_1 A WHERE A.PAGE_NAME = 'KFZT';
select *
  from fact_pagegoods a
 where A.VISIT_DATE >= DATE '2018-09-10'
   AND a.page_name = 'KFZT';

select DISTINCT A.PAGE_VALUE
  from fact_pagegoods a
 where A.VISIT_DATE >= DATE '2018-09-10'
   AND a.page_name = 'KFZT';

SELECT *
  FROM (select a1.id,
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
           and length(a1.page_value) <= 6) Z
 WHERE Z.PAGE_NAME = 'KFZT';

SELECT DISTINCT A1.HMCI
  FROM fact_page_view a1
 where a1.visit_date_key >= 20180910
   and a1.page_key in (1924, 2841, 24146, 11586, 355, 38629)
   and a1.page_value != 'undefined'
   and length(a1.page_value) <= 6;

SELECT *
  FROM fact_page_view a1
 where a1.visit_date_key >= 20180910
   and a1.page_key in (1924, 2841, 24146, 11586, 355, 38629)
   and a1.page_value != 'undefined'
   and length(a1.page_value) <= 6;
