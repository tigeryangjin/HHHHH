SELECT B.POSTING_DATE_KEY POSTING_DATE_KEY, /*日期*/
       B.MATDLT, /*一级分类名称*/
       B.MATZLT, /*二级分类名称*/
       B.MATXLT, /*三级分类名称*/
       B.ITEM_CODE, /*商品编码*/
       B.GOODS_NAME GOOD_NAME, /*商品名称*/
       B.GOODS_PRICE GOOD_S_PRICE, /*商品价格*/
       (SELECT NVL(MAX(D.COST_PRICE), 0)
          FROM FACT_GOODS_SALES D
         WHERE D.POSTING_DATE_KEY = 20180117
           AND B.ITEM_CODE = D.GOODS_COMMON_KEY) GOOD_C_PRICE, /*商品进价*/
       (SELECT E.GROUP_NAME
          FROM DIM_GOOD E
         WHERE B.ITEM_CODE = E.ITEM_CODE
           AND E.CURRENT_FLG = 'Y') GROUP_NAME, /*提报组*/
       NVL((SELECT MAX(1)
             FROM DIM_TV_GOOD F
            WHERE B.ITEM_CODE = F.ITEM_CODE
              AND F.TV_STARTDAY_KEY = 20180117),
           0) IS_ONTV, /*是否当天播出*/
       B.IS_SHIPPING_SELF, /*是否仓配*/
       NVL(L.TV_ORDER_AMOUNT, 0) TV_ORDER_AMOUNT, /*TV销售金额*/
       NVL(L.TV_ORDER_QTY, 0) TV_ORDER_QTY, /*TV销售件数*/
       NVL(A.DS_ORDER_AMOUNT, 0) DS_ORDER_AMOUNT, /*电商销售金额*/
       NVL(A.DS_ORDER_QTY, 0) DS_ORDER_QTY, /*电商销售件数*/
       NVL(A.DS_PROFIT_AMOUNT, 0) PROFIT_AMOUNT, /*电商毛利额*/
       NVL(A.DS_PROFIT_RATE, 0) PROFIT_RATE, /*电商毛利率*/
       NVL(C.PV, 0) PV, /*浏览次数*/
       NVL(C.UV, 0) UV, /*浏览人数*/
       NVL(A.DS_ORDER_MEMBER_COUNT, 0) DS_ORDER_MEMBER_COUNT, /*电商订购人数*/
       DECODE(NVL(C.UV, 0),
              0,
              0,
              ROUND(NVL(A.DS_ORDER_MEMBER_COUNT, 0) / NVL(C.UV, 0), 2)) CONVERSION_RATE, /*转换率*/
       NVL(J.FAV_COUNT, 0) FAV_COUNT, /*收藏次数*/
       NVL(K.CAR_COUNT, 0) CAR_COUNT, /*加购物车次数*/
       NVL(I.LOW_EVAL_COUNT, 0) LOW_EVAL_COUNT, /*差评次数*/
       NVL(I.MED_EVAL_COUNT, 0) MED_EVAL_COUNT, /*中评次数*/
       NVL(I.HIGH_EVAL_COUNT, 0) HIGH_EVAL_COUNT, /*好评次数*/
       NVL(A.DS_REJECT_MEMBER_COUNT, 0) DS_REJECT_MEMBER_COUNT, /*电商拒收人数*/
       NVL(A.DS_REJECT_QTY, 0) DS_REJECT_QTY, /*电商拒收件数*/
       NVL(A.DS_REVERSE_MEMBER_COUNT, 0) DS_REVERSE_MEMBER_COUNT, /*电商退货人数*/
       NVL(A.DS_REVERSE_QTY, 0) DS_REVERSE_QTY /*电商退货件数*/
  FROM (SELECT 20180117 POSTING_DATE_KEY,
               N.ITEM_CODE,
               N.GOODS_NAME,
               N.MATDLT,
               N.MATZLT,
               N.MATXLT,
               N.GOODS_PRICE,
               N.IS_SHIPPING_SELF
          FROM DIM_EC_GOOD N) B,
       OPER_PRODUCT_DAILY_DS_S A,
       OPER_PRODUCT_DAILY_TV_S L,
       OPER_PRODUCT_DAILY_PUV_S C,
       OPER_PRODUCT_DAILY_EVAL_S I,
       OPER_PRODUCT_DAILY_FAV_S J,
       OPER_PRODUCT_DAILY_CAR_S K
 WHERE B.ITEM_CODE = A.ITEM_CODE(+)
   AND B.ITEM_CODE = C.ITEM_CODE(+)
   AND B.ITEM_CODE = I.ITEM_CODE(+)
   AND B.ITEM_CODE = J.ITEM_CODE(+)
   AND B.ITEM_CODE = K.ITEM_CODE(+)
   AND B.ITEM_CODE = L.ITEM_CODE(+)
   AND B.POSTING_DATE_KEY = A.POSTING_DATE_KEY(+)
   AND B.POSTING_DATE_KEY = L.POSTING_DATE_KEY(+)
   AND B.POSTING_DATE_KEY = C.VISIT_DATE_KEY(+)
   AND B.POSTING_DATE_KEY = I.GEVAL_ADDTIME_KEY(+)
   AND B.POSTING_DATE_KEY = J.FAV_TIME(+)
   AND B.POSTING_DATE_KEY = K.CREATE_DATE_KEY(+)
   AND (A.DS_ORDER_QTY <> 0 OR L.TV_ORDER_QTY <> 0 OR C.PV <> 0 OR
       I.LOW_EVAL_COUNT <> 0 OR I.MED_EVAL_COUNT <> 0 OR
       I.HIGH_EVAL_COUNT <> 0 OR J.FAV_COUNT <> 0 OR K.CAR_COUNT <> 0);


SELECT * FROM OPER_PRODUCT_DAILY_PREVIEW;
TRUNCATE TABLE OPER_PRODUCT_DAILY_PREVIEW;

SELECT * FROM OPER_PRODUCT_DAILY_REPORT A WHERE A.POSTING_DATE_KEY=20180123 AND A.ITEM_CODE IS NULL;

SELECT * FROM S_PARAMETERS2 ;
