???create or replace trigger dw_user.process_goods_deletelabel
  before delete on GOODS_LABEL_LINK
  referencing old as old_value
  for each row
declare
  -- local variables here
begin
  insert into GOODS_LABEL_LINK_LOG
  values
    (:old_value.item_code,
     :old_value.g_label_id,
     :old_value.g_label_type_id,
     :old_value.create_date,
     sysdate,
     sysdate,
     :old_value.create_user_id

     );
end process_goods_deletelabel;
/

