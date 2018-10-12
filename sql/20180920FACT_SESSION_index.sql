drop index FACT_SESSION_FIST_IP;
create index FACT_SESSION_FIST_IP on FACT_SESSION (FIST_IP) local
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
