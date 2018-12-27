???create or replace force view dw_user.fact_v_daily_app as
select
h.visit_date_key as "统计日期",
h.iosnewvt as "IOS新访客",
h.aznewvt as "安卓新访客",
h.newvtcount as "总新访客",
h.iosvt as "IOS活跃用户",
h.azvt  as "安卓活跃用户",
h.uvcnt as "总活跃用户",
h.iosmembercnt as "IOS注册人数",
h.andmembercnt as "安卓注册人数",
h.cntstart as "启动次数",
h.lcrate as "次日留存率" ,
nvl(h.tvsmrs,0) as "中间页扫码数",
nvl(h.zbsmrs,0) as "直播列表页扫码数",
h.pvcnt  as "浏览数",
h.avgpv  as "平均浏览数",
h.avglife_time as "平均浏览时长",
h.newvtrate as "新访客率",
h.bonusrate as "跳出率",
h.orderrate as "订单转化率"
from fact_daily_app h
order by h.visit_date_key desc;

