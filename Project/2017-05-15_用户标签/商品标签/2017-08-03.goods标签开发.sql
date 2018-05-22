--1.新建商品标签
begin
  -- Call the procedure
  goods_label_pkg.create_goods_label(in_g_label_name      => 'GOODS_BASIC_ATTRIBUTE',
                                     in_g_label_desc      => '商品基础属性',
                                     in_g_label_type_id   => 1,
                                     in_g_label_father_id => null);
end;
/

  SELECT * FROM GOODS_LABEL_HEAD ORDER BY G_LABEL_ID;

INSERT INTO GOODS_LABEL_LINK
  (ITEM_CODE,
   G_LABEL_ID,
   G_LABEL_TYPE_ID,
   CREATE_DATE,
   CREATE_USER_ID,
   LAST_UPDATE_DATE,
   LAST_UPDATE_USER_ID)
  SELECT A.ITEM_CODE,
         3 G_LABEL_ID,
         1 G_LABEL_TYPE_ID,
         SYSDATE CREATE_DATE,
         'yangjin' CREATE_USER_ID,
         SYSDATE LAST_UPDATE_DATE,
         'yangjin' LAST_UPDATE_USER_ID
    FROM GOODS_LABEL_TMP A
   ORDER BY A.ITEM_CODE;
COMMIT;

CREATE VIEW GOODS_LABEL_LINK_V AS
  SELECT B.ITEM_CODE,
         C.GOODS_NAME,
         C.MATDL,
         C.MATDLT,
         C.MATZL,
         C.MATZLT,
         C.MATXL,
         C.MATXLT,
         B.G_LABEL_ID,
         B.G_LABEL_TYPE_ID,
         A.G_LABEL_NAME,
         A.G_LABEL_DESC,
         B.CREATE_DATE,
         B.CREATE_USER_ID,
         B.LAST_UPDATE_DATE,
         B.LAST_UPDATE_USER_ID
    FROM GOODS_LABEL_HEAD A, GOODS_LABEL_LINK B, DIM_GOOD C
   WHERE A.G_LABEL_ID = B.G_LABEL_ID
     AND B.ITEM_CODE = C.ITEM_CODE
     AND C.CURRENT_FLG = 'Y';

select * from DIM_GOOD t;
SELECT * FROM MEMBER_LABEL_LINK_V;

--1.1 ROW_ID
-- Create sequence 
create sequence GOODS_LABEL_LINK_SEQ minvalue 1 maxvalue 9999999999999999999999999999 start
  with 1 increment by 1 cache 20;

UPDATE GOODS_LABEL_LINK A
   SET A.ROW_ID = GOODS_LABEL_LINK_SEQ.NEXTVAL
 WHERE A.ROW_ID IS NULL;
COMMIT;

--*********************************************************************************************
--2.商品标签开发
--*********************************************************************************************
--2.1配送方式(DISTRIBUTION_TYPE)
--2.1.1
SELECT B.ITEM_CODE,
       C.G_LABEL_ID,
       C.G_LABEL_TYPE_ID,
       SYSDATE CREATE_DATE,
       'yangjin' CREATE_USER_ID,
       SYSDATE LAST_UPDATE_DATE,
       'yangjin' LAST_UPDATE_USER_ID
  FROM (SELECT A.ITEM_CODE,
               CASE
                 WHEN A.IS_SHIPPING_SELF = 1 THEN
                  'DISTRIBUTION_TYPE_KLG'
                 WHEN A.IS_SHIPPING_SELF = 0 THEN
                  'DISTRIBUTION_TYPE_SUPPLIER'
               END DISTRIBUTION_TYPE
          FROM DIM_EC_GOOD A
         WHERE A.IS_SHIPPING_SELF IS NOT NULL) B,
       GOODS_LABEL_HEAD C
 WHERE B.DISTRIBUTION_TYPE = C.G_LABEL_NAME;

