--i
select nvl(max(t.end_time),
           to_date('2016-07-19 00:00:00', 'yyyy-mm-dd hh24:mi:ss'))
  from stats_online_good2_minute t;
--il
select to_char(max(e.visit_date), 'yyyymmddhh24mi')
      from fact_page_view e
     where e.visit_date_key =to_number(to_char(sysdate, 'yyyymmdd'))
       and e.page_key in (1924, 2841, 24146, 11586, 355, 38629)
       and e.ip_geo_key != 0;
			 
--
select * from stats_online_good2_minute a where a.statdate=20171110;

select * from STATS_ONLINE_GOOD_MINUTE a where a.statdate=20171110;

select * from w_etl_log a where upper(a.table_name)='STATS_ONLINE_GOOD_MINUTE' order by a.start_time desc;

select * from w_etl_log a where a.proc_name='processgdrealtime' order by a.start_time desc;
select * from w_etl_log a where a.proc_name='processgdrealtime2' order by a.start_time desc;

select * from stats_online_good_minute;
select * from stats_online_good2_minute;

select 258+268+411+165+300+550+165 from dual;
