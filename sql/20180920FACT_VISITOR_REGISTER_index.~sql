drop index FACT_VISITOR_REGISTER_I1;
create index FACT_VISITOR_REGISTER_I1 on FACT_VISITOR_REGISTER (CREATE_DATE_KEY, VISTOR_KEY) local
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
  )
  nologging;
	
drop index FACT_VISITOR_REGISTER_I2;
create index FACT_VISITOR_REGISTER_I2 on FACT_VISITOR_REGISTER (APPLICATION_KEY) local
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
  )
  nologging;
	
drop index FACT_VISITOR_REGISTER_IP_INT;
create index FACT_VISITOR_REGISTER_IP_INT on FACT_VISITOR_REGISTER (IP_INT) local
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
  )
  nologging;
	
drop index FACT_VISITOR_REGISTER_VID;
create index FACT_VISITOR_REGISTER_VID on FACT_VISITOR_REGISTER (VID) local
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
  )
  nologging;
