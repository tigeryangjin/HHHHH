/*优惠券订单级捞单SQL*/
SELECT
  voucher_ref                 AS '券号',
  voucher_name                AS '券名称',
  voucher_price               AS '券金额',
  cust_no                     AS '顾客编号',
  member_level                AS '会员等级',
  CONCAT('`', order_sn)       AS '订单编号',
  CONCAT('`', a.erp_order_no) AS 'ERP订单编号',
  goods_amount                AS '商品金额',
  order_amount                AS '订单金额',
  FROM_UNIXTIME(add_time)     AS '下单时间'
FROM happigo_ec.ec_order a, happigo_ec.ec_order_common b
WHERE a.order_id = b.order_id
      AND a.order_state >= '20' AND add_time >= UNIX_TIMESTAMP('2018-10-18 20:00:00') AND
      add_time <= UNIX_TIMESTAMP('2018-10-22 00:00:00')
      AND b.voucher_ref IN
          ('5951',
            '5952',
            '5953',
            '5954',
            '5955',
            '5956',
            '5957',
            '5963',
            '5964',
            '5965',
            '5966')
ORDER BY voucher_ref, a.order_id;

/*优惠券商品级捞单SQL*/
SELECT
  voucher_ref                 AS '券号',
  voucher_name                AS '券名称',
  voucher_price               AS '券金额',
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
      AND a.order_state >= '20' AND add_time >= UNIX_TIMESTAMP('2018-10-18 20:00:00') AND
      add_time < UNIX_TIMESTAMP('2018-10-22 00:00:00')
      AND b.voucher_ref IN
          ('5951',
            '5952',
            '5953',
            '5954',
            '5955',
            '5956',
            '5957',
            '5963',
            '5964',
            '5965',
            '5966')
ORDER BY voucher_ref, a.order_id;

#合计优惠券的商品金额，订单金额
select
  券号,
  COUNT(DISTINCT 顾客编号) 订购人数,
  COUNT(DISTINCT 订单编号) 订购单数,
  sum(商品金额)            商品金额,
  sum(订单金额)            订单金额
from (
       SELECT
         voucher_ref                 AS '券号',
         voucher_name                AS '券名称',
         voucher_price               AS '券金额',
         cust_no                     AS '顾客编号',
         member_level                AS '会员等级',
         CONCAT('`', order_sn)       AS '订单编号',
         CONCAT('`', a.erp_order_no) AS 'ERP订单编号',
         goods_amount                AS '商品金额',
         order_amount                AS '订单金额',
         FROM_UNIXTIME(add_time)     AS '下单时间'
       FROM happigo_ec.ec_order a, happigo_ec.ec_order_common b
       WHERE a.order_id = b.order_id
             AND a.order_state >= '20' AND add_time >= UNIX_TIMESTAMP('2018-11-09 00:00:00') AND
             add_time < UNIX_TIMESTAMP('2018-11-12 00:00:00')
             AND b.voucher_ref IN
                 ('4037',
                   '4038',
                   '4039',
                   '4040',
                   '4041',
                   '4042',
                   '4043',
                   '4044',
                   '4045',
                   '4046',
                   '4047',
                   '4048',
                   '4049',
                   '4051',
                   '4052',
                   '4566',
                   '4567',
                   '4568',
                   '4569',
                   '4572',
                   '4573',
                  '4564',
                  '4565',
                  '4980',
                  '4977',
                  '4978',
                  '4555',
                  '4556'
                 )
       ORDER BY voucher_ref, a.order_id) a
group by 券号;

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
SELECT
  A.voucher_t_id                 券号,
  A.voucher_title                券名,
  A.all_count                    发放数,
  A.user_count                   使用数,
  A.user_count * A.voucher_price 使用金额
FROM (
       SELECT
         voucher_t_id,
         voucher_title,
         voucher_price,
         sum(1)          all_count,
         sum(case when voucher_order_id > 0
           then 1
             else 0 end) user_count
       FROM ec_voucher
       WHERE voucher_t_id IN ('4037',
         '4038',
         '4039',
         '4040',
         '4041',
         '4042',
         '4043',
         '4044',
         '4045',
         '4046',
         '4047',
         '4048',
         '4049',
         '4051',
         '4052',
         '4566',
         '4567',
         '4568',
         '4569',
         '4572',
         '4573',
                              '4564',
                              '4565',
                              '4980',
                              '4977',
                              '4978',
                              '4555',
                              '4556')
             AND voucher_active_date >= UNIX_TIMESTAMP('2018-11-09 00:00:00') AND
             voucher_active_date < UNIX_TIMESTAMP('2018-11-12 00:00:00')
       group by voucher_t_id, voucher_title) A;

