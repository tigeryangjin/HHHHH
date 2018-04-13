--1.
select *
  from (select a1.*
          from odshappigo.ods_order a1
         where a1.crmpostdat = 20180401) a,
       (select "CRM_OBJ_ID" as crm_obj_id,
               "CRM_NUMINT" as crm_numint,
               --"RECORDMODE"     as recordmode,
               "/BIC/ZEAMC008"  as zeamc008,
               "CRM_OHGUID"     as crm_ohguid,
               "CRM_ITMGUI"     as crm_itmgui,
               "CRM_PRCTYP"     as crm_prctyp,
               "/BIC/ZCRMD023"  as zcrmd023,
               "CRM_ITMTYP"     as crm_itmtyp,
               "/BIC/ZTCMC002"  as ztcmc002,
               "/BIC/ZTCMC006"  as ztcmc006,
               "SALESORG"       as salesorg,
               "DISTR_CHAN"     as distr_chan,
               "SALES_OFF"      as sales_off,
               "DIVISION"       as division,
               "/BIC/ZMATERIAL" as zmaterial,
               "/BIC/ZEAMC027"  as zeamc027,
               "/BIC/ZLIFNR"    as zlifnr,
               "CRM_ENDCST"     as crm_endcst,
               "/BIC/ZTCMC016"  as ztcmc016,
               "AGE"            as age,
               "/BIC/ZTCMC020"  as ztcmc020,
               "CRM_SOLDTO"     as crm_soldto,
               "/BIC/ZKUNNR_L1" as zkunnr_l1,
               "/BIC/ZKUNNR_L2" as zkunnr_l2,
               "/BIC/ZTHRC015"  as zthrc015,
               "BP_EMPLO"       as bp_emplo,
               "/BIC/ZTHRC016"  as zthrc016,
               "/BIC/ZTHRC017"  as zthrc017,
               "/BIC/ZESDC113"  as zesdc113,
               crmpostdat,
               "/BIC/ZPST_TIM"  as zpst_tim,
               "/BIC/ZGZ_TIME"  as zgz_time,
               "/BIC/ZCRMD001"  as zcrmd001,
               "CRM_USSTAT"     as crm_usstat,
               "CRM_STSMA"      as crm_stsma,
               "CRM_CTD_BY"     as crm_ctd_by,
               "CRM_CRD_AT"     as crm_crd_at,
               "CREA_TIME"      as crea_time,
               "/BIC/ZEAMC001"  as zeamc001,
               "/BIC/ZEAMC010"  as zeamc010,
               "/BIC/ZEAMC011"  as zeamc011,
               "/BIC/ZEAMC012"  as zeamc012,
               "/BIC/ZEAMC037"  as zeamc037,
               "/BIC/ZEAMC013"  as zeamc013,
               "/BIC/ZEAMC014"  as zeamc014,
               "/BIC/ZTCMC021"  as ztcmc021,
               "/BIC/ZTCMC022"  as ztcmc022,
               "/BIC/ZTCMC027"  as ztcmc027,
               "/BIC/ZTCMC026"  as ztcmc026,
               "/BIC/ZTCMC030"  as ztcmc030,
               "/BIC/ZTCMC007"  as ztcmc007,
               "/BIC/ZTCMC008"  as ztcmc008,
               "/BIC/ZTCMC009"  as ztcmc009,
               "/BIC/ZTCMC023"  as ztcmc023,
               "/BIC/ZTCMC024"  as ztcmc024,
               "/BIC/ZTCMC025"  as ztcmc025,
               "/BIC/ZCRMD015"  as zcrmd015,
               "/BIC/ZCRMD016"  as zcrmd016,
               "/BIC/ZCRMD017"  as zcrmd017,
               "/BIC/ZCRMD018"  as zcrmd018,
               "/BIC/ZCR_ON"    as zcr_on,
               "/BIC/ZOBJ_CC"   as zobj_cc,
               "/BIC/ZDSXD"     as zdsxd,
               "/BIC/ZJSJF_YN"  as zjsjf_yn,
               "/BIC/ZCRMD025"  as zcrmd025,
               "/BIC/ZCRMD020"  as zcrmd020,
               "/BIC/ZCRMD021"  as zcrmd021,
               "/BIC/ZTCRMC01"  as ztcrmc01,
               "/BIC/ZTCRMC02"  as ztcrmc02,
               "/BIC/ZTCRMC03"  as ztcrmc03,
               "/BIC/ZTCRMC04"  as ztcrmc04,
               "/BIC/ZTCRMC05"  as ztcrmc05,
               --"UNIT"           as unit,
               "NETVALORD"      as netvalord,
               "CRM_TAXAMO"     as crm_taxamo,
               "GRSVALORD"      as grsvalord,
               "/BIC/ZAMK0011"  as zamk0011,
               "/BIC/ZAMK0010"  as zamk0010,
               "/BIC/ZCRMK006"  as zcrmk006,
               "/BIC/ZCRMK007"  as zcrmk007,
               "/BIC/ZCRMK009"  as zcrmk009,
               "CRM_SRVKB"      as crm_srvkb,
               "/BIC/ZCRMK003"  as zcrmk003,
               "/BIC/ZCRMK004"  as zcrmk004,
               "/BIC/ZCRMK005"  as zcrmk005,
               "/BIC/ZYF_PAY"   as zyf_pay,
               "/BIC/ZXY_PAY"   as zxy_pay,
               "/BIC/ZNPT_ATM"  as znpt_atm,
               "CRM_NUMOFI"     as crm_numofi,
               "/BIC/ZAMK0024"  as zamk0024,
               "/BIC/ZCRMK008"  as zcrmk008,
               "SALES_UNIT"     as sales_unit,
               "CURRENCY"       as currency,
               "CRM_CURREN"     as crm_curren,
               "/BIC/ZCRMD031"  as zcrmd031,
               "/BIC/ZEHRC012"  as zehrc012,
               "/BIC/ZCRMD048"  as zcrmd048,
               "/BIC/ZCRMD086"  as zcrmd086,
               "/BIC/ZCRMD019"  as zcrmd019,
               "/BIC/ZTHRC027"  as zthrc027,
               "/BIC/ZTHRC026"  as zthrc026,
               "/BIC/ZTHRC025"  as zthrc025,
               "/BIC/ZTCRMC11"  as ztcrmc11,
               "/BIC/ZCRMD199"  as zcrmd199,
               "/BIC/ZTLEC001"  as ztlec001,
               "/BIC/ZCONDK001" as zcondk001,
               "/BIC/ZCRMD120"  as zcrmd120,
               "CHANGED_BY"     as changed_by,
               "/BIC/ZMATER2"   as zmater2,
               "/BIC/ZZTRANSF"  as zztransf,
               "/BIC/ZTMSTAMP"  as ztmstamp
          from sap_bic_aztcrd00100 a
         where crmpostdat = date '2018-04-01') b
 where a.crm_obj_id = b.crm_obj_id
   and a.crm_numint = b.crm_numint
   and (a.crm_numint <> b.crm_numint or a.zeamc008 <> b.zeamc008 or
       a.crm_ohguid <> b.crm_ohguid or a.crm_itmgui <> b.crm_itmgui or
       a.crm_prctyp <> b.crm_prctyp or a.zcrmd023 <> b.zcrmd023 or
       a.crm_itmtyp <> b.crm_itmtyp or a.ztcmc002 <> b.ztcmc002 or
       a.ztcmc006 <> b.ztcmc006 or a.salesorg <> b.salesorg or
       a.distr_chan <> b.distr_chan or a.sales_off <> b.sales_off or
       a.division <> b.division or a.zmaterial <> b.zmaterial or
       a.zeamc027 <> b.zeamc027 or a.zlifnr <> b.zlifnr or
       a.crm_endcst <> b.crm_endcst or a.ztcmc016 <> b.ztcmc016 or
       a.age <> b.age or a.ztcmc020 <> b.ztcmc020 or
       a.crm_soldto <> b.crm_soldto or a.zkunnr_l1 <> b.zkunnr_l1 or
       a.zkunnr_l2 <> b.zkunnr_l2 or a.zthrc015 <> b.zthrc015 or
       a.bp_emplo <> b.bp_emplo or a.zthrc016 <> b.zthrc016 or
       a.zthrc017 <> b.zthrc017 or a.zesdc113 <> b.zesdc113 or
       a.crmpostdat <> b.crmpostdat or a.zpst_tim <> b.zpst_tim or
       a.zgz_time <> b.zgz_time or a.zcrmd001 <> b.zcrmd001 or
       a.crm_usstat <> b.crm_usstat or a.crm_stsma <> b.crm_stsma or
       a.crm_ctd_by <> b.crm_ctd_by or a.crm_crd_at <> b.crm_crd_at or
       a.crea_time <> b.crea_time or a.zeamc001 <> b.zeamc001 or
       a.zeamc010 <> b.zeamc010 or a.zeamc011 <> b.zeamc011 or
       a.zeamc012 <> b.zeamc012 or a.zeamc037 <> b.zeamc037 or
       a.zeamc013 <> b.zeamc013 or a.zeamc014 <> b.zeamc014 or
       a.ztcmc021 <> b.ztcmc021 or a.ztcmc022 <> b.ztcmc022 or
       a.ztcmc027 <> b.ztcmc027 or a.ztcmc026 <> b.ztcmc026 or
       a.ztcmc030 <> b.ztcmc030 or a.ztcmc007 <> b.ztcmc007 or
       a.ztcmc008 <> b.ztcmc008 or a.ztcmc009 <> b.ztcmc009 or
       a.ztcmc023 <> b.ztcmc023 or a.ztcmc024 <> b.ztcmc024 or
       a.ztcmc025 <> b.ztcmc025 or a.zcrmd015 <> b.zcrmd015 or
       a.zcrmd016 <> b.zcrmd016 or a.zcrmd017 <> b.zcrmd017 or
       a.zcrmd018 <> b.zcrmd018 or a.zcr_on <> b.zcr_on or
       a.zobj_cc <> b.zobj_cc or a.zdsxd <> b.zdsxd or
       a.zjsjf_yn <> b.zjsjf_yn or a.zcrmd025 <> b.zcrmd025 or
       a.zcrmd020 <> b.zcrmd020 or a.zcrmd021 <> b.zcrmd021 or
       a.ztcrmc01 <> b.ztcrmc01 or a.ztcrmc02 <> b.ztcrmc02 or
       a.ztcrmc03 <> b.ztcrmc03 or a.ztcrmc04 <> b.ztcrmc04 or
       a.ztcrmc05 <> b.ztcrmc05 or a.netvalord <> b.netvalord or
       a.crm_taxamo <> b.crm_taxamo or a.grsvalord <> b.grsvalord or
       a.zamk0011 <> b.zamk0011 or a.zamk0010 <> b.zamk0010 or
       a.zcrmk006 <> b.zcrmk006 or a.zcrmk007 <> b.zcrmk007 or
       a.zcrmk009 <> b.zcrmk009 or a.crm_srvkb <> b.crm_srvkb or
       a.zcrmk003 <> b.zcrmk003 or a.zcrmk004 <> b.zcrmk004 or
       a.zcrmk005 <> b.zcrmk005 or a.zyf_pay <> b.zyf_pay or
       a.zxy_pay <> b.zxy_pay or a.znpt_atm <> b.znpt_atm or
       a.crm_numofi <> b.crm_numofi or a.zamk0024 <> b.zamk0024 or
       a.zcrmk008 <> b.zcrmk008 or a.sales_unit <> b.sales_unit or
       a.currency <> b.currency or a.crm_curren <> b.crm_curren or
       a.zcrmd031 <> b.zcrmd031 or a.zehrc012 <> b.zehrc012 or
       a.zcrmd048 <> b.zcrmd048 or a.zcrmd086 <> b.zcrmd086 or
       a.zcrmd019 <> b.zcrmd019 or a.zthrc027 <> b.zthrc027 or
       a.zthrc026 <> b.zthrc026 or a.zthrc025 <> b.zthrc025 or
       a.ztcrmc11 <> b.ztcrmc11 or a.zcrmd199 <> b.zcrmd199 or
       a.ztlec001 <> b.ztlec001 or a.zcondk001 <> b.zcondk001 or
       a.zcrmd120 <> b.zcrmd120 or a.changed_by <> b.changed_by or
       a.zmater2 <> b.zmater2 or a.zztransf <> b.zztransf or
       a.ztmstamp <> b.ztmstamp)
   and a.crm_obj_id = 5207577794;

