SELECT * FROM MEMBER_LABEL_HEAD;

SELECT MEMBER_FILTER_PKG.SPLICE_SQL(A.FILTER_ID,
                                     A.MEMBER_LABEL_ID_SET,
                                     A.ITEM_CODE_SET,
                                     A.BRAND_SET,
                                     A.MATXL_SET),
       A.*
  FROM MEMBER_FILTER_OPTION_HEAD A
 WHERE A.FILTER_ID = 88
 ORDER BY A.FILTER_ID DESC;
