???create or replace force view dw_happigo.stats_report as
select aa.logid ,aa.objectname,aa.request,aa.response,aa.responsecode,aa.ip,aa.vid,aa.applicationkey
,aa.logdatekey as statdate,aa.logtime,bb.stathour,bb.statminute,bb.start_time,bb.end_time from  fact_request aa,stats_api_minute bb
where aa.responsecode <= 3000
and aa.responsecode not in (0, 2102)
and aa.logdatekey=bb.statdate
and aa.logtime>=bb.start_time and aa.logtime<bb.end_time;

