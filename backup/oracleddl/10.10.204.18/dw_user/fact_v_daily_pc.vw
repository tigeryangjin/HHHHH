???create or replace force view dw_user.fact_v_daily_pc as
select
h2.visit_date_key as "统计日期",
h2.uvcnt as "活跃用户",
h2.newvtcount as "新访客",
h2.zccnt as "注册人数",
h2.pvcnt as "浏览数",
h2.ipcnt as "IP数",
h2.avgpv as "平均浏览数",
h2.avglife_time as "平均浏览时长",
h2.newvtrate as "新访客率",
h2.bonusrate as "跳出率",
h2.orderrate as "订单转化率"
from fact_daily_pc h2 order by h2.visit_date_key  desc;

