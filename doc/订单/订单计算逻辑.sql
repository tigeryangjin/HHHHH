select *from ods_order;
select *from ods_order_cancel;

-- select *from ods_order; �˻�
    if CRM_PRCTYP = 'ZB01'
      and ( ZTCMC008  = '10'  "���Ż���
       OR ZTCMC008  = '30'    "�û��ؼ�
       OR ZTCMC008  = '' )    "ϵͳ�쳣
    end if;
-- ����
    if CRM_PRCTYP = 'ZB01'
      and ZTCMC008  = '20'. "�����˻�
    end if;

-- ���ա��˻�ȡ���� select *from ods_order_cancel; 
    if CRM_PRCTYP = 'ZB01'
      AND (  ZCRMD001 = 'ZR05'
       or  ZCRMD001 = 'ZR07' )  " 20141128 panlei
      and (  ZTCMC008  = '10'  "���Ż���
       OR  ZTCMC008  = '30'    "�û��ؼ�
       OR  ZTCMC008  = '' ).   "ϵͳ�쳣
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
