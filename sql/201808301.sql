CREATE TABLE YANGJIN.FACT_PAGE_VIEW_201807 AS
SELECT *
  FROM fact_page_view c2
 WHERE c2.visit_date_key BETWEEN 20180701 AND 20180731;
	 
	 
SELECT COUNT(DISTINCT c1.vid) / 31
  FROM factec_order c1
 WHERE c1.add_time BETWEEN 20180701 AND 20180731
   AND NOT EXISTS
 (SELECT 1
          FROM YANGJIN.FACT_PAGE_VIEW_201807 c2
         WHERE c2.visit_date_key BETWEEN 20180701 AND 20180731
           AND application_key IN (10, 20)
           AND c2.hmsc IN (SELECT hmsc FROM dim_hmsc WHERE hmpl = '推广')
           AND c2.vid = c1.vid)
   AND NOT EXISTS
 (SELECT 1
          FROM fact_daily_pcpromotion c3
         WHERE c3.active_date_key BETWEEN 20180701 AND 20180731
           AND c3.vid = c1.vid)
   AND NOT EXISTS
 (SELECT 1
          FROM fact_daily_3gpromotion c3
         WHERE c3.active_date_key BETWEEN 20180701 AND 20180731
           AND c3.vid = c1.vid)
   AND NOT EXISTS
 (SELECT 1
          FROM dim_vid_scan c5
         WHERE c5.scan_date_key BETWEEN 20180701 AND 20180731
           AND c5.vid = c1.vid);

create table yangjin.vid1 as 
SELECT distinct c2.vid
  FROM YANGJIN.FACT_PAGE_VIEW_201807 c2
 WHERE c2.visit_date_key BETWEEN 20180701 AND 20180731
   AND application_key IN (10, 20)
   AND c2.hmsc IN (SELECT hmsc FROM dim_hmsc WHERE hmpl = '推广');

create table yangjin.vid2 as 
SELECT distinct c3.vid
  FROM fact_daily_pcpromotion c3
 WHERE c3.active_date_key BETWEEN 20180701 AND 20180731;

create table yangjin.vid3 as 
SELECT distinct c3.vid
  FROM fact_daily_3gpromotion c3
 WHERE c3.active_date_key BETWEEN 20180701 AND 20180731;

create table yangjin.vid4 as  
SELECT distinct c3.vid
  FROM dim_vid_scan c3
 WHERE c3.active_date_key BETWEEN 20180701 AND 20180731;


SELECT COUNT(DISTINCT c1.vid) / 31
  FROM factec_order c1
 WHERE c1.add_time BETWEEN 20180701 AND 20180731
   AND NOT EXISTS
 (SELECT 1
          FROM yangjin.vid1 c2
         WHERE c2.vid = c1.vid)
   AND NOT EXISTS
 (SELECT 1
          FROM yangjin.vid2 c3
         WHERE c3.vid = c1.vid)
   AND NOT EXISTS
 (SELECT 1
          FROM yangjin.vid3 c3
         WHERE c3.vid = c1.vid)
   AND NOT EXISTS
 (SELECT 1
          FROM yangjin.vid4 c5
         WHERE c5.vid = c1.vid);
				 
select  529.29/734 from dual;