--2.1.2
MERGE /*+APPEND*/
INTO (SELECT A.ROW_ID,
             A.ITEM_CODE,
             A.G_LABEL_ID,
             A.G_LABEL_TYPE_ID,
             A.CREATE_DATE,
             A.CREATE_USER_ID,
             A.LAST_UPDATE_DATE,
             A.LAST_UPDATE_USER_ID
        FROM GOODS_LABEL_LINK A
       WHERE A.G_LABEL_ID BETWEEN 22 AND 23) T
USING (SELECT B.ITEM_CODE,
              C.G_LABEL_ID,
              C.G_LABEL_TYPE_ID,
              SYSDATE CREATE_DATE,
              'yangjin' CREATE_USER_ID,
              SYSDATE LAST_UPDATE_DATE,
              'yangjin' LAST_UPDATE_USER_ID
         FROM (SELECT A.ITEM_CODE,
                      CASE
                        WHEN A.IS_SHIPPING_SELF = 1 THEN
                         'DISTRIBUTION_TYPE_KLG'
                        WHEN A.IS_SHIPPING_SELF = 0 THEN
                         'DISTRIBUTION_TYPE_SUPPLIER'
                      END DISTRIBUTION_TYPE
                 FROM DIM_EC_GOOD A
                WHERE A.IS_SHIPPING_SELF IS NOT NULL) B,
              GOODS_LABEL_HEAD C
        WHERE B.DISTRIBUTION_TYPE = C.G_LABEL_NAME) S
ON (T.ITEM_CODE = S.ITEM_CODE)
WHEN MATCHED THEN
  UPDATE
     SET T.G_LABEL_ID          = S.G_LABEL_ID,
         T.G_LABEL_TYPE_ID     = S.G_LABEL_TYPE_ID,
         T.LAST_UPDATE_DATE    = SYSDATE,
         T.LAST_UPDATE_USER_ID = 'yangjin'
WHEN NOT MATCHED THEN
  INSERT
    (T.ROW_ID,
     T.ITEM_CODE,
     T.G_LABEL_ID,
     T.G_LABEL_TYPE_ID,
     T.CREATE_DATE,
     T.CREATE_USER_ID,
     T.LAST_UPDATE_DATE,
     T.LAST_UPDATE_USER_ID)
  VALUES
    (GOODS_LABEL_LINK_SEQ.NEXTVAL,
     S.ITEM_CODE,
     S.G_LABEL_ID,
     1,
     SYSDATE,
     'yangjin',
     SYSDATE,
     'yangjin');

--2.1.3
DELETE GOODS_LABEL_LINK A
 WHERE A.G_LABEL_ID BETWEEN 22 AND 23
   AND NOT EXISTS (SELECT 1
          FROM (SELECT A.ITEM_CODE,
                       CASE
                         WHEN A.IS_SHIPPING_SELF = 1 THEN
                          22
                         WHEN A.IS_SHIPPING_SELF = 0 THEN
                          23
                       END G_LABEL_ID
                  FROM DIM_EC_GOOD A
                 WHERE A.IS_SHIPPING_SELF IS NOT NULL) B
         WHERE A.ITEM_CODE = B.ITEM_CODE
           AND A.G_LABEL_ID = B.G_LABEL_ID);

