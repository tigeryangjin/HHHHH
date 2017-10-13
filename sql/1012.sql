MERGE /*+APPEND*/
    INTO MEMBER_LABEL_LINK T
    USING (SELECT A.ROW_ID,
                  A.MEMBER_KEY,
                  A.M_LABEL_ID,
                  A.M_LABEL_TYPE_ID,
                  A.CREATE_DATE,
                  A.CREATE_USER_ID,
                  A.LAST_UPDATE_DATE,
                  A.LAST_UPDATE_USER_ID
             FROM MEMBER_LABEL_LINK@DW27 A
            WHERE A.ROW_ID IS NOT NULL
              AND TRUNC(A.LAST_UPDATE_DATE) = TRUNC(&IN_SYNC_DATE)) S
    ON (T.ROW_ID = S.ROW_ID)
    WHEN MATCHED THEN
      UPDATE
         SET T.MEMBER_KEY          = S.MEMBER_KEY,
             T.M_LABEL_ID          = S.M_LABEL_ID,
             T.M_LABEL_TYPE_ID     = S.M_LABEL_TYPE_ID,
             T.CREATE_DATE         = S.CREATE_DATE,
             T.CREATE_USER_ID      = S.CREATE_USER_ID,
             T.LAST_UPDATE_DATE    = S.LAST_UPDATE_DATE,
             T.LAST_UPDATE_USER_ID = S.LAST_UPDATE_USER_ID
    WHEN NOT MATCHED THEN
      INSERT
        (T.ROW_ID,
         T.MEMBER_KEY,
         T.M_LABEL_ID,
         T.M_LABEL_TYPE_ID,
         T.CREATE_DATE,
         T.CREATE_USER_ID,
         T.LAST_UPDATE_DATE,
         T.LAST_UPDATE_USER_ID)
      VALUES
        (S.ROW_ID,
         S.MEMBER_KEY,
         S.M_LABEL_ID,
         1,
         SYSDATE,
         'yangjin',
         SYSDATE,
         'yangjin');
