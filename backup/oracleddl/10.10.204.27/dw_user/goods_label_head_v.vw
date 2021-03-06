???CREATE OR REPLACE FORCE VIEW DW_USER.GOODS_LABEL_HEAD_V AS
SELECT A.G_LABEL_ID,
       A.G_LABEL_NAME,
       A.G_LABEL_DESC,
       A.G_LABEL_TYPE_ID,
       A.IS_LEAF_NODE,
       A.CREATE_DATE,
       A.CREATE_USER_ID,
       A.LAST_UPDATE_DATE,
       A.LAST_UPDATE_USER_ID,
       A.CURRENT_FLAG,
       A.G_LABEL_FATHER_ID
  FROM DW_USER.GOODS_LABEL_HEAD A;

