???CREATE OR REPLACE FORCE VIEW DW_USER.GOODS_LABEL_LINK_V AS
SELECT B.ITEM_CODE,
         C.GOODS_NAME,
         C.MATDL,
         C.MATDLT,
         C.MATZL,
         C.MATZLT,
         C.MATXL,
         C.MATXLT,
         B.G_LABEL_ID,
         B.G_LABEL_TYPE_ID,
         A.G_LABEL_NAME,
         A.G_LABEL_DESC,
         B.CREATE_DATE,
         B.CREATE_USER_ID,
         B.LAST_UPDATE_DATE,
         B.LAST_UPDATE_USER_ID
    FROM GOODS_LABEL_HEAD A, GOODS_LABEL_LINK B, DIM_GOOD C
   WHERE A.G_LABEL_ID = B.G_LABEL_ID
     AND B.ITEM_CODE = C.ITEM_CODE
     AND C.CURRENT_FLG = 'Y';
