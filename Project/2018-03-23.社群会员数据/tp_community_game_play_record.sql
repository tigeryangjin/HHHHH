--1.
-- Create table
create table TP_COMMUNITY_GAME_PLAY_R_TMP
(
  id                   NUMBER(11) not null,
  gameid               NUMBER(11),
  group_id             NUMBER(11),
  openid               VARCHAR2(250),
  ip                   VARCHAR2(255),
  member_crmbp         VARCHAR2(20),
  memberdisplayname    VARCHAR2(50),
  prizeid              NUMBER(11),
  prizename            VARCHAR2(100),
  prizetype            NUMBER(4),
  pointsreward         VARCHAR2(11),
  vouchercodereward    VARCHAR2(50),
  delivery_name        VARCHAR2(50),
  delivery_phonenumber VARCHAR2(11),
  delivery_address     VARCHAR2(255),
  put_status           NUMBER(1),
  audit_status         NUMBER(1),
  audit_admin          VARCHAR2(50),
  audit_time           DATE,
  remark               VARCHAR2(200),
  createtime           DATE
)
tablespace DWDATA00
  pctfree 10
  initrans 1
  maxtrans 255;
-- Add comments to the table 
comment on table TP_COMMUNITY_GAME_PLAY_R_TMP
  is '抽奖记录表-中间表
by yangjin
2018-03-27';
-- Add comments to the columns 
comment on column TP_COMMUNITY_GAME_PLAY_R_TMP.id
  is '自增ID';
comment on column TP_COMMUNITY_GAME_PLAY_R_TMP.gameid
  is '游戏编号';
comment on column TP_COMMUNITY_GAME_PLAY_R_TMP.group_id
  is '群号';
comment on column TP_COMMUNITY_GAME_PLAY_R_TMP.openid
  is 'openid';
comment on column TP_COMMUNITY_GAME_PLAY_R_TMP.ip
  is 'ip';
comment on column TP_COMMUNITY_GAME_PLAY_R_TMP.member_crmbp
  is '会员ID';
comment on column TP_COMMUNITY_GAME_PLAY_R_TMP.memberdisplayname
  is '会员显示名';
comment on column TP_COMMUNITY_GAME_PLAY_R_TMP.prizeid
  is '奖品ID';
comment on column TP_COMMUNITY_GAME_PLAY_R_TMP.prizename
  is '奖品名称';
comment on column TP_COMMUNITY_GAME_PLAY_R_TMP.prizetype
  is '0-再来一次;10-未中奖;20-优惠券;21-积分;30-实物奖品';
comment on column TP_COMMUNITY_GAME_PLAY_R_TMP.pointsreward
  is '奖励的积分数，0表示不赠送积分';
comment on column TP_COMMUNITY_GAME_PLAY_R_TMP.vouchercodereward
  is '奖励的优惠券号，空表示不赠送券';
comment on column TP_COMMUNITY_GAME_PLAY_R_TMP.delivery_name
  is '收货人姓名，仅用于实物奖品';
comment on column TP_COMMUNITY_GAME_PLAY_R_TMP.delivery_phonenumber
  is '收货人联系电话，仅用于实物奖品';
comment on column TP_COMMUNITY_GAME_PLAY_R_TMP.delivery_address
  is '收货人详细地址，仅用于实物奖品';
comment on column TP_COMMUNITY_GAME_PLAY_R_TMP.put_status
  is '发放状态：-1失败，1成功，0待发放，默认空';
comment on column TP_COMMUNITY_GAME_PLAY_R_TMP.audit_status
  is '审核状态：-1不通过，1审核通过，0待审核，默认空';
comment on column TP_COMMUNITY_GAME_PLAY_R_TMP.audit_admin
  is '审核人';
comment on column TP_COMMUNITY_GAME_PLAY_R_TMP.audit_time
  is '审核时间';
comment on column TP_COMMUNITY_GAME_PLAY_R_TMP.remark
  is '备注';
comment on column TP_COMMUNITY_GAME_PLAY_R_TMP.createtime
  is '中奖时间';


