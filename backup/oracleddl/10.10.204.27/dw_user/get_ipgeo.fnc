???create or replace function dw_user.GET_IPGEO(ipvalue in number) return number is
  resultipgeo number;
begin
  

select a2.ip_geo_key into  resultipgeo from  dim_ip_geo a2 where a2.ip_start<=ipvalue
           and a2.ip_end>=ipvalue;
return(resultipgeo);

end GET_IPGEO;
/