#券号，使用渠道，使用数
SELECT
  b.voucher_ref 券号,
  a.app_name    使用渠道,
  count(1)      使用数
FROM happigo_ec.ec_order a, happigo_ec.ec_order_common b
WHERE a.order_id = b.order_id
      AND a.order_state >= '20' AND add_time >= UNIX_TIMESTAMP('2017-12-23 00:00:00') AND
      add_time <= UNIX_TIMESTAMP('2017-12-26 00:00')
      AND b.voucher_ref IN
          ('4786',
            '4790',
            '4791',
            '4792',
            '4793',
            '4794',
            '4795',
            '4796',
            '4797',
            '4798',
            '4799',
            '4800',
            '4801',
            '4802',
            '4803',
            '4804',
            '4805',
            '4806',
            '4807',
            '4808',
            '4809',
            '4810',
            '4811',
            '4812',
            '4813',
            '4814',
            '4815',
            '4816',
            '4817',
            '4818',
            '4819',
            '4820',
            '4821',
            '4822',
            '4823',
            '4824',
            '4825',
            '4826',
            '4827',
            '4828',
            '4829',
           '4830',
           '4831',
           '4832',
           '4833',
           '4834',
           '4835')
GROUP BY b.voucher_ref,
  a.app_name;

#券号，领取渠道，领取数
SELECT
  A.voucher_t_id            券号,
  A.voucher_add_application 领取渠道,
  COUNT(1)                  领取数
FROM ec_voucher A
WHERE A.voucher_t_id IN (4786,
  4790,
  4791,
  4792,
  4793,
  4794,
  4795,
  4796,
  4797,
  4798,
  4799,
  4800,
  4801,
  4802,
  4803,
  4804,
  4805,
  4806,
  4807,
  4808,
  4809,
  4810,
  4811,
  4812,
  4813,
  4814,
  4815,
  4816,
  4817,
  4818,
  4819,
  4820,
  4821,
  4822,
  4823,
  4824,
  4825,
  4826,
  4827,
  4828,
  4829,
                         4830,
                         4831,
                         4832,
                         4833,
                         4834,
                         4835)
GROUP BY A.voucher_t_id;

#券号，领取渠道，领取数,通过voucher_add_vid判断渠道
SELECT
  A.voucher_t_id     券号,
  CASE WHEN A.voucher_add_vid LIKE 'wx%'
    THEN 'wx'
  WHEN A.voucher_add_vid LIKE 'android%'
    THEN 'android'
  WHEN A.voucher_add_vid LIKE 'iphone%'
    THEN 'iphone'
  ELSE 'unknown' END 领取渠道,
  count(1)
FROM ec_voucher A
WHERE A.voucher_t_id IN (4786,
  4790,
  4791,
  4792,
  4793,
  4794,
  4795,
  4796,
  4797,
  4798,
  4799,
  4800,
  4801,
  4802,
  4803,
  4804,
  4805,
  4806,
  4807,
  4808,
  4809,
  4810,
  4811,
  4812,
  4813,
  4814,
  4815,
  4816,
  4817,
  4818,
  4819,
  4820,
  4821,
  4822,
  4823,
  4824,
  4825,
  4826,
  4827,
  4828,
  4829,
                         4830,
                         4831,
                         4832,
                         4833,
                         4834,
                         4835)
GROUP BY A.voucher_t_id,
  CASE WHEN A.voucher_add_vid LIKE 'wx%'
    THEN 'wx'
  WHEN A.voucher_add_vid LIKE 'android%'
    THEN 'android'
  WHEN A.voucher_add_vid LIKE 'iphone%'
    THEN 'iphone'
  ELSE 'unknown' END;

#券号，优惠券领取数，优惠券使用数
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

#领取优惠券的BP号
SELECT distinct b.member_crmbp
FROM ec_voucher a, ec_member b
WHERE a.voucher_owner_id = b.member_id
      and voucher_t_id IN ('5951',
  '5952',
  '5953',
  '5954',
  '5955',
  '5956',
  '5957',
  '5963',
  '5964',
  '5965',
  '5966')
      and a.voucher_active_date >= UNIX_TIMESTAMP('2018-10-15 00:00:00') and
      a.voucher_active_date < UNIX_TIMESTAMP('2018-10-20 00:00:00')
order by b.member_crmbp;