--2.
-- Create table
create table TP_COMMUNITY_GAME_PLAY_R
(
  id                   NUMBER(11) not null,
  gameid               NUMBER(11),
  group_id             NUMBER(11),
  openid               VARCHAR2(250),
  ip                   VARCHAR2(255),
  member_crmbp         VARCHAR2(20),
  memberdisplayname    VARCHAR2(50),
  prizeid              NUMBER(11),
  prizename            VARCHAR2(100),
  prizetype            NUMBER(4),
  pointsreward         VARCHAR2(11),
  vouchercodereward    VARCHAR2(50),
  delivery_name        VARCHAR2(50),
  delivery_phonenumber VARCHAR2(11),
  delivery_address     VARCHAR2(255),
  put_status           NUMBER(1),
  audit_status         NUMBER(1),
  audit_admin          VARCHAR2(50),
  audit_time           DATE,
  remark               VARCHAR2(200),
  createtime           DATE
)
tablespace DWDATA00
  pctfree 10
  initrans 1
  maxtrans 255;
-- Add comments to the table 
comment on table TP_COMMUNITY_GAME_PLAY_R
  is '抽奖记录表
by yangjin
2018-03-27';
-- Add comments to the columns 
comment on column TP_COMMUNITY_GAME_PLAY_R.id
  is '自增ID';
comment on column TP_COMMUNITY_GAME_PLAY_R.gameid
  is '游戏编号';
comment on column TP_COMMUNITY_GAME_PLAY_R.group_id
  is '群号';
comment on column TP_COMMUNITY_GAME_PLAY_R.openid
  is 'openid';
comment on column TP_COMMUNITY_GAME_PLAY_R.ip
  is 'ip';
comment on column TP_COMMUNITY_GAME_PLAY_R.member_crmbp
  is '会员ID';
comment on column TP_COMMUNITY_GAME_PLAY_R.memberdisplayname
  is '会员显示名';
comment on column TP_COMMUNITY_GAME_PLAY_R.prizeid
  is '奖品ID';
comment on column TP_COMMUNITY_GAME_PLAY_R.prizename
  is '奖品名称';
comment on column TP_COMMUNITY_GAME_PLAY_R.prizetype
  is '0-再来一次;10-未中奖;20-优惠券;21-积分;30-实物奖品';
comment on column TP_COMMUNITY_GAME_PLAY_R.pointsreward
  is '奖励的积分数，0表示不赠送积分';
comment on column TP_COMMUNITY_GAME_PLAY_R.vouchercodereward
  is '奖励的优惠券号，空表示不赠送券';
comment on column TP_COMMUNITY_GAME_PLAY_R.delivery_name
  is '收货人姓名，仅用于实物奖品';
comment on column TP_COMMUNITY_GAME_PLAY_R.delivery_phonenumber
  is '收货人联系电话，仅用于实物奖品';
comment on column TP_COMMUNITY_GAME_PLAY_R.delivery_address
  is '收货人详细地址，仅用于实物奖品';
comment on column TP_COMMUNITY_GAME_PLAY_R.put_status
  is '发放状态：-1失败，1成功，0待发放，默认空';
comment on column TP_COMMUNITY_GAME_PLAY_R.audit_status
  is '审核状态：-1不通过，1审核通过，0待审核，默认空';
comment on column TP_COMMUNITY_GAME_PLAY_R.audit_admin
  is '审核人';
comment on column TP_COMMUNITY_GAME_PLAY_R.audit_time
  is '审核时间';
comment on column TP_COMMUNITY_GAME_PLAY_R.remark
  is '备注';
comment on column TP_COMMUNITY_GAME_PLAY_R.createtime
  is '中奖时间';
-- Create/Recreate primary, unique and foreign key constraints 
alter table TP_COMMUNITY_GAME_PLAY_R
  add constraint TP_COMMUNITY_GAME_PLAY_R_PK primary key (ID)
  using index 
  tablespace DWDATA00
  pctfree 10
  initrans 2
  maxtrans 255;

