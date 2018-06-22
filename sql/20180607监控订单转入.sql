--*************************************************************************************
--OD_ORDER-->SAP_BIC_AZTCRD00100
--*************************************************************************************
--分日期
SELECT
  TRUNC(A.ORDER_DATE) ORDER_DATE,
  COUNT(1)
FROM ODSHAPPIGO.OD_ORDER_ITEM A
WHERE A.ORDER_DATE >= DATE '2018-01-01'
      AND NOT EXISTS
(SELECT 1
 FROM ODSHAPPIGO.SAP_BIC_AZTCRD00100 B
 WHERE A.ORDER_NO || A.ORDER_GB || A.ORDER_SEQ = B.CRM_ITMGUI)
      AND A.ORDER_GB IN ('HM20', 'HM21', 'HM30', 'HM41', 'HM42')
GROUP BY TRUNC(A.ORDER_DATE)
ORDER BY TRUNC(A.ORDER_DATE) DESC;

--*************************************************************************************
--SAP_BIC_AZTCRD00100-->ODS_ORDER
--*************************************************************************************
--分日期
SELECT
  A.CRMPOSTDAT,
  COUNT(1)
FROM ODSHAPPIGO.SAP_BIC_AZTCRD00100 A
WHERE NOT EXISTS(SELECT 1
                 FROM ODSHAPPIGO.ODS_ORDER B
                 WHERE B.CRM_ITMGUI = A.CRM_ITMGUI)
GROUP BY A.CRMPOSTDAT
ORDER BY A.CRMPOSTDAT DESC;

--*****************************************************************************************
--ODS_ORDER-->fact_goods_sales检查
--*****************************************************************************************
--日期
SELECT
  A.CRMPOSTDAT,
  COUNT(1)
FROM ODSHAPPIGO.ODS_ORDER A
WHERE NOT EXISTS(SELECT 1
                 FROM FACT_GOODS_SALES B
                 WHERE A.ZTCRMC04 = B.ORDER_KEY)
      AND A.CRMPOSTDAT >= 20180101
      AND A.CRM_PRCTYP IN ('ZA01', 'ZA02', 'ZA03')
GROUP BY A.CRMPOSTDAT
ORDER BY A.CRMPOSTDAT desc;

--日期、渠道
SELECT
  A.CRMPOSTDAT,
  A.CRM_SOLDTO,
  COUNT(1)
FROM ODSHAPPIGO.ODS_ORDER A
WHERE NOT EXISTS(SELECT 1
                 FROM FACT_GOODS_SALES B
                 WHERE A.ZTCRMC04 = B.ORDER_KEY)
      AND A.CRMPOSTDAT >= 20180101
      AND A.CRM_PRCTYP IN ('ZA01', 'ZA02', 'ZA03')
GROUP BY A.CRMPOSTDAT, A.CRM_SOLDTO
ORDER BY A.CRMPOSTDAT desc, A.CRM_SOLDTO;

SELECT
  A.CRMPOSTDAT,
  A.CRM_SOLDTO,
  A.ZTCRMC04
FROM ODSHAPPIGO.ODS_ORDER A
WHERE NOT EXISTS(SELECT 1
                 FROM FACT_GOODS_SALES B
                 WHERE A.ZTCRMC04 = B.ORDER_KEY)
      AND A.CRMPOSTDAT >= 20180101
      AND A.CRM_PRCTYP IN ('ZA01', 'ZA02', 'ZA03')
ORDER BY A.CRMPOSTDAT DESC, A.CRM_SOLDTO, A.ZTCRMC04;

SELECT *
FROM ODSHAPPIGO.ODS_ORDER A
WHERE A.ZTCRMC04 = 5208563313;
SELECT *
FROM FACT_GOODS_SALES A
WHERE A.ORDER_KEY = 5208563313;

CALL CREATEORDERGOODS(20180527);
CALL PROCESSUPDATEORDER(20180527);

--*****************************************************************************************
--ODS_ORDER-->fact_goods_sales_reverse检查
--*****************************************************************************************
--日期
SELECT
  A.CRMPOSTDAT,
  COUNT(1)
FROM ODSHAPPIGO.ODS_ORDER A
WHERE NOT EXISTS(SELECT 1
                 FROM FACT_GOODS_SALES_REVERSE B
                 WHERE A.ZTCRMC04 = B.ORDER_KEY)
      AND A.CRMPOSTDAT >= 20180101
      AND A.CRM_PRCTYP = 'ZB01'
GROUP BY A.CRMPOSTDAT
ORDER BY A.CRMPOSTDAT desc;



