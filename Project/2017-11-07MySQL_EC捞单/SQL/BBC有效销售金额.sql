#月份 店铺名 EC分类 有效金额 有效件数
SELECT
  od.order_month       月份,
  od.store_name        店铺名,
  c.gc_id              ec分类编码,
  c.gc_name            ec分类名称,
  sum(od.order_amount) 有效金额,
  sum(od.order_qty)    有效件数
FROM (
       SELECT
         substr(FROM_UNIXTIME(o.add_time), 1, 7) order_month,
         o.store_name,
         g.goods_commonid,
         sum(g.goods_num * g.goods_pay_price)    order_amount,
         sum(g.goods_num)                        order_qty
       FROM ec_order o, ec_order_goods g
       WHERE o.order_id = g.order_id AND o.order_state >= '20'
             AND o.store_id > 5
             AND o.add_time >= UNIX_TIMESTAMP('2017-05-01 00:00')
       GROUP BY substr(FROM_UNIXTIME(o.add_time), 1, 7),
         o.store_name,
         g.goods_commonid) od, (SELECT DISTINCT
                                  b.gc_id,
                                  b.gc_name,
                                  a.goods_commonid
                                FROM ec_goods a, ec_goods_class b
                                WHERE a.gc_id = b.gc_id) c
WHERE od.goods_commonid = c.goods_commonid
GROUP BY od.order_month,
  od.store_name,
  c.gc_id,
  c.gc_name
ORDER BY od.order_month,
  od.store_name,
  c.gc_id;

SELECT
  substr(FROM_UNIXTIME(o.add_time), 1, 7) 月份,
  o.store_name                            店铺名,
  concat(c.gc_id, '|', c.gc_name)         ec分类,
  sum(og.goods_num * og.goods_pay_price)  有效金额,
  sum(og.goods_num)                       有效件数
FROM ec_order o, ec_order_goods og, ec_goods g, ec_goods_class c
WHERE o.order_id = og.order_id AND og.goods_id = g.goods_id AND g.gc_id = c.gc_id AND o.order_state >= '20'
      AND o.store_id > 5
      AND o.add_time >= UNIX_TIMESTAMP('2017-05-01 00:00')
GROUP BY substr(FROM_UNIXTIME(o.add_time), 1, 7),
  o.store_name,
  concat(c.gc_id, c.gc_name);