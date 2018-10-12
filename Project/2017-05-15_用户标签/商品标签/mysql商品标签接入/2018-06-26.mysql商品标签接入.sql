select * from ec_tags;
select * from ec_goods_tags;

select a1.tag_id   lv1_tag_id,
       a1.tag_name lv1_tag_name,
       a2.tag_id   lv2_tag_id,
       a2.tag_name lv2_tag_name,
       a3.tag_id   lv3_tag_id,
       a3.tag_name lv3_tag_name,
       a4.tag_id   lv4_tag_id,
       a4.tag_name lv4_tag_name
  from ec_tags a1
  left join ec_tags a2
    on a1.tag_id = a2.parent_id
  left join ec_tags a3
    on a2.tag_id = a3.parent_id
  left join ec_tags a4
    on a3.tag_id = a4.parent_id
 where a1.parent_id = 0
 order by a1.tag_id, a2.tag_id, a3.tag_id, a4.tag_id;

--oracle
--ec_tags
--1.1
INSERT INTO GOODS_LABEL_HEAD
  (G_LABEL_ID,
   G_LABEL_NAME,
   G_LABEL_DESC,
   G_LABEL_TYPE_ID,
   IS_LEAF_NODE,
   CREATE_DATE,
   CREATE_USER_ID,
   LAST_UPDATE_DATE,
   LAST_UPDATE_USER_ID,
   CURRENT_FLAG,
   G_LABEL_FATHER_ID)
  SELECT GOODS_LABEL_HEAD_SEQ.NEXTVAL G_LABEL_ID,
         A.TAG_ID G_LABEL_NAME,
         A.TAG_NAME G_LABEL_DESC,
         1 G_LABEL_TYPE_ID,
         NULL IS_LEAF_NODE,
         SYSDATE CREATE_DATE,
         'happigo_ec' CREATE_USER_ID,
         SYSDATE LAST_UPDATE_DATE,
         'happigo_ec' LAST_UPDATE_USER_ID,
         1 CURRENT_FLAG,
         NULL G_LABEL_FATHER_ID
    FROM (SELECT 'ec_' || A1.TAG_ID TAG_ID,
                 'ec_' || A1.TAG_NAME TAG_NAME,
                 'ec_' || A1.PARENT_ID PARENT_ID
            FROM EC_TAGS A1) A
   WHERE NOT EXISTS
   (SELECT 1 FROM GOODS_LABEL_HEAD B WHERE A.TAG_ID = B.G_LABEL_NAME);

--1.2.�Ƿ�Ҷ�ڵ����
UPDATE GOODS_LABEL_HEAD A
   SET A.IS_LEAF_NODE = 1
 WHERE A.CREATE_USER_ID = 'happigo_ec'
   AND EXISTS
 (SELECT 1
          FROM (SELECT NVL(C.LV4_TAG_ID,
                           NVL(C.LV3_TAG_ID, NVL(C.LV2_TAG_ID, C.LV1_TAG_ID))) G_LABEL_NAME,
                       C.LV1_TAG_ID,
                       C.LV2_TAG_ID,
                       C.LV3_TAG_ID,
                       C.LV4_TAG_ID
                  FROM EC_GOODS_LABEL_HEAD_LEVEL_V C) B
         WHERE A.G_LABEL_NAME = B.G_LABEL_NAME);
COMMIT;

UPDATE GOODS_LABEL_HEAD A
   SET A.IS_LEAF_NODE = 0
 WHERE A.CREATE_USER_ID = 'happigo_ec'
   AND A.IS_LEAF_NODE IS NULL;
COMMIT;

--1.3.���¸��ڵ�
UPDATE GOODS_LABEL_HEAD A
   SET A.G_LABEL_FATHER_ID =
       (SELECT C.G_LABEL_ID
          FROM (SELECT 'ec_' || B1.TAG_ID TAG_ID,
                       'ec_' || B1.PARENT_ID PARENT_ID
                  FROM EC_TAGS B1) B,
               (SELECT C1.G_LABEL_ID, C1.G_LABEL_NAME
                  FROM GOODS_LABEL_HEAD C1) C
         WHERE A.G_LABEL_NAME = B.TAG_ID
           AND B.PARENT_ID = C.G_LABEL_NAME)
 WHERE A.CREATE_USER_ID = 'happigo_ec'
   AND A.G_LABEL_FATHER_ID IS NULL;
COMMIT;

--ec_goods_tags
--1.
INSERT INTO GOODS_LABEL_LINK
  (ITEM_CODE,
   G_LABEL_ID,
   G_LABEL_TYPE_ID,
   CREATE_DATE,
   CREATE_USER_ID,
   LAST_UPDATE_DATE,
   LAST_UPDATE_USER_ID,
   ROW_ID)
  SELECT C.ITEM_CODE,
         C.G_LABEL_ID,
         C.G_LABEL_TYPE_ID,
         SYSDATE CREATE_DATE,
         'happigo_ec' CREATE_USER_ID,
         SYSDATE LAST_UPDATE_DATE,
         'happigo_ec' LAST_UPDATE_USER_ID,
         GOODS_LABEL_LINK_SEQ.NEXTVAL
    FROM (SELECT B.G_LABEL_ID,
                 'ec_' || A.TAG_ID G_LABEL_NAME,
                 A.ITEM_CODE,
                 B.G_LABEL_TYPE_ID
            FROM EC_GOODS_TAGS A, GOODS_LABEL_HEAD B
           WHERE 'ec_' || A.TAG_ID = B.G_LABEL_NAME
             AND A.STATE = 1
             AND B.CREATE_USER_ID = 'happigo_ec') C
   WHERE NOT EXISTS (SELECT 1
            FROM GOODS_LABEL_LINK D
           WHERE C.G_LABEL_ID = D.G_LABEL_ID
             AND C.ITEM_CODE = D.ITEM_CODE);

