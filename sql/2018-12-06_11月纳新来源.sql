--1.
SELECT A2.REG_MONTH_KEY MONTH_KEY,
       A2.SNAME,
       COUNT(A2.MEMBER_KEY) REG_MEMBER_COUNT,
       SUM(A2.ORDER_CNT) ORDER_CNT,
       SUM(A2.IS_ORDER) ORDER_MEMBER_COUNT,
       SUM(A2.ORDER_QTY) ORDER_QTY,
       SUM(A2.ORDER_AMOUNT) ORDER_AMOUNT,
       SYSDATE W_INSERT_DT,
       SYSDATE W_UPDATE_DT
  FROM (SELECT SUBSTR(A1.REG_DATE, 1, 6) REG_MONTH_KEY,
               A1.MEMBER_KEY,
               CASE
                 WHEN A1.M_LABEL_DESC = '推广' THEN
                  '推广流量'
                 WHEN A1.M_LABEL_DESC = '扫码' THEN
                  '内部流量'
                 WHEN A1.M_LABEL_DESC = '自然' AND A1.REGISTER_RESOURCE = 'TV' THEN
                  '内部流量'
                 ELSE
                  '自然流量'
               END SNAME,
               CASE
                 WHEN A1.ORDER_AMOUNT > 0 THEN
                  1
                 ELSE
                  0
               END IS_ORDER,
               A1.ORDER_CNT,
               A1.ORDER_MEMBER_CNT,
               A1.ORDER_QTY,
               A1.ORDER_AMOUNT
          FROM (SELECT A.MEMBER_KEY,
                       NVL(B.M_LABEL_DESC, '自然') M_LABEL_DESC,
                       NVL(C.REGISTER_RESOURCE, 'unknown') REGISTER_RESOURCE,
                       NVL(D.MEMBER_TIME, '20170101') REG_DATE,
                       NVL(E.ORDER_CNT, 0) ORDER_CNT,
                       NVL(E.ORDER_MEMBER_CNT, 0) ORDER_MEMBER_CNT,
                       NVL(E.ORDER_QTY, 0) ORDER_QTY,
                       NVL(E.ORDER_AMOUNT, 0) ORDER_AMOUNT
                  FROM (SELECT MEMBER_KEY
                          FROM FACT_SESSION
                         WHERE START_DATE_KEY BETWEEN 20181101 AND 20181130
                           AND MEMBER_KEY <> 0
                         GROUP BY MEMBER_KEY) A,
                       (SELECT MEMBER_KEY, MAX(M_LABEL_DESC) M_LABEL_DESC
                          FROM MEMBER_LABEL_LINK_V
                         WHERE M_LABEL_ID IN (143, 144, 145)
                         GROUP BY MEMBER_KEY) B,
                       (SELECT MEMBER_BP, REGISTER_RESOURCE FROM DIM_MEMBER) C,
                       (SELECT MEMBER_CRMBP, MAX(MEMBER_TIME) MEMBER_TIME
                          FROM FACT_ECMEMBER
                         GROUP BY MEMBER_CRMBP) D,
                       (SELECT MEMBER_KEY,
                               COUNT(A.ORDER_ID) ORDER_CNT,
                               COUNT(DISTINCT A.MEMBER_KEY) ORDER_MEMBER_CNT,
                               SUM(A.GOODS_NUM) ORDER_QTY,
                               SUM(ORDER_AMOUNT) ORDER_AMOUNT
                          FROM FACTEC_ORDER A
                         WHERE ADD_TIME BETWEEN 20181101 AND 20181130
                           AND ORDER_STATE >= 10
                         GROUP BY A.MEMBER_KEY) E
                 WHERE A.MEMBER_KEY = B.MEMBER_KEY(+)
                   AND A.MEMBER_KEY = C.MEMBER_BP(+)
                   AND A.MEMBER_KEY = D.MEMBER_CRMBP(+)
                   AND A.MEMBER_KEY = E.MEMBER_KEY(+)) A1
         WHERE A1.REG_DATE BETWEEN 20181101 AND 20181130) A2
 GROUP BY A2.REG_MONTH_KEY, A2.SNAME;

--2.UV
SELECT Y.SNAME,
       COUNT(DISTINCT Y.MEMBER_KEY) MEMBER_COUNT,
       COUNT(DISTINCT Y.VID) VID_COUNT
  FROM (SELECT CASE
                 WHEN Z.M_LABEL_DESC = '推广' THEN
                  '推广流量'
                 WHEN Z.M_LABEL_DESC = '扫码' THEN
                  '内部流量'
                 WHEN Z.M_LABEL_DESC = '自然' AND Z.REGISTER_RESOURCE = 'TV' THEN
                  '内部流量'
                 ELSE
                  '自然流量'
               END SNAME,
               Z.MEMBER_KEY,
               Z.VID
          FROM (SELECT A.MEMBER_KEY,
                       A.VID,
                       D.REGISTER_RESOURCE,
                       NVL(B.M_LABEL_DESC, '自然') M_LABEL_DESC
                  FROM (SELECT A1.MEMBER_KEY, A1.VID
                          FROM FACT_SESSION A1
                         WHERE A1.START_DATE_KEY BETWEEN 20181101 AND 20181130
                         GROUP BY A1.MEMBER_KEY, A1.VID) A,
                       (SELECT B1.MEMBER_KEY,
                               MAX(B1.M_LABEL_DESC) M_LABEL_DESC
                          FROM MEMBER_LABEL_LINK_V B1
                         WHERE B1.M_LABEL_ID IN (143, 144, 145)
                         GROUP BY B1.MEMBER_KEY) B,
                       (SELECT C1.MEMBER_CRMBP MEMBER_KEY,
                               MAX(C1.MEMBER_TIME) MEMBER_TIME
                          FROM FACT_ECMEMBER C1
                         WHERE C1.MEMBER_TIME BETWEEN 20181101 AND 20181130
                         GROUP BY C1.MEMBER_CRMBP) C,
                       (SELECT MEMBER_BP MEMBER_KEY,
                               NVL(REGISTER_RESOURCE, 'unknown') REGISTER_RESOURCE
                          FROM DIM_MEMBER) D
                 WHERE A.MEMBER_KEY = B.MEMBER_KEY(+)
                   AND A.MEMBER_KEY = C.MEMBER_KEY
                   AND A.MEMBER_KEY = D.MEMBER_KEY(+)) Z) Y
 GROUP BY Y.SNAME;
