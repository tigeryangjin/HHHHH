/*
关联算法
用户购买的商品之间频繁项集
*/

--********************************************************************************************************************
--二个商品
--********************************************************************************************************************
--1.购买记录基表
TRUNCATE TABLE MEMBER_ITEM_APRIORI_BASE;
INSERT INTO MEMBER_ITEM_APRIORI_BASE
  SELECT DISTINCT A.MEMBER_KEY MEMBER_BP, A.GOODS_COMMON_KEY ITEM_CODE
    FROM FACT_GOODS_SALES A
   WHERE A.ORDER_STATE = 1
     AND A.ORDER_AMOUNT > 0
     AND A.GOODS_COMMON_KEY IS NOT NULL;

--2.确定商品范围
--2353786
SELECT COUNT(DISTINCT A.MEMBER_BP) FROM MEMBER_ITEM_APRIORI_BASE A;

SELECT A.ITEM_CODE, COUNT(1)
  FROM MEMBER_ITEM_APRIORI_BASE A
 GROUP BY A.ITEM_CODE
HAVING COUNT(1) > 10000
 ORDER BY COUNT(1) DESC;


--3.生成(A->B)项集
--3.1.部分商品的关联项集
SELECT A.MEMBER_BP, A.ITEM_CODE ITEM_CODE_A, B.ITEM_CODE ITEM_CODE_B
  FROM MEMBER_ITEM_APRIORI_BASE A, MEMBER_ITEM_APRIORI_BASE B
 WHERE A.MEMBER_BP = B.MEMBER_BP
   AND A.ITEM_CODE <> B.ITEM_CODE
   AND EXISTS (SELECT 1
          FROM (SELECT D.ITEM_CODE
                  FROM MEMBER_ITEM_APRIORI_BASE D
                 GROUP BY D.ITEM_CODE
                HAVING COUNT(1) > 10000) C
         WHERE A.ITEM_CODE = C.ITEM_CODE);

--3.2.全部商品的关联
DROP TABLE MEMBER_ITEM_APRIORI_ITEMSET2;
CREATE TABLE MEMBER_ITEM_APRIORI_ITEMSET2 AS
WITH ALL_MEMBER AS
/*整体会员数*/
 (SELECT COUNT(DISTINCT A.MEMBER_BP) ALL_BP_COUNT
    FROM MEMBER_ITEM_APRIORI_BASE A),
A_TRAN AS
/*A商品会员数*/
 (SELECT A.ITEM_CODE, COUNT(A.MEMBER_BP) A_BP_COUNT
    FROM MEMBER_ITEM_APRIORI_BASE A
   GROUP BY A.ITEM_CODE)
SELECT D.ITEM_CODE_A,
       D.ITEM_CODE_B,
       D.BP_COUNT / F.A_BP_COUNT CONFIDENCE,
       D.BP_COUNT / E.ALL_BP_COUNT SUPPPORT_RATE
  FROM (SELECT C.ITEM_CODE_A, C.ITEM_CODE_B, COUNT(C.MEMBER_BP) BP_COUNT
          FROM (SELECT A.MEMBER_BP,
                       A.ITEM_CODE ITEM_CODE_A,
                       B.ITEM_CODE ITEM_CODE_B
                  FROM MEMBER_ITEM_APRIORI_BASE A, MEMBER_ITEM_APRIORI_BASE B
                 WHERE A.MEMBER_BP = B.MEMBER_BP
                   AND A.ITEM_CODE <> B.ITEM_CODE) C
         GROUP BY C.ITEM_CODE_A, C.ITEM_CODE_B
         ORDER BY COUNT(C.MEMBER_BP) DESC) D,
       ALL_MEMBER E,
       A_TRAN F
 WHERE ROWNUM <= 100000
   AND D.ITEM_CODE_A = F.ITEM_CODE;

--剔除爆品
select A.ITEM_CODE_A,
       B.GOODS_NAME,
       A.ITEM_CODE_B,
       C.GOODS_NAME,
       A.CONFIDENCE,
       A.SUPPPORT_RATE
  from MEMBER_ITEM_APRIORI_ITEMSET2 A, DIM_GOOD B, DIM_GOOD C
 WHERE A.ITEM_CODE_A = B.ITEM_CODE
   AND A.ITEM_CODE_B = C.ITEM_CODE
   AND A.ITEM_CODE_A = 215509
   AND NOT EXISTS
 (SELECT 1
          FROM (SELECT A.ITEM_CODE, COUNT(A.MEMBER_BP) BP_COUNT
                  FROM MEMBER_ITEM_APRIORI_BASE A
                 GROUP BY A.ITEM_CODE
								 HAVING COUNT(A.MEMBER_BP)>10000) D
         WHERE A.ITEM_CODE_B = D.ITEM_CODE)
 ORDER BY A.SUPPPORT_RATE DESC, A.CONFIDENCE DESC;

--4.
SELECT *
  FROM (SELECT E.ITEM_CODE_A, E.ITEM_CODE_B, COUNT(E.MEMBER_BP) BP_COUNT
          FROM (SELECT A.MEMBER_BP,
                       A.ITEM_CODE ITEM_CODE_A,
                       B.ITEM_CODE ITEM_CODE_B
                  FROM MEMBER_ITEM_APRIORI_BASE A, MEMBER_ITEM_APRIORI_BASE B
                 WHERE A.MEMBER_BP = B.MEMBER_BP
                   AND A.ITEM_CODE <> B.ITEM_CODE
                   AND EXISTS (SELECT 1
                          FROM (SELECT D.ITEM_CODE
                                  FROM MEMBER_ITEM_APRIORI_BASE D
                                 GROUP BY D.ITEM_CODE
                                HAVING COUNT(1) > 10000) C
                         WHERE A.ITEM_CODE = C.ITEM_CODE)) E
         GROUP BY E.ITEM_CODE_A, E.ITEM_CODE_B
         ORDER BY COUNT(E.MEMBER_BP) DESC) F
 WHERE ROWNUM <= 100;

