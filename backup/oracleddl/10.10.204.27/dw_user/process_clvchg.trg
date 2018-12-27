???create or replace trigger dw_user.process_clvchg
  before update of clv_type, clv_type_w on dim_member
  referencing old as old_value new as new_value
  for each row
declare
  --XX VARCHAR2(7);

begin

  if (:new_value.clv_type != :old_value.clv_type) then
    :new_value.clv_chgdate_key := to_number(to_char(sysdate, 'yyyymmdd'));
  end if;

if (:new_value.clv_type_w != :old_value.clv_type_w) then
    :new_value.clv_chgdate_key := to_number(to_char(sysdate, 'yyyymmdd'));
  end if;

end;
/

