--1.添加商品计算标签
begin
  -- Call the procedure
  goods_label_pkg.create_goods_label(in_g_label_name      => 'GOODS_CVR',
                                     in_g_label_desc      => '高转化率',
                                     in_g_label_type_id   => 1,
                                     in_is_leaf_node      => 1, /*是否叶节点*/
                                     in_g_label_father_id => 1059);
end;
/

  SELECT * FROM GOODS_LABEL_HEAD A ORDER BY A.G_LABEL_ID DESC;

CREATE OR REPLACE VIEW GOODS_LABEL_HEAD_LEVEL_V AS
  SELECT A1.G_LABEL_ID   LV1_ID,
         A1.G_LABEL_NAME LV1_NAME,
         A1.G_LABEL_DESC LV1_DESC,
         A2.G_LABEL_ID   LV2_ID,
         A2.G_LABEL_NAME LV2_NAME,
         A2.G_LABEL_DESC LV2_DESC,
         A3.G_LABEL_ID   LV3_ID,
         A3.G_LABEL_NAME LV3_NAME,
         A3.G_LABEL_DESC LV3_DESC,
         A4.G_LABEL_ID   LV4_ID,
         A4.G_LABEL_NAME LV4_NAME,
         A4.G_LABEL_DESC LV4_DESC
    FROM GOODS_LABEL_HEAD_V A1,
         GOODS_LABEL_HEAD_V A2,
         GOODS_LABEL_HEAD_V A3,
         GOODS_LABEL_HEAD_V A4
   WHERE A1.G_LABEL_ID = A2.G_LABEL_FATHER_ID(+)
     AND A2.G_LABEL_ID = A3.G_LABEL_FATHER_ID(+)
     AND A3.G_LABEL_ID = A4.G_LABEL_FATHER_ID(+)
     AND A1.G_LABEL_FATHER_ID IS NULL
   ORDER BY A1.G_LABEL_ID, A2.G_LABEL_ID, A3.G_LABEL_ID, A4.G_LABEL_ID;

SELECT *
  FROM GOODS_LABEL_HEAD A
 WHERE EXISTS (SELECT 1
          FROM GOODS_LABEL_HEAD B
         WHERE A.G_LABEL_ID = B.G_LABEL_FATHER_ID)
 ORDER BY A.G_LABEL_ID;

--2.
/*
GOODS_HOT_SEASON_SPRING,商品热销季节-春,自然年内所属物料细类销量60%以上位于（1~4月）
GOODS_HOT_SEASON_SUMMER,商品热销季节-夏,自然年内所属物料细类销量60%以上位于（4~7月）
GOODS_HOT_SEASON_AUTUMN,商品热销季节-秋,自然年内所属物料细类销量60%以上位于（7~10月）
GOODS_HOT_SEASON_WINTER,商品热销季节-冬,自然年内所属物料细类销量60%以上位于（10~1月）
*/
CREATE TABLE GOODS_LABEL_1041_STAGE AS
  SELECT C.YEAR_KEY, C.MONTH_KEY, E.MATL_GROUP, SUM(C.QTY) QTY
    FROM (SELECT TO_CHAR(A.ADD_TIME, 'YYYY') YEAR_KEY,
                 TO_CHAR(A.ADD_TIME, 'MM') MONTH_KEY,
                 B.GOODS_COMMONID,
                 SUM(B.GOODS_NUM) QTY
            FROM FACT_EC_ORDER_2 A, FACT_EC_ORDER_GOODS B
           WHERE A.ORDER_ID = B.ORDER_ID
             AND A.ORDER_STATE >= 20
             AND TO_CHAR(A.ADD_TIME, 'YYYY') = 2017
           GROUP BY TO_CHAR(A.ADD_TIME, 'YYYY'),
                    TO_CHAR(A.ADD_TIME, 'MM'),
                    B.GOODS_COMMONID) C,
         (SELECT D.ITEM_CODE, D.GOODS_COMMONID, D.MATL_GROUP
            FROM DIM_GOOD D
           WHERE D.CURRENT_FLG = 'Y'
             AND D.GOODS_COMMONID <> 0) E
   WHERE C.GOODS_COMMONID = E.GOODS_COMMONID
   GROUP BY C.YEAR_KEY, C.MONTH_KEY, E.MATL_GROUP
   ORDER BY C.YEAR_KEY, C.MONTH_KEY, E.MATL_GROUP;

