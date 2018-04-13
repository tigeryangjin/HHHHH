-- Create table
create table SAP_BIC_AZTCRD00100
(
  crm_obj_id       VARCHAR2(100),
  crm_numint       VARCHAR2(100),
  recordmode       VARCHAR2(100),
  "/BIC/ZEAMC008"  VARCHAR2(100),
  crm_ohguid       VARCHAR2(100),
  crm_itmgui       VARCHAR2(100),
  crm_prctyp       VARCHAR2(100),
  "/BIC/ZCRMD023"  VARCHAR2(100),
  crm_itmtyp       VARCHAR2(100),
  "/BIC/ZTCMC002"  VARCHAR2(100),
  "/BIC/ZTCMC006"  VARCHAR2(100),
  salesorg         VARCHAR2(100),
  distr_chan       VARCHAR2(100),
  sales_off        VARCHAR2(100),
  division         VARCHAR2(100),
  "/BIC/ZMATERIAL" VARCHAR2(100),
  "/BIC/ZEAMC027"  VARCHAR2(100),
  "/BIC/ZLIFNR"    VARCHAR2(100),
  crm_endcst       VARCHAR2(100),
  "/BIC/ZTCMC016"  VARCHAR2(100),
  age              VARCHAR2(100),
  "/BIC/ZTCMC020"  VARCHAR2(100),
  crm_soldto       VARCHAR2(100),
  "/BIC/ZKUNNR_L1" VARCHAR2(100),
  "/BIC/ZKUNNR_L2" VARCHAR2(100),
  "/BIC/ZTHRC015"  VARCHAR2(100),
  bp_emplo         VARCHAR2(100),
  "/BIC/ZTHRC016"  VARCHAR2(100),
  "/BIC/ZTHRC017"  VARCHAR2(100),
  "/BIC/ZESDC113"  VARCHAR2(100),
  crmpostdat       VARCHAR2(100),
  "/BIC/ZPST_TIM"  VARCHAR2(100),
  "/BIC/ZGZ_TIME"  VARCHAR2(100),
  "/BIC/ZCRMD001"  VARCHAR2(100),
  crm_usstat       VARCHAR2(100),
  crm_stsma        VARCHAR2(100),
  crm_ctd_by       VARCHAR2(100),
  crm_crd_at       VARCHAR2(100),
  crea_time        VARCHAR2(100),
  "/BIC/ZEAMC001"  VARCHAR2(100),
  "/BIC/ZEAMC010"  VARCHAR2(100),
  "/BIC/ZEAMC011"  VARCHAR2(100),
  "/BIC/ZEAMC012"  VARCHAR2(100),
  "/BIC/ZEAMC037"  VARCHAR2(100),
  "/BIC/ZEAMC013"  VARCHAR2(100),
  "/BIC/ZEAMC014"  VARCHAR2(100),
  "/BIC/ZTCMC021"  VARCHAR2(100),
  "/BIC/ZTCMC022"  VARCHAR2(100),
  "/BIC/ZTCMC027"  VARCHAR2(100),
  "/BIC/ZTCMC026"  VARCHAR2(100),
  "/BIC/ZTCMC030"  VARCHAR2(100),
  "/BIC/ZTCMC007"  VARCHAR2(100),
  "/BIC/ZTCMC008"  VARCHAR2(100),
  "/BIC/ZTCMC009"  VARCHAR2(100),
  "/BIC/ZTCMC023"  VARCHAR2(100),
  "/BIC/ZTCMC024"  VARCHAR2(100),
  "/BIC/ZTCMC025"  VARCHAR2(100),
  "/BIC/ZCRMD015"  VARCHAR2(100),
  "/BIC/ZCRMD016"  VARCHAR2(100),
  "/BIC/ZCRMD017"  VARCHAR2(100),
  "/BIC/ZCRMD018"  VARCHAR2(100),
  "/BIC/ZCR_ON"    VARCHAR2(100),
  "/BIC/ZOBJ_CC"   VARCHAR2(100),
  "/BIC/ZDSXD"     VARCHAR2(100),
  "/BIC/ZJSJF_YN"  VARCHAR2(100),
  "/BIC/ZCRMD025"  VARCHAR2(100),
  "/BIC/ZCRMD020"  VARCHAR2(100),
  "/BIC/ZCRMD021"  VARCHAR2(100),
  "/BIC/ZTCRMC01"  VARCHAR2(100),
  "/BIC/ZTCRMC02"  VARCHAR2(100),
  "/BIC/ZTCRMC03"  VARCHAR2(100),
  "/BIC/ZTCRMC04"  VARCHAR2(100),
  "/BIC/ZTCRMC05"  VARCHAR2(100),
  unit             VARCHAR2(100),
  netvalord        VARCHAR2(100),
  crm_taxamo       VARCHAR2(100),
  grsvalord        VARCHAR2(100),
  "/BIC/ZAMK0011"  VARCHAR2(100),
  "/BIC/ZAMK0010"  VARCHAR2(100),
  "/BIC/ZCRMK006"  VARCHAR2(100),
  "/BIC/ZCRMK007"  VARCHAR2(100),
  "/BIC/ZCRMK009"  VARCHAR2(100),
  crm_srvkb        VARCHAR2(100),
  "/BIC/ZCRMK003"  VARCHAR2(100),
  "/BIC/ZCRMK004"  VARCHAR2(100),
  "/BIC/ZCRMK005"  VARCHAR2(100),
  "/BIC/ZYF_PAY"   VARCHAR2(100),
  "/BIC/ZXY_PAY"   VARCHAR2(100),
  "/BIC/ZNPT_ATM"  VARCHAR2(100),
  crm_numofi       VARCHAR2(100),
  "/BIC/ZAMK0024"  VARCHAR2(100),
  "/BIC/ZCRMK008"  VARCHAR2(100),
  sales_unit       VARCHAR2(100),
  currency         VARCHAR2(100),
  crm_curren       VARCHAR2(100),
  "/BIC/ZCRMD031"  VARCHAR2(100),
  "/BIC/ZEHRC012"  VARCHAR2(100),
  "/BIC/ZCRMD048"  VARCHAR2(100),
  "/BIC/ZCRMD086"  VARCHAR2(100),
  "/BIC/ZCRMD019"  VARCHAR2(100),
  "/BIC/ZTHRC027"  VARCHAR2(100),
  "/BIC/ZTHRC026"  VARCHAR2(100),
  "/BIC/ZTHRC025"  VARCHAR2(100),
  "/BIC/ZTCRMC11"  VARCHAR2(100),
  "/BIC/ZCRMD199"  VARCHAR2(100),
  "/BIC/ZTLEC001"  VARCHAR2(100),
  "/BIC/ZCONDK001" VARCHAR2(100),
  "/BIC/ZCRMD120"  VARCHAR2(100),
  changed_by       VARCHAR2(100),
  "/BIC/ZMATER2"   VARCHAR2(100),
  "/BIC/ZZTRANSF"  VARCHAR2(100),
  "/BIC/ZTMSTAMP"  VARCHAR2(100)
)
tablespace ODSDATA01
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 8K
    minextents 1
    maxextents unlimited
  );
