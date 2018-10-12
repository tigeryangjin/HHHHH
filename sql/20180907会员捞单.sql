/*
20180701-20180831  7-8月订购过美妆、食品类商品用户
*/
SELECT F.CUST_NO
  FROM (SELECT A.CUST_NO, COUNT(DISTINCT A.ORDER_ID) ORDER_CNT
          FROM FACT_EC_ORDER_2 A, FACT_EC_ORDER_GOODS B
         WHERE A.ORDER_ID = B.ORDER_ID
           AND A.ADD_TIME BETWEEN DATE '2018-07-01' AND DATE
         '2018-08-31'
           AND A.ORDER_STATE >= 20
           AND A.CUST_NO <> 0
           AND EXISTS
         (SELECT 1
                  FROM (SELECT D.GOODS_COMMONID
                          FROM DIM_EC_GOOD D, DIM_GOOD_CLASS E
                         WHERE D.MATDL = E.MATDL
                           AND E.GC_ID IN (4, 2)) C
                 WHERE B.GOODS_COMMONID = C.GOODS_COMMONID)
         GROUP BY A.CUST_NO) F
 ORDER BY F.CUST_NO;

/*
20180201-20180630 2-6月订购过美妆、食品类商品但7-8月未订购美妆、食品类商品用户
*/
SELECT DISTINCT F.CUST_NO
  FROM (SELECT A.CUST_NO, COUNT(DISTINCT A.ORDER_ID) ORDER_CNT
          FROM FACT_EC_ORDER_2 A, FACT_EC_ORDER_GOODS B
         WHERE A.ORDER_ID = B.ORDER_ID
           AND A.ADD_TIME BETWEEN DATE '2018-02-01' AND DATE
         '2018-06-30'
           AND A.ORDER_STATE >= 20
           AND A.CUST_NO <> 0
           AND EXISTS
         (SELECT 1
                  FROM (SELECT D.GOODS_COMMONID
                          FROM DIM_EC_GOOD D, DIM_GOOD_CLASS E
                         WHERE D.MATDL = E.MATDL
                           AND E.GC_ID IN (4, 2)) C
                 WHERE B.GOODS_COMMONID = C.GOODS_COMMONID)
         GROUP BY A.CUST_NO) F
 WHERE NOT EXISTS
 (SELECT 1
          FROM (SELECT A.CUST_NO, COUNT(DISTINCT A.ORDER_ID) ORDER_CNT
                  FROM FACT_EC_ORDER_2 A, FACT_EC_ORDER_GOODS B
                 WHERE A.ORDER_ID = B.ORDER_ID
                   AND A.ADD_TIME BETWEEN DATE '2018-07-01' AND DATE
                 '2018-08-31'
                   AND A.ORDER_STATE >= 20
                   AND A.CUST_NO <> 0
                   AND EXISTS
                 (SELECT 1
                          FROM (SELECT D.GOODS_COMMONID
                                  FROM DIM_EC_GOOD D, DIM_GOOD_CLASS E
                                 WHERE D.MATDL = E.MATDL
                                   AND E.GC_ID IN (4, 2)) C
                         WHERE B.GOODS_COMMONID = C.GOODS_COMMONID)
                 GROUP BY A.CUST_NO) G
         WHERE F.CUST_NO = G.CUST_NO)
   AND F.ORDER_CNT >= 2
 ORDER BY F.CUST_NO;

/*
2-8月浏览及订购过收藏品类商品用户，订购过瓷器类商品用户
450104瓷器/餐具
58投资收藏
*/
--订购
SELECT F.CUST_NO
  FROM (SELECT TO_NUMBER(A.CUST_NO) CUST_NO,
               COUNT(DISTINCT A.ORDER_ID) ORDER_CNT
          FROM FACT_EC_ORDER_2 A, FACT_EC_ORDER_GOODS B
         WHERE A.ORDER_ID = B.ORDER_ID
           AND A.ADD_TIME BETWEEN DATE '2018-02-01' AND DATE
         '2018-08-31'
           AND A.ORDER_STATE >= 20
           AND A.CUST_NO <> 0
           AND EXISTS
         (SELECT 1
                  FROM (SELECT D.GOODS_COMMONID
                          FROM DIM_EC_GOOD D, DIM_GOOD_CLASS E
                         WHERE D.MATDL = E.MATDL
                           AND (E.MATDL = 58 OR E.MATXL = 450104)) C
                 WHERE B.GOODS_COMMONID = C.GOODS_COMMONID)
         GROUP BY A.CUST_NO) F
 ORDER BY F.CUST_NO;

