--1.����������������
SELECT C.DATE_KEY,
       C.CHANNEL_NAME,
       C.IS_NEW_USER,
       C.MEMBER_LEVEL,
       C.ITEM_CODE,
       COUNT(1) PV,
       COUNT(DISTINCT C.VID) UV
  FROM (SELECT A.PAGE_VIEW_KEY,
               A.VISIT_DATE_KEY DATE_KEY,
               A.VID,
               A.MEMBER_KEY,
               NVL(B.MEMBER_LEVEL, 'unregistered') MEMBER_LEVEL,
               NVL(B.FIRST_ORDER_DATE_KEY, 0) FIRST_ORDER_DATE_KEY,
               CASE
                 WHEN NVL(B.FIRST_ORDER_DATE_KEY, 0) = 0 THEN
                  'new_user'
                 WHEN B.FIRST_ORDER_DATE_KEY < A.VISIT_DATE_KEY THEN
                  'old_user'
                 WHEN B.FIRST_ORDER_DATE_KEY >= A.VISIT_DATE_KEY THEN
                  'new_user'
               END IS_NEW_USER,
               A.PAGE_VALUE ITEM_CODE,
               CASE
                 WHEN A.APPLICATION_KEY IN (10, 20) THEN
                  'APP'
                 WHEN A.APPLICATION_KEY = 30 THEN
                  '3G'
                 WHEN A.APPLICATION_KEY = 40 THEN
                  'PC'
                 WHEN A.APPLICATION_KEY = 50 THEN
                  '΢��'
               END CHANNEL_NAME
          FROM FACT_PAGE_VIEW A, DIM_MEMBER B
         WHERE A.MEMBER_KEY = B.MEMBER_BP(+)
           AND A.VISIT_DATE_KEY = 20180425
           AND UPPER(A.PAGE_NAME) IN ('GOOD', 'Good_Desc')
           AND A.PAGE_VALUE =
               TRANSLATE(A.PAGE_VALUE,
                         '0' || TRANSLATE(A.PAGE_VALUE, '#0123456789', '#'),
                         '0')) C
 GROUP BY C.DATE_KEY,
          C.CHANNEL_NAME,
          C.IS_NEW_USER,
          C.MEMBER_LEVEL,
          C.ITEM_CODE;

--2.  �ӹ��ﳵ����
SELECT C.DATE_KEY,
       C.CHANNEL_NAME,
       C.IS_NEW_USER,
       C.MEMBER_LEVEL,
       C.ITEM_CODE,
       COUNT(1) CAR_COUNT
  FROM (SELECT A.CREATE_DATE_KEY DATE_KEY,
               CASE
                 WHEN A.APPLICATION_KEY IN (10, 20) THEN
                  'APP'
                 WHEN A.APPLICATION_KEY = 30 THEN
                  '3G'
                 WHEN A.APPLICATION_KEY = 40 THEN
                  'PC'
                 WHEN A.APPLICATION_KEY = 50 THEN
                  '΢��'
               END CHANNEL_NAME,
               A.VID,
               A.MEMBER_KEY,
               NVL(B.MEMBER_LEVEL, 'unregistered') MEMBER_LEVEL,
               CASE
                 WHEN NVL(B.FIRST_ORDER_DATE_KEY, 0) = 0 THEN
                  'new_user'
                 WHEN B.FIRST_ORDER_DATE_KEY < A.CREATE_DATE_KEY THEN
                  'old_user'
                 WHEN B.FIRST_ORDER_DATE_KEY >= A.CREATE_DATE_KEY THEN
                  'new_user'
               END IS_NEW_USER,
               A.SCGID ITEM_CODE
          FROM FACT_SHOPPINGCAR A, DIM_MEMBER B
         WHERE A.MEMBER_KEY = B.MEMBER_BP(+)
           AND A.CREATE_DATE_KEY = 20180425) C
 GROUP BY C.DATE_KEY,
          C.CHANNEL_NAME,
          C.IS_NEW_USER,
          C.MEMBER_LEVEL,
          C.ITEM_CODE;

--3.�ղش���,û�а취��������,��ʱ����
SELECT * FROM FACT_FAVORITES A WHERE A.FAV_TIME = 20180425;