--2.2商品价格区间(PRICE_RANGE)
/*
0~50
50~100
100~200
200~300
300~400
400~500
500~600
600~800
800~1000
1000~1500
1500~2000
2000~3000
3000以上
*/
--2.2.1
SELECT B.ITEM_CODE,
       C.G_LABEL_NAME,
       C.G_LABEL_TYPE_ID,
       SYSDATE CREATE_DATE,
       'yangjin' CREATE_USER_ID,
       SYSDATE LAST_UPDATE_DATE,
       'yangjin' LAST_UPDATE_USER_ID
  FROM (SELECT A.ITEM_CODE,
               A.GOODS_PRICE,
               CASE
                 WHEN A.GOODS_PRICE >= 0 AND A.GOODS_PRICE < 50 THEN
                  'GOODS_PRICE_RANGE_0_50'
                 WHEN A.GOODS_PRICE >= 50 AND A.GOODS_PRICE < 100 THEN
                  'GOODS_PRICE_RANGE_50_100'
                 WHEN A.GOODS_PRICE >= 100 AND A.GOODS_PRICE < 200 THEN
                  'GOODS_PRICE_RANGE_100_200'
                 WHEN A.GOODS_PRICE >= 200 AND A.GOODS_PRICE < 300 THEN
                  'GOODS_PRICE_RANGE_200_300'
                 WHEN A.GOODS_PRICE >= 300 AND A.GOODS_PRICE < 400 THEN
                  'GOODS_PRICE_RANGE_300_400'
                 WHEN A.GOODS_PRICE >= 400 AND A.GOODS_PRICE < 500 THEN
                  'GOODS_PRICE_RANGE_400_500'
                 WHEN A.GOODS_PRICE >= 500 AND A.GOODS_PRICE < 600 THEN
                  'GOODS_PRICE_RANGE_500_600'
                 WHEN A.GOODS_PRICE >= 600 AND A.GOODS_PRICE < 800 THEN
                  'GOODS_PRICE_RANGE_600_800'
                 WHEN A.GOODS_PRICE >= 800 AND A.GOODS_PRICE < 1000 THEN
                  'GOODS_PRICE_RANGE_800_1000'
                 WHEN A.GOODS_PRICE >= 1000 AND A.GOODS_PRICE < 1500 THEN
                  'GOODS_PRICE_RANGE_1000_1500'
                 WHEN A.GOODS_PRICE >= 1500 AND A.GOODS_PRICE < 2000 THEN
                  'GOODS_PRICE_RANGE_1500_2000'
                 WHEN A.GOODS_PRICE >= 2000 AND A.GOODS_PRICE < 3000 THEN
                  'GOODS_PRICE_RANGE_2000_3000'
                 WHEN A.GOODS_PRICE >= 3000 THEN
                  'GOODS_PRICE_RANGE_MORE_THAN_3000'
               END GOODS_PRICE_RANGE
          FROM DIM_EC_GOOD A) B,
       GOODS_LABEL_HEAD C
 WHERE B.GOODS_PRICE_RANGE = C.G_LABEL_NAME;

--2.2.2
MERGE /*+APPEND*/
INTO (SELECT A.ROW_ID,
             A.ITEM_CODE,
             A.G_LABEL_ID,
             A.G_LABEL_TYPE_ID,
             A.CREATE_DATE,
             A.CREATE_USER_ID,
             A.LAST_UPDATE_DATE,
             A.LAST_UPDATE_USER_ID
        FROM GOODS_LABEL_LINK A
       WHERE A.G_LABEL_ID IN
             (25, 26, 27, 28, 29, 1000, 1001, 1002, 1003, 1004, 1005, 1006)) T
