--local index 只支持分区内的唯一性，无法支持表上的唯一性，因此如果要用局部索引去给表做唯一性约束，则约束中必须要包括分区键列。
drop index MEMBER_LABEL_LINK_I2;
create index MEMBER_LABEL_LINK_I2 on MEMBER_LABEL_LINK (M_LABEL_ID) LOCAL
  tablespace DWDATA00
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
	
drop index MEMBER_LABEL_LINK_I3;
create index MEMBER_LABEL_LINK_I3 on MEMBER_LABEL_LINK (MEMBER_KEY) LOCAL
  tablespace DWDATA00
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
	
drop index MEMBER_LABEL_LINK_I4;
create index MEMBER_LABEL_LINK_I4 on MEMBER_LABEL_LINK (ROW_ID) LOCAL
  tablespace DWDATA00
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
	
drop index MEMBER_LABEL_LINK_I5;
create unique index MEMBER_LABEL_LINK_I5 on MEMBER_LABEL_LINK (MEMBER_KEY, M_LABEL_ID) 
  tablespace DWDATA00
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