-- Add comments to the table 
comment on table SAP_BIC_AZTCRD00100
  is 'CRM������';
-- Add comments to the columns 
comment on column SAP_BIC_AZTCRD00100.crm_obj_id
  is '���ױ��';
comment on column SAP_BIC_AZTCRD00100.crm_numint
  is '��Ŀ��Ŷ���ƾ֤';
comment on column SAP_BIC_AZTCRD00100.recordmode
  is '����ģʽ';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZEAMC008"
  is 'ɾ�����';
comment on column SAP_BIC_AZTCRD00100.crm_ohguid
  is 'GUID CRM��������';
comment on column SAP_BIC_AZTCRD00100.crm_itmgui
  is 'CRM��Ŀȫ��Ψһ��ʶ';
comment on column SAP_BIC_AZTCRD00100.crm_prctyp
  is 'ҵ��������';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZCRMD023"
  is '�ϼ���Ŀ���';
comment on column SAP_BIC_AZTCRD00100.crm_itmtyp
  is '��Ŀ��������';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZTCMC002"
  is 'CRM�ο�������';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZTCMC006"
  is 'CRM�ο�������';
comment on column SAP_BIC_AZTCRD00100.salesorg
  is '������֯';
comment on column SAP_BIC_AZTCRD00100.distr_chan
  is '��������';
comment on column SAP_BIC_AZTCRD00100.sales_off
  is '���۰칫��';
comment on column SAP_BIC_AZTCRD00100.division
  is '����';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZMATERIAL"
  is '��Ʒ';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZEAMC027"
  is 'Ա��-MD';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZLIFNR"
  is '������Ʒ�Ĺ�Ӧ��';
comment on column SAP_BIC_AZTCRD00100.crm_endcst
  is '�ն˿ͻ�';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZTCMC016"
  is '��Ա�ȼ�';
