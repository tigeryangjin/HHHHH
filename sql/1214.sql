SELECT D.ITEM_CODE_A, D.ITEM_CODE_B, D.BP_COUNT
  FROM (SELECT C.ITEM_CODE_A, C.ITEM_CODE_B, COUNT(C.MEMBER_BP) BP_COUNT
          FROM (SELECT A.MEMBER_BP,
                       A.ITEM_CODE ITEM_CODE_A,
                       B.ITEM_CODE ITEM_CODE_B
                  FROM MEMBER_ITEM_APRIORI_BASE A, MEMBER_ITEM_APRIORI_BASE B
                 WHERE A.MEMBER_BP = B.MEMBER_BP
                   AND A.ITEM_CODE <> B.ITEM_CODE) C
         GROUP BY C.ITEM_CODE_A, C.ITEM_CODE_B
         ORDER BY COUNT(C.MEMBER_BP) DESC) D
 WHERE ROWNUM <= 100000;
