---
SELECT (CASE
         WHEN 高消费线 > PRICE43 * 1.2 THEN
          PRICE43 * 1.2
         ELSE
          高消费线
       END
       
       ) 最高消费,
       (CASE
         WHEN 低消费线 < PRICE41 * 0.8 THEN
          PRICE41 * 0.8
         ELSE
          低消费线
       END
       
       ) 低消费线,
       MATKL,
       MATKLT
  FROM (SELECT D.MATKL,
               D.MATKLT,
               PRICE43,
               PRICE41,
               最贵,
               商品数,
               最便宜,
               中位数,
               平均值,
               方差,
               高消费线,
               低消费线
          FROM (SELECT MEDIAN(GOODS_PRICE) PRICE41, MATKL
                  FROM (SELECT AA.MATKL,
                               AA.MATKLT,
                               AA.GOODS_PRICE,
                               BB.MEDPRICE
                          FROM DIM_EC_GOOD AA
                          LEFT JOIN (SELECT MEDIAN(GOODS_PRICE) MEDPRICE,
                                           MATKL,
                                           MATKLT
                                      FROM DIM_EC_GOOD
                                     WHERE STORE_ID = 1
                                       AND GOODS_PRICE > 0
                                     GROUP BY MATKL, MATKLT) BB
                            ON AA.MATKL = BB.MATKL)
                 WHERE GOODS_PRICE < MEDPRICE
                 GROUP BY MATKL) A
          LEFT JOIN (SELECT MEDIAN(GOODS_PRICE) PRICE43, MATKL
                      FROM (SELECT GOODS_PRICE, AA.MATKL, AA.MATKLT, MEDPRICE
                              FROM DIM_EC_GOOD AA
                              LEFT JOIN (SELECT MEDIAN(GOODS_PRICE) MEDPRICE,
                                               MATKL,
                                               MATKLT
                                          FROM DIM_EC_GOOD
                                         WHERE STORE_ID = 1
                                           AND GOODS_PRICE > 0
                                         GROUP BY MATKL, MATKLT) BB
                                ON AA.MATKL = BB.MATKL)
                     WHERE GOODS_PRICE > MEDPRICE
                     GROUP BY MATKL) B
            ON A.MATKL = B.MATKL
          LEFT JOIN((SELECT MATKL,
                           MATKLT,
                           MAX(GOODS_PRICE) 最贵,
                           COUNT(1) 商品数,
                           MIN(GOODS_PRICE) 最便宜,
                           MEDIAN(GOODS_PRICE) 中位数,
                           AVG(GOODS_PRICE) 平均值,
                           STDDEV(GOODS_PRICE) 方差,
                           AVG(GOODS_PRICE) + STDDEV(GOODS_PRICE) 高消费线,
                           AVG(GOODS_PRICE) - STDDEV(GOODS_PRICE) 低消费线
                      FROM DIM_EC_GOOD
                     WHERE STORE_ID = 1
                       AND GOODS_PRICE > 0
                     GROUP BY MATKL, MATKLT)) D
            ON A.MATKL = D.MATKL);

--function
SELECT A.MATL_GROUP, COUNT(1)
  FROM DIM_GOOD A
 WHERE A.CURRENT_FLG = 'Y'
   AND A.GOOD_PRICE >= 0
 GROUP BY A.MATL_GROUP;
SELECT A.ITEM_CODE, A.GOOD_PRICE
  FROM DIM_GOOD A
 WHERE A.MATL_GROUP = 30020306
   AND A.GOOD_PRICE > 0;

SELECT A.ITEM_CODE,
       A.GOOD_PRICE,
       YANGJIN_PKG.DIM_GOOD_PRICE_LEVEL(A.ITEM_CODE)
  FROM DIM_GOOD A
 WHERE A.ITEM_CODE = 103745;

