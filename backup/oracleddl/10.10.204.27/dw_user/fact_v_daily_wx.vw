???create or replace force view dw_user.fact_v_daily_wx as
select
h1.visit_date_key as "统计日期",
h1.uvcnt as "活跃用户",
h1.newvtcount as "新访客",
h1.pvcnt as "浏览数",
h1.avgpv as "平均浏览数",
h1.avglife_time as "平均浏览时长",
h1.newvtrate as "新访客率",
h1.bonusrate as "跳出率",
h1.orderrate as "订单转化率",
h1.mcnt as "会员注册数"
from fact_daily_wx h1
order by h1.visit_date_key desc;

