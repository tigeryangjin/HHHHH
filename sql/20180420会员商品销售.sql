--****************************************************
--FACT_EC_ORDER_2
--****************************************************
--1. 4.5~4.7
SELECT A.ORDER_ID, A.CUST_NO, B.ERP_CODE, SUM(B.GOODS_NUM) ORDER_QTY
  FROM FACT_EC_ORDER_2 A, FACT_EC_ORDER_GOODS B
 WHERE A.ORDER_ID = B.ORDER_ID
   AND TRUNC(A.ADD_TIME) BETWEEN DATE '2018-04-05' AND DATE
 '2018-04-07'
   AND A.ORDER_STATE >= 20
   AND A.ORDER_FROM <> '76'
   AND B.ERP_CODE IN (214964,
                      214965,
                      234808,
                      234809,
                      234790,
                      234791,
                      234792,
                      230836,
                      236052,
                      236053,
                      230628,
                      230629,
                      230630,
                      230631,
                      230632,
                      232206,
                      232207,
                      232208,
                      232209)
 GROUP BY A.ORDER_ID, A.CUST_NO, B.ERP_CODE
 ORDER BY A.ORDER_ID, A.CUST_NO, B.ERP_CODE;

--2.
SELECT A.ORDER_ID, A.CUST_NO, B.ERP_CODE, SUM(B.GOODS_NUM) ORDER_QTY
  FROM FACT_EC_ORDER_2 A, FACT_EC_ORDER_GOODS B
 WHERE A.ORDER_ID = B.ORDER_ID
   AND TRUNC(A.ADD_TIME) BETWEEN DATE '2018-04-02' AND DATE
 '2018-04-05'
   AND A.ORDER_STATE >= 20
   AND A.ORDER_FROM <> '76'
   AND B.ERP_CODE IN (235332,
                      235327,
                      235328,
                      235324,
                      235323,
                      235309,
                      235330,
                      235325,
                      235331,
                      235326,
                      235329,
                      235322,
                      235321,
                      235320,
                      234320,
                      234322,
                      234324,
                      234309,
                      234321,
                      235712,
                      235700,
                      235701,
                      235702,
                      235703,
                      235704,
                      235705,
                      235706,
                      235707,
                      235708,
                      235709,
                      235710,
                      235711,
                      209843,
                      205501,
                      210096,
                      222260,
                      205502,
                      224539,
                      221650,
                      232430,
                      232431,
                      222073,
                      205822,
                      221651,
                      205819,
                      221663,
                      224540,
                      222085,
                      235311,
                      235310,
                      234285,
                      234286,
                      222434,
                      222435,
                      215496,
                      232783,
                      215563,
                      216988,
                      216987,
                      223273,
                      216985,
                      216986,
                      234133,
                      217769,
                      234308,
                      228567,
                      234823,
                      233820,
                      230294,
                      225320,
                      225319,
                      229094,
                      228568,
                      230297,
                      228803)
 GROUP BY A.ORDER_ID, A.CUST_NO, B.ERP_CODE
 ORDER BY A.ORDER_ID, A.CUST_NO, B.ERP_CODE;

--****************************************************
--FACTEC_ORDER
--****************************************************
--1.
SELECT A.MEMBER_KEY, B.ITEM_CODE, SUM(B.GOODS_NUM)
  FROM FACTEC_ORDER A, FACTEC_ORDER_GOODS B
 WHERE A.ORDER_ID = B.ORDER_ID
   AND A.ORDER_STATE >= 20
   AND A.ORDER_FROM <> 76
   AND A.ADD_TIME BETWEEN 20180405 AND 20180407
   AND B.ITEM_CODE IN (214964,
                       214965,
                       234808,
                       234809,
                       234790,
                       234791,
                       234792,
                       230836,
                       236052,
                       236053,
                       230628,
                       230629,
                       230630,
                       230631,
                       230632,
                       232206,
                       232207,
                       232208,
                       232209)
 GROUP BY A.MEMBER_KEY, B.ITEM_CODE
 ORDER BY A.MEMBER_KEY, B.ITEM_CODE;

--2.
SELECT A.MEMBER_KEY, B.ITEM_CODE, SUM(B.GOODS_NUM)
  FROM FACTEC_ORDER A, FACTEC_ORDER_GOODS B
 WHERE A.ORDER_ID = B.ORDER_ID
   AND A.ADD_TIME BETWEEN 20180402 AND 20180405
   AND B.ITEM_CODE IN (235332,
                       235327,
                       235328,
                       235324,
                       235323,
                       235309,
                       235330,
                       235325,
                       235331,
                       235326,
                       235329,
                       235322,
                       235321,
                       235320,
                       234320,
                       234322,
                       234324,
                       234309,
                       234321,
                       235712,
                       235700,
                       235701,
                       235702,
                       235703,
                       235704,
                       235705,
                       235706,
                       235707,
                       235708,
                       235709,
                       235710,
                       235711,
                       209843,
                       205501,
                       210096,
                       222260,
                       205502,
                       224539,
                       221650,
                       232430,
                       232431,
                       222073,
                       205822,
                       221651,
                       205819,
                       221663,
                       224540,
                       222085,
                       235311,
                       235310,
                       234285,
                       234286,
                       222434,
                       222435,
                       215496,
                       232783,
                       215563,
                       216988,
                       216987,
                       223273,
                       216985,
                       216986,
                       234133,
                       217769,
                       234308,
                       228567,
                       234823,
                       233820,
                       230294,
                       225320,
                       225319,
                       229094,
                       228568,
                       230297,
                       228803)
 GROUP BY A.MEMBER_KEY, B.ITEM_CODE
 ORDER BY A.MEMBER_KEY, B.ITEM_CODE;
