*|select resource, loglevel,count(1) as c group by resource, loglevel limit 100
*|select excuteresult,count(1) as c group by excuteresult limit 1000
*|select substr(excuteresult,20,14),count(1) as c group by substr(excuteresult,20,14) limit 1000
*|select regexp_extract(excuteresult,'code?\d+') as code,count(1) as c group by regexp_extract(excuteresult,'code?\d+') limit 1000
*|select substr(excuteresult,strpos(excuteresult,'code'),11),count(1) as c group by substr(excuteresult,strpos(excuteresult,'code'),11) limit 1000
*|select excuteresult,regexp_extract(excuteresult, '\"code\":\"\d+\"')
*|select regexp_extract(excuteresult, '\"code\":\"\d+\"') as code,count(1) as c group by regexp_extract(excuteresult, '\"code\":\"\d+\"') limit 1000
loglevel=error|select regexp_extract(excuteresult, '\"code\":\"\d+\"') as code,count(1) as c group by regexp_extract(excuteresult, '\"code\":\"\d+\"') limit 1000
*|select regexp_extract(resource,'/[a-z.]*') as resource,method,min(totalexpend) min_totalexpend,max(totalexpend) max_totalexpend,avg(totalexpend) avg_totalexpend,count(1) as log_count group by regexp_extract(resource,'/[a-z.]*'),method order by avg(totalexpend) desc limit 1000
*|select resource, regexp_extract(resource,'/[a-z]*.[a-z]*{0,}/?' ) as r limit 1000
*|select trim(regexp_extract(resource,'/[a-z]*.[a-z]*{0,}/?' ),'/') as resource,count(1) as c group by trim(regexp_extract(resource,'/[a-z]*.[a-z]*{0,}/?' ),'/') order by count(1) desc  limit 1000
not (loglevel=info or loglevel=error or loglevel=trace or loglevel=warning)|select projectname group by projectname limit 100
not(method=GET or method=POST or method=PUT or method=DELETE)|select trim(regexp_extract(resource,'/[a-z.]*'),'/') group by trim(regexp_extract(resource,'/[a-z.]*'),'/') limit 1000

*|select trim(regexp_extract(resource,'/[a-z.]*'),'/'),method group by trim(regexp_extract(resource,'/[a-z.]*'),'/'),method order by trim(regexp_extract(resource,'/[a-z.]*'),'/'),method limit 1000

projectname=EC.MemberOrderStatus.task|select case when count(1) is null then 0 else count(1) end count_all,case when sum(case when loglevel='info' then 1 else 0 end) is null then 0 else sum(case when loglevel='info' then 1 else 0 end) end count_info,case when sum(case when loglevel='error' then 1 else 0 end) is null then 0 else sum(case when loglevel='error' then 1 else 0 end) end count_error,case when sum(case when loglevel='warning' then 1 else 0 end) is null then 0 else sum(case when loglevel='warning' then 1 else 0 end) end count_warning,case when sum(case when loglevel='trace' then 1 else 0 end) is null then 0 else sum(case when loglevel='trace' then 1 else 0 end) end count_trace,case when round(avg(totalexpend)) is null then 0 else round(avg(totalexpend)) end avg_expend_all,case when round(avg(case when loglevel='info' then totalexpend end)) is null then 0 else round(avg(case when loglevel='info' then totalexpend  end)) end avg_expend_info,case when round(avg(case when loglevel='error' then totalexpend end)) is null then 0 else round(avg(case when loglevel='error' then totalexpend end)) end avg_expend_error,case when round(avg(case when loglevel='warning' then totalexpend end)) is null then 0 else round(avg(case when loglevel='warning' then totalexpend end)) end avg_expend_warning,case when round(avg(case when loglevel='trace' then totalexpend end)) is null then 0 else round(avg(case when loglevel='trace' then totalexpend end)) end avg_expend_trace

* and Query_time|select __source__ as ip,count(1) cnt group by __source__ order by count(1) desc limit 1000
#慢查询日志监控
* and source: 10.33.2.180 and Query_time|select count(1) cnt limit 1000

Wxcms.AdminSendHb.Api and loglevel=error and message=改红包不存在