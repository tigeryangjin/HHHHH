#��Ʒ������
SELECT
  b.item_code  ��Ʒ����,
  b.goods_name ��Ʒ����,
  c.cnt        ������
FROM (SELECT
        d.goods_id,
        d.item_code,
        d.goods_name
      FROM ec_goods d) b, (
                            SELECT
                              a.goods_id,
                              count(1) cnt
                            FROM ec_group_purchase_task a
                            WHERE
                              a.add_time >= UNIX_TIMESTAMP('2018-11-01') AND a.add_time < UNIX_TIMESTAMP('2018-11-09')
                            GROUP BY a.goods_id) c
WHERE b.goods_id = c.goods_id
ORDER BY c.cnt DESC;

#��Ʒ������
SELECT
  b.item_code  ��Ʒ����,
  b.goods_name ��Ʒ����,
  c.cnt        ������
FROM (SELECT
        d.goods_id,
        d.item_code,
        d.goods_name
      FROM ec_goods d) b, (
                            SELECT
                              a.goods_id,
                              count(1) cnt
                            FROM ec_group_purchase_task a
                            WHERE
                              a.add_time >= UNIX_TIMESTAMP('2018-11-01') AND a.add_time < UNIX_TIMESTAMP('2018-11-09')
                              AND a.task_state IN (10)
                            GROUP BY a.goods_id) c
WHERE b.goods_id = c.goods_id
ORDER BY c.cnt DESC;