--2.						 
DELETE GOODS_LABEL_LINK A
 WHERE EXISTS (SELECT 1
          FROM (SELECT D.G_LABEL_ID,
                       'ec_' || C.TAG_ID G_LABEL_NAME,
                       C.ITEM_CODE,
                       D.G_LABEL_TYPE_ID
                  FROM EC_GOODS_TAGS C, GOODS_LABEL_HEAD D
                 WHERE 'ec_' || C.TAG_ID = D.G_LABEL_NAME
                   AND C.STATE = 0
                   AND D.CREATE_USER_ID = 'happigo_ec') B
         WHERE A.ITEM_CODE = B.ITEM_CODE
           AND A.G_LABEL_ID = B.G_LABEL_ID);


--tmp
SELECT * FROM S_PARAMETERS2 FOR UPDATE;
SELECT *
  FROM W_ETL_LOG A
 WHERE A.PROC_NAME IN ('GOODS_LABEL_PKG.SYNC_EC_TAGS',
                       'GOODS_LABEL_PKG.SYNC_EC_GOODS_TAGS')
 ORDER BY A.START_TIME DESC;

SELECT * FROM GOODS_LABEL_LINK A WHERE A.CREATE_USER_ID='happigo_ec';

SELECT C.G_LABEL_ID, B.TAG_ID, B.PARENT_ID, D.G_LABEL_ID
  FROM (SELECT 'ec_' || B1.TAG_ID TAG_ID, 'ec_' || B1.PARENT_ID PARENT_ID
          FROM EC_TAGS B1) B,
       (SELECT C1.G_LABEL_ID, C1.G_LABEL_NAME, C1.G_LABEL_FATHER_ID
          FROM GOODS_LABEL_HEAD C1) C,
       (SELECT D1.G_LABEL_ID, D1.G_LABEL_NAME, D1.G_LABEL_FATHER_ID
          FROM GOODS_LABEL_HEAD D1) D
 WHERE B.TAG_ID = C.G_LABEL_NAME
   AND B.PARENT_ID = D.G_LABEL_NAME(+)
 ORDER BY 1;

SELECT 'ec_' || B1.TAG_ID TAG_ID, 'ec_' || B1.PARENT_ID PARENT_ID
  FROM EC_TAGS B1;

SELECT C1.G_LABEL_ID, C1.G_LABEL_NAME
  FROM GOODS_LABEL_HEAD C1
 WHERE C1.CREATE_USER_ID = 'happigo_ec';
SELECT * FROM GOODS_LABEL_HEAD A WHERE A.CREATE_USER_ID = 'happigo_ec';
SELECT * FROM EC_GOODS_LABEL_HEAD_LEVEL_V;
SELECT * FROM EC_TAGS A, EC_GOODS_TAGS B WHERE A.TAG_ID = B.TAG_ID;

CREATE OR REPLACE VIEW EC_GOODS_LABEL_HEAD_LEVEL_V AS
  SELECT A1.TAG_ID    LV1_TAG_ID,
         A1.TAG_NAME  LV1_TAG_NAME,
         A1.PARENT_ID LV1_PARENT_ID,
         A2.TAG_ID    LV2_TAG_ID,
         A2.TAG_NAME  LV2_TAG_NAME,
         A2.PARENT_ID LV2_PARENT_ID,
         A3.TAG_ID    LV3_TAG_ID,
         A3.TAG_NAME  LV3_TAG_NAME,
         A3.PARENT_ID LV3_PARENT_ID,
         A4.TAG_ID    LV4_TAG_ID,
         A4.TAG_NAME  LV4_TAG_NAME,
         A4.PARENT_ID LV4_PARENT_ID
    FROM (SELECT 'ec_' || A.TAG_ID TAG_ID,
                 'ec_' || A.TAG_NAME TAG_NAME,
                 'ec_' || A.PARENT_ID PARENT_ID
            FROM EC_TAGS A) A1,
         (SELECT 'ec_' || A.TAG_ID TAG_ID,
                 'ec_' || A.TAG_NAME TAG_NAME,
                 'ec_' || A.PARENT_ID PARENT_ID
            FROM EC_TAGS A) A2,
         (SELECT 'ec_' || A.TAG_ID TAG_ID,
                 'ec_' || A.TAG_NAME TAG_NAME,
                 'ec_' || A.PARENT_ID PARENT_ID
            FROM EC_TAGS A) A3,
         (SELECT 'ec_' || A.TAG_ID TAG_ID,
                 'ec_' || A.TAG_NAME TAG_NAME,
                 'ec_' || A.PARENT_ID PARENT_ID
            FROM EC_TAGS A) A4
   WHERE A1.TAG_ID = A2.PARENT_ID(+)
     AND A2.TAG_ID = A3.PARENT_ID(+)
     AND A3.TAG_ID = A4.PARENT_ID(+)
     AND A1.PARENT_ID = 'ec_0'
   ORDER BY A1.TAG_ID, A2.TAG_ID, A3.TAG_ID, A4.TAG_ID;