--4.��Ʒ���ۣ�û�а취������������ʱ����
select * from FACT_GOODS_EVALUATE t;

--5.����
SELECT G.POSTING_DATE_KEY,
       G.CHANNEL_NAME,
       G.MEMBER_LEVEL,
       G.IS_NEW_USER,
       G.GOODS_COMMON_KEY,
       SUM(G.ORDER_MEMBER) ORDER_MEMBER_COUNT,
       SUM(G.ORDER_QTY) ORDER_QTY,
       SUM(G.ORDER_AMOUNT) ORDER_AMOUNT,
       SUM(G.RETURN_MEMBER) RETURN_MEMBER_COUNT,
       SUM(G.RETURN_QTY) RETURN_QTY,
       SUM(G.RETURN_AMOUNT) RETURN_AMOUNT
  FROM (SELECT E.POSTING_DATE_KEY,
               CASE
                 WHEN E.SALES_SOURCE_SECOND_KEY LIKE '10%' THEN
                  'TV'
                 WHEN E.SALES_SOURCE_SECOND_KEY IN (20015, 20017) THEN
                  'APP'
                 WHEN E.SALES_SOURCE_SECOND_KEY IN (20006, 20021) THEN
                  '΢��'
                 WHEN E.SALES_SOURCE_SECOND_KEY IN (20007, 20022) THEN
                  '3G'
                 WHEN E.SALES_SOURCE_SECOND_KEY IN (20001, 20020) THEN
                  'PC'
               END CHANNEL_NAME,
               E.MEMBER_KEY,
               NVL(F.MEMBER_LEVEL, 'unregistered') MEMBER_LEVEL,
               CASE
                 WHEN NVL(F.FIRST_ORDER_DATE_KEY, 0) = 0 THEN
                  'new_user'
                 WHEN F.FIRST_ORDER_DATE_KEY < E.POSTING_DATE_KEY THEN
                  'old_user'
                 WHEN F.FIRST_ORDER_DATE_KEY >= E.POSTING_DATE_KEY THEN
                  'new_user'
               END IS_NEW_USER,
               E.GOODS_COMMON_KEY,
               CASE
                 WHEN E.ORDER_QTY > 0 THEN
                  1
                 ELSE
                  0
               END ORDER_MEMBER,
               E.ORDER_QTY,
               E.ORDER_AMOUNT,
               CASE
                 WHEN E.RETURN_QTY > 0 THEN
                  1
                 ELSE
                  0
               END RETURN_MEMBER,
               E.RETURN_QTY,
               E.RETURN_AMOUNT
          FROM (SELECT NVL(C.POSTING_DATE_KEY, D.POSTING_DATE_KEY) POSTING_DATE_KEY,
                       NVL(C.SALES_SOURCE_SECOND_KEY,
                           D.SALES_SOURCE_SECOND_KEY) SALES_SOURCE_SECOND_KEY,
                       NVL(C.MEMBER_KEY, D.MEMBER_KEY) MEMBER_KEY,
                       NVL(C.GOODS_COMMON_KEY, D.GOODS_COMMON_KEY) GOODS_COMMON_KEY,
                       NVL(C.ORDER_QTY, 0) ORDER_QTY,
                       NVL(C.ORDER_AMOUNT, 0) ORDER_AMOUNT,
                       NVL(D.RETURN_QTY, 0) RETURN_QTY,
                       NVL(D.RETURN_AMOUNT, 0) RETURN_AMOUNT
                  FROM (SELECT A.POSTING_DATE_KEY,
                               A.SALES_SOURCE_SECOND_KEY,
                               A.MEMBER_KEY,
                               A.GOODS_COMMON_KEY,
                               SUM(A.NUMS) ORDER_QTY,
                               SUM(A.ORDER_AMOUNT) ORDER_AMOUNT
                          FROM FACT_GOODS_SALES A
                         WHERE A.POSTING_DATE_KEY = 20180425
                           AND A.CANCEL_BEFORE_STATE = 0 /*����ǰȡ��*/
                           AND A.TRAN_TYPE = 0 /*��Ʒ*/
                           AND (A.SALES_SOURCE_KEY = 10 OR
                               A.SALES_SOURCE_SECOND_KEY IN
                               (20001,
                                 20006,
                                 20007,
                                 20015,
                                 20017,
                                 20020,
                                 20021,
                                 20022)) /*����*/
                         GROUP BY A.POSTING_DATE_KEY,
                                  A.SALES_SOURCE_SECOND_KEY,
                                  A.MEMBER_KEY,
                                  A.GOODS_COMMON_KEY) C
                  FULL OUTER JOIN (SELECT B.POSTING_DATE_KEY,
                                         B.SALES_SOURCE_SECOND_KEY,
                                         B.MEMBER_KEY,
                                         B.GOODS_COMMON_KEY,
                                         SUM(B.NUMS) RETURN_QTY,
                                         SUM(B.ORDER_AMOUNT) RETURN_AMOUNT
                                    FROM FACT_GOODS_SALES_REVERSE B
                                   WHERE B.POSTING_DATE_KEY = 20180425
                                     AND B.CANCEL_STATE = 0
                                     AND B.TRAN_TYPE <> 1 /*��Ʒ*/
                                     AND (B.SALES_SOURCE_KEY = 10 OR
                                         B.SALES_SOURCE_SECOND_KEY IN
                                         (20001,
                                           20006,
                                           20007,
                                           20015,
                                           20017,
                                           20020,
                                           20021,
                                           20022)) /*����*/
                                   GROUP BY B.POSTING_DATE_KEY,
                                            B.SALES_SOURCE_SECOND_KEY,
                                            B.MEMBER_KEY,
                                            B.GOODS_COMMON_KEY) D
                    ON C.POSTING_DATE_KEY = D.POSTING_DATE_KEY
                   AND C.SALES_SOURCE_SECOND_KEY = D.SALES_SOURCE_SECOND_KEY
                   AND C.MEMBER_KEY = D.MEMBER_KEY
                   AND C.GOODS_COMMON_KEY = D.GOODS_COMMON_KEY) E,
               DIM_MEMBER F
         WHERE E.MEMBER_KEY = F.MEMBER_BP(+)) G
 GROUP BY G.POSTING_DATE_KEY,
          G.CHANNEL_NAME,
          G.MEMBER_LEVEL,
          G.IS_NEW_USER,
          G.GOODS_COMMON_KEY;

