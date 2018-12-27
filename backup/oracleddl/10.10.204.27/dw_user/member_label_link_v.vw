???CREATE OR REPLACE FORCE VIEW DW_USER.MEMBER_LABEL_LINK_V AS
SELECT a.member_key,
       a.m_label_id,
       a.m_label_type_id,
       b.m_label_name,
       b.m_label_desc,
       a.create_date,
       a.create_user_id,
       a.last_update_date,
       a.last_update_user_id
  from member_label_link a, member_label_head b
 where a.m_label_id = b.m_label_id;

