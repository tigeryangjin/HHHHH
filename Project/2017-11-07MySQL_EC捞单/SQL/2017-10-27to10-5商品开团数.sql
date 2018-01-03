#商品开团数
SELECT
  b.item_code  商品编码,
  b.goods_name 商品名称,
  c.cnt        开团数
FROM (SELECT
        d.goods_commonid,
        d.item_code,
        d.goods_name
      FROM ec_goods d) b, (
                            SELECT
                              a.goods_commonid,
                              count(1) cnt
                            FROM ec_group_purchase_task a
                            WHERE
                              a.add_time > UNIX_TIMESTAMP('2017-12-15') AND a.add_time < UNIX_TIMESTAMP('2017-12-25')
                            GROUP BY a.goods_commonid) c
WHERE b.goods_commonid = c.goods_commonid
ORDER BY c.cnt DESC;

#商品成团数
SELECT
  b.item_code  商品编码,
  b.goods_name 商品名称,
  c.cnt        成团数
FROM (SELECT
        d.goods_commonid,
        d.item_code,
        d.goods_name
      FROM ec_goods d) b, (
                            SELECT
                              a.goods_commonid,
                              count(1) cnt
                            FROM ec_group_purchase_task a
                            WHERE
                              a.add_time > UNIX_TIMESTAMP('2017-11-24') AND a.add_time < UNIX_TIMESTAMP('2017-11-30')
                              AND a.task_state IN (10)
                            GROUP BY a.goods_commonid) c
WHERE b.goods_commonid = c.goods_commonid
ORDER BY c.cnt DESC;

SELECT
  d.cdate        日期,
  d.order_sn     订单编号,
  f.item_code    商品编码,
  f.goods_name   商品名称,
  f.goods_price  快乐价,
  d.head_price   团长价,
  d.member_price 团员价,
  d.order_amount 支付金额
FROM (SELECT
        e.goods_commonid,
        e.item_code,
        e.goods_name,
        e.goods_price
      FROM ec_goods e) f, (SELECT
                             b.cdate,
                             c.order_sn,
                             b.goods_commonid,
                             b.head_price,
                             b.member_price,
                             c.order_amount
                           FROM (
                                  SELECT
                                    from_unixtime(a.add_time, '%Y-%m-%d') cdate,
                                    a.goods_commonid,
                                    a.order_sn,
                                    g.head_price,
                                    g.member_price
                                  FROM ec_group_purchase_task a, ec_group_purchase_rule g
                                  WHERE a.rule_id = g.id AND a.goods_commonid = g.goods_commonid
                                        AND a.add_time > UNIX_TIMESTAMP('2017-11-10') AND
                                        a.add_time < UNIX_TIMESTAMP('2017-11-13')
                                        AND a.task_state IN (10)) b, ec_order C
                           WHERE b.order_sn = c.order_sn) d
WHERE f.goods_commonid = d.goods_commonid
ORDER BY d.cdate, f.item_code;


#开团数
SELECT count(1)
FROM ec_group_purchase_task
WHERE
  add_time > UNIX_TIMESTAMP('2017-11-24') AND add_time < UNIX_TIMESTAMP('2017-11-30');

#成团数
SELECT count(1)
FROM ec_group_purchase_task
WHERE
  add_time > UNIX_TIMESTAMP('2017-11-24') AND add_time < UNIX_TIMESTAMP('2017-11-30')
  AND task_state IN (10);

#参与人数
SELECT count(1)
FROM ec_group_purchase_task_member
WHERE
  add_time > UNIX_TIMESTAMP('2017-11-24') AND add_time < UNIX_TIMESTAMP('2017-11-30');

#支付
SELECT count(1)
FROM ec_group_purchase_task_member
WHERE
  add_time > UNIX_TIMESTAMP('2017-11-24') AND add_time < UNIX_TIMESTAMP('2017-11-30')
  AND join_state IN (1, 6);