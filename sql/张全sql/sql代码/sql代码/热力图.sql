------ÍÆ¼öÒ³
select page_name,SUM(UV)/COUNT(DISTINCT(visit_date_key)) from (
select  COUNT(DISTINCT(VID)) UV,page_name,visit_date_key  from  fact_page_view where
visit_date_key between 20170317 and 20170323
and page_name like '%SL_B2C_%'
---and applincation_key in (10,20)
group by page_name,visit_date_key)
GROUP BY page_name

---- ÍÆ¼öÒ³ 4ICON
select page_name,page_VALUE,SUM(UV)/COUNT(DISTINCT(visit_date_key)) from (
select  COUNT(DISTINCT(VID)) UV,page_name,page_VALUE,visit_date_key  from  fact_page_view where
visit_date_key between 20170317 and 20170323
and page_name like '%LS_B2C_%'
---and applincation_key in (10,20)
group by page_name,page_VALUE,visit_date_key)
GROUP BY page_name,page_VALUE



------TVÒ³
select page_name,SUM(UV)/COUNT(DISTINCT(visit_date_key)) from (
select  COUNT(DISTINCT(VID)) UV,page_name,visit_date_key  from  fact_page_view where
visit_date_key between 20170317 and 20170323
and page_name like '%SL_B2C_%'
---and applincation_key in (10,20)
group by page_name,visit_date_key)
GROUP BY page_name

---- ÍÆ¼öÒ³ 4ICON
select page_name,page_VALUE,SUM(UV)/COUNT(DISTINCT(visit_date_key)) from (
select  COUNT(DISTINCT(VID)) UV,page_name,page_VALUE,visit_date_key  from  fact_page_view where
visit_date_key between 20170317 and 20170323
and page_name like '%LS_B2C_%'
---and applincation_key in (10,20)
group by page_name,page_VALUE,visit_date_key)
GROUP BY page_name,page_VALUE
