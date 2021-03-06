SELECT 10000+10000+3000+5000+2000+10000+896.79+10000+10580 FROM  DUAL;

SELECT * FROM ODSHAPPIGO.ODS_PAGEVIEW A WHERE A.HMCI IS NOT NULL;

SELECT PAGE_KEY 页面KEY,
       to_date(VISIT_DATE_KEY, 'YYYY-MM-DD HH24:MI:ss') 统计日期,
       APPLICATION_NM 应用渠道名称,
       AVG(TOTALUV) 页面总UV,
       PAGE_VALUE 页面值,
       AVG(TOTALPV) 页面总PV
  FROM fact_daily_goodpage
 where VISIT_DATE_KEY = 20180911
 GROUP BY APPLICATION_NM, VISIT_DATE_KEY, PAGE_KEY, PAGE_VALUE;

SELECT SUM(A.GOODPV) FROM fact_daily_goodorder A WHERE A.VISIT_DATE_KEY=20180911;
SELECT SUM(A.PAGEPV) FROM fact_daily_goodpage A WHERE A.VISIT_DATE_KEY=20180911;

SELECT * FROM fact_daily_goodorder A WHERE A.VISIT_DATE_KEY=20180911 and a.page_name='Home';
SELECT * FROM fact_daily_goodpage A WHERE A.VISIT_DATE_KEY=20180911 and a.page_name='Home';

SELECT * FROM fact_daily_goodorder A WHERE A.VISIT_DATE_KEY=20180911 and a.page_name='KFZT';
SELECT * FROM fact_daily_goodpage A WHERE A.VISIT_DATE_KEY=20180911 and a.page_name='KFZT';

SELECT A.SESSION_KEY,A.ID,A.PAGE_NAME,A.PAGE_VALUE,A.HMKW,A.HMCI
  FROM FACT_PAGE_VIEW A
 WHERE A.SESSION_KEY IN (114058201,
                         114061061,
                         114053752,
                         114059428,
                         114067179,
                         114061428,
                         114058470,
                         114059100,
                         114060173,
                         114061296,
                         114061100,
                         114062067,
                         114061341,
                         114058268,
                         114060875,
                         114061581,
                         114061318,
                         114060923,
                         114056185,
                         114060556,
                         114060745,
                         114061182)
 ORDER BY A.SESSION_KEY, A.ID;

SELECT DISTINCT A.SESSION_KEY
  FROM FACT_PAGE_VIEW A
 WHERE A.PAGE_NAME = 'KFZT'
   AND A.PAGE_VALUE = 'PriceDwonLive'
   AND A.VISIT_DATE_KEY = 20180911;

select *
  from fact_page_view a
 where a.session_key in (114186037,
                         114187213,
                         114188393,
                         114188666,
                         114189304,
                         114190320,
                         114191045,
                         114191124,
                         114191265,
                         114191328,
                         114191478,
                         114191637,
                         114191718,
                         114191818,
                         114191856,
                         114191928,
                         114191933,
                         114192053,
                         114192093,
                         114192111,
                         114192116,
                         114192121,
                         114192198,
                         114192231,
                         114192288,
                         114192297,
                         114192347,
                         114192406,
                         114192424,
                         114192451,
                         114192487,
                         114192490,
                         114192497,
                         114192527,
                         114192536,
                         114192543,
                         114192547,
                         114192552,
                         114192569,
                         114192577,
                         114192587,
                         114192589,
                         114192590,
                         114192595,
                         114192615,
                         114192623,
                         114192626,
                         114192637,
                         114192648,
                         114192663,
                         114192670,
                         114192676,
                         114192684,
                         114192687,
                         114192696,
                         114192705,
                         114192706,
                         114192708,
                         114192712,
                         114192719,
                         114192725,
                         114192727,
                         114192742,
                         114192748,
                         114192749,
                         114192755,
                         114192756,
                         114192757,
                         114192764,
                         114192767,
                         114192768,
                         114192770,
                         114192775,
                         114192779,
                         114192780,
                         114192781,
                         114192783,
                         114192784,
                         114192787,
                         114192788,
                         114192789,
                         114192795,
                         114192796,
                         114192797,
                         114192800,
                         114192801,
                         114192804,
                         114192808,
                         114192811,
                         114192815,
                         114192816,
                         114192821,
                         114192825,
                         114192826,
                         114192828,
                         114192830,
                         114192831,
                         114192832,
                         114192833,
                         114192834,
                         114192836,
                         114192843,
                         114192846,
                         114192847,
                         114192852,
                         114192859,
                         114192860,
                         114192868,
                         114192870,
                         114192872,
                         114192873,
                         114192877,
                         114192881,
                         114192887,
                         114192892,
                         114192896,
                         114192908)
 ORDER BY A.SESSION_KEY, A.ID;

select *
/*bulk collect
into var_array*/
  from fact_page_view e
 where e.visit_date_key between 20180910 and 20180913 -- to_number(to_char(sysdate, 'yyyymmdd'))
   and e.page_key in (1924, 2841, 24146, 11586, 355, 38629, 47518)
   and e.ip_geo_key = 0
 order by e.id;

select to_number(to_char(sysdate - 2, 'yyyymmdd')) as maxday,
       to_number(to_char(sysdate + 1, 'yyyymmdd')) as maxday2
  from dual;

SELECT * FROM FACT_PAGE_VIEW A WHERE A.SESSION_KEY = 114058470;

SELECT *
  FROM FACT_PAGE_VIEW A
 WHERE A.PAGE_NAME = 'KFZT'
   AND A.PAGE_VALUE = 'PriceDwonLive'
   AND A.VISIT_DATE_KEY = 20180911
 ORDER BY A.ID DESC;

SELECT *
  FROM W_ETL_LOG A
 WHERE A.PROC_NAME IN ('processgoodpage', 'processgoodpagenull')
 ORDER BY A.START_TIME DESC;

SELECT *
  FROM ALL_SOURCE A
 WHERE UPPER(A.TEXT) LIKE '%UPDATE%FACT_PAGE_VIEW%'
   AND EXISTS (SELECT 1
          FROM ALL_SOURCE B
         WHERE A.OWNER = B.OWNER
           AND A.name = B.name
           AND A.TYPE = B.TYPE
           AND UPPER(B.TEXT) LIKE '%HMKW%');
PROCESSPAGELATION
SELECT *
  FROM FACT_PAGE_VIEW A
 WHERE A.VISIT_DATE_KEY = 20180912
   AND A.IP_GEO_KEY = -1;