--3.
CREATE TABLE GOODS_LABEL_1041_STAGE_A AS
  SELECT C.MATL_GROUP,
         CASE
           WHEN C.SPRING_QTY >= C.TOTAL_QTY * 0.6 THEN
            'GOODS_HOT_SEASON_SPRING'
         END COL1,
         CASE
           WHEN C.SUMMER_QTY >= C.TOTAL_QTY * 0.6 THEN
            'GOODS_HOT_SEASON_SUMMER'
         END COL2,
         CASE
           WHEN C.AUTUMN_QTY >= C.TOTAL_QTY * 0.6 THEN
            'GOODS_HOT_SEASON_AUTUMN'
         END COL3,
         CASE
           WHEN C.WINTER_QTY >= C.TOTAL_QTY * 0.6 THEN
            'GOODS_HOT_SEASON_WINTER'
         END COL4
    FROM (SELECT B.MATL_GROUP,
                 SUM(SPRING_QTY) SPRING_QTY,
                 SUM(SUMMER_QTY) SUMMER_QTY,
                 SUM(AUTUMN_QTY) AUTUMN_QTY,
                 SUM(WINTER_QTY) WINTER_QTY,
                 SUM(TOTAL_QTY) TOTAL_QTY
            FROM (SELECT A.MATL_GROUP,
                         CASE
                           WHEN A.MONTH_KEY IN ('01', '02', '03', '04') THEN
                            A.QTY
                           ELSE
                            0
                         END SPRING_QTY,
                         CASE
                           WHEN A.MONTH_KEY IN ('04', '05', '06', '07') THEN
                            A.QTY
                           ELSE
                            0
                         END SUMMER_QTY,
                         CASE
                           WHEN A.MONTH_KEY IN ('07', '08', '09', '10') THEN
                            A.QTY
                           ELSE
                            0
                         END AUTUMN_QTY,
                         CASE
                           WHEN A.MONTH_KEY IN ('10', '11', '12', '01') THEN
                            A.QTY
                           ELSE
                            0
                         END WINTER_QTY,
                         A.QTY TOTAL_QTY
                    FROM GOODS_LABEL_1041_STAGE A) B
           GROUP BY B.MATL_GROUP) C;

--4.
INSERT INTO GOODS_LABEL_LINK
  (ITEM_CODE,
   G_LABEL_ID,
   G_LABEL_TYPE_ID,
   CREATE_DATE,
   CREATE_USER_ID,
   LAST_UPDATE_DATE,
   LAST_UPDATE_USER_ID,
   ROW_ID)
  SELECT G.ITEM_CODE,
         H.G_LABEL_ID,
         H.G_LABEL_TYPE_ID,
         SYSDATE CREATE_DATE,
         'yangjin' CREATE_USER_ID,
         SYSDATE LAST_UPDATE_DATE,
         'yangjin' LAST_UPDATE_USER_ID,
         GOODS_LABEL_LINK_SEQ.NEXTVAL
    FROM (SELECT F.ITEM_CODE, E.COL1
            FROM (SELECT A.MATL_GROUP, A.COL1
                    FROM GOODS_LABEL_1041_STAGE_A A
                   WHERE A.COL1 IS NOT NULL
                  UNION ALL
                  SELECT B.MATL_GROUP, B.COL2
                    FROM GOODS_LABEL_1041_STAGE_A B
                   WHERE B.COL2 IS NOT NULL
                  UNION ALL
                  SELECT C.MATL_GROUP, C.COL3
                    FROM GOODS_LABEL_1041_STAGE_A C
                   WHERE C.COL3 IS NOT NULL
                  UNION ALL
                  SELECT D.MATL_GROUP, D.COL4
                    FROM GOODS_LABEL_1041_STAGE_A D
                   WHERE D.COL4 IS NOT NULL) E,
                 DIM_GOOD F
           WHERE E.MATL_GROUP = F.MATL_GROUP) G,
         GOODS_LABEL_HEAD H
   WHERE G.COL1 = H.G_LABEL_NAME;

--5.
SELECT *
  FROM W_ETL_LOG A
 WHERE A.PROC_NAME = 'GOODS_LABEL_PKG.GOODS_HOT_SEASON'
 ORDER BY A.START_TIME DESC;

SELECT * FROM GOODS_LABEL_LINK A WHERE A.CREATE_DATE >= DATE '2018-05-24';

