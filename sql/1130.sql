SELECT A.MEMBER_BP, A.TASK_TYPE, MAX(A.CREATE_TIME)
  FROM PUSH_MSG_LOG A
 WHERE A.CREATE_TIME >= SYSDATE - 7 /*7����*/
   AND A.PUSH_STATE = 10 /*���ͳɹ��Ŵ��ϱ�ǩ*/
   AND A.MEMBER_BP IS NOT NULL /*BP�Ų�Ϊ��*/
 GROUP BY A.MEMBER_BP, A.TASK_TYPE;

a.page_value = translate(a.page_value,
                         '0' || translate(a.page_value, '#0123456789', '#'),
                         '0');
												 
SELECT A.M_LABEL_ID,COUNT(1) FROM MEMBER_LABEL_LINK A WHERE A.M_LABEL_ID BETWEEN 399 AND 401 GROUP BY A.M_LABEL_ID;
