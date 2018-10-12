--**********************************************************
--1.3个月 空调(430102)、冰箱(430101)、风扇(440201)、塔扇、凉席(490205,490502) 浏览加车未订购用户
--**********************************************************
--1.1.
CREATE TABLE YANGJIN.PV_TMP AS
SELECT /*+PARALLEL(16)*/
 A.VISIT_DATE_KEY, A.MEMBER_KEY, A.PAGE_VALUE GOODS_COMMONID
  FROM FACT_PAGE_VIEW A
 WHERE A.VISIT_DATE_KEY BETWEEN 20180401 AND 20180711
   AND A.PAGE_NAME IN ('good', 'Good')
   AND A.MEMBER_KEY <> 0
   AND A.PAGE_VALUE =
       TRANSLATE(A.PAGE_VALUE,
                 '0' || TRANSLATE(A.PAGE_VALUE, '#0123456789', '#'),
                 '0');
							
--1.2.			 					 
SELECT DISTINCT A3.MEMBER_KEY
  FROM (
        --浏览
        SELECT A.MEMBER_KEY
          FROM YANGJIN.PV_TMP A
         WHERE A.VISIT_DATE_KEY BETWEEN 20180411 AND 20180711
           AND EXISTS
         (SELECT 1
                  FROM DIM_EC_GOOD B
                 WHERE A.GOODS_COMMONID = B.GOODS_COMMONID
                   AND B.MATXL IN (430102, 430101, 440201, 490205, 490502))
        UNION ALL
        --加车
        SELECT A1.MEMBER_KEY
          FROM FACT_SHOPPINGCAR A1
         WHERE A1.CREATE_DATE_KEY BETWEEN 20180401 AND 20180711
           AND A1.MEMBER_KEY <> 0
           AND EXISTS
         (SELECT 1
                  FROM DIM_EC_GOOD B1
                 WHERE A1.SCGID = B1.GOODS_COMMONID
                   AND B1.MATXL IN (430102, 430101, 440201, 490205, 490502))) A3
 WHERE NOT EXISTS
 (SELECT 1
          FROM ( --订购
                SELECT A2.MEMBER_KEY
                  FROM FACT_GOODS_SALES A2
                 WHERE A2.POSTING_DATE_KEY BETWEEN 20180401 AND 20180711
                   AND A2.ORDER_STATE = 1
                   AND EXISTS
                 (SELECT 1
                          FROM DIM_EC_GOOD B2
                         WHERE A2.GOODS_COMMON_KEY = B2.ITEM_CODE
                           AND B2.MATXL IN
                               (430102, 430101, 440201, 490205, 490502))) A4
         WHERE A3.MEMBER_KEY = A4.MEMBER_KEY)
 ORDER BY A3.MEMBER_KEY;



--**********************************************************
--2.3个月注册未订购用户
--**********************************************************
SELECT DISTINCT A.MEMBER_KEY
  FROM FACT_MEMBER_REGISTER A
 WHERE A.REGISTER_DATE_KEY >= TO_CHAR(SYSDATE - 90, 'YYYYMMDD')
   AND NOT EXISTS (SELECT 1
          FROM FACT_GOODS_SALES B
         WHERE A.MEMBER_KEY = B.MEMBER_KEY
           AND B.ORDER_STATE = 1)
 ORDER BY A.MEMBER_KEY;


--*********************************************************
--3.2个月必抢清单浏览加车未订购用户
--*********************************************************
--3.1
UPDATE YANGJIN.ITEM_CODE_TMP A
   SET A.GOODS_COMMONID =
       (SELECT B.GOODS_COMMONID
          FROM DIM_EC_GOOD B
         WHERE A.ITEM_CODE = B.ITEM_CODE)
 WHERE A.GOODS_COMMONID IS NULL;
 
--3.2
SELECT DISTINCT A3.MEMBER_KEY
  FROM (SELECT A.MEMBER_KEY
          FROM YANGJIN.PV_TMP A
         WHERE A.VISIT_DATE_KEY BETWEEN 20180511 AND 20180711
           AND EXISTS
         (SELECT 1
                  FROM YANGJIN.ITEM_CODE_TMP B
                 WHERE A.GOODS_COMMONID = B.GOODS_COMMONID)
        UNION ALL
        --加车
        SELECT A1.MEMBER_KEY
          FROM FACT_SHOPPINGCAR A1
         WHERE A1.CREATE_DATE_KEY BETWEEN 20180511 AND 20180711
           AND A1.MEMBER_KEY <> 0
           AND EXISTS (SELECT 1
                  FROM YANGJIN.ITEM_CODE_TMP B1
                 WHERE A1.SCGID = B1.GOODS_COMMONID)) A3
 WHERE NOT EXISTS
 (SELECT 1
          FROM ( --订购
                SELECT A2.MEMBER_KEY
                  FROM FACT_GOODS_SALES A2
                 WHERE A2.POSTING_DATE_KEY BETWEEN 20180511 AND 20180711
                   AND A2.ORDER_STATE = 1
                   AND EXISTS
                 (SELECT 1
                          FROM YANGJIN.ITEM_CODE_TMP B2
                         WHERE A2.GOODS_COMMON_KEY = B2.ITEM_CODE)) A4
         WHERE A3.MEMBER_KEY = A4.MEMBER_KEY)
 ORDER BY A3.MEMBER_KEY;

 

--tmp
SELECT A.ITEM_CODE,
       A.GOODS_NAME,
       A.MATDL,
       A.MATDLT,
       A.MATZL,
       A.MATZLT,
       A.MATXL,
       A.MATXLT,
       A.MATKL,
       A.MATKLT
  FROM DIM_EC_GOOD A
 WHERE A.MATXLT LIKE '%凉席%'
    OR A.MATKLT LIKE '%凉席%'
 ORDER BY A.MATDL, A.MATZL, A.MATXL, A.MATKL;
