???CREATE OR REPLACE FUNCTION DW_USER.GET_GOODS_RECOMMEND(IN_MEMBER_BP IN NUMBER,
                                               IN_ITEM_CODE IN NUMBER)
  RETURN GOODS_RECOMMEND_TABLE IS
  V_GOODS_RECOMMEND_TABLE GOODS_RECOMMEND_TABLE := GOODS_RECOMMEND_TABLE();
BEGIN
  FOR I IN (SELECT ROW_NUMBER() OVER(ORDER BY G.MEMBER_NUMBER DESC) TOPN,
                   G.MEMBER_NUMBER,
                   G.ITEM_CODE,
                   H.GOODS_NAME,
                   H.MATDL,
                   H.MATDLT,
                   H.MATZL,
                   H.MATZLT,
                   H.MATXL,
                   H.MATXLT
              FROM (SELECT F.ITEM_CODE, F.MEMBER_NUMBER
                      FROM (SELECT B.ITEM_CODE,
                                   COUNT(DISTINCT B.MEMBER_BP) MEMBER_NUMBER
                              FROM GOODS_RECOMMEND_BASE B
                             WHERE EXISTS
                             (SELECT 1
                                      FROM (SELECT A.MEMBER_BP
                                              FROM GOODS_RECOMMEND_BASE A
                                             WHERE A.ITEM_CODE = IN_ITEM_CODE) C
                                     WHERE B.MEMBER_BP = C.MEMBER_BP) /*购买此商品的所有会员*/
                               AND NOT EXISTS
                             (SELECT 1
                                      FROM (SELECT E.ITEM_CODE
                                              FROM GOODS_RECOMMEND_BASE E
                                             WHERE E.MEMBER_BP = IN_MEMBER_BP) D
                                     WHERE B.ITEM_CODE = D.ITEM_CODE) /*此会员已经购买过的商品*/
                               AND B.ITEM_CODE <> 0
                               AND B.ITEM_CODE <> IN_ITEM_CODE /*剔除此会员已经购买的此商品*/
                               AND B.ORDER_DATE >=
                                   TO_CHAR(SYSDATE - 91, 'YYYYMMDD') /*日期范围最近90天*/
                             GROUP BY B.ITEM_CODE) F
                     WHERE ROWNUM <= 50
                     ORDER BY F.MEMBER_NUMBER DESC) G,
                   DIM_GOOD H
             WHERE G.ITEM_CODE = H.ITEM_CODE
               AND H.CURRENT_FLG = 'Y') LOOP
    V_GOODS_RECOMMEND_TABLE.EXTEND;
    V_GOODS_RECOMMEND_TABLE(V_GOODS_RECOMMEND_TABLE.COUNT) := GOODS_RECOMMEND_ROW(I.TOPN,
                                                                                  I.MEMBER_NUMBER,
																																									I.ITEM_CODE,
                                                                                  I.GOODS_NAME,
                                                                                  I.MATDL,
                                                                                  I.MATDLT,
                                                                                  I.MATZL,
                                                                                  I.MATZLT,
                                                                                  I.MATXL,
                                                                                  I.MATXLT);
  END LOOP;
  RETURN V_GOODS_RECOMMEND_TABLE;
END GET_GOODS_RECOMMEND;
/