--******************************************************************************************************************************
/*
最近30天
HIGH_TRAFFIC-高流量-月度UV超过1000
MEDIUM_TRAFFIC-一般流量-月度UV介于101~999
LOW_TRAFFIC-低流量-月度UV低于100
*/
--******************************************************************************************************************************
--1.
/*INSERT INTO GOODS_LABEL_LINK
  (ITEM_CODE,
   G_LABEL_ID,
   G_LABEL_TYPE_ID,
   CREATE_DATE,
   CREATE_USER_ID,
   LAST_UPDATE_DATE,
   LAST_UPDATE_USER_ID,
   ROW_ID)*/
INSERT INTO GOODS_LABEL_1050_STAGE
  (ITEM_CODE, G_LABEL_ID, G_LABEL_TYPE_ID)
  SELECT C.ITEM_CODE, D.G_LABEL_ID, D.G_LABEL_TYPE_ID
    FROM (SELECT B.ITEM_CODE,
                 B.UV,
                 CASE
                   WHEN B.UV BETWEEN 0 AND 100 THEN
                    'LOW_TRAFFIC'
                   WHEN B.UV BETWEEN 101 AND 999 THEN
                    'MEDIUM_TRAFFIC'
                   WHEN B.UV >= 1000 THEN
                    'HIGH_TRAFFIC'
                 END TRAFFIC_LEVEL
            FROM (SELECT A.PAGE_VALUE ITEM_CODE, COUNT(DISTINCT A.VID) UV
                    FROM FACT_PAGE_VIEW A
                   WHERE A.VISIT_DATE_KEY >=
                         TO_CHAR(SYSDATE - 31, 'YYYYMMDD')
                     AND UPPER(A.PAGE_NAME) = 'GOOD'
                     AND LENGTH(A.PAGE_VALUE) = 6
                     AND A.PAGE_VALUE =
                         TRANSLATE(A.PAGE_VALUE,
                                   '0' ||
                                   TRANSLATE(A.PAGE_VALUE, '#0123456789', '#'),
                                   '0')
                   GROUP BY A.PAGE_VALUE) B) C,
         GOODS_LABEL_HEAD D
   WHERE C.TRAFFIC_LEVEL = D.G_LABEL_NAME;

--2.
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
       WHERE A.G_LABEL_ID IN (1051, 1052, 1053)) T
USING (SELECT ITEM_CODE, G_LABEL_ID, G_LABEL_TYPE_ID
         FROM GOODS_LABEL_1050_STAGE) S
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

--3.
DELETE GOODS_LABEL_LINK A
 WHERE A.G_LABEL_ID IN (1051, 1052, 1053)
   AND NOT EXISTS (SELECT 1
          FROM GOODS_LABEL_1050_STAGE B
         WHERE A.ITEM_CODE = B.ITEM_CODE);

--4.
SELECT * FROM S_PARAMETERS2 FOR UPDATE;
SELECT *
  FROM W_ETL_LOG A
 WHERE A.PROC_NAME = 'GOODS_LABEL_PKG.GOODS_TRAFFIC_LEVEL'
 ORDER BY A.START_TIME DESC;

--******************************************************************************************************************************
--转化情况
--HIGH_CVR-高转化率-月度转化率高于2.5%
--MEDIUM_CVR-一般转化率-月度转化率介于1.0%~2.5%
--LOW_CVR-低转化率-月度转化率低于1.0%
--******************************************************************************************************************************
--1.
begin
  -- Call the procedure
  goods_label_pkg.create_goods_label(in_g_label_name      => 'GOODS_LOW_CVR',
                                     in_g_label_desc      => '低转化率-月度转化率低于1.0%',
                                     in_g_label_type_id   => 1,
                                     in_is_leaf_node      => 1, /*是否叶节点*/
                                     in_g_label_father_id => 1059);
end;
/

  SELECT * FROM GOODS_LABEL_HEAD A ORDER BY A.G_LABEL_ID DESC;

