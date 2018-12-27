???CREATE OR REPLACE FORCE VIEW DW_USER.EC_GOODS_LABEL_HEAD_LEVEL_V AS
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

