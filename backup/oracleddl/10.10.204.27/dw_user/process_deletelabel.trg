???create or replace trigger dw_user.process_deletelabel
  before delete on member_label_link
  referencing old as old_value
  for each row
declare
  -- local variables here
begin
  insert into member_label_log
  values
    (:old_value.member_key,
     :old_value.m_label_id,
     :old_value.m_label_type_id,
     :old_value.create_date,
     sysdate,
     sysdate,
     :old_value.create_user_id
     
     );
end process_deletelabel;
/