--2.

select *
  from (select a1.*
          from odshappigo.ods_order a1
         where a1.crmpostdat = 20180401) a,
       (select "CRM_OBJ_ID" as crm_obj_id,
               "CRM_NUMINT" as crm_numint,
               --"RECORDMODE"     as recordmode,
               "/BIC/ZEAMC008"  as zeamc008,
               "CRM_OHGUID"     as crm_ohguid,
               "CRM_ITMGUI"     as crm_itmgui,
               "CRM_PRCTYP"     as crm_prctyp,
               "/BIC/ZCRMD023"  as zcrmd023,
               "CRM_ITMTYP"     as crm_itmtyp,
               "/BIC/ZTCMC002"  as ztcmc002,
               "/BIC/ZTCMC006"  as ztcmc006,
               "SALESORG"       as salesorg,
               "DISTR_CHAN"     as distr_chan,
               "SALES_OFF"      as sales_off,
               "DIVISION"       as division,
               "/BIC/ZMATERIAL" as zmaterial,
               "/BIC/ZEAMC027"  as zeamc027,
               "/BIC/ZLIFNR"    as zlifnr,
               "CRM_ENDCST"     as crm_endcst,
               "/BIC/ZTCMC016"  as ztcmc016,
               "AGE"            as age,
               "/BIC/ZTCMC020"  as ztcmc020,
               "CRM_SOLDTO"     as crm_soldto,
               "/BIC/ZKUNNR_L1" as zkunnr_l1,
               "/BIC/ZKUNNR_L2" as zkunnr_l2,
               "/BIC/ZTHRC015"  as zthrc015,
               "BP_EMPLO"       as bp_emplo,
               "/BIC/ZTHRC016"  as zthrc016,
               "/BIC/ZTHRC017"  as zthrc017,
               "/BIC/ZESDC113"  as zesdc113,
               crmpostdat,
               "/BIC/ZPST_TIM"  as zpst_tim,
               "/BIC/ZGZ_TIME"  as zgz_time,
               "/BIC/ZCRMD001"  as zcrmd001,
               "CRM_USSTAT"     as crm_usstat,
               "CRM_STSMA"      as crm_stsma,
               "CRM_CTD_BY"     as crm_ctd_by,
               "CRM_CRD_AT"     as crm_crd_at,
               "CREA_TIME"      as crea_time,
               "/BIC/ZEAMC001"  as zeamc001,
               "/BIC/ZEAMC010"  as zeamc010,
               "/BIC/ZEAMC011"  as zeamc011,
               "/BIC/ZEAMC012"  as zeamc012,
               "/BIC/ZEAMC037"  as zeamc037,
               "/BIC/ZEAMC013"  as zeamc013,
               "/BIC/ZEAMC014"  as zeamc014,
               "/BIC/ZTCMC021"  as ztcmc021,
               "/BIC/ZTCMC022"  as ztcmc022,
               "/BIC/ZTCMC027"  as ztcmc027,
               "/BIC/ZTCMC026"  as ztcmc026,
               "/BIC/ZTCMC030"  as ztcmc030,
               "/BIC/ZTCMC007"  as ztcmc007,
               "/BIC/ZTCMC008"  as ztcmc008,
               "/BIC/ZTCMC009"  as ztcmc009,
               "/BIC/ZTCMC023"  as ztcmc023,
               "/BIC/ZTCMC024"  as ztcmc024,
               "/BIC/ZTCMC025"  as ztcmc025,
               "/BIC/ZCRMD015"  as zcrmd015,
               "/BIC/ZCRMD016"  as zcrmd016,
               "/BIC/ZCRMD017"  as zcrmd017,
               "/BIC/ZCRMD018"  as zcrmd018,
               "/BIC/ZCR_ON"    as zcr_on,
               "/BIC/ZOBJ_CC"   as zobj_cc,
               "/BIC/ZDSXD"     as zdsxd,
               "/BIC/ZJSJF_YN"  as zjsjf_yn,
               "/BIC/ZCRMD025"  as zcrmd025,
               "/BIC/ZCRMD020"  as zcrmd020,
               "/BIC/ZCRMD021"  as zcrmd021,
               "/BIC/ZTCRMC01"  as ztcrmc01,
               "/BIC/ZTCRMC02"  as ztcrmc02,
               "/BIC/ZTCRMC03"  as ztcrmc03,
               "/BIC/ZTCRMC04"  as ztcrmc04,
               "/BIC/ZTCRMC05"  as ztcrmc05,
               --"UNIT"           as unit,
               "NETVALORD"      as netvalord,
               "CRM_TAXAMO"     as crm_taxamo,
               "GRSVALORD"      as grsvalord,
               "/BIC/ZAMK0011"  as zamk0011,
               "/BIC/ZAMK0010"  as zamk0010,
               "/BIC/ZCRMK006"  as zcrmk006,
               "/BIC/ZCRMK007"  as zcrmk007,
               "/BIC/ZCRMK009"  as zcrmk009,
               "CRM_SRVKB"      as crm_srvkb,
               "/BIC/ZCRMK003"  as zcrmk003,
               "/BIC/ZCRMK004"  as zcrmk004,
               "/BIC/ZCRMK005"  as zcrmk005,
               "/BIC/ZYF_PAY"   as zyf_pay,
               "/BIC/ZXY_PAY"   as zxy_pay,
               "/BIC/ZNPT_ATM"  as znpt_atm,
               "CRM_NUMOFI"     as crm_numofi,
               "/BIC/ZAMK0024"  as zamk0024,
               "/BIC/ZCRMK008"  as zcrmk008,
               "SALES_UNIT"     as sales_unit,
               "CURRENCY"       as currency,
               "CRM_CURREN"     as crm_curren,
               "/BIC/ZCRMD031"  as zcrmd031,
               "/BIC/ZEHRC012"  as zehrc012,
               "/BIC/ZCRMD048"  as zcrmd048,
               "/BIC/ZCRMD086"  as zcrmd086,
               "/BIC/ZCRMD019"  as zcrmd019,
               "/BIC/ZTHRC027"  as zthrc027,
               "/BIC/ZTHRC026"  as zthrc026,
               "/BIC/ZTHRC025"  as zthrc025,
               "/BIC/ZTCRMC11"  as ztcrmc11,
               "/BIC/ZCRMD199"  as zcrmd199,
               "/BIC/ZTLEC001"  as ztlec001,
               "/BIC/ZCONDK001" as zcondk001,
               "/BIC/ZCRMD120"  as zcrmd120,
               "CHANGED_BY"     as changed_by,
               "/BIC/ZMATER2"   as zmater2,
               "/BIC/ZZTRANSF"  as zztransf,
               "/BIC/ZTMSTAMP"  as ztmstamp
          from sap_bic_aztcrd00100 a
         where crmpostdat = date '2018-04-01') b
 where a.crm_obj_id = b.crm_obj_id
   and a.crm_numint = b.crm_numint
   and (a.crm_numint <> b.crm_numint or a.zeamc008 <> b.zeamc008 or
       a.crm_ohguid <> b.crm_ohguid or a.crm_itmgui <> b.crm_itmgui or
       a.crm_prctyp <> b.crm_prctyp or a.zcrmd023 <> b.zcrmd023 or
       a.crm_itmtyp <> b.crm_itmtyp or a.ztcmc002 <> b.ztcmc002 or
       a.ztcmc006 <> b.ztcmc006 or a.salesorg <> b.salesorg or
       a.distr_chan <> b.distr_chan or a.sales_off <> b.sales_off or
       a.division <> b.division or a.zmaterial <> b.zmaterial or
       a.zeamc027 <> b.zeamc027 or a.zlifnr <> b.zlifnr or
       a.crm_endcst <> b.crm_endcst or a.ztcmc016 <> b.ztcmc016 /*or a.age <> b.age*/
       /*or a.ztcmc020 <> b.ztcmc020*/
       or a.crm_soldto <> b.crm_soldto or a.zkunnr_l1 <> b.zkunnr_l1 or
       a.zkunnr_l2 <> b.zkunnr_l2 /*or a.zthrc015 <> b.zthrc015*/
       or a.bp_emplo <> b.bp_emplo /*or a.zthrc016 <> b.zthrc016 or a.zthrc017 <> b.zthrc017*/
       or a.zesdc113 <> b.zesdc113 or a.crmpostdat <> b.crmpostdat or
       a.zpst_tim <> b.zpst_tim or a.zgz_time <> b.zgz_time /*or a.zcrmd001 <> b.zcrmd001*/
       or a.crm_usstat <> b.crm_usstat or a.crm_stsma <> b.crm_stsma or
       a.crm_ctd_by <> b.crm_ctd_by or a.crm_crd_at <> b.crm_crd_at or
       a.crea_time <> b.crea_time or a.zeamc001 <> b.zeamc001 or
       a.zeamc010 <> b.zeamc010 or a.zeamc011 <> b.zeamc011 or
       a.zeamc012 <> b.zeamc012 or a.zeamc037 <> b.zeamc037 or
       a.zeamc013 <> b.zeamc013 or a.zeamc014 <> b.zeamc014 /*or
                                     a.ztcmc021 <> b.ztcmc021*/
       or a.ztcmc022 <> b.ztcmc022 or a.ztcmc027 <> b.ztcmc027 or
       a.ztcmc026 <> b.ztcmc026 or a.ztcmc030 <> b.ztcmc030 or
       a.ztcmc007 <> b.ztcmc007 or a.ztcmc008 <> b.ztcmc008 or
       a.ztcmc009 <> b.ztcmc009 /*or a.ztcmc023 <> b.ztcmc023*/
       /*or a.ztcmc024 <> b.ztcmc024*/ /*or a.ztcmc025 <> b.ztcmc025*/
       or a.zcrmd015 <> b.zcrmd015 or a.zcrmd016 <> b.zcrmd016 or
       a.zcrmd017 <> b.zcrmd017 or a.zcrmd018 <> b.zcrmd018 or
       a.zcr_on <> b.zcr_on or a.zobj_cc <> b.zobj_cc or
       a.zdsxd <> b.zdsxd or a.zjsjf_yn <> b.zjsjf_yn /*or a.zcrmd025 <> b.zcrmd025*/
       or a.zcrmd020 <> b.zcrmd020 or a.zcrmd021 <> b.zcrmd021 or
       a.ztcrmc01 <> b.ztcrmc01 or a.ztcrmc02 <> b.ztcrmc02 or
       a.ztcrmc03 <> b.ztcrmc03 or a.ztcrmc04 <> b.ztcrmc04 or
       a.ztcrmc05 <> b.ztcrmc05 or a.netvalord <> b.netvalord or
       a.crm_taxamo <> b.crm_taxamo or a.grsvalord <> b.grsvalord or
       a.zamk0011 <> b.zamk0011 or a.zamk0010 <> b.zamk0010 or
       a.zcrmk006 <> b.zcrmk006 or a.zcrmk007 <> b.zcrmk007 or
       a.zcrmk009 <> b.zcrmk009 or a.crm_srvkb <> b.crm_srvkb or
       a.zcrmk003 <> b.zcrmk003 or a.zcrmk004 <> b.zcrmk004 or
       a.zcrmk005 <> b.zcrmk005 or a.zyf_pay <> b.zyf_pay or
       a.zxy_pay <> b.zxy_pay or a.znpt_atm <> b.znpt_atm or
       a.crm_numofi <> b.crm_numofi or a.zamk0024 <> b.zamk0024 or
       a.zcrmk008 <> b.zcrmk008 or a.sales_unit <> b.sales_unit or
       a.currency <> b.currency or a.crm_curren <> b.crm_curren or
       a.zcrmd031 <> b.zcrmd031 or a.zehrc012 <> b.zehrc012 or
       a.zcrmd048 <> b.zcrmd048 or a.zcrmd086 <> b.zcrmd086 or
       a.zcrmd019 <> b.zcrmd019 or a.zthrc027 <> b.zthrc027 or
       a.zthrc026 <> b.zthrc026 or a.zthrc025 <> b.zthrc025 or
       a.ztcrmc11 <> b.ztcrmc11 or a.zcrmd199 <> b.zcrmd199 /*or a.ztlec001 <> b.ztlec001*/
       or a.zcondk001 <> b.zcondk001 or a.zcrmd120 <> b.zcrmd120 or
       a.changed_by <> b.changed_by or a.zmater2 <> b.zmater2 or
       a.zztransf <> b.zztransf /*or a.ztmstamp <> b.ztmstamp*/
       );

