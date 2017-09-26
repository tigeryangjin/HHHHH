--1.新建商品标签
begin
  -- Call the procedure
  goods_label_pkg.create_goods_label(in_g_label_name      => 'HOUSE_DECORATION',
                                     in_g_label_desc      => '房屋装修',
                                     in_g_label_type_id   => :in_g_label_type_id,
                                     in_g_label_father_id => :in_g_label_father_id);
end;
/

TRUNCATE TABLE GOODS_LABEL_TMP;
SELECT * FROM GOODS_LABEL_TMP FOR UPDATE;

INSERT INTO GOODS_LABEL_LINK
  (ITEM_CODE,
   G_LABEL_ID,
   G_LABEL_TYPE_ID,
   CREATE_DATE,
   CREATE_USER_ID,
   LAST_UPDATE_DATE,
   LAST_UPDATE_USER_ID)
  SELECT A.ITEM_CODE,
         3 G_LABEL_ID,
         1 G_LABEL_TYPE_ID,
         SYSDATE CREATE_DATE,
         'yangjin' CREATE_USER_ID,
         SYSDATE LAST_UPDATE_DATE,
         'yangjin' LAST_UPDATE_USER_ID
    FROM GOODS_LABEL_TMP A
   ORDER BY A.ITEM_CODE;
COMMIT;

CREATE VIEW GOODS_LABEL_LINK_V AS
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

select * from DIM_GOOD t;
SELECT * FROM MEMBER_LABEL_LINK_V;
