--1.
SELECT *
  FROM W_ETL_LOG A
 WHERE A.PROC_NAME = 'MEMBER_LABEL_PKG.FIRST_ORDER_ITEM'
 ORDER BY A.START_TIME DESC;

SELECT * FROM MEMBER_LABEL_HEAD;

--2.
SELECT P.*
/*BULK COLLECT
INTO VAR_ARRAY*/
  FROM (SELECT A.MEMBER_KEY,
               TO_CHAR(TRUNC(MIN(A.CREATE_DATE)), 'YYYYMMDD') CREATE_DATE
          FROM MEMBER_LABEL_LINK A
         WHERE A.M_LABEL_ID = 42
         GROUP BY A.MEMBER_KEY) P
 WHERE EXISTS (SELECT 1
          FROM FACT_GOODS_SALES B
         WHERE B.ORDER_STATE = 1
              /*订购日期大于未产生首单标签的日期*/
           AND B.POSTING_DATE_KEY >= CREATE_DATE
           AND P.MEMBER_KEY = B.MEMBER_KEY);

--3.
UPDATE MEMBER_LABEL_LINK A
   SET (A.M_LABEL_ID,
        --A.M_LABEL_TYPE_ID,
        A.LAST_UPDATE_DATE,
        A.LAST_UPDATE_USER_ID) =
       (SELECT NVL(MLH.M_LABEL_ID, 42),
               * 如果M_LABEL_ID为空，则默认为42，未产生首单 *
               --NVL(MLH.M_LABEL_TYPE_ID, 1),
                SYSDATE,
               'yangjin'
          FROM * 首单订购金额最大的商品 *
                (SELECT A.MEMBER_KEY,
                        A.ORDER_KEY,
                        MIN(A.GOODS_COMMON_KEY) GOODS_COMMON_KEY,
                        A.ORDER_AMOUNT
                   FROM FACT_GOODS_SALES A
                  WHERE A.ORDER_STATE = 1
                    AND A.GOODS_COMMON_KEY IS NOT NULL
                    AND EXISTS
                  (SELECT 1
                           FROM (SELECT C.MEMBER_KEY, MIN(C.ORDER_KEY) ORDER_KEY
                                   FROM FACT_GOODS_SALES C
                                  WHERE C.ORDER_STATE = 1
                                    AND C.GOODS_COMMON_KEY IS NOT NULL
                                  GROUP BY C.MEMBER_KEY) B
                          WHERE A.MEMBER_KEY = B.MEMBER_KEY
                            AND A.ORDER_KEY = B.ORDER_KEY)
                    AND EXISTS
                  (SELECT 1
                           FROM (SELECT C.MEMBER_KEY,
                                        C.ORDER_KEY,
                                        MAX(C.ORDER_AMOUNT) ORDER_AMOUNT
                                   FROM FACT_GOODS_SALES C
                                  WHERE C.ORDER_STATE = 1
                                    AND C.GOODS_COMMON_KEY IS NOT NULL
                                  GROUP BY C.MEMBER_KEY, C.ORDER_KEY) D
                          WHERE A.MEMBER_KEY = D.MEMBER_KEY
                            AND A.ORDER_KEY = D.ORDER_KEY
                            AND A.ORDER_AMOUNT = D.ORDER_AMOUNT)
                    AND A.MEMBER_KEY = VAR_ARRAY(I).MEMBER_KEY
                  GROUP BY A.MEMBER_KEY, A.ORDER_KEY, A.ORDER_AMOUNT) ORD,
               * 商品标签分类 * (SELECT A.ITEM_CODE,
                        CASE
                          WHEN A.GROUP_ID = 1000 AND EXISTS
                           (SELECT 1
                                  FROM DIM_TV_GOOD B
                                 WHERE A.ITEM_CODE = B.ITEM_CODE) THEN
                           'FIRST_ORDER_BROADCAST'
                          WHEN A.GROUP_ID = 1000 THEN
                           'FIRST_ORDER_NOT_BROADCAST'
                          WHEN A.GROUP_ID = 2000 AND EXISTS
                           (SELECT 1
                                  FROM DIM_EC_GOOD C
                                 WHERE A.ITEM_CODE = C.ITEM_CODE
                                   AND C.STORE_ID = 1) THEN
                           'FIRST_ORDER_SELF'
                          WHEN A.GROUP_ID = 2000 AND EXISTS
                           (SELECT 1
                                  FROM DIM_EC_GOOD C
                                 WHERE A.ITEM_CODE = C.ITEM_CODE
                                   AND C.STORE_ID <> 1) THEN
                           'FIRST_ORDER_BBC'
                          ELSE
                           'FIRST_ORDER_OTHER'
                        END ITEM_LABEL
                   FROM DIM_GOOD A
                  WHERE A.CURRENT_FLG = 'Y') ITEM,
               (SELECT * FROM MEMBER_LABEL_HEAD) MLH
         WHERE ORD.GOODS_COMMON_KEY = ITEM.ITEM_CODE
           AND ITEM.ITEM_LABEL = MLH.M_LABEL_NAME)
 WHERE A.M_LABEL_ID = 42
   AND A.MEMBER_KEY = VAR_ARRAY(I).MEMBER_KEY;
