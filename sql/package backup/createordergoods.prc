create or replace procedure createordergoods(postday in number) is
  s_etl        w_etl_log%rowtype;
  sp_name      s_parameters2.pname%type;
  s_parameter  s_parameters1.parameter_value%type;
  insert_rows  number;
  crmpostdates number;
  /*total_nums   number;*/
  --endid number;
  --onetotal number;--һ��ȡ���ٸ�
  /*
  ����˵�����Զ������ݽ���������ȡ
       
  
  ����ʱ�䣺bobo  2016-04-06
  */

begin

  sp_name          := 'createordergoods'; --��Ҫ�ֹ�������дPROCEDURE������
  s_etl.table_name := 'FACT_ORDER'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı��
  s_etl.proc_name  := sp_name;
  s_etl.start_time := sysdate;
  s_parameter      := 0;
  --onetotal         := 50000; --һ��ȡ5000��¼ѭ��
  begin
    sp_parameter_two(sp_name, s_parameter);
    if s_parameter = '0'
    then
      s_etl.err_msg := 'û���ҵ���Ӧ�Ĺ��̼�����������';
      sp_sbi_w_etl_log(s_etl);
      return;
    end if;
  end;

  /*if postday>=20151231 then
     s_etl.err_msg := '�����������';
      sp_sbi_w_etl_log(s_etl);
      return;
  end if;*/

  if postday < 20050101
  then
    select max(posting_date_key) into crmpostdates from fact_ORDER; -- where CRM_CRD_AT=to_char(20140101);
  else
    crmpostdates := postday;
  end if;

  --��ɾ������
  delete from fact_ORDER
   where order_key in
         (select to_number(z.ZTCRMC04)
            from odshappigo.ods_order z
           where ((z.zcr_on >= to_char(crmpostdates * 1000000) and
                 z.zcr_on < to_char((crmpostdates + 1) * 1000000) and
                 z.crmpostdat < to_char(crmpostdates)) or
                 z.crmpostdat = to_char(crmpostdates))
             and z.CRM_PRCTYP in ('ZA01', 'ZA02', 'ZA03')
           group by z.ZTCRMC04);
  delete from fact_goods_sales
   where order_key in
         (select to_number(z.ZTCRMC04)
            from odshappigo.ods_order z
           where ((z.zcr_on >= to_char(crmpostdates * 1000000) and
                 z.zcr_on < to_char((crmpostdates + 1) * 1000000) and
                 z.crmpostdat < to_char(crmpostdates)) or
                 z.crmpostdat = to_char(crmpostdates))
             and z.CRM_PRCTYP in ('ZA01', 'ZA02', 'ZA03')
           group by z.ZTCRMC04);

  /*select count(1) into total_nums from fact_ORDER where POSTING_DATE_KEY=postday;
  if total_nums>0 then
     s_etl.err_msg := '�Ѿ�����������';
      sp_sbi_w_etl_log(s_etl);
      return;
  end if;*/

  --�Ȳ���������ʵ��
  insert into fact_goods_sales
    (SALES_GOODS_ID, --goods sku
     ORDER_KEY, --����Ȩ���Ʊ��
     ORDER_H_KEY, --���������Ʊ��
     ADDRESS_KEY, --�ļ���ַ���
     MEMBER_KEY, --��Ա���
     MEMBER_GRADE_DESC, --��Ա�ȼ�����
     MEMBER_GRADE_KEY, --��Ա�ȼ�key
     GOODS_KEY, --goods sku
     GOODS_COMMON_KEY, --goods spu
     TRAN_DESC, --ת������
     TRAN_TYPE, --0��Ʒ��1��Ʒ
     LIVE_STATE, --1��ֱ��
     REPLAY_STATE, --1���ز�
     WINDOW_ID, --������ʶ
     MD_PERSON, --md���
     SUPPLIER_KEY, --��Ӧ��key
     SUPPLIER_TITLE, --��Ӧ��key����
     UNIT_PRICE, --��Ʒ����
     DISCOUNT_PRICE, --������Ʒ�������
     BARGAIN_PRICE, --������Ʒ�ɽ��۸�
     NUMS, --����
     COST_PRICE, --������Ʒ�ɱ����
     PURCHASE_PRICE, --������Ʒ�ɹ��۸�
     COUPONS_PRICE, --ȯ���
     POINTS_REWARD, --����������
     Points_amount, --ʹ�û�����
     Points_total, --ʹ�û�����
     SALES_AMOUNT, --�����ܽ��
     ORDER_AMOUNT, --�����ܽ��
     ORDER_NET_AMOUNT, --���������
     PAY_AMOUNT, --Ӧ���ܽ��
     AMOUNT_PAID, --�Ѹ����
     PURCHASE_AMOUNT, --�ɹ��ܽ��
     PROFIT_AMOUNT, --ë���ܽ��
     TAX_AMOUNT, --˰�ս��
     Amount_advanced, --Ԥ������
     Card_amount, --���⿨���
     Points_no_amount, --���ǻ��ֽ��
     Freight_amount, --�˷ѽ��
     SALES_SOURCE_KEY,
     SALES_SOURCE_DESC, --����һ����֯
     SALES_SOURCE_SECOND_KEY,
     SALES_SOURCE_SECOND_DESC, --���۶�����֯
     ORDER_DATE_KEY, --����ʱ��
     ORDER_DATE,
     ORDER_HOUR_KEY,
     ORDER_HOUR,
     POSTING_DATE, --����ʱ��
     POSTING_DATE_KEY,
     POSTING_HOUR_KEY,
     POSTING_HOUR,
     order_desc, --����״̬��������
     Pre_order_state, --�Ƿ���Ԥ����
     ORDER_STATE, --�Ƿ�����Ч����
     CANCEL_STATE, --�Ƿ����˻�ȡ��ȡ��
     
     Cancel_before_state, --�Ƿ��Ƿ���ǰȡ��
     Cancel_nums,
     Cancel_date,
     Cancel_date_key,
     Cancel_hour_key,
     Cancel_hour,
     Cancel_date_first_key,
     Cancel_date_first,
     Cancel_date_last_key,
     Cancel_date_last,
     CANCEL_PERSON,
     Exchange_goods_state, --�Ƿ�ȡ��
     Exchange_goods_nums,
     Exchange_goods_date_key,
     Exchange_goods_date,
     Exchange_goods_hour_key,
     Exchange_goods_hour,
     Exchange_date_last_key,
     Exchange_date_last,
     Exchange_date_first_key,
     Exchange_date_first,
     cancel_total,
     Exchange_goods_total,
     UPDATE_TIME,
     ORDER_FROM)
    select to_number(z.ZMATERIAL) as SALES_GOODS_ID, --goods sku
           to_number(z.ZTCRMC04) as ORDER_KEY, --����Ȩ���Ʊ��
           to_number(z.crm_obj_id) as ORDER_H_KEY, --���������Ʊ��
           to_number(z.ZTCMC020) as ADDRESS_KEY, --�ļ���ַ���
           (case
             when nvl2(translate(replace(z.crm_endcst, '"', ''),
                                 '\0123456789',
                                 '\'),
                       0,
                       1) = 0 then
              0
             else
              to_number(replace(z.crm_endcst, '"', ''))
           end) as MEMBER_KEY, --��Ա���
           to_char(z.ZTCMC016) as MEMBER_GRADE_DESC, --��Ա�ȼ�����
           DECODE(z.ZTCMC016,
                  'HAPP_T0',
                  0,
                  'HAPP_T1',
                  1,
                  'HAPP_T2',
                  2,
                  'HAPP_T3',
                  3,
                  'HAPP_T4',
                  4,
                  'HAPP_T5',
                  5,
                  'HAPP_T6',
                  6,
                  -1) as MEMBER_GRADE_KEY,
           to_number(z.zmaterial) as GOODS_KEY, --goods sku
           to_number(z.zmater2) as GOODS_COMMON_KEY, --goods spu
           to_char(z.crm_itmtyp) as TRAN_DESC, --ת������
           decode(z.crm_itmtyp, 'TAN', 0, 'TANN', 1, -1) as TRAN_TYPE, --0��Ʒ��1��Ʒ
           decode(z.zeamc010, 'ZB', 1, 0) as LIVE_STATE, --1��ֱ��
           decode(z.zeamc010, 'CB', 1, 0) as REPLAY_STATE, --1���ز�
           to_char(z.ZCRMD015) as WINDOW_ID, --������ʶ
           to_number(z.ZEAMC027) as MD_PERSON, --md���
           to_number(z.ZLIFNR) as SUPPLIER_KEY, --��Ӧ��key
           to_number(z.ZLIFNR) as SUPPLIER_TITLE, --��Ӧ��key����
           (case
             when to_number(z.zamk0010) = 0 then
              to_number(z.zcrmk009)
             else
              to_number(z.zcrmk009 / z.zamk0010)
           end) as UNIT_PRICE,
           --to_number(z.zcrmk009/z.zamk0010) as UNIT_PRICE,--��Ʒ����
           (case
             when to_number(z.zamk0010) = 0 then
              to_number(z.zcrmk006)
             else
              to_number(z.zcrmk006 / z.zamk0010)
           end) as DISCOUNT_PRICE,
           --to_number(z.zcrmk006/z.zamk0010) as DISCOUNT_PRICE,--������Ʒ�������
           (case
             when to_number(z.zamk0010) = 0 then
              to_number(z.zamk0011)
             else
              to_number(z.zamk0011 / z.zamk0010)
           end) as BARGAIN_PRICE,
           --to_number(z.zamk0011/z.zamk0010) as BARGAIN_PRICE,--������Ʒ�ɽ��۸�
           z.zamk0010 as NUMS, --����
           (case
             when to_number(z.zamk0010) = 0 then
              to_number(z.crm_srvkb)
             else
              to_number(z.crm_srvkb / z.zamk0010)
           end) as COST_PRICE,
           --to_number(z.crm_srvkb/z.zamk0010) as COST_PRICE,--������Ʒ�ɱ����
           to_number(z.zcrmk008) as PURCHASE_PRICE, --������Ʒ�ɹ��۸�
           z.zcrmk007 as COUPONS_PRICE, --ȯ���
           0 as POINTS_REWARD, --����������
           to_number(z.zcrmk005) as Points_amount, --ʹ�û��ֽ��
           0 as Points_total, --ʹ�û�����
           to_number(z.zcrmk009) as SALES_AMOUNT, --�����ܽ��
           to_number(z.zamk0011) as ORDER_AMOUNT, --�����ܽ��
           to_number(z.netvalord) as ORDER_NET_AMOUNT, --���������
           to_number(z.zcrmk003) as PAY_AMOUNT, --Ӧ���ܽ��
           to_number(z.zcrmk004) as AMOUNT_PAID, --�Ѹ����
           to_number(z.zcrmk008 * z.zamk0010) as PURCHASE_AMOUNT, --�ɹ��ܽ��
           to_number(z.zcrmk009 - z.zamk0011) as PROFIT_AMOUNT, --ë���ܽ��
           to_number(z.crm_taxamo) as TAX_AMOUNT, --˰�ս��
           to_number(z.zyf_pay) as Amount_advanced, --Ԥ������
           to_number(z.zxy_pay) as Card_amount, --���⿨���
           to_number(z.znpt_atm) as Points_no_amount, --���ǻ��ֽ��
           to_number(z.ZCONDK001) as Freight_amount, --�˷ѽ��
           to_number(substr(z.zkunnr_l1, 2)) as SALES_SOURCE_KEY,
           to_char(z.zkunnr_l1) as SALES_SOURCE_DESC, --����һ����֯
           to_number(substr(z.zkunnr_l2, 2)) as SALES_SOURCE_SECOND_KEY,
           to_char(z.zkunnr_l2) as SALES_SOURCE_SECOND_DESC, --���۶�����֯
           (case
             when to_number(z.CRM_CRD_AT) > 0 then
              to_number(z.CRM_CRD_AT) --����ʱ��
             else
              to_number(z.crmpostdat)
           end) as ORDER_DATE_KEY,
           (case
             when to_number(z.CRM_CRD_AT) > 0 then
              to_date(z.CRM_CRD_AT || z.CREA_TIME, 'YYYY-MM-DD HH24:MI:SS')
             else
              TO_DATE(z.zgz_time, 'YYYY-MM-DD HH24:MI:SS')
           end) as ORDER_DATE,
           (case
             when to_number(z.CRM_CRD_AT) > 0 then
              to_number(to_char(to_date(z.CRM_CRD_AT || z.CREA_TIME,
                                        'yyyy-mm-dd hh24:mi:ss'),
                                'hh24')) + 1
             else
              to_number(to_char(to_date(z.zgz_time, 'yyyy-mm-dd hh24:mi:ss'),
                                'hh24')) + 1
           end) as ORDER_HOUR_KEY,
           (case
             when to_number(z.CRM_CRD_AT) > 0 then
              to_number(to_char(to_date(z.CRM_CRD_AT || z.CREA_TIME,
                                        'yyyy-mm-dd hh24:mi:ss'),
                                'hh24'))
             else
              to_number(to_char(to_date(z.zgz_time, 'yyyy-mm-dd hh24:mi:ss'),
                                'hh24'))
           end) as ORDER_HOUR,
           --to_number(to_char(to_date(z.CRM_CRD_AT||z.CREA_TIME,'yyyy-mm-dd hh24:mi:ss'),'yyyymmdd')) as ORDER_DATE_KEY,--����ʱ��
           --to_date(z.CRM_CRD_AT||z.CREA_TIME, 'YYYY-MM-DD HH24:MI:SS') as ORDER_DATE,
           --to_number(to_char(to_date(z.CRM_CRD_AT||z.CREA_TIME,'yyyy-mm-dd hh24:mi:ss'),'hh24'))+1 as ORDER_HOUR_KEY,
           --to_number(to_char(to_date(z.CRM_CRD_AT||z.CREA_TIME,'yyyy-mm-dd hh24:mi:ss'),'hh24')) as ORDER_HOUR,
           TO_DATE(z.zgz_time, 'YYYY-MM-DD HH24:MI:SS') as POSTING_DATE, --����ʱ��
           to_number(z.crmpostdat) as POSTING_DATE_KEY,
           to_number(to_char(to_date(z.zgz_time, 'yyyy-mm-dd hh24:mi:ss'),
                             'hh24')) + 1 as POSTING_HOUR_KEY,
           to_number(to_char(to_date(z.zgz_time, 'yyyy-mm-dd hh24:mi:ss'),
                             'hh24')) as POSTING_HOUR,
           
           to_char(z.ZCRMD001) as order_desc, --����״̬��������
           DECODE(Z.ZCRMD199, 'X', 1, 0) as Pre_order_state, --�Ƿ���Ԥ����
           
           (case
             when fhq.fhqcancel = 1 then
              0 --����ǰȡ������Ч����
             when fhq.fhqcancel is null and th.cancel_stae is null then
              1 --û���˻�ȡ����������Ч
             when fhq.fhqcancel is null and th.cancel_stae >= 1 then
              0 --���˻�ȡ����������Ч
             else
              1 --��������Ч
           end) as ORDER_STATE, --�Ƿ�����Ч����
           (case
             when fhq.fhqcancel = 1 then
              1
             when fhq.fhqcancel is null and th.cancel_stae is null then
              0
             when fhq.fhqcancel is null and th.cancel_stae >= 1 then
              1
             else
              0
           end) as CANCEL_STATE, --�Ƿ���ȡ������
           (case
             when fhq.fhqcancel = 1 then
              1
             else
              0
           end) as Cancel_before_state, --�Ƿ񷢻�ǰȡ��
           (case
             when fhq.fhqcancel = 1 then
              1
             else
              th.cancel_nums
           end) as Cancel_nums,
           (case
             when fhq.fhqcancel = 1 then
              fhq.befor_goods_date
             else
              th.cancel_date
           end) as Cancel_date,
           
           (case
             when fhq.fhqcancel = 1 then
              to_number(to_char(fhq.befor_goods_date, 'yyyymmdd'))
             else
              to_number(to_char(th.cancel_date, 'yyyymmdd'))
           end) as Cancel_date_key,
           (case
             when fhq.fhqcancel = 1 then
              to_number(to_char(fhq.befor_goods_date, 'hh24')) + 1
             else
              to_number(to_char(th.cancel_date, 'hh24')) + 1
           end) as Cancel_hour_key,
           (case
             when fhq.fhqcancel = 1 then
              to_number(to_char(fhq.befor_goods_date, 'hh24'))
             else
              to_number(to_char(th.cancel_date, 'hh24'))
           end) as Cancel_hour,
           (case
             when fhq.fhqcancel = 1 then
              to_number(to_char(fhq.befor_goods_date, 'yyyymmdd'))
             else
              to_number(to_char(th.min_cancel_date, 'yyyymmdd'))
           end) as Cancel_date_first_key,
           (case
             when fhq.fhqcancel = 1 then
              fhq.befor_goods_date
             else
              th.min_cancel_date
           end) as Cancel_date_first,
           (case
             when fhq.fhqcancel = 1 then
              to_number(to_char(fhq.befor_goods_date, 'yyyymmdd'))
             else
              to_number(to_char(th.max_cancel_date, 'yyyymmdd'))
           end) as Cancel_date_last_key,
           (case
             when fhq.fhqcancel = 1 then
              fhq.befor_goods_date
             else
              th.max_cancel_date
           end) as Cancel_date_last,
           /*(case when th.cancel_stae is null then 1
                 when th.cancel_stae>=1 then 0
                 else 1
           end) as ORDER_STATE,--�Ƿ�ȡ��
           (case when th.cancel_stae is null then 0
                 when th.cancel_stae>=1 then 1
                 else 0
           end) as CANCEL_STATE,--�Ƿ�ȡ��
           th.cancel_nums as Cancel_nums,
           th.cancel_date as Cancel_date,
           to_number(to_char(th.cancel_date,'yyyymmdd')) as Cancel_date_key,
           to_number(to_char(th.cancel_date,'hh24'))+1 as Cancel_hour_key,
           to_number(to_char(th.cancel_date,'hh24')) as Cancel_hour,
           to_number(to_char(th.min_cancel_date,'yyyymmdd')) as Cancel_date_first_key,
           th.min_cancel_date as Cancel_date_first,
           to_number(to_char(th.max_cancel_date,'yyyymmdd')) as Cancel_date_last_key,
           th.max_cancel_date as Cancel_date_last,*/
           -1 as CANCEL_PERSON,
           (case
             when hh.Exchange_goods_state is null then
              0
             when hh.Exchange_goods_state >= 1 then
              1
             else
              0
           end) as Exchange_goods_state, --�Ƿ�ȡ��
           hh.Exchange_goods_state as Exchange_goods_nums,
           to_number(to_char(hh.max_exchange_date, 'yyyymmdd')) as Exchange_goods_date_key,
           hh.max_exchange_date as Exchange_goods_date,
           to_number(to_char(hh.max_exchange_date, 'hh24')) + 1 as Exchange_goods_hour_key,
           to_number(to_char(hh.max_exchange_date, 'hh24')) as Exchange_goods_hour,
           to_number(to_char(hh.max_exchange_date, 'yyyymmdd')) as Exchange_date_last_key,
           hh.max_exchange_date as Exchange_date_last,
           to_number(to_char(hh.min_exchange_date, 'yyyymmdd')) as Exchange_date_first_key,
           hh.min_exchange_date as Exchange_date_first,
           tht.numstht as cancel_total,
           hht.numshht as Exchange_goods_total,
           crmpostdates as UPDATE_TIME,
           Z.ZCRMD018 ORDER_FROM /*������Դodshappigo.ods_order.zcrmd018 by yangjin 2018-05-03*/
      from (select distinct CREA_TIME,
                            CRM_CRD_AT,
                            CRM_ENDCST,
                            CRM_ITMTYP,
                            CRM_OBJ_ID,
                            CRM_PRCTYP,
                            CRM_SRVKB,
                            CRM_TAXAMO,
                            CRMPOSTDAT,
                            NETVALORD,
                            ZAMK0010,
                            ZAMK0011,
                            ZCONDK001,
                            ZCR_ON,
                            ZCRMD001,
                            ZCRMD015,
                            ZCRMD018,
                            ZCRMD199,
                            ZCRMK003,
                            ZCRMK004,
                            ZCRMK005,
                            ZCRMK006,
                            ZCRMK007,
                            ZCRMK008,
                            ZCRMK009,
                            ZEAMC010,
                            ZEAMC027,
                            ZGZ_TIME,
                            ZKUNNR_L1,
                            ZKUNNR_L2,
                            ZLIFNR,
                            ZMATER2,
                            ZMATERIAL,
                            ZNPT_ATM,
                            ZTCMC016,
                            ZTCMC020,
                            ZTCRMC04,
                            ZTCRMC05,
                            ZXY_PAY,
                            ZYF_PAY
              from odshappigo.ods_order /*��distinctȥ�� by yangjin 2016-07-23*/
            ) z
      left join
    --�˻���Ϣͳ��
     (select count(distinct(p.crm_obj_id)) as cancel_nums,
             p.ztcmc006,
             p.ztcrmc04,
             min(p.ORDER_DATE) as min_cancel_date,
             max(p.ORDER_DATE) as max_cancel_date,
             sum(case
                   when p.crm_obj_id = pp.crm_obj_ids then
                    0
                   else
                    1
                 end) as cancel_stae,
             max(decode(pp.crm_obj_ids, '', p.ORDER_DATE, '')) as cancel_date
        from (select qc.crm_obj_id,
                     qc.ztcmc006,
                     max(to_date(qc.zgz_time, 'YYYY-MM-DD HH24:MI:SS')) as ORDER_DATE,
                     max(qc.ztcrmc04) as ztcrmc04
                from odshappigo.ods_order qc
               where qc.CRM_PRCTYP = 'ZB01'
                 and (qc.ZTCMC008 = '10' -- "���Ż���
                     OR qc.ZTCMC008 = '30' -- "�û��ؼ�
                     OR qc.ZTCMC008 is null OR qc.ZTCMC008 = '20' --�����˻�
                     )
                 and qc.ztcrmc04 in
                     (select ztcrmc04
                        from odshappigo.ods_order
                       where ((zcr_on >= to_char(crmpostdates * 1000000) and
                             zcr_on < to_char((crmpostdates + 1) * 1000000) and
                             crmpostdat < to_char(crmpostdates)) or
                             crmpostdat = to_char(crmpostdates))
                         and CRM_PRCTYP in ('ZA01', 'ZA02', 'ZA03')
                       group by ztcrmc04)
               group by qc.crm_obj_id, qc.ztcmc006) p
        left join (select qc.crm_obj_id as crm_obj_ids,
                         qc.ztcmc006,
                         max(to_date(qc.zgz_time, 'YYYY-MM-DD HH24:MI:SS')) as ORDER_DATE
                    from odshappigo.ods_order_cancel qc
                   where qc.CRM_PRCTYP = 'ZB01'
                     and (qc.ZTCMC008 = '10' -- "���Ż���
                         OR qc.ZTCMC008 = '30' -- "�û��ؼ�
                         OR qc.ZTCMC008 is null /*qc.ZTCMC008=''*/
                         OR qc.ZTCMC008 = '20' --�����˻�
                         )
                     and qc.ztcrmc04 in
                         (select ztcrmc04
                            from odshappigo.ods_order
                           where ((zcr_on >= to_char(crmpostdates * 1000000) and
                                 zcr_on <
                                 to_char((crmpostdates + 1) * 1000000) and
                                 crmpostdat < to_char(crmpostdates)) or
                                 crmpostdat = to_char(crmpostdates))
                             and CRM_PRCTYP in ('ZA01', 'ZA02', 'ZA03')
                           group by ztcrmc04)
                   group by qc.crm_obj_id, qc.ztcmc006) pp
          on pp.crm_obj_ids = p.crm_obj_id
         and pp.ztcmc006 = p.ztcmc006
       group by p.ztcrmc04, p.ztcmc006) th
        on th.ztcrmc04 = z.ztcrmc04
       and th.ztcmc006 = z.ztcrmc05
      left join
    --������Ϣͳ��
     (select qc.ztcrmc04,
             qc.ztcmc006,
             count(distinct(qc.crm_obj_id)) as Exchange_goods_state,
             min(to_date(zgz_time, 'YYYY-MM-DD HH24:MI:SS')) as min_Exchange_date,
             max(to_date(zgz_time, 'YYYY-MM-DD HH24:MI:SS')) as max_Exchange_date
        from odshappigo.ods_order qc
       where qc.CRM_PRCTYP = 'ZA08'
         and qc.ztcrmc04 in
             (select ztcrmc04
                from odshappigo.ods_order
               where ((zcr_on >= to_char(crmpostdates * 1000000) and
                     zcr_on < to_char((crmpostdates + 1) * 1000000) and
                     crmpostdat < to_char(crmpostdates)) or
                     crmpostdat = to_char(crmpostdates))
                 and CRM_PRCTYP in ('ZA01', 'ZA02', 'ZA03')
               group by ztcrmc04)
       group by qc.ztcrmc04, qc.ztcmc006) hh
        on hh.ztcrmc04 = z.ztcrmc04
       and hh.ztcmc006 = z.ztcrmc05
      left join ( --����ǰȡ��
                 select qc.ztcrmc04,
                         qc.ztcmc006,
                         1 as fhqcancel,
                         min(to_date(zgz_time, 'YYYY-MM-DD HH24:MI:SS')) as befor_goods_date
                   from odshappigo.ods_order qc
                  where qc.CRM_PRCTYP = 'ZCR1'
                    and qc.ztcrmc04 in
                        (select ztcrmc04
                           from odshappigo.ods_order
                          where ((zcr_on >= to_char(crmpostdates * 1000000) and
                                zcr_on <
                                to_char((crmpostdates + 1) * 1000000) and
                                crmpostdat < to_char(crmpostdates)) or
                                crmpostdat = to_char(crmpostdates))
                            and CRM_PRCTYP in ('ZA01', 'ZA02', 'ZA03'))
                  group by qc.ztcrmc04, qc.ztcmc006) fhq
        on fhq.ztcrmc04 = z.ztcrmc04
       and fhq.ztcmc006 = z.ztcrmc05
      left join ( --ͳ���˻��ܴ���
                 select count(distinct(qc.crm_obj_id)) as numstht,
                         qc.ztcrmc04
                   from odshappigo.ods_order qc
                  where qc.CRM_PRCTYP = 'ZB01'
                    and (qc.ZTCMC008 = '10' -- "���Ż���
                        OR qc.ZTCMC008 = '30' -- "�û��ؼ�
                        OR qc.ZTCMC008 is null /*qc.ZTCMC008 = ''*/
                        OR qc.ZTCMC008 = '20' --�����˻�
                        )
                    and qc.ztcrmc04 in
                        (select ztcrmc04
                           from odshappigo.ods_order
                          where ((zcr_on >= to_char(crmpostdates * 1000000) and
                                zcr_on <
                                to_char((crmpostdates + 1) * 1000000) and
                                crmpostdat < to_char(crmpostdates)) or
                                crmpostdat = to_char(crmpostdates))
                            and CRM_PRCTYP in ('ZA01', 'ZA02', 'ZA03')
                          group by ztcrmc04)
                  group by qc.ztcrmc04) tht
        on tht.ztcrmc04 = z.ztcrmc04
      left join ( --ͳ�ƻ��ܴ���
                 select count(distinct(qc.crm_obj_id)) as numshht,
                         qc.ztcrmc04
                   from odshappigo.ods_order qc
                  where qc.CRM_PRCTYP = 'ZA08'
                    and qc.ztcrmc04 in
                        (select ztcrmc04
                           from odshappigo.ods_order
                          where ((zcr_on >= to_char(crmpostdates * 1000000) and
                                zcr_on <
                                to_char((crmpostdates + 1) * 1000000) and
                                crmpostdat < to_char(crmpostdates)) or
                                crmpostdat = to_char(crmpostdates))
                            and CRM_PRCTYP in ('ZA01', 'ZA02', 'ZA03')
                          group by ztcrmc04)
                  group by qc.ztcrmc04) hht
        on hht.ztcrmc04 = z.ztcrmc04
     where ((z.zcr_on >= to_char(crmpostdates * 1000000) and
           z.zcr_on < to_char((crmpostdates + 1) * 1000000) and
           z.crmpostdat < to_char(crmpostdates)) or
           z.crmpostdat = to_char(crmpostdates))
       and z.CRM_PRCTYP in ('ZA01', 'ZA02', 'ZA03')
     order by z.CRM_OBJ_ID asc;
  insert_rows := sql%rowcount;

  --������ʵ�����ݲ���
  if insert_rows > 0
  then
    insert into fact_order
      (ORDER_OBJ_ID,
       Order_key,
       Address_key,
       Member_key,
       Member_Grade_desc,
       Member_Grade_key,
       Sales_Source_key,
       Sales_Source_desc,
       Sales_Source_second_key,
       Sales_Source_second_desc,
       Order_date_key,
       Order_date,
       Order_hour_key,
       Order_hour,
       Posting_date,
       Posting_date_key,
       Posting_hour_key,
       Posting_hour,
       Sales_amount,
       Order_nums,
       Sku_nums,
       spu_nums,
       Discount_amount,
       Counpos_amount,
       Order_amount,
       Profit_amount,
       Freight_amount,
       Cost_amount,
       Purchase_price,
       Pay_amount,
       Amount_paid,
       Points_total,
       Points_amount,
       Amount_advanced,
       Card_amount,
       Points_no_amount,
       
       ORDER_NET_AMOUNT,
       TAX_AMOUNT,
       
       order_desc, --����״̬��������
       Pre_order_state, --�Ƿ���Ԥ����
       ORDER_STATE, --�Ƿ�����Ч����
       CANCEL_STATE, --�Ƿ�ȡ��
       Cancel_before_state, --�Ƿ��Ƿ���ǰȡ��
       Cancel_nums,
       Cancel_date,
       Cancel_date_key,
       Cancel_hour_key,
       Cancel_hour,
       Cancel_date_first_key,
       Cancel_date_first,
       Cancel_date_last_key,
       Cancel_date_last,
       CANCEL_PERSON,
       Exchange_goods_state, --�Ƿ�ȡ��
       Exchange_goods_nums,
       Exchange_goods_date_key,
       Exchange_goods_date,
       Exchange_goods_hour_key,
       Exchange_goods_hour,
       Exchange_date_last_key,
       Exchange_date_last,
       Exchange_date_first_key,
       Exchange_date_first,
       UPDATE_TIME,
       ORDER_FROM)
      select gs.order_key as ORDER_OBJ_ID,
             gs.order_key as Order_key,
             min(gs.Address_key) as Address_key,
             min(gs.Member_key) as Member_key,
             min(gs.Member_Grade_desc) as Member_Grade_desc, --��Ա�ȼ�����
             min(gs.Member_Grade_Key) as Member_Grade_Key, --��Ա�ȼ�key
             max(gs.Sales_Source_key) as Sales_Source_key, --һ����������
             min(gs.Sales_Source_desc) as Sales_Source_desc, --һ����������
             max(gs.Sales_Source_second_key) as Sales_Source_second_key, --������������
             min(gs.Sales_Source_second_desc) as Sales_Source_second_desc, --������������
             min(gs.Order_date_key) as Order_date_key, --������������
             min(gs.Order_date) as Order_date, --������������
             min(gs.Order_hour_key) as Order_hour_key,
             min(gs.Order_hour) as Order_hour,
             min(gs.Posting_date) as Posting_date, --����ʱ��
             --to_number(o.crmpostdat) as Posting_date_key,
             min(gs.Posting_date_key) as Posting_date_key,
             min(gs.Posting_hour_key) as Posting_hour_key,
             min(gs.Posting_hour) as Posting_hour,
             sum(gs.sales_amount) as Sales_amount, --���۽��
             sum(gs.nums) as Order_nums, --��Ʒ����
             sum(gs.nums) as Sku_nums, --sku����
             
             count(gs.order_key) as spu_nums, --spu����
             sum(gs.discount_price * gs.nums) as Discount_amount, --��Ʒ���ۼ�����ǵ������ó˻���
             sum(gs.Coupons_price * gs.nums) as Counpos_amount, --��Ʒ���ۼ�����ǵ������ó˻���
             sum(gs.order_amount) as Order_amount, --�������
             sum(gs.order_amount) - sum(gs.COST_PRICE * gs.nums) as Profit_amount, --ë���ܽ��  �����ܽ��-�ܳɱ����
             sum(gs.Freight_amount) as Freight_amount, --�˷ѽ��
             sum(gs.Cost_price * gs.nums) as Cost_amount, --��Ʒ���ۼ�����ǵ������ó˻���
             sum(gs.purchase_price * gs.nums) as Purchase_price, --��Ʒ���ۼ�����ǵ������ó˻���
             min(distinct(gs.Pay_amount)) as Pay_amount, --Ӧ�����
             min(distinct(gs.amount_paid)) as Amount_paid, --�Ѹ����
             min(gs.points_total) as Points_total, --��������
             min(gs.Points_amount) as Points_amount, --���ֽ��
             sum(gs.amount_advanced) as Amount_advanced, --Ԥ������
             sum(gs.Card_amount) as Card_amount, --���⿨���
             sum(gs.Points_no_amount) as Points_no_amount, --���ƻ��ֽ��
             sum(gs.ORDER_NET_AMOUNT) as ORDER_NET_AMOUNT, --���������
             sum(gs.TAX_AMOUNT) as TAX_AMOUNT, --˰����
             
             max(gs.order_desc) as order_desc, --����״̬��������
             max(gs.Pre_order_state) as Pre_order_state, --�Ƿ���Ԥ����
             (case
               when count(gs.ORDER_STATE) = sum(gs.ORDER_STATE) then
                1 --��������
               when count(gs.ORDER_STATE) > sum(gs.ORDER_STATE) and
                    sum(gs.ORDER_STATE) > 0 then
                2 --����ȡ��
               else
                0 --ȡ��
             end) as ORDER_STATE, --�Ƿ���Ч����
             (case --when hh.Exchange_goods_state is null then 0
               when sum(gs.CANCEL_STATE) > 0 then
                1
               else
                0
             end) as CANCEL_STATE, --���з�ȡ��
             (case
               when sum(gs.Cancel_before_state) > 0 then
                1
               else
                0
             end) as Cancel_before_state, --�Ƿ񷢻�ǰȡ��
             max(gs.cancel_total) as Cancel_nums,
             min(gs.Cancel_date) as Cancel_date,
             min(gs.Cancel_date_key) as Cancel_date_key,
             min(gs.Cancel_hour_key) as Cancel_hour_key,
             min(gs.Cancel_hour) as Cancel_hour,
             min(gs.Cancel_date_first_key) as Cancel_date_first_key,
             min(gs.Cancel_date_first) as Cancel_date_first,
             min(gs.Cancel_date_last_key) as Cancel_date_last_key,
             min(gs.Cancel_date_last) as Cancel_date_last,
             -1 as CANCEL_PERSON,
             (case --when hh.Exchange_goods_state is null then 0
               when sum(gs.Exchange_goods_state) >= 1 then
                1
               else
                0
             end) as Exchange_goods_state, --�Ƿ�ȡ��
             max(gs.Exchange_goods_total) as Exchange_goods_nums,
             min(gs.Exchange_goods_date_key) as Exchange_goods_date_key,
             min(gs.Exchange_goods_date) as Exchange_goods_date,
             min(gs.Exchange_goods_hour_key) as Exchange_goods_hour_key,
             min(gs.Exchange_goods_hour) as Exchange_goods_hour,
             min(gs.Exchange_date_last_key) as Exchange_date_last_key,
             min(gs.Exchange_date_last) as Exchange_date_last,
             min(gs.Exchange_date_first_key) as Exchange_date_first_key,
             min(gs.Exchange_date_first) as Exchange_date_first,
             crmpostdates as UPDATE_TIME,
             MIN(GS.ORDER_FROM) AS ORDER_FROM /*������Դodshappigo.ods_order.zcrmd018 by yangjin 2018-05-03*/
        from fact_goods_sales gs
       where gs.order_key in
             (select to_number(z.ZTCRMC04)
                from odshappigo.ods_order z
               where ((z.zcr_on >= to_char(crmpostdates * 1000000) and
                     z.zcr_on < to_char((crmpostdates + 1) * 1000000) and
                     z.crmpostdat < to_char(crmpostdates)) or
                     z.crmpostdat = to_char(crmpostdates))
                 and z.CRM_PRCTYP in ('ZA01', 'ZA02', 'ZA03')
               group by z.ZTCRMC04)
       group by gs.order_key
       order by gs.order_key desc;
    s_etl.err_msg := crmpostdates || 'goods����:' || insert_rows ||
                     '-orders����:' || sql%rowcount;
  else
    s_etl.err_msg := crmpostdates || 'goods���۱�����δ����';
    sp_sbi_w_etl_log(s_etl);
    return;
  end if;
  commit;

  /*��־��¼ģ��*/
  s_etl.end_time       := sysdate;
  s_etl.etl_record_ins := insert_rows;
  s_etl.etl_status     := 'SUCCESS';
  s_etl.etl_duration   := trunc((s_etl.end_time - s_etl.start_time) * 86400);
  sp_sbi_w_etl_log(s_etl);
exception
  when others then
    s_etl.end_time   := sysdate;
    s_etl.etl_status := 'FAILURE';
    s_etl.err_msg    := sqlerrm;
    sp_sbi_w_etl_log(s_etl);
    return;
  
end createordergoods;
/
