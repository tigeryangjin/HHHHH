???CREATE OR REPLACE TYPE DW_USER.GOODS_RECOMMEND_ROW IS object /*RECORD自定义行类型*/
  (
    TOPN          NUMBER, /*排名*/
    MEMBER_NUMBER NUMBER, /*购买人数*/
    ITEM_CODE     NUMBER(10), /*商品编码*/
    GOODS_NAME    VARCHAR2(200), /*商品名称*/
    MATDL         NUMBER(10), /*物料大类编码*/
    MATDLT        VARCHAR2(100), /*物料大类名称*/
    MATZL         NUMBER(10), /*物料中类编码*/
    MATZLT        VARCHAR2(100), /*物料中类名称*/
    MATXL         NUMBER(10), /*物料小类编码*/
    MATXLT        VARCHAR2(100) /*物料小类名称*/)
/

