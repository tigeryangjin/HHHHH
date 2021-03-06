CREATE TABLE fact_ec_p_xianshi (
   xianshi_id number(10) ,
   crm_policy_id varchar2(20),
   xianshi_type number(2) ,
   xianshi_name varchar2(50),
   xianshi_title varchar2(10) ,
   xianshi_explain varchar2(50),
   quota_id number(10) ,
   start_time number(10) ,
   end_time number(10) ,
   xianshi_time number(10),
   member_id number(10) ,
   store_id number(10) ,
   member_name varchar2(50),
   store_name varchar2(50) ,
   lower_limit number(10) ,
   state number(3)  ,
   xianshi_web number(2),
   xianshi_3g number(2) ,
   xianshi_app number(2) ,
   xianshi_wx number(2) ,
   xianshi_schedule number(2) 
 ) ;
 
-- Add comments to the columns 
comment on column fact_ec_p_xianshi.xianshi_id
  is '限时编号';
comment on column fact_ec_p_xianshi.crm_policy_id
  is 'CRM促销编号';
comment on column fact_ec_p_xianshi.xianshi_type
  is '限时类型 1限时直降  2限时抢 3 tv直减';
comment on column fact_ec_p_xianshi.xianshi_name
  is '活动名称';
comment on column fact_ec_p_xianshi.xianshi_title
  is '活动标题';
comment on column fact_ec_p_xianshi.xianshi_explain
  is '活动说明';
comment on column fact_ec_p_xianshi.quota_id
  is '套餐编号';
comment on column fact_ec_p_xianshi.start_time
  is '活动开始时间';
comment on column fact_ec_p_xianshi.end_time
  is '活动结束时间';
comment on column fact_ec_p_xianshi.xianshi_time
  is '限时抢日期';
comment on column fact_ec_p_xianshi.member_id
  is '用户编号';
comment on column fact_ec_p_xianshi.store_id
  is '店铺编号';
comment on column fact_ec_p_xianshi.member_name
  is '用户名';
comment on column fact_ec_p_xianshi.store_name
  is '店铺名称';
comment on column fact_ec_p_xianshi.lower_limit
  is '购买下限，1为不限制';
comment on column fact_ec_p_xianshi.state
  is '状态，0-取消 1-正常 2结束 3管理员关闭';
comment on column fact_ec_p_xianshi.xianshi_web
  is '作用于网站';
comment on column fact_ec_p_xianshi.xianshi_3g
  is '作用于3G';
comment on column fact_ec_p_xianshi.xianshi_app
  is '作用于APP';
comment on column fact_ec_p_xianshi.xianshi_wx
  is '作用于微信';
comment on column fact_ec_p_xianshi.xianshi_schedule
  is '限时抢档期';
	
