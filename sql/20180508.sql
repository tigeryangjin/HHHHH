SELECT * FROM ALL_ALL_TABLES A WHERE A.owner='DW_USER';
SELECT * FROM FACT_GOODS_EVALUATE;

select * from OPER_CLICK_ANALYSIS t WHERE T.PAGE_NAME='SL_TV_Hotgood';

select * from OPER_CLICK_ANALYSIS t WHERE T.DATE_KEY=20180508 AND T.PAGE_NAME='SL_TV_Hotgood';

SELECT *
  FROM W_ETL_LOG A
 WHERE A.PROC_NAME = 'MEMBER_LABEL_PKG.MEMBER_INJURED_PERIOD'
 ORDER BY A.START_TIME DESC;

SELECT SYSDATE FROM DUAL;

SELECT *
  FROM MEMBER_LABEL_HEAD A
 WHERE A.M_LABEL_ID IN (237,
                        238,
                        240,
                        242,
                        244,
                        245,
                        247,
                        250,
                        251,
                        253,
                        254,
                        393,
                        394,
                        397);

UPDATE MEMBER_LABEL_HEAD A
   SET A.M_LABEL_NAME = A.M_LABEL_DESC, A.LAST_UPDATE_DATE = SYSDATE
 WHERE A.M_LABEL_ID IN (237,
                        238,
                        240,
                        242,
                        244,
                        245,
                        247,
                        250,
                        251,
                        253,
                        254,
                        393,
                        394,
                        397);

SELECT A.M_LABEL_NAME, COUNT(1)
  FROM MEMBER_LABEL_HEAD A
 GROUP BY A.M_LABEL_NAME
HAVING COUNT(1) > 1;

SELECT *
  FROM MEMBER_LABEL_HEAD A
 WHERE A.M_LABEL_NAME IN ('360好搜',
                          '亿起发手机soso',
                          '多麦',
                          '搜狗',
                          '智汇推(ZHT)',
                          '百度',
                          '领克特');

UPDATE GOODS_LABEL_HEAD A SET A.LAST_UPDATE_DATE = SYSDATE;

SELECT * FROM GOODS_LABEL_HEAD;

SELECT COUNT(1)
  FROM YANGJIN.ORDER_FROM_TMP A
 WHERE A.ZCRMD018 IS NOT NULL
   AND A.IS_UPDATE IS NULL;

SELECT A.DATE_KEY, COUNT(1)
  FROM OPER_GOOD_LABEL_ANALYSIS A
 GROUP BY A.DATE_KEY
 ORDER BY A.DATE_KEY;

SELECT *
  FROM W_ETL_LOG A
 WHERE A.PROC_NAME = 'processmblabelsource'
 ORDER BY A.START_TIME DESC;

SELECT MAX(B.R)
  FROM (SELECT ROWNUM R, A.CRM_OBJ_ID, A.ZCRMD018, A.IS_UPDATE
          FROM YANGJIN.ORDER_FROM_TMP A) B
 WHERE B.IS_UPDATE = 1;

SELECT B.R, B.CRM_OBJ_ID, B.ZCRMD018, B.IS_UPDATE
  FROM (SELECT ROWNUM R, A.CRM_OBJ_ID, A.ZCRMD018, A.IS_UPDATE
          FROM YANGJIN.ORDER_FROM_TMP A) B
 WHERE B.R >= 483000;

SELECT *
  FROM FACT_ORDER A
 WHERE A.POSTING_DATE_KEY = 20180503
   AND A.ORDER_FROM IS NULL;

SELECT * FROM ODSHAPPIGO.ODS_ORDER A WHERE A.CRM_OBJ_ID = 5208127337;
SELECT * FROM YANGJIN.ORDER_FROM_TMP A WHERE A.CRM_OBJ_ID = 5208127337;

SELECT * FROM ODSHAPPIGO.ODS_ORDER A WHERE A.ZCRMD018 IS NULL;

SELECT COUNT(1)
  FROM (SELECT DISTINCT B.CRM_OBJ_ID, B.CRM_PRCTYP, B.ZCRMD018
          FROM ODSHAPPIGO.ODS_ORDER B
         WHERE B.ZCRMD018 IS NOT NULL);

SELECT COUNT(1)
  FROM (SELECT DISTINCT B.CRM_OBJ_ID, B.CRM_PRCTYP, B.ZCRMD018
          FROM ODSHAPPIGO.ODS_ORDER B
         WHERE B.ZCRMD018 IS NOT NULL
           AND B.CRM_PRCTYP IN ('ZA01', 'ZA02', 'ZA03'));