--********************************************************************************************************************
--三个商品
--********************************************************************************************************************
--1.
--1.1
--数据量太大，报临时表空间不足
SELECT E.MEMBER_BP, E.ITEM_CODE_A, E.ITEM_CODE_B, E.ITEM_CODE_C, E.BP_COUNT
  FROM (SELECT D.MEMBER_BP,
               D.ITEM_CODE_A,
               D.ITEM_CODE_B,
               D.ITEM_CODE_C,
               COUNT(D.MEMBER_BP) BP_COUNT
          FROM (SELECT A.MEMBER_BP,
                       A.ITEM_CODE ITEM_CODE_A,
                       B.ITEM_CODE ITEM_CODE_B,
                       C.ITEM_CODE ITEM_CODE_C
                  FROM MEMBER_ITEM_APRIORI_BASE A,
                       MEMBER_ITEM_APRIORI_BASE B,
                       MEMBER_ITEM_APRIORI_BASE C
                 WHERE A.MEMBER_BP = B.MEMBER_BP
                   AND A.MEMBER_BP = C.MEMBER_BP
                   AND A.ITEM_CODE <> B.ITEM_CODE
                   AND A.ITEM_CODE <> C.ITEM_CODE
                   AND B.ITEM_CODE <> C.ITEM_CODE) D
         WHERE EXISTS (SELECT 1
                  FROM (SELECT G.ITEM_CODE_A, G.ITEM_CODE_B, G.BP_COUNT
                          FROM (SELECT H.ITEM_CODE_A,
                                       H.ITEM_CODE_B,
                                       COUNT(H.MEMBER_BP) BP_COUNT
                                  FROM (SELECT I.MEMBER_BP,
                                               I.ITEM_CODE ITEM_CODE_A,
                                               J.ITEM_CODE ITEM_CODE_B
                                          FROM MEMBER_ITEM_APRIORI_BASE I,
                                               MEMBER_ITEM_APRIORI_BASE J
                                         WHERE I.MEMBER_BP = J.MEMBER_BP
                                           AND I.ITEM_CODE <> J.ITEM_CODE) H
                                 GROUP BY H.ITEM_CODE_A, H.ITEM_CODE_B
                                 ORDER BY COUNT(H.MEMBER_BP) DESC) G
                         WHERE ROWNUM <= 100000) F
                 WHERE D.ITEM_CODE_A = F.ITEM_CODE_A
                   AND D.ITEM_CODE_B = F.ITEM_CODE_B)
         GROUP BY D.MEMBER_BP, D.ITEM_CODE_A, D.ITEM_CODE_B, D.ITEM_CODE_C
         ORDER BY COUNT(D.MEMBER_BP) DESC) E
 WHERE ROWNUM <= 10000;

--1.2
SELECT I.ITEM_CODE_A,
       J.GOODS_NAME,
       I.ITEM_CODE_B,
       K.GOODS_NAME,
       I.ITEM_CODE_C,
       L.GOODS_NAME,
       I.BP_COUNT
  FROM (SELECT H.ITEM_CODE_A, H.ITEM_CODE_B, H.ITEM_CODE_C, H.BP_COUNT
          FROM (SELECT G.ITEM_CODE_A,
                       G.ITEM_CODE_B,
                       G.ITEM_CODE_C,
                       COUNT(G.MEMBER_BP) BP_COUNT
                  FROM (SELECT E.MEMBER_BP,
                               E.ITEM_CODE_A,
                               E.ITEM_CODE_B,
                               F.ITEM_CODE ITEM_CODE_C
                          FROM (SELECT A.MEMBER_BP,
                                       A.ITEM_CODE ITEM_CODE_A,
                                       B.ITEM_CODE ITEM_CODE_B
                                  FROM MEMBER_ITEM_APRIORI_BASE A,
                                       MEMBER_ITEM_APRIORI_BASE B
                                 WHERE A.MEMBER_BP = B.MEMBER_BP
                                   AND A.ITEM_CODE <> B.ITEM_CODE
                                   AND EXISTS
                                 (SELECT 1
                                          FROM (SELECT D.ITEM_CODE_A,
                                                       D.ITEM_CODE_B
                                                  FROM MEMBER_ITEM_APRIORI_ITEMSET2 D
                                                 WHERE D.BP_COUNT >= 2000) C
                                         WHERE A.ITEM_CODE = C.ITEM_CODE_A
                                           AND B.ITEM_CODE = C.ITEM_CODE_B)) E,
                               MEMBER_ITEM_APRIORI_BASE F
                         WHERE E.MEMBER_BP = F.MEMBER_BP
                           AND E.ITEM_CODE_A <> F.ITEM_CODE
                           AND E.ITEM_CODE_B <> F.ITEM_CODE) G
                 GROUP BY G.ITEM_CODE_A, G.ITEM_CODE_B, G.ITEM_CODE_C
                 ORDER BY COUNT(G.MEMBER_BP) DESC) H
         WHERE ROWNUM <= 10000) I,
       DIM_GOOD J,
       DIM_GOOD K,
       DIM_GOOD L
 WHERE I.ITEM_CODE_A = J.ITEM_CODE(+)
   AND I.ITEM_CODE_B = K.ITEM_CODE(+)
   AND I.ITEM_CODE_C = L.ITEM_CODE(+);

--2.

--3.

--tmp
SELECT * FROM MEMBER_ITEM_APRIORI_BASE A WHERE A.MEMBER_BP=1614284419;
