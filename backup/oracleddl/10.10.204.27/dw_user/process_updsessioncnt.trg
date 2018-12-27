???create or replace trigger dw_user.process_updsessioncnt
before update
of mbcnt
on dim_mb_count
referencing old as old_value
new as new_value
for each row
declare
 --XX VARCHAR2(7);

begin

 if
(:new_value.mbcnt>:old_value.mbcnt and :old_value.mbcnt>4)
then

:new_value.MOD_FLAG:=1;
:new_value.MOD_DATE_KEY:=to_number(to_char(sysdate,'yyyymmdd'));
end if;

 if
(:new_value.mbcnt>:old_value.mbcnt and :old_value.mbcnt<=4 and  :new_value.mbcnt>4)
then

:new_value.CHG_FLAG:=1;
:new_value.MODIFY_DATE_KEY:=to_number(to_char(sysdate,'yyyymmdd'));
end if;


end;
/

