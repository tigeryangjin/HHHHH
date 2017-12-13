*|select resource, loglevel,count(1) as c group by resource, loglevel limit 100
*|select excuteresult,count(1) as c group by excuteresult limit 1000
*|select substr(excuteresult,20,14),count(1) as c group by substr(excuteresult,20,14) limit 1000
*|select regexp_extract(excuteresult,'code?\d+') as code,count(1) as c group by regexp_extract(excuteresult,'code?\d+') limit 1000
*|select substr(excuteresult,strpos(excuteresult,'code'),11),count(1) as c group by substr(excuteresult,strpos(excuteresult,'code'),11) limit 1000
*|select excuteresult,regexp_extract(excuteresult, '\"code\":\"\d+\"')
*|select regexp_extract(excuteresult, '\"code\":\"\d+\"') as code,count(1) as c group by regexp_extract(excuteresult, '\"code\":\"\d+\"') limit 1000
loglevel=error|select regexp_extract(excuteresult, '\"code\":\"\d+\"') as code,count(1) as c group by regexp_extract(excuteresult, '\"code\":\"\d+\"') limit 1000