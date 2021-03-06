SELECT a.crm_obj_id,
       a.crm_numint,
       a.zeamc008,
       a.crm_ohguid,
       a.crm_itmgui,
       a.crm_prctyp,
       a.zcrmd023,
       a.crm_itmtyp,
       a.ztcmc002,
       a.ztcmc006,
       a.salesorg,
       a.distr_chan,
       a.sales_off,
       a.division,
       a.zmaterial,
       a.zeamc027,
       a.zlifnr,
       a.crm_endcst,
       a.ztcmc016,
       a.age,
       a.ztcmc020,
       a.crm_soldto,
       a.zkunnr_l1,
       a.zkunnr_l2,
       a.zthrc015,
       a.bp_emplo,
       a.zthrc016,
       a.zthrc017,
       a.zesdc113,
       a.crmpostdat,
       a.zpst_tim,
       a.zgz_time,
       a.zcrmd001,
       a.crm_usstat,
       a.crm_stsma,
       a.crm_ctd_by,
       a.crm_crd_at,
       a.crea_time,
       a.zeamc001,
       a.zeamc010,
       a.zeamc011,
       a.zeamc012,
       a.zeamc037,
       a.zeamc013,
       a.zeamc014,
       a.ztcmc021,
       a.ztcmc022,
       a.ztcmc027,
       a.ztcmc026,
       a.ztcmc030,
       a.ztcmc007,
       a.ztcmc008,
       a.ztcmc009,
       a.ztcmc023,
       a.ztcmc024,
       a.ztcmc025,
       a.zcrmd015,
       a.zcrmd016,
       a.zcrmd017,
       a.zcrmd018,
       a.zcr_on,
       a.zobj_cc,
       a.zdsxd,
       a.zjsjf_yn,
       a.zcrmd025,
       a.zcrmd020,
       a.zcrmd021,
       a.ztcrmc01,
       a.ztcrmc02,
       a.ztcrmc03,
       a.ztcrmc04,
       a.ztcrmc05,
       a.netvalord,
       a.crm_taxamo,
       a.grsvalord,
       a.zamk0011,
       a.zamk0010,
       a.zcrmk006,
       a.zcrmk007,
       a.zcrmk009,
       a.crm_srvkb,
       a.zcrmk003,
       a.zcrmk004,
       a.zcrmk005,
       a.zyf_pay,
       a.zxy_pay,
       a.znpt_atm,
       a.crm_numofi,
       a.zamk0024,
       a.zcrmk008,
       a.sales_unit,
       a.currency,
       a.crm_curren,
       a.zcrmd031,
       a.zehrc012,
       a.zcrmd048,
       a.zcrmd086,
       a.zcrmd019,
       a.zthrc027,
       a.zthrc026,
       a.zthrc025,
       a.ztcrmc11,
       a.zcrmd199,
       a.ztlec001,
       a.zcondk001,
       a.zcrmd120,
       a.changed_by,
       a.zmater2,
       a.zztransf,
       a.ztmstamp
  FROM odshappigo.ods_order a
 where a.crmpostdat = 20180401
   and a.crm_obj_id = 5207583860;