--加车
SELECT DISTINCT A.MEMBER_KEY
  FROM FACT_SHOPPINGCAR A
 WHERE A.CREATE_DATE_KEY BETWEEN 20180201 AND 20180831
   AND EXISTS (SELECT 1
          FROM (SELECT C.GOODS_COMMONID
                  FROM DIM_EC_GOOD C, DIM_GOOD_CLASS D
                 WHERE C.MATKL = D.MATKL
                   AND (D.MATDL = 58 OR D.MATXL = 450104)) B
         WHERE A.SCGID = B.GOODS_COMMONID)
 ORDER BY A.MEMBER_KEY;

--浏览

/*
浏览及订购过大闸蟹的用户
*/
CREATE TABLE YANGJIN.FACT_PAGE_VIEW_201808 AS
  SELECT *
    FROM FACT_PAGE_VIEW A
   WHERE A.VISIT_DATE_KEY BETWEEN 20180801 AND 20180831
     AND A.PAGE_NAME IN ('good', 'Good')
     AND A.MEMBER_KEY <> 0
     AND A.PAGE_VALUE =
         TRANSLATE(A.PAGE_VALUE,
                   '0' || TRANSLATE(A.PAGE_VALUE, '#0123456789', '#'),
                   '0');

SELECT *
  FROM (SELECT TO_NUMBER(F.CUST_NO) MEMBER_BP
          FROM (SELECT A.CUST_NO, COUNT(DISTINCT A.ORDER_ID) ORDER_CNT
                  FROM FACT_EC_ORDER_2 A, FACT_EC_ORDER_GOODS B
                 WHERE A.ORDER_ID = B.ORDER_ID
                   AND A.ADD_TIME BETWEEN DATE '2018-08-01' AND DATE
                 '2018-08-31'
                   AND A.ORDER_STATE >= 20
                   AND A.CUST_NO <> 0
                   AND EXISTS
                 (SELECT 1
                          FROM (SELECT D.GOODS_COMMONID
                                  FROM DIM_EC_GOOD D
                                 WHERE D.GOODS_NAME LIKE '%阳澄%') C
                         WHERE B.GOODS_COMMONID = C.GOODS_COMMONID)
                 GROUP BY A.CUST_NO) F
        UNION
        --浏览
        SELECT TO_NUMBER(A.MEMBER_KEY) MEMBER_BP
          FROM YANGJIN.FACT_PAGE_VIEW_201808 A
         WHERE EXISTS (SELECT 1
                  FROM (SELECT C.GOODS_COMMONID
                          FROM DIM_EC_GOOD C
                         WHERE C.GOODS_NAME LIKE '%阳澄%') B
                 WHERE A.PAGE_VALUE = B.GOODS_COMMONID)) Z
 ORDER BY Z.MEMBER_BP;

/*
6-8月在新媒体订购食品
*/
SELECT TO_NUMBER(F.CUST_NO) MEMBER_BP
  FROM (SELECT A.CUST_NO, COUNT(DISTINCT A.ORDER_ID) ORDER_CNT
          FROM FACT_EC_ORDER_2 A, FACT_EC_ORDER_GOODS B
         WHERE A.ORDER_ID = B.ORDER_ID
           AND A.ADD_TIME BETWEEN DATE '2018-06-01' AND DATE
         '2018-08-31'
           AND A.ORDER_STATE >= 20
           AND A.CUST_NO <> 0
           AND EXISTS
         (SELECT 1
                  FROM (SELECT D.GOODS_COMMONID
                          FROM DIM_EC_GOOD D, DIM_GOOD_CLASS E
                         WHERE D.MATDL = E.MATDL
                           AND E.Matdl = 51) C
                 WHERE B.GOODS_COMMONID = C.GOODS_COMMONID)
         GROUP BY A.CUST_NO) F
 ORDER BY F.CUST_NO;

--TMP
SELECT * FROM ALL_COL_COMMENTS A WHERE A.COLUMN_NAME = 'GC_ID';

SELECT * FROM DIM_EC_GOOD;
SELECT * FROM DIM_GOOD_CLASS A WHERE A.MATDLT LIKE '%大闸蟹%';
SELECT * FROM DIM_GOOD_CLASS A WHERE A.MATZLT LIKE '%大闸蟹%';
SELECT * FROM DIM_GOOD_CLASS A WHERE A.MATXLT LIKE '%大闸蟹%';
SELECT * FROM DIM_GOOD_CLASS A WHERE A.Matklt LIKE '%大闸蟹%';
SELECT * FROM DIM_EC_GOOD A WHERE A.GOODS_NAME LIKE '%阳澄%';
SELECT * FROM DIM_EC_GOOD A WHERE A.GOODS_NAME LIKE '%蟹%';
SELECT DISTINCT A.GC_NAME FROM DIM_GOOD_CLASS A;
SELECT DISTINCT A.MATDLT FROM DIM_GOOD_CLASS A;
