???create or replace function dw_happigo.get_ip_number(ipvalue in varchar2) return number is
  resulttotal number;
begin
  
  --先做IP的匹配，如果不是正确的IP地址，直接返回0
  --boob 2016.03.05
   If Regexp_Like(ipvalue, '^((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.){3,3}(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])?$') then  

    resulttotal:= (substr(ipvalue ,
                1,
                (instr(ipvalue , '.', 1, 1 ) - 1))
                * 256 * 256 * 256
        ) +
        (substr(ipvalue ,
                instr(ipvalue , '.', 1, 1 ) + 1,
                instr(ipvalue , '.', 1, 2 ) -
                instr(ipvalue , '.', 1, 1 ) - 1) * 256 * 256
        ) +
        (substr(ipvalue ,
                instr(ipvalue , '.', 1, 2 ) + 1,
                instr(ipvalue , '.', 1, 3 ) -
                instr(ipvalue , '.', 1, 2 ) - 1) * 256
        ) +
        (substr(ipvalue ,
                instr(ipvalue , '.', 1, 3 ) + 1)
        ) ;
   else
     resulttotal:=0;
   end if;
  return(resulttotal);
end get_ip_number;
/

