SELECT *
  FROM (SELECT RD2.GOODS_KEY,
               RD2.GOODS_COMMON_KEY,
               RD2.SALES_SOURCE_SECOND_KEY /*销售二级组织key*/,
               '主品' ITEM_OR_GIFT /*主赠品*/,
               RD2.TRAN_TYPE /*交易类型*/,
               DECODE(RD2.TRAN_TYPE, 'TAN', '主品', 'REN', '主品退货') TRAN_TYPE_NAME /*交易类型说明*/,
               RD2.MD_PERSON /*MD员工号*/,
               RD2.POSTING_DATE_KEY /*过账日期*/,
               RD2.LIVE_OR_REPLAY /*直重播*/,
               RD2.TOTAL_ORDER_AMOUNT /*总订购金额*/,
               RD2.NET_ORDER_AMOUNT /*净订购金额*/,
               -RD2.REVERSE_ORDER_AMOUNT - RD2.REJECT_ORDER_AMOUNT +
               RD2.CANCEL_REVERSE_AMOUNT + RD2.CANCEL_REJECT_AMOUNT EFFECTIVE_ORDER_AMOUNT /*有效订购金额= -退货订购金额-拒收订购金额+退货取消订购金额+拒收取消订购金额*/,
               RD2.CANCEL_ORDER_AMOUNT /*取消订购金额*/,
               RD2.REVERSE_ORDER_AMOUNT /*退货订购金额*/,
               RD2.REJECT_ORDER_AMOUNT /*拒收订购金额*/,
               RD2.CANCEL_REVERSE_AMOUNT /*退货取消订购金额*/,
               RD2.CANCEL_REJECT_AMOUNT /*拒收取消订购金额*/,
               RD2.TOTAL_SALES_AMOUNT /*总售价金额*/,
               RD2.NET_SALES_AMOUNT /*净售价金额*/,
               -RD2.REVERSE_SALES_AMOUNT - RD2.REJECT_SALES_AMOUNT +
               RD2.CANCEL_REVERSE_SALES_AMOUNT +
               RD2.CANCEL_REJECT_SALES_AMOUNT EFFECTIVE_SALES_AMOUNT /*有效售价金额= -退货售价金额-拒收售价金额+退货取消售价金额+拒收取消售价金额*/,
               RD2.TOTAL_ORDER_MEMBER_COUNT /*总订购人数*/,
               RD2.NET_ORDER_MEMBER_COUNT /*净订购人数*/,
               -RD2.REVERSE_MEMBER_COUNT - RD2.REJECT_MEMBER_COUNT +
               RD2.CANCEL_REVERSE_MEMBER_COUNT +
               RD2.CANCEL_REJECT_MEMBER_COUNT EFFECTIVE_ORDER_MEMBER_COUNT /*有效订购人数=-退货订购人数-拒收订购人数+退货取消订购人数+拒收取消订购人数*/,
               RD2.CANCEL_ORDER_MEMBER_COUNT /*取消订购人数*/,
               RD2.REVERSE_MEMBER_COUNT /*退货订购人数*/,
               RD2.REJECT_MEMBER_COUNT /*拒收订购人数*/,
               RD2.CANCEL_REVERSE_MEMBER_COUNT /*退货取消订购人数*/,
               RD2.CANCEL_REJECT_MEMBER_COUNT /*拒收取消订购人数*/,
               RD2.TOTAL_ORDER_COUNT /*总订购单数*/,
               RD2.NET_ORDER_COUNT /*净订购单数*/,
               -RD2.REVERSE_COUNT - RD2.REJECT_COUNT +
               RD2.CANCEL_REVERSE_COUNT + RD2.CANCEL_REJECT_COUNT EFFECTIVE_ORDER_COUNT /*有效订购单数*/,
               RD2.CANCEL_ORDER_COUNT /*取消订购单数*/,
               RD2.REVERSE_COUNT /*退货订购单数*/,
               RD2.REJECT_COUNT /*拒收订购单数*/,
               RD2.CANCEL_REVERSE_COUNT /*退货取消订购单数*/,
               RD2.CANCEL_REJECT_COUNT /*拒收取消订购单数*/,
               RD2.GROSS_PROFIT_AMOUNT /*还原后总毛利额*/,
               RD2.NET_PROFIT_AMOUNT /*还原后净毛利额*/,
               (-RD2.REVERSE_SALES_AMOUNT - RD2.REJECT_SALES_AMOUNT +
               RD2.CANCEL_REVERSE_SALES_AMOUNT +
               RD2.CANCEL_REJECT_SALES_AMOUNT) -
               (-RD2.REVERSE_PURCHASE_AMOUNT - RD2.REJECT_PURCHASE_AMOUNT +
               RD2.CANCEL_REVERSE_PURCHASE_AMOUNT +
               RD2.CANCEL_REJECT_PURCHASE_AMOUNT) EFFECTIVE_PROFIT_AMOUNT /*还原后有效毛利额*/,
               RD2.GROSS_PROFIT_RATE /*还原后总毛利率*/,
               RD2.NET_PROFIT_RATE /*还原后净毛利率*/,
               DECODE(-RD2.REVERSE_ORDER_AMOUNT - RD2.REJECT_ORDER_AMOUNT +
                      RD2.CANCEL_REVERSE_AMOUNT + RD2.CANCEL_REJECT_AMOUNT,
                      0,
                      0,
                      ((-RD2.REVERSE_SALES_AMOUNT - RD2.REJECT_SALES_AMOUNT +
                      RD2.CANCEL_REVERSE_SALES_AMOUNT +
                      RD2.CANCEL_REJECT_SALES_AMOUNT) -
                      (-RD2.REVERSE_PURCHASE_AMOUNT -
                      RD2.REJECT_PURCHASE_AMOUNT +
                      RD2.CANCEL_REVERSE_PURCHASE_AMOUNT +
                      RD2.CANCEL_REJECT_PURCHASE_AMOUNT)) /
                      (-RD2.REVERSE_ORDER_AMOUNT - RD2.REJECT_ORDER_AMOUNT +
                      RD2.CANCEL_REVERSE_AMOUNT + RD2.CANCEL_REJECT_AMOUNT)) EFFECTIVE_PROFIT_RATE /*还原后有效毛利率*/,
               RD2.TOTAL_ORDER_QTY /*总订购数量*/,
               RD2.NET_ORDER_QTY /*净订购数量*/,
               -RD2.REVERSE_QTY - RD2.REJECT_QTY + RD2.CANCEL_REVERSE_QTY +
               RD2.CANCEL_REJECT_QTY EFFECTIVE_ORDER_QTY /*有效订购数量= -退货订购数量-拒收订购数量+退货取消订购数量+拒收取消订购数量*/,
               RD2.CANCEL_ORDER_QTY /*取消订购数量*/,
               RD2.REVERSE_QTY /*退货订购数量*/,
               RD2.REJECT_QTY /*拒收订购数量*/,
               RD2.CANCEL_REVERSE_QTY /*退货取消订购数量*/,
               RD2.CANCEL_REJECT_QTY /*拒收取消订购数量*/,
               RD2.NET_ORDER_CUST_PRICE /*净订购客单价*/,
               DECODE(-RD2.REVERSE_MEMBER_COUNT - RD2.REJECT_MEMBER_COUNT +
                      RD2.CANCEL_REVERSE_MEMBER_COUNT +
                      RD2.CANCEL_REJECT_MEMBER_COUNT,
                      0,
                      0,
                      (-RD2.REVERSE_ORDER_AMOUNT - RD2.REJECT_ORDER_AMOUNT +
                      RD2.CANCEL_REVERSE_AMOUNT + RD2.CANCEL_REJECT_AMOUNT) /
                      (-RD2.REVERSE_MEMBER_COUNT - RD2.REJECT_MEMBER_COUNT +
                      RD2.CANCEL_REVERSE_MEMBER_COUNT +
                      RD2.CANCEL_REJECT_MEMBER_COUNT)) EFFECTIVE_ORDER_CUST_PRICE /*有效订购客单价*/,
               RD2.NET_ORDER_UNIT_PRICE /*净订购件单价*/,
               DECODE(-RD2.REVERSE_QTY - RD2.REJECT_QTY +
                      RD2.CANCEL_REVERSE_QTY + RD2.CANCEL_REJECT_QTY,
                      0,
                      0,
                      (-RD2.REVERSE_ORDER_AMOUNT - RD2.REJECT_ORDER_AMOUNT +
                      RD2.CANCEL_REVERSE_AMOUNT + RD2.CANCEL_REJECT_AMOUNT) /
                      (-RD2.REVERSE_QTY - RD2.REJECT_QTY +
                      RD2.CANCEL_REVERSE_QTY + RD2.CANCEL_REJECT_QTY)) EFFECTIVE_ORDER_UNIT_PRICE /*有效订购件单价*/,
               0 TOTAL_PURCHASE_AMOUNT /*总订购成本*/,
               0 NET_PURCHASE_AMOUNT /*净订购成本*/,
               -RD2.REVERSE_PURCHASE_AMOUNT - RD2.REJECT_PURCHASE_AMOUNT +
               RD2.CANCEL_REVERSE_PURCHASE_AMOUNT +
               RD2.CANCEL_REJECT_PURCHASE_AMOUNT EFFECTIVE_PURCHASE_AMOUNT /*有效订购成本=-退货订购成本-拒收订购成本+退货取消订购成本+拒收取消订购成本*/,
               RD2.PROFIT_AMOUNT PROFIT_AMOUNT /*折扣金额*/,
               RD2.COUPONS_AMOUNT COUPONS_AMOUNT /*优惠券金额*/,
               RD2.FREIGHT_AMOUNT FREIGHT_AMOUNT /*运费*/,
               0 PRODUCT_AVG_PRICE /*商品平均售价*/,
               - (-RD2.REVERSE_ORDER_AMOUNT - RD2.REJECT_ORDER_AMOUNT +
                 RD2.CANCEL_REVERSE_AMOUNT + RD2.CANCEL_REJECT_AMOUNT) REJECT_AMOUNT /*拒退金额*/
          FROM (SELECT RD1.GOODS_KEY,
                       RD1.GOODS_COMMON_KEY,
                       RD1.SALES_SOURCE_SECOND_KEY /*销售二级组织key*/,
                       RD1.TRAN_DESC TRAN_TYPE /*交易类型*/,
                       RD1.MD_PERSON /*MD员工号*/,
                       RD1.POSTING_DATE_KEY /*过账日期*/,
                       DECODE(RD1.LIVE_OR_REPLAY,
                              '10',
                              '直播',
                              '01',
                              '重播',
                              '未分配') LIVE_OR_REPLAY,
                       0 TOTAL_ORDER_AMOUNT /*总订购金额*/,
                       0 NET_ORDER_AMOUNT /*净订购金额*/,
                       0 CANCEL_ORDER_AMOUNT /*取消订购金额*/,
                       SUM(DECODE(RD1.CANCEL_STATE,
                                  0,
                                  DECODE(RD1.CANCEL_REASON,
                                         10,
                                         RD1.ORDER_AMOUNT,
                                         30,
                                         RD1.ORDER_AMOUNT,
                                         20,
                                         0),
                                  0)) REVERSE_ORDER_AMOUNT /*退货订购金额*/,
                       SUM(DECODE(RD1.CANCEL_STATE,
                                  0,
                                  DECODE(RD1.CANCEL_REASON,
                                         20,
                                         RD1.ORDER_AMOUNT,
                                         0),
                                  0)) REJECT_ORDER_AMOUNT /*拒收订购金额*/,
                       SUM(DECODE(RD1.CANCEL_STATE,
                                  1,
                                  DECODE(RD1.CANCEL_REASON,
                                         10,
                                         RD1.ORDER_AMOUNT,
                                         30,
                                         RD1.ORDER_AMOUNT,
                                         20,
                                         0),
                                  0)) CANCEL_REVERSE_AMOUNT /*退货取消订购金额*/,
                       SUM(DECODE(RD1.CANCEL_STATE,
                                  1,
                                  DECODE(RD1.CANCEL_REASON,
                                         20,
                                         RD1.ORDER_AMOUNT,
                                         0),
                                  0)) CANCEL_REJECT_AMOUNT /*拒收取消订购金额*/,
                       0 TOTAL_SALES_AMOUNT /*总售价金额*/,
                       0 NET_SALES_AMOUNT /*净售价金额*/,
                       SUM(DECODE(RD1.CANCEL_STATE,
                                  0,
                                  DECODE(RD1.CANCEL_REASON,
                                         10,
                                         RD1.SALES_AMOUNT,
                                         30,
                                         RD1.SALES_AMOUNT,
                                         20,
                                         0),
                                  0)) REVERSE_SALES_AMOUNT /*退货售价金额*/,
                       SUM(DECODE(RD1.CANCEL_STATE,
                                  0,
                                  DECODE(RD1.CANCEL_REASON,
                                         20,
                                         RD1.SALES_AMOUNT,
                                         0),
                                  0)) REJECT_SALES_AMOUNT /*拒收售价金额*/,
                       SUM(DECODE(RD1.CANCEL_STATE,
                                  1,
                                  DECODE(RD1.CANCEL_REASON,
                                         10,
                                         RD1.SALES_AMOUNT,
                                         30,
                                         RD1.SALES_AMOUNT,
                                         20,
                                         0),
                                  0)) CANCEL_REVERSE_SALES_AMOUNT /*退货取消售价金额*/,
                       SUM(DECODE(RD1.CANCEL_STATE,
                                  1,
                                  DECODE(RD1.CANCEL_REASON,
                                         20,
                                         RD1.SALES_AMOUNT,
                                         0),
                                  0)) CANCEL_REJECT_SALES_AMOUNT /*拒收取消售价金额*/,
                       0 TOTAL_ORDER_MEMBER_COUNT /*总订购人数*/,
                       0 NET_ORDER_MEMBER_COUNT /*净订购人数*/,
                       0 CANCEL_ORDER_MEMBER_COUNT /*取消订购人数*/,
                       COUNT(DISTINCT DECODE(RD1.CANCEL_STATE,
                                    0,
                                    DECODE(RD1.CANCEL_REASON,
                                           10,
                                           RD1.MEMBER_KEY,
                                           30,
                                           RD1.MEMBER_KEY,
                                           NULL),
                                    0)) REVERSE_MEMBER_COUNT /*退货订购人数*/,
                       COUNT(DISTINCT DECODE(RD1.CANCEL_STATE,
                                    0,
                                    DECODE(RD1.CANCEL_REASON,
                                           20,
                                           RD1.MEMBER_KEY,
                                           NULL),
                                    0)) REJECT_MEMBER_COUNT /*拒收订购人数*/,
                       COUNT(DISTINCT DECODE(RD1.CANCEL_STATE,
                                    1,
                                    DECODE(RD1.CANCEL_REASON,
                                           10,
                                           RD1.MEMBER_KEY,
                                           30,
                                           RD1.MEMBER_KEY,
                                           NULL),
                                    0)) CANCEL_REVERSE_MEMBER_COUNT /*退货取消订购人数*/,
                       COUNT(DISTINCT DECODE(RD1.CANCEL_STATE,
                                    1,
                                    DECODE(RD1.CANCEL_REASON,
                                           20,
                                           RD1.MEMBER_KEY,
                                           NULL),
                                    0)) CANCEL_REJECT_MEMBER_COUNT /*拒收取消订购人数*/,
                       0 TOTAL_ORDER_COUNT /*总订购单数*/,
                       0 NET_ORDER_COUNT /*净订购单数*/,
                       0 CANCEL_ORDER_COUNT /*取消订购单数*/,
                       COUNT(DISTINCT DECODE(RD1.CANCEL_STATE,
                                    0,
                                    DECODE(RD1.CANCEL_REASON,
                                           10,
                                           RD1.ORDER_H_KEY,
                                           30,
                                           RD1.ORDER_H_KEY,
                                           NULL),
                                    0)) REVERSE_COUNT /*退货订购单数*/,
                       COUNT(DISTINCT DECODE(RD1.CANCEL_STATE,
                                    0,
                                    DECODE(RD1.CANCEL_REASON,
                                           20,
                                           RD1.ORDER_H_KEY,
                                           NULL),
                                    0)) REJECT_COUNT /*拒收订购单数*/,
                       COUNT(DISTINCT DECODE(RD1.CANCEL_STATE,
                                    1,
                                    DECODE(RD1.CANCEL_REASON,
                                           10,
                                           RD1.ORDER_H_KEY,
                                           30,
                                           RD1.ORDER_H_KEY,
                                           NULL),
                                    0)) CANCEL_REVERSE_COUNT /*退货取消订购单数*/,
                       COUNT(DISTINCT DECODE(RD1.CANCEL_STATE,
                                    1,
                                    DECODE(RD1.CANCEL_REASON,
                                           20,
                                           RD1.ORDER_H_KEY,
                                           NULL),
                                    0)) CANCEL_REJECT_COUNT /*拒收取消订购单数*/,
                       0 GROSS_PROFIT_AMOUNT /*还原后总毛利额*/,
                       0 NET_PROFIT_AMOUNT /*还原后净毛利额*/,
                       0 GROSS_PROFIT_RATE /*还原后总毛利率*/,
                       0 NET_PROFIT_RATE /*还原后净毛利率*/,
                       0 TOTAL_ORDER_QTY /*总订购数量*/,
                       0 NET_ORDER_QTY /*净订购数量*/,
                       0 CANCEL_ORDER_QTY /*取消订购数量*/,
                       SUM(DECODE(RD1.CANCEL_STATE,
                                  0,
                                  DECODE(RD1.CANCEL_REASON,
                                         10,
                                         RD1.NUMS,
                                         30,
                                         RD1.NUMS,
                                         20,
                                         0),
                                  0)) REVERSE_QTY /*退货订购数量*/,
                       SUM(DECODE(RD1.CANCEL_STATE,
                                  0,
                                  DECODE(RD1.CANCEL_REASON, 20, RD1.NUMS, 0),
                                  0)) REJECT_QTY /*拒收订购数量*/,
                       SUM(DECODE(RD1.CANCEL_STATE,
                                  1,
                                  DECODE(RD1.CANCEL_REASON,
                                         10,
                                         RD1.NUMS,
                                         30,
                                         RD1.NUMS,
                                         20,
                                         0),
                                  0)) CANCEL_REVERSE_QTY /*退货取消订购数量*/,
                       SUM(DECODE(RD1.CANCEL_STATE,
                                  1,
                                  DECODE(RD1.CANCEL_REASON, 20, RD1.NUMS, 0),
                                  0)) CANCEL_REJECT_QTY /*拒收取消订购数量*/,
                       0 NET_ORDER_CUST_PRICE /*净订购客单价*/,
                       0 NET_ORDER_UNIT_PRICE /*净订购件单价*/,
                       SUM(DECODE(RD1.CANCEL_STATE,
                                  0,
                                  DECODE(RD1.CANCEL_REASON,
                                         10,
                                         RD1.PURCHASE_AMOUNT,
                                         30,
                                         RD1.PURCHASE_AMOUNT,
                                         20,
                                         0),
                                  0)) REVERSE_PURCHASE_AMOUNT /*退货订购成本*/,
                       SUM(DECODE(RD1.CANCEL_STATE,
                                  0,
                                  DECODE(RD1.CANCEL_REASON,
                                         20,
                                         RD1.PURCHASE_AMOUNT,
                                         0),
                                  0)) REJECT_PURCHASE_AMOUNT /*拒收订购成本*/,
                       SUM(DECODE(RD1.CANCEL_STATE,
                                  1,
                                  DECODE(RD1.CANCEL_REASON,
                                         10,
                                         RD1.PURCHASE_AMOUNT,
                                         30,
                                         RD1.PURCHASE_AMOUNT,
                                         20,
                                         0),
                                  0)) CANCEL_REVERSE_PURCHASE_AMOUNT /*退货取消订购成本*/,
                       SUM(DECODE(RD1.CANCEL_STATE,
                                  1,
                                  DECODE(RD1.CANCEL_REASON,
                                         20,
                                         RD1.PURCHASE_AMOUNT,
                                         0),
                                  0)) CANCEL_REJECT_PURCHASE_AMOUNT /*拒收取消订购成本*/,
                       SUM(RD1.PROFIT_AMOUNT) PROFIT_AMOUNT /*折扣金额*/,
                       SUM(RD1.COUPONS_AMOUNT) COUPONS_AMOUNT /*优惠券金额*/,
                       SUM(RD1.FREIGHT_AMOUNT) FREIGHT_AMOUNT /*运费*/
                  FROM (SELECT RD.ORDER_KEY /*订单权责制*/,
                               RD.ORDER_H_KEY /*订单发生制*/,
                               RD.CANCEL_REASON /*退货类型*/,
                               RD.CANCEL_STATE /*退货状态*/,
                               RD.GOODS_KEY /*商品*/,
                               RD.GOODS_COMMON_KEY /*商品短编码*/,
                               RD.SALES_SOURCE_SECOND_KEY /*销售二级组织key*/,
                               RD.TRAN_TYPE /*是否赠品标志*/,
                               RD.TRAN_DESC /*交易类型*/,
                               RD.MD_PERSON /*MD工号*/,
                               RD.POSTING_DATE_KEY /*过账日期key*/,
                               TO_CHAR(RD.LIVE_STATE) ||
                               TO_CHAR(RD.REPLAY_STATE) LIVE_OR_REPLAY /*直播重播*/,
                               RD.MEMBER_KEY /*会员key*/,
                               RD.ORDER_AMOUNT /*退货订购金额*/,
                               RD.NUMS /*总订购数量*/,
                               RD.SALES_AMOUNT /*总售价金额*/,
                               RD.UNIT_PRICE /*单个商品售价*/,
                               RD.COST_PRICE /*商品单件成本*/,
                               RD.FREIGHT_AMOUNT /*运费*/,
                               RD.COUPONS_AMOUNT /*优惠券金额*/,
                               RD.PURCHASE_AMOUNT /*总订购成本*/,
                               RD.PROFIT_AMOUNT /*折扣金额*/
                          FROM (
                                
                                /*取消的订单，按过账日期POSTING_DATE_KEY记正向订单。
                                2017-06-15 yangjin*/
                                SELECT RDU1.ORDER_KEY /*订单权责制*/,
                                        RDU1.ORDER_H_KEY /*订单发生制*/,
                                        RDU1.CANCEL_REASON /*退货类型*/,
                                        CASE
                                          WHEN RDU1.CANCEL_STATE = 1 AND
                                               RDU1.POSTING_DATE_KEY <=
                                               RDU1.UPDATE_TIME THEN
                                           0
                                          ELSE
                                           RDU1.CANCEL_STATE
                                        END CANCEL_STATE /*退货状态*/,
                                        RDU1.GOODS_KEY /*商品*/,
                                        RDU1.GOODS_COMMON_KEY /*商品短编码*/,
                                        RDU1.SALES_SOURCE_SECOND_KEY /*销售二级组织key*/,
                                        RDU1.TRAN_TYPE /*是否赠品标志*/,
                                        RDU1.TRAN_DESC /*交易类型*/,
                                        RDU1.MD_PERSON /*MD工号*/,
                                        RDU1.POSTING_DATE_KEY /*过账日期key*/,
                                        RDU1.LIVE_STATE /*是否直播*/,
                                        RDU1.REPLAY_STATE /*是否重播*/,
                                        RDU1.MEMBER_KEY /*会员key*/,
                                        RDU1.ORDER_AMOUNT /*退货订购金额*/,
                                        RDU1.NUMS /*总订购数量*/,
                                        RDU1.SALES_AMOUNT /*总售价金额*/,
                                        RDU1.UNIT_PRICE /*单个商品售价*/,
                                        RDU1.COST_PRICE /*商品单件成本*/,
                                        RDU1.FREIGHT_AMOUNT /*运费*/,
                                        RDU1.COUPONS_PRICE COUPONS_AMOUNT /*优惠券金额*/,
                                        RDU1.PURCHASE_AMOUNT /*总订购成本*/,
                                        RDU1.PROFIT_AMOUNT /*折扣金额*/
                                  FROM FACT_GOODS_SALES_REVERSE RDU1
                                 WHERE RDU1.CANCEL_REASON IN (10, 20, 30)
                                   AND RDU1.TRAN_DESC = 'REN'
                                      /*2018-03-15剔除扫码购销售，FACT_EC_ORDER_2.order_from=76为扫码购销售*/
                                   AND NOT EXISTS
                                 (SELECT 1
                                          FROM FACT_EC_ORDER_2 FEO
                                         WHERE RDU1.ORDER_KEY = FEO.CRM_ORDER_NO
                                           AND FEO.ORDER_FROM = '76')
                                UNION ALL
                                /*取消的订单，按过账日期POSTING_DATE_KEY记逆向订单。
                                2017-06-15 yangjin*/
                                SELECT RDU2.ORDER_KEY /*订单权责制*/,
                                        RDU2.ORDER_H_KEY /*订单发生制*/,
                                        RDU2.CANCEL_REASON /*退货类型*/,
                                        RDU2.CANCEL_STATE /*退货状态*/,
                                        RDU2.GOODS_KEY /*商品*/,
                                        RDU2.GOODS_COMMON_KEY /*商品短编码*/,
                                        RDU2.SALES_SOURCE_SECOND_KEY /*销售二级组织key*/,
                                        RDU2.TRAN_TYPE /*是否赠品标志*/,
                                        RDU2.TRAN_DESC /*交易类型*/,
                                        RDU2.MD_PERSON /*MD工号*/,
                                        RDU2.UPDATE_TIME             POSTING_DATE_KEY /*过账日期key*/,
                                        RDU2.LIVE_STATE /*是否直播*/,
                                        RDU2.REPLAY_STATE /*是否重播*/,
                                        RDU2.MEMBER_KEY /*会员key*/,
                                        RDU2.ORDER_AMOUNT /*退货订购金额*/,
                                        RDU2.NUMS /*总订购数量*/,
                                        RDU2.SALES_AMOUNT /*总售价金额*/,
                                        RDU2.UNIT_PRICE /*单个商品售价*/,
                                        RDU2.COST_PRICE /*商品单件成本*/,
                                        RDU2.FREIGHT_AMOUNT /*运费*/,
                                        RDU2.COUPONS_PRICE           COUPONS_AMOUNT /*优惠券金额*/,
                                        RDU2.PURCHASE_AMOUNT /*总订购成本*/,
                                        RDU2.PROFIT_AMOUNT /*折扣金额*/
                                  FROM FACT_GOODS_SALES_REVERSE RDU2
                                 WHERE RDU2.CANCEL_REASON IN (10, 20, 30)
                                   AND RDU2.TRAN_DESC = 'REN'
                                   AND RDU2.CANCEL_STATE = 1
                                   AND RDU2.POSTING_DATE_KEY <= RDU2.UPDATE_TIME
                                      /*2018-03-15剔除扫码购销售，FACT_EC_ORDER_2.order_from=76为扫码购销售*/
                                   AND NOT EXISTS
                                 (SELECT 1
                                          FROM FACT_EC_ORDER_2 FEO
                                         WHERE RDU2.ORDER_KEY = FEO.CRM_ORDER_NO
                                           AND FEO.ORDER_FROM = '76')) RD
                         WHERE RD.POSTING_DATE_KEY = &IN_POSTING_DATE_KEY
                           AND RD.CANCEL_REASON IN (10, 20, 30)
                           AND RD.TRAN_DESC = 'REN') RD1
                 GROUP BY RD1.GOODS_KEY,
                          RD1.GOODS_COMMON_KEY,
                          RD1.SALES_SOURCE_SECOND_KEY,
                          RD1.TRAN_DESC,
                          RD1.MD_PERSON,
                          RD1.POSTING_DATE_KEY,
                          DECODE(RD1.LIVE_OR_REPLAY,
                                 '10',
                                 '直播',
                                 '01',
                                 '重播',
                                 '未分配')) RD2) A1
 WHERE A1.SALES_SOURCE_SECOND_KEY = 20017
   AND A1.GOODS_COMMON_KEY = 235272;