USING (SELECT B.ITEM_CODE,
              C.G_LABEL_ID,
              C.G_LABEL_TYPE_ID,
              SYSDATE CREATE_DATE,
              'yangjin' CREATE_USER_ID,
              SYSDATE LAST_UPDATE_DATE,
              'yangjin' LAST_UPDATE_USER_ID
         FROM (SELECT A.ITEM_CODE,
                      A.GOODS_PRICE,
                      CASE
                        WHEN A.GOODS_PRICE >= 0 AND A.GOODS_PRICE < 50 THEN
                         'GOODS_PRICE_RANGE_0_50'
                        WHEN A.GOODS_PRICE >= 50 AND A.GOODS_PRICE < 100 THEN
                         'GOODS_PRICE_RANGE_50_100'
                        WHEN A.GOODS_PRICE >= 100 AND A.GOODS_PRICE < 200 THEN
                         'GOODS_PRICE_RANGE_100_200'
                        WHEN A.GOODS_PRICE >= 200 AND A.GOODS_PRICE < 300 THEN
                         'GOODS_PRICE_RANGE_200_300'
                        WHEN A.GOODS_PRICE >= 300 AND A.GOODS_PRICE < 400 THEN
                         'GOODS_PRICE_RANGE_300_400'
                        WHEN A.GOODS_PRICE >= 400 AND A.GOODS_PRICE < 500 THEN
                         'GOODS_PRICE_RANGE_400_500'
                        WHEN A.GOODS_PRICE >= 500 AND A.GOODS_PRICE < 600 THEN
                         'GOODS_PRICE_RANGE_500_600'
                        WHEN A.GOODS_PRICE >= 600 AND A.GOODS_PRICE < 800 THEN
                         'GOODS_PRICE_RANGE_600_800'
                        WHEN A.GOODS_PRICE >= 800 AND A.GOODS_PRICE < 1000 THEN
                         'GOODS_PRICE_RANGE_800_1000'
                        WHEN A.GOODS_PRICE >= 1000 AND A.GOODS_PRICE < 1500 THEN
                         'GOODS_PRICE_RANGE_1000_1500'
                        WHEN A.GOODS_PRICE >= 1500 AND A.GOODS_PRICE < 2000 THEN
                         'GOODS_PRICE_RANGE_1500_2000'
                        WHEN A.GOODS_PRICE >= 2000 AND A.GOODS_PRICE < 3000 THEN
                         'GOODS_PRICE_RANGE_2000_3000'
                        WHEN A.GOODS_PRICE >= 3000 THEN
                         'GOODS_PRICE_RANGE_MORE_THAN_3000'
                      END GOODS_PRICE_RANGE
                 FROM DIM_EC_GOOD A) B,
              GOODS_LABEL_HEAD C
        WHERE B.GOODS_PRICE_RANGE = C.G_LABEL_NAME) S
ON (T.ITEM_CODE = S.ITEM_CODE)
WHEN MATCHED THEN
  UPDATE
     SET T.G_LABEL_ID          = S.G_LABEL_ID,
         T.G_LABEL_TYPE_ID     = S.G_LABEL_TYPE_ID,
         T.LAST_UPDATE_DATE    = SYSDATE,
         T.LAST_UPDATE_USER_ID = 'yangjin'
WHEN NOT MATCHED THEN
  INSERT
    (T.ROW_ID,
     T.ITEM_CODE,
     T.G_LABEL_ID,
     T.G_LABEL_TYPE_ID,
     T.CREATE_DATE,
     T.CREATE_USER_ID,
     T.LAST_UPDATE_DATE,
     T.LAST_UPDATE_USER_ID)
  VALUES
    (GOODS_LABEL_LINK_SEQ.NEXTVAL,
     S.ITEM_CODE,
     S.G_LABEL_ID,
     1,
     SYSDATE,
     'yangjin',
     SYSDATE,
     'yangjin');