--6.DIM
SELECT D1.DATE_KEY,
       D2.CHANNEL_NAME,
       D3.IS_NEW_USER,
       D4.MEMBER_LEVEL,
       D5.ITEM_CODE
  FROM (SELECT 20180425 DATE_KEY FROM DUAL) D1,
       (SELECT 'APP' CHANNEL_NAME
          FROM DUAL
        UNION ALL
        SELECT '΢��' CHANNEL_NAME
          FROM DUAL
        UNION ALL
        SELECT '3G' CHANNEL_NAME
          FROM DUAL
        UNION ALL
        SELECT 'PC' CHANNEL_NAME
          FROM DUAL) D2,
       (SELECT 'new_user' IS_NEW_USER
          FROM DUAL
        UNION ALL
        SELECT 'old_user' IS_NEW_USER
          FROM DUAL) D3,
       (SELECT 'HAPP_T0' MEMBER_LEVEL
          FROM DUAL
        UNION ALL
        SELECT 'HAPP_T1' MEMBER_LEVEL
          FROM DUAL
        UNION ALL
        SELECT 'HAPP_T2' MEMBER_LEVEL
          FROM DUAL
        UNION ALL
        SELECT 'HAPP_T3' MEMBER_LEVEL
          FROM DUAL
        UNION ALL
        SELECT 'HAPP_T4' MEMBER_LEVEL
          FROM DUAL
        UNION ALL
        SELECT 'HAPP_T5' MEMBER_LEVEL
          FROM DUAL
        UNION ALL
        SELECT 'HAPP_T6' MEMBER_LEVEL
          FROM DUAL
        UNION ALL
        SELECT 'unregistered' MEMBER_LEVEL
          FROM DUAL) D4,
       (SELECT ITEM_CODE FROM DIM_GOOD) D5;

