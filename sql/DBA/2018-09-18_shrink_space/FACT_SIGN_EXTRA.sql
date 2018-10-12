--1.
DROP INDEX FCTIME_IDX;
--2.
CALL YJ_OPTIMIZATION.ALTER_TABLE_SHRINK_SPACE('FACT_SIGN_EXTRA');
--3.
create index FCTIME_IDX on FACT_SIGN_EXTRA (TO_CHAR(CREATE_TIME,'yyyymmdd'))
  tablespace BIINDEX01
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
