CREATE OR REPLACE PACKAGE YJTMP IS

  -- AUTHOR  : YANGJIN
  -- CREATED : 2018-05-04 10:07:42
  -- PURPOSE : YANGJIN PACKAGE

  PROCEDURE ORDER_FROM_UPDATE;
  /*
  功能名:       ORDER_FROM_UPDATE
  目的:         
  作者:         yangjin
  创建时间：    2018/05/04
  最后修改人：
  最后更改日期：
  */

  PROCEDURE ODS_ORDER_DEL;
  /*
  功能名:       ODS_ORDER_DEL
  目的:         
  作者:         yangjin
  创建时间：    2018/05/04
  最后修改人：
  最后更改日期：
  */

END YJTMP;
/
CREATE OR REPLACE PACKAGE BODY YJTMP IS

  PROCEDURE ORDER_FROM_UPDATE IS
    /*
    功能说明：
    作者时间：yangjin  2018-04-17
    */
  BEGIN
  
    DECLARE
      TYPE TYPE_RECORD IS RECORD(
        CRM_OBJ_ID VARCHAR2(10));
    
      TYPE TYPE_TABLE IS TABLE OF TYPE_RECORD INDEX BY BINARY_INTEGER; --类似二维数组
    
      VAR_ARRAY TYPE_TABLE;
    BEGIN
      /*逐条取出*/
      SELECT A.CRM_OBJ_ID
        BULK COLLECT
        INTO VAR_ARRAY
        FROM YANGJIN.ORDER_FROM_TMP A
       WHERE A.ZCRMD018 IS NOT NULL
         AND A.IS_UPDATE IS NULL
         AND ROWNUM <= 10000;
    
      FOR I IN 1 .. VAR_ARRAY.COUNT LOOP
        BEGIN
          /*更新*/
          UPDATE FACT_GOODS_SALES A
             SET A.ORDER_FROM =
                 (SELECT C.ZCRMD018
                    FROM YANGJIN.ORDER_FROM_TMP C
                   WHERE A.ORDER_KEY = C.CRM_OBJ_ID)
           WHERE A.ORDER_FROM IS NULL
             AND EXISTS (SELECT 1
                    FROM YANGJIN.ORDER_FROM_TMP D
                   WHERE A.ORDER_KEY = D.CRM_OBJ_ID)
             AND A.ORDER_KEY = VAR_ARRAY(I).CRM_OBJ_ID;
          COMMIT;
        
          UPDATE FACT_ORDER A
             SET A.ORDER_FROM =
                 (SELECT C.ZCRMD018
                    FROM YANGJIN.ORDER_FROM_TMP C
                   WHERE A.ORDER_KEY = C.CRM_OBJ_ID)
           WHERE A.ORDER_FROM IS NULL
             AND EXISTS (SELECT 1
                    FROM YANGJIN.ORDER_FROM_TMP D
                   WHERE A.ORDER_KEY = D.CRM_OBJ_ID)
             AND A.ORDER_KEY = VAR_ARRAY(I).CRM_OBJ_ID;
          COMMIT;
        
          /*更新标志*/
          UPDATE YANGJIN.ORDER_FROM_TMP A
             SET A.IS_UPDATE = 1
           WHERE A.CRM_OBJ_ID = VAR_ARRAY(I).CRM_OBJ_ID;
          COMMIT;
        END;
      END LOOP;
    END;
    /*test20180606*/
  END ORDER_FROM_UPDATE;

  PROCEDURE ODS_ORDER_DEL IS
    /*
    功能说明：
    作者时间：yangjin  2018-04-17
    */
  BEGIN
  
    DECLARE
    
      TYPE TYPE_CRM_ITMGUI IS TABLE OF YANGJIN.ODS_ORDER_DUPLICATE2.CRM_ITMGUI%TYPE;
    
      VAR_CRM_ITMGUI TYPE_CRM_ITMGUI;
    
    BEGIN
      /*逐条取出*/
      SELECT A.CRM_ITMGUI
        BULK COLLECT
        INTO VAR_CRM_ITMGUI
        FROM YANGJIN.ODS_ORDER_DUPLICATE2 A
       WHERE A.IS_DEL IS NULL;
    
      FOR I IN 1 .. VAR_CRM_ITMGUI.COUNT LOOP
        BEGIN
          /*删除*/
          DELETE ODSHAPPIGO.ODS_ORDER A
           WHERE EXISTS
           (SELECT 1
                    FROM (SELECT C.CRM_ITMGUI, C.ZTMSTAMP
                            FROM (SELECT D.CRM_ITMGUI,
                                         D.ZTMSTAMP,
                                         ROW_NUMBER() OVER(PARTITION BY D.CRM_ITMGUI ORDER BY D.ZTMSTAMP) RN
                                    FROM ODSHAPPIGO.ODS_ORDER D
                                   WHERE D.CRM_ITMGUI = VAR_CRM_ITMGUI(I)
                                   ORDER BY D.CRM_ITMGUI, D.ZTMSTAMP) C
                           WHERE C.RN = 1) B
                   WHERE A.CRM_ITMGUI = B.CRM_ITMGUI
                     AND A.ZTMSTAMP = B.ZTMSTAMP);
          COMMIT;
        
          /*更新标志*/
          UPDATE YANGJIN.ODS_ORDER_DUPLICATE2 A
             SET A.IS_DEL = 1
           WHERE A.CRM_ITMGUI = VAR_CRM_ITMGUI(I);
          COMMIT;
        END;
      END LOOP;
    END;
  END ODS_ORDER_DEL;

END YJTMP;
/
