--1.
CREATE TABLE `tp_community_game_prize_setting` (
  `ID` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `GameID` int(11) NOT NULL COMMENT '游戏编号',
  `Probability` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '中奖概率，单位万分之一',
  `PrizeName` varchar(100) NOT NULL COMMENT '奖品名称',
  `RewardMessage` varchar(100) DEFAULT NULL COMMENT '中奖提示语',
  `PrizeType` tinyint(4) NOT NULL COMMENT '0-再来一次;10-未中奖;20-优惠券;21-积分;30-实物奖品',
  `PointsReward` int(11) NOT NULL DEFAULT '0' COMMENT '奖励的积分数',
  `VoucherID` varchar(50) DEFAULT NULL COMMENT '优惠券ID',
  `VoucherSend_Key` varchar(50) DEFAULT NULL COMMENT '优惠券Key',
  `CreateTime` int(11) NOT NULL COMMENT '创建时间',
  `PrizeNum` int(11) DEFAULT NULL COMMENT '奖品数量',
  `imgurl` varchar(255) DEFAULT NULL COMMENT '图片地址',
  `is_del` tinyint(1) DEFAULT '0',
  `position` int(4) NOT NULL COMMENT '排序',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

--2.
create table tp_community_game_prize_stmp(
  id number(11) not null,
  gameid number(11) not null,
  probability number(10) ,
  prizename varchar2(100) not null,
  rewardmessage varchar2(100) ,
  prizetype number(4) not null,
  pointsreward number(11) not null,
  voucherid varchar2(50) ,
  vouchersend_key varchar2(50) ,
  createtime date not null ,
  prizenum number(11) default null,
  imgurl varchar2(255) ,
  is_del number(1) ,
  position number(4) not null);
	
--3.
-- Create table
create table TP_COMMUNITY_GAME_PRIZE_S
(
  id              NUMBER(11),
  gameid          NUMBER(11),
  probability     NUMBER(10),
  prizename       VARCHAR2(100),
  rewardmessage   VARCHAR2(100),
  prizetype       NUMBER(4),
  pointsreward    NUMBER(11),
  voucherid       VARCHAR2(50),
  vouchersend_key VARCHAR2(50),
  createtime      DATE,
  prizenum        NUMBER(11),
  imgurl          VARCHAR2(255),
  is_del          NUMBER(1),
  position        NUMBER(4)
)
tablespace DWDATA00
  pctfree 10
  initrans 1
  maxtrans 255;
-- Add comments to the table 
comment on table TP_COMMUNITY_GAME_PRIZE_S
  is '奖品表-中间表
by yangjin
2018-03-27';
-- Add comments to the columns 
comment on column TP_COMMUNITY_GAME_PRIZE_S.id
  is '自增ID';
comment on column TP_COMMUNITY_GAME_PRIZE_S.gameid
  is '游戏编号';
comment on column TP_COMMUNITY_GAME_PRIZE_S.probability
  is '中奖概率，单位万分之一';
comment on column TP_COMMUNITY_GAME_PRIZE_S.prizename
  is '奖品名称';
comment on column TP_COMMUNITY_GAME_PRIZE_S.rewardmessage
  is '中奖提示语';
comment on column TP_COMMUNITY_GAME_PRIZE_S.prizetype
  is '0-再来一次;10-未中奖;20-优惠券;21-积分;30-实物奖品';
comment on column TP_COMMUNITY_GAME_PRIZE_S.pointsreward
  is '奖励的积分数';
comment on column TP_COMMUNITY_GAME_PRIZE_S.voucherid
  is '优惠券ID';
comment on column TP_COMMUNITY_GAME_PRIZE_S.vouchersend_key
  is '优惠券Key';
comment on column TP_COMMUNITY_GAME_PRIZE_S.createtime
  is '创建时间';
comment on column TP_COMMUNITY_GAME_PRIZE_S.prizenum
  is '奖品数量';
comment on column TP_COMMUNITY_GAME_PRIZE_S.imgurl
  is '图片地址';
comment on column TP_COMMUNITY_GAME_PRIZE_S.position
  is '排序';
