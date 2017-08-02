/*
１。捞取电商6-7月活跃会员5万人，按照订购频次排序
２。１到３月份又订购但是４到７月份没有产生订购的会员（电商订购）（带会员等级）
３。针对对应商品调取近1个月浏览和加车但没有订购的会员信息
*/
--1.捞取电商6-7月活跃会员5万人，按照订购频次排序
SELECT *
  FROM (SELECT B.MEMBER_KEY, COUNT(B.ORDER_KEY) ORDER_COUNT
          FROM (SELECT A.MEMBER_KEY, A.ORDER_KEY
                  FROM FACT_ORDER A
                 WHERE A.POSTING_DATE_KEY BETWEEN 20170601 AND 20170731
                   AND A.ORDER_STATE = 1
                   AND A.SALES_SOURCE_KEY = 20) B
         GROUP BY B.MEMBER_KEY
         ORDER BY COUNT(B.ORDER_KEY) DESC) C
 WHERE ROWNUM <= 50000;
--2.１到３月份又订购但是４到７月份没有产生订购的会员（电商订购）（带会员等级）
SELECT B.MEMBER_KEY,
       NVL(MAX(B.MEMBER_GRADE_DESC), 'HAPP_T0') MEMBER_GRADE_DESC
  FROM FACT_ORDER B
 WHERE B.POSTING_DATE_KEY BETWEEN 20170101 AND 20170331
   AND B.ORDER_STATE = 1
   AND B.SALES_SOURCE_KEY = 20
   AND NOT EXISTS
 (SELECT 1
          FROM (SELECT A.MEMBER_KEY
                  FROM FACT_ORDER A
                 WHERE A.POSTING_DATE_KEY BETWEEN 20170401 AND 20170731
                   AND A.ORDER_STATE = 1
                   AND A.SALES_SOURCE_KEY = 20) C
         WHERE B.MEMBER_KEY = C.MEMBER_KEY)
 GROUP BY B.MEMBER_KEY
 ORDER BY 1;

--3.针对对应商品调取近1个月浏览和加车但没有订购的会员信息
/*
217789
222658
200414
223817
223074
213888
215063
215646
204964 
222069
217368
215983 
217769 
188801 
222815
220709 
*/

SELECT DISTINCT D.MEMBER_KEY
  FROM ( /*浏览*/
        SELECT /*+PARALLEL(16)*/
        DISTINCT A.MEMBER_KEY
          FROM FACT_PAGE_VIEW A
         WHERE A.VISIT_DATE_KEY BETWEEN 20170626 AND 20170725
           AND A.PAGE_NAME IN ('good', 'Good')
           AND A.PAGE_VALUE IN
               (SELECT TO_CHAR(A1.GOODS_COMMONID)
                  FROM DIM_GOOD A1
                 WHERE A1.ITEM_CODE IN (217789,
                                        222658,
                                        200414,
                                        223817,
                                        223074,
                                        213888,
                                        215063,
                                        215646,
                                        204964,
                                        222069,
                                        217368,
                                        215983,
                                        217769,
                                        188801,
                                        222815,
                                        220709)
                   AND A1.GOODS_COMMONID IS NOT NULL)
        UNION ALL
        /*加车*/
        SELECT /*+PARALLEL(16)*/
        DISTINCT B.MEMBER_KEY
          FROM FACT_SHOPPINGCAR B
         WHERE B.CREATE_DATE BETWEEN DATE '2017-06-26' AND DATE
         '2017-07-25'
           AND B.SCGID IN (SELECT B1.GOODS_COMMONID
                             FROM DIM_GOOD B1
                            WHERE B1.ITEM_CODE IN (217789,
                                                   222658,
                                                   200414,
                                                   223817,
                                                   223074,
                                                   213888,
                                                   215063,
                                                   215646,
                                                   204964,
                                                   222069,
                                                   217368,
                                                   215983,
                                                   217769,
                                                   188801,
                                                   222815,
                                                   220709))) D
 WHERE NOT EXISTS
 (SELECT 1
          FROM ( /*订购*/
                SELECT /*+PARALLEL(16)*/
                DISTINCT C.MEMBER_KEY
                  FROM FACT_GOODS_SALES C
                 WHERE C.POSTING_DATE_KEY BETWEEN 20170626 AND 20170725
                   AND C.ORDER_STATE = 1
                   AND C.GOODS_COMMON_KEY IN (217789,
                                              222658,
                                              200414,
                                              223817,
                                              223074,
                                              213888,
                                              215063,
                                              215646,
                                              204964,
                                              222069,
                                              217368,
                                              215983,
                                              217769,
                                              188801,
                                              222815,
                                              220709)) E
         WHERE D.MEMBER_KEY = E.MEMBER_KEY);



--tmp
SELECT * from fact_goods_page_view;
SELECT distinct a.page_name
  FROM FACT_PAGE_VIEW A
 WHERE A.VISIT_DATE_KEY BETWEEN 20170626 AND 20170725;
select * from fact_shoppingcar;