DELETE GOODS_LABEL_LINK A
 WHERE A.G_LABEL_ID IN
       (25, 26, 27, 28, 29, 1000, 1001, 1002, 1003, 1004, 1005, 1006)
   AND NOT EXISTS
 (SELECT 1
          FROM (SELECT B.ITEM_CODE, C.G_LABEL_ID
                  FROM (SELECT A.ITEM_CODE,
                               A.GOODS_PRICE,
                               CASE
                                 WHEN A.GOODS_PRICE >= 0 AND A.GOODS_PRICE < 50 THEN
                                  'GOODS_PRICE_RANGE_0_50'
                                 WHEN A.GOODS_PRICE >= 50 AND
                                      A.GOODS_PRICE < 100 THEN
                                  'GOODS_PRICE_RANGE_50_100'
                                 WHEN A.GOODS_PRICE >= 100 AND
                                      A.GOODS_PRICE < 200 THEN
                                  'GOODS_PRICE_RANGE_100_200'
                                 WHEN A.GOODS_PRICE >= 200 AND
                                      A.GOODS_PRICE < 300 THEN
                                  'GOODS_PRICE_RANGE_200_300'
                                 WHEN A.GOODS_PRICE >= 300 AND
                                      A.GOODS_PRICE < 400 THEN
                                  'GOODS_PRICE_RANGE_300_400'
                                 WHEN A.GOODS_PRICE >= 400 AND
                                      A.GOODS_PRICE < 500 THEN
                                  'GOODS_PRICE_RANGE_400_500'
                                 WHEN A.GOODS_PRICE >= 500 AND
                                      A.GOODS_PRICE < 600 THEN
                                  'GOODS_PRICE_RANGE_500_600'
                                 WHEN A.GOODS_PRICE >= 600 AND
                                      A.GOODS_PRICE < 800 THEN
                                  'GOODS_PRICE_RANGE_600_800'
                                 WHEN A.GOODS_PRICE >= 800 AND
                                      A.GOODS_PRICE < 1000 THEN
                                  'GOODS_PRICE_RANGE_800_1000'
                                 WHEN A.GOODS_PRICE >= 1000 AND
                                      A.GOODS_PRICE < 1500 THEN
                                  'GOODS_PRICE_RANGE_1000_1500'
                                 WHEN A.GOODS_PRICE >= 1500 AND
                                      A.GOODS_PRICE < 2000 THEN
                                  'GOODS_PRICE_RANGE_1500_2000'
                                 WHEN A.GOODS_PRICE >= 2000 AND
                                      A.GOODS_PRICE < 3000 THEN
                                  'GOODS_PRICE_RANGE_2000_3000'
                                 WHEN A.GOODS_PRICE >= 3000 THEN
                                  'GOODS_PRICE_RANGE_MORE_THAN_3000'
                               END GOODS_PRICE_RANGE
                          FROM DIM_EC_GOOD A) B,
                       GOODS_LABEL_HEAD C
                 WHERE B.GOODS_PRICE_RANGE = C.G_LABEL_NAME) B
         WHERE A.ITEM_CODE = B.ITEM_CODE
           AND A.G_LABEL_ID = B.G_LABEL_ID);

--tmp
SELECT * FROM GOODS_LABEL_HEAD;
SELECT * FROM GOODS_LABEL_LINK;
SELECT * FROM GOODS_LABEL_TYPE;
SELECT *
  FROM W_ETL_LOG A
 WHERE A.PROC_NAME = 'GOODS_LABEL_PKG.DISTRIBUTION_TYPE';
SELECT *
  FROM W_ETL_LOG A
 WHERE A.PROC_NAME LIKE 'GOODS_LABEL_PKG%' ORDER BY A.START_TIME DESC;
SELECT * FROM S_PARAMETERS2 FOR UPDATE;
SELECT *
  FROM W_ETL_LOG A WHERE UPPER(A.TABLE_NAME)='DIM_EC_GOOD';
SELECT DISTINCT LENGTH(A.ITEM_CODE) FROM GOODS_LABEL_LINK A;
SELECT * FROM GOODS_LABEL_LINK A WHERE LENGTH(A.ITEM_CODE) = 1;
SELECT * FROM GOODS_LABEL_LINK A WHERE LENGTH(A.ITEM_CODE) = 3;
SELECT * FROM GOODS_LABEL_LINK A WHERE LENGTH(A.ITEM_CODE) = 6;
SELECT * FROM GOODS_LABEL_LINK A WHERE LENGTH(A.ITEM_CODE) = 7;
SELECT * FROM GOODS_LABEL_LINK A WHERE LENGTH(A.ITEM_CODE) = 9;

SELECT * FROM DIM_GOOD A WHERE A.ITEM_CODE = 1010297;
SELECT * FROM DIM_EC_GOOD A WHERE A.ITEM_CODE = 101910082;
SELECT * FROM DIM_EC_GOOD A WHERE A.ITEM_CODE LIKE '1019100%';
