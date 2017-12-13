--1.create table 
--push_msg_log_tmp
--push_msg_log
--task_type'֪ͨ����,1��΢�����ͣ�2���������ͣ�3��APP����' 1:openid  2:mobile 3:memberbp
/*
CREATE TABLE `push_msg_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '��������',
  `task_id` int(11) NOT NULL COMMENT '֪ͨģ��ID',
  `task_type` int(2) NOT NULL COMMENT '֪ͨ����,1��΢�����ͣ�2���������ͣ�3��APP����',
  `send_member` varchar(100) DEFAULT NULL COMMENT '�����û�',
  `push_state` int(2) NOT NULL DEFAULT '0' COMMENT '֪ͨ״̬,0:�����ͣ�5:�����У�10�ɹ���-10ʧ��',
  `push_message` varchar(6300) NOT NULL COMMENT '��������',
  `result_message` varchar(600) DEFAULT NULL COMMENT '���ͽ��',
  `create_time` int(11) NOT NULL COMMENT '���ʱ��',
  `start_time` varchar(15) DEFAULT NULL COMMENT '���Ϳ�ʼʱ��',
  `end_time` varchar(15) DEFAULT NULL COMMENT '���ͽ���ʱ��',
  `push_delay` int(11) DEFAULT NULL COMMENT '�����߳���,����',
  `push_thread_id` int(11) DEFAULT NULL COMMENT '�����߳���',
  `remark` varchar(100) DEFAULT NULL COMMENT '��ע'
);
*/
SELECT * FROM PUSH_MSG_LOG_TMP;
SELECT * FROM PUSH_MSG_LOG;


--2.merge push_msg_log
MERGE /*+APPEND*/
INTO PUSH_MSG_LOG T
USING (SELECT A.ID,
              A.TASK_ID,
              A.TASK_TYPE,
              A.SEND_MEMBER,
              A.PUSH_STATE,
              A.PUSH_MESSAGE,
              A.RESULT_MESSAGE,
              A.CREATE_TIME,
              A.START_TIME,
              A.END_TIME,
              A.PUSH_DELAY,
              A.PUSH_THREAD_ID,
              A.REMARK,
              SYSDATE          W_INSERT_DT,
              SYSDATE          W_UPDATE_DT
         FROM PUSH_MSG_LOG_TMP A) S
ON (T.ID = S.ID)
WHEN MATCHED THEN
  UPDATE
     SET T.TASK_ID        = S.TASK_ID,
         T.TASK_TYPE      = S.TASK_TYPE,
         T.SEND_MEMBER    = S.SEND_MEMBER,
         T.PUSH_STATE     = S.PUSH_STATE,
         T.PUSH_MESSAGE   = S.PUSH_MESSAGE,
         T.RESULT_MESSAGE = S.RESULT_MESSAGE,
         T.CREATE_TIME    = S.CREATE_TIME,
         T.START_TIME     = S.START_TIME,
         T.END_TIME       = S.END_TIME,
         T.PUSH_DELAY     = S.PUSH_DELAY,
         T.PUSH_THREAD_ID = S.PUSH_THREAD_ID,
         T.REMARK         = S.REMARK,
         T.W_UPDATE_DT    = S.W_UPDATE_DT
WHEN NOT MATCHED THEN
  INSERT
    (T.ID,
     T.TASK_ID,
     T.TASK_TYPE,
     T.SEND_MEMBER,
     T.PUSH_STATE,
     T.PUSH_MESSAGE,
     T.RESULT_MESSAGE,
     T.CREATE_TIME,
     T.START_TIME,
     T.END_TIME,
     T.PUSH_DELAY,
     T.PUSH_THREAD_ID,
     T.REMARK,
     T.W_INSERT_DT,
     T.W_UPDATE_DT)
  VALUES
    (S.ID,
     S.TASK_ID,
     S.TASK_TYPE,
     S.SEND_MEMBER,
     S.PUSH_STATE,
     S.PUSH_MESSAGE,
     S.RESULT_MESSAGE,
     S.CREATE_TIME,
     S.START_TIME,
     S.END_TIME,
     S.PUSH_DELAY,
     S.PUSH_THREAD_ID,
     S.REMARK,
     S.W_INSERT_DT,
     S.W_UPDATE_DT);

--3.member label

--4.

--5.

--tmp
SELECT * FROM W_ETL_LOG A WHERE A.PROC_NAME='MEMBER_LABEL_PKG.MERGE_PUSH_MSG_LOG' ORDER BY A.START_TIME DESC;
SELECT * FROM PUSH_MSG_LOG;
SELECT * FROM DIM_MAPPING_MEM A WHERE A.OPEN_ID='oeNKjjnWtCnKYWXlIH_hlIUQYpps';
SELECT A.VID,COUNT(1) FROM DIM_MAPPING_MEM A GROUP BY A.VID HAVING COUNT(1)>1 ORDER BY COUNT(1) DESC;
SELECT A.OPEN_ID,COUNT(1) FROM DIM_MAPPING_MEM A GROUP BY A.OPEN_ID HAVING COUNT(1)>1 ORDER BY COUNT(1) DESC;
SELECT A.OPEN_ID, A.CREATE_DATE_KEY, COUNT(1)
  FROM DIM_MAPPING_MEM A
	WHERE A.OPEN_ID IS NOT NULL
 GROUP BY A.OPEN_ID, A.CREATE_DATE_KEY
HAVING COUNT(1) > 1
 ORDER BY COUNT(1) DESC;
SELECT * FROM DIM_MAPPING_MEM A WHERE A.OPEN_ID='oeNKjji07ApIWri7CaeWz8wU3E7M';
select * from dim_member;

