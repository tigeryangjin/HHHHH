--网上例子
DECLARE
  V_F1 UTL_FILE.FILE_TYPE;
BEGIN
  --外层循环得到内层循环BETWEEN的最小值和最大值
  FOR J IN (SELECT (LEVEL - 1) * 3000 MINVAL, LEVEL * 3000 MAXVAL
              FROM DUAL
            CONNECT BY LEVEL <=
                       (SELECT COUNT(1) FROM ALL_OBJECTS) / 10000 + 1) LOOP
    V_F1 := UTL_FILE.FOPEN('MEMBER_LABEL_OUTPUT',
                           'DATA' || J.MAXVAL || '.TXT',
                           'W');
    --内层循环，获取需要导出的数据
    FOR I IN (SELECT T.OWNER, T.OBJECT_NAME
                FROM (SELECT ALL_OBJECTS.*,
                             ROW_NUMBER() OVER(ORDER BY OBJECT_NAME) RN
                        FROM ALL_OBJECTS) T
               WHERE RN BETWEEN J.MINVAL AND J.MAXVAL) LOOP
      --行数据依次写入文件
      UTL_FILE.PUT_LINE(V_F1, I.OWNER || I.OBJECT_NAME);
    END LOOP;
    UTL_FILE.FCLOSE(V_F1);
  END LOOP;
END;
/

--1.
DECLARE V_F1 UTL_FILE.FILE_TYPE;
BEGIN
  --外层循环得到内层循环BETWEEN的最小值和最大值
  FOR J IN (SELECT COUNT(1) O_ROWS
              FROM MEMBER_LABEL_LINK_V A
             WHERE A.m_label_id = 66) LOOP
    V_F1 := UTL_FILE.FOPEN('MEMBER_LABEL_OUTPUT',
                           'MEMBER_LABEL_LINK_V_' || J.O_ROWS || '.csv',
                           'W');
    --内层循环，获取需要导出的数据
    FOR I IN (SELECT A.member_key,
                     A.m_label_id,
                     A.m_label_type_id,
                     A.m_label_name,
                     A.m_label_desc,
                     A.create_date,
                     A.create_user_id,
                     A.last_update_date,
                     A.last_update_user_id
                FROM MEMBER_LABEL_LINK_V A
               WHERE A.m_label_id = 66) LOOP
      --行数据依次写入文件
      UTL_FILE.PUT_LINE(V_F1,
                        I.member_key || ',' || I.m_label_id || ',' ||
                        I.M_LABEL_TYPE_ID || ',' || I.M_LABEL_NAME || ',' ||
                        I.M_LABEL_DESC || ',' || I.CREATE_DATE || ',' ||
                        I.CREATE_USER_ID || ',' || I.LAST_UPDATE_DATE || ',' ||
                        I.LAST_UPDATE_USER_ID);
    END LOOP;
    UTL_FILE.FCLOSE(V_F1);
  END LOOP;
END;
/

--TMP
  SELECT A.m_label_id, A.m_label_name, A.m_label_desc, COUNT(1)
    FROM MEMBER_LABEL_LINK_V A
   GROUP BY A.m_label_id, A.m_label_name, A.m_label_desc
   ORDER BY 1;
