--APP月活  （整月一起算）
select * from kpi_asmt_app_mau 正常   
--APP净订购转化率 （按天计算然后求平均 ）
select * from  kpi_asmt_app_net_order_cvr 正常
----商品详情页转化率  （按天计算然后求平均 ）
select * from kpi_asmt_app_item_cvr 正常
---微信日活  （按天计算然后求平均 ）
select * from kpi_asmt_wx_dau 正常
---新增注册数  （整月一起算）
select * from  kpi_asmt_wx_new_reg  正常
--非扫码人数净订购转化率  （按天计算然后求平均 ）
select * from kpi_asmt_wx_non_scan_cvr  --有异常  不能一次性整月一起算，需要按天计算然后求平均 
--视频购商品详情页转化率  （按天计算然后求平均 ）
select * from kpi_asmt_vedio_item_cvr --有异常  不能一次性整月一起算，需要按天计算然后求平均 
--日均新访客数  （按天计算然后求平均 ）
select * from kpi_asmt_new_uv ---有异常  不能一次性整月一起算，需要按天计算然后求平均 
--日均老访客数  （按天计算然后求平均 ）
select * from kpi_asmt_old_uv ---有异常  不能一次性整月一起算，需要按天计算然后求平均 
---APP新增下载数 （整月一起算） 
select * from  kpi_asmt_app_download  正常

---当月新注册会员净订购转化率 （整月一起算）
select *  from   kpi_asmt_reg_order_cvr  正常
-----老会员复购人数（整月一起算）
select * from   kpi_asmt_repurchase_member 正常
----会员复购率  （整月一起算）
select * from kpi_asmt_repurchase_member 正常



