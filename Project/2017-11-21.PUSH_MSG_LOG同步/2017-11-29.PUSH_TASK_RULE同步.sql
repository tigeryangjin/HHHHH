/*
CREATE TABLE `push_task_rule` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增编码',
  `task_name` varchar(50) DEFAULT NULL COMMENT '任务名称',
  `task_type` int(2) DEFAULT '1' COMMENT '通知类型，1：微信推送，2：短信推送，3：APP推送',
  `add_time` int(11) DEFAULT NULL COMMENT '创建时间',
  `start_time` int(11) DEFAULT NULL COMMENT '发送开始时间',
  `member_group_id` int(11) DEFAULT NULL COMMENT '发送用户组编号，用户组表ID',
  `msg_t_id` int(11) DEFAULT NULL COMMENT '发送模版编号，模版主表ID',
  `msg_content` varchar(6000) DEFAULT NULL COMMENT '通知消息文案,冗余通知字段',
  `task_stauts` varchar(20) DEFAULT NULL COMMENT '-5：停止，-3：创建， -1：待审核，0：待执行，1：用户初始化中5：数据初始化完成，10：发送消息中，15：运行成功, ',
  `run_records` int(11) DEFAULT '0' COMMENT '运行条数',
  `result_records` int(11) DEFAULT '0' COMMENT '成功条数',
  `fail_records` int(11) DEFAULT '0' COMMENT '失败条数',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`),
  KEY `task_type` (`task_type`),
  KEY `task_stauts` (`task_stauts`)
) ENGINE=InnoDB AUTO_INCREMENT=191 DEFAULT CHARSET=utf8 COMMENT='推送任务主表表'
*/

SELECT * FROM PUSH_TASK_RULE_TMP;
SELECT * FROM PUSH_TASK_RULE;