Select "CRM_OBJ_ID" As Crm_Obj_Id,
       "CRM_NUMINT" As Crm_Numint,
       --"RECORDMODE"     As Recordmode,
       "/BIC/ZEAMC008"  As Zeamc008,
       "CRM_OHGUID"     As Crm_Ohguid,
       "CRM_ITMGUI"     As Crm_Itmgui,
       "CRM_PRCTYP"     As Crm_Prctyp,
       "/BIC/ZCRMD023"  As Zcrmd023,
       "CRM_ITMTYP"     As Crm_Itmtyp,
       "/BIC/ZTCMC002"  As Ztcmc002,
       "/BIC/ZTCMC006"  As Ztcmc006,
       "SALESORG"       As Salesorg,
       "DISTR_CHAN"     As Distr_Chan,
       "SALES_OFF"      As Sales_Off,
       "DIVISION"       As Division,
       "/BIC/ZMATERIAL" As Zmaterial,
       "/BIC/ZEAMC027"  As Zeamc027,
       "/BIC/ZLIFNR"    As Zlifnr,
       "CRM_ENDCST"     As Crm_Endcst,
       "/BIC/ZTCMC016"  As Ztcmc016,
       "AGE"            As Age,
       "/BIC/ZTCMC020"  As Ztcmc020,
       "CRM_SOLDTO"     As Crm_Soldto,
       "/BIC/ZKUNNR_L1" As Zkunnr_L1,
       "/BIC/ZKUNNR_L2" As Zkunnr_L2,
       "/BIC/ZTHRC015"  As Zthrc015,
       "BP_EMPLO"       As Bp_Emplo,
       "/BIC/ZTHRC016"  As Zthrc016,
       "/BIC/ZTHRC017"  As Zthrc017,
       "/BIC/ZESDC113"  As Zesdc113,
       Crmpostdat,
       "/BIC/ZPST_TIM"  As Zpst_Tim,
       "/BIC/ZGZ_TIME"  As Zgz_Time,
       "/BIC/ZCRMD001"  As Zcrmd001,
       "CRM_USSTAT"     As Crm_Usstat,
       "CRM_STSMA"      As Crm_Stsma,
       "CRM_CTD_BY"     As Crm_Ctd_By,
       "CRM_CRD_AT"     As Crm_Crd_At,
       "CREA_TIME"      As Crea_Time,
       "/BIC/ZEAMC001"  As Zeamc001,
       "/BIC/ZEAMC010"  As Zeamc010,
       "/BIC/ZEAMC011"  As Zeamc011,
       "/BIC/ZEAMC012"  As Zeamc012,
       "/BIC/ZEAMC037"  As Zeamc037,
       "/BIC/ZEAMC013"  As Zeamc013,
       "/BIC/ZEAMC014"  As Zeamc014,
       "/BIC/ZTCMC021"  As Ztcmc021,
       "/BIC/ZTCMC022"  As Ztcmc022,
       "/BIC/ZTCMC027"  As Ztcmc027,
       "/BIC/ZTCMC026"  As Ztcmc026,
       "/BIC/ZTCMC030"  As Ztcmc030,
       "/BIC/ZTCMC007"  As Ztcmc007,
       "/BIC/ZTCMC008"  As Ztcmc008,
       "/BIC/ZTCMC009"  As Ztcmc009,
       "/BIC/ZTCMC023"  As Ztcmc023,
       "/BIC/ZTCMC024"  As Ztcmc024,
       "/BIC/ZTCMC025"  As Ztcmc025,
       "/BIC/ZCRMD015"  As Zcrmd015,
       "/BIC/ZCRMD016"  As Zcrmd016,
       "/BIC/ZCRMD017"  As Zcrmd017,
       "/BIC/ZCRMD018"  As Zcrmd018,
       "/BIC/ZCR_ON"    As Zcr_On,
       "/BIC/ZOBJ_CC"   As Zobj_Cc,
       "/BIC/ZDSXD"     As Zdsxd,
       "/BIC/ZJSJF_YN"  As Zjsjf_Yn,
       "/BIC/ZCRMD025"  As Zcrmd025,
       "/BIC/ZCRMD020"  As Zcrmd020,
       "/BIC/ZCRMD021"  As Zcrmd021,
       "/BIC/ZTCRMC01"  As Ztcrmc01,
       "/BIC/ZTCRMC02"  As Ztcrmc02,
       "/BIC/ZTCRMC03"  As Ztcrmc03,
       "/BIC/ZTCRMC04"  As Ztcrmc04,
       "/BIC/ZTCRMC05"  As Ztcrmc05,
       --"UNIT"           As Unit,
       "NETVALORD"      As Netvalord,
       "CRM_TAXAMO"     As Crm_Taxamo,
       "GRSVALORD"      As Grsvalord,
       "/BIC/ZAMK0011"  As Zamk0011,
       "/BIC/ZAMK0010"  As Zamk0010,
       "/BIC/ZCRMK006"  As Zcrmk006,
       "/BIC/ZCRMK007"  As Zcrmk007,
       "/BIC/ZCRMK009"  As Zcrmk009,
       "CRM_SRVKB"      As Crm_Srvkb,
       "/BIC/ZCRMK003"  As Zcrmk003,
       "/BIC/ZCRMK004"  As Zcrmk004,
       "/BIC/ZCRMK005"  As Zcrmk005,
       "/BIC/ZYF_PAY"   As Zyf_Pay,
       "/BIC/ZXY_PAY"   As Zxy_Pay,
       "/BIC/ZNPT_ATM"  As Znpt_Atm,
       "CRM_NUMOFI"     As Crm_Numofi,
       "/BIC/ZAMK0024"  As Zamk0024,
       "/BIC/ZCRMK008"  As Zcrmk008,
       "SALES_UNIT"     As Sales_Unit,
       "CURRENCY"       As Currency,
       "CRM_CURREN"     As Crm_Curren,
       "/BIC/ZCRMD031"  As Zcrmd031,
       "/BIC/ZEHRC012"  As Zehrc012,
       "/BIC/ZCRMD048"  As Zcrmd048,
       "/BIC/ZCRMD086"  As Zcrmd086,
       "/BIC/ZCRMD019"  As Zcrmd019,
       "/BIC/ZTHRC027"  As Zthrc027,
       "/BIC/ZTHRC026"  As Zthrc026,
       "/BIC/ZTHRC025"  As Zthrc025,
       "/BIC/ZTCRMC11"  As Ztcrmc11,
       "/BIC/ZCRMD199"  As Zcrmd199,
       "/BIC/ZTLEC001"  As Ztlec001,
       "/BIC/ZCONDK001" As Zcondk001,
       "/BIC/ZCRMD120"  As Zcrmd120,
       "CHANGED_BY"     As Changed_By,
       "/BIC/ZMATER2"   As Zmater2,
       "/BIC/ZZTRANSF"  As Zztransf,
       "/BIC/ZTMSTAMP"  As Ztmstamp
  From Sap_Bic_Aztcrd00100 a
 where Crmpostdat = date '2018-04-01'
   and a.crm_obj_id = 5207583860;

select LPAD(B.ITEM_CODE ||
            DECODE(B.UNIT_CODE, '999', '', B.UNIT_CODE),
            18,
            '0') PRODUCT_ID,
       B.ITEM_CODE,
       B.UNIT_CODE
  from od_order_item b;
