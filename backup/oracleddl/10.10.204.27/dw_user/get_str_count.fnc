???create or replace function dw_user.get_str_count(str1 in varchar2) return number is
  str1cnt number;
  str2cnt number;
  strlen  number(30);
  tem     varchar(500);
begin
  strlen  := length(str1);
  str1cnt := 0;
  str2cnt := 0;

  for i in 0 .. strlen loop
  
    tem := substr(str1, i, 1);
  
    if tem = '?'
    then
      str1cnt := str1cnt + 1;
    else
    
      str2cnt := str2cnt + 1;
    end if;
  
  end loop;

  return(str1cnt);

end get_str_count;
/

