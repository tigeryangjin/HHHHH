CREATE OR REPLACE PACKAGE YJTMP IS

  -- AUTHOR  : YANGJIN
  -- CREATED : 2018-05-04 10:07:42
  -- PURPOSE : YANGJIN PACKAGE

  PROCEDURE ORDER_FROM_UPDATE;
  /*
  ������:       ORDER_FROM_UPDATE
  Ŀ��:         
  ����:         yangjin
  ����ʱ�䣺    2018/05/04
  ����޸��ˣ�
  ���������ڣ�
  */

END YJTMP;
/
CREATE OR REPLACE PACKAGE BODY YJTMP IS

  PROCEDURE ORDER_FROM_UPDATE IS
    /*
    ����˵����
    ����ʱ�䣺yangjin  2018-04-17
    */
  BEGIN
  
    DECLARE
      TYPE TYPE_RECORD IS RECORD(
        CRM_OBJ_ID VARCHAR2(10));
    
      TYPE TYPE_TABLE IS TABLE OF TYPE_RECORD INDEX BY BINARY_INTEGER; --���ƶ�ά���� 
    
      VAR_ARRAY TYPE_TABLE;
    BEGIN
      /*����ȡ��*/
      SELECT A.CRM_OBJ_ID
        BULK COLLECT
        INTO VAR_ARRAY
        FROM YANGJIN.ORDER_FROM_TMP A
       WHERE A.ZCRMD018 IS NOT NULL
         AND A.IS_UPDATE IS NULL
         AND ROWNUM <= 10000;
    
      FOR I IN 1 .. VAR_ARRAY.COUNT LOOP
        BEGIN
          /*����*/
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
        
          /*���±�־*/
          UPDATE YANGJIN.ORDER_FROM_TMP A
             SET A.IS_UPDATE = 1
           WHERE A.CRM_OBJ_ID = VAR_ARRAY(I).CRM_OBJ_ID;
          COMMIT;
        END;
      END LOOP;
    END;
  
  END ORDER_FROM_UPDATE;

END YJTMP;
/