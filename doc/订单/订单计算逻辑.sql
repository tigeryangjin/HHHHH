select *from ods_order;
select *from ods_order_cancel;

-- select *from ods_order; 退货
    if CRM_PRCTYP = 'ZB01'
      and ( ZTCMC008  = '10'  "上门回收
       OR ZTCMC008  = '30'    "用户回寄
       OR ZTCMC008  = '' )    "系统异常
    end if;
-- 拒收
    if CRM_PRCTYP = 'ZB01'
      and ZTCMC008  = '20'. "拒收退货
    end if;

-- 拒收、退货取消　 select *from ods_order_cancel; 
    if CRM_PRCTYP = 'ZB01'
      AND (  ZCRMD001 = 'ZR05'
       or  ZCRMD001 = 'ZR07' )  " 20141128 panlei
      and (  ZTCMC008  = '10'  "上门回收
       OR  ZTCMC008  = '30'    "用户回寄
       OR  ZTCMC008  = '' ).   "系统异常
    end if;       



select crm_obj_id,
       crm_prctyp,
       ZCRMD023,
       zmaterial,
       zeamc027,
       CRMPOSTDAT,
       ZTCMC008,
       ZCRMD001,
       ZAMK0011,
       CRM_USSTAT,
       CRM_STSMA
  from ods_order
 where crm_obj_id in ('5106239088', '5106239088', '5106239088', '5110557098',
        '5110557098', '5110557098', '5111230702');

select crm_obj_id,
       crm_prctyp,
       ZCRMD023,
       zmaterial,
       zeamc027,
       CRMPOSTDAT,
       ZTCMC008,
       ZCRMD001,
       ZAMK0011,
       CRM_USSTAT,
       CRM_STSMA
  from ods_order_cancel
 where crm_obj_id in ('5106239088', '5106239088', '5106239088', '5110557098',
        '5110557098', '5110557098', '5111230702');
