SELECT D.MEMBER_KEY,
       E.M_LABEL_ID          M_LABEL_ID,
       E.M_LABEL_TYPE_ID     M_LABEL_TYPE_ID,
       SYSDATE               CREATE_DATE,
       E.CREATE_USER_ID      CREATE_USER_ID,
       SYSDATE               LAST_UPDATE_DATE,
       E.LAST_UPDATE_USER_ID LAST_UPDATE_USER_ID
  FROM (SELECT C.MEMBER_KEY,
               COUNT(C.ITEM_CODE) ITEM_COUNT,
               COUNT(CASE
                       WHEN C.IS_TV = 1 THEN
                        1
                       ELSE
                        NULL
                     END) TV_ITEM_COUNT,
               COUNT(DISTINCT C.ORDER_KEY) ORDER_COUNT
          FROM (SELECT SALES.ORDER_KEY,
                       SALES.MEMBER_KEY,
                       SALES.GOODS_COMMON_KEY ITEM_CODE,
                       NVL(TV_GOOD.IS_TV, 0) IS_TV
                  FROM (SELECT DISTINCT A.ORDER_KEY,
                                        A.MEMBER_KEY,
                                        A.GOODS_COMMON_KEY
                          FROM FACT_GOODS_SALES A
                         WHERE A.POSTING_DATE_KEY >=
                               TO_CHAR(TRUNC(&IN_POSTING_DATE - 181),
                                       'YYYYMMDD') /*180������ͳ��*/
                           AND A.ORDER_STATE = 1
                           AND A.TRAN_TYPE = 0) SALES,
                       (SELECT ITEM_CODE, 1 IS_TV /*TV��Ʒ*/
                          FROM DIM_GOOD
                         WHERE GROUP_ID = 1000) TV_GOOD
                 WHERE SALES.GOODS_COMMON_KEY = TV_GOOD.ITEM_CODE(+)) C
         GROUP BY C.MEMBER_KEY) D,
       (SELECT F.M_LABEL_ID,
               F.M_LABEL_NAME,
               F.M_LABEL_TYPE_ID,
               F.CREATE_USER_ID,
               F.LAST_UPDATE_USER_ID
          FROM MEMBER_LABEL_HEAD F
         WHERE F.M_LABEL_NAME = 'ONLY_TV' /*ֻ��TV��Ʒ*/
        ) E
 WHERE /*�û�������������4��ʱ����*/
 D.ORDER_COUNT >= 4
/*����TV��Ʒ�ﵽ70%����*/
 AND D.TV_ITEM_COUNT / D.ITEM_COUNT >= 0.7;
