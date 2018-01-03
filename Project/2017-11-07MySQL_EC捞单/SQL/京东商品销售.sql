#月、大类、销售额、毛利额、毛利率、订购件数
SELECT
  substr(FROM_UNIXTIME(o.add_time), 1, 7)                                                      月份,
  c.matdl                                                                                      大类编码,
  c.matdlt                                                                                     大类名称,
  sum(og.goods_num * og.goods_pay_price)                                                       销售金额,
  sum(og.goods_num * (og.goods_pay_price - jd.price))                                          毛利额,
  sum(og.goods_num * (og.goods_pay_price - jd.price)) / sum(og.goods_num * og.goods_pay_price) 毛利率,
  sum(og.goods_num)                                                                            订购件数
FROM ec_order o, ec_order_goods og, ec_goods g, (SELECT DISTINCT
                                                   m.matdl,
                                                   m.matdlt,
                                                   m.gc_id
                                                 FROM ec_erp_mat m) c, ec_jd_goods jd
WHERE o.order_id = og.order_id AND og.goods_id = g.goods_id AND g.gc_id = c.gc_id AND g.item_code = jd.itemCode AND
      o.order_state >= '20'
      AND og.supplier_id = 120595 /*京东商品*/
#AND o.store_id > 5
#AND o.add_time >= UNIX_TIMESTAMP('2017-05-01 00:00')
GROUP BY substr(FROM_UNIXTIME(o.add_time), 1, 7),
  c.matdl,
  c.matdlt
ORDER BY substr(FROM_UNIXTIME(o.add_time), 1, 7),
  c.matdl;