--update dim_good
DROP TABLE YJ_TMP2;
CREATE TABLE DIM_GOOD_PRICE_LEVEL AS
  SELECT A.ITEM_CODE,
         YANGJIN_PKG.GET_DIM_GOOD_PRICE_LEVEL(A.ITEM_CODE) GOOD_PRICE_LEVEL
    FROM DIM_GOOD A
   WHERE A.CURRENT_FLG = 'Y'
     AND YANGJIN_PKG.GET_DIM_GOOD_PRICE_LEVEL(A.ITEM_CODE) IS NOT NULL;
		 
INSERT INTO DIM_GOOD_PRICE_LEVEL
  SELECT A.ITEM_CODE,
         YANGJIN_PKG.GET_DIM_GOOD_PRICE_LEVEL(A.ITEM_CODE) GOOD_PRICE_LEVEL
    FROM DIM_GOOD A
   WHERE A.CURRENT_FLG = 'Y'
     AND YANGJIN_PKG.GET_DIM_GOOD_PRICE_LEVEL(A.ITEM_CODE) IS NOT NULL;

UPDATE DIM_GOOD A
   SET A.GOOD_PRICE_LEVEL =
       (SELECT B.GOOD_PRICE_LEVEL
          FROM DIM_GOOD_PRICE_LEVEL B
         WHERE A.ITEM_CODE = B.ITEM_CODE)
 WHERE A.GOOD_PRICE > 0
   AND EXISTS (SELECT 1
          FROM DIM_GOOD_PRICE_LEVEL C
         WHERE A.ITEM_CODE = C.ITEM_CODE
           AND A.GOOD_PRICE_LEVEL <> C.GOOD_PRICE_LEVEL);
COMMIT;



SELECT A.ITEM_CODE, COUNT(1)
  FROM YJ_TMP2 A
 GROUP BY A.ITEM_CODE
HAVING COUNT(1) > 1;
SELECT * FROM DIM_GOOD A WHERE A.ITEM_CODE = 224518;

--tmp
SELECT * FROM W_ETL_LOG A WHERE A.PROC_NAME='YANGJIN_PKG.DIM_GOOD_PRICE_LEVEL_UPDATE' ORDER BY A.START_TIME DESC;
SELECT * FROM DIM_GOOD A WHERE A.GOOD_PRICE = 0;
SELECT * FROM DIM_GOOD A WHERE A.ITEM_CODE = 135881;
select * from dim_good a where a.matl_group = 49020402;
SELECT C.MATL_GROUP, MEDIAN(C.GOOD_PRICE) PRICE41
  FROM (SELECT A.MATL_GROUP, A.GOOD_PRICE, B.MEDIAN_PRICE
          FROM (SELECT A1.MATL_GROUP, A1.GOOD_PRICE
                  FROM DIM_GOOD A1
                 WHERE A1.GOOD_PRICE > 0
                   AND A1.MATL_GROUP = 46030202) A,
               (SELECT B1.MATL_GROUP, MEDIAN(B1.GOOD_PRICE) MEDIAN_PRICE
                  FROM DIM_GOOD B1
                 WHERE B1.GOOD_PRICE > 0
                   AND B1.MATL_GROUP = 46030202
                 GROUP BY B1.MATL_GROUP) B
         WHERE A.MATL_GROUP = B.MATL_GROUP(+)) C
 WHERE C.GOOD_PRICE <= C.MEDIAN_PRICE
 GROUP BY C.MATL_GROUP;

SELECT MEDIAN(I), AVG(I)
  FROM (SELECT 1 I
          FROM DUAL
        UNION ALL
        SELECT 2 I
          FROM DUAL
        UNION ALL
        SELECT 3 I
          FROM DUAL
        UNION ALL
        SELECT 4 I
          FROM DUAL
        UNION ALL
        SELECT 5 I
          FROM DUAL
        UNION ALL
        SELECT 6 I
          FROM DUAL
        UNION ALL
        SELECT 7 I
          FROM DUAL
        UNION ALL
        SELECT 8 I
          FROM DUAL
        UNION ALL
        SELECT 9 I
          FROM DUAL
        UNION ALL
        SELECT 1 I
          FROM DUAL);
SELECT 1 + 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8 + 9, 11 / 2 from dual;