--2.
TRUNCATE TABLE GOODS_LABEL_1059_STAGE;
INSERT INTO GOODS_LABEL_1059_STAGE
  (ITEM_CODE, CVR, CVR_LEVEL, W_INSERT_DT, W_UPDATE_DT)
  SELECT H.ITEM_CODE,
         G.CVR,
         CASE
           WHEN G.CVR BETWEEN 0 AND 0.01 THEN
            'LOW_CVR'
           WHEN G.CVR BETWEEN 0.01 AND 0.025 THEN
            'MEDIUM_CVR'
           WHEN G.CVR > 0.025 THEN
            'HIGH_CVR'
         END CVR_LEVEL,
         SYSDATE W_INSERT_DT,
         SYSDATE W_UPDATE_DT
    FROM (SELECT E.GOODS_COMMONID,
                 E.UV,
                 NVL(F.ORDER_MEMBER_CNT, 0),
                 ROUND(NVL(F.ORDER_MEMBER_CNT, 0) / E.UV, 2) CVR
            FROM (SELECT B.GOODS_COMMONID, B.UV
                    FROM (SELECT A.PAGE_VALUE GOODS_COMMONID,
                                 COUNT(DISTINCT A.VID) UV
                            FROM FACT_PAGE_VIEW A
                           WHERE A.VISIT_DATE_KEY BETWEEN
                                 TO_CHAR(TO_DATE(&IN_DATE_KEY, 'YYYYMMDD') - 30,
                                         'YYYYMMDD') AND &IN_DATE_KEY
                             AND UPPER(A.PAGE_NAME) = 'GOOD'
                                --AND LENGTH(A.PAGE_VALUE) = 6
                             AND A.PAGE_VALUE =
                                 TRANSLATE(A.PAGE_VALUE,
                                           '0' || TRANSLATE(A.PAGE_VALUE,
                                                            '#0123456789',
                                                            '#'),
                                           '0')
                           GROUP BY A.PAGE_VALUE) B) E,
                 (SELECT D.GOODS_COMMONID,
                         COUNT(DISTINCT C.CUST_NO) ORDER_MEMBER_CNT
                    FROM FACT_EC_ORDER_2 C, FACT_EC_ORDER_GOODS D
                   WHERE C.ORDER_ID = D.ORDER_ID
                     AND C.ORDER_STATE >= 20
                     AND C.ADD_TIME BETWEEN
                         TO_DATE(&IN_DATE_KEY, 'YYYYMMDD') - 30 AND
                         TO_DATE(&IN_DATE_KEY, 'YYYYMMDD')
                   GROUP BY D.GOODS_COMMONID) F
           WHERE E.GOODS_COMMONID = F.GOODS_COMMONID(+)) G,
         DIM_EC_GOOD H
   WHERE G.GOODS_COMMONID = H.GOODS_COMMONID
     AND H.STORE_ID = 1;

--3.
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
       WHERE A.G_LABEL_ID IN (1060, 1061, 1062)) T
USING (SELECT B.ITEM_CODE, C.G_LABEL_ID, C.G_LABEL_TYPE_ID
         FROM GOODS_LABEL_1059_STAGE B, GOODS_LABEL_HEAD C
        WHERE B.CVR_LEVEL = C.G_LABEL_NAME
          AND C.G_LABEL_ID IN (1060, 1061, 1062)) S
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

--4.
SELECT * FROM S_PARAMETERS2 A FOR UPDATE;

SELECT *
  FROM W_ETL_LOG A
 WHERE A.PROC_NAME = 'GOODS_LABEL_PKG.GOODS_CVR'
 ORDER BY A.START_TIME DESC;

--******************************************************************************************************************************
--新品标签
--FIRST_ON_SELL_TIME-1072
--15_DAYS_TO_30DAYS-商品首次上架时间在（15天以上30天以下）-1073
--7_DAYS_TO_15_DAYS-商品首次上架时间在（7天以上15天以下）-1074
--WITHIN_7_DAYS-商品首次上架时间在（7天以下）-1075
--******************************************************************************************************************************
--1.
begin
  -- Call the procedure
  goods_label_pkg.create_goods_label(in_g_label_name      => '15_DAYS_TO_30DAYS',
                                     in_g_label_desc      => '商品首次上架时间在（15天以上30天以下）',
                                     in_g_label_type_id   => 1,
                                     in_is_leaf_node      => 1, /*是否叶节点*/
                                     in_g_label_father_id => 1072);
end;
/

  SELECT * FROM GOODS_LABEL_HEAD A ORDER BY A.G_LABEL_ID DESC;

