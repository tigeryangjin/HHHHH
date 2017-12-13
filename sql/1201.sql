MERGE /*+APPEND*/
INTO (SELECT ROW_ID,
             MEMBER_KEY,
             M_LABEL_ID,
             M_LABEL_TYPE_ID,
             CREATE_DATE,
             CREATE_USER_ID,
             LAST_UPDATE_DATE,
             LAST_UPDATE_USER_ID
        FROM MEMBER_LABEL_LINK
       WHERE M_LABEL_ID BETWEEN 399 AND 401) T
USING (SELECT G.MEMBER_KEY,
              H.M_LABEL_ID,
              H.M_LABEL_TYPE_ID,
              SYSDATE CREATE_DATE,
              'yangjin' CREATE_USER_ID,
              SYSDATE LAST_UPDATE_DATE,
              'yangjin' LAST_UPDATE_USER_ID
         FROM (SELECT B.MEMBER_BP MEMBER_KEY,
                      CASE
                        WHEN B.TASK_TYPE = 1 THEN
                         'WX_IN_7DAYS' /*微信推送*/
                        WHEN B.TASK_TYPE = 2 THEN
                         'SMS_IN_7DAYS' /*短信推送*/
                        WHEN B.TASK_TYPE = 3 THEN
                         'APP_IN_7DAYS' /*APP推送*/
                      END MEMBER_LABEL_NAME
                 FROM (SELECT A.MEMBER_BP, A.TASK_TYPE, MAX(A.CREATE_TIME)
                         FROM PUSH_MSG_LOG A
                        WHERE A.CREATE_TIME >= SYSDATE - 7 /*7天内*/
                          AND A.PUSH_STATE = 10 /*推送成功才打上标签*/
                          AND A.MEMBER_BP IS NOT NULL /*BP号不为空*/
                        GROUP BY A.MEMBER_BP, A.TASK_TYPE) B) G,
              MEMBER_LABEL_HEAD H
        WHERE G.MEMBER_LABEL_NAME = H.M_LABEL_NAME) S
ON (T.MEMBER_KEY = S.MEMBER_KEY AND T.M_LABEL_ID = S.M_LABEL_ID)
WHEN MATCHED THEN
  UPDATE
     SET T.LAST_UPDATE_DATE = SYSDATE, T.LAST_UPDATE_USER_ID = 'yangjin'
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
    (MEMBER_LABEL_LINK_SEQ.NEXTVAL,
     S.MEMBER_KEY,
     S.M_LABEL_ID,
     1,
     SYSDATE,
     'yangjin',
     SYSDATE,
     'yangjin');

DELETE MEMBER_LABEL_LINK A
 WHERE A.M_LABEL_ID BETWEEN 399 AND 401
   AND NOT EXISTS (SELECT 1
          FROM (SELECT C.MEMBER_BP MEMBER_KEY,
                       CASE
                         WHEN C.TASK_TYPE = 1 THEN
                          399
                         WHEN C.TASK_TYPE = 2 THEN
                          400
                         WHEN C.TASK_TYPE = 3 THEN
                          401
                       END M_LABEL_ID
                  FROM PUSH_MSG_LOG C
                 WHERE C.CREATE_TIME >= SYSDATE - 7) B
         WHERE A.MEMBER_KEY = B.MEMBER_KEY
           AND A.M_LABEL_ID = B.M_LABEL_ID);
