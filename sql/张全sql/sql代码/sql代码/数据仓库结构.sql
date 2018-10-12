-----------------------------------------------------
-- Export file for user DW_USER                    --
-- Created by Administrator on 2017/2/15, 16:12:15 --
-----------------------------------------------------

set define off
spool 数据仓库结构.log

prompt
prompt Creating table ABPAGE_MEMSCORE
prompt ==============================
prompt
create table DW_USER.ABPAGE_MEMSCORE
(
  member_key NUMBER,
  memscore   NUMBER
)
tablespace DWDATA00
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index DW_USER.MEM_COUNTSCORE_IDX on DW_USER.ABPAGE_MEMSCORE (MEMBER_KEY)
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


spool off
