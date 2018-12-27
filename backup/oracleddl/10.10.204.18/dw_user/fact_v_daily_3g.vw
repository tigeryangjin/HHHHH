???create or replace force view dw_user.fact_v_daily_3g as
select
h3.visit_date_key as "统计日期",
h3.uvcnt as "活跃用户",
h3.newvtcount as "新访客",
h3.pvcnt as "浏览数",
h3.ipcnt as "IP数",
h3.avgpv as "平均浏览数",
h3.avglife_time as "平均浏览时长",
h3.newvtrate as "新访客率",
h3.bonusrate as "跳出率",
h3.orderrate as "订单转化率",
h3.mcnt as "会员注册数"
 from  fact_daily_3g h3 order by h3.visit_date_key desc;

