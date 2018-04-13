--1.
CREATE TABLE `tp_community_game_prize_setting` (
  `ID` int(11) NOT NULL AUTO_INCREMENT COMMENT '����ID',
  `GameID` int(11) NOT NULL COMMENT '��Ϸ���',
  `Probability` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '�н����ʣ���λ���֮һ',
  `PrizeName` varchar(100) NOT NULL COMMENT '��Ʒ����',
  `RewardMessage` varchar(100) DEFAULT NULL COMMENT '�н���ʾ��',
  `PrizeType` tinyint(4) NOT NULL COMMENT '0-����һ��;10-δ�н�;20-�Ż�ȯ;21-����;30-ʵ�ｱƷ',
  `PointsReward` int(11) NOT NULL DEFAULT '0' COMMENT '�����Ļ�����',
  `VoucherID` varchar(50) DEFAULT NULL COMMENT '�Ż�ȯID',
  `VoucherSend_Key` varchar(50) DEFAULT NULL COMMENT '�Ż�ȯKey',
  `CreateTime` int(11) NOT NULL COMMENT '����ʱ��',
  `PrizeNum` int(11) DEFAULT NULL COMMENT '��Ʒ����',
  `imgurl` varchar(255) DEFAULT NULL COMMENT 'ͼƬ��ַ',
  `is_del` tinyint(1) DEFAULT '0',
  `position` int(4) NOT NULL COMMENT '����',
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
  is '��Ʒ��-�м��
by yangjin
2018-03-27';
-- Add comments to the columns 
comment on column TP_COMMUNITY_GAME_PRIZE_S.id
  is '����ID';
comment on column TP_COMMUNITY_GAME_PRIZE_S.gameid
  is '��Ϸ���';
comment on column TP_COMMUNITY_GAME_PRIZE_S.probability
  is '�н����ʣ���λ���֮һ';
comment on column TP_COMMUNITY_GAME_PRIZE_S.prizename
  is '��Ʒ����';
comment on column TP_COMMUNITY_GAME_PRIZE_S.rewardmessage
  is '�н���ʾ��';
comment on column TP_COMMUNITY_GAME_PRIZE_S.prizetype
  is '0-����һ��;10-δ�н�;20-�Ż�ȯ;21-����;30-ʵ�ｱƷ';
comment on column TP_COMMUNITY_GAME_PRIZE_S.pointsreward
  is '�����Ļ�����';
comment on column TP_COMMUNITY_GAME_PRIZE_S.voucherid
  is '�Ż�ȯID';
comment on column TP_COMMUNITY_GAME_PRIZE_S.vouchersend_key
  is '�Ż�ȯKey';
comment on column TP_COMMUNITY_GAME_PRIZE_S.createtime
  is '����ʱ��';
comment on column TP_COMMUNITY_GAME_PRIZE_S.prizenum
  is '��Ʒ����';
comment on column TP_COMMUNITY_GAME_PRIZE_S.imgurl
  is 'ͼƬ��ַ';
comment on column TP_COMMUNITY_GAME_PRIZE_S.position
  is '����';
