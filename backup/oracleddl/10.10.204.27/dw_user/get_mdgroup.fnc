???create or replace function dw_user.get_mdgroup(itemcode in number) return number is
  groupid number;
begin

  select  nvl(max(group_id),0) into groupid from dim_good where item_code = itemcode and rownum=1;

  return(groupid);

end get_mdgroup;
/

