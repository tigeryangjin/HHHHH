/*快乐币-新版*/
SELECT
  COUNT(DISTINCT (a.order_id))                     AS '订单数',
  SUM(a.goods_num * a.extra_point * c.give_points) AS '快乐币发放数',
  SUM(B.integrals_sum)                             AS '快乐币使用数'
FROM ec_order_goods AS a LEFT JOIN ec_order AS b ON a.order_id = b.order_id
  LEFT JOIN ec_goods AS c ON a.goods_id = c.goods_id
WHERE
  b.order_state >= 20 AND b.add_time >= UNIX_TIMESTAMP('2017-08-01') AND b.add_time < UNIX_TIMESTAMP('2017-09-01') AND
  a.extra_point > 0;