--7.����
--CREATE TABLE OPER_GOOD_LABEL_ANALYSIS AS
INSERT INTO OPER_GOOD_LABEL_ANALYSIS
  (DATE_KEY,
   CHANNEL_NAME,
   IS_NEW_USER,
   MEMBER_LEVEL,
   ITEM_CODE,
   PV,
   UV,
   CAR_COUNT,
   ORDER_MEMBER_COUNT,
   ORDER_QTY,
   ORDER_AMOUNT,
   RETURN_MEMBER_COUNT,
   RETURN_QTY,
   RETURN_AMOUNT,
   W_INSERT_DT,
   W_UPDATE_DT)
  WITH DIM AS
  /*ά��*/
   (SELECT D1.DATE_KEY,
           D2.CHANNEL_NAME,
           D3.IS_NEW_USER,
           D4.MEMBER_LEVEL,
           D5.ITEM_CODE
      FROM (SELECT 20180425 DATE_KEY FROM DUAL) D1,
           (SELECT 'APP' CHANNEL_NAME
              FROM DUAL
            UNION ALL
            SELECT '΢��' CHANNEL_NAME
              FROM DUAL
            UNION ALL
            SELECT '3G' CHANNEL_NAME
              FROM DUAL
            UNION ALL
            SELECT 'PC' CHANNEL_NAME
              FROM DUAL) D2,
           (SELECT 'new_user' IS_NEW_USER
              FROM DUAL
            UNION ALL
            SELECT 'old_user' IS_NEW_USER
              FROM DUAL) D3,
           (SELECT 'HAPP_T0' MEMBER_LEVEL
              FROM DUAL
            UNION ALL
            SELECT 'HAPP_T1' MEMBER_LEVEL
              FROM DUAL
            UNION ALL
            SELECT 'HAPP_T2' MEMBER_LEVEL
              FROM DUAL
            UNION ALL
            SELECT 'HAPP_T3' MEMBER_LEVEL
              FROM DUAL
            UNION ALL
            SELECT 'HAPP_T4' MEMBER_LEVEL
              FROM DUAL
            UNION ALL
            SELECT 'HAPP_T5' MEMBER_LEVEL
              FROM DUAL
            UNION ALL
            SELECT 'HAPP_T6' MEMBER_LEVEL
              FROM DUAL
            UNION ALL
            SELECT 'unregistered' MEMBER_LEVEL
              FROM DUAL) D4,
           (SELECT ITEM_CODE FROM DIM_GOOD) D5),
  VIS AS
  /*���*/
   (SELECT C.DATE_KEY,
           C.CHANNEL_NAME,
           C.IS_NEW_USER,
           C.MEMBER_LEVEL,
           C.ITEM_CODE,
           COUNT(1) PV,
           COUNT(DISTINCT C.VID) UV
      FROM (SELECT A.PAGE_VIEW_KEY,
                   A.VISIT_DATE_KEY DATE_KEY,
                   A.VID,
                   A.MEMBER_KEY,
                   NVL(B.MEMBER_LEVEL, 'unregistered') MEMBER_LEVEL,
                   NVL(B.FIRST_ORDER_DATE_KEY, 0) FIRST_ORDER_DATE_KEY,
                   CASE
                     WHEN NVL(B.FIRST_ORDER_DATE_KEY, 0) = 0 THEN
                      'new_user'
                     WHEN B.FIRST_ORDER_DATE_KEY < A.VISIT_DATE_KEY THEN
                      'old_user'
                     WHEN B.FIRST_ORDER_DATE_KEY >= A.VISIT_DATE_KEY THEN
                      'new_user'
                   END IS_NEW_USER,
                   A.PAGE_VALUE ITEM_CODE,
                   CASE
                     WHEN A.APPLICATION_KEY IN (10, 20) THEN
                      'APP'
                     WHEN A.APPLICATION_KEY = 30 THEN
                      '3G'
                     WHEN A.APPLICATION_KEY = 40 THEN
                      'PC'
                     WHEN A.APPLICATION_KEY = 50 THEN
                      '΢��'
                   END CHANNEL_NAME
              FROM FACT_PAGE_VIEW A, DIM_MEMBER B
             WHERE A.MEMBER_KEY = B.MEMBER_BP(+)
               AND A.VISIT_DATE_KEY = 20180425
               AND UPPER(A.PAGE_NAME) IN ('GOOD', 'Good_Desc')
               AND A.PAGE_VALUE =
                   TRANSLATE(A.PAGE_VALUE,
                             '0' ||
                             TRANSLATE(A.PAGE_VALUE, '#0123456789', '#'),
                             '0')) C
     GROUP BY C.DATE_KEY,
              C.CHANNEL_NAME,
              C.IS_NEW_USER,
              C.MEMBER_LEVEL,
              C.ITEM_CODE),
  CAR AS
  /*���ﳵ*/
   (SELECT C.DATE_KEY,
           C.CHANNEL_NAME,
           C.IS_NEW_USER,
           C.MEMBER_LEVEL,
           C.ITEM_CODE,
           COUNT(1) CAR_COUNT
      FROM (SELECT A.CREATE_DATE_KEY DATE_KEY,
                   CASE
                     WHEN A.APPLICATION_KEY IN (10, 20) THEN
                      'APP'
                     WHEN A.APPLICATION_KEY = 30 THEN
                      '3G'
                     WHEN A.APPLICATION_KEY = 40 THEN
                      'PC'
                     WHEN A.APPLICATION_KEY = 50 THEN
                      '΢��'
                   END CHANNEL_NAME,
                   A.VID,
                   A.MEMBER_KEY,
                   NVL(B.MEMBER_LEVEL, 'unregistered') MEMBER_LEVEL,
                   CASE
                     WHEN NVL(B.FIRST_ORDER_DATE_KEY, 0) = 0 THEN
                      'new_user'
                     WHEN B.FIRST_ORDER_DATE_KEY < A.CREATE_DATE_KEY THEN
                      'old_user'
                     WHEN B.FIRST_ORDER_DATE_KEY >= A.CREATE_DATE_KEY THEN
                      'new_user'
                   END IS_NEW_USER,
                   A.SCGID ITEM_CODE
              FROM FACT_SHOPPINGCAR A, DIM_MEMBER B
             WHERE A.MEMBER_KEY = B.MEMBER_BP(+)
               AND A.CREATE_DATE_KEY = 20180425) C
     GROUP BY C.DATE_KEY,
              C.CHANNEL_NAME,
              C.IS_NEW_USER,
              C.MEMBER_LEVEL,
              C.ITEM_CODE),
  ORD AS
  /*����*/
   (SELECT G.POSTING_DATE_KEY DATE_KEY,
           G.CHANNEL_NAME,
           G.MEMBER_LEVEL,
           G.IS_NEW_USER,
           G.GOODS_COMMON_KEY ITEM_CODE,
           SUM(G.ORDER_MEMBER) ORDER_MEMBER_COUNT,
           SUM(G.ORDER_QTY) ORDER_QTY,
           SUM(G.ORDER_AMOUNT) ORDER_AMOUNT,
           SUM(G.RETURN_MEMBER) RETURN_MEMBER_COUNT,
           SUM(G.RETURN_QTY) RETURN_QTY,
           SUM(G.RETURN_AMOUNT) RETURN_AMOUNT
      FROM (SELECT E.POSTING_DATE_KEY,
                   CASE
                     WHEN E.SALES_SOURCE_SECOND_KEY LIKE '10%' THEN
                      'TV'
                     WHEN E.SALES_SOURCE_SECOND_KEY IN (20015, 20017) THEN
                      'APP'
                     WHEN E.SALES_SOURCE_SECOND_KEY IN (20006, 20021) THEN
                      '΢��'
                     WHEN E.SALES_SOURCE_SECOND_KEY IN (20007, 20022) THEN
                      '3G'
                     WHEN E.SALES_SOURCE_SECOND_KEY IN (20001, 20020) THEN
                      'PC'
                   END CHANNEL_NAME,
                   E.MEMBER_KEY,
                   NVL(F.MEMBER_LEVEL, 'unregistered') MEMBER_LEVEL,
                   CASE
                     WHEN NVL(F.FIRST_ORDER_DATE_KEY, 0) = 0 THEN
                      'new_user'
                     WHEN F.FIRST_ORDER_DATE_KEY < E.POSTING_DATE_KEY THEN
                      'old_user'
                     WHEN F.FIRST_ORDER_DATE_KEY >= E.POSTING_DATE_KEY THEN
                      'new_user'
                   END IS_NEW_USER,
                   E.GOODS_COMMON_KEY,
                   CASE
                     WHEN E.ORDER_QTY > 0 THEN
                      1
                     ELSE
                      0
                   END ORDER_MEMBER,
                   E.ORDER_QTY,
                   E.ORDER_AMOUNT,
                   CASE
                     WHEN E.RETURN_QTY > 0 THEN
                      1
                     ELSE
                      0
                   END RETURN_MEMBER,
                   E.RETURN_QTY,
                   E.RETURN_AMOUNT
              FROM (SELECT NVL(C.POSTING_DATE_KEY, D.POSTING_DATE_KEY) POSTING_DATE_KEY,
                           NVL(C.SALES_SOURCE_SECOND_KEY,
                               D.SALES_SOURCE_SECOND_KEY) SALES_SOURCE_SECOND_KEY,
                           NVL(C.MEMBER_KEY, D.MEMBER_KEY) MEMBER_KEY,
                           NVL(C.GOODS_COMMON_KEY, D.GOODS_COMMON_KEY) GOODS_COMMON_KEY,
                           NVL(C.ORDER_QTY, 0) ORDER_QTY,
                           NVL(C.ORDER_AMOUNT, 0) ORDER_AMOUNT,
                           NVL(D.RETURN_QTY, 0) RETURN_QTY,
                           NVL(D.RETURN_AMOUNT, 0) RETURN_AMOUNT
                      FROM (SELECT A.POSTING_DATE_KEY,
                                   A.SALES_SOURCE_SECOND_KEY,
                                   A.MEMBER_KEY,
                                   A.GOODS_COMMON_KEY,
                                   SUM(A.NUMS) ORDER_QTY,
                                   SUM(A.ORDER_AMOUNT) ORDER_AMOUNT
                              FROM FACT_GOODS_SALES A
                             WHERE A.POSTING_DATE_KEY = 20180425
                               AND A.CANCEL_BEFORE_STATE = 0 /*����ǰȡ��*/
                               AND A.TRAN_TYPE = 0 /*��Ʒ*/
                               AND (A.SALES_SOURCE_KEY = 10 OR
                                   A.SALES_SOURCE_SECOND_KEY IN
                                   (20001,
                                     20006,
                                     20007,
                                     20015,
                                     20017,
                                     20020,
                                     20021,
                                     20022)) /*����*/
                             GROUP BY A.POSTING_DATE_KEY,
                                      A.SALES_SOURCE_SECOND_KEY,
                                      A.MEMBER_KEY,
                                      A.GOODS_COMMON_KEY) C
                      FULL OUTER JOIN (SELECT B.POSTING_DATE_KEY,
                                             B.SALES_SOURCE_SECOND_KEY,
                                             B.MEMBER_KEY,
                                             B.GOODS_COMMON_KEY,
                                             SUM(B.NUMS) RETURN_QTY,
                                             SUM(B.ORDER_AMOUNT) RETURN_AMOUNT
                                        FROM FACT_GOODS_SALES_REVERSE B
                                       WHERE B.POSTING_DATE_KEY = 20180425
                                         AND B.CANCEL_STATE = 0
                                         AND B.TRAN_TYPE <> 1 /*��Ʒ*/
                                         AND (B.SALES_SOURCE_KEY = 10 OR
                                             B.SALES_SOURCE_SECOND_KEY IN
                                             (20001,
                                               20006,
                                               20007,
                                               20015,
                                               20017,
                                               20020,
                                               20021,
                                               20022)) /*����*/
                                       GROUP BY B.POSTING_DATE_KEY,
                                                B.SALES_SOURCE_SECOND_KEY,
                                                B.MEMBER_KEY,
                                                B.GOODS_COMMON_KEY) D
                        ON C.POSTING_DATE_KEY = D.POSTING_DATE_KEY
                       AND C.SALES_SOURCE_SECOND_KEY =
                           D.SALES_SOURCE_SECOND_KEY
                       AND C.MEMBER_KEY = D.MEMBER_KEY
                       AND C.GOODS_COMMON_KEY = D.GOODS_COMMON_KEY) E,
                   DIM_MEMBER F
             WHERE E.MEMBER_KEY = F.MEMBER_BP(+)) G
     GROUP BY G.POSTING_DATE_KEY,
              G.CHANNEL_NAME,
              G.MEMBER_LEVEL,
              G.IS_NEW_USER,
              G.GOODS_COMMON_KEY)
  SELECT DIM.DATE_KEY,
         DIM.CHANNEL_NAME,
         DIM.IS_NEW_USER,
         DIM.MEMBER_LEVEL,
         DIM.ITEM_CODE,
         NVL(VIS.PV, 0) PV,
         NVL(VIS.UV, 0) UV,
         NVL(CAR.CAR_COUNT, 0) CAR_COUNT,
         NVL(ORD.ORDER_MEMBER_COUNT, 0) ORDER_MEMBER_COUNT,
         NVL(ORD.ORDER_QTY, 0) ORDER_QTY,
         NVL(ORD.ORDER_AMOUNT, 0) ORDER_AMOUNT,
         NVL(ORD.RETURN_MEMBER_COUNT, 0) RETURN_MEMBER_COUNT,
         NVL(ORD.RETURN_QTY, 0) RETURN_QTY,
         NVL(ORD.RETURN_AMOUNT, 0) RETURN_AMOUNT
    FROM DIM, VIS, CAR, ORD
   WHERE DIM.DATE_KEY = VIS.DATE_KEY(+)
     AND DIM.DATE_KEY = CAR.DATE_KEY(+)
     AND DIM.DATE_KEY = ORD.DATE_KEY(+)
     AND DIM.CHANNEL_NAME = VIS.CHANNEL_NAME(+)
     AND DIM.CHANNEL_NAME = CAR.CHANNEL_NAME(+)
     AND DIM.CHANNEL_NAME = ORD.CHANNEL_NAME(+)
     AND DIM.IS_NEW_USER = VIS.IS_NEW_USER(+)
     AND DIM.IS_NEW_USER = CAR.IS_NEW_USER(+)
     AND DIM.IS_NEW_USER = ORD.IS_NEW_USER(+)
     AND DIM.MEMBER_LEVEL = VIS.MEMBER_LEVEL(+)
     AND DIM.MEMBER_LEVEL = CAR.MEMBER_LEVEL(+)
     AND DIM.MEMBER_LEVEL = ORD.MEMBER_LEVEL(+)
     AND DIM.ITEM_CODE = VIS.ITEM_CODE(+)
     AND DIM.ITEM_CODE = CAR.ITEM_CODE(+)
     AND DIM.ITEM_CODE = ORD.ITEM_CODE(+)
     AND (VIS.PV IS NOT NULL OR CAR.CAR_COUNT IS NOT NULL OR
         ORD.ORDER_QTY IS NOT NULL);

