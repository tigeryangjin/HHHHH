???create or replace force view dw_user.fact_v_week_stats as
select
visit_date_key as "日期",
  application_name as "应用",
  uvcnt  as "访客数量"          ,
  ipcnt  as "IP数量"           ,
  newvtcount as "新访客数量"        ,
  pvcnt  as "浏览数量"          ,
  avgpv  as "平均访问数量"          ,
  avglife_time as "访问时长"     ,
  newvtrate as "新访客率"      ,
  bonusrate as "跳出率"
 from fact_week_stats
 order by  visit_date_key,application_name;