comment on column SAP_BIC_AZTCRD00100.age
  is '�����ʾ������';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZTCMC020"
  is '�ļ���ַ_�����';
comment on column SAP_BIC_AZTCRD00100.crm_soldto
  is '�۴﷽';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZKUNNR_L1"
  is '�����ͻ���һ�㣨ͨ·��';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZKUNNR_L2"
  is '�����ͻ��ڶ��㣨��ͨ·��';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZTHRC015"
  is 'HR��������';
comment on column SAP_BIC_AZTCRD00100.bp_emplo
  is '����Ա����BP��';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZTHRC016"
  is 'HR��������';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZTHRC017"
  is 'HR��������';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZESDC113"
  is '���ڣ��ַ���';
comment on column SAP_BIC_AZTCRD00100.crmpostdat
  is '��������';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZPST_TIM"
  is '����ʱ��';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZGZ_TIME"
  is '����ʱ������Զ��壩';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZCRMD001"
  is '����״̬����������';
comment on column SAP_BIC_AZTCRD00100.crm_usstat
  is '�û�״̬';
comment on column SAP_BIC_AZTCRD00100.crm_stsma
  is '״̬�����ļ�';
comment on column SAP_BIC_AZTCRD00100.crm_ctd_by
  is '���񴴽���';
comment on column SAP_BIC_AZTCRD00100.crm_crd_at
  is '��������';
comment on column SAP_BIC_AZTCRD00100.crea_time
  is 'ʱ��';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZEAMC001"
  is '��Ԫ���';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZEAMC010"
  is 'ֱ��/�ز�';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZEAMC011"
  is '��Ԫ��ʼ����';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZEAMC012"
  is '��Ԫ��������';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZEAMC037"
  is '��Ԫ��ʼʱ��';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZEAMC013"
  is '��Ԫ��ʼʱ��';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZEAMC014"
  is '��Ԫ����ʱ��';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZTCMC021"
  is '�������˻���ȡ������';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZTCMC022"
  is '�������˻���ȡ��ʱ��';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZTCMC027"
  is '�ο�����ʱ��';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZTCMC026"
  is '�ο���������';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZTCMC030"
  is '�ο�����Ա��';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZTCMC007"
  is '��ʾ������ȡ��/�˻�/����';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZTCMC008"
  is '�˻�����';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZTCMC009"
  is '��������';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZTCMC023"
  is '����״̬';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZTCMC024"
  is 'һ��ԭ��';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZTCMC025"
  is '����ԭ��';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZCRMD015"
  is '������ʶ';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZCRMD016"
  is 'IVR��ʶ';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZCRMD017"
  is '����֧��״̬';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZCRMD018"
  is '������Դ';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZCR_ON"
  is '����ʱ���';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZOBJ_CC"
  is '������ţ�CRM��';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZDSXD"
  is '��ʱ�µ�ʱ������Զ��壩';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZJSJF_YN"
  is '��ʾ���Ѽ������';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZCRMD025"
  is 'Ԥ����ʱ���';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZCRMD020"
  is '��ȯ���ţ�CRM��';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZCRMD021"
  is '��ʾ���������⿨���Զ���ֵ';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZTCRMC01"
  is 'CRM�������ڣ�Ȩ���ƣ�';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZTCRMC02"
  is 'CRM����ʱ�����Ȩ���ƣ�';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZTCRMC03"
  is 'CRM���������ַ���Ȩ���ƣ�';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZTCRMC04"
  is 'CRM������ţ�Ȩ���ƣ�';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZTCRMC05"
  is 'CRM����������Ŀ��Ȩ���ƣ�';
comment on column SAP_BIC_AZTCRD00100.unit
  is '������λ';
comment on column SAP_BIC_AZTCRD00100.netvalord
  is '��������ֵ';
comment on column SAP_BIC_AZTCRD00100.crm_taxamo
  is '˰���';
comment on column SAP_BIC_AZTCRD00100.grsvalord
  is '��ֵ';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZAMK0011"
  is '�������';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZAMK0010"
  is '��������';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZCRMK006"
  is '�ۿ۽��';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZCRMK007"
  is 'ȯ���';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZCRMK009"
  is '�ۼ۽��';
comment on column SAP_BIC_AZTCRD00100.crm_srvkb
  is '�ɱ������';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZCRMK003"
  is 'Ӧ�����';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZCRMK004"
  is '�Ѹ����';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZCRMK005"
  is 'ʹ�û���';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZYF_PAY"
  is 'Ԥ������';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZXY_PAY"
  is '���⿨֧�����';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZNPT_ATM"
  is '���ƻ��ֽ��';