--2.
TRUNCATE TABLE GOODS_LABEL_1072_STAGE;
INSERT INTO GOODS_LABEL_1072_STAGE
  (ITEM_CODE, FIRSTONSELLTIME, FIRST_LEVEL, W_INSERT_DT, W_UPDATE_DT)
  SELECT A.ITEM_CODE,
         TRUNC(A.FIRSTONSELLTIME) FIRSTONSELLTIME,
         CASE
           WHEN TRUNC(A.FIRSTONSELLTIME) > TRUNC(SYSDATE) - 7 THEN
            'WITHIN_7_DAYS'
           WHEN TRUNC(A.FIRSTONSELLTIME) <= TRUNC(SYSDATE) - 7 AND
                TRUNC(A.FIRSTONSELLTIME) >= TRUNC(SYSDATE) - 15 THEN
            '7_DAYS_TO_15_DAYS'
           WHEN TRUNC(A.FIRSTONSELLTIME) < TRUNC(SYSDATE) - 15 AND
                TRUNC(A.FIRSTONSELLTIME) >= TRUNC(SYSDATE) - 30 THEN
            '15_DAYS_TO_30DAYS'
         END FIRST_LEVEL,
         SYSDATE W_INSERT_DT,
         SYSDATE W_UPDATE_DT
    FROM FACT_EC_GOODS_COMMON A
   WHERE TRUNC(A.FIRSTONSELLTIME) >= TRUNC(SYSDATE) - 30;

--3.
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
       WHERE A.G_LABEL_ID IN (1073, 1074, 1075)) T
USING (SELECT B.ITEM_CODE, C.G_LABEL_ID, C.G_LABEL_TYPE_ID
         FROM GOODS_LABEL_1072_STAGE B, GOODS_LABEL_HEAD C
        WHERE B.FIRST_LEVEL = C.G_LABEL_NAME
          AND C.G_LABEL_ID IN (1073, 1074, 1075)) S
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

--4.
SELECT * FROM S_PARAMETERS2 A FOR UPDATE;

--******************************************************************************************************************************
--细类价格区间
--GOODS_MATXXL_PRICE_LEVEL
--HIGH_MATXXL_PRICE_LEVEL-高价格区间
--MEDIUM_MATXXL_PRICE_LEVEL-常规价格区间
--LOW_MATXXL_PRICE_LEVEL-低价格区间
--******************************************************************************************************************************
--1.
begin
  -- Call the procedure
  goods_label_pkg.create_goods_label(in_g_label_name      => 'LOW_MATXXL_PRICE_LEVEL',
                                     in_g_label_desc      => '低价格区间',
                                     in_g_label_type_id   => 1,
                                     in_is_leaf_node      => 1, /*是否叶节点*/
                                     in_g_label_father_id => 1076);
end;
/

  SELECT * FROM GOODS_LABEL_HEAD A ORDER BY A.G_LABEL_ID DESC;

--2.
SELECT C.ITEM_CODE, D.G_LABEL_ID, D.G_LABEL_TYPE_ID
  FROM (SELECT B.ITEM_CODE,
               B.GOOD_PRICE_LEVEL || '_MATXXL_PRICE_LEVEL' GOODS_MATXXL_PRICE_LEVEL
          FROM DIM_GOOD B
         WHERE B.CURRENT_FLG = 'Y'
           AND B.GOOD_PRICE_LEVEL IS NOT NULL) C,
       GOODS_LABEL_HEAD D
 WHERE C.GOODS_MATXXL_PRICE_LEVEL = D.G_LABEL_NAME;

--3.
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
       WHERE A.G_LABEL_ID IN (1077, 1078, 1079)) T
USING (SELECT C.ITEM_CODE, D.G_LABEL_ID, D.G_LABEL_TYPE_ID
         FROM (SELECT B.ITEM_CODE,
                      B.GOOD_PRICE_LEVEL || '_MATXXL_PRICE_LEVEL' GOODS_MATXXL_PRICE_LEVEL
                 FROM DIM_GOOD B
                WHERE B.CURRENT_FLG = 'Y'
                  AND B.GOOD_PRICE_LEVEL IS NOT NULL) C,
              GOODS_LABEL_HEAD D
        WHERE C.GOODS_MATXXL_PRICE_LEVEL = D.G_LABEL_NAME
          AND D.G_LABEL_ID IN (1077, 1078, 1079)) S
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

--4.
SELECT * FROM S_PARAMETERS2 A FOR UPDATE;
