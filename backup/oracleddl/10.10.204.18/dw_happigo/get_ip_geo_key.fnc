???create or replace function dw_happigo.get_ip_geo_key(ipvalue in varchar2) return number is
 resulttotal number;
 res number;
 resboot number;
 
 --根据IP算出 ip的10进制，并同时返回ip维度的  ip_geo_key值
 --bobo
 
begin
    res:= (substr(ipvalue ,
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
    select ip_geo_key into resulttotal from dim_ip_geo where ip_start<= res and ip_end>=res;
  --  if resboot 
    --  than 
  return(resulttotal);
end get_ip_geo_key;
/