--3.补全数据
DECLARE
  IN_DATE_INT NUMBER(8);
  IN_DATE     DATE;
  BEGIN_DATE  DATE := DATE '2018-04-01';
  END_DATE    DATE := DATE '2018-04-08';
BEGIN
  IN_DATE := BEGIN_DATE;
  WHILE IN_DATE <= END_DATE LOOP
    IN_DATE_INT := TO_CHAR(IN_DATE, 'YYYYMMDD');
    OD_ORDER_ETL.INSERT_MODIFY_TP(IN_DATE_INT);
    OD_ORDER_ETL.MERGE_SAP_BIC_AZTCRD00100;
    IN_DATE := IN_DATE + 1;
  END LOOP;
END;
/

--4.
/*
age     (以年表示的年龄)    (没有使用)--
zcrmd001(订购状态类型描述)  (使用)
zcrmd025(预定购时间戳)      (没有使用)
ztcmc020(四级地址编号)      (使用)
ztcmc021(交换(退货)取消日期)(没有使用)
ztcmc023(货物状态)          (没有使用)
ztcmc024(一级原因)          (使用)
ztcmc025(二级原因)          (使用)
zthrc015(HR所属部门)        (没有使用)--
zthrc016(HR所属班组)        (没有使用)--
zthrc017(HR所属处室)        (没有使用)--
ztlec001(仓库)              (没有使用)??
ztmstamp(定价-条件值)       (没有使用)
*/
select a.crmpostdat, a.crm_obj_id, a.crm_numint, a.zcrmd001, b.zcrmd001
  from ods_order a, v_ods_order b
 where a.crm_obj_id = b.crm_obj_id(+)
   and a.crm_numint = b.CRM_NUMINT(+)
   and nvl(a.zcrmd001, 0) <> nvl(b.zcrmd001, 0)
   and a.crmpostdat >= 20180401;

