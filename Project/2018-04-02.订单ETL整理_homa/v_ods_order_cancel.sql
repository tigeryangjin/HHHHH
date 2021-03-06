create or replace view v_ods_order_cancel as
Select "CRM_OBJ_ID"     As Crm_Obj_Id,
       "CRM_NUMINT"     As Crm_Numint,
       "RECORDMODE"     As Recordmode,
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
       "/BIC/ZTCMC021"  As Zesdc113,
       "/BIC/ZTCMC021"  As Crmpostdat,
       "/BIC/ZTCMC022"  As Zpst_Tim,
       "/BIC/ZTCMC021"||"/BIC/ZTCMC022"  As Zgz_Time,
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
       "UNIT"           As Unit,
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
       "/BIC/ZTLEC001"  As Ztlec001,
       "/BIC/ZCONDK001" As Zcondk001,
       "/BIC/ZCRMD120"  As Zcrmd120,
       "/BIC/ZMATER2"   As Zmater2,
       "/BIC/ZZTRANSF"  As Zztransf
  From Sap_Bic_Aztcrd00100 a