--tmp
SELECT * FROM S_PARAMETERS2 FOR UPDATE;
SELECT A.DATE_KEY, COUNT(1)
  FROM OPER_GOOD_LABEL_ANALYSIS A
 GROUP BY A.DATE_KEY
 ORDER BY A.DATE_KEY;
SELECT * FROM OPER_GOOD_LABEL_ANALYSIS A WHERE A.DATE_KEY=20180501; 
SELECT * FROM OPER_GOOD_LABEL_ANALYSIS A WHERE A.DATE_KEY=20180430 AND A.ITEM_CODE=235601;
SELECT * FROM OPER_PRODUCT_DAILY_REPORT A WHERE A.POSTING_DATE_KEY=20180430 AND A.ITEM_CODE=180081;
SELECT * FROM FACT_PAGE_VIEW A WHERE A.VISIT_DATE_KEY=20180501 AND A.PAGE_VALUE='234822';
SELECT * FROM DIM_GOOD A WHERE A.ITEM_CODE=180081;
SELECT *
  FROM FACT_SHOPPINGCAR
       
        SELECT * FROM FACT_GOODS_SALES A WHERE A.ORDER_KEY = 5207887758;


SELECT * FROM FACT_GOODS_SALES_REVERSE A WHERE A.ORDER_KEY = 5207887758;

SELECT * FROM FACT_GOODS_SALES A WHERE A.POSTING_DATE_KEY = 20180425;

SELECT *
  FROM FACT_GOODS_SALES_REVERSE B
 WHERE B.POSTING_DATE_KEY = 20180425;

SELECT *
  FROM FACT_GOODS_SALES A
 WHERE A.POSTING_DATE_KEY = 20180425
   AND A.CANCEL_BEFORE_STATE = 1;
