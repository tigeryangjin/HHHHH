/*优惠券订单级捞单SQL*/
SELECT
  voucher_ref                 AS '券号',
  voucher_name                AS '券名称',
  voucher_price               AS '券名称',
  cust_no                     AS '顾客编号',
  member_level                AS '会员等级',
  CONCAT('`', order_sn)       AS '订单编号',
  CONCAT('`', a.erp_order_no) AS 'ERP订单编号',
  goods_amount                AS '商品金额',
  order_amount                AS '订单金额',
  FROM_UNIXTIME(add_time)     AS '下单时间'
FROM happigo_ec.ec_order a, happigo_ec.ec_order_common b
WHERE a.order_id = b.order_id
      AND a.order_state >= '20' AND add_time >= UNIX_TIMESTAMP('2017-10-20 00:00:00') AND
      add_time <= UNIX_TIMESTAMP('2017-10-23 00:00')
      AND b.voucher_ref IN
          ('4269', '4270', '4271', '4272', '4273', '4274', '4275', '4276', '4277', '4278')
ORDER BY voucher_ref, a.order_id;

/*优惠券商品级捞单SQL*/
SELECT
  voucher_ref                 AS '券号',
  voucher_name                AS '券名称',
  voucher_price               AS '券名称',
  cust_no                     AS '顾客编号',
  member_level                AS '会员等级',
  CONCAT('`', order_sn)       AS '订单编号',
  CONCAT('`', a.erp_order_no) AS 'ERP订单编号',
  goods_amount                AS '商品金额',
  order_amount                AS '订单金额',
  FROM_UNIXTIME(add_time)     AS '下单时间',
  erp_code                    AS '商品编号',
  goods_name                  AS '商品名称',
  goods_num                   AS '商品数量'
FROM happigo_ec.ec_order a, happigo_ec.ec_order_common b, happigo_ec.ec_order_goods c
WHERE a.order_id = b.order_id AND b.order_id = c.order_id AND a.order_id = c.order_id
      AND a.order_state >= '20' AND add_time >= UNIX_TIMESTAMP('2017-10-20 00:00:00') AND
      add_time <= UNIX_TIMESTAMP('2017-10-23 00:00')
      AND b.voucher_ref IN
          ('4269', '4270', '4271', '4272', '4273', '4274', '4275', '4276', '4277', '4278')
ORDER BY voucher_ref, a.order_id;

/*满减数据捞单*/
SELECT
  discount_mansong_id     AS '活动ID',
  mansong_name            AS '活动名称',
  cust_no                 AS '顾客编号',
  member_level            AS '会员等级',
  order_sn                AS '订单编号',
  goods_amount            AS '商品金额',
  order_amount            AS '订单金额',
  discount_mansong_amount AS '优惠金额',
  FROM_UNIXTIME(add_time) AS '下单时间',
  erp_code                AS '商品编号',
  goods_name              AS '商品名称',
  goods_num               AS '商品数量'
FROM
  ec_order a,
  ec_order_goods b,
  ec_p_mansong c
WHERE
  a.order_id = b.order_id
  AND a.discount_mansong_id = c.mansong_id
  AND order_state >= 20
  AND add_time >= UNIX_TIMESTAMP('2017-07-01') AND add_time < UNIX_TIMESTAMP('2017-07-07')
  AND discount_mansong_id IN (470)
GROUP BY a.order_id
ORDER BY discount_mansong_id, a.order_id;

/*优惠券领取使用数*/
SELECT count(1) AS '优惠券领取数'
FROM ec_voucher
WHERE voucher_t_id IN ('4367');
SELECT count(1) AS '优惠券使用数'
FROM ec_voucher
WHERE voucher_order_id > 0 AND voucher_t_id IN ('4367');

SELECT
  voucher_t_id    '券号',
  count(1) AS     '优惠券领取数',
  sum(CASE WHEN voucher_order_id > 0
    THEN 1
      ELSE 0 END) '优惠券使用数'
FROM ec_voucher
WHERE voucher_t_id IN ('4543',
                       '4544',
                       '4545',
                       '4546')
GROUP BY voucher_t_id;