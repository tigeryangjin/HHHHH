SELECT *
  FROM (SELECT OD.ORDER_KEY /*订单权责制*/,
               OD.ORDER_H_KEY /*订单发生制*/,
               OD.ORDER_DESC /*订购状态*/,
               OD.GOODS_KEY /*商品*/,
               OD.GOODS_COMMON_KEY /*商品短编码*/,
               OD.SALES_SOURCE_SECOND_KEY /*销售二级组织key*/,
               OD.TRAN_TYPE /*是否赠品标志*/,
               OD.TRAN_DESC /*交易类型*/,
               OD.MD_PERSON /*MD工号*/,
               OD.POSTING_DATE_KEY /*过账日期key*/,
               TO_CHAR(OD.LIVE_STATE) || TO_CHAR(OD.REPLAY_STATE) LIVE_OR_REPLAY /*直播重播*/,
               OD.ORDER_STATE /*订单状态*/,
               OD.CANCEL_STATE /*取消状态*/,
               OD.MEMBER_KEY /*会员key*/,
               OD.NUMS TOTAL_ORDER_QTY /*总订购数量*/,
               OD.NUMS NET_ORDER_QTY /*净订购数量*/,
               OD.NUMS EFFECTIVE_ORDER_QTY /*有效订购数量*/,
               OD.ORDER_AMOUNT TOTAL_ORDER_AMOUNT /*总订单金额*/,
               OD.ORDER_AMOUNT NET_ORDER_AMOUNT /*净订购金额*/,
               OD.ORDER_AMOUNT EFFECTIVE_ORDER_AMOUNT /*有效订购金额*/,
               OD.SALES_AMOUNT TOTAL_SALES_AMOUNT /*总售价金额*/,
               OD.SALES_AMOUNT NET_SALES_AMOUNT /*净订购金额*/,
               OD.SALES_AMOUNT EFFECTIVE_SALES_AMOUNT /*有效订购金额*/,
               OD.UNIT_PRICE /*单个商品售价*/,
               OD.COST_PRICE /*商品单件成本*/,
               OD.FREIGHT_AMOUNT /*运费*/,
               OD.COUPONS_PRICE COUPONS_AMOUNT /*优惠券金额*/,
               OD.PURCHASE_AMOUNT TOTAL_PURCHASE_AMOUNT /*总订购成本*/,
               OD.PURCHASE_AMOUNT NET_PURCHASE_AMOUNT /*净订购成本*/,
               OD.PURCHASE_AMOUNT EFFECTIVE_PURCHASE_AMOUNT /*有效订购成本*/,
               OD.PROFIT_AMOUNT /*折扣金额*/
          FROM (
                /*取消的订单，按过账日期POSTING_DATE_KEY记正向订单。
                2017-06-14 yangjin*/
                SELECT ODU1.ORDER_KEY /*订单权责制*/,
                        ODU1.ORDER_H_KEY /*订单发生制*/,
                        ODU1.ORDER_DESC /*订购状态*/,
                        ODU1.GOODS_KEY /*商品*/,
                        ODU1.GOODS_COMMON_KEY /*商品短编码*/,
                        ODU1.SALES_SOURCE_SECOND_KEY /*销售二级组织key*/,
                        ODU1.TRAN_TYPE /*是否赠品标志*/,
                        ODU1.TRAN_DESC /*交易类型*/,
                        ODU1.MD_PERSON /*MD工号*/,
                        ODU1.POSTING_DATE_KEY /*过账日期key*/,
                        ODU1.LIVE_STATE /*是否直播*/,
                        ODU1.REPLAY_STATE /*是否重播*/,
                        ODU1.ORDER_STATE /*订单状态*/,
                        CASE
                          WHEN ODU1.CANCEL_STATE = 1 AND
                               ODU1.POSTING_DATE_KEY <= ODU1.UPDATE_TIME THEN
                           0
                          ELSE
                           ODU1.CANCEL_STATE
                        END CANCEL_STATE /*取消状态*/,
                        ODU1.MEMBER_KEY /*会员key*/,
                        ODU1.NUMS,
                        ODU1.ORDER_AMOUNT,
                        ODU1.SALES_AMOUNT,
                        ODU1.UNIT_PRICE /*单个商品售价*/,
                        ODU1.COST_PRICE /*商品单件成本*/,
                        ODU1.FREIGHT_AMOUNT /*运费*/,
                        ODU1.COUPONS_PRICE /*优惠券金额*/,
                        ODU1.PURCHASE_AMOUNT /*订购成本*/,
                        ODU1.PROFIT_AMOUNT /*折扣金额*/
                  FROM FACT_GOODS_SALES ODU1
                 WHERE
                /*2018-03-15剔除扫码购销售，FACT_EC_ORDER_2.order_from=76为扫码购销售*/
                 NOT EXISTS (SELECT 1
                    FROM FACT_EC_ORDER_2 FEO
                   WHERE ODU1.ORDER_KEY = FEO.CRM_ORDER_NO
                     AND FEO.ORDER_FROM = '76')
                
                UNION ALL
                /*取消的订单，按更新日期UPDATE_TIME记逆向订单（虚拟记录）。
                2017-06-14 yangjin*/
                SELECT ODU2.ORDER_KEY /*订单权责制*/,
                        ODU2.ORDER_H_KEY /*订单发生制*/,
                        ODU2.ORDER_DESC /*订购状态*/,
                        ODU2.GOODS_KEY /*商品*/,
                        ODU2.GOODS_COMMON_KEY /*商品短编码*/,
                        ODU2.SALES_SOURCE_SECOND_KEY /*销售二级组织key*/,
                        ODU2.TRAN_TYPE /*是否赠品标志*/,
                        ODU2.TRAN_DESC /*交易类型*/,
                        ODU2.MD_PERSON /*MD工号*/,
                        ODU2.UPDATE_TIME POSTING_DATE_KEY /*过账日期key*/,
                        ODU2.LIVE_STATE /*是否直播*/,
                        ODU2.REPLAY_STATE /*是否重播*/,
                        ODU2.ORDER_STATE /*订单状态*/,
                        ODU2.CANCEL_STATE /*取消状态*/,
                        ODU2.MEMBER_KEY /*会员key*/,
                        ODU2.NUMS,
                        ODU2.ORDER_AMOUNT,
                        ODU2.SALES_AMOUNT,
                        ODU2.UNIT_PRICE /*单个商品售价*/,
                        ODU2.COST_PRICE /*商品单件成本*/,
                        ODU2.FREIGHT_AMOUNT /*运费*/,
                        ODU2.COUPONS_PRICE /*优惠券金额*/,
                        ODU2.PURCHASE_AMOUNT,
                        ODU2.PROFIT_AMOUNT /*折扣金额*/
                  FROM FACT_GOODS_SALES ODU2
                 WHERE ODU2.CANCEL_STATE = 1
                   AND ODU2.CANCEL_BEFORE_STATE = 1 /*发货前取消的订单才虚拟出记录*/
                   AND ODU2.POSTING_DATE_KEY <= ODU2.UPDATE_TIME
                      /*2018-03-15剔除扫码购销售，FACT_EC_ORDER_2.order_from=76为扫码购销售*/
                   AND NOT EXISTS
                 (SELECT 1
                          FROM FACT_EC_ORDER_2 FEO
                         WHERE ODU2.ORDER_KEY = FEO.CRM_ORDER_NO
                           AND FEO.ORDER_FROM = '76')) OD
         WHERE OD.POSTING_DATE_KEY = &IN_POSTING_DATE_KEY
           AND OD.TRAN_TYPE = 0 /*只显示主品*/
        ) A1
 WHERE A1.SALES_SOURCE_SECOND_KEY = 20017
   AND A1.GOODS_COMMON_KEY = 235272;

