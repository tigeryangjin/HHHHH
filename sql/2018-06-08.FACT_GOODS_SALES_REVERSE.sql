--source
select to_number(z.ZMATERIAL) as SALES_GOODS_ID, --goods sku
       to_number(z.ZTCRMC04) as ORDER_KEY, --订单权责制编号
       to_number(z.crm_obj_id) as ORDER_H_KEY, --订单发生制编号
       to_number(z.ZTCMC020) as ADDRESS_KEY, --四级地址编号
       (case
         when nvl2(translate(replace(z.crm_endcst, '"', ''),
                             '\0123456789',
                             '\'),
                   0,
                   1) = 0 then
          0
         else
          to_number(replace(z.crm_endcst, '"', ''))
       end) as MEMBER_KEY, --会员编号
       to_char(z.ZTCMC016) as MEMBER_GRADE_DESC, --会员等级描述
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
       to_char(z.crm_itmtyp) as TRAN_DESC, --转换类型
       decode(z.crm_itmtyp, 'TAN', 0, 'TANN', 1, -1) as TRAN_TYPE, --0主品，1赠品
       decode(z.zeamc010, 'ZB', 1, 0) as LIVE_STATE, --1是直播
       decode(z.zeamc010, 'CB', 1, 0) as REPLAY_STATE, --1是重播
       to_char(z.ZCRMD015) as WINDOW_ID, --橱窗标识
       to_number(z.ZEAMC027) as MD_PERSON, --md编号
       to_number(z.ZLIFNR) as SUPPLIER_KEY, --供应商key
       to_number(z.ZLIFNR) as SUPPLIER_TITLE, --供应商key描述
       
       (case
         when to_number(z.zamk0010) = 0 then
          to_number(z.zcrmk009)
         else
          to_number(z.zcrmk009 / z.zamk0010)
       end) as UNIT_PRICE,
       --to_number(z.zcrmk009/z.zamk0010) as UNIT_PRICE,--商品单价
       (case
         when to_number(z.zamk0010) = 0 then
          to_number(z.zcrmk006)
         else
          to_number(z.zcrmk006 / z.zamk0010)
       end) as DISCOUNT_PRICE,
       --to_number(z.zcrmk006/z.zamk0010) as DISCOUNT_PRICE,--单个商品促销金额
       (case
         when to_number(z.zamk0010) = 0 then
          to_number(z.zamk0011)
         else
          to_number(z.zamk0011 / z.zamk0010)
       end) as BARGAIN_PRICE,
       --to_number(z.zamk0011/z.zamk0010) as BARGAIN_PRICE,--单个商品成交价格
       z.zamk0010 as NUMS, --数量
       (case
         when to_number(z.zamk0010) = 0 then
          to_number(z.crm_srvkb)
         else
          to_number(z.crm_srvkb / z.zamk0010)
       end) as COST_PRICE,
       
       --to_number(z.zcrmk009/z.zamk0010) as UNIT_PRICE,--商品单价
       --to_number(z.zcrmk006/z.zamk0010) as DISCOUNT_PRICE,--单个商品促销金额
       --to_number(z.zamk0011/z.zamk0010) as BARGAIN_PRICE,--单个商品成交价格
       --z.zamk0010 as NUMS,--数量
       --to_number(z.crm_srvkb/z.zamk0010) as COST_PRICE,--单个商品成本金额
       to_number(z.zcrmk008) as PURCHASE_PRICE, --单个商品采购价格
       z.zcrmk007 as COUPONS_PRICE, --券金额
       0 as POINTS_REWARD, --奖励积分数
       to_number(z.zcrmk005) as Points_amount, --使用积分金额
       0 as Points_total, --使用积分数
       to_number(z.zcrmk009) as SALES_AMOUNT, --销售总金额
       to_number(z.zamk0011) as ORDER_AMOUNT, --订购总金额
       to_number(z.netvalord) as ORDER_NET_AMOUNT, --订购净金额
       to_number(z.zcrmk003) as PAY_AMOUNT, --应付总金额
       to_number(z.zcrmk004) as AMOUNT_PAID, --已付金额
       to_number(z.zcrmk008 * z.zamk0010) as PURCHASE_AMOUNT, --采购总金额
       to_number(z.zcrmk009 - z.zamk0011) as PROFIT_AMOUNT, --毛利总金额
       to_number(z.crm_taxamo) as TAX_AMOUNT, --税收金额
       to_number(z.zyf_pay) as Amount_advanced, --预付款金额
       to_number(z.zxy_pay) as Card_amount, --心意卡金额
       to_number(z.znpt_atm) as Points_no_amount, --不记积分金额
       to_number(z.ZCONDK001) as Freight_amount, --运费金额
       to_number(substr(z.zkunnr_l1, 2)) as SALES_SOURCE_KEY,
       to_char(z.zkunnr_l1) as SALES_SOURCE_DESC, --销售一级组织
       to_number(substr(z.zkunnr_l2, 2)) as SALES_SOURCE_SECOND_KEY,
       to_char(z.zkunnr_l2) as SALES_SOURCE_SECOND_DESC, --销售二级组织
       to_number(z.ztcrmc01) as ORDER_DATE_KEY, --订购时间
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
       to_number(z.ZTCMC008) as Reject_return, --拒收还是退货
       (case
         when z.CRM_PRCTYP = 'ZB01' then
          to_number(z.ZTCMC008)
         else
          -1 --其余是有效
       end) as cancel_type,
       (case
         when z.CRM_PRCTYP = 'ZA08' then
          to_number(z.ZTCMC008)
         else
          -1 --其余是有效
       end) as exchange_type,
       TO_DATE(z.zgz_time, 'YYYY-MM-DD HH24:MI:SS') as POSTING_DATE, --过账时间
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
       -1            as Cancel_person,
       &crmpostdates as UPDATE_TIME,
       Z.ZCRMD018    AS ORDER_FROM /*订单来源odshappigo.ods_order.zcrmd018 by yangjin 2018-05-03*/
  from (select distinct *
          from odshappigo.ods_order /*加上distinct去重 by yangjin 2017-07-25*/
        ) z
  left join (select *
               from odshappigo.ods_order_cancel
              where CRM_PRCTYP = 'ZB01'
                and (ZTCMC008 = '10' -- "上门回收
                    OR ZTCMC008 = '30' -- "用户回寄
                    OR ZTCMC008 is null OR ZTCMC008 = '20' --拒收退货
                    )
                and crm_obj_id in
                    (select crm_obj_id
                       from odshappigo.ods_order
                      where ((zcr_on >= to_char(&crmpostdates * 1000000) and
                            zcr_on < to_char((&crmpostdates + 1) * 1000000) and
                            crmpostdat < to_char(&crmpostdates)) or
                            crmpostdat = to_char(&crmpostdates))
                        and CRM_PRCTYP in ('ZB01')
                      group by crm_obj_id)) zc
    on zc.crm_obj_id = z.crm_obj_id
   and zc.ztcmc006 = z.ztcmc006
 where ((z.CRM_PRCTYP = 'ZB01' and
       (z.ZTCMC008 = '10' -- "上门回收
       OR z.ZTCMC008 = '30' -- "用户回寄
       OR z.ZTCMC008 is null OR z.ZTCMC008 = '20' --拒收退货
       )) or z.crm_prctyp = 'ZA08')
   and ((z.zcr_on >= to_char(&crmpostdates * 1000000) and
       z.zcr_on < to_char((&crmpostdates + 1) * 1000000) and
       z.crmpostdat < to_char(&crmpostdates)) or
       z.crmpostdat = to_char(&crmpostdates))
   AND Z.ZTCRMC04 = 5208514566

 order by z.CRM_OBJ_ID asc;

--2.
select to_number(z.ZMATERIAL) as SALES_GOODS_ID, --goods sku
       to_number(z.ZTCRMC04) as ORDER_KEY, --订单权责制编号
       to_number(z.crm_obj_id) as ORDER_H_KEY, --订单发生制编号
       to_number(z.ZTCMC020) as ADDRESS_KEY, --四级地址编号
       (case
         when nvl2(translate(replace(z.crm_endcst, '"', ''),
                             '\0123456789',
                             '\'),
                   0,
                   1) = 0 then
          0
         else
          to_number(replace(z.crm_endcst, '"', ''))
       end) as MEMBER_KEY, --会员编号
       to_char(z.ZTCMC016) as MEMBER_GRADE_DESC, --会员等级描述
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
       to_char(z.crm_itmtyp) as TRAN_DESC, --转换类型
       decode(z.crm_itmtyp, 'TAN', 0, 'TANN', 1, -1) as TRAN_TYPE, --0主品，1赠品
       decode(z.zeamc010, 'ZB', 1, 0) as LIVE_STATE, --1是直播
       decode(z.zeamc010, 'CB', 1, 0) as REPLAY_STATE, --1是重播
       to_char(z.ZCRMD015) as WINDOW_ID, --橱窗标识
       to_number(z.ZEAMC027) as MD_PERSON, --md编号
       to_number(z.ZLIFNR) as SUPPLIER_KEY, --供应商key
       to_number(z.ZLIFNR) as SUPPLIER_TITLE, --供应商key描述
       
       (case
         when to_number(z.zamk0010) = 0 then
          to_number(z.zcrmk009)
         else
          to_number(z.zcrmk009 / z.zamk0010)
       end) as UNIT_PRICE,
       --to_number(z.zcrmk009/z.zamk0010) as UNIT_PRICE,--商品单价
       (case
         when to_number(z.zamk0010) = 0 then
          to_number(z.zcrmk006)
         else
          to_number(z.zcrmk006 / z.zamk0010)
       end) as DISCOUNT_PRICE,
       --to_number(z.zcrmk006/z.zamk0010) as DISCOUNT_PRICE,--单个商品促销金额
       (case
         when to_number(z.zamk0010) = 0 then
          to_number(z.zamk0011)
         else
          to_number(z.zamk0011 / z.zamk0010)
       end) as BARGAIN_PRICE,
       --to_number(z.zamk0011/z.zamk0010) as BARGAIN_PRICE,--单个商品成交价格
       z.zamk0010 as NUMS, --数量
       (case
         when to_number(z.zamk0010) = 0 then
          to_number(z.crm_srvkb)
         else
          to_number(z.crm_srvkb / z.zamk0010)
       end) as COST_PRICE,
       
       --to_number(z.zcrmk009/z.zamk0010) as UNIT_PRICE,--商品单价
       --to_number(z.zcrmk006/z.zamk0010) as DISCOUNT_PRICE,--单个商品促销金额
       --to_number(z.zamk0011/z.zamk0010) as BARGAIN_PRICE,--单个商品成交价格
       --z.zamk0010 as NUMS,--数量
       --to_number(z.crm_srvkb/z.zamk0010) as COST_PRICE,--单个商品成本金额
       to_number(z.zcrmk008) as PURCHASE_PRICE, --单个商品采购价格
       z.zcrmk007 as COUPONS_PRICE, --券金额
       0 as POINTS_REWARD, --奖励积分数
       to_number(z.zcrmk005) as Points_amount, --使用积分金额
       0 as Points_total, --使用积分数
       to_number(z.zcrmk009) as SALES_AMOUNT, --销售总金额
       to_number(z.zamk0011) as ORDER_AMOUNT, --订购总金额
       to_number(z.netvalord) as ORDER_NET_AMOUNT, --订购净金额
       to_number(z.zcrmk003) as PAY_AMOUNT, --应付总金额
       to_number(z.zcrmk004) as AMOUNT_PAID, --已付金额
       to_number(z.zcrmk008 * z.zamk0010) as PURCHASE_AMOUNT, --采购总金额
       to_number(z.zcrmk009 - z.zamk0011) as PROFIT_AMOUNT, --毛利总金额
       to_number(z.crm_taxamo) as TAX_AMOUNT, --税收金额
       to_number(z.zyf_pay) as Amount_advanced, --预付款金额
       to_number(z.zxy_pay) as Card_amount, --心意卡金额
       to_number(z.znpt_atm) as Points_no_amount, --不记积分金额
       to_number(z.ZCONDK001) as Freight_amount, --运费金额
       to_number(substr(z.zkunnr_l1, 2)) as SALES_SOURCE_KEY,
       to_char(z.zkunnr_l1) as SALES_SOURCE_DESC, --销售一级组织
       to_number(substr(z.zkunnr_l2, 2)) as SALES_SOURCE_SECOND_KEY,
       to_char(z.zkunnr_l2) as SALES_SOURCE_SECOND_DESC, --销售二级组织
       to_number(z.ztcrmc01) as ORDER_DATE_KEY, --订购时间
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
       to_number(z.ZTCMC008) as Reject_return, --拒收还是退货
       (case
         when z.CRM_PRCTYP = 'ZB01' then
          to_number(z.ZTCMC008)
         else
          -1 --其余是有效
       end) as cancel_type,
       (case
         when z.CRM_PRCTYP = 'ZA08' then
          to_number(z.ZTCMC008)
         else
          -1 --其余是有效
       end) as exchange_type,
       TO_DATE(z.zgz_time, 'YYYY-MM-DD HH24:MI:SS') as POSTING_DATE, --过账时间
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
       -1            as Cancel_person,
       &crmpostdates as UPDATE_TIME,
       Z.ZCRMD018    AS ORDER_FROM /*订单来源odshappigo.ods_order.zcrmd018 by yangjin 2018-05-03*/
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
          from odshappigo.ods_order /*加上distinct去重 by yangjin 2017-07-25*/
        ) z
  left join (select *
               from odshappigo.ods_order_cancel
              where CRM_PRCTYP = 'ZB01'
                and (ZTCMC008 = '10' -- "上门回收
                    OR ZTCMC008 = '30' -- "用户回寄
                    OR ZTCMC008 is null OR ZTCMC008 = '20' --拒收退货
                    )
                and crm_obj_id in
                    (select crm_obj_id
                       from odshappigo.ods_order
                      where ((zcr_on >= to_char(&crmpostdates * 1000000) and
                            zcr_on < to_char((&crmpostdates + 1) * 1000000) and
                            crmpostdat < to_char(&crmpostdates)) or
                            crmpostdat = to_char(&crmpostdates))
                        and CRM_PRCTYP in ('ZB01')
                      group by crm_obj_id)) zc
    on zc.crm_obj_id = z.crm_obj_id
   and zc.ztcmc006 = z.ztcmc006
 where ((z.CRM_PRCTYP = 'ZB01' and
       (z.ZTCMC008 = '10' -- "上门回收
       OR z.ZTCMC008 = '30' -- "用户回寄
       OR z.ZTCMC008 is null OR z.ZTCMC008 = '20' --拒收退货
       )) or z.crm_prctyp = 'ZA08')
   and ((z.zcr_on >= to_char(&crmpostdates * 1000000) and
       z.zcr_on < to_char((&crmpostdates + 1) * 1000000) and
       z.crmpostdat < to_char(&crmpostdates)) or
       z.crmpostdat = to_char(&crmpostdates))
   AND Z.ZTCRMC04 = 5208514566

 order by z.CRM_OBJ_ID asc;

--3.
select distinct CRM_ENDCST,
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
  from odshappigo.ods_order z
 where ((z.CRM_PRCTYP = 'ZB01' and
       (z.ZTCMC008 = '10' -- "上门回收
       OR z.ZTCMC008 = '30' -- "用户回寄
       OR z.ZTCMC008 is null OR z.ZTCMC008 = '20' --拒收退货
       )) or z.crm_prctyp = 'ZA08')
   and z.ZTCRMC04 = 5208514566;
