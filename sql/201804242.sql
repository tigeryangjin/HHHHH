SELECT * FROM MEMBER_FILTER_OPTION_HEAD;

SELECT MIN(A.FILTER_ID)
  --INTO V_TABLE_HEAD.FILTER_ID
  FROM MEMBER_FILTER_OPTION_HEAD A
 WHERE (A.MEMBER_LABEL_ID_SET IS NOT NULL OR A.ITEM_CODE_SET IS NOT NULL OR
       A.BRAND_SET IS NOT NULL OR A.MATXL_SET IS NOT NULL) /*�����Ա��ǩ����Ʒ���롢Ʒ�ơ�С����붼Ϊ�գ���ִ��*/
   AND A.STATUS = 0;