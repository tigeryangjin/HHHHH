/*
ͳһ���һ����Ա���ųأ���ͬ���Ͷ��ŵ���Ŀ��ͳһ�����ųز�����Ҫ���͵ļ�¼����Ҫע��ÿ����¼�����ĸ���Ŀд��ġ�
*/
--OPER_MEMBER_SMS_POOL
/*
row_wid
posting_date_key
project_no
project_desc
member_key
w_insert_dt
w_update_dt
is_send
*/

INSERT INTO OPER_MEMBER_SMS_POOL
  (ROW_WID,
   POSTING_DATE_KEY,
   PROJECT_NAME,
   PROJECT_DESC,
   MEMBER_KEY,
   W_INSERT_DT,
   W_UPDATE_DT,
   IS_SEND)
  SELECT OPER_MEMBER_SMS_POOL_SEQ.NEXTVAL,
         TO_NUMBER(TO_CHAR(A.POST_DATE, 'YYYYMMDD')) POSTING_DATE_KEY,
         'MBLEVEL_DCGOOD' PROJECT_NAME,
         '' PROJECT_DESC,
         A.MEMBER_KEY,
         SYSDATE W_INSERT_DT,
         SYSDATE W_UPDATE_DT,
         0 IS_SEND
    FROM OPER_MEMBER_MBLEVEL_DCGOOD A;
		
		
--tmp
SELECT * FROM W_ETL_LOG;
