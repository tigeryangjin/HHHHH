/*���*/
SELECT DISTINCT A.MEMBER_KEY
  FROM FACT_PAGE_VIEW A
 WHERE A.VISIT_DATE_KEY BETWEEN 20170401 AND 20170731
   AND A.PAGE_NAME IN ('good', 'Good')
   AND A.PAGE_VALUE IN (SELECT TO_CHAR(C.GOODS_COMMONID)
                          FROM DIM_GOOD C
                         WHERE C.ITEM_CODE IN (217060,
                                               217061,
                                               211796,
                                               212282,
                                               223654,
                                               216975,
                                               222727,
                                               222601,
                                               221793,
                                               215663,
                                               217427,
                                               216953,
                                               210260,
                                               216953,
                                               222602,
                                               222433,
                                               217519,
                                               217777,
                                               218832))
UNION ALL
/*�ӳ�*/
SELECT DISTINCT B.MEMBER_KEY
  FROM FACT_SHOPPINGCAR B
 WHERE B.CREATE_DATE BETWEEN DATE '2017-04-01' AND DATE
 '2017-07-31'
   AND B.SCGID IN (SELECT C.GOODS_COMMONID
                     FROM DIM_GOOD C
                    WHERE C.ITEM_CODE IN (217060,
                                          217061,
                                          211796,
                                          212282,
                                          223654,
                                          216975,
                                          222727,
                                          222601,
                                          221793,
                                          215663,
                                          217427,
                                          216953,
                                          210260,
                                          216953,
                                          222602,
                                          222433,
                                          217519,
                                          217777,
                                          218832));

SELECT C.GOODS_COMMONID
  FROM DIM_GOOD C
 WHERE C.ITEM_CODE IN (217060,
                       217061,
                       211796,
                       212282,
                       223654,
                       216975,
                       222727,
                       222601,
                       221793,
                       215663,
                       217427,
                       216953,
                       210260,
                       216953,
                       222602,
                       222433,
                       217519,
                       217777,
                       218832);

SELECT *
  FROM DIM_MBLEVEL_DCGOOD C
 WHERE TRUNC(C.START_TIME) = DATE '2017-08-03';
