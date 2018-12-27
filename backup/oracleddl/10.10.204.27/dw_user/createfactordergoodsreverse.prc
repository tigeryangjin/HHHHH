???create or replace procedure dw_user.createfactordergoodsreverse(postday in number) is
  s_etl        w_etl_log%rowtype;
  sp_name      s_parameters2.pname%type;
  s_parameter  s_parameters1.parameter_value%type;
  insert_rows  number;
  crmpostdates number;
  --total_nums   number;
  --endid number;
  --onetotal number;--一次取多少个
  /*
  功能说明：对逆向订单数据进行增量抽取
       
  
  作者时间：bobo  2016-04-06
  */

begin

  sp_name          := 'createfactordergoodsreverse'; --需要手工填入所写PROCEDURE的名称
  s_etl.table_name := 'FACT_ORDER_REVERSE'; --此处需要手工录入该PROCEDURE操作的表格
  s_etl.proc_name  := sp_name;
  s_etl.start_time := sysdate;
  s_parameter      := 0;
  --onetotal         := 50000; --一次取5000记录循环
  begin
    sp_parameter_two(sp_name, s_parameter);
    if s_parameter = '0'
    then
      s_etl.err_msg := '没有找到对应的过程加载类型数据';
      sp_sbi_w_etl_log(s_etl);
      return;
    end if;
  end;

  /*if postday>=20151231 then
      s_etl.err_msg := postday||'先跑年的数据';
      sp_sbi_w_etl_log(s_etl);
      return;
  end if;*/

  /*select count(1) into total_nums from Fact_Order_Reverse where POSTING_DATE_KEY=postday;
  if total_nums>0 then
     s_etl.err_msg := postday||'已经存在数据了';
      sp_sbi_w_etl_log(s_etl);
      return;
  end if;*/

  if postday < 20050101
  then
    select max(posting_date_key) into crmpostdates from fact_ORDER; -- where CRM_CRD_AT=to_char(20140101);
  else
    crmpostdates := postday;
  end if;
  --先删除那天的数据
  delete from Fact_Order_Reverse
   where Order_obj_ID in
         (select to_number(z.crm_obj_id)
            from odshappigo.ods_order z
            left join (select *
                        from odshappigo.ods_order_cancel
                       where CRM_PRCTYP = 'ZB01'
                            /*2018-06-22添加ZTCMC008=40*/
                         and (ZTCMC008 = '10' -- 上门回收
                             OR ZTCMC008 = '20' --拒收退货
                             OR ZTCMC008 = '30' -- 用户回寄
                             OR ZTCMC008 = '40' --指定回寄快乐购
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
                 /*2018-06-22添加ZTCMC008=40*/
                 and (z.ZTCMC008 = '10' -- 上门回收
                 OR z.ZTCMC008 = '20' --拒收退货
                 OR z.ZTCMC008 = '30' -- 用户回寄
                 OR Z.ZTCMC008 = '40' --指定回寄快乐购
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
                            /*2018-06-22添加ZTCMC008=40*/
                         and (ZTCMC008 = '10' -- 上门回收
                             OR ZTCMC008 = '20' --拒收退货
                             OR ZTCMC008 = '30' -- 用户回寄
                             OR ZTCMC008 = '40' --指定回寄快乐购
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
                 /*2018-06-22添加ZTCMC008=40*/
                 and (z.ZTCMC008 = '10' -- 上门回收
                 OR z.ZTCMC008 = '20' --拒收退货
                 OR z.ZTCMC008 = '30' -- 用户回寄
                 OR Z.ZTCMC008 = '40' --指定回寄快乐购
                 OR z.ZTCMC008 is null)) or z.crm_prctyp = 'ZA08')
             and ((z.zcr_on >= to_char(crmpostdates * 1000000) and
                 z.zcr_on < to_char((crmpostdates + 1) * 1000000) and
                 z.crmpostdat < to_char(crmpostdates)) or
                 z.crmpostdat = to_char(crmpostdates)));

  --POSTING_DATE_KEY = crmpostdates;

  --先插入销售事实表
  insert into fact_goods_sales_reverse
    (SALES_GOODS_ID, --goods sku
     ORDER_KEY, --订单权责制编号
     ORDER_H_KEY, --订单发生制编号
     ADDRESS_KEY, --四级地址编号
     MEMBER_KEY, --会员编号
     MEMBER_GRADE_DESC, --会员等级描述
     MEMBER_GRADE_KEY, --会员等级key
     GOODS_KEY, --goods sku
     GOODS_COMMON_KEY, --goods spu
     TRAN_DESC, --转换类型
     TRAN_TYPE, --0主品，1赠品
     LIVE_STATE, --1是直播
     REPLAY_STATE, --1是重播
     WINDOW_ID, --橱窗标识
     MD_PERSON, --md编号
     SUPPLIER_KEY, --供应商key
     SUPPLIER_TITLE, --供应商key描述
     UNIT_PRICE, --商品单价
     DISCOUNT_PRICE, --单个商品促销金额
     BARGAIN_PRICE, --单个商品成交价格
     NUMS, --数量
     COST_PRICE, --单个商品成本金额
     PURCHASE_PRICE, --单个商品采购价格
     COUPONS_PRICE, --券金额
     POINTS_REWARD, --奖励积分数
     Points_amount, --使用积分数
     Points_total, --使用积分数
     SALES_AMOUNT, --销售总金额
     ORDER_AMOUNT, --订购总金额
     ORDER_NET_AMOUNT, --订购净金额
     PAY_AMOUNT, --应付总金额
     AMOUNT_PAID, --已付金额
     PURCHASE_AMOUNT, --采购总金额
     PROFIT_AMOUNT, --毛利总金额
     TAX_AMOUNT, --税收金额
     Amount_advanced, --预付款金额
     Card_amount, --心意卡金额
     Points_no_amount, --不记积分金额
     Freight_amount, --运费金额
     SALES_SOURCE_KEY,
     SALES_SOURCE_DESC, --销售一级组织
     SALES_SOURCE_SECOND_KEY,
     SALES_SOURCE_SECOND_DESC, --销售二级组织
     order_date_key, --原单订购时间
     order_date,
     order_hour_key,
     order_hour,
     order_type, --订单类型
     Reject_return, --拒收还是退货
     cancel_type, --退货类型
     exchange_type, --换货类型
     posting_date, --过账时间
     posting_date_key,
     posting_hour_key,
     posting_hour,
     cancel_state, --退货状态
     cancel_date_key, --退货取消时间
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
                                                                                                          pay_state,--支付状态
                                                                                                          pay_date_key,--支付时间
                                                                                                          pay_date,
                                                                                                          pay_hour_key,
                                                                                                          pay_hour  */)
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
           -1           as Cancel_person,
           crmpostdates as UPDATE_TIME,
           Z.ZCRMD018   AS ORDER_FROM /*订单来源odshappigo.ods_order.zcrmd018 by yangjin 2018-05-03*/
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
           /*2018-06-22添加ZTCMC008=40*/
           and (Z.ZTCMC008 = '10' -- 上门回收
           OR Z.ZTCMC008 = '20' --拒收退货
           OR Z.ZTCMC008 = '30' -- 用户回寄
           OR Z.ZTCMC008 = '40' --指定回寄快乐购
           OR Z.ZTCMC008 is null)) or z.crm_prctyp = 'ZA08')
       and ((z.zcr_on >= to_char(crmpostdates * 1000000) and
           z.zcr_on < to_char((crmpostdates + 1) * 1000000) and
           z.crmpostdat < to_char(crmpostdates)) or
           z.crmpostdat = to_char(crmpostdates))
    
     order by z.CRM_OBJ_ID asc;

  /*from odshappigo.ods_order z left join 
  (select * from odshappigo.ods_order_cancel where CRM_PRCTYP = 'ZB01' and (ZTCMC008 = '10' -- "上门回收
                          OR ZTCMC008 = '30' -- "用户回寄
                          OR ZTCMC008 = '' OR ZTCMC008 = '20' --拒收退货
                          ) and crm_obj_id in (
                           select crm_obj_id  from odshappigo.ods_order where crmpostdat=to_char(crmpostdates) and CRM_PRCTYP in ('ZB01')
                          )) zc on zc.crm_obj_id=z.crm_obj_id and zc.ztcmc006=z.ztcmc006
     where ((z.CRM_PRCTYP = 'ZB01' and (z.ZTCMC008 = '10' -- "上门回收
                          OR z.ZTCMC008 = '30' -- "用户回寄
                          OR z.ZTCMC008 = '' OR z.ZTCMC008 = '20' --拒收退货
                          )) or z.crm_prctyp = 'ZA08')
                           and z.crmpostdat=to_char(crmpostdates)
     order by z.CRM_OBJ_ID asc;*/
  insert_rows := sql%rowcount;

  --订购事实表数据插入
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
       
       order_date_key, --原单订购时间
       order_date,
       order_hour_key,
       order_hour,
       order_type, --订单类型
       Reject_return, --拒收还是退货
       cancel_type, --退货类型
       exchange_type, --换货类型
       posting_date, --过账时间
       posting_date_key,
       posting_hour_key,
       posting_hour,
       cancel_state, --退货状态
       cancel_date_key, --退货取消时间
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
             min(gs.Member_Grade_desc) as Member_Grade_desc, --会员等级描述
             min(gs.Member_Grade_Key) as Member_Grade_Key, --会员等级key
             min(gs.Sales_Source_key) as Sales_Source_key, --一级销售渠道
             min(gs.Sales_Source_desc) as Sales_Source_desc, --一级销售渠道
             min(gs.Sales_Source_second_key) as Sales_Source_second_key, --二级销售渠道
             min(gs.Sales_Source_second_desc) as Sales_Source_second_desc, --二级销售渠道
             sum(gs.sales_amount) as Sales_amount, --销售金额
             sum(gs.nums) as Order_nums, --商品数量
             sum(gs.nums) as Sku_nums, --sku总数
             
             count(gs.order_key) as spu_nums, --spu总数
             sum(gs.discount_price * gs.nums) as Discount_amount, --商品销售计算的是单个，得乘回来
             sum(gs.Coupons_price * gs.nums) as Counpos_amount, --商品销售计算的是单个，得乘回来
             sum(gs.order_amount) as Order_amount, --订购金额
             sum(gs.order_amount) - sum(gs.COST_PRICE * gs.nums) as Profit_amount, --毛利总金额  订购总金额-总成本金额
             sum(gs.Freight_amount) as Freight_amount, --运费金额
             sum(gs.Cost_price * gs.nums) as Cost_amount, --商品销售计算的是单个，得乘回来
             sum(gs.purchase_price * gs.nums) as Purchase_price, --商品销售计算的是单个，得乘回来
             min(distinct(gs.Pay_amount)) as Pay_amount, --应付金额
             min(distinct(gs.amount_paid)) as Amount_paid, --已付金额
             min(gs.points_total) as Points_total, --积分数量
             min(gs.Points_amount) as Points_amount, --积分金额
             sum(gs.amount_advanced) as Amount_advanced, --预付款金额
             sum(gs.Card_amount) as Card_amount, --心意卡金额
             sum(gs.Points_no_amount) as Points_no_amount, --不计积分金额
             sum(gs.ORDER_NET_AMOUNT) as ORDER_NET_AMOUNT, --订购净金额
             sum(gs.TAX_AMOUNT) as TAX_AMOUNT, --税金金额
             
             min(gs.order_date_key) as order_date_key, --原单订购时间
             min(gs.order_date) as order_date,
             min(gs.order_hour_key) as order_hour_key,
             min(gs.order_hour) as order_hour,
             max(gs.order_type) as order_type, --订单类型
             max(gs.Reject_return) as Reject_return, --拒收还是退货
             max(gs.cancel_type) as cancel_type, --退货类型
             max(gs.exchange_type) as exchange_type, --换货类型
             min(gs.posting_date) as posting_date, --过账时间
             min(gs.posting_date_key) as posting_date_key,
             min(gs.posting_hour_key) as posting_hour_key,
             min(gs.posting_hour) as posting_hour,
             max(gs.cancel_state) as cancel_state, --退货状态
             max(gs.cancel_date_key) as cancel_date_key, --退货取消时间
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
             MIN(GS.ORDER_FROM) AS ORDER_FROM /*订单来源odshappigo.ods_order.zcrmd018 by yangjin 2018-05-03*/
        from fact_goods_sales_reverse gs
       where gs.order_h_key in
             (select to_number(z.crm_obj_id)
                from odshappigo.ods_order z
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
                     /*2018-06-22添加ZTCMC008=40*/
                     and (Z.ZTCMC008 = '10' -- 上门回收
                     OR Z.ZTCMC008 = '20' --拒收退货
                     OR Z.ZTCMC008 = '30' -- 用户回寄
                     OR Z.ZTCMC008 = '40' --指定回寄快乐购
                     OR Z.ZTCMC008 is null)) or z.crm_prctyp = 'ZA08')
                 and ((z.zcr_on >= to_char(crmpostdates * 1000000) and
                     z.zcr_on < to_char((crmpostdates + 1) * 1000000) and
                     z.crmpostdat < to_char(crmpostdates)) or
                     z.crmpostdat = to_char(crmpostdates)))
       group by gs.order_h_key
       order by gs.order_h_key desc;
    s_etl.err_msg := crmpostdates || 'goods数据:' || insert_rows ||
                     '-orders数据:' || sql%rowcount;
  else
    s_etl.err_msg := crmpostdates || 'goods销售表数据未增量';
    sp_sbi_w_etl_log(s_etl);
    return;
  end if;
  commit;

  /*日志记录模块*/
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

