/*
CREATE TABLE `push_task_rule` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '��������',
  `task_name` varchar(50) DEFAULT NULL COMMENT '��������',
  `task_type` int(2) DEFAULT '1' COMMENT '֪ͨ���ͣ�1��΢�����ͣ�2���������ͣ�3��APP����',
  `add_time` int(11) DEFAULT NULL COMMENT '����ʱ��',
  `start_time` int(11) DEFAULT NULL COMMENT '���Ϳ�ʼʱ��',
  `member_group_id` int(11) DEFAULT NULL COMMENT '�����û����ţ��û����ID',
  `msg_t_id` int(11) DEFAULT NULL COMMENT '����ģ���ţ�ģ������ID',
  `msg_content` varchar(6000) DEFAULT NULL COMMENT '֪ͨ��Ϣ�İ�,����֪ͨ�ֶ�',
  `task_stauts` varchar(20) DEFAULT NULL COMMENT '-5��ֹͣ��-3�������� -1������ˣ�0����ִ�У�1���û���ʼ����5�����ݳ�ʼ����ɣ�10��������Ϣ�У�15�����гɹ�, ',
  `run_records` int(11) DEFAULT '0' COMMENT '��������',
  `result_records` int(11) DEFAULT '0' COMMENT '�ɹ�����',
  `fail_records` int(11) DEFAULT '0' COMMENT 'ʧ������',
  `remark` varchar(500) DEFAULT NULL COMMENT '��ע',
  PRIMARY KEY (`id`),
  KEY `task_type` (`task_type`),
  KEY `task_stauts` (`task_stauts`)
) ENGINE=InnoDB AUTO_INCREMENT=191 DEFAULT CHARSET=utf8 COMMENT='�������������'
*/

SELECT * FROM PUSH_TASK_RULE_TMP;
SELECT * FROM PUSH_TASK_RULE;

