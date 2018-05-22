--1.
SELECT * FROM g_activity_tmp;
SELECT * FROM g_activity_goods_tmp;
SELECT * FROM g_activity_goods_group_tmp;
SELECT * FROM g_activity_voucher_tmp;

--2.
SELECT * FROM G_ACTIVITY;
SELECT * FROM G_ACTIVITY_GOODS;
SELECT * FROM G_ACTIVITY_GOODS_GROUP;
SELECT * FROM G_ACTIVITY_VOUCHER;

--3.
SELECT * FROM S_PARAMETERS2 FOR UPDATE;

--4.
SELECT *
  FROM W_ETL_LOG A
 WHERE A.PROC_NAME IN
       ('HAPPIGO_EC_PKG.MERGE_G_ACTIVITY',
        'HAPPIGO_EC_PKG.MERGE_G_ACTIVITY_GOODS',
        'HAPPIGO_EC_PKG.MERGE_G_ACTIVITY_GOODS_GROUP',
        'HAPPIGO_EC_PKG.MERGE_G_ACTIVITY_VOUCHER')
 ORDER BY A.START_TIME DESC;

--tmp
SELECT * FROM g_activity_tmp;
SELECT * FROM g_activity_goods_tmp;
SELECT * FROM g_activity_goods_group_tmp;
SELECT * FROM g_activity_voucher_tmp;

SELECT * FROM g_activity;
SELECT * FROM g_activity_goods;
SELECT * FROM g_activity_goods_group;
SELECT * FROM g_activity_voucher;

select a.id_col,
       a.activity_id,
       a.voucher_id,
       a.voucher_key,
       a.create_time,
       a.update_time
  from g_activity_voucher_tmp a;