comment on column SAP_BIC_AZTCRD00100.crm_numofi
  is 'ƾ֤��Ŀ��';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZAMK0024"
  is '��Ŀ��Ԫ�ӳ�ʱ��';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZCRMK008"
  is '�ɹ��۸񣨳ɱ��ۣ�';
comment on column SAP_BIC_AZTCRD00100.sales_unit
  is '���۵�Ԫ';
comment on column SAP_BIC_AZTCRD00100.currency
  is '����';
comment on column SAP_BIC_AZTCRD00100.crm_curren
  is '����';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZCRMD031"
  is 'ҵ�������ͣ�Ȩ���ƣ�';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZEHRC012"
  is '��ʷ��¼��־';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZCRMD048"
  is 'ԭ������Ŀ��������(TAN��Ʒ,TANN��Ʒ,REN��Ʒ�˻�,RENN��Ʒ�˻�)';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZCRMD086"
  is '400�������';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZCRMD019"
  is '�����ص㣨CRM��';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZTHRC027"
  is 'ԭHR��������';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZTHRC026"
  is 'ԭHR��������';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZTHRC025"
  is 'ԭHR��������';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZTCRMC11"
  is 'ԭ����_TM';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZCRMD199"
  is 'Ԥ������־';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZTLEC001"
  is '�ֿ�';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZCONDK001"
  is '����-����ֵ';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZCRMD120"
  is 'CPS�����̱��';
comment on column SAP_BIC_AZTCRD00100.changed_by
  is '������';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZMATER2"
  is '��Ӧ����ĸƷ';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZZTRANSF"
  is '��ʾ���������ͱ��';
comment on column SAP_BIC_AZTCRD00100."/BIC/ZTMSTAMP"
  is 'ʱ������Զ��壩';
-- Create/Recreate indexes 
create index IDX_SAP_BIC_ZTCRMC02 on SAP_BIC_AZTCRD00100 ("/BIC/ZTCRMC02")
  tablespace ODSINDEX01
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
create index SAP_AZTCRD001_01_TP_CRMPOSTDAT on SAP_BIC_AZTCRD00100 (CRMPOSTDAT)
  tablespace ODSINDEX01
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
create index SAP_AZTCRD001_01_TP_ITEM on SAP_BIC_AZTCRD00100 ("/BIC/ZMATERIAL")
  tablespace ODSINDEX01
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
create index SAP_AZTCRD001_01_TP_ZTCMC021 on SAP_BIC_AZTCRD00100 ("/BIC/ZTCMC021")
  tablespace ODSINDEX01
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
create index SAP_AZTCRD001_01_TP_ZTCMC022 on SAP_BIC_AZTCRD00100 ("/BIC/ZTCMC022")
  tablespace ODSINDEX01
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
create index SAP_AZTCRD001_ZTCRMC04 on SAP_BIC_AZTCRD00100 ("/BIC/ZTCRMC04")
  tablespace ODSINDEX01
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
create index SAP_BIC_AZTCRD001_01_TP_ID on SAP_BIC_AZTCRD00100 (CRM_OBJ_ID)
  tablespace ODSINDEX01
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
create index SAP_BIC_ZKUNNR_L1 on SAP_BIC_AZTCRD00100 ("/BIC/ZKUNNR_L1")
  tablespace ODSINDEX01
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
create index SAP_BIC_ZTCRMC01_01 on SAP_BIC_AZTCRD00100 ("/BIC/ZTCRMC01")
  tablespace ODSINDEX01
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
-- Grant/Revoke object privileges 
grant select, index on SAP_BIC_AZTCRD00100 to dw_user with grant option;
/*grant select on SAP_BIC_AZTCRD00100 to BAS;
grant index on SAP_BIC_AZTCRD00100 to BAS with grant option;
grant select on SAP_BIC_AZTCRD00100 to BSP;
grant select, index on SAP_BIC_AZTCRD00100 to F_HYS with grant option;
grant select on SAP_BIC_AZTCRD00100 to F_SW with grant option;
grant select on SAP_BIC_AZTCRD00100 to F_TJ;
grant select on SAP_BIC_AZTCRD00100 to F_YB with grant option;
grant select on SAP_BIC_AZTCRD00100 to F_YW;
grant select on SAP_BIC_AZTCRD00100 to K_DS;
grant select on SAP_BIC_AZTCRD00100 to K_ZZS;*/
