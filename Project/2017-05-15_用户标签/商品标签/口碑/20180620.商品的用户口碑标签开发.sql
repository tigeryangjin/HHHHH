--1.添加商品计算标签
begin
  -- Call the procedure
  goods_label_pkg.create_goods_label(in_g_label_name      => 'GOODS_EVALUATION_COST_PERFORMANCE_LOW',
                                     in_g_label_desc      => '商品的用户口碑标签(性价比)_低',
                                     in_g_label_type_id   => 1,
                                     in_is_leaf_node      => 1, /*是否叶节点*/
                                     in_g_label_father_id => 1110);
end;
/

  SELECT * FROM GOODS_LABEL_HEAD A ORDER BY A.G_LABEL_ID DESC FOR UPDATE;

SELECT * FROM GOODS_LABEL_HEAD_LEVEL_V A WHERE A.LV1_ID = 1080;

--2.
/*
版型/款式STYLE
包装PACKING
保暖性WARMTH_RETENTION
功能FUNCTION
卖家服务SELLER_SERVICE
面料/材质MATERIAL
物流LOGISTICS
性价比COST_PERFORMANCE
*/

--3.
CREATE TABLE GOODS_LABEL_1080_STAGE AS
  SELECT D.ITEM_CODE,
         D.ASPECT_CATEGORY,
         G.LV3_ID G_LABEL_ID,
         E.LV2_NAME || '_' || D.EVA_LEVEL G_LABEL_NAME,
         D.EVA_COUNT,
         D.EVA_POSITIVE_COUNT,
         D.EVA_NEGATIVE_COUNT,
         SYSDATE W_INSERT_DT,
         SYSDATE W_UPDATE_DT
    FROM (SELECT C.ITEM_CODE,
                 C.ASPECT_CATEGORY,
                 C.EVA_COUNT,
                 C.EVA_POSITIVE_COUNT,
                 C.EVA_NEGATIVE_COUNT,
                 CASE
                   WHEN C.EVA_POSITIVE_PER < 0.7 THEN
                    'LOW'
                   WHEN C.EVA_POSITIVE_PER >= 0.7 AND
                        C.EVA_POSITIVE_PER < 0.9 THEN
                    'MEDIUM'
                   WHEN C.EVA_POSITIVE_PER >= 0.7 THEN
                    'HIGH'
                 END EVA_LEVEL
            FROM (SELECT B.ITEM_CODE,
                         B.ASPECT_CATEGORY,
                         COUNT(1) EVA_COUNT,
                         SUM(B.COL1) EVA_POSITIVE_COUNT,
                         SUM(B.COL2) EVA_NEGATIVE_COUNT,
                         ROUND(SUM(B.COL1) / COUNT(1), 2) EVA_POSITIVE_PER
                    FROM (SELECT A.GEVAL_GOODSID ITEM_CODE,
                                 A.ASPECT_CATEGORY,
                                 A.ASPECT_POLARITY,
                                 CASE
                                   WHEN A.ASPECT_POLARITY = '正' THEN
                                    1
                                   ELSE
                                    0
                                 END COL1,
                                 CASE
                                   WHEN A.ASPECT_POLARITY = '负' THEN
                                    1
                                   ELSE
                                    0
                                 END COL2
                            FROM FACT_GOODS_EVALUATE_ALIYUN A) B
                   GROUP BY B.ITEM_CODE, B.ASPECT_CATEGORY) C
           WHERE C.EVA_COUNT >= 10 /*评论数大于10才打商品标签*/
          ) D,
         (SELECT DISTINCT F.LV2_NAME,
                          SUBSTR(F.LV2_DESC,
                                 INSTR(F.LV2_DESC, '(', 1) + 1,
                                 INSTR(F.LV2_DESC, ')', 1) -
                                 INSTR(F.LV2_DESC, '(', 1) - 1) ASPECT_CATEGORY
            FROM GOODS_LABEL_HEAD_LEVEL_V F
           WHERE F.LV1_ID = 1080) E,
         (SELECT H.LV3_ID, H.LV3_NAME
            FROM GOODS_LABEL_HEAD_LEVEL_V H
           WHERE H.LV1_ID = 1080) G
   WHERE D.ASPECT_CATEGORY = E.ASPECT_CATEGORY
     AND E.LV2_NAME || '_' || D.EVA_LEVEL = G.LV3_NAME;

--4.
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
       WHERE EXISTS (SELECT 1
                FROM GOODS_LABEL_HEAD_LEVEL_V B
               WHERE B.LV1_ID = 1080
                 AND A.G_LABEL_ID = B.LV3_ID)) T
USING (SELECT C.ITEM_CODE,
              C.G_LABEL_ID,
              C.G_LABEL_TYPE_ID,
              SYSDATE CREATE_DATE,
              'yangjin' CREATE_USER_ID,
              SYSDATE LAST_UPDATE_DATE,
              'yangjin' LAST_UPDATE_USER_ID
         FROM GOODS_LABEL_1080_STAGE C) S
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
     S.G_LABEL_TYPE_ID,
     SYSDATE,
     'yangjin',
     SYSDATE,
     'yangjin');

--tmp.
SELECT * FROM S_PARAMETERS2 FOR UPDATE;
SELECT *
  FROM W_ETL_LOG A
 WHERE A.PROC_NAME = 'GOODS_LABEL_PKG.GOODS_EVALUATION_LEVEL'
 ORDER BY A.START_TIME DESC;
SELECT * FROM GOODS_LABEL_LINK;
SELECT * FROM GOODS_
SELECT * FROM GOODS_LABEL_LINK_V;
SELECT * FROM GOODS_LABEL_HEAD_LEVEL_V A WHERE A.LV1_ID = 1080;
