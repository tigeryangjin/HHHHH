SELECT
  F.ID,
  F.TASK_ID,
  F.TASK_TYPE,
  F.SEND_MEMBER,
  IFNULL(G.MEMBER_BP, H.MEMBER_BP) MEMBER_BP,
  F.PUSH_STATE,
  F.PUSH_MESSAGE,
  F.RESULT_MESSAGE,
  F.CREATE_TIME,
  F.START_TIME,
  F.END_TIME,
  F.PUSH_DELAY,
  F.PUSH_THREAD_ID,
  F.REMARK,
  F.MEMBER_GROUP_ID,
  F.DATA_TYPE,
  F.DATA_OTHER_ID
FROM (
       SELECT
         D.ID,
         D.TASK_ID,
         D.TASK_TYPE,
         D.SEND_MEMBER,
         D.PUSH_STATE,
         D.PUSH_MESSAGE,
         D.RESULT_MESSAGE,
         D.CREATE_TIME,
         D.START_TIME,
         D.END_TIME,
         D.PUSH_DELAY,
         D.PUSH_THREAD_ID,
         D.REMARK,
         D.MEMBER_GROUP_ID,
         E.DATA_TYPE,
         E.DATA_OTHER_ID
       FROM (
              SELECT
                C.ID,
                C.TASK_ID,
                C.TASK_TYPE,
                C.SEND_MEMBER,
                C.PUSH_STATE,
                C.PUSH_MESSAGE,
                C.RESULT_MESSAGE,
                C.CREATE_TIME,
                C.START_TIME,
                C.END_TIME,
                C.PUSH_DELAY,
                C.PUSH_THREAD_ID,
                C.REMARK,
                C.MEMBER_GROUP_ID
              FROM (
                     SELECT
                       A.ID,
                       A.TASK_ID,
                       A.TASK_TYPE,
                       A.SEND_MEMBER,
                       A.PUSH_STATE,
                       A.PUSH_MESSAGE,
                       A.RESULT_MESSAGE,
                       STR_TO_DATE(FROM_UNIXTIME(A.CREATE_TIME, '%Y-%m-%d %H:%i:%s'), '%Y-%m-%d %H:%i:%s') CREATE_TIME,
                       STR_TO_DATE(FROM_UNIXTIME(A.START_TIME, '%Y-%m-%d %H:%i:%s'), '%Y-%m-%d %H:%i:%s')  START_TIME,
                       STR_TO_DATE(FROM_UNIXTIME(A.END_TIME, '%Y-%m-%d %H:%i:%s'), '%Y-%m-%d %H:%i:%s')    END_TIME,
                       A.PUSH_DELAY,
                       A.PUSH_THREAD_ID,
                       A.REMARK,
                       B.MEMBER_GROUP_ID
                     FROM PUSH_MSG_LOG A LEFT JOIN PUSH_TASK_RULE B
                         ON A.TASK_ID = B.ID) C) D LEFT JOIN PUSH_MEMBER_GROUP E
           ON D.MEMBER_GROUP_ID = E.ID) F LEFT JOIN PUSH_MEMBER G
    ON F.MEMBER_GROUP_ID = G.MEMBER_G_ID AND F.SEND_MEMBER = G.MOBILE
  LEFT JOIN MEMBER_FILTER_RESULT H ON F.DATA_OTHER_ID = H.FILTER_ID AND F.SEND_MEMBER = H.MOBILE
WHERE F.ID > ?