???create or replace function dw_happigo.Get_StrArrayStrOfIndex
(
  av_str varchar2,  --要分割的字符串
  av_split varchar2,  --分隔符号
  av_index number --取第几个元素
)
return varchar2
is
  lv_str varchar2(1024);
  lv_strOfIndex varchar2(1024);
  lv_length number;
begin
  lv_str:=ltrim(rtrim(av_str));
  lv_str:=concat(lv_str,av_split);
  lv_length:=av_index;
  if lv_length=0 then
      lv_strOfIndex:=substr(lv_str,1,instr(lv_str,av_split)-length(av_split));
  else
      lv_length:=av_index+1;
     lv_strOfIndex:=substr(lv_str,instr(lv_str,av_split,1,av_index)+length(av_split),instr(lv_str,av_split,1,lv_length)-instr(lv_str,av_split,1,av_index)-length(av_split));
  end if;
  return  lv_strOfIndex;
end Get_StrArrayStrOfIndex;
/

