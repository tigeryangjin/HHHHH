create or replace procedure createfactordergoodsreverse(postday in number) is
  s_etl        w_etl_log%rowtype;
  sp_name      s_parameters2.pname%type;
  s_parameter  s_parameters1.parameter_value%type;
  insert_rows  number;
  crmpostdates number;
  --total_nums   number;
  --endid number;
  --onetotal number;--һ��ȡ���ٸ�
  /*
  ����˵���������򶩵����ݽ���������ȡ
       
  
  ����ʱ�䣺bobo  2016-04-06
  */

begin

  sp_name          := 'createfactordergoodsreverse'; --��Ҫ�ֹ�������дPROCEDURE������
  s_etl.table_name := 'FACT_ORDER_REVERSE'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı��
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
      s_etl.err_msg := postday||'�����������';
      sp_sbi_w_etl_log(s_etl);
      return;
  end if;*/

  /*select count(1) into total_nums from Fact_Order_Reverse where POSTING_DATE_KEY=postday;
  if total_nums>0 then
     s_etl.err_msg := postday||'�Ѿ�����������';
      sp_sbi_w_etl_log(s_etl);
      return;
  end if;*/

  if postday < 20050101
  then
    select max(posting_date_key) into crmpostdates from fact_ORDER; -- where CRM_CRD_AT=to_char(20140101);
  else
    crmpostdates := postday;
  end if;
  --��ɾ�����������
  delete from Fact_Order_Reverse
   where Order_obj_ID in
         (select to_number(z.crm_obj_id)
            from odshappigo.ods_order z
            left join (select *
                        from odshappigo.ods_order_cancel
                       where CRM_PRCTYP = 'ZB01'
                            /*2018-06-22���ZTCMC008=40*/
                         and (ZTCMC008 = '10' -- ���Ż���
                             OR ZTCMC008 = '20' --�����˻�
                             OR ZTCMC008 = '30' -- �û��ؼ�
                             OR ZTCMC008 = '40' --ָ���ؼĿ��ֹ�
                             OR ZTCMC008 is null)
                         and crm_obj_id in
                             (select crm_obj_id
                                from odshappigo.ods_order
                               where ((zcr_on >=
                                     to_char(crmpostdates * 1000000) and
                                     zcr_on <
                                     to_char((crmpostdates + 1) * 1000000) and
                                     crmpostdat < to_char(crmpostdates)) or
                                     crmpostdat = to_char(crmpostdates))
                                 and CRM_PRCTYP in ('ZB01')
                               group by crm_obj_id)) zc
              on zc.crm_obj_id = z.crm_obj_id
             and zc.ztcmc006 = z.ztcmc006
           where ((z.CRM_PRCTYP = 'ZB01'
                 /*2018-06-22���ZTCMC008=40*/
                 and (z.ZTCMC008 = '10' -- ���Ż���
                 OR z.ZTCMC008 = '20' --�����˻�
                 OR z.ZTCMC008 = '30' -- �û��ؼ�
                 OR Z.ZTCMC008 = '40' --ָ���ؼĿ��ֹ�
                 OR z.ZTCMC008 is null)) or z.crm_prctyp = 'ZA08')
             and ((z.zcr_on >= to_char(crmpostdates * 1000000) and
                 z.zcr_on < to_char((crmpostdates + 1) * 1000000) and
                 z.crmpostdat < to_char(crmpostdates)) or
                 z.crmpostdat = to_char(crmpostdates)));
  delete from fact_goods_sales_reverse
   where order_h_key in
         (select to_number(z.crm_obj_id)
            from odshappigo.ods_order z
            left join (select *
                        from odshappigo.ods_order_cancel
                       where CRM_PRCTYP = 'ZB01'
                            /*2018-06-22���ZTCMC008=40*/
                         and (ZTCMC008 = '10' -- ���Ż���
                             OR ZTCMC008 = '20' --�����˻�
                             OR ZTCMC008 = '30' -- �û��ؼ�
                             OR ZTCMC008 = '40' --ָ���ؼĿ��ֹ�
                             OR ZTCMC008 is null)
                         and crm_obj_id in
                             (select crm_obj_id
                                from odshappigo.ods_order
                               where ((zcr_on >=
                                     to_char(crmpostdates * 1000000) and
                                     zcr_on <
                                     to_char((crmpostdates + 1) * 1000000) and
                                     crmpostdat < to_char(crmpostdates)) or
                                     crmpostdat = to_char(crmpostdates))
                                 and CRM_PRCTYP in ('ZB01')
                               group by crm_obj_id)) zc
              on zc.crm_obj_id = z.crm_obj_id
             and zc.ztcmc006 = z.ztcmc006
           where ((z.CRM_PRCTYP = 'ZB01'
                 /*2018-06-22���ZTCMC008=40*/
                 and (z.ZTCMC008 = '10' -- ���Ż���
                 OR z.ZTCMC008 = '20' --�����˻�
                 OR z.ZTCMC008 = '30' -- �û��ؼ�
                 OR Z.ZTCMC008 = '40' --ָ���ؼĿ��ֹ�
                 OR z.ZTCMC008 is null)) or z.crm_prctyp = 'ZA08')
             and ((z.zcr_on >= to_char(crmpostdates * 1000000) and
                 z.zcr_on < to_char((crmpostdates + 1) * 1000000) and
                 z.crmpostdat < to_char(crmpostdates)) or
                 z.crmpostdat = to_char(crmpostdates)));

  --POSTING_DATE_KEY = crmpostdates;

  --�Ȳ���������ʵ��
  insert into fact_goods_sales_reverse
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
     order_date_key, --ԭ������ʱ��
     order_date,
     order_hour_key,
     order_hour,
     order_type, --��������
     Reject_return, --���ջ����˻�
     cancel_type, --�˻�����
     exchange_type, --��������
     posting_date, --����ʱ��
     posting_date_key,
     posting_hour_key,
     posting_hour,
     cancel_state, --�˻�״̬
     cancel_date_key, --�˻�ȡ��ʱ��
     cancel_date,
     cancel_hour_key,
     cancel_hour,
     Cancel_reason,
     Exchange_reason,
     One_reason,
     Two_reason,
     cancel_person,
     UPDATE_TIME,
     ORDER_FROM /*,
                                                                                                          pay_state,--֧��״̬
                                                                                                          pay_date_key,--֧��ʱ��
                                                                                                          pay_date,
                                                                                                          pay_hour_key,
                                                                                                          pay_hour  */)
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
           
           --to_number(z.zcrmk009/z.zamk0010) as UNIT_PRICE,--��Ʒ����
           --to_number(z.zcrmk006/z.zamk0010) as DISCOUNT_PRICE,--������Ʒ�������
           --to_number(z.zamk0011/z.zamk0010) as BARGAIN_PRICE,--������Ʒ�ɽ��۸�
           --z.zamk0010 as NUMS,--����
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
           to_number(z.ztcrmc01) as ORDER_DATE_KEY, --����ʱ��
           (case
             when to_number(z.ztcrmc02) > 0 then
              to_date(z.ztcrmc02, 'YYYY-MM-DD HH24:MI:SS')
             else
              to_date('1970-01-01 00:00:00', 'yyyy-mm-dd hh24:mi:ss')
           end) as ORDER_DATE,
           (case
             when to_number(z.ztcrmc02) = 0 then
              0
             else
              to_number(to_char(to_date(z.ztcrmc02, 'yyyy-mm-dd hh24:mi:ss'),
                                'hh24')) + 1
           end) as ORDER_HOUR_KEY,
           (case
             when to_number(z.ztcrmc02) = 0 then
              0
             else
              to_number(to_char(to_date(z.ztcrmc02, 'yyyy-mm-dd hh24:mi:ss'),
                                'hh24'))
           end) as ORDER_HOUR,
           DECODE(z.CRM_PRCTYP, 'ZB01', 0, 'ZA08', 1, -1) as order_type,
           to_number(z.ZTCMC008) as Reject_return, --���ջ����˻�
           (case
             when z.CRM_PRCTYP = 'ZB01' then
              to_number(z.ZTCMC008)
             else
              -1 --��������Ч
           end) as cancel_type,
           (case
             when z.CRM_PRCTYP = 'ZA08' then
              to_number(z.ZTCMC008)
             else
              -1 --��������Ч
           end) as exchange_type,
           TO_DATE(z.zgz_time, 'YYYY-MM-DD HH24:MI:SS') as POSTING_DATE, --����ʱ��
           to_number(z.crmpostdat) as POSTING_DATE_KEY,
           to_number(to_char(to_date(z.zgz_time, 'yyyy-mm-dd hh24:mi:ss'),
                             'hh24')) + 1 as POSTING_HOUR_KEY,
           to_number(to_char(to_date(z.zgz_time, 'yyyy-mm-dd hh24:mi:ss'),
                             'hh24')) as POSTING_HOUR,
           (case
             when z.CRM_PRCTYP = 'ZB01' and zc.zgz_time > 0 then
              1
             when z.CRM_PRCTYP = 'ZB01' and zc.zgz_time is null then
              0
             else
              -1
           end) as cancel_state,
           to_number(to_char(to_date(zc.zgz_time, 'yyyy-mm-dd hh24:mi:ss'),
                             'yyyymmdd')) as cancel_date_key,
           to_date(zc.zgz_time, 'yyyy-mm-dd hh24:mi:ss') as cancel_date,
           to_number(to_char(to_date(zc.zgz_time, 'yyyy-mm-dd hh24:mi:ss'),
                             'hh24')) + 1 as cancel_hour_key,
           to_number(to_char(to_date(zc.zgz_time, 'yyyy-mm-dd hh24:mi:ss'),
                             'hh24')) as cancel_hour,
           
           to_number(z.ZTCMC008) as Cancel_reason,
           to_number(z.ZTCMC009) as Exchange_reason,
           z.ZTCMC024 as One_reason,
           z.ZTCMC025 as Two_reason,
           --to_number(z.ZTCMC008) as REJECT_RETURN,
           -1           as Cancel_person,
           crmpostdates as UPDATE_TIME,
           Z.ZCRMD018   AS ORDER_FROM /*������Դodshappigo.ods_order.zcrmd018 by yangjin 2018-05-03*/
      from (select distinct CRM_ENDCST,
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
                            ZCRMD015,
                            ZCRMD018,
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
                            ZTCMC006,
                            ZTCMC008,
                            ZTCMC009,
                            ZTCMC016,
                            ZTCMC020,
                            ZTCMC024,
                            ZTCMC025,
                            ZTCRMC01,
                            ZTCRMC02,
                            ZTCRMC04,
                            ZXY_PAY,
                            ZYF_PAY
              from odshappigo.ods_order /*����distinctȥ�� by yangjin 2017-07-25*/
            ) z
      left join (select *
                   from odshappigo.ods_order_cancel
                  where CRM_PRCTYP = 'ZB01'
                       
                    and (ZTCMC008 = '10' -- "���Ż���
                        OR ZTCMC008 = '30' -- "�û��ؼ�
                        OR ZTCMC008 is null OR ZTCMC008 = '20' --�����˻�
                        )
                    and crm_obj_id in
                        (select crm_obj_id
                           from odshappigo.ods_order
                          where ((zcr_on >= to_char(crmpostdates * 1000000) and
                                zcr_on <
                                to_char((crmpostdates + 1) * 1000000) and
                                crmpostdat < to_char(crmpostdates)) or
                                crmpostdat = to_char(crmpostdates))
                            and CRM_PRCTYP in ('ZB01')
                          group by crm_obj_id)) zc
        on zc.crm_obj_id = z.crm_obj_id
       and zc.ztcmc006 = z.ztcmc006
     where ((z.CRM_PRCTYP = 'ZB01'
           /*2018-06-22���ZTCMC008=40*/
           and (Z.ZTCMC008 = '10' -- ���Ż���
           OR Z.ZTCMC008 = '20' --�����˻�
           OR Z.ZTCMC008 = '30' -- �û��ؼ�
           OR Z.ZTCMC008 = '40' --ָ���ؼĿ��ֹ�
           OR Z.ZTCMC008 is null)) or z.crm_prctyp = 'ZA08')
       and ((z.zcr_on >= to_char(crmpostdates * 1000000) and
           z.zcr_on < to_char((crmpostdates + 1) * 1000000) and
           z.crmpostdat < to_char(crmpostdates)) or
           z.crmpostdat = to_char(crmpostdates))
    
     order by z.CRM_OBJ_ID asc;

  /*from odshappigo.ods_order z left join 
  (select * from odshappigo.ods_order_cancel where CRM_PRCTYP = 'ZB01' and (ZTCMC008 = '10' -- "���Ż���
                          OR ZTCMC008 = '30' -- "�û��ؼ�
                          OR ZTCMC008 = '' OR ZTCMC008 = '20' --�����˻�
                          ) and crm_obj_id in (
                           select crm_obj_id  from odshappigo.ods_order where crmpostdat=to_char(crmpostdates) and CRM_PRCTYP in ('ZB01')
                          )) zc on zc.crm_obj_id=z.crm_obj_id and zc.ztcmc006=z.ztcmc006
     where ((z.CRM_PRCTYP = 'ZB01' and (z.ZTCMC008 = '10' -- "���Ż���
                          OR z.ZTCMC008 = '30' -- "�û��ؼ�
                          OR z.ZTCMC008 = '' OR z.ZTCMC008 = '20' --�����˻�
                          )) or z.crm_prctyp = 'ZA08')
                           and z.crmpostdat=to_char(crmpostdates)
     order by z.CRM_OBJ_ID asc;*/
  insert_rows := sql%rowcount;

  --������ʵ�����ݲ���
  if insert_rows > 0
  then
    insert into fact_order_reverse
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
       
       order_date_key, --ԭ������ʱ��
       order_date,
       order_hour_key,
       order_hour,
       order_type, --��������
       Reject_return, --���ջ����˻�
       cancel_type, --�˻�����
       exchange_type, --��������
       posting_date, --����ʱ��
       posting_date_key,
       posting_hour_key,
       posting_hour,
       cancel_state, --�˻�״̬
       cancel_date_key, --�˻�ȡ��ʱ��
       cancel_date,
       cancel_hour_key,
       cancel_hour,
       Cancel_reason,
       Exchange_reason,
       One_reason,
       Two_reason,
       cancel_person,
       UPDATE_TIME,
       ORDER_FROM)
      select gs.order_h_key as ORDER_OBJ_ID,
             min(gs.order_key) as Order_key,
             min(gs.Address_key) as Address_key,
             min(gs.Member_key) as Member_key,
             min(gs.Member_Grade_desc) as Member_Grade_desc, --��Ա�ȼ�����
             min(gs.Member_Grade_Key) as Member_Grade_Key, --��Ա�ȼ�key
             min(gs.Sales_Source_key) as Sales_Source_key, --һ����������
             min(gs.Sales_Source_desc) as Sales_Source_desc, --һ����������
             min(gs.Sales_Source_second_key) as Sales_Source_second_key, --������������
             min(gs.Sales_Source_second_desc) as Sales_Source_second_desc, --������������
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
             
             min(gs.order_date_key) as order_date_key, --ԭ������ʱ��
             min(gs.order_date) as order_date,
             min(gs.order_hour_key) as order_hour_key,
             min(gs.order_hour) as order_hour,
             max(gs.order_type) as order_type, --��������
             max(gs.Reject_return) as Reject_return, --���ջ����˻�
             max(gs.cancel_type) as cancel_type, --�˻�����
             max(gs.exchange_type) as exchange_type, --��������
             min(gs.posting_date) as posting_date, --����ʱ��
             min(gs.posting_date_key) as posting_date_key,
             min(gs.posting_hour_key) as posting_hour_key,
             min(gs.posting_hour) as posting_hour,
             max(gs.cancel_state) as cancel_state, --�˻�״̬
             max(gs.cancel_date_key) as cancel_date_key, --�˻�ȡ��ʱ��
             max(gs.cancel_date) as cancel_date,
             max(gs.cancel_hour_key) as cancel_hour_key,
             max(gs.cancel_hour) as cancel_hour,
             
             min(gs.Cancel_reason) as Cancel_reason,
             min(gs.Exchange_reason) as Exchange_reason,
             min(gs.one_reason) as One_reason,
             min(gs.Two_reason) as Two_reason,
             --min(gs.REJECT_RETURN) as REJECT_RETURN,
             max(gs.cancel_person) as cancel_person,
             crmpostdates as UPDATE_TIME,
             MIN(GS.ORDER_FROM) AS ORDER_FROM /*������Դodshappigo.ods_order.zcrmd018 by yangjin 2018-05-03*/
        from fact_goods_sales_reverse gs
       where gs.order_h_key in
             (select to_number(z.crm_obj_id)
                from odshappigo.ods_order z
                left join (select *
                            from odshappigo.ods_order_cancel
                           where CRM_PRCTYP = 'ZB01'
                             and (ZTCMC008 = '10' -- "���Ż���
                                 OR ZTCMC008 = '30' -- "�û��ؼ�
                                 OR ZTCMC008 is null OR ZTCMC008 = '20' --�����˻�
                                 )
                             and crm_obj_id in
                                 (select crm_obj_id
                                    from odshappigo.ods_order
                                   where ((zcr_on >=
                                         to_char(crmpostdates * 1000000) and
                                         zcr_on <
                                         to_char((crmpostdates + 1) *
                                                   1000000) and
                                         crmpostdat < to_char(crmpostdates)) or
                                         crmpostdat = to_char(crmpostdates))
                                     and CRM_PRCTYP in ('ZB01')
                                   group by crm_obj_id)) zc
                  on zc.crm_obj_id = z.crm_obj_id
                 and zc.ztcmc006 = z.ztcmc006
               where ((z.CRM_PRCTYP = 'ZB01'
                     /*2018-06-22���ZTCMC008=40*/
                     and (Z.ZTCMC008 = '10' -- ���Ż���
                     OR Z.ZTCMC008 = '20' --�����˻�
                     OR Z.ZTCMC008 = '30' -- �û��ؼ�
                     OR Z.ZTCMC008 = '40' --ָ���ؼĿ��ֹ�
                     OR Z.ZTCMC008 is null)) or z.crm_prctyp = 'ZA08')
                 and ((z.zcr_on >= to_char(crmpostdates * 1000000) and
                     z.zcr_on < to_char((crmpostdates + 1) * 1000000) and
                     z.crmpostdat < to_char(crmpostdates)) or
                     z.crmpostdat = to_char(crmpostdates)))
       group by gs.order_h_key
       order by gs.order_h_key desc;
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
end createfactordergoodsreverse;
/
