--2017-09-27 17:25:22
--2017-09-27 19:39:17
insert into member_label_link
  (member_key,
   m_label_id,
   m_label_type_id,
   create_date,
   create_user_id,
   last_update_date,
   last_update_user_id)
  select a.member_key,
         a.m_label_id,
         a.m_label_type_id,
         a.m_label_effective_begin,
         a.operation_user_id,
         a.m_label_effective_begin,
         a.operation_user_id
    from member_label_log a
   where a.operation_date >=
         to_date('2017-09-27 17:25:22', 'yyyy-mm-dd hh24:mi:ss')
     and a.operation_date <=
         to_date('2017-09-27 19:39:17', 'yyyy-mm-dd hh24:mi:ss')
     and a.m_label_id <> 167
     and not exists
   (select 1
            from member_label_link b
           where a.member_key = b.member_key
             and a.m_label_id = b.m_label_id
             and a.m_label_type_id = b.m_label_type_id);

select distinct a.operation_date
  from member_label_log a
 where a.operation_date >=
       to_date('2017-09-27 17:25:22', 'yyyy-mm-dd hh24:mi:ss')
   and a.operation_date <=
       to_date('2017-09-27 19:39:17', 'yyyy-mm-dd hh24:mi:ss')
   and a.m_label_id <> 167
   and not exists
 (select 1
          from member_label_link b
         where a.member_key = b.member_key
           and a.m_label_id = b.m_label_id
           and a.m_label_type_id = b.m_label_type_id);

SELECT A.START_TIME,
       A.END_TIME,
       A.ETL_DURATION,
       A.ETL_RECORD_INS,
       A.ETL_RECORD_DEL,
       A.ETL_STATUS,
       A.ERR_MSG,
       A.PROC_NAME
  FROM W_ETL_LOG A
 WHERE A.PROC_NAME = 'MEMBER_LABEL_PKG.MEMBER_INJURED_PERIOD'
 ORDER BY A.START_TIME DESC;