select distinct a.zcrmd001, b.zcrmd001
  from ods_order a, v_ods_order b
 where a.crm_obj_id = b.crm_obj_id
   and a.crm_numint = b.CRM_NUMINT
   and a.zcrmd001 <> b.zcrmd001;

--5.sh
/*
存储过程：
createordergoods
createfactordergoodsreverse
processupdateorder
processupdateorderreverse

ktr------------------------------------
createordergoods:
ktr/createfactordergoods.ktr
ktr/processorder.ktr

createfactordergoodsreverse:
ktr/processrejectreturn.ktr
ktr/createfactordergoodsreverse.ktr
ktr/processorder.ktr
job/createfactordergoods_dayly.kjb
job/createfactordergoodsreverse.kjb

processupdateorder:
ktr/processupdateorder.ktr
ktr/processorder.ktr
ktr/processupdateorderreverse.ktr
job/createfactordergoods_dayly.kjb

processupdateorderreverse:
ktr/processorder.ktr
ktr/processupdateorderreverse.ktr
job/createfactordergoods_dayly.kjb
ktr------------------------------------


*/


--tmp
select * from all_source a where lower(a.TEXT) like '%insert%fact_goods_sales%';
select * from ods_order a where a.crm_obj_id=5207688036;
select * from v_ods_order a where a.crm_obj_id=5207688036;
select * from sap_bic_aztcrd00100 a where a.crm_obj_id=5207688036;
select * from od_order a where a.crm_order_no=5207688036;
select * from od_order a where a.order_no=20180407648458;
select * from od_order_item a where a.ecc_order_no=5207688036;
select * from od_order a where a.or

select * from od_order a order by a.order_date desc